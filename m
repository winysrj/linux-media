Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:42124 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935346AbeFMNK5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 09:10:57 -0400
Date: Wed, 13 Jun 2018 15:10:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
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
Subject: Re: [PATCH 1/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
Message-ID: <20180613131000.GX12198@hirez.programming.kicks-ass.net>
References: <20180613074745.14750-1-thellstrom@vmware.com>
 <20180613074745.14750-2-thellstrom@vmware.com>
 <20180613095012.GW12198@hirez.programming.kicks-ass.net>
 <69f3dee9-4782-bc90-3ee2-813ac6835c4a@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69f3dee9-4782-bc90-3ee2-813ac6835c4a@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 13, 2018 at 12:40:29PM +0200, Thomas Hellstrom wrote:
> On 06/13/2018 11:50 AM, Peter Zijlstra wrote:
> > 
> > > +
> > > +	lockdep_assert_held(&lock->wait_lock);
> > > +
> > > +	if (owner && hold_ctx && __ww_ctx_stamp_after(hold_ctx, ww_ctx) &&
> > > +	    ww_ctx->acquired > 0) {
> > > +		WRITE_ONCE(hold_ctx->wounded, true);
> > > +		if (owner != current) {
> > > +			/*
> > > +			 * wake_up_process() inserts a write memory barrier to
> > It does no such thing. But yes, it does ensure the wakee sees all prior
> > stores IFF the wakeup happened.
> > 
> > > +			 * make sure owner sees it is wounded before
> > > +			 * TASK_RUNNING in case it's sleeping on another
> > > +			 * ww_mutex. Note that owner points to a valid
> > > +			 * task_struct as long as we hold the wait_lock.
> > > +			 */
> > What exactly are you trying to say here ?
> > 
> > I'm thinking this is the pairing barrier to the smp_mb() below, with
> > your list_empty() thing? Might make sense to write a single coherent
> > comment and refer to the other location.
> 
> So what I'm trying to say here is that wake_up_process() ensures that the
> owner, if in !TASK_RUNNING, sees the write to hold_ctx->wounded before the
> transition to TASK_RUNNING. This was how I interpreted "woken up" in the
> wake up process documentation.

There is documentation!? :-) Aaah, you mean that kerneldoc comment with
wake_up_process() ? Yeah, that needs fixing. /me puts on endless todo
list.

Anyway, wakeup providing that ordering isn't something that needs a
comment of that size; and I think the only comment here is that we care
about the ordering and a reference to the site(s) that pairs with it.

Maybe something like:

	/*
	 * __ww_mutex_lock_check_stamp() will observe our wounded store.
	 */

> > > -	if (likely(!(atomic_long_read(&lock->base.owner) & MUTEX_FLAG_WAITERS)))
> > > +	if (likely(list_empty(&lock->base.wait_list)))
> > >   		return;
> > >   	/*
> > > @@ -653,6 +695,17 @@ __ww_mutex_lock_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
> > >   	struct ww_acquire_ctx *hold_ctx = READ_ONCE(ww->ctx);
> > >   	struct mutex_waiter *cur;
> > > +	/*
> > > +	 * If we miss a wounded == true here, we will have a pending
> > Explain how we can miss that.
> 
> This is actually the pairing location of the wake_up_process() comment /
> code discussed above. Here we should have !TASK_RUNNING, and let's say
> ctx->wounded is set by another process immediately after we've read it (we
> "miss" it). At that point there must be a pending wake-up-process() for us
> and we'll pick up the set value of wounded on the next iteration after
> returning from schedule().

Right, so that's when the above wakeup isn't the one waking us.


> > I can't say I'm a fan. I'm already cursing the ww_mutex stuff every time
> > I have to look at it, and you just made it worse spagethi.

> Well, I can't speak for the current ww implementation except I didn't think
> it was too hard to understand for a first time reader.
> 
> Admittedly the Wound-Wait path makes it worse since it's a preemptive
> algorithm and we need to touch other processes a acquire contexts and worry
> about ordering.
> 
> So, assuming your review comments are fixed up, is that a solid NAK or do
> you have any suggestion that would make you more comfortable with the code?
> like splitting out ww-stuff to a separate file?

Nah, not a NAK, but we should look at whan can be done to improve code.
Maybe add a few more comments that explain why. Part of the problem with
ww_mutex is always that I forget exactly how they work and mutex.c
doesn't have much useful comments in (most of those are in ww_mutex.h
and I always forget to look there).

Also; I'm not at all sure about the exact difference between what we
have and what you propose. I did read the documentation part (I really
should not have to) but it just doesn't jive.

I suspect you're using preemption entirely different from what we
usually call a preemption.



Also, __ww_ctx_stamp_after() is crap; did we want to write:

	return (signed long)(a->stamp - b->stamp) > 0;

or something?
