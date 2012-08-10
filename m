Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:57681 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab2HJU25 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 16:28:57 -0400
Received: by weyx8 with SMTP id x8so1238233wey.19
        for <linux-media@vger.kernel.org>; Fri, 10 Aug 2012 13:28:56 -0700 (PDT)
Date: Fri, 10 Aug 2012 22:29:16 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: sumit.semwal@linaro.org, rob.clark@linaro.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: Re: [Linaro-mm-sig] [PATCH 2/4] dma-fence: dma-buf synchronization
 (v8 )
Message-ID: <20120810202916.GI5738@phenom.ffwll.local>
References: <20120810145728.5490.44707.stgit@patser.local>
 <20120810145750.5490.5639.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120810145750.5490.5639.stgit@patser.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 10, 2012 at 04:57:52PM +0200, Maarten Lankhorst wrote:
> A dma-fence can be attached to a buffer which is being filled or consumed
> by hw, to allow userspace to pass the buffer without waiting to another
> device.  For example, userspace can call page_flip ioctl to display the
> next frame of graphics after kicking the GPU but while the GPU is still
> rendering.  The display device sharing the buffer with the GPU would
> attach a callback to get notified when the GPU's rendering-complete IRQ
> fires, to update the scan-out address of the display, without having to
> wake up userspace.
> 
> A dma-fence is transient, one-shot deal.  It is allocated and attached
> to one or more dma-buf's.  When the one that attached it is done, with
> the pending operation, it can signal the fence.
> 
>   + dma_fence_signal()
> 
> The dma-buf-mgr handles tracking, and waiting on, the fences associated
> with a dma-buf.
> 
> TODO maybe need some helper fxn for simple devices, like a display-
> only drm/kms device which simply wants to wait for exclusive fence to
> be signaled, and then attach a non-exclusive fence while scanout is in
> progress.
> 
> The one pending on the fence can add an async callback:
>   + dma_fence_add_callback()
> The callback can optionally be cancelled with remove_wait_queue()
> 
> Or wait synchronously (optionally with timeout or interruptible):
>   + dma_fence_wait()
> 
> A default software-only implementation is provided, which can be used
> by drivers attaching a fence to a buffer when they have no other means
> for hw sync.  But a memory backed fence is also envisioned, because it
> is common that GPU's can write to, or poll on some memory location for
> synchronization.  For example:
> 
>   fence = dma_buf_get_fence(dmabuf);
>   if (fence->ops == &bikeshed_fence_ops) {
>     dma_buf *fence_buf;
>     dma_bikeshed_fence_get_buf(fence, &fence_buf, &offset);
>     ... tell the hw the memory location to wait on ...
>   } else {
>     /* fall-back to sw sync * /
>     dma_fence_add_callback(fence, my_cb);
>   }
> 
> On SoC platforms, if some other hw mechanism is provided for synchronizing
> between IP blocks, it could be supported as an alternate implementation
> with it's own fence ops in a similar way.
> 
> To facilitate other non-sw implementations, the enable_signaling callback
> can be used to keep track if a device not supporting hw sync is waiting
> on the fence, and in this case should arrange to call dma_fence_signal()
> at some point after the condition has changed, to notify other devices
> waiting on the fence.  If there are no sw waiters, this can be skipped to
> avoid waking the CPU unnecessarily. The handler of the enable_signaling
> op should take a refcount until the fence is signaled, then release its ref.
> 
> The intention is to provide a userspace interface (presumably via eventfd)
> later, to be used in conjunction with dma-buf's mmap support for sw access
> to buffers (or for userspace apps that would prefer to do their own
> synchronization).

I think the commit message should be cleaned up: Kill the TODO, rip out
the bikeshed_fence and otherwise update it to the latest code.

> 
> v1: Original
> v2: After discussion w/ danvet and mlankhorst on #dri-devel, we decided
>     that dma-fence didn't need to care about the sw->hw signaling path
>     (it can be handled same as sw->sw case), and therefore the fence->ops
>     can be simplified and more handled in the core.  So remove the signal,
>     add_callback, cancel_callback, and wait ops, and replace with a simple
>     enable_signaling() op which can be used to inform a fence supporting
>     hw->hw signaling that one or more devices which do not support hw
>     signaling are waiting (and therefore it should enable an irq or do
>     whatever is necessary in order that the CPU is notified when the
>     fence is passed).
> v3: Fix locking fail in attach_fence() and get_fence()
> v4: Remove tie-in w/ dma-buf..  after discussion w/ danvet and mlankorst
>     we decided that we need to be able to attach one fence to N dma-buf's,
>     so using the list_head in dma-fence struct would be problematic.
> v5: [ Maarten Lankhorst ] Updated for dma-bikeshed-fence and dma-buf-manager.
> v6: [ Maarten Lankhorst ] I removed dma_fence_cancel_callback and some comments
>     about checking if fence fired or not. This is broken by design.
>     waitqueue_active during destruction is now fatal, since the signaller
>     should be holding a reference in enable_signalling until it signalled
>     the fence. Pass the original dma_fence_cb along, and call __remove_wait
>     in the dma_fence_callback handler, so that no cleanup needs to be
>     performed.
> v7: [ Maarten Lankhorst ] Set cb->func and only enable sw signaling if
>     fence wasn't signaled yet, for example for hardware fences that may
>     choose to signal blindly.
> v8: [ Maarten Lankhorst ] Tons of tiny fixes, moved __dma_fence_init to
>     header and fixed include mess. dma-fence.h now includes dma-buf.h
>     All members are now initialized, so kmalloc can be used for
>     allocating a dma-fence. More documentation added.
> 
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

I like the design of this, and especially that it's rather simple ;-)

A few comments to polish the interface, implementation and documentation a
bit below.

> ---
>  Documentation/DocBook/device-drivers.tmpl |    2 
>  drivers/base/Makefile                     |    2 
>  drivers/base/dma-fence.c                  |  268 +++++++++++++++++++++++++++++
>  include/linux/dma-fence.h                 |  124 +++++++++++++
>  4 files changed, 395 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/base/dma-fence.c
>  create mode 100644 include/linux/dma-fence.h
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 7514dbf..36252ac 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -126,6 +126,8 @@ X!Edrivers/base/interface.c
>       </sect1>
>       <sect1><title>Device Drivers DMA Management</title>
>  !Edrivers/base/dma-buf.c
> +!Edrivers/base/dma-fence.c
> +!Iinclude/linux/dma-fence.h
>  !Edrivers/base/dma-coherent.c
>  !Edrivers/base/dma-mapping.c
>       </sect1>
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 5aa2d70..6e9f217 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
>  obj-y			+= power/
>  obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
>  obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
> -obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o
> +obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o
>  obj-$(CONFIG_ISA)	+= isa.o
>  obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
>  obj-$(CONFIG_NUMA)	+= node.o
> diff --git a/drivers/base/dma-fence.c b/drivers/base/dma-fence.c
> new file mode 100644
> index 0000000..93448e4
> --- /dev/null
> +++ b/drivers/base/dma-fence.c
> @@ -0,0 +1,268 @@
> +/*
> + * Fence mechanism for dma-buf to allow for asynchronous dma access
> + *
> + * Copyright (C) 2012 Texas Instruments
> + * Author: Rob Clark <rob.clark@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/sched.h>
> +#include <linux/export.h>
> +#include <linux/dma-fence.h>
> +
> +/**
> + * dma_fence_signal - signal completion of a fence
> + * @fence: the fence to signal
> + *
> + * All registered callbacks will be called directly (synchronously) and
> + * all blocked waters will be awoken. This should be always be called on
> + * software only fences, or alternatively be called after
> + * dma_fence_ops::enable_signaling is called.

I think we need to be cleare here when dma_fence_signal can be called:
- for a sw-only fence (i.e. created with dma_fence_create)
  dma_fence_signal _must_ be called under all circumstances.
- for any other fences, dma_fence_signal may be called, but it _must_ be
  called once the ->enable_signalling func has been called and return 0
  (i.e. success).
- it may be called only _once_.

> + */
> +int dma_fence_signal(struct dma_fence *fence)
> +{
> +	unsigned long flags;
> +	int ret = -EINVAL;
> +
> +	if (WARN_ON(!fence))
> +		return -EINVAL;
> +
> +	spin_lock_irqsave(&fence->event_queue.lock, flags);
> +	if (!fence->signaled) {
> +		fence->signaled = true;
> +		__wake_up_locked_key(&fence->event_queue, TASK_NORMAL,
> +				     &fence->event_queue);
> +		ret = 0;
> +	} else
> +		WARN(1, "Already signaled");
> +	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dma_fence_signal);
> +
> +static void release_fence(struct kref *kref)
> +{
> +	struct dma_fence *fence =
> +			container_of(kref, struct dma_fence, refcount);
> +
> +	BUG_ON(waitqueue_active(&fence->event_queue));
> +
> +	if (fence->ops->release)
> +		fence->ops->release(fence);
> +
> +	kfree(fence);
> +}
> +
> +/**
> + * dma_fence_put - decreases refcount of the fence
> + * @fence:	[in]	fence to reduce refcount of
> + */
> +void dma_fence_put(struct dma_fence *fence)
> +{
> +	if (WARN_ON(!fence))
> +		return;
> +	kref_put(&fence->refcount, release_fence);
> +}
> +EXPORT_SYMBOL_GPL(dma_fence_put);
> +
> +/**
> + * dma_fence_get - increases refcount of the fence
> + * @fence:	[in]	fence to increase refcount of
> + */
> +void dma_fence_get(struct dma_fence *fence)
> +{
> +	if (WARN_ON(!fence))
> +		return;
> +	kref_get(&fence->refcount);
> +}
> +EXPORT_SYMBOL_GPL(dma_fence_get);
> +
> +static int check_signaling(struct dma_fence *fence)
> +{
> +	bool enable_signaling = false, signaled;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&fence->event_queue.lock, flags);
> +	signaled = fence->signaled;
> +	if (!signaled && !fence->needs_sw_signal)
> +		enable_signaling = fence->needs_sw_signal = true;
> +	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
> +
> +	if (enable_signaling) {
> +		int ret;
> +
> +		/* At this point, if enable_signaling returns any error
> +		 * a wakeup has to be performanced regardless.
> +		 * -ENOENT signals fence was already signaled. Any other error
> +		 * inidicates a catastrophic hardware error.
> +		 *
> +		 * If any hardware error occurs, nothing can be done against
> +		 * it, so it's treated like the fence was already signaled.
> +		 * No synchronization can be performed, so we have to assume
> +		 * the fence was already signaled.
> +		 */
> +		ret = fence->ops->enable_signaling(fence);
> +		if (ret) {
> +			signaled = true;
> +			dma_fence_signal(fence);

I think we should call dma_fence_signal only for -ENOENT and pass all
other errors back as-is. E.g. on -ENOMEM or so we might want to retry ...
> +		}
> +	}
> +
> +	if (!signaled)
> +		return 0;
> +	else
> +		return -ENOENT;
> +}
> +
> +static int
> +__dma_fence_wake_func(wait_queue_t *wait, unsigned mode, int flags, void *key)
> +{
> +	struct dma_fence_cb *cb =
> +			container_of(wait, struct dma_fence_cb, base);
> +
> +	__remove_wait_queue(key, wait);
> +	return cb->func(cb, wait->private);
> +}
> +
> +/**
> + * dma_fence_add_callback - add a callback to be called when the fence
> + * is signaled
> + *
> + * @fence:	[in]	the fence to wait on
> + * @cb:		[in]	the callback to register
> + * @func:	[in]	the function to call
> + * @priv:	[in]	the argument to pass to function
> + *
> + * cb will be initialized by dma_fence_add_callback, no initialization
> + * by the caller is required. Any number of callbacks can be registered
> + * to a fence, but a callback can only be registered to one fence at a time.
> + *
> + * Note that the callback can be called from an atomic context.  If
> + * fence is already signaled, this function will return -ENOENT (and
> + * *not* call the callback)
> + */
> +int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
> +			   dma_fence_func_t func, void *priv)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	if (WARN_ON(!fence || !func))
> +		return -EINVAL;
> +
> +	ret = check_signaling(fence);
> +
> +	spin_lock_irqsave(&fence->event_queue.lock, flags);
> +	if (!ret && fence->signaled)
> +		ret = -ENOENT;

