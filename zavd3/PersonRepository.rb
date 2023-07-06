require 'test/unit'
require_relative 'Person'
require_relative 'PersonRepository'

class PersonRepositoryTest < Test::Unit::TestCase
  def setup
    @repository = PersonRepository.new
    @person1 = Person.new('John', 'Doe', '1980-01-01', '123456789')
    @person2 = Person.new('Jane', 'Doe', '1990-05-15', '987654321')
  end

  def test_add_person
    @repository.add_person(@person1)
    assert_equal([@person1], @repository.people)

    assert_raise(ArgumentError) { @repository.add_person('not a person') }
    assert_raise(PersonAlreadyExist) { @repository.add_person(@person1) }
  end

  def test_edit_person_by_inn
    @repository.add_person(@person1)
    @repository.edit_person_by_inn('123456789', 'Jack', 'Smith', '1985-03-20')
    assert_equal('Jack', @person1.first_name)
    assert_equal('Smith', @person1.last_name)
    assert_equal('1985-03-20', @person1.birth_date)

    assert_raise(PersonNotFoundError) { @repository.edit_person_by_inn('999999999', 'Jack', 'Smith', '1985-03-20') }
  end

  def test_delete_person_by_inn
    @repository.add_person(@person1)
    @repository.add_person(@person2)
    @repository.delete_person_by_inn('123456789')
    assert_equal([@person2], @repository.people)

    assert_raise(PersonNotFoundError) { @repository.delete_person_by_inn('123456789') }
  end

  def test_get_by_inn
    @repository.add_person(@person1)
    assert_equal(@person1, @repository.get_by_inn('123456789'))
    assert_nil(@repository.get_by_inn('999999999'))
  end

  def test_get_by_part_name
    @repository.add_person(@person1)
    @repository.add_person(@person2)
    assert_equal([@person1, @person2], @repository.get_by_part_name('doe'))
    assert_equal([@person2], @repository.get_by_part_name('jane'))
  end

  def test_get_by_date_range
    @repository.add_person(@person1)
    @repository.add_person(@person2)
    assert_equal([@person1], @repository.get_by_date_range(nil, '1985-01-01'))
    assert_equal([@person2], @repository.get_by_date_range('1985-01-01', nil))
    assert_equal([@person1, @person2], @repository.get_by_date_range(nil, nil))
  end
end