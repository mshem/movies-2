
#Author: Michael Shemesh
	# 2/9/2015
	# Movie Data http://cosi105-2015.s3-website-us-west-2.amazonaws.com/content/topics/pa/pa_movies_2/

class MovieData

	require './MovieTest.rb'
	#initializes with default parameter name=nil. this will load data from the directory specified if there is a u.data file there.
		#if name is specified, then two sets of data will be compared in that directory as name.base and name.test
	def initialize(path, name=nil)
		
		@movies=Hash.new
		@users=Hash.new
		if name!=nil


		base = path+"/"+name+".base"
		test =path+"/"+name+".test"
		load_test_data(base, test, @movies, @users)

		else
			path=path+"/u.data"
		load_data(path, @movies, @users)

		end



	end

	#loads data into base and test hashe instance variables
	def load_test_data(base, test, movies, users)
		
		@test_movies=Hash.new
		@test_users=Hash.new

		load_data(base,movies,users)
		load_data(test,@test_movies,@test_users)

	    

	end

	#loads data by default
	def load_data(path, movies, users)
		
	# usually u.data in the ml-100k directory
	    txt= open(path)
	    while line = txt.gets do

	        rev=review(line)

	        mov = rev[:movie]
	          user = rev[:user]
	          rating=rev[:rating]
	        if movies.has_key?(mov)
		      viewers =  movies[mov]
	          viewers << user
	          movies[mov]=viewers
	        else
	        	viewers=[user] 
	        	movies[mov]=viewers
	        end
	        

	        if users.has_key?(user)
						u=users.fetch(user)
						u[mov]=rating
						users[user]=u        
	        else 
				u= {} 
				u[mov]=rating
				users[user]=u
	        
	        end

	        
	    end

	end


	#makes a four entry hash out of a string 
	def review(arg)
	
	    r = arg.split(' ')
	    rev = {user: r[0].to_i, movie:r[1].to_i, rating:r[2].to_i, timestamp: r[3].to_i}
	    return rev
	end

	#popularity takes in a movie id and returns its popularity: popularity=total number of ratings
	def popularity(movie_id)
		users =	@movies[movie_id.to_i]
	    return users.length
	end

	    	#popularity_list will take the data and generate a list of the movies ordered by most popular to least popular. 
		#we should have a list of movies and the users who rated them. returns a hash of each movie and how many users have rated it.
	def popularity_list()
     poplist = {}
	        @movies.each do |movie, users|
			poplist[movie]=popularity(movie)
			end
	        return poplist
	end

		#similarity generates a number that represents how similar two user's preferences are
		def similarity(user1, user2)
			#max similarity is 1, min is 0
			u1=@users[user1] #get the movie ratings of each user
			u2=@users[user2]	#get each users movie ratings
			dif=0
			com=0
		
		
			u1.each do |movie1, rating1|
				if u2.has_key? movie1
					com = com+1 #if theyve seen the same movie, increase similarity
					dif=dif+1-((rating1-u2[movie1]).abs)/4  #if theyre ratings are completely different then add 1, if they are the same, add 0
				else
				end
			end
			
			if com != 0
				return dif/com
			else
				return 0
			end
		end

				#most_similar returns a list of users and their similarity to the specified user
		def most_similar(user, users=nil)
			if users!=nil

				user_list=users
			else

			user_list=@users
		end
		res=Hash.new
		user_list.each do |key, value|
			if key==user
			else
			s=similarity(user, key)
			res.store(key, s)
			end
			end
		
		result = res.sort_by{|k,v| v}.reverse
	        return result
	    

		end



	    	#returns the rating that user u gave movie m in the training set, and 0 if user u did not rate movie m
	    def rating(user, movie)

	        u=@users[user]
	        if u == nil
	        	return 0

	        else

	        return u[movie]
	    end
	    end

	    	#returns a floating point number between 1.0 and 5.0 as an estimate of what user u would rate movie m
	   		#we need to look at the users who have rated this movie
	    	#and determine their similarity to the current user
	    	#then aggregate those into a prediction
	    def predict(user, movie)

	    	users=viewers(movie)
	    	
	    	
	    	#if no one has seen the movie return a random number
	    	if users==nil
	    		return 1+rand(5)
	    	else
	    		#otherwise return the average rating
	    		return average_rating(users,movie)

	   		 end
	    end

	    def average_rating(users, movie)
	    	#this method finds the average rating for the given users and movie
	    	result=0
	    	inc=0
	    	users.each do |k,v|
	    		if v.has_key? movie
	    			result=result+v[movie]
	    			inc=inc+1
	    		end
	    	end

	    	if inc==0
	    		return 1+rand(5)
	    	else
	    		return result/inc
	    	end

	    end
	    
	    #returns the array of movies that user u has watched
	    def movies(user)
	        u= @users[user]
	        return u.keys
	    end
	    
	    #returns the users that have seen movie
	    def viewers(movie)

	    	userarray=@movies[movie.to_i]
	    	users=@users.select {|k,v| userarray.include? k} 
	        return users
	    end
	    
	    #runs z.predict method on the first k ratings in the test set and returns a MovieTest object containing the results
	    def run_test(k)
	    
	    	mt =MovieTest.new(k, self)
	    	return mt
        end
        
        #returns the users
        def user_list
        return @users
        
		end
		
		#returns the test users
	 def test_user_list
     return @test_users
        
	end
		
		
    end    
