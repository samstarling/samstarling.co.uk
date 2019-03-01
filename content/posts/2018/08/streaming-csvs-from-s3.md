---
title: Streaming large CSVs from S3
created_at: 2018-08-18 00:00:00
kind: article
---

One of my current projects involves ingesting large amounts of data from CSV files (~60GB each) into a Postgres database. With a smaller file, you could iterate over each line, and do something with it:

<pre class="code ba pv2 ph3 f6 f5-ns b--black-20 black-60"><code>#!ruby
CSV.read('data.csv') do |row|
  do_something(row)
end
</code></pre>

This is where we hit our first problem: `CSV.read` will read everything into memory before it starts iterating. If you don't have enough memory, then that might not be a good idea. Switch to use `CSV.foreach`, and _thing will happen_.

<!-- TODO: Benchmarking -->

[Good blog post here][goodblog].

What if the CSV file you need to process doesn't fit on your laptop? One option is to spin up an EC2 instance (or similar) and process the files there. That worked, but I was keen to see if I could process the files locally – that way I could use tools and editors I had at hand on my laptop.

One big advantage I had was that the files I had to process were already in S3. This meant I could perform range requests against the files, and this felt like a good way forward.

Here's some pseudocode:

<pre class="code ba pv2 ph3 f6 f5-ns b--black-20 black-60"><code>#!ruby
def fetch_range(start, chunk_size)
  content = s3.range(start, start + chunk_size)
  last_newline = # todo
  csv = yield(content[0..last_newline])
  fetch_range(last_newline, chunk_size)
end

fetch_range(0, 10_000) do |content|
  CSV.parse(content)
end
</code></pre>

[goodblog]: https://dalibornasevic.com/posts/68-processing-large-csv-files-with-ruby