The locking here is a bit suboptimal: We grab the fence spinlock once in
check_signalling and then again here. We should combine this into one
critical section.

> +
> +	if (!ret) {
> +		cb->base.flags = 0;
> +		cb->base.func = __dma_fence_wake_func;
> +		cb->base.private = priv;
> +		cb->fence = fence;
> +		cb->func = func;
> +		__add_wait_queue(&fence->event_queue, &cb->base);
> +	}
> +	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(dma_fence_add_callback);

I think for api completenes we should also have a
dma_fence_remove_callback function.
> +
> +/**
> + * dma_fence_wait - wait for a fence to be signaled
> + *
> + * @fence:	[in]	The fence to wait on
> + * @intr:	[in]	if true, do an interruptible wait
> + * @timeout:	[in]	absolute time for timeout, in jiffies.

I don't quite like this, I think we should keep the styl of all other
wait_*_timeout functions and pass the arg as timeout in jiffies (and also
the same return semantics). Otherwise well have funny code that needs to
handle return values differently depending upon whether it waits upon a
dma_fence or a native object (where it would us the wait_*_timeout
functions directly).

Also, I think we should add the non-_timeout variants, too, just for
completeness.

> + *
> + * Returns 0 on success, -EBUSY if a timeout occured,
> + * -ERESTARTSYS if the wait was interrupted by a signal.
> + */
> +int dma_fence_wait(struct dma_fence *fence, bool intr, unsigned long timeout)
> +{
> +	unsigned long cur;
> +	int ret;
> +
> +	if (WARN_ON(!fence))
> +		return -EINVAL;
> +
> +	cur = jiffies;
> +	if (time_after_eq(cur, timeout))
> +		return -EBUSY;
> +
> +	timeout -= cur;
> +
> +	ret = check_signaling(fence);
> +	if (ret == -ENOENT)
> +		return 0;
> +	else if (ret)
> +		return ret;
> +
> +	if (intr)
> +		ret = wait_event_interruptible_timeout(fence->event_queue,
> +						       fence->signaled,
> +						       timeout);

We have a race here, since fence->signaled is proctected by
fenc->event_queu.lock. There's a special variant of the wait_event macros
that automatically drops a spinlock at the right time, which would fit
here. Again, like for the callback function I think you then need to
open-code check_signalling to avoid taking the spinlock twice.

> +	else
> +		ret = wait_event_timeout(fence->event_queue,
> +				fence->signaled, timeout);
> +
> +	if (ret > 0)
> +		return 0;
> +	else if (!ret)
> +		return -EBUSY;
> +	else
> +		return ret;
> +}
> +EXPORT_SYMBOL_GPL(dma_fence_wait);
> +
> +static int sw_enable_signaling(struct dma_fence *fence)
> +{
> +	/* dma_fence_create sets needs_sw_signal,
> +	 * so this should never be called
> +	 */
> +	WARN_ON_ONCE(1);
> +	return 0;
> +}
> +
> +static const struct dma_fence_ops sw_fence_ops = {
> +	.enable_signaling = sw_enable_signaling,
> +};
> +
> +/**
> + * dma_fence_create - create a simple sw-only fence
> + * @priv:	[in]	the value to use for the priv member
> + *
> + * This fence only supports signaling from/to CPU.  Other implementations
> + * of dma-fence can be used to support hardware to hardware signaling, if
> + * supported by the hardware, and use the dma_fence_helper_* functions for
> + * compatibility with other devices that only support sw signaling.
> + */
> +struct dma_fence *dma_fence_create(void *priv)
> +{
> +	struct dma_fence *fence;
> +
> +	fence = kmalloc(sizeof(struct dma_fence), GFP_KERNEL);
> +	if (!fence)
> +		return NULL;
> +
> +	__dma_fence_init(fence, &sw_fence_ops, priv);
> +	fence->needs_sw_signal = true;
> +
> +	return fence;
> +}
> +EXPORT_SYMBOL_GPL(dma_fence_create);
> diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
> new file mode 100644
> index 0000000..e0ceddd
> --- /dev/null
> +++ b/include/linux/dma-fence.h
> @@ -0,0 +1,124 @@
> +/*
> + * Fence mechanism for dma-buf to allow for asynchronous dma access
> + *
> + * Copyright (C) 2012 Texas Instruments
> + * Author: Rob Clark <rob.clark@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef __DMA_FENCE_H__
> +#define __DMA_FENCE_H__
> +
> +#include <linux/err.h>
> +#include <linux/list.h>
> +#include <linux/wait.h>
> +#include <linux/list.h>
> +#include <linux/dma-buf.h>
> +
> +struct dma_fence;
> +struct dma_fence_ops;
> +struct dma_fence_cb;
> +
> +/**
> + * struct dma_fence - software synchronization primitive
> + * @refcount: refcount for this fence
> + * @ops: dma_fence_ops associated with this fence
> + * @priv: fence specific private data
> + * @event_queue: event queue used for signaling fence
> + * @signaled: whether this fence has been completed yet
> + * @needs_sw_signal: whether dma_fence_ops::enable_signaling
> + *                   has been called yet
> + *
> + * Read Documentation/dma-buf-synchronization.txt for usage.
> + */
> +struct dma_fence {
> +	struct kref refcount;
> +	const struct dma_fence_ops *ops;
> +	wait_queue_head_t event_queue;
> +	void *priv;
> +	bool signaled:1;
> +	bool needs_sw_signal:1;

I guess a comment here is in order that signaled and needs_sw_signal is
protected by event_queue.lock. Also, since the compiler is rather free to
do crazy stuff with bitfields, I think it's preferred style to use an
unsigned long and explicit bit #defines (ton ensure the compiler doesn't
generate loads/stores that leak to other members of the struct).

