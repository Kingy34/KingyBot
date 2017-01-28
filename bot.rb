require 'discordrb'
require 'fileutils'
require 'rqrcode'

bot = Discordrb::Commands::CommandBot.new token: 'TOKEN HERE', client_id: CLIENTIDHERE, prefix: 'k-'

# Pings to see if the bot is alive

bot.command :ping do |event|
  event << 'Pong!'

# BOT OWNER COMMANDS

# Change the game the bot is playing

bot.command(:game, description: 'Set the "Playing" status. Admin only.') do |event, *game|
    unless event.user.id == YOURID
           event.respond("Oh, sure BO- WAIT A SECOND! >:^(")
                break
              end
            event.bot.game = game.join(' ')
            event.respond("Game set to `#{game.join(' ')}`!")
end

#Kills the bot when entered by the bot owner

bot.command(:exit, help_available: false) do |event|
  # This is a check that only allows a user with a specific ID to execute this command. Otherwise, everyone would be
  # able to shut your bot down whenever they wanted.
  break unless event.user.id == YOURID  # Replace number with your ID

  bot.send_message(event.channel.id, 'Goodbye!')
  exit
end

# Moderation commands

# Prune (Currently after testing, only works for itself)

bot.command(:prune, required_permissions: [:manage_messages], max_args: 1) do |event, num|
            begin
                num = 50 if num.nil?
                count = 0
                event.channel.history(num).each do |x|
                    if x.author.id == event.bot.profile.id
                        x.delete
                        count += 1
                    end
                end
                message = event.respond("deleted #{count} messages!")
                sleep(10)
                message.delete
                event.message.delete
            rescue Discordrb::Errors::NoPermission
                event.channel.send_message("I have no permission!")
                puts 'The bot does not have the delete message permission!'
            end
end

#
=begin
OTHER COMMANDS
=end

# Time for LMGTFY!

bot.command(:lmgtfy, min_args: 1, description: 'Generates Let Me Goole That For You link.', usage: 'lmgtfy <text>') do |event, *text|
        "http://lmgtfy.com/?q=#{text.join('+')}"
      end

bot.command(:google, min_args: 1, description: 'Generates a Google search for you', usage: 'google <text>') do |event, *text|
        "https://www.google.de/search?q=+#{text.join('+')}"
      end

	bot.command(:invite) do |event|
      	    "Invite Kingy's lost twin to your server here: https://discordapp.com/oauth2/authorize?&client_id=YOURCLIENTID&scope=bot&permissions=12659727"
    	end

# Info command

        bot.command(:info, description: 'Displays info about a user.') do |event, mention|
            event.channel.start_typing
            if event.channel.private? # This is so that the bot doesn't let you run this in PMs.
                event << "❌ This command can only be used in a server."
                next
            end

            if mention.nil?
              user = event.user
            elsif event.message.mentions[0]
              user = event.server.member(event.message.mentions[0])
            else
              user = event.user
            end

            user = event.message.mentions[0]
            playing = if user.game.nil?
                          '[N/A]'
                      else
                          user.game
                      end
            member = user.on(event.server)
            nick = if member.nickname.nil?
                       '[N/A]' 
                   else
                       member.nickname
                   end
            event << "👥  Infomation about **#{member.display_name}**"
            event << "-ID: **#{user.id}**"
            event << "-Username: `#{user.distinct}`"
            event << "-Nickname: **#{nick}**"
            event << "-Status: **#{user.status}**"
            event << "-Playing: **#{playing}**"
            event << "-Account created: **#{user.creation_time.getutc.asctime}** UTC"
            event << "-Joined server at: **#{member.joined_at.getutc.asctime}** UTC"
end

#Generates QR codes

        bot.command(:qr, description: 'Returns a QR code of an input.', min_args: 1) do |event, *text|
            event.channel.start_typing
            tmp_path = "#{Dir.pwd}/tmp/qr.png"
				    content = text.join(" ")
				    # Limits and the work
    				if content.length >= 1000
    					event.respond("That's way too much charaters. You went over by #{content.length - 1000}!")
    					break
    				end
    				qrcode = RQRCode::QRCode.new(content)
    				FileUtils.mkdir("#{Dir.pwd}/tmp/") unless File.exist?("#{Dir.pwd}/tmp/")
    				FileUtils.rm(tmp_path) if File.exist?(tmp_path)
    				png = qrcode.as_png(
              file: tmp_path # path to write
            )
    				event.channel.send_file(File.new(tmp_path), caption: "Here's your QR code:")
end

# Fun commands

bot.command(:ys) do |event|
  event.respond 'https://www.youtube.com/watch?v=ByC8sRdL-Ro'

  # posts a nice song :^)
end

bot.command(:fc) do |event|
  event.user.pm('This is KFC, how may we take your order?')
end

bot.command(:crash) do |event|
  event.respond 'no u'
end

bot.command(:lenny) do |event|
  event.respond '( ͡° ͜ʖ ͡°)'
end

bot.command(:say, description: 'Speak, KingyBot, Speak!') do |event, *text|
event.message.delete
            event.respond("#{text.join(' ')}")

end

bot.command(:imsexy, description: 'Command by smileyhead', usage: 'k-imsexy') do |event, *text|
        "https://cdn.discordapp.com/attachments/209772758081470464/273180064764526592/but_nobody_came_1___undertale_by_dragonitearmy-d9nc9ef.png"
      end

# DISABLED COMMANDS

# This spams stuff. Please, this is disabled because it spams, obviously. Uncomment if you want it.
=begin

        bot.command(:spam, required_permissions: [:administrator], description: 'Spam a message. Admin only.', usage: '&spam num text') do |event, num, *text|
            puts "#{event.author.distinct}: \`#{event.message.content}\`"
            if num.nil?
                event.respond('What the fuck, spam less than one times? You are crazy, man! (Or I am an idiot... Yeah, possibly the latter)')
                break
            end

            if !/\A\d+\z/.match(num)
                event.respond("`#{num}` is not a possible number, peasant!")
                break
            else num == 0
                 event.respond("What, h-how can I spam 0 times?")
            end

            num = num.to_i

            while num > 0
                event.respond(text.join(' ').to_s)
                num -= 1
            end
end
=end


