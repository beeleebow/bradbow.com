---
title: "How to express yourself without effecting others"
---

## TL;DR

*Most programmers build programs out of a mix of expressions (things that can be evaluated to produce a value, e.g. `5 + 7`) and statements (imperative instructions to a machine, e.g. `printLine "hello world"`).
While this seems like a sane and flexible approach, it comes at the cost of "reasonability". This is because statements hide side-effects, which are the the mortal enemies of clarity and determinism.*

## So what's the difference?

An **expression** is a composition of values and sub-expressions which, upon *evaluation*, reduces to a single value. Let's take some simple mathematical examples.

```
1. 5 + 7
2. 3 * (4 - 1)
3. 7*x + 5
```

Example 1 is a *simple* expression, meaning there is only one evaluation needed to produce a value, in this case `12`. The second example is a *compound* expression because it is composed of two simple sub-expressions. First, we evaluate `4-1`, then we multiply that value with `3`. Finally, example 3 is a *parameterised, compound* expression. Given a value for `x` (the parameter) we can evaluate `7*x` then add `5` to this value.

A **statement** does not produce a value. It is an imperative instruction to the machine to do something. Let's have a look at some familiar statements.

```csharp
var x = 1;
Console.WriteLine("I am a statement");
_logger.Info("Logger calls don't produce values, only side-effects");

var firstInteger = -1;
if(_listOfIntegers.Length > 0){
  firstInteger = _listOfIntegers[0];
}
```

`var x = 1;` is a statement (i.e. the *assignment* statement). It says: "Give me enough memory to hold an integer, put the value `1` into that memory, and address the memory as `x` so I can refer to it later". Writing to the Console or logging are also statements. You don't get values back from running them. The `if` construct in most languages executes blocks of statements if a certain predicate (i.e. an *expression* that evaluates to a bool) is true.

## So what's the problem?

If you want to be able to easily and consistently reason about your program, then side effects should be treated with caution. This is probably worthy of it's own post, but for now let's accept the premise that side effects are somewhat undesirable.

The problem, then, is that statements are **always side-effecting**. Think about it. How can you possibly have a statement that doesn't have a side effect? It has to do *something*, and it doesn't produce a value...

In most programming languages expressions may or may not produce a side effect. Consider the following C# code.

```csharp
public int PureAdd(int x, int y)
{
  return x + y;
}

public int ImpureAdd(int x, int y)
{
  Console.WriteLine($"Adding {x} and {y}");
  return x + y;
}
```

Invocations of both `PureAdd` and `ImpureAdd` are expressions because they produce values. Evaluation of `ImpureAdd`, however, also produces the side effect of writing a message to the console. Notice how the side effect is achieved though? Thats right, via a statement.

> As an aside, a "pure" functional programming language is one that has only expressions and does not permit side effects. Programs written in these languages are simply the composition of smaller expressions into a single compound expression (i.e. the "program").

## So what's the take away?

Try to build as much of your program as you can out of pure expressions and limit the use of statements. Here are a few tips:

* **Don't write `void` methods/functions.** A method/function that doesn't return anything is just another statement. Your programming language probably has enough of those already. You don't need to be adding more.
* **Side effects at the edges, pure in the middle** The reality is that your program needs to perform side effects to be useful. At some point you'll need to read from a database or write to a response stream. Don't let these concerns pollute your entire program. Fence them off as soon as you can and keep those side effects out or your pure application logic.
* **Avoid mutation.** Mutation destroys determinism. That is, you can't expect the same output for the same inputs every time if things are being changed along the way.
* **Replace control flow structures and error handling with type driven alternatives.** Instead of having a `Person` object that can be null represent the nullability in a type, e.g. `Option<Person>`. Instead of throwing an exception, represent that an evaluation might fail in a type, e.g. `Either<Exception, Person>`.

Go forth and express yourself.

