use_helper Nanoc::Helpers::Blogging
use_helper Nanoc::Helpers::LinkTo
use_helper Nanoc::Helpers::Rendering

def friendly_date_for(post)
  attribute_to_time(post[:created_at]).strftime("%-d %B %Y")
end
