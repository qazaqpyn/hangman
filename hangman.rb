require 'csv'

class Hangman
    attr_accessor :word, :level, :misses, :lifes_left, :answer

    def self.game #always use donwcase letters
        puts " WELCOME TO THE HANGMAN ".center(50,"#")
        puts " TO START GAME PRESS 'S' ".center(50,"#")
        puts " PRESS 'E' TO EXIT THE GAME ".center(50,"#")
        puts " PRESS 'H' TO LOAD THE SAVED GAME ".center(50,"#") 
        puts " PRESS 'R' TO OPEN RULES".center(50,"#")
        input = gets.chomp()
        if input.downcase == 's'
            player = Hangman.new()
            player.play()
        elsif input.downcase == 'r'
            Hangman.rules
        elsif input.downcase == 'e'
            Kernel.exit(false)
        elsif input.downcase == 'h'
            Hangman.load()
        end

    end

    def self.rules
        puts "U should only use downcase letters;\nu have 6 lifes;\nto save the game input 'saveIt'\nGOOD LUCK"
    end

    def initialize(misses=[],lifes_left = 6, w = '', dash = '-')
        @misses = misses
        @lifes_left = lifes_left
        @word = w
        @answer = dash
        if @word == ''
            @word = word_select()
        end
        if @answer == '-'
            @answer = dash_print()
        end
    end

    def play 
        hi()

        while true
            if death() || win()
                again()
            end
            
            puts "Your word is: "
            puts "#{@answer}"
            
            puts "you have #{@lifes_left} lifes"
            puts "misses: #{@misses}"
            puts "your guess: "
            users = gets.chomp()
            show_word(users)
        end
    end

    private

    def self.load 
        puts "history: "
        contents = CSV.open "/Users/pro/Desktop/projects/hangman/history/history.csv", headers: true, header_converters: :symbol
        contents.each do |row|
            situation_life = row[:lifes_left]
            situation_answer = row[:answer] 
            situation_misses = row[:misses]
            number = row[:n]
            puts "Game number: #{number}"
            puts "you have: #{situation_life} lifes left"
            puts "word: #{situation_answer}"
            puts "misses: #{situation_misses}"
        end
        puts "enter number of game u wanna play"
        user_number = gets.chomp()
        content = CSV.open "/Users/pro/Desktop/projects/hangman/history/history.csv", headers: true, header_converters: :symbol
        content.each do |row|
            load_life = row[:lifes_left]
            load_answer = row[:answer] 
            load_misses = row[:misses]
            load_number = row[:n]
            load_word = row[:word]
            if load_number == user_number
                puts "eah"
                player = Hangman.new(load_misses,load_life,load_word,load_answer)
                player.play()
            end
        end

    end

    def word_select
        lines = File.readlines "./dictionary/words.txt"
        word1 = lines[rand(1...lines.length())]
        loop do 
            word1 = lines[rand(1...lines.length())]
            break if word1.length > 4 && word1.length < 13
        end
        return word1[0,word1.length-2]
    end

    def save_game
        n = 0

        lines = File.readlines "/Users/pro/Desktop/projects/hangman/history/history.csv"
        lines.each do |line|
            n+=1
        end

        CSV.open("/Users/pro/Desktop/projects/hangman/history/history.csv", "a+") do |csv|
            csv << ["#{n}","#{@misses}","#{@lifes_left}","#{@word}","#{@answer}"]
        end
    end

    def show_word(letter)
        if letter.downcase == 'saveit'
            save_game()
            Kernel.exit(false)
        end
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
        annswer = ''
        length_answer = @word.length
        i = 0
        while i < length_answer
            annswer += "_"
            i += 1
        end
        return annswer
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
            puts "you did it. u found out the secret word."
            return true
        end
    end
    
    def again
        puts "wanna play again? y/n"
        inputs = gets.chomp()
        if inputs.downcase == 'y' || inputs.downcase == "yes"
            start = Hangman.game()
        else
            Kernel.exit(false)
        end
    end

end

start = Hangman.game()