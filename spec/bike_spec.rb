require 'rspec'
require_relative 'bike'

RSpec::Matchers.define :be_a_warning do
  match do |actual|
    actual.start_with?("WARNING:") && actual.end_with?("!")
  end
end

# describe "warning" do
#   subject(:warning) { "WARN -- Something is messed up." }
#   it { is_expected.to start_with("WARNING:") }
#   it { is_expected.to end_with "!" }

#   it "passes our validations", aggregate_failures: true do
#     expect(warning).to start_with("WARNING:")
#     expect(warning).to end_with("!")
#   end

#   it { is_expected.to start_with("WARNING:").and end_with("!") }
# end


describe Bike do
  shared_examples :shift_gear do ||
  end

  RSpec::Matchers.define :shift_gear_of do |bike|
    match do |actual|
      @delta ||= 1
      @direction ||= nil

      @previous_gear = bike.gear

      actual.call

      @actual_delta = bike.gear - @previous_gear
      @actual_delta == @delta
    end

    chain :by, :delta

    description do
      case @direction
      when :up
        "shift gear up #{@delta}"
      when :down
        "shift gear down #{- @delta}"
      else
        "shift gear by #{@delta}"
      end
    end

    failure_message do
      actual_direction = @actual_delta > 0 ? :up : :down

      ["expected block to #{description}",
       "but shifted #{actual_direction} #{@actual_delta.abs}"].join(", ")
    end

    chain :up do |delta|
      @direction = :up
      @delta = delta
    end

    chain :down do |delta|
      @direction = :down
      @delta = - delta
    end

    supports_block_expectations
  end

  shared_context "in highest gear" do
    let(:bike) { described_class.new(gear: Bike::MAX_GEAR) }
  end

  describe "#shift_up" do
    subject(:shift_up) { bike.shift_up }

    context "when in the highest gear" do
      include_context "in highest gear"

      it { expect { shift_up }.not_to change(bike, :gear) }
    end

    context "when not in the highest gear" do
      let(:bike) { described_class.new(gear: Bike::MIN_GEAR) }

      it "shifts up one gear" do
        shift_up
        expect(bike.gear).to eq Bike::MIN_GEAR + 1
      end

      it "shifts up one gear" do
        expect { shift_up }.to change(bike, :gear).by(1)
      end

      specify { expect { shift_up }.to shift_gear_of(bike).by(1) }
      specify { expect { shift_up }.to shift_gear_of(bike).up(1) }
      specify { expect { shift_up }.to shift_gear_of(bike).down(1) }

      specify { expect { shift_up }.to change(bike, :gear).by(1) }

      # context "as a block" do
      #   subject { -> { bike.shift_up } }

      #   specify "called multiple times changes gear each time" do
      #     is_expected.to change(bike, :gear).by(1)
      #     is_expected.to change(bike, :gear).by(1)
      #     is_expected.to change(bike, :gear).by(1)
      #     is_expected.to change(bike, :gear).by(1)
      #     # expect { shift_up }.to change(bike, :gear).by(1)
      #     # expect { shift_up }.to change(bike, :gear).by(1)
      #     # expect { shift_up }.to change(bike, :gear).by(1)
      #   end
      # end
    end
  end

  describe "#shift_down"
end
