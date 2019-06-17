---
title: "Total Avoidance of Partiality"
---

# TL;DR

<div class="tldr">
**Functions** map values from their **domain** to values in their **co-domain**. When a function provides a mapping
for **every domain value**, then it is **total**, otherwise it is **partial**. Partial functions are
**bad** and total functions are **good**.

You can often make a partial function total by **expanding its co-domain** or
**shrinking its domain**.
</div>

## Functions, Domains, and Co-domains

Remember when you learnt about functions in high school mathematics? Neither do I. Oh well, let's just learn it again.

A function maps inputs to outputs.

<pre><code class="language-csharp">f(x) = x + 1      // where x is an integer
g(x,y) = x * y    // where x and y are both integers
</code></pre>

<code class=language-csharp>f</code> is a function that maps an integer to another integer by adding one to it. <code class=language-csharp>g</code> is a function that maps two integers to another integer by multiplying them together.

The set of values that a function can take as inputs is called its **domain** and the set of values that a function can return as outputs is called its **co-domain**. The domain of our <code class=language-csharp>f</code> function is the set of all integers and it's co-domain is also the set of all integers. The domain for the <code class=language-csharp>g</code> function is the set of all pairs of integers, <code class=language-csharp>(x,y)</code>, and it's co-domain is the set of all integers.

Unfortunately, in practice that's not quite the whole story, especially in programmer-land. Often, the functions we encounter, and write, end
up only mapping _some_ of the values in their domain to values in their co-domain.

## Partial to Lying

Looking at our <code class=language-csharp>f</code> and <code class=language-csharp>g</code> functions above it is hard to imagine a way to "break" them. There is no integer that we could pass to <code class=language-csharp>f</code> such that there was no way for the expression <code class=language-csharp>x + 1</code> to evaluate to another integer.

This can't be said of most functions we write when programming, especially in languages that support throwing exceptions, because anything can break at any time. Consider the following C# code, which calculates the average per-item cost from a collection of items in a shopping cart.

<pre><code class="language-csharp">public decimal CalculateAverageItemCost(Cart cart) =>
  cart.Items.Sum(i => i.Price) / cart.Items.Length;
</code></pre>

The domain of the <code class="language-csharp">CalculateAverageItemCost</code> function is all the inhabitants of the <code class="language-csharp">Cart</code> type. It's co-domain is the set of values that populate the C# <code class=language-csharp>decimal</code> type. If we give this function
a <code class="language-csharp">Cart</code>, we get back a <code class="language-csharp">decimal</code>. At least that's what the signature says.

But what about when <code class="language-csharp">Cart.Items</code> is an empty collection?

That's right, a <code class="language-csharp">DivideByZeroExcpetion</code> is thrown. Well, that signature isn't worth the internet it's written on. I'm sure you'll agree that throwing an exception is hardly the same thing as returning a <code class=language-csharp>decimal</code>!

This irresponsible behaviour makes <code class=language-csharp>CalculateAverageItemCost</code> a partial function. And the problem with partial functions is that they are **lies**. I was promised a <code class="language-csharp">decimal</code> and I didn't get one. How can I ever trust a function again?

> When some values in a function's domain are not mapped to values in its co-domain, then it is a **partial function**.

## Getting back to Total Trust

There is nothing more sacred than the relationship between a programmer and their functions. We must mend this rift, lest we doom ourselves
to a broken existence, full of pain and suffering.

Let's start with a healthy dose of honesty. **There is no function we could write** that returns a <code class="language-csharp">decimal</code> output for every possible <code class="language-csharp">Cart</code> input. It doesn't exist, because a cart with no items in it doesn't have a average per-item cost. We simply can't satisfy this signature.

This means we'll need to change the signature to something we can satisfy. A promise we can actually keep, if you will. Our goal is
to be able to map every input passed to <code class="language-csharp">CalcualteAverageItemCost</code> to some output. We can achive this by expanding the output space
(co-domain) or shrinking the input space (domain).

Both of these approaches will allow us to map every input to an output, making our <code class="language-csharp">CalculateAverageItemCost</code> a total function.

> When every value in a function's domain is mapped to a value in its co-domain, then it is a **total function**.

## Expanding the Co-domain

If we can't guarantee that we can return a <code class="language-csharp">decimal</code> output, what type of output could we guarantee? Well, we'd need a type that could model the presence of a <code class="language-csharp">decimal</code> average (for when the cart has items), and the **absence** of an average (for when the cart is empty). Let's call this type <code class="language-csharp">Maybe<decimal></code> and use it to rewrite our <code class="language-csharp">CalculateAverageItemCost</code> function.

<pre><code class="language-csharp">public Maybe&lt;decimal&gt; CalculateAverageItemCost(
  Cart cart
) =>
  cart.Items.Length > 0
    ? Just(cart.Items.Sum(i => i.Price) / cart.Items.Length)
    : Empty();
</code></pre>

<code class="language-csharp">Just</code> and <code class="language-csharp">Empty</code> are both functions that return a value of type <code class="language-csharp">Maybe<decimal></code>. <code class="language-csharp">Just</code> puts a decimal "inside" the <code class="language-csharp">Maybe</code> structure while
<code class="language-csharp">Empty</code>, as the name suggests, represents the absence of a value.

With these changes we've removed the possibility of throwing an exception by returning <code class="language-csharp">Empty</code> instead. Of course, in C#, both <code class="language-csharp">Cart</code> and <code class="language-csharp">Cart.Items</code> could be null, in which case we'd be throwing exceptions again, but I've ignored those cases for the sake of a clear example.

The point is that we have turned our partial function into a total function by conceptually expanding our co-domain
from <code class="language-csharp">decimal</code> to <code class="language-csharp">Maybe<decimal></code>.

> A partial function can be turned into a total function by **expanding it's co-domain**.

## Shrinking the Domain

We could also leave the function returning a decimal, and instead constrain the input (domain).

In this case we'd need an input type that gives us a guarantee that the cart could never be empty. Let's call this type <code class="language-csharp">NonEmptyCart</code> and say that the <code class="language-csharp">NonEmptyCart</code> API makes it impossible to construct a cart that has no items.

With this new type under out belt we could rewrite out function once again.

<pre><code class="language-csharp">public decimal CalculateAverageItemCost(
  NonEmptyCart cart
) =>
  cart.Items.Sum(i => i.Price) / cart.Items.Length;
</code></pre>

Here we've removed the possibility of the exception by limiting the inputs the function can take. This means we can use the function in less places, since <code class="language-csharp">NonEmptyCart</code> is a more constrained type than <code class="language-csharp">Cart</code>, but this is a small price to pay for being sure that you can use it safely.

> A partial function can be turned into a total function by **shrinking it's domain**.
