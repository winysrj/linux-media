Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0057.outbound.protection.outlook.com ([104.47.34.57]:2224
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934508AbeFMKlA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 06:41:00 -0400
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
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <69f3dee9-4782-bc90-3ee2-813ac6835c4a@vmware.com>
Date: Wed, 13 Jun 2018 12:40:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180613095012.GW12198@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/13/2018 11:50 AM, Peter Zijlstra wrote:
>
>> +
>> +	lockdep_assert_held(&lock->wait_lock);
>> +
>> +	if (owner && hold_ctx && __ww_ctx_stamp_after(hold_ctx, ww_ctx) &&
>> +	    ww_ctx->acquired > 0) {
>> +		WRITE_ONCE(hold_ctx->wounded, true);
>> +		if (owner != current) {
>> +			/*
>> +			 * wake_up_process() inserts a write memory barrier to
> It does no such thing. But yes, it does ensure the wakee sees all prior
> stores IFF the wakeup happened.
>
>> +			 * make sure owner sees it is wounded before
>> +			 * TASK_RUNNING in case it's sleeping on another
>> +			 * ww_mutex. Note that owner points to a valid
>> +			 * task_struct as long as we hold the wait_lock.
>> +			 */
> What exactly are you trying to say here ?
>
> I'm thinking this is the pairing barrier to the smp_mb() below, with
> your list_empty() thing? Might make sense to write a single coherent
> comment and refer to the other location.

So what I'm trying to say here is that wake_up_process() ensures that 
the owner, if in !TASK_RUNNING, sees the write to hold_ctx->wounded 
before the transition to TASK_RUNNING. This was how I interpreted "woken 
up" in the wake up process documentation.

>
>> +			wake_up_process(owner);
>> +		}
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>   /*
>>    * Wake up any waiters that may have to back off when the lock is held by the
>>    * given context.
>>    *
>>    * Due to the invariants on the wait list, this can only affect the first
>> - * waiter with a context.
>> + * waiter with a context, unless the Wound-Wait algorithm is used where
>> + * also subsequent waiters with a context main wound the lock holder.
>>    *
>>    * The current task must not be on the wait list.
>>    */
>> @@ -303,6 +338,7 @@ static void __sched
>>   __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>>   {
>>   	struct mutex_waiter *cur;
>> +	bool is_wait_die = ww_ctx->ww_class->is_wait_die;
>>   
>>   	lockdep_assert_held(&lock->wait_lock);
>>   
>> @@ -310,13 +346,14 @@ __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>>   		if (!cur->ww_ctx)
>>   			continue;
>>   
>> -		if (cur->ww_ctx->acquired > 0 &&
>> +		if (is_wait_die && cur->ww_ctx->acquired > 0 &&
>>   		    __ww_ctx_stamp_after(cur->ww_ctx, ww_ctx)) {
>>   			debug_mutex_wake_waiter(lock, cur);
>>   			wake_up_process(cur->task);
>>   		}
>>   
>> -		break;
>> +		if (is_wait_die || __ww_mutex_wound(lock, cur->ww_ctx, ww_ctx))
>> +			break;
>>   	}
>>   }
>>   
>> @@ -338,12 +375,17 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>>   	 * and keep spinning, or it will acquire wait_lock, add itself
>>   	 * to waiter list and sleep.
>>   	 */
>> -	smp_mb(); /* ^^^ */
>> +	smp_mb(); /* See comments above and below. */
>>   
>>   	/*
>> -	 * Check if lock is contended, if not there is nobody to wake up
>> +	 * Check if lock is contended, if not there is nobody to wake up.
>> +	 * Checking MUTEX_FLAG_WAITERS is not enough here,
> That seems like a superfluous thing to say. It makes sense in the
> context of this patch because we change the FLAG check into a list
> check, but the resulting comment/code looks odd.
>
>> 							   since we need to
>> +	 * order against the lock->ctx check in __ww_mutex_wound called from
>> +	 * __ww_mutex_add_waiter. We can use list_empty without taking the
>> +	 * wait_lock, given the memory barrier above and the list_empty
>> +	 * documentation.
> I don't trust documentation. Please reason about implementation.

Will do.

>>   	 */
>> -	if (likely(!(atomic_long_read(&lock->base.owner) & MUTEX_FLAG_WAITERS)))
>> +	if (likely(list_empty(&lock->base.wait_list)))
>>   		return;
>>   
>>   	/*
>> @@ -653,6 +695,17 @@ __ww_mutex_lock_check_stamp(struct mutex *lock, struct mutex_waiter *waiter,
>>   	struct ww_acquire_ctx *hold_ctx = READ_ONCE(ww->ctx);
>>   	struct mutex_waiter *cur;
>>   
>> +	/*
>> +	 * If we miss a wounded == true here, we will have a pending
> Explain how we can miss that.

This is actually the pairing location of the wake_up_process() comment / 
code discussed above. Here we should have !TASK_RUNNING, and let's say 
ctx->wounded is set by another process immediately after we've read it 
(we "miss" it). At that point there must be a pending wake-up-process() 
for us and we'll pick up the set value of wounded on the next iteration 
after returning from schedule().

>
>> +	 * TASK_RUNNING and pick it up on the next schedule fall-through.
>> +	 */
>> +	if (!ctx->ww_class->is_wait_die) {
>> +		if (READ_ONCE(ctx->wounded))
>> +			goto deadlock;
>> +		else
>> +			return 0;
>> +	}
>> +
>>   	if (hold_ctx && __ww_ctx_stamp_after(ctx, hold_ctx))
>>   		goto deadlock;
>>   
>> @@ -683,12 +736,15 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>>   {
>>   	struct mutex_waiter *cur;
>>   	struct list_head *pos;
>> +	bool is_wait_die;
>>   
>>   	if (!ww_ctx) {
>>   		list_add_tail(&waiter->list, &lock->wait_list);
>>   		return 0;
>>   	}
>>   
>> +	is_wait_die = ww_ctx->ww_class->is_wait_die;
>> +
>>   	/*
>>   	 * Add the waiter before the first waiter with a higher stamp.
>>   	 * Waiters without a context are skipped to avoid starving
>> @@ -701,7 +757,7 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>>   
>>   		if (__ww_ctx_stamp_after(ww_ctx, cur->ww_ctx)) {
>>   			/* Back off immediately if necessary. */
>> -			if (ww_ctx->acquired > 0) {
>> +			if (is_wait_die && ww_ctx->acquired > 0) {
>>   #ifdef CONFIG_DEBUG_MUTEXES
>>   				struct ww_mutex *ww;
>>   
>> @@ -721,13 +777,26 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>>   		 * Wake up the waiter so that it gets a chance to back
>>   		 * off.
>>   		 */
>> -		if (cur->ww_ctx->acquired > 0) {
>> +		if (is_wait_die && cur->ww_ctx->acquired > 0) {
>>   			debug_mutex_wake_waiter(lock, cur);
>>   			wake_up_process(cur->task);
>>   		}
>>   	}
>>   
>>   	list_add_tail(&waiter->list, pos);
>> +	if (!is_wait_die) {
>> +		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
>> +
>> +		/*
>> +		 * Make sure a racing lock taker sees a non-empty waiting list
>> +		 * before we read ww->ctx, so that if we miss ww->ctx, the
>> +		 * racing lock taker will call __ww_mutex_wake_up_for_backoff()
>> +		 * and wound itself.
>> +		 */
>> +		smp_mb();
>> +		__ww_mutex_wound(lock, ww_ctx, ww->ctx);
>> +	}
>> +
>>   	return 0;
>>   }
>>   
>> @@ -750,6 +819,14 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>>   	if (use_ww_ctx && ww_ctx) {
>>   		if (unlikely(ww_ctx == READ_ONCE(ww->ctx)))
>>   			return -EALREADY;
>> +
>> +		/*
>> +		 * Reset the wounded flag after a backoff.
>> +		 * No other process can race and wound us here since they
>> +		 * can't have a valid owner pointer at this time
>> +		 */
>> +		if (ww_ctx->acquired == 0)
>> +			ww_ctx->wounded = false;
>>   	}
>>   
>>   	preempt_disable();
>> @@ -858,6 +935,11 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
>>   acquired:
>>   	__set_current_state(TASK_RUNNING);
>>   
>> +	/* We stole the lock. Need to check wounded status. */
>> +	if (use_ww_ctx && ww_ctx && !ww_ctx->ww_class->is_wait_die &&
>> +	    !__mutex_waiter_is_first(lock, &waiter))
>> +		__ww_mutex_wakeup_for_backoff(lock, ww_ctx);
>> +
>>   	mutex_remove_waiter(lock, &waiter, current);
>>   	if (likely(list_empty(&lock->wait_list)))
>>   		__mutex_clear_flag(lock, MUTEX_FLAGS);
> I can't say I'm a fan. I'm already cursing the ww_mutex stuff every time
> I have to look at it, and you just made it worse spagethi.
>
>

Thanks for the review.

Well, I can't speak for the current ww implementation except I didn't 
think it was too hard to understand for a first time reader.

Admittedly the Wound-Wait path makes it worse since it's a preemptive 
algorithm and we need to touch other processes a acquire contexts and 
worry about ordering.

So, assuming your review comments are fixed up, is that a solid NAK or 
do you have any suggestion that would make you more comfortable with the 
code? like splitting out ww-stuff to a separate file?

/Thomas
