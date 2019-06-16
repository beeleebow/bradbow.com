---
title: "How to express yourself without effecting others"
---

## TL;DR

<div class="tldr">
We typically build programs out of a mix of **expressions** and **statements**. Expressions can be **evaluated** to produce a value, e.g. <code class="language-csharp">5 + 7</code> produces <code class="language-csharp">12</code>. Statements do not produce values, they exist to have some effect (or side-effect), e.g. <code class="language-csharp">Console.Write("I am a statement.")</code>.

**Preferring expressions over statements** will result in code that is easier to reason about.

</div>

## So what's the difference?

An **expression** is a composition of values and sub-expressions which, upon *evaluation*, reduce to a single value.
Let's take some simple mathematical examples.

<pre><code class="language-csharp">5 + 7
3 * (4 - 1)
7*x + 5
</code></pre>

Example 1 is an expression that requires a single evaluation to produce a value, in this case <code class=language-csharp>12</code>.
The second example requires two evaulations. First, we evaluate <code class=language-csharp>4 - 1</code>, then we multiply that value with <code class=language-csharp>3</code>. We see a *parameterised* expression in example 3. Given a value for <code class=language-csharp>x</code> (the parameter) we can evaluate <code class=language-csharp>7 * x</code> then add <code class=language-csharp>5</code> to this value (1 substitution, followed by 2 evaluations).

A **statement**, on the other hand, does not produce a value. It is an imperative instruction to the machine to do something. Let's have a look at some familiar statements.

<pre id="ex1"><code class="language-csharp">Console.WriteLine("I am a statement");

_logger.Info("I am a side-effect. Boo!");

var firstInteger = -1;
if(_listOfIntegers.Length > 0){
  firstInteger = _listOfIntegers[0];
}
</code></pre>

Writing to the Console or logging are statements because you don't get values back
from running them. The <code class="language-csharp">if</code> construct in most
languages executes blocks of statements if a certain predicate (i.e. an *expression*
that evaluates to a <code class="language-csharp">bool</code>) is true.

## What's the problem?

In most programming languages, the functions -- probably more accurately called methods -- end up mixing expressions and statements.
Consider the following C# code.

<pre id="ex1"><code class="language-csharp">public int PureAdd(int x, int y)
{
  return x + y;
}

public int ImpureAdd(int x, int y)
{
  Console.WriteLine($"Adding {x} and {y}");
  return x + y;
}
</code></pre>

Invocations of <code class="language-csharp">PureAdd</code> and <code class="language-csharp">ImpureAdd</code> both produce values. Evaluation of <code class="language-csharp">ImpureAdd</code>, however, also produces the side effect of writing a message to the console. The effect is achieved by calling the `Console.WriteLine` method, which we can think of as a statement, since it doens't return a value.

Now let's imagine that we, correctly, realise that having our own method for adding two `int` values is silly and decide
to replace any usage of our method with the built in `+` operator. To rectify this, we'll just do a regex-based find and
replace across all our source files.

If we've used `PureAdd` then our regex would replace `PureAdd(x, y)` with `x + y`. When we run our program after this
change, nothing will actually be different. We won't produce any new output, or change the results in any way.

However, if we've used `ImpureAdd` then our regex would replace `ImpureAdd(x, y)` with `x + y`. This will result
in the same produced value, but we would have changed our program's output. The program that called `ImpureAdd(x, y)` would
have been producing console output, because of the `Console.WriteLine`. The program that inlines `x + y` will not produce
this output. By making what seems to be a like-for-like substitution, we've actually changed the behaviour or our
running program.

We've all worked on code bases that seem to get harder and harder to change over time. This is due, in large part,
to an accumlation of hard-to-discover side-effects. I change code over here, and now code over here is broken.
One of the main causes of this state of affairs is the over-use of statements, because statements are **always side-effecting**
(except for silly examples like empty `if` blocks).
Think about it. How can you possibly have a statement that doesn't have a side effect? It has to
do *something*, and it doesn't produce a value.

> As an aside, a _pure_ functional programming language is one that has only expressions,
> no statements (and therefore no side-effects).

## What's the take away?

Try to build as much of your program as you can out of pure expressions and limit the use of statements. Here are a few tips:

* **Don't write <code class=language-csharp>void</code> methods/functions.** A method/function that doesn't return anything is just another statement. Your programming language probably has enough of those already. You don't need to be adding more.
* **Side effects at the edges, pure in the middle** The reality is that your program needs to perform side effects to be useful. At some point you'll need to read from a database or write to a response stream. Don't let these concerns pollute your entire program. Fence them off as soon as you can and keep those side effects out or your pure application logic.
* **Avoid mutation.** Mutation destroys determinism. That is, you can't expect the same output for the same inputs every time if things are being changed along the way.
* **Replace control flow structures and error handling with type driven alternatives.** Instead of having a <code class=language-csharp>Person</code> object that can be null, represent the nullability in a type, e.g. <code class=language-csharp>Option<Person></code>. Instead of throwing an exception, represent that an evaluation might fail in a type, e.g. <code class=language-csharp>Either<Exception, Person></code>.

Go forth and express yourself.