> +};
> +
> +typedef int (*dma_fence_func_t)(struct dma_fence_cb *cb, void *priv);
> +
> +/**
> + * struct dma_fence_cb - callback for dma_fence_add_callback
> + * @base: wait_queue_t added to event_queue
> + * @func: dma_fence_func_t to call
> + * @fence: fence this dma_fence_cb was used on
> + *
> + * This struct will be initialized by dma_fence_add_callback, additional
> + * data can be passed along by embedding dma_fence_cb in another struct.
> + */
> +struct dma_fence_cb {
> +	wait_queue_t base;
> +	dma_fence_func_t func;
> +	struct dma_fence *fence;
> +};
> +
> +/**
> + * struct dma_fence_ops - operations implemented for dma-fence
> + * @enable_signaling: enable software signaling of fence
> + * @release: [optional] called on destruction of fence
> + *
> + * Notes on enable_signaling:
> + * For fence implementations that have the capability for hw->hw
> + * signaling, they can implement this op to enable the necessary
> + * irqs, or insert commands into cmdstream, etc.  This is called
> + * in the first wait() or add_callback() path to let the fence
> + * implementation know that there is another driver waiting on
> + * the signal (ie. hw->sw case).
> + *
> + * A return value of -ENOENT will indicate that the fence has
> + * already passed. Any other errors will be treated as -ENOENT,
> + * and can happen because of hardware failure.
> + */
> +

