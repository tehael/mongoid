require "spec_helper"

describe Mongoid::Document do

  before do
    Foo.delete_all
    3.times do |i|
      Foo.create(:translated_name => { "en" => "EN#{i}", "de" => "DE#{i}" })
    end
  end

  context "finding collection documents" do

    context "with a hash" do

      context "which is complete" do

        context "and matches" do

          before do
            @selector = { :translated_name => { "en" => "EN0", "de" => "DE0" } }
          end

          it "succeeds" do
            criteria = Foo.where(@selector)
            criteria.count.should == 1
            criteria.first.translated_name.should == { "en" => "EN0", "de" => "DE0" }
          end

        end

        context "and does not match" do

          before do
            @selector = { :translated_name => { "en" => "EN666", "de" => "DE666" } }
          end

          it "fails" do
            criteria = Foo.where(@selector)
            criteria.count.should == 0
            criteria.first.should be_nil
          end

        end

      end

    end

    context "with a incomplete hash" do

      before do
        @selector = { :translated_name => { "en" => "EN0" } }
      end

      it "fails" do
        criteria = Foo.where(@selector)
        criteria.count.should == 0
        criteria.first.should be_nil
      end

    end


    context "with a selector using a dot seperated key" do

      context "which matches" do

        before do
          @selector = { 'translated_name.de' => 'DE1'}
        end

        it "succeeds" do
          criteria = Foo.where(@selector)
          criteria.count.should == 1
          criteria.first.translated_name.should == { "en" => "EN1", "de" => "DE1" }
        end

      end

      context "whose key matches but value does not match" do

        before do
          @selector = { 'translated_name.de' => 'DE666'}
        end

        it "fails" do
          criteria = Foo.where(@selector)
          criteria.count.should == 0
          criteria.first.should be_nil
        end

      end

      context "whose key does not match but value does match" do

        before do
          @selector = { 'translated_name.fr' => 'DE1'}
        end

        it "fails" do
          criteria = Foo.where(@selector)
          criteria.count.should == 0
          criteria.first.should be_nil
        end

      end

    end

  end


  context "collection document with embedded documents" do

    before do
      @document = Foo.first
      3.times do |i|
        @document.bars.create(:translated_name => { "en" => "EN#{i}", "de" => "DE#{i}" })
      end
    end

    context "finding root documents" do

      context "with a hash" do

        context "which is complete" do

          context "and matches" do

            before do
              @selector = { :translated_name => { "en" => "EN0", "de" => "DE0" } }
            end

            it "succeeds" do
              criteria = @document.bars.where(@selector)
              criteria.count.should == 1
              criteria.first.translated_name.should == { "en" => "EN0", "de" => "DE0" }
            end

          end

          context "and does not match" do

            before do
              @selector = { :translated_name => { "en" => "EN666", "de" => "DE666" } }
            end

            it "fails" do
              criteria = @document.bars.where(@selector)
              criteria.count.should == 0
              criteria.first.should be_nil
            end

          end

        end

      end

      context "with a incomplete hash" do

        before do
          @selector = { :translated_name => { "en" => "EN0" } }
        end

        it "fails" do
          criteria = @document.bars.where(@selector)
          criteria.count.should == 0
          criteria.first.should be_nil
        end

      end


      context "with a selector using a dot seperated key" do

        context "which matches" do

          before do
            @selector = { 'translated_name.de' => 'DE1'}
          end

          it "succeeds" do
            criteria = @document.bars.where(@selector)
            criteria.count.should == 1
            criteria.first.translated_name.should == { "en" => "EN1", "de" => "DE1" }
          end

        end

        context "whose key matches but value does not match" do

          before do
            @selector = { 'translated_name.de' => 'DE666'}
          end

          it "fails" do
            criteria = @document.bars.where(@selector)
            criteria.count.should == 0
            criteria.first.should be_nil
          end

        end

        context "whose key does not match but value does match" do

          before do
            @selector = { 'translated_name.fr' => 'DE1'}
          end

          it "fails" do
            criteria = @document.bars.where(@selector)
            criteria.count.should == 0
            criteria.first.should be_nil
          end

        end

      end

    end

  end

end