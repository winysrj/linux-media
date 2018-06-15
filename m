Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58162 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964992AbeFOQqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 12:46:42 -0400
Date: Fri, 15 Jun 2018 18:46:04 +0200
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
        linaro-mm-sig@lists.linaro.org, stern@rowland.harvard.edu
Subject: Re: [PATCH v3 2/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
Message-ID: <20180615164604.GD2458@hirez.programming.kicks-ass.net>
References: <20180615120827.3989-1-thellstrom@vmware.com>
 <20180615120827.3989-2-thellstrom@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615120827.3989-2-thellstrom@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 15, 2018 at 02:08:27PM +0200, Thomas Hellstrom wrote:

> @@ -772,6 +856,25 @@ __ww_mutex_add_waiter(struct mutex_waiter *waiter,
>  	}
>  
>  	list_add_tail(&waiter->list, pos);
> +	if (__mutex_waiter_is_first(lock, waiter))
> +		__mutex_set_flag(lock, MUTEX_FLAG_WAITERS);
> +
> +	/*
> +	 * Wound-Wait: if we're blocking on a mutex owned by a younger context,
> +	 * wound that such that we might proceed.
> +	 */
> +	if (!is_wait_die) {
> +		struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
> +
> +		/*
> +		 * See ww_mutex_set_context_fastpath(). Orders setting
> +		 * MUTEX_FLAG_WAITERS (atomic operation) vs the ww->ctx load,
> +		 * such that either we or the fastpath will wound @ww->ctx.
> +		 */
> +		smp_mb__after_atomic();
> +
> +		__ww_mutex_wound(lock, ww_ctx, ww->ctx);
> +	}

I think we want the smp_mb__after_atomic() in the same branch as
__mutex_set_flag(). So something like:

	if (__mutex_waiter_is_first()) {
		__mutex_set_flag();
		if (!is_wait_die)
			smp_mb__after_atomic();
	}

Or possibly even without the !is_wait_die. The rules for
smp_mb__*_atomic() are such that we want it unconditional after an
atomic, otherwise the semantics get too fuzzy.

Alan (rightfully) complained about that a while ago when he was auditing
users.
