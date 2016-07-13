Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53850 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbcGMK0y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 06:26:54 -0400
Date: Wed, 13 Jul 2016 12:26:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Tejun Heo <tj@kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 2/9] async: Introduce kfence, a N:M completion mechanism
Message-ID: <20160713102625.GA30921@twins.programming.kicks-ass.net>
References: <1466759333-4703-1-git-send-email-chris@chris-wilson.co.uk>
 <1466759333-4703-3-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466759333-4703-3-git-send-email-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 24, 2016 at 10:08:46AM +0100, Chris Wilson wrote:
> +struct kfence {
> +	wait_queue_head_t wait;
> +	unsigned long flags;
> +	struct kref kref;
> +	atomic_t pending;
> +};

> +#define KFENCE_CHECKED_BIT	0
> +
> +static void kfence_free(struct kref *kref)
> +{
> +	struct kfence *fence = container_of(kref, typeof(*fence), kref);
> +
> +	WARN_ON(atomic_read(&fence->pending) > 0);
> +
> +	kfree(fence);
> +}
> +
> +/**
> + * kfence_put - release a reference to a kfence
> + * @fence: the kfence being disposed of
> + */
> +void kfence_put(struct kfence *fence)
> +{
> +	if (fence)
> +		kref_put(&fence->kref, kfence_free);

It seems very poor semantics to allow to put NULL, that would indicate a
severe logic fail.

> +}
> +EXPORT_SYMBOL_GPL(kfence_put);

> +/**
> + * kfence_get - acquire a reference to a kfence
> + * @fence: the kfence being used
> + *
> + * Returns the pointer to the kfence, with its reference count incremented.
> + */
> +struct kfence *kfence_get(struct kfence *fence)
> +{
> +	if (fence)
> +		kref_get(&fence->kref);

Similar, getting NULL is just horrible taste.

> +	return fence;
> +}
> +EXPORT_SYMBOL_GPL(kfence_get);


> +static void __kfence_wake_up_all(struct kfence *fence,
> +				 struct list_head *continuation)
> +{
> +	wait_queue_head_t *x = &fence->wait;
> +	unsigned long flags;
> +
> +	/* To prevent unbounded recursion as we traverse the graph

Broken comment style.

> +	 * of kfences, we move the task_list from this ready fence
> +	 * to the tail of the current fence we are signaling.
> +	 */
> +	spin_lock_irqsave_nested(&x->lock, flags, 1 + !!continuation);
> +	if (continuation)
> +		list_splice_tail_init(&x->task_list, continuation);
> +	else while (!list_empty(&x->task_list))
> +		__wake_up_locked_key(x, TASK_NORMAL, &x->task_list);
> +	spin_unlock_irqrestore(&x->lock, flags);
> +}
> +
> +static void __kfence_signal(struct kfence *fence,
> +			    struct list_head *continuation)
> +{
> +	if (!atomic_dec_and_test(&fence->pending))
> +		return;
> +
> +	atomic_dec(&fence->pending);

You decrement twice?

> +	__kfence_wake_up_all(fence, continuation);
> +}
> +
> +/**
> + * kfence_pending - mark the fence as pending a signal

I would say: increment the pending count, requiring one more completion
before the fence is done.

'Mark' completely misses the point. You need to balance these increments
with decrements, its not a boolean state.

> + * @fence: the kfence to be signaled
> + *
> + */
> +void kfence_pending(struct kfence *fence)
> +{
> +	WARN_ON(atomic_inc_return(&fence->pending) <= 1);
> +}
> +EXPORT_SYMBOL_GPL(kfence_pending);


> +/**
> + * kfence_create - create a fence
> + * @gfp: the allowed allocation type
> + *
> + * A fence is created with a reference count of one, and pending a signal.
> + * After you have completed setting up the fence for use, call kfence_signal()
> + * to signal completion.
> + *
> + * Returns the newly allocated fence, or NULL on error.
> + */
> +struct kfence *kfence_create(gfp_t gfp)
> +{
> +	struct kfence *fence;
> +
> +	fence = kmalloc(sizeof(*fence), gfp);
> +	if (!fence)
> +		return NULL;
> +
> +	kfence_init(fence);
> +	return fence;
> +}
> +EXPORT_SYMBOL_GPL(kfence_create);

