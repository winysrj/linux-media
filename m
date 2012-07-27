Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:33143 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab2G0OOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 10:14:24 -0400
Subject: [RFC PATCH 1/3] dma-fence: dma-buf synchronization (v5)
To: linaro-mm-sig@lists.linaro.org, rob.clark@linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: patches@linaro.org, linux-kernel@vger.kernel.org,
	sumit.semwal@linaro.org
Date: Fri, 27 Jul 2012 15:39:54 +0200
Message-ID: <20120727133952.2036.61330.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A dma-fence can be attached to a buffer which is being filled or consumed
by hw, to allow userspace to pass the buffer without waiting to another
device.  For example, userspace can call page_flip ioctl to display the
next frame of graphics after kicking the GPU but while the GPU is still
rendering.  The display device sharing the buffer with the GPU would
attach a callback to get notified when the GPU's rendering-complete IRQ
fires, to update the scan-out address of the display, without having to
wake up userspace.

A dma-fence is transient, one-shot deal.  It is allocated and attached
to one or more dma-buf's.  When the one that attached it is done, with
the pending operation, it can signal the fence.

  + dma_fence_signal()

The dma-buf-mgr handles tracking, and waiting on, the fences associated
with a dma-buf.

TODO maybe need some helper fxn for simple devices, like a display-
only drm/kms device which simply wants to wait for exclusive fence to
be signaled, and then attach a non-exclusive fence while scanout is in
progress.

The one pending on the fence can add an async callback (and optionally
cancel it.. for example, to recover from GPU hangs):

  + dma_fence_add_callback()
  + dma_fence_cancel_callback()

Or wait synchronously (optionally with timeout or from atomic context):

  + dma_fence_wait()

