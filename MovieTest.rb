    #Author Michael Shemesh
    #2/9/2015

class MovieTest

    #loads movie data and tests the first k ratings in the test data
	def initialize(k, moviedata)
        @test_users=moviedata.test_user_list
		@predictions=Array.new
	    i=1
	    while i < k do
	    user=@test_users[i]
	    user.each do |movie, rating|
	    	prediction=moviedata.predict(i,movie)
	    	pred= {user: i, movie: movie, rating: rating, prediction: prediction}
	    	@predictions << pred
	    	end
	    i=i+1
	    end
	end
	

    #this returns the average prediction error
    def mean
        result=0
        @predictions.each do |pred|
        result=result+pred[:prediction]-pred[:rating]
        end
        return result/@predictions.length
    end
    
    
    #stadard deviation of error
    def stddev
        result=0
        @predictions.each do |pred|
        result=result+(pred[:prediction]-pred[:rating])**2
        end
        return (result**0.5)/(@predictions.length-1)
    end
    
    #root mean square error of prediction
    def rms
            result=0
        @predictions.each do |pred|
        result=result+(pred[:prediction]-pred[:rating])**2
        end
        return (result/@predictions.length)**0.5
    end
    
    #returns array of predictions [u,m,r,p]
    def to_a
    	return @predictions
    end
end