Why? What is the purpose of this here thing? We never provide allocation
wrappers.

> +
> +/**
> + * kfence_add - set one fence to wait upon another

Since you're going to do a whole lot other kfence_add_$foo() thingies,
why isn't this called kfence_add_kfence() ?

> + * @fence: this kfence
> + * @signaler: target kfence to wait upon
> + * @gfp: the allowed allocation type
> + *
> + * kfence_add() causes the @fence to wait upon completion of @signaler.
> + * Internally the @fence is marked as pending a signal from @signaler.
> + *
> + * Returns 1 if the @fence was added to the waiqueue of @signaler, 0
> + * if @signaler was already complete, or a negative error code.
> + */
> +int kfence_add(struct kfence *fence, struct kfence *signaler, gfp_t gfp)
> +{
> +	wait_queue_t *wq;
> +	unsigned long flags;
> +	int pending;
> +
> +	if (!signaler || kfence_complete(signaler))

Again, wth would you allow adding NULL? That's just horrible.

> +		return 0;
> +
> +	/* The dependency graph must be acyclic */
> +	if (unlikely(kfence_check_if_after(fence, signaler)))
> +		return -EINVAL;
> +
> +	wq = kmalloc(sizeof(*wq), gfp);
> +	if (unlikely(!wq)) {
> +		if (!gfpflags_allow_blocking(gfp))
> +			return -ENOMEM;
> +
> +		kfence_wait(signaler);
> +		return 0;
> +	}
> +
> +	wq->flags = 0;
> +	wq->func = kfence_wake;
> +	wq->private = kfence_get(fence);
> +
> +	kfence_pending(fence);
> +
> +	spin_lock_irqsave(&signaler->wait.lock, flags);
> +	if (likely(!kfence_complete(signaler))) {
> +		__add_wait_queue_tail(&signaler->wait, wq);
> +		pending = 1;
> +	} else {
> +		INIT_LIST_HEAD(&wq->task_list);
> +		kfence_wake(wq, 0, 0, NULL);
> +		pending = 0;
> +	}
> +	spin_unlock_irqrestore(&signaler->wait.lock, flags);
> +
> +	return pending;
> +}
> +EXPORT_SYMBOL_GPL(kfence_add);
> +
> +/**
> + * kfence_add_completion - set the fence to wait upon a completion
> + * @fence: this kfence
> + * @x: target completion to wait upon
> + * @gfp: the allowed allocation type
> + *
> + * kfence_add_completiond() causes the @fence to wait upon a completion.
> + * Internally the @fence is marked as pending a signal from @x.
> + *
> + * Returns 1 if the @fence was added to the waiqueue of @x, 0
> + * if @x was already complete, or a negative error code.
> + */
> +int kfence_add_completion(struct kfence *fence, struct completion *x, gfp_t gfp)
> +{
> +	wait_queue_t *wq;
> +	unsigned long flags;
> +	int pending;
> +
> +	if (!x || completion_done(x))
> +		return 0;
> +
> +	wq = kmalloc(sizeof(*wq), gfp);
> +	if (unlikely(!wq)) {
> +		if (!gfpflags_allow_blocking(gfp))
> +			return -ENOMEM;
> +
> +		wait_for_completion(x);
> +		return 0;
> +	}
> +
> +	wq->flags = 0;
> +	wq->func = kfence_wake;
> +	wq->private = kfence_get(fence);
> +
> +	kfence_pending(fence);
> +
> +	spin_lock_irqsave(&x->wait.lock, flags);
> +	if (likely(!READ_ONCE(x->done))) {
> +		__add_wait_queue_tail(&x->wait, wq);
> +		pending = 1;
> +	} else {
> +		INIT_LIST_HEAD(&wq->task_list);
> +		kfence_wake(wq, 0, 0, NULL);
> +		pending = 0;
> +	}
> +	spin_unlock_irqrestore(&x->wait.lock, flags);
> +
> +	return pending;
> +}
> +EXPORT_SYMBOL_GPL(kfence_add_completion);

It appears to me these two function share a _lot_ of code, surely that
can be reduced a bit?
