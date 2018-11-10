---
title: Generically-typed React components
created_at: 2018-11-03 00:00:00
kind: article
---

I've been using React a lot on some recent projects, and enjoying it. The surrounding community and range of libraries on offer is (unsurprisingly) great, and if you're building a common component then it's often easy to find a well-documented open source version of what you're about to build.

**Note:** you can see this code [on GitHub](https://github.com/samstarling/flow-generic-types), and it's also deployed [to Netlify](https://react-flow-generic-types.netlify.com).
{: .blue .ba .pa3 .mv4 .bw1 .f5}

One tool I can no longer live without is [Flow][flow], a static type checker. It helps me spot errors with passing objects that might be incompatible, accessing variables that might not exist, and a whole host of other common pitfalls.

This weekend, I've been playing around with writing generically-typed components, that is: components where the type definition takes a parameter that is also a type. One of the most obvious examples is a list, so I'll use that as an example.

### The types

By using a type parameter, <code>&lt;T&gt;</code>, we can define a type that takes an array of items, and a method that renders a single item. At the moment, think of `T` as a placeholder: we'll fill it in later.

<pre class="code ba pv2 ph3 f6 f5-ns b--black-20 black-60"><code>#!javascript
// @flow
import * as React from "react";

// The list itself takes an array of items
// and a function to render each one
type Props&lt;T&gt; = {
  items: Array&lt;T&gt;,
  renderItem: T =&gt; React.Node
};
</code></pre>

### The component

Here, we're making a component that takes props of type <code>Props&lt;T&gt;</code>, and ensuring that the type is an object that defines a readable `key` property. It doesn't do anything too clever: it renders the items by calling `map` with our `renderItem` property:

<pre class="code ba pv2 ph3 f6 f5-ns b--black-20 black-60"><code>#!javascript
export type ListItem = { +key: string };

export default class GenericList&lt;T: ListItem&gt; extends React.Component&lt;
  Props&lt;T&gt;
> {
  renderListItem: T =&gt; React.Node = (item: T) =&gt; {
    return &lt;li key={item.key}&gt;{this.props.renderItem(item)}&lt;/li&gt;;
  };

  render() {
    return &lt;ul&gt;{this.props.items.map(this.renderListItem)}&lt;/ul&gt;;
  }
}
</code></pre>

### Using the component

Once we've defined our `GenericList` component, we can extend it, and define a class that fills in the `T` with a specific type. In this case, we'll make a list of `TodoItem` objects:

<pre class="code ba pv2 ph3 f6 f5-ns b--black-20 black-60"><code>#!javascript
export type Task = ListItem & {
  title: string,
  isCompleted: boolean
};

type Props = {
  items: Array&lt;Task&gt;
};

export default class TaskList extends React.Component&lt;Props&gt; {
  renderItem = (task: Task) =&gt; {
    return (
      &lt;span&gt;
        {task.title} ({task.isCompleted ? "Done" : "Not done"})
      &lt;/span&gt;
    );
  };

  render() {
    return (
      &lt;GenericList items={this.props.items} renderItem={this.renderItem} /&gt;
    );
  }
}
</code></pre>

And that's about it: our `GenericList` will only typecheck if the objects passed in have a `key` property, and our types will ensure that each item can always be rendered correctly.

Think of the `GenericList` like a contract: given a type `T`, and a function <code>T =&gt; React.Node</code>, we can render a list of any object with `key` property, and Flow will type check it all.

And that's it... I've written lists, tables, typeahead searches and more, and doing so has felt pleasant. A big thanks has to go to [William Chargin](https://github.com/wchargin) who helped me out when I [raised the question](https://github.com/facebook/flow/issues/7145) of how to do this. Thanks!

[flow]: https://flow.org
