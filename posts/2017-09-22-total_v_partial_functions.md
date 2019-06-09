---
title: "Why you should totally avoid partial functions"
---

# TL;DR

> **Functions** map values from their **domain** to values in their **co-domain**. **Total** functions have a total mapping between their domain and co-domain. **Partial** functions do not. This makes code that uses them hard to reason about and prone to bugs. Functions that throw exceptions are perfect examples of partial functions and their effect on reasonability.

## Functions, domains, and co-domains

Remember when you learnt about functions in high school maths? Neither do I. Oh well, let's just learn it again.

A **function** maps inputs to outputs.

<pre><code class="language-csharp">f(x) = x + 1      // where x is an integer
g(x,y) = x * y    // where x and y are both integers
</code></pre>

`f` is a function that maps an integer to another integer by adding one to it. `g` is a function that maps two integers to another integer by multiplying them together.

The set of values that a function can take as inputs is called it's **domain**. The set of values that a function can return is called it's **co-domain**. So the domain of our `f` function is the set of all integers and it's co-domain is also the set of all integers. The domain for the `g` function is the set of all pairs of integers, (x,y), and it's co-domain is the set of all integers.

So **functions** map values from their **domain** to values in their **co-domain**.

Now that we have learnt (or re-learnt) what functions are, let's look at what it means for a function to be *partial*.

## Can a function ... lie?

Looking at our `f` and `g` functions above it is hard to imagine a way to 'break' them. What integer could we possibly pass to `f` such that there was no way for the expression `x + 1` to evaluate to another integer?

When it comes to programming though, it is very easy to 'break' most functions we write. Particularly in languages that support throwing exceptions. Anything can break, at any time. Consider the following C# code.

<pre><code class="language-csharp">public decimal AddProductToCart(int productId)
{
  var product = _productLookup.Lookup(productId);
  if(product == null)
    throw new ArgumentException(nameof(productId));

  _cart.Add(product);
  return _cart.CalculateCartValue();
}
</code></pre>

The domain of the <code class="language-csharp">AddProductToCart</code> function is all integers (or at least all 32-bit integers). It's co-domain is the set of values that populate the C# `decimal` type. But `AddProductToCart` will only return a value from it's co-domain for some special set of values from it's domain. When the `productId` does not resolve to an existing product an exception is thrown and no value is returned at all. This makes `AddProductToCart` a **partial** function.

> Partial functions are functions that do not map every value in their domain to a value in their co-domain.

So what's the problem?

Well, the problem is that **the function is a lie**. It told me that if I give it an integer I will get a decimal back. It promised. And it let me down. How can I ever trust a function again?

So what's to be done? How can we mend this relationship?

## Getting the trust back

We mend the relationship by getting the trust back. And we get the trust back by not lying to each other. With regard to our `AddProductToCart` function above the lie was that it returned a decimal. The *truth* is that it returns *either* a decimal or some form of error (in our case an `Exception`). So let's tell the truth.

<pre><code class="language-csharp">public Either<Exception, decimal> TrustworthyAddProductToCart(
    int productId
)
{
  try
  {
    var product = _productLookup.Lookup(productId);
    if(product == null)
    {
      throw new ArgumentException(nameof(productId));
    }
    _cart.Add(product);
    return Either<Exception, decimal>.Right(_cart.CalculateCartValue());
  }
  catch(Exception e)
  {
    return Either<Exception, decimal>.Left(e);
  }
}
</code></pre>

Instead of letting an exception escape, `TrustworthyAddProductToCart` catches it and returns it inside the the `Either` type. This is a type that encapsulates the idea that a value can have one of two types, typically referred to as the `Left` and `Right`. Any code that calls `TrustworthyAddProductToCart` knows that it must handle both the error case and the success case (i.e. the `Left` and `Right` 'branches'). This information is right there in the signature. It's honest.

The domain of the `TrustworthyAddProductToCart` is still 32-bit integers but the co-domain is now represented by the `Either<Exception, decimal>` type. You can't call `TrustworthyAddProductToCart` with any value in it's domain (`int`) and fail to get back a value in it's co-domain (`Either<Exception, decimal>`). This makes it a **total function**.

> Total functions are functions that map every value in their domain to a value in their co-domain.

Save your lies for people and keep your functions honest (i.e. **total**).