A default software-only implementation is provided, which can be used
by drivers attaching a fence to a buffer when they have no other means
for hw sync.  But a memory backed fence is also envisioned, because it
is common that GPU's can write to, or poll on some memory location for
synchronization.  For example:

  fence = dma_buf_get_fence(dmabuf);
  if (fence->ops == &bikeshed_fence_ops) {
    dma_buf *fence_buf;
    dma_bikeshed_fence_get_buf(fence, &fence_buf, &offset);
    ... tell the hw the memory location to wait on ...
  } else {
    /* fall-back to sw sync * /
    dma_fence_add_callback(fence, my_cb);
  }

On SoC platforms, if some other hw mechanism is provided for synchronizing
between IP blocks, it could be supported as an alternate implementation
with it's own fence ops in a similar way.

To facilitate other non-sw implementations, the enable_signaling callback
can be used to keep track if a device not supporting hw sync is waiting
on the fence, and in this case should arrange to call dma_fence_signal()
at some point after the condition has changed, to notify other devices
waiting on the fence.  If there are no sw waiters, this can be skipped to
avoid waking the CPU unnecessarily.

The intention is to provide a userspace interface (presumably via eventfd)
later, to be used in conjunction with dma-buf's mmap support for sw access
to buffers (or for userspace apps that would prefer to do their own
synchronization).

v1: Original
v2: After discussion w/ danvet and mlankhorst on #dri-devel, we decided
    that dma-fence didn't need to care about the sw->hw signaling path
    (it can be handled same as sw->sw case), and therefore the fence->ops
    can be simplified and more handled in the core.  So remove the signal,
    add_callback, cancel_callback, and wait ops, and replace with a simple
    enable_signaling() op which can be used to inform a fence supporting
    hw->hw signaling that one or more devices which do not support hw
    signaling are waiting (and therefore it should enable an irq or do
    whatever is necessary in order that the CPU is notified when the
    fence is passed).
v3: Fix locking fail in attach_fence() and get_fence()
v4: Remove tie-in w/ dma-buf..  after discussion w/ danvet and mlankorst
    we decided that we need to be able to attach one fence to N dma-buf's,
    so using the list_head in dma-fence struct would be problematic.
v5: [ Maarten Lankhorst ] Updated for dma-bikeshed-fence and dma-buf-manager.
---
 drivers/base/Makefile     |    2 
 drivers/base/dma-fence.c  |  317 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-fence.h |  123 +++++++++++++++++
 3 files changed, 441 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/dma-fence.c
 create mode 100644 include/linux/dma-fence.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5aa2d70..6e9f217 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-fence.c b/drivers/base/dma-fence.c
new file mode 100644
index 0000000..6798dc4
--- /dev/null
+++ b/drivers/base/dma-fence.c
@@ -0,0 +1,317 @@
+/*
+ * Fence mechanism for dma-buf to allow for asynchronous dma access
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Author: Rob Clark <rob.clark@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/export.h>
+#include <linux/dma-fence.h>
+
+/**
+ * dma_fence_signal - Signal a fence.
+ *
+ * @fence:  The fence to signal
+ *
+ * All registered callbacks will be called directly (synchronously) and
+ * all blocked waters will be awoken.
+ *
+ * TODO: any value in adding a dma_fence_cancel(), for example to recov
+ * from hung gpu?  It would behave like dma_fence_signal() but return
+ * an error to waiters and cb's to let them know that the condition they
+ * are waiting for will never happen.
+ */
+int dma_fence_signal(struct dma_fence *fence)
+{
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (WARN_ON(!fence))
+		return -EINVAL;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (!fence->signaled) {
+		fence->signaled = true;
+		wake_up_all_locked(&fence->event_queue);
+		ret = 0;
+	} else WARN(1, "Already signaled");
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_fence_signal);
+
+static void release_fence(struct kref *kref)
+{
+	struct dma_fence *fence =
+			container_of(kref, struct dma_fence, refcount);
+
+	WARN_ON(waitqueue_active(&fence->event_queue));
+	if (fence->ops->release)
+		fence->ops->release(fence);
+
+	kfree(fence);
+}
+
+/**
+ * dma_fence_put - Release a reference to the fence.
+ */
+void dma_fence_put(struct dma_fence *fence)
+{
+	WARN_ON(!fence);
+	kref_put(&fence->refcount, release_fence);
+}
+EXPORT_SYMBOL_GPL(dma_fence_put);
+
+/**
+ * dma_fence_get - Take a reference to the fence.
+ *
+ * In most cases this is used only internally by dma-fence.
+ */
+void dma_fence_get(struct dma_fence *fence)
+{
+	WARN_ON(!fence);
+	kref_get(&fence->refcount);
+}
+EXPORT_SYMBOL_GPL(dma_fence_get);
+
+static int check_signaling(struct dma_fence *fence)
+{
+	bool enable_signaling = false, signaled;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (!fence->needs_sw_signal)
+		enable_signaling = fence->needs_sw_signal = true;
+	signaled = fence->signaled;
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	if (enable_signaling) {
+		int ret;
+
+		/* At this point, if enable_signaling returns any error
+		 * a wakeup has to be performanced regardless.
+		 * -ENOENT signals fence was already signaled. Any other error
+		 * inidicates a catastrophic hardware error.
+		 *
+		 * If any hardware error occurs, nothing can be done against
+		 * it, so it's treated like the fence was already signaled.
+		 * No synchronization can be performed, so we have to assume
+		 * the fence was already signaled.
+		 */
+		ret = fence->ops->enable_signaling(fence);
+		if (ret) {
+			signaled = true;
+			dma_fence_signal(fence);
+		}
+	}
+
+	if (!signaled)
+		return 0;
+	else
+		return -ENOENT;
+}
+
+/**
+ * dma_fence_add_callback - Add a callback to be called when the fence
+ * is signaled.
+ *
+ * @fence: The fence to wait on
+ * @cb: The callback to register
+ *
+ * Any number of callbacks can be registered to a fence, but a callback
+ * can only be registered to once fence at a time.
+ *
+ * Note that the callback can be called from an atomic context.  If
+ * fence is already signaled, this function will return -ENOENT (and
+ * *not* call the callback)
+ */
+int dma_fence_add_callback(struct dma_fence *fence,
+		struct dma_fence_cb *cb)
+{
+	unsigned long flags;
+	int ret;
+
+	if (WARN_ON(!fence || !cb))
+		return -EINVAL;
+
+	ret = check_signaling(fence);
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (!ret && !fence->signaled) {
+		cb->fence = fence;
+		__add_wait_queue(&fence->event_queue, &cb->base);
+		ret = 0;
+	} else if (!ret)
+		ret = -ENOENT;
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_fence_add_callback);
+
+/**
+ * dma_fence_cancel_callback - Remove a previously registered callback.
+ *
+ * @cb: The callback to unregister
+ *
+ * The callback will not be called after this function returns, but could
+ * be called before this function returns.
+ */
+int dma_fence_cancel_callback(struct dma_fence_cb *cb)
+{
+	struct dma_fence *fence;
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (WARN_ON(!cb))
+		return -EINVAL;
+
+	fence = cb->fence;
+
+	spin_lock_irqsave(&fence->event_queue.lock, flags);
+	if (fence) {
+		__remove_wait_queue(&fence->event_queue, &cb->base);
+		cb->fence = NULL;
+		ret = 0;
+	}
+	spin_unlock_irqrestore(&fence->event_queue.lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_fence_cancel_callback);
+
+/**
+ * dma_fence_wait - Wait for a fence to be signaled.
+ *
+ * @fence: The fence to wait on
+ * @interruptible: if true, do an interruptible wait
+ * @timeout: absolute time for timeout, in jiffies.
+ *
+ * Returns 0 on success, -EBUSY if a timeout occured,
+ * -ERESTARTSYS if the wait was interrupted by a signal.
+ */
+int dma_fence_wait(struct dma_fence *fence, bool interruptible, unsigned long timeout)
+{
+	unsigned long cur;
+	int ret;
+
+	if (WARN_ON(!fence))
+		return -EINVAL;
+
+	cur = jiffies;
+	if (time_after_eq(cur, timeout))
+		return -EBUSY;
+
+	timeout -= cur;
+
+	ret = check_signaling(fence);
+	if (ret == -ENOENT)
+		return 0;
+	else if (ret)
+		return ret;
+
+	if (interruptible)
+		ret = wait_event_interruptible_timeout(fence->event_queue,
+						       fence->signaled,
+						       timeout);
+	else
+		ret = wait_event_timeout(fence->event_queue,
+				fence->signaled, timeout);
+
+	WARN(1, "wait_event_timeout(%u) returns %i", interruptible, ret);
+	if (ret > 0)
+		return 0;
+	else if (!ret)
+		return -EBUSY;
+	else
+		return ret;
+}
+EXPORT_SYMBOL_GPL(dma_fence_wait);
+
+int __dma_fence_wake_func(wait_queue_t *wait, unsigned mode,
+		int flags, void *key)
+{
+	struct dma_fence_cb *cb =
+			container_of(wait, struct dma_fence_cb, base);
+	struct dma_fence *fence = cb->fence;
+	int ret;
+
+	ret = cb->func(cb, fence);
+	cb->fence = NULL;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__dma_fence_wake_func);
+
+/*
+ * Helpers intended to be used by the ops of the dma_fence implementation:
+ *
+ * NOTE: helpers and fxns intended to be used by other dma-fence
+ * implementations are not exported..  I'm not really sure if it makes
+ * sense to have a dma-fence implementation that is itself a module.
+ */
+
+void __dma_fence_init(struct dma_fence *fence, struct dma_fence_ops *ops, void *priv)
+{
+	WARN_ON(!ops || !ops->enable_signaling);
+
+	kref_init(&fence->refcount);
+	fence->ops = ops;
+	fence->priv = priv;
+	init_waitqueue_head(&fence->event_queue);
+}
+EXPORT_SYMBOL_GPL(__dma_fence_init);
+
+/*
+ * Pure sw implementation for dma-fence.  The CPU always gets involved.
+ */
+
+static int sw_enable_signaling(struct dma_fence *fence)
+{
+	/*
+	 * pure sw, no irq's to enable, because the fence creator will
+	 * always call dma_fence_signal()
+	 */
+	return 0;
+}
+
+static struct dma_fence_ops sw_fence_ops = {
+	.enable_signaling = sw_enable_signaling,
+};
+
+/**
+ * dma_fence_create - Create a simple sw-only fence.
+ *
+ * This fence only supports signaling from/to CPU.  Other implementations
+ * of dma-fence can be used to support hardware to hardware signaling, if
+ * supported by the hardware, and use the dma_fence_helper_* functions for
+ * compatibility with other devices that only support sw signaling.
+ */
+struct dma_fence *dma_fence_create(void)
+{
+	struct dma_fence *fence;
+
+	fence = kzalloc(sizeof(struct dma_fence), GFP_KERNEL);
+	if (!fence)
+		return ERR_PTR(-ENOMEM);
+
+	__dma_fence_init(fence, &sw_fence_ops, 0);
+
+	return fence;
+}
+EXPORT_SYMBOL_GPL(dma_fence_create);
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
new file mode 100644
index 0000000..648f136
--- /dev/null
+++ b/include/linux/dma-fence.h
@@ -0,0 +1,123 @@
+/*
+ * Fence mechanism for dma-buf to allow for asynchronous dma access
+ *
+ * Copyright (C) 2012 Texas Instruments
+ * Author: Rob Clark <rob.clark@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __DMA_FENCE_H__
+#define __DMA_FENCE_H__
+
+#include <linux/err.h>
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/list.h>
+#include <linux/dma-buf.h>
+
+struct dma_fence;
+struct dma_fence_ops;
+struct dma_fence_cb;
+
+struct dma_fence {
+	struct kref refcount;
+	struct dma_fence_ops *ops;
+	wait_queue_head_t event_queue;
+	void *priv;
+
+	/* has this fence been signaled yet? */
+	bool signaled : 1;
+
+	/* do we have one or more waiters or callbacks? */
+	bool needs_sw_signal : 1;
+};
+
+typedef int (*dma_fence_func_t)(struct dma_fence_cb *cb,
+		struct dma_fence *fence);
+
+struct dma_fence_cb {
+	wait_queue_t base;
+	dma_fence_func_t func;
+
+	/*
+	 * This is initialized when the cb is added, and NULL'd when it
+	 * is canceled or expired, so can be used to for error checking
+	 * if the cb is already pending.  A dma_fence_cb can be pending
+	 * on at most one fence at a time.
+	 */
+	struct dma_fence *fence;
+};
+
+struct dma_fence_ops {
+	/**
+	 * For fence implementations that have the capability for hw->hw
+	 * signaling, they can implement this op to enable the necessary
+	 * irqs, or insert commands into cmdstream, etc.  This is called
+	 * in the first wait() or add_callback() path to let the fence
+	 * implementation know that there is another driver waiting on
+	 * the signal (ie. hw->sw case).
+	 *
+	 * A return value of -ENOENT will indicate that the fence has
+	 * already passed.
+	 */
+	int (*enable_signaling)(struct dma_fence *fence);
+	void (*release)(struct dma_fence *fence);
+};
+
+int __dma_fence_wake_func(wait_queue_t *wait, unsigned mode,
+		int flags, void *key);
+
+#define DMA_FENCE_CB_INITIALIZER(cb_func) {                \
+		.base = { .func = __dma_fence_wake_func },  \
+		.func = (cb_func),                          \
+	}
+
+#define DECLARE_DMA_FENCE_CB(name, cb_func)                   \
+		struct dma_fence_cb name = DMA_FENCE_CB_INITIALIZER(cb_func)
+
+
+/*
+ * TODO does it make sense to be able to enable dma-fence without dma-buf,
+ * or visa versa?
+ */
+#ifdef CONFIG_DMA_SHARED_BUFFER
+
+/* create a basic (pure sw) fence: */
+struct dma_fence *dma_fence_create(void);
+
+/* intended to be used by other dma_fence implementations: */
+void __dma_fence_init(struct dma_fence *fence, struct dma_fence_ops *ops, void *priv);
+
+void dma_fence_get(struct dma_fence *fence);
+void dma_fence_put(struct dma_fence *fence);
+int dma_fence_signal(struct dma_fence *fence);
+
+int dma_fence_add_callback(struct dma_fence *fence,
+		struct dma_fence_cb *cb);
+int dma_fence_cancel_callback(struct dma_fence_cb *cb);
+int dma_fence_wait(struct dma_fence *fence, bool interruptible, unsigned long timeout);
+
+/* helpers intended to be used by the ops of the dma_fence implementation: */
+int dma_fence_helper_signal(struct dma_fence *fence);
+int dma_fence_helper_add_callback(struct dma_fence *fence,
+		struct dma_fence_cb *cb);
+int dma_fence_helper_cancel_callback(struct dma_fence_cb *cb);
+int dma_fence_helper_wait(struct dma_fence *fence, bool interruptible,
+		long timeout);
+
+#else
+// TODO
+#endif /* CONFIG_DMA_SHARED_BUFFER */
+
+#endif /* __DMA_FENCE_H__ */

