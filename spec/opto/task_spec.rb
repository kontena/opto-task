require 'spec_helper'

describe Opto::Task do
  it 'has a version number' do
    expect(Opto::Task::VERSION).not_to be nil
  end

  let(:test_task) do
    Object.send(:remove_const, :TestTask) if Object.constants.include?(:TestTask)
    class TestTask
      include Opto.task

      attribute :name, :string
      attribute :age, :integer

      def after
        # expect to be called
      end

      def validate
        if age > 900 && name != "Methusalem"
          add_error :age, :invalid, "You must be methusalem to be that old"
          add_error :age, :invalid, "You must be methusalem to be that old" # doesn't add duplicates
          add_error :age, :invalid, "Becomes an array"
          add_error :age, :invalid, "Adds to the array"
        end
      end

      def perform
        if name == "Benjamin Button"
          add_error :age, :before_birth, 'You went back in' if age == 0
          age - 1
        else
          age + 1
        end
      end
    end
    TestTask
  end

  it 'creates instances' do
    instance = test_task.new(name: 'foo', age: 10)
    expect(instance.name).to eq 'foo'
  end

  it 'runs #after after performing' do
    instance = test_task.new(name: 'before', age: 10)
    expect(instance).to receive(:after).and_return(nil)
    instance.run
  end

  it 'does not perform when not valid' do
    instance = test_task.new(name: 'before', age: nil)
    expect(instance).to receive(:valid?).and_return(false)
    expect(instance).not_to receive(:perform)
    instance.run
  end

  it 'validates' do
    instance = test_task.new(name: 'not_metu', age: 901)
    expect(instance.valid?).to be_falsey
    expect(instance.errors[:age][:invalid].first).to start_with('You must be')
    expect(instance.errors[:age][:invalid].last).to start_with('Adds')
    instance = test_task.new(name: 'Methusalem', age: 901)
    expect(instance.valid?).to be_truthy
  end

  it 'performs when valid' do
    instance = test_task.new(name: 'Jonne', age: 13)
    result = instance.run
    expect(result.success?).to be_truthy
    expect(result.outcome).to eq 14
    instance = test_task.new(name: 'Benjamin Button', age: 31)
    result = instance.run
    expect(result.success?).to be_truthy
    expect(result.outcome).to eq 30
  end

  it 'reports the result as failure if perform adds errors' do
    instance = test_task.new(name: 'Benjamin Button', age: 0)
    result = instance.run
    expect(result.success?).to be_falsey
    expect(result.failure?).to be_truthy
    expect(result.errors[:age][:before_birth]).to start_with('You')
    expect(result.outcome).to be_nil
  end

end
