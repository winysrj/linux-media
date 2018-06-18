Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0075.outbound.protection.outlook.com ([104.47.34.75]:27969
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933381AbeFRLf0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 07:35:26 -0400
Subject: Re: [PATCH v3 2/2] locking: Implement an algorithm choice for
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
        linaro-mm-sig@lists.linaro.org, stern@rowland.harvard.edu
References: <20180615120827.3989-1-thellstrom@vmware.com>
 <20180615120827.3989-2-thellstrom@vmware.com>
 <20180615164604.GD2458@hirez.programming.kicks-ass.net>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <88ca74e5-0d26-4e18-7596-229d12f4afc4@vmware.com>
Date: Mon, 18 Jun 2018 13:35:06 +0200
MIME-Version: 1.0
In-Reply-To: <20180615164604.GD2458@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2018 06:46 PM, Peter Zijlstra wrote:
> On Fri, Jun 15, 2018 at 02:08:27PM +0200, Thomas Hellstrom wrote:
>
>> @@ -772,6 +856,25 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>>   	}
>>   
>>   	list_add_tail(&waiter->list, pos);
>> +	if (__mutex_waiter_is_first(lock, waiter))
>> +		__mutex_set_flag(lock, MUTEX_FLAG_WAITERS);
>> +
>> +	/*
>> +	 * Wound-Wait: if we're blocking on a mutex owned by a younger context,
>> +	 * wound that such that we might proceed.
>> +	 */
>> +	if (!is_wait_die) {
>> +		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
>> +
>> +		/*
>> +		 * See ww_mutex_set_context_fastpath(). Orders setting
>> +		 * MUTEX_FLAG_WAITERS (atomic operation) vs the ww->ctx load,
>> +		 * such that either we or the fastpath will wound @ww->ctx.
>> +		 */
>> +		smp_mb__after_atomic();
>> +
>> +		__ww_mutex_wound(lock, ww_ctx, ww->ctx);
>> +	}
> I think we want the smp_mb__after_atomic() in the same branch as
> __mutex_set_flag(). So something like:
>
> 	if (__mutex_waiter_is_first()) {
> 		__mutex_set_flag();
> 		if (!is_wait_die)
> 			smp_mb__after_atomic();
> 	}
>
> Or possibly even without the !is_wait_die. The rules for
> smp_mb__*_atomic() are such that we want it unconditional after an
> atomic, otherwise the semantics get too fuzzy.
>
> Alan (rightfully) complained about that a while ago when he was auditing
> users.
>
>
Hmm, yes that's understandable, although I must admit that when one of 
the accesses we want to order is actually an atomic this shouldn't 
really be causing much confusion.

But I'll think I'll change it back to an smp_mb() then. It's in a 
slowpath, and awkward constructs around smp_mb__after_atomic() might be 
causing grief in the future.

/Thomas
