class Hangman
    attr_accessor :word, :level, :misses, :lifes_left, :answer

    def self.game #always use donwcase letters
        puts " WELCOME TO THE HANGMAN ".center(50,"#")
        puts " TO START GAME PRESS 'Y' ".center(50,"#")
        puts " PRESS 'E' TO EXIT THE GAME ".center(50,"#")
        puts " PRESS 'S' TO SAVE THE GAME ".center(50,"#")
        puts " PRESS 'H' TO LOAD THE SAVED GAME ".center(50,"#") 
        puts " PRESS 'R' TO OPEN RULES".center(50,"#")
        input = gets.chomp()
        if input.downcase == 'y'
            player = Hangman.new()
            player.play()
        elsif input.downcase == 'r'
            Hangman.rules
        elsif input.downcase == 'e'
            Kernel.exit(false)
        end

    end

    def self.rules
        puts "U should only use downcase letters;\nu have 6 lifes;\nGOOD LUCK"
    end

    def initialize
        @level = 0
        @misses = []
        @lifes_left = 6
        word_select()
        dash_print()
    end

    def save_game
        #TODO: serialization
    end

    def play 
        hi()

        while true
            if death()
                break
            end

            if win()
                break
            end
            
            puts "Your word is: "
            puts "#{@answer}"
            
            puts "#{@word}"
            
            puts "you have #{@lifes_left} lifes"
            puts "misses: #{@misses}"
            puts "your guess: "
            users = gets.chomp()
            show_word(users)
        end
    end

    private

    def word_select
        lines = File.readlines "./dictionary/words.txt"
        word1 = lines[rand(1...lines.length())]
        loop do 
            word1 = lines[rand(1...lines.length())]
            break if word1.length > 4 && word1.length < 13
        end
        @word = word1
    end

    def show_word(letter)
        
        index = []
        i = 0
        if (!(@word.downcase.include? letter)) # check if it's not in the string
            @lifes_left -= 1
            @misses.push(letter)
        else
            @word.each_char do |char|
                if char.downcase == letter
                    index.push(i)
                end
                i += 1
            end
            puts index
            index.each do |item|
                @answer[item] = @word[item]
            end
        end
    end

    def dash_print
        @answer = ''
        length_answer = @word.length
        i = 0
        while i < length_answer - 2
            @answer += "_"
            i += 1
        end
    end

    def hi
        welcome = "HANGMAN".center(50,"#")
        rules = "U have 6 lifes to find out the word".center(50,"#")
        puts welcome
        puts rules
    end

    def death
        if @lifes_left == 0
            puts "that's it; dont have more lifes"
            puts "it was #{@word}"
            return true
        end
    end

    def win 
        if @answer.include? "_"
            return false
        else
            puts "you did it. u found out the hidden word."
            return true
        end
    end

end

start = Hangman.game()