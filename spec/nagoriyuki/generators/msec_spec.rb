require "spec_helper"
require "nagoriyuki/generators/msec"

describe Nagoriyuki::Generators::Msec do
  context "When initialized" do
    subject { described_class.new(options) }

    context "with empty hash" do
      let(:options) { {} }

      it { expect { subject }.to raise_error(ArgumentError) }
    end

    context "with required options" do
      let(:options) { {"length" => 16, "offset_epoch" => (Time.now.to_f * 1000).round } }

      it { is_expected.to be_instance_of(Nagoriyuki::Generators::Msec) }
      its(:length) { is_expected.to eq(options["length"]) }
      its(:offset_epoch) { is_expected.to eq(options["offset_epoch"]) }
    end
  end

  describe "#generate" do
    subject { described_class.new(options).generate }
    let(:length) { 39 }
    let(:offset_epoch) { (Time.parse("2019-01-01 00:00:00").to_f*1000).round }
    let(:options) { {"length" => length, "offset_epoch" => offset_epoch} }

    it { is_expected.to be_instance_of(Fixnum) }
    it { is_expected.to be < 2 ** length }

    context "generate two numbers between 10 millisecond " do
      subject { described_class.new(options) }

      it "numbers difference that generated in interval 10 millisecond should exactly 10" do
        t = Time.parse("2019-01-01 00:00:00")
        first = time_travel_to(t) { subject.generate }
        second = time_travel_to(Time.at(t.to_i, 10000)) { subject.generate }
        expect(second - first).to eq(10)
      end
    end
  end
end
