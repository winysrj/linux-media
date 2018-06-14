Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37136 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754810AbeFNLgy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 07:36:54 -0400
Date: Thu, 14 Jun 2018 13:36:04 +0200
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
Subject: Re: [PATCH v2 1/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
Message-ID: <20180614113604.GZ12198@hirez.programming.kicks-ass.net>
References: <20180614072922.8114-1-thellstrom@vmware.com>
 <20180614072922.8114-2-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180614072922.8114-2-thellstrom@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 14, 2018 at 09:29:21AM +0200, Thomas Hellstrom wrote:

>  __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>  {
>  	struct mutex_waiter *cur;
> +	unsigned int is_wait_die = ww_ctx->ww_class->is_wait_die;
>  
>  	lockdep_assert_held(&lock->wait_lock);
>  
> @@ -310,13 +348,14 @@ __ww_mutex_wakeup_for_backoff(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
>  		if (!cur->ww_ctx)
>  			continue;
>  
> -		if (cur->ww_ctx->acquired > 0 &&
> +		if (is_wait_die && cur->ww_ctx->acquired > 0 &&
>  		    __ww_ctx_stamp_after(cur->ww_ctx, ww_ctx)) {
>  			debug_mutex_wake_waiter(lock, cur);
>  			wake_up_process(cur->task);
>  		}
>  
> -		break;
> +		if (is_wait_die || __ww_mutex_wound(lock, cur->ww_ctx, ww_ctx))
> +			break;
>  	}
>  }

I ended up with:


static void __sched
__ww_mutex_check_waiters(struct mutex *lock, struct ww_acquire_ctx *ww_ctx)
{
	bool is_wait_die = ww_ctx->ww_class->is_wait_die;
	struct mutex_waiter *cur;

	lockdep_assert_held(&lock->wait_lock);

	list_for_each_entry(cur, &lock->wait_list, list) {
		if (!cur->ww_ctx)
			continue;

		if (is_wait_die) {
			/*
			 * Because __ww_mutex_add_waiter() and
			 * __ww_mutex_check_stamp() wake any but the earliest
			 * context, this can only affect the first waiter (with
			 * a context).
			 */
			if (cur->ww_ctx->acquired > 0 &&
			    __ww_ctx_stamp_after(cur->ww_ctx, ww_ctx)) {
				debug_mutex_wake_waiter(lock, cur);
				wake_up_process(cur->task);
			}

			break;
		}

		if (__ww_mutex_wound(lock, cur->ww_ctx, ww_ctx))
			break;
	}
}


Currently you don't allow mixing WD and WW contexts (which is not
immediately obvious from the above code), and the above hard relies on
that. Are there sensible use cases for mixing them? IOW will your
current restriction stand without hassle?
