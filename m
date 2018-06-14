Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0058.outbound.protection.outlook.com ([104.47.40.58]:25312
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752767AbeFNMsg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 08:48:36 -0400
Subject: Re: [PATCH v2 1/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
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
References: <20180614072922.8114-1-thellstrom@vmware.com>
 <20180614072922.8114-2-thellstrom@vmware.com>
 <20180614124129.GA12198@hirez.programming.kicks-ass.net>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <3d73590a-13de-9164-4b32-9d7da6a1055b@vmware.com>
Date: Thu, 14 Jun 2018 14:48:16 +0200
MIME-Version: 1.0
In-Reply-To: <20180614124129.GA12198@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, Peter,

On 06/14/2018 02:41 PM, Peter Zijlstra wrote:
> On Thu, Jun 14, 2018 at 09:29:21AM +0200, Thomas Hellstrom wrote:
>> +static bool __ww_mutex_wound(struct mutex *lock,
>> +			     struct ww_acquire_ctx *ww_ctx,
>> +			     struct ww_acquire_ctx *hold_ctx)
>> +{
>> +	struct task_struct *owner = __mutex_owner(lock);
>> +
>> +	lockdep_assert_held(&lock->wait_lock);
>> +
>> +	if (owner && hold_ctx && __ww_ctx_stamp_after(hold_ctx, ww_ctx) &&
>> +	    ww_ctx->acquired > 0) {
>> +		hold_ctx->wounded = 1;
>> +
>> +		/*
>> +		 * wake_up_process() paired with set_current_state() inserts
>> +		 * sufficient barriers to make sure @owner either sees it's
>> +		 * wounded or has a wakeup pending to re-read the wounded
>> +		 * state.
>> +		 *
>> +		 * The value of hold_ctx->wounded in
>> +		 * __ww_mutex_lock_check_stamp();
>> +		 */
>> +		if (owner != current)
>> +			wake_up_process(owner);
>> +
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}
>> @@ -338,12 +377,18 @@ ww_mutex_set_context_fastpath(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
>>   	 * and keep spinning, or it will acquire wait_lock, add itself
>>   	 * to waiter list and sleep.
>>   	 */
>> -	smp_mb(); /* ^^^ */
>> +	smp_mb(); /* See comments above and below. */
>>   
>>   	/*
>> -	 * Check if lock is contended, if not there is nobody to wake up
>> +	 * Check if lock is contended, if not there is nobody to wake up.
>> +	 * We can use list_empty() unlocked here since it only compares a
>> +	 * list_head field pointer to the address of the list head
>> +	 * itself, similarly to how list_empty() can be considered RCU-safe.
>> +	 * The memory barrier above pairs with the memory barrier in
>> +	 * __ww_mutex_add_waiter and makes sure lock->ctx is visible before
>> +	 * we check for waiters.
>>   	 */
>> -	if (likely(!(atomic_long_read(&lock->base.owner) & MUTEX_FLAG_WAITERS)))
>> +	if (likely(list_empty(&lock->base.wait_list)))
>>   		return;
>>   
> OK, so what happens is that if we see !empty list, we take wait_lock,
> if we end up in __ww_mutex_wound() we must really have !empty wait-list.
>
> It can however still see !owner because __mutex_unlock_slowpath() can
> clear the owner field. But if owner is set, it must stay valid because
> FLAG_WAITERS and we're holding wait_lock.

If __ww_mutex_wound() is called from ww_mutex_set_context_fastpath() 
owner is the current process so we can never see !owner. However if 
__ww_mutex_wound() is called from __ww_mutex_add_waiter() then the above 
is true.

>
> So the wake_up_process() is in fact safe.
>
> Let me put that in a comment.


Thanks,

Thomas
