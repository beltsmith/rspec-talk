require 'rspec'
require_relative 'bike'

describe Bike do
  describe "#shift_up" do
    subject(:shift_up) { bike.shift_up }

    context "when in highest gear" do
      let(:bike) { described_class.new(gear: Bike::MAX_GEAR) }

      it { expect { shift_up }.not_to change(bike, :gear) }
    end

    context "when not in highest gear" do
      let(:bike) { described_class.new(gear: Bike::MIN_GEAR) }

      it do
        expect { shift_up }.to change(bike, :gear).by(1)
        expect { shift_up }.to change(bike, :gear).by(1)
        expect { shift_up }.to change(bike, :gear).by(1)
      end
    end
  end

  describe "#shift_down"
end