I think we need to specify the calling contexts of these two.

> +struct dma_fence_ops {
> +	int (*enable_signaling)(struct dma_fence *fence);

I think we should mandate that enable_signalling can be called from atomic
context, but not irq context (since I don't see a use-case for calling
this from irq context).

> +	void (*release)(struct dma_fence *fence);

Since a waiter might call ->release as a reaction to a signal, I think the
release callback must be able to handle any calling context, and
especially anything that calls dma_fence_signal.

> +};
> +
> +struct dma_fence *dma_fence_create(void *priv);
> +
> +/**
> + * __dma_fence_init - Initialize a custom dma_fence.
> + * @fence:	[in]	The fence to initialize
> + * @ops:	[in]	The dma_fence_ops for operations on this fence.
> + * @priv:	[in]	The value to use for the priv member.
> + */
> +static inline void
> +__dma_fence_init(struct dma_fence *fence,
> +		 const struct dma_fence_ops *ops, void *priv)
> +{
> +	WARN_ON(!ops || !ops->enable_signaling);
> +
> +	kref_init(&fence->refcount);
> +	fence->ops = ops;
> +	fence->priv = priv;
> +	fence->needs_sw_signal = false;
> +	fence->signaled = false;
> +	init_waitqueue_head(&fence->event_queue);
> +}
> +
> +void dma_fence_get(struct dma_fence *fence);
> +void dma_fence_put(struct dma_fence *fence);
> +
> +int dma_fence_signal(struct dma_fence *fence);
> +int dma_fence_wait(struct dma_fence *fence, bool intr, unsigned long timeout);
> +int dma_fence_add_callback(struct dma_fence *fence, struct dma_fence_cb *cb,
> +			   dma_fence_func_t func, void *priv);
> +
> +#endif /* __DMA_FENCE_H__ */
> 
> 
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig

-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
