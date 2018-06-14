Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-co1nam03on0048.outbound.protection.outlook.com ([104.47.40.48]:58392
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752767AbeFNLyj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 07:54:39 -0400
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
 <20180614113604.GZ12198@hirez.programming.kicks-ass.net>
From: Thomas Hellstrom <thellstrom@vmware.com>
Message-ID: <7eb10c22-57b3-1472-0a77-7f787f612217@vmware.com>
Date: Thu, 14 Jun 2018 13:54:15 +0200
MIME-Version: 1.0
In-Reply-To: <20180614113604.GZ12198@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/14/2018 01:36 PM, Peter Zijlstra wrote:
> On Thu, Jun 14, 2018 at 09:29:21AM +0200, Thomas Hellstrom wrote:
>
>>   __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>>   {
>>   	struct mutex_waiter *cur;
>> +	unsigned int is_wait_die = ww_ctx->ww_class->is_wait_die;
>>   
>>   	lockdep_assert_held(&lock->wait_lock);
>>   
>> @@ -310,13 +348,14 @@ __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
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
> I ended up with:
>
>
> static void __sched
> __ww_mutex_check_waiters(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
> {
> 	bool is_wait_die = ww_ctx->ww_class->is_wait_die;
> 	struct mutex_waiter *cur;
>
> 	lockdep_assert_held(&lock->wait_lock);
>
> 	list_for_each_entry(cur, &lock->wait_list, list) {
> 		if (!cur->ww_ctx)
> 			continue;
>
> 		if (is_wait_die) {
> 			/*
> 			 * Because __ww_mutex_add_waiter() and
> 			 * __ww_mutex_check_stamp() wake any but the earliest
> 			 * context, this can only affect the first waiter (with
> 			 * a context).
> 			 */
> 			if (cur->ww_ctx->acquired > 0 &&
> 			    __ww_ctx_stamp_after(cur->ww_ctx, ww_ctx)) {
> 				debug_mutex_wake_waiter(lock, cur);
> 				wake_up_process(cur->task);
> 			}
>
> 			break;
> 		}
>
> 		if (__ww_mutex_wound(lock, cur->ww_ctx, ww_ctx))
> 			break;
> 	}
> }

Looks OK to me.

>
> Currently you don't allow mixing WD and WW contexts (which is not
> immediately obvious from the above code), and the above hard relies on
> that. Are there sensible use cases for mixing them? IOW will your
> current restriction stand without hassle?

Contexts _must_ agree on the algorithm used to resolve deadlocks. With 
Wait-Die, for example, older transactions will wait if a lock is held by 
a younger transaction and with Wound-Wait, younger transactions will 
wait if a lock is held by an older transaction so there is no way of 
mixing them.

Thanks,

/Thomas
