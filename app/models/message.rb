class Message < ApplicationRecord
	include QueryHelper
	
  	belongs_to :user

	def self.fetch_all_message_comments
		fetch_message_query = ["SELECT messages.id as message_id, messages.user_id, messages.message, concat(users.first_name, ' ', users.last_name) as author_message, messages.created_at,
			CASE WHEN comments.id IS NULL THEN '[]'
			ELSE
				JSON_ARRAYAGG(
					JSON_OBJECT(
						'comment_id', comments.id,
						'comment_user_id', comments.user_id,
						'message_id', comments.message_id,
						'comment', comments.comment,
						'created_at', comments.created_at,
						'author_comment', concat(comment_user.first_name, ' ', comment_user.last_name)
					)
				)
			END as user_comments
		FROM messages
		INNER JOIN users ON users.id = messages.user_id
		LEFT JOIN comments ON comments.message_id = messages.id
		LEFT JOIN users as comment_user ON comment_user.id = comments.user_id
		GROUP BY messages.id"]

		return query_records(fetch_message_query)
	end

	def self.create_message(message_params, user_id)
		message_result = {:status => false, :result => nil, :message => nil}

		if message_params[:message_text].present?
			insert_message_query = ["INSERT INTO messages (user_id, message, created_at, updated_at) 
									VALUES (?, ?, NOW(), NOW())", user_id, message_params[:message_text]]

			new_message = insert_record(insert_message_query)

			if new_message.present?
				message_result[:status] = true
			else
				message_result[:message] = "Error while creating a new message. Please try again."
			end
		else  
			message_result[:message] = "Message is required"
		end

		return message_result
	end

	def self.delete_message(message_params, user_id)
		message_result = {:status => false, :result => nil, :message => nil}

		if message_params[:message_id].present?
			delete_message_query = ["DELETE FROM messages WHERE id =? AND user_id =?", message_params[:message_id], user_id]
			delete_message = delete_record(delete_message_query)

			if delete_message
				#delete all comments connected to the message
				Comment.delete_comment_by_message_id(message_params[:message_id])
				message_result[:status] = true
			else
				message_result[:message] = "Error while deleting a message. Please try again."
			end
		else  
			message_result[:message] = "Message ID is required"
		end

		return message_result
	end
end
