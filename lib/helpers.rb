use_helper Nanoc::Helpers::Blogging
use_helper Nanoc::Helpers::LinkTo
use_helper Nanoc::Helpers::Rendering

def friendly_date_for(date)
  attribute_to_time(date).strftime("%-d %B %Y")
end

def latest_til
  sorted_tils.first
end

def tils
  blk = -> { @items.select { |item| item[:kind] == 'til' } }
  if @items.frozen?
    @article_items ||= blk.call
  else
    blk.call
  end
end

def article_list
  @items.select { |item| item[:kind] == 'article' }
    .sort_by { |a| attribute_to_time(a[:created_at]) }
    .reverse
end

def sorted_tils
  blk = -> { tils.sort_by { |a| attribute_to_time(a[:created_at]) }.reverse }
  if @items.frozen?
    @sorted_til_items ||= blk.call
  else
    blk.call
  end
end

def title_tag item
  if item[:title]
    "#{item[:title]} &middot; Sam Starling"
  else
    "Sam Starling"
  end
end

def nav_class path
  if @item.path == path
    "black-60" 
  else
    "black-20"
  end
end