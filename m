Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:51253 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbeEDOGw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:06:52 -0400
Received: by mail-wm0-f45.google.com with SMTP id j4so4265214wme.1
        for <linux-media@vger.kernel.org>; Fri, 04 May 2018 07:06:51 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-fence: Polish kernel-doc for dma-fence.c
Date: Fri,  4 May 2018 16:06:43 +0200
Message-Id: <20180504140643.27365-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20180503142603.28513-16-daniel.vetter@ffwll.ch>
References: <20180503142603.28513-16-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Intro section that links to how this is exposed to userspace.
- Lots more hyperlinks.
- Minor clarifications and style polish

v2: Add misplaced hunk of kerneldoc from a different patch.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
---
 Documentation/driver-api/dma-buf.rst |   6 ++
 drivers/dma-buf/dma-fence.c          | 147 +++++++++++++++++++--------
 2 files changed, 109 insertions(+), 44 deletions(-)

diff --git a/Documentation/driver-api/dma-buf.rst b/Documentation/driver-api/dma-buf.rst
index dc384f2f7f34..b541e97c7ab1 100644
--- a/Documentation/driver-api/dma-buf.rst
+++ b/Documentation/driver-api/dma-buf.rst
@@ -130,6 +130,12 @@ Reservation Objects
 DMA Fences
 ----------
 
+.. kernel-doc:: drivers/dma-buf/dma-fence.c
+   :doc: DMA fences overview
+
+DMA Fences Functions Reference
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
 .. kernel-doc:: drivers/dma-buf/dma-fence.c
    :export:
 
diff --git a/drivers/dma-buf/dma-fence.c b/drivers/dma-buf/dma-fence.c
index 7a92f85a4cec..1551ca7df394 100644
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -38,12 +38,43 @@ EXPORT_TRACEPOINT_SYMBOL(dma_fence_enable_signal);
  */
 static atomic64_t dma_fence_context_counter = ATOMIC64_INIT(0);
 
