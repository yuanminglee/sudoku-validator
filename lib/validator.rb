class Validator
  SUBGROUP_INDEXES = [0..2, 3..5, 6..8].freeze

  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    convert_to_puzzle

    if rows_valid? && columns_valid? && subgroups_valid?
      if complete?
        'This sudoku is valid.'
      else
        'This sudoku is valid, but incomplete.'
      end
    else
      'This sudoku is invalid.'
    end
  end

  private

  def convert_to_puzzle
    puzzle_with_divider = @puzzle_string.split("\n").map do |row|
      row.gsub('|', '').split(' ').map(&:to_i)
    end
    @puzzle = puzzle_with_divider.reject { |row| row.size < 9 }
  end

  def rows_valid?
    validate_unit(@puzzle)
  end

  def columns_valid?
    columns = @puzzle.transpose
    validate_unit(columns)
  end

  def subgroups_valid?
    subgroups = []
    SUBGROUP_INDEXES.each do |e|
      SUBGROUP_INDEXES.each do |e1|
        subgroups << @puzzle.slice(e).map { |row| row.slice(e1) }.flatten
      end
    end
    validate_unit(subgroups)
  end

  def validate_unit(puzzle)
    puzzle_without_zeros = puzzle.map { |unit| unit.select(&:positive?) }
    puzzle_without_zeros.all? { |unit| unit.size == unit.uniq.size }
  end

  def complete?
    !@puzzle.flatten.include?(0)
  end
end
