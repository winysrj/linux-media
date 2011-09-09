Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout0.thls.bbc.co.uk ([132.185.240.35]:63210 "EHLO
	mailout0.thls.bbc.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933307Ab1IILHY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 07:07:24 -0400
Message-ID: <4E69EE5E.8080605@rd.bbc.co.uk>
Date: Fri, 09 Sep 2011 11:45:50 +0100
From: David Waring <davidjw@rd.bbc.co.uk>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>
Subject: Re: recursive locking problem
References: <4E68EE98.90201@iki.fi>
In-Reply-To: <4E68EE98.90201@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/11 17:34, Antti Palosaari wrote:
> [snip]
> 
> Is there any lock can do recursive locking but unlock frees all locks?
> 
> Like that:
> gate_open
> +gate_open
> +gate_close
> == lock is free
> 
> AFAIK mutex can do only simple lock() + unlock(). Semaphore can do
> recursive locking, like lock() + lock() + unlock() + unlock(). But how I
> can do lock() + lock() + unlock() == free.
> 
Antti,

It's a very bad idea to try and use a mutex like that. The number of
locks and unlocks must be balanced otherwise you risk accessing
variables without a lock.

Consider:

static struct mutex foo_mutex;
static int foo=3;

void a() {
  mutex_lock(&foo_mutex);
  if (foo<5) foo++;
  b();
  foo--; /* <<< still need lock here */
  mutex_unlock(&foo_mutex);
}

void b() {
  mutex_lock(&foo_mutex);
  if (foo>6) foo=(foo>>1);
  mutex_unlock(&foo_mutex);
}

Note: this assumes mutex_lock will allow the same thread get multiple
locks as you would like (which it doesn't).

As pointed out in the code, when a() is called, you still need the lock
for accesses to foo after the call to b() that also requires the lock.
If we used the locks in the way you propose then foo would be accessed
without a lock.

To code properly for cases like these I usually use a wrapper functions
to acquire the lock and call a thread unsafe version (i.e. doesn't use
locks) of the function that only uses other thread unsafe functions. e.g.

void a() {
  mutex_lock(&foo_mutex);
  __a_thr_unsafe();
  mutex_unlock(&foo_mutex);
}

void b() {
  mutex_lock(&foo_mutex);
  __b_thr_unsafe();
  mutex_unlock(&foo_mutex);
}

static void __a_thr_unsafe() {
  if (foo<5) foo++;
  __b_thr_unsafe();
  foo--;
}

static void __b_thr_unsafe() {
  if (foo>6) foo=(foo>>1);
}

This way a call to a() or b() will acquire the lock once for that
thread, perform all actions and then release the lock. The mutex is
handled properly.

Can you restructure the code so that you don't need multiple locks?

-- 
David Waring
