class Failure < ActiveRecord::Base
  unloadable
  belongs_to :acknowledged_user, :class_name => "User", :foreign_key => "acknowledged_user_id"

  before_save :compute_signature

  def short_message
    "#{message}".split("\n").first.sub(Rails.root.to_s, "")
  end

  def compute_signature
    msg = short_message.gsub(/<([A-Z]\w+):0x\w+>/){ "<#{$1}:xxx>" }
    self.signature = "#{name}|#{msg}"
  end

  def acknowledge!
    self.update_attributes(:acknowledged => true,
                           :acknowledged_user_id => User.current.id)
  end
end
