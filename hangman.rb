class Hangman
    attr_accessor :word, :level, :misses, :lifes_left, :answer

    def initialize
        @level = 0
        @misses = []
        @lifes_left = 6
        self.word_select
        self.word_print
    end

    def save_game
        #TODO: serialization
    end

    def play 
        
    end

    private

    def word_select
        lines = File.readlines "./dictionary/words.txt"
        word = lines[rand(1...lines.length())]
        loop do 
            word = lines[rand(1...lines.length())]
            break if word.length > 4 && word.length < 13
        end
        @word = word
    end

    def show_word(letter)
        index = []
        if (!(@word.include? letter)) # check if it's not in the string
            @lifes_left -= 1
        else
            @word.each_char do |char|
                if char == letter
                    index.push(@word.index(char))
                end
            end
            index.each do |item|
                @answer[item] = @word[item]
            end
        end
        put @answer
    end

    def word_print
        @answer = ''
        length_answer = @word.length
        i = 0
        while i < length_answer
            @answer += "_"
            i += 1
        end
    end
end