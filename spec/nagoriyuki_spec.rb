require "spec_helper"

describe Nagoriyuki do
  it "has a version number" do
    expect(Nagoriyuki::VERSION).not_to be nil
  end

  context "when initialized" do
    subject { Nagoriyuki.new(options) }

    context "with empty generators" do
      let(:options) { {"generators" => []} }
      its(:generators) { is_expected.to be_empty }
    end

    context "with generators" do
      let(:options) {
        {
          "generators" => [
            {"name" => "msec", "length" => 39, "offset_epoch" => 1396278000000},
            {"name" => "pid", "length" => 16},
            {"name" => "sequence", "length" => 9}
          ]
        }
      }
      it { expect(subject.generators.size).to eq(options["generators"].size) }
      its(:generators) {
        is_expected.to contain_exactly(
          be_kind_of(Nagoriyuki::Generators::Msec),
          be_kind_of(Nagoriyuki::Generators::Pid),
          be_kind_of(Nagoriyuki::Generators::Sequence)
        )
      }

      describe "#generate" do
        let(:nagoriyuki) { described_class.new(options) }
        subject { nagoriyuki.generate }
        it { is_expected.to be_kind_of(Integer) }
        it { is_expected.to be < 2 ** nagoriyuki.length }
      end

      describe "#length" do
        subject { described_class.new(options).length }
        it { is_expected.to eq(options["generators"].map { |h| h["length"]}.inject(:+)) }
      end

      describe "#timestamp" do
        let(:nagoriyuki) { described_class.new(options) }

        it {
          t = Time.parse("2019-01-01 00:00:00")
          id = time_travel_to(t) { nagoriyuki.generate }
          timestamp = time_travel_to(t) { nagoriyuki.timestamp(id) }
          expect(timestamp).to eq(t.to_i)
        }
      end
    end
  end
end
