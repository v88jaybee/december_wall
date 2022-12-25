class Comment < ApplicationRecord
	include QueryHelper
	
  	belongs_to :message
  	belongs_to :user

	def self.create_comment(comment_params, user_id)
		comment_result = {:status => false, :result => nil, :message => nil}

		if comment_params[:comment_text].present?
			insert_comment_query = ["INSERT INTO comments (user_id, message_id, comment, created_at, updated_at) 
									VALUES (?, ?, ?, NOW(), NOW())", user_id, comment_params[:message_id], comment_params[:comment_text]]

			new_comment = insert_record(insert_comment_query)

			if new_comment.present?
				comment_result[:status] = true
			else
				comment_result[:message] = "Error while creating a new comment. Please try again."
			end
		else  
			comment_result[:message] = "Comment is required"
		end

		return comment_result
	end

	def self.delete_comment(comment_params, user_id)
		comment_result = {:status => false, :result => nil, :message => nil}

		if comment_params[:comment_id].present?
			delete_comment_query = ["DELETE FROM comments WHERE id =? AND user_id =?", comment_params[:comment_id], user_id]
			delete_comment = delete_record(delete_comment_query)

			if delete_comment
				comment_result[:status] = true
			else
				comment_result[:message] = "Error while deleting a comment. Please try again."
			end
		else  
			comment_result[:message] = "Comment ID is required"
		end

		return comment_result
	end

	def self.delete_comment_by_message_id(message_id)
		comment_result = {:status => false, :result => nil, :message => nil}

		delete_comment_query = ["DELETE FROM comments WHERE message_id =?", message_id]
		delete_comment = delete_record(delete_comment_query)

		if delete_comment
			comment_result[:status] = true
		else
			comment_result[:message] = "Error while deleting comments. Please try again."
		end

		return comment_result
	end
end
