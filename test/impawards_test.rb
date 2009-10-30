require 'test_helper'

class ImpawardsTest < Test::Unit::TestCase
  context "IMPAwards" do
    
    context "searching for posters by title" do
      setup do
        @results = IMPAwards::IMPAwards.search_posters("K-11")
      end
      
      should "return an array" do
        assert_equal Array, @results.class
      end
    
      should "return an array of hashes" do
        assert_equal Hash, @results.first.class
      end
      
      context "returned poster" do
        setup do
          @result = @results.first
        end
    
        should "have 3 sizes" do
          assert_equal 3, @result.keys.size
        end
    
        should "have xlg url" do
          assert_match /http.*xlg/, @result[:xlg]
        end
    
        should "have thumb url" do
          assert_match /http.*/, @result[:thumb]
        end
    
        should "have tiny url" do
          assert_match /http.*/, @result[:tiny]
        end
    
      end
    end

    context "GETTING for posters for exact title" do
      
      context "with good result" do
        setup do
          @results = IMPAwards::IMPAwards.get_posters("The Dark Knight")
        end
        
        should "return an array" do
          assert_equal Array, @results.class
        end
      
        should "return an array of hashes" do
          assert_equal Hash, @results.first.class
        end
      
        context "returned poster" do
          setup do
            @result = @results.first
          end
      
          should "have 3 sizes" do
            assert_equal 3, @result.keys.size
          end
      
          should "have xlg url" do
            assert_match /http.*xlg/, @result[:xlg]
          end
      
          should "have thumb url" do
            assert_match /http.*/, @result[:thumb]
          end
      
          should "have tiny url" do
            assert_match /http.*/, @result[:tiny]
          end
      
        end
      end
      
      context "with bad results" do
        setup do
          @results = IMPAwards::IMPAwards.get_posters("k-11")
        end
        
        should "return an array" do
          assert_equal Array, @results.class
        end

        should "return an empty array" do
          assert @results.empty?
        end

      end
      

    end
    
    
  end
end
