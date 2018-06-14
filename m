Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0043.outbound.protection.outlook.com ([104.47.32.43]:15384
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755173AbeFNLtA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 07:49:00 -0400
Subject: Re: [PATCH 1/2] locking: Implement an algorithm choice for Wound-Wait
 mutexes
To: Peter Zijlstra <peterz@infradead.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Gustavo Padovan <gustavo@padovan.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        David Airlie <airlied@linux.ie>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
References: <20180613074745.14750-1-thellstrom@vmware.com>
 <20180613074745.14750-2-thellstrom@vmware.com>
 <20180613095012.GW12198@hirez.programming.kicks-ass.net>
 <69f3dee9-4782-bc90-3ee2-813ac6835c4a@vmware.com>
 <20180613131000.GX12198@hirez.programming.kicks-ass.net>
 <9afd482d-7082-fa17-5e34-179a652376e5@vmware.com>
 <20180614105151.GY12198@hirez.programming.kicks-ass.net>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <dd0c5e50-ac14-912c-d31c-c2341fdd2864@vmware.com>
Date: Thu, 14 Jun 2018 13:48:39 +0200
MIME-Version: 1.0
In-Reply-To: <20180614105151.GY12198@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2018 12:51 PM, Peter Zijlstra wrote:
> On Wed, Jun 13, 2018 at 04:05:43PM +0200, Thomas Hellstrom wrote:
>> In short, with Wait-Die (before the patch) it's the process _taking_ the
>> contended lock that backs off if necessary. No preemption required. With
>> Wound-Wait, it's the process _holding_ the contended lock that gets wounded
>> (preempted), and it needs to back off at its own discretion but no later
>> than when it's going to sleep on another ww mutex. That point is where we
>> intercept the preemption request. We're preempting the transaction rather
>> than the process.
> This:
>
>    Wait-die:
>      The newer transactions are killed when:
>        It (= the newer transaction) makes a reqeust for a lock being held
>        by an older transactions
>
>    Wound-wait:
>      The newer transactions are killed when:
>        An older transaction makes a request for a lock being held by the
>        newer transactions
>
> Would make for an excellent comment somewhere. No talking about
> preemption, although I think I know what you mean with it, that is not
> how preemption is normally used.

Ok. I'll incorporate something along this line. Unfortunately that last 
statement is not fully true. It should read
"The newer transactions are wounded when:", not "killed" when.

The literature makes a distinction between "killed" and "wounded". In 
our context, "Killed" is when a transaction actually receives an 
-EDEADLK and needs to back off. "Wounded" is when someone (typically 
another transaction) requests a transaction to kill itself. A wound will 
often, but not always, lead to a kill. If the wounded transaction has 
finished its locking sequence, or has the opportunity to grab 
uncontended ww mutexes or steal contended (non-handoff) ww mutexes to 
finish its transaction it will do so and never kill itself.



>
> In scheduling speak preemption is when we pick a runnable (but !running)
> task to run instead of the current running task.  In this case however,
> our T2 is blocked on a lock acquisition (one owned by our T1) and T1 is
> the only runnable task. Only when T1's progress is inhibited by T2 (T1
> wants a lock held by T2) do we wound/wake T2.

Indeed. The preemption spoken about in the Wound-Wait litterature means 
that a transaction preempts another transaction when it wounds it. In 
distributed computing my understanding is that the preempted transaction 
is aborted instantly and restarted after a random delay. Of course, we 
have no means of mapping wounding to process preemption in the linux 
kernel, so that's why I referred to it as "lazy preemption". In process 
analogy "wounded" wound roughly correspond to (need_resched() == true), 
and returning -EDEADLK would correspond to voluntary preemption.



>
> In any case, I had a little look at the current ww_mutex code and ended
> up with the below patch that hopefully clarifies things a little.
>
> ---
> diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
> index f44f658ae629..a20c04619b2a 100644
> --- a/kernel/locking/mutex.c
> +++ b/kernel/locking/mutex.c
> @@ -244,6 +244,10 @@ void __sched mutex_lock(struct mutex *lock)
>   EXPORT_SYMBOL(mutex_lock);
>   #endif
>   
> +/*
> + * Associate the ww_mutex @ww with the context @ww_ctx under which we acquired
> + * it.
> + */

IMO use of "acquire_context" or "context" is a little unfortunate when 
the literature uses "transaction",
but otherwise fine.


>   static __always_inline void
>   ww_mutex_lock_acquired(struct ww_mutex *ww, struct ww_acquire_ctx *ww_ctx)
>   {
> @@ -282,26 +286,36 @@ ww_mutex_lock_acquired(struct ww_mutex *ww, struct ww_acquire_ctx *ww_ctx)
>   	DEBUG_LOCKS_WARN_ON(ww_ctx->ww_class != ww->ww_class);
>   #endif
>   	ww_ctx->acquired++;
> +	lock->ctx = ctx;
>   }
>   
> +/*
> + * Determine if context @a is 'after' context @b. IOW, @a should be wounded in
> + * favour of @b.
> + */

So "wounded" should never really be used with Wait-Die
"Determine whether context @a represents a younger transaction than 
context @b"?

>   static inline bool __sched
>   __ww_ctx_stamp_after(struct ww_acquire_ctx *a, struct ww_acquire_ctx *b)
>   {
> -	return a->stamp - b->stamp <= LONG_MAX &&
> -	       (a->stamp != b->stamp || a > b);
> +
> +	return (signed long)(a->stamp - b->stamp) > 0;
>   }
>   
>   /*
> - * Wake up any waiters that may have to back off when the lock is held by the
> - * given context.
> + * We just acquired @lock under @ww_ctx, if there are later contexts waiting
> + * behind us on the wait-list, wake them up so they can wound themselves.

Actually for Wait-Die, Back off or "Die" is the correct terminology.

>    *
> - * Due to the invariants on the wait list, this can only affect the first
> - * waiter with a context.
> + * See __ww_mutex_add_waiter() for the list-order construction; basically the
> + * list is ordered by stamp smallest (oldest) first, so if there is a later
> + * (younger) stamp on the list behind us, wake it so it can wound itself.
> + *
> + * Because __ww_mutex_add_waiter() and __ww_mutex_check_stamp() wake any
> + * but the earliest context, this can only affect the first waiter (with a
> + * context).

The wait list invariants are stated in 
Documentation/locking/ww-mutex-design.txt.
Perhaps we could copy those into the code to make the comment more 
understandable:
"  We maintain the following invariants for the wait list:
   (1) Waiters with an acquire context are sorted by stamp order; waiters
       without an acquire context are interspersed in FIFO order.
   (2) For Wait-Die, among waiters with contexts, only the first one can 
have
       other locks acquired already (ctx->acquired > 0). Note that this 
waiter
       may come after other waiters without contexts in the list."

>    *
>    * The current task must not be on the wait list.
>    */
>   static void __sched
> -__ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
> +__ww_mutex_wakeup_for_wound(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)

Again, "wound" is unsuitable for Wait-Die. + numerous additional places.

Thanks,
Thomas