+/**
+ * DOC: DMA fences overview
+ *
+ * DMA fences, represented by &struct dma_fence, are the kernel internal
+ * synchronization primitive for DMA operations like GPU rendering, video
+ * encoding/decoding, or displaying buffers on a screen.
+ *
+ * A fence is initialized using dma_fence_init() and completed using
+ * dma_fence_signal(). Fences are associated with a context, allocated through
+ * dma_fence_context_alloc(), and all fences on the same context are
+ * fully ordered.
+ *
+ * Since the purposes of fences is to facilitate cross-device and
+ * cross-application synchronization, there's multiple ways to use one:
+ *
+ * - Individual fences can be exposed as a &sync_file, accessed as a file
+ *   descriptor from userspace, created by calling sync_file_create(). This is
+ *   called explicit fencing, since userspace passes around explicit
+ *   synchronization points.
+ *
+ * - Some subsystems also have their own explicit fencing primitives, like
+ *   &drm_syncobj. Compared to &sync_file, a &drm_syncobj allows the underlying
+ *   fence to be updated.
+ *
+ * - Then there's also implicit fencing, where the synchronization points are
+ *   implicitly passed around as part of shared &dma_buf instances. Such
+ *   implicit fences are stored in &struct reservation_object through the
+ *   &dma_buf.resv pointer.
+ */
+
 /**
  * dma_fence_context_alloc - allocate an array of fence contexts
- * @num:	[in]	amount of contexts to allocate
+ * @num: amount of contexts to allocate
  *
- * This function will return the first index of the number of fences allocated.
- * The fence context is used for setting fence->context to a unique number.
+ * This function will return the first index of the number of fence contexts
+ * allocated.  The fence context is used for setting &dma_fence.context to a
+ * unique number by passing the context to dma_fence_init().
  */
 u64 dma_fence_context_alloc(unsigned num)
 {
@@ -59,10 +90,14 @@ EXPORT_SYMBOL(dma_fence_context_alloc);
  * Signal completion for software callbacks on a fence, this will unblock
  * dma_fence_wait() calls and run all the callbacks added with
  * dma_fence_add_callback(). Can be called multiple times, but since a fence
- * can only go from unsignaled to signaled state, it will only be effective
- * the first time.
+ * can only go from the unsignaled to the signaled state and not back, it will
+ * only be effective the first time.
+ *
+ * Unlike dma_fence_signal(), this function must be called with &dma_fence.lock
+ * held.
  *
- * Unlike dma_fence_signal, this function must be called with fence->lock held.
+ * Returns 0 on success and a negative error value when @fence has been
+ * signalled already.
  */
 int dma_fence_signal_locked(struct dma_fence *fence)
 {
@@ -102,8 +137,11 @@ EXPORT_SYMBOL(dma_fence_signal_locked);
  * Signal completion for software callbacks on a fence, this will unblock
  * dma_fence_wait() calls and run all the callbacks added with
  * dma_fence_add_callback(). Can be called multiple times, but since a fence
- * can only go from unsignaled to signaled state, it will only be effective
- * the first time.
+ * can only go from the unsignaled to the signaled state and not back, it will
+ * only be effective the first time.
+ *
+ * Returns 0 on success and a negative error value when @fence has been
+ * signalled already.
  */
 int dma_fence_signal(struct dma_fence *fence)
 {
@@ -136,9 +174,9 @@ EXPORT_SYMBOL(dma_fence_signal);
 /**
  * dma_fence_wait_timeout - sleep until the fence gets signaled
  * or until timeout elapses
- * @fence:	[in]	the fence to wait on
- * @intr:	[in]	if true, do an interruptible wait
- * @timeout:	[in]	timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
+ * @fence: the fence to wait on
+ * @intr: if true, do an interruptible wait
+ * @timeout: timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
  *
  * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or the
  * remaining timeout in jiffies on success. Other error values may be
@@ -148,6 +186,8 @@ EXPORT_SYMBOL(dma_fence_signal);
  * directly or indirectly (buf-mgr between reservation and committing)
  * holds a reference to the fence, otherwise the fence might be
  * freed before return, resulting in undefined behavior.
+ *
+ * See also dma_fence_wait() and dma_fence_wait_any_timeout().
  */
 signed long
 dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
@@ -167,6 +207,13 @@ dma_fence_wait_timeout(struct dma_fence *fence, bool intr, signed long timeout)
 }
 EXPORT_SYMBOL(dma_fence_wait_timeout);
 
+/**
+ * dma_fence_release - default relese function for fences
+ * @kref: &dma_fence.recfount
+ *
+ * This is the default release functions for &dma_fence. Drivers shouldn't call
+ * this directly, but instead call dma_fence_put().
+ */
 void dma_fence_release(struct kref *kref)
 {
 	struct dma_fence *fence =
@@ -184,6 +231,13 @@ void dma_fence_release(struct kref *kref)
 }
 EXPORT_SYMBOL(dma_fence_release);
 
+/**
+ * dma_fence_free - default release function for &dma_fence.
+ * @fence: fence to release
+ *
+ * This is the default implementation for &dma_fence_ops.release. It calls
+ * kfree_rcu() on @fence.
+ */
 void dma_fence_free(struct dma_fence *fence)
 {
 	kfree_rcu(fence, rcu);
@@ -192,10 +246,11 @@ EXPORT_SYMBOL(dma_fence_free);
 
 /**
  * dma_fence_enable_sw_signaling - enable signaling on fence
- * @fence:	[in]	the fence to enable
+ * @fence: the fence to enable
  *
- * this will request for sw signaling to be enabled, to make the fence
- * complete as soon as possible
+ * This will request for sw signaling to be enabled, to make the fence
+ * complete as soon as possible. This calls &dma_fence_ops.enable_signaling
+ * internally.
  */
 void dma_fence_enable_sw_signaling(struct dma_fence *fence)
 {
@@ -220,24 +275,24 @@ EXPORT_SYMBOL(dma_fence_enable_sw_signaling);
 /**
  * dma_fence_add_callback - add a callback to be called when the fence
  * is signaled
- * @fence:	[in]	the fence to wait on
- * @cb:		[in]	the callback to register
- * @func:	[in]	the function to call
+ * @fence: the fence to wait on
+ * @cb: the callback to register
+ * @func: the function to call
  *
- * cb will be initialized by dma_fence_add_callback, no initialization
+ * @cb will be initialized by dma_fence_add_callback(), no initialization
  * by the caller is required. Any number of callbacks can be registered
  * to a fence, but a callback can only be registered to one fence at a time.
  *
  * Note that the callback can be called from an atomic context.  If
  * fence is already signaled, this function will return -ENOENT (and
- * *not* call the callback)
+ * *not* call the callback).
  *
  * Add a software callback to the fence. Same restrictions apply to
- * refcount as it does to dma_fence_wait, however the caller doesn't need to
- * keep a refcount to fence afterwards: when software access is enabled,
- * the creator of the fence is required to keep the fence alive until
- * after it signals with dma_fence_signal. The callback itself can be called
- * from irq context.
+ * refcount as it does to dma_fence_wait(), however the caller doesn't need to
+ * keep a refcount to fence afterward dma_fence_add_callback() has returned:
+ * when software access is enabled, the creator of the fence is required to keep
+ * the fence alive until after it signals with dma_fence_signal(). The callback
+ * itself can be called from irq context.
  *
  * Returns 0 in case of success, -ENOENT if the fence is already signaled
  * and -EINVAL in case of error.
@@ -286,7 +341,7 @@ EXPORT_SYMBOL(dma_fence_add_callback);
 
 /**
  * dma_fence_get_status - returns the status upon completion
- * @fence: [in]	the dma_fence to query
+ * @fence: the dma_fence to query
  *
  * This wraps dma_fence_get_status_locked() to return the error status
  * condition on a signaled fence. See dma_fence_get_status_locked() for more
@@ -311,8 +366,8 @@ EXPORT_SYMBOL(dma_fence_get_status);
 
 /**
  * dma_fence_remove_callback - remove a callback from the signaling list
- * @fence:	[in]	the fence to wait on
- * @cb:		[in]	the callback to remove
+ * @fence: the fence to wait on
+ * @cb: the callback to remove
  *
  * Remove a previously queued callback from the fence. This function returns
  * true if the callback is successfully removed, or false if the fence has
@@ -323,6 +378,9 @@ EXPORT_SYMBOL(dma_fence_get_status);
  * doing, since deadlocks and race conditions could occur all too easily. For
  * this reason, it should only ever be done on hardware lockup recovery,
  * with a reference held to the fence.
+ *
+ * Behaviour is undefined if @cb has not been added to @fence using
+ * dma_fence_add_callback() beforehand.
  */
 bool
 dma_fence_remove_callback(struct dma_fence *fence, struct dma_fence_cb *cb)
@@ -359,9 +417,9 @@ dma_fence_default_wait_cb(struct dma_fence *fence, struct dma_fence_cb *cb)
 /**
  * dma_fence_default_wait - default sleep until the fence gets signaled
  * or until timeout elapses
- * @fence:	[in]	the fence to wait on
- * @intr:	[in]	if true, do an interruptible wait
- * @timeout:	[in]	timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
+ * @fence: the fence to wait on
+ * @intr: if true, do an interruptible wait
+ * @timeout: timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
  *
  * Returns -ERESTARTSYS if interrupted, 0 if the wait timed out, or the
  * remaining timeout in jiffies on success. If timeout is zero the value one is
@@ -454,12 +512,12 @@ dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
 /**
  * dma_fence_wait_any_timeout - sleep until any fence gets signaled
  * or until timeout elapses
- * @fences:	[in]	array of fences to wait on
- * @count:	[in]	number of fences to wait on
- * @intr:	[in]	if true, do an interruptible wait
- * @timeout:	[in]	timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
- * @idx:       [out]	the first signaled fence index, meaningful only on
- *			positive return
+ * @fences: array of fences to wait on
+ * @count: number of fences to wait on
+ * @intr: if true, do an interruptible wait
+ * @timeout: timeout value in jiffies, or MAX_SCHEDULE_TIMEOUT
+ * @idx: used to store the first signaled fence index, meaningful only on
+ *	positive return
  *
  * Returns -EINVAL on custom fence wait implementation, -ERESTARTSYS if
  * interrupted, 0 if the wait timed out, or the remaining timeout in jiffies
@@ -468,6 +526,8 @@ dma_fence_test_signaled_any(struct dma_fence **fences, uint32_t count,
  * Synchronous waits for the first fence in the array to be signaled. The
  * caller needs to hold a reference to all fences in the array, otherwise a
  * fence might be freed before return, resulting in undefined behavior.
+ *
+ * See also dma_fence_wait() and dma_fence_wait_timeout().
  */
 signed long
 dma_fence_wait_any_timeout(struct dma_fence **fences, uint32_t count,
@@ -540,19 +600,18 @@ EXPORT_SYMBOL(dma_fence_wait_any_timeout);
 
 /**
  * dma_fence_init - Initialize a custom fence.
- * @fence:	[in]	the fence to initialize
- * @ops:	[in]	the dma_fence_ops for operations on this fence
- * @lock:	[in]	the irqsafe spinlock to use for locking this fence
- * @context:	[in]	the execution context this fence is run on
- * @seqno:	[in]	a linear increasing sequence number for this context
+ * @fence: the fence to initialize
+ * @ops: the dma_fence_ops for operations on this fence
+ * @lock: the irqsafe spinlock to use for locking this fence
+ * @context: the execution context this fence is run on
+ * @seqno: a linear increasing sequence number for this context
  *
  * Initializes an allocated fence, the caller doesn't have to keep its
  * refcount after committing with this fence, but it will need to hold a
- * refcount again if dma_fence_ops.enable_signaling gets called. This can
- * be used for other implementing other types of fence.
+ * refcount again if &dma_fence_ops.enable_signaling gets called.
  *
  * context and seqno are used for easy comparison between fences, allowing
- * to check which fence is later by simply using dma_fence_later.
+ * to check which fence is later by simply using dma_fence_later().
  */
 void
 dma_fence_init(struct dma_fence *fence, const struct dma_fence_ops *ops,
-- 
2.17.0
