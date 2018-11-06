---
title: Generically-typed React components
created_at: 2018-11-03 00:00:00
kind: article
---

I've been using React a lot on some recent projects, and enjoying it. The surrounding community and range of libraries on offer is (unsurprisingly) great, and if you're building a common component then it's often easy to find a well-documented open source version of what you're about to build.

One tool I can no longer live without is [Flow][flow], a static type checker. It helps me spot errors with passing objects that might be incompatible, accessing variables that might not exist, and a whole host of other common pitfalls.

This weekend, I've been playing around with writing generically-typed components, that is: components where the type definition takes a parameter that is also a type. One of the most obvious examples is a list, so I'll use that as an example.

### The types

By using a type parameter, <code>&lt;T&gt;</code>, we can define a type that takes an array of items, and a method that renders a single item. At the moment, think of `T` as a placeholder: we'll fill it in later.

<pre class="code ba pv2 ph3 f6 f5-ns b--black-20 black-60"><code>#!javascript
// @flow
import * as React from 'react';

type Props&lt;T&gt; = {
  items: Array&lt;T&gt;,
  renderItem: &lt;T&gt;(item: T) =&gt; React.Node,
};
</code></pre>

### The component

Here, we're making a component that takes props of type <code>Props&lt;T&gt;</code>. It doesn't do anything too clever: it renders the items by calling `map` with our `renderItem` property:

<pre class="code ba pv2 ph3 f6 f5-ns b--black-20 black-60"><code>#!javascript
class List&lt;T&gt; extends React.Component&lt;Props&lt;T&gt;&gt; {
  renderItem = &lt;T&gt;(item: T) = {
    return &lt;li&gt;{this.props.renderItem(item)}&lt;/li&gt;
  };

  render() {
    return this.props.items.map(this.renderItem);
  }
}
</code></pre>

### Using the component

Once we've defined our generic `List` component, we can extend it, and define a class that fills in the `T` with a specific type. In this case, we'll make a list of `TodoItem` objects:

<pre class="code ba pv2 ph3 f6 f5-ns b--black-20 black-60"><code>#!javascript
type TodoItem = {
  isCompleted: boolean,
  dueDate: date,
  description: string
}

export class TaskList extends List&lt;TodoItem&gt; {}
</code></pre>

We're then free to use <code>&lt;TodoItem /&gt;</code>, and Flow will complain if the items aren't of the correct type, or if the `renderItem` method doesn't take (or return) the types it should.

Think of this like a contract: given a type `T`, and a function <code>(item: T) =&gt; React.Node</code>, we can render a list of _anything_, and Flow will type check it.

And that's it. I've written lists, tables, typeahead searches and more, and doing so has felt pleasant.

<div class="black-50">One small footnote: I've noticed this breaks my syntax highlighting in VSCode a little, when I annotate functions with types before the parameters. If anyone knows a good fix, let me know.</div>

[flow]: https://flow.org
