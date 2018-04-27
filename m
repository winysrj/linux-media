Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:52312 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbeD0GRc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 02:17:32 -0400
Received: by mail-wm0-f48.google.com with SMTP id m70so381356wma.2
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 23:17:31 -0700 (PDT)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: DRI Development <dri-devel@lists.freedesktop.org>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: [PATCH 01/17] dma-fence: Some kerneldoc polish for dma-fence.h
Date: Fri, 27 Apr 2018 08:17:08 +0200
Message-Id: <20180427061724.28497-2-daniel.vetter@ffwll.ch>
In-Reply-To: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
References: <20180427061724.28497-1-daniel.vetter@ffwll.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Switch to inline member docs for dma_fence_ops.
- Mild polish all around.
- hyperlink all the things!

v2: - Remove the various [in] annotations, they seem really uncommon
in kerneldoc and look funny.

Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org
Cc: linaro-mm-sig@lists.linaro.org
---
 include/linux/dma-fence.h | 235 +++++++++++++++++++++++++-------------
 1 file changed, 154 insertions(+), 81 deletions(-)

diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index 4c008170fe65..9d6f39bf2111 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -94,11 +94,11 @@ typedef void (*dma_fence_func_t)(struct dma_fence *fence,
 				 struct dma_fence_cb *cb);
 
 /**
- * struct dma_fence_cb - callback for dma_fence_add_callback
- * @node: used by dma_fence_add_callback to append this struct to fence::cb_list
+ * struct dma_fence_cb - callback for dma_fence_add_callback()
+ * @node: used by dma_fence_add_callback() to append this struct to fence::cb_list
  * @func: dma_fence_func_t to call
  *
- * This struct will be initialized by dma_fence_add_callback, additional
+ * This struct will be initialized by dma_fence_add_callback(), additional
  * data can be passed along by embedding dma_fence_cb in another struct.
  */
 struct dma_fence_cb {
@@ -108,75 +108,142 @@ struct dma_fence_cb {
 
 /**
  * struct dma_fence_ops - operations implemented for fence
- * @get_driver_name: returns the driver name.
- * @get_timeline_name: return the name of the context this fence belongs to.
- * @enable_signaling: enable software signaling of fence.
- * @signaled: [optional] peek whether the fence is signaled, can be null.
- * @wait: custom wait implementation, or dma_fence_default_wait.
- * @release: [optional] called on destruction of fence, can be null
- * @fill_driver_data: [optional] callback to fill in free-form debug info
- * Returns amount of bytes filled, or -errno.
- * @fence_value_str: [optional] fills in the value of the fence as a string
- * @timeline_value_str: [optional] fills in the current value of the timeline
- * as a string
  *
- * Notes on enable_signaling:
- * For fence implementations that have the capability for hw->hw
- * signaling, they can implement this op to enable the necessary
- * irqs, or insert commands into cmdstream, etc.  This is called
- * in the first wait() or add_callback() path to let the fence
- * implementation know that there is another driver waiting on
- * the signal (ie. hw->sw case).
- *
- * This function can be called from atomic context, but not
- * from irq context, so normal spinlocks can be used.
- *
- * A return value of false indicates the fence already passed,
- * or some failure occurred that made it impossible to enable
- * signaling. True indicates successful enabling.
- *
- * fence->error may be set in enable_signaling, but only when false is
- * returned.
- *
- * Calling dma_fence_signal before enable_signaling is called allows
- * for a tiny race window in which enable_signaling is called during,
- * before, or after dma_fence_signal. To fight this, it is recommended
- * that before enable_signaling returns true an extra reference is
- * taken on the fence, to be released when the fence is signaled.
- * This will mean dma_fence_signal will still be called twice, but
- * the second time will be a noop since it was already signaled.
- *
- * Notes on signaled:
- * May set fence->error if returning true.
- *
- * Notes on wait:
- * Must not be NULL, set to dma_fence_default_wait for default implementation.
- * the dma_fence_default_wait implementation should work for any fence, as long
- * as enable_signaling works correctly.
- *
- * Must return -ERESTARTSYS if the wait is intr = true and the wait was
- * interrupted, and remaining jiffies if fence has signaled, or 0 if wait
- * timed out. Can also return other error values on custom implementations,
- * which should be treated as if the fence is signaled. For example a hardware
- * lockup could be reported like that.
- *
- * Notes on release:
- * Can be NULL, this function allows additional commands to run on
- * destruction of the fence. Can be called from irq context.
- * If pointer is set to NULL, kfree will get called instead.
  */
-
 struct dma_fence_ops {
+	/**
+	 * @get_driver_name:
+	 *
+	 * Returns the driver name. This is a callback to allow drivers to
+	 * compute the name at runtime, without having it to store permanently
+	 * for each fence, or build a cache of some sort.
+	 *
+	 * This callback is mandatory.
+	 */
 	const char * (*get_driver_name)(struct dma_fence *fence);
+
+	/**
+	 * @get_timeline_name:
+	 *
+	 * Return the name of the context this fence belongs to. This is a
+	 * callback to allow drivers to compute the name at runtime, without
+	 * having it to store permanently for each fence, or build a cache of
+	 * some sort.
+	 *
+	 * This callback is mandatory.
+	 */
 	const char * (*get_timeline_name)(struct dma_fence *fence);
+
+	/**
+	 * @enable_signaling:
+	 *
+	 * Enable software signaling of fence.
+	 *
+	 * For fence implementations that have the capability for hw->hw
+	 * signaling, they can implement this op to enable the necessary
+	 * interrupts, or insert commands into cmdstream, etc, to avoid these
+	 * costly operations for the common case where only hw->hw
+	 * synchronization is required.  This is called in the first
+	 * dma_fence_wait() or dma_fence_add_callback() path to let the fence
+	 * implementation know that there is another driver waiting on the
+	 * signal (ie. hw->sw case).
+	 *
+	 * This function can be called from atomic context, but not
+	 * from irq context, so normal spinlocks can be used.
+	 *
+	 * A return value of false indicates the fence already passed,
+	 * or some failure occurred that made it impossible to enable
+	 * signaling. True indicates successful enabling.
+	 *
+	 * &dma_fence.error may be set in enable_signaling, but only when false
+	 * is returned.
+	 *
+	 * Since many implementations can call dma_fence_signal() even when before
+	 * @enable_signaling has been called there's a race window, where the
+	 * dma_fence_signal() might result in the final fence reference being
+	 * released and its memory freed. To avoid this, implementations of this
+	 * callback should grab their own reference using dma_fence_get(), to be
+	 * released when the fence is signalled (through e.g. the interrupt
+	 * handler).
+	 *
+	 * This callback is mandatory.
+	 */
 	bool (*enable_signaling)(struct dma_fence *fence);
+
+	/**
+	 * @signaled:
+	 *
+	 * Peek whether the fence is signaled, as a fastpath optimization for
+	 * e.g. dma_fence_wait() or dma_fence_add_callback(). Note that this
+	 * callback does not need to make any guarantees beyond that a fence
+	 * once indicates as signalled must always return true from this
+	 * callback. This callback may return false even if the fence has
+	 * completed already, in this case information hasn't propogated throug
+	 * the system yet. See also dma_fence_is_signaled().
+	 *
+	 * May set &dma_fence.error if returning true.
+	 *
+	 * This callback is optional.
+	 */
 	bool (*signaled)(struct dma_fence *fence);
+
+	/**
+	 * @wait:
+	 *
+	 * Custom wait implementation, or dma_fence_default_wait.
+	 *
+	 * Must not be NULL, set to dma_fence_default_wait for default implementation.
+	 * the dma_fence_default_wait implementation should work for any fence, as long
+	 * as enable_signaling works correctly.
+	 *
+	 * Must return -ERESTARTSYS if the wait is intr = true and the wait was
+	 * interrupted, and remaining jiffies if fence has signaled, or 0 if wait
+	 * timed out. Can also return other error values on custom implementations,
+	 * which should be treated as if the fence is signaled. For example a hardware
+	 * lockup could be reported like that.
+	 *
+	 * This callback is mandatory.
+	 */
 	signed long (*wait)(struct dma_fence *fence,
 			    bool intr, signed long timeout);
+
+	/**
+	 * @release:
+	 *
+	 * Called on destruction of fence to release additional resources.
+	 * Can be called from irq context.  This callback is optional. If it is
+	 * NULL, then dma_fence_free() is instead called as the default
+	 * implementation.
+	 */
 	void (*release)(struct dma_fence *fence);
 
+	/**
+	 * @fill_driver_data:
+	 *
+	 * Callback to fill in free-form debug info Returns amount of bytes
+	 * filled, or negative error on failure.
+	 *
+	 * This callback is optional.
+	 */
 	int (*fill_driver_data)(struct dma_fence *fence, void *data, int size);
+
+	/**
+	 * @fence_value_str:
+	 *
+	 * Callback to fill in free-form debug info specific to this fence, like
+	 * the sequence number.
+	 *
+	 * This callback is optional.
+	 */
 	void (*fence_value_str)(struct dma_fence *fence, char *str, int size);
+
+	/**
+	 * @timeline_value_str:
+	 *
+	 * Fills in the current value of the timeline as a string, like the
+	 * sequence number. This should match what @fill_driver_data prints for
+	 * the most recently signalled fence (assuming no delayed signalling).
+	 */
 	void (*timeline_value_str)(struct dma_fence *fence,
 				   char *str, int size);
 };
@@ -189,7 +256,7 @@ void dma_fence_free(struct dma_fence *fence);
 
 /**
  * dma_fence_put - decreases refcount of the fence
- * @fence:	[in]	fence to reduce refcount of
+ * @fence: fence to reduce refcount of
  */
 static inline void dma_fence_put(struct dma_fence *fence)
 {
@@ -199,7 +266,7 @@ static inline void dma_fence_put(struct dma_fence *fence)
 
 /**
  * dma_fence_get - increases refcount of the fence
- * @fence:	[in]	fence to increase refcount of
+ * @fence: fence to increase refcount of
  *
  * Returns the same fence, with refcount increased by 1.
  */
@@ -213,7 +280,7 @@ static inline struct dma_fence *dma_fence_get(struct dma_fence *fence)
 /**
  * dma_fence_get_rcu - get a fence from a reservation_object_list with
  *                     rcu read lock
- * @fence:	[in]	fence to increase refcount of
+ * @fence: fence to increase refcount of
  *
  * Function returns NULL if no refcount could be obtained, or the fence.
  */
@@ -227,7 +294,7 @@ static inline struct dma_fence *dma_fence_get_rcu(struct dma_fence *fence)
 
 /**
  * dma_fence_get_rcu_safe  - acquire a reference to an RCU tracked fence
- * @fencep:	[in]	pointer to fence to increase refcount of
+ * @fencep: pointer to fence to increase refcount of
  *
  * Function returns NULL if no refcount could be obtained, or the fence.
  * This function handles acquiring a reference to a fence that may be
@@ -289,14 +356,16 @@ void dma_fence_enable_sw_signaling(struct dma_fence *fence);
 /**
  * dma_fence_is_signaled_locked - Return an indication if the fence
  *                                is signaled yet.
- * @fence:	[in]	the fence to check
+ * @fence: the fence to check
  *
  * Returns true if the fence was already signaled, false if not. Since this
  * function doesn't enable signaling, it is not guaranteed to ever return
- * true if dma_fence_add_callback, dma_fence_wait or
- * dma_fence_enable_sw_signaling haven't been called before.
+ * true if dma_fence_add_callback(), dma_fence_wait() or
+ * dma_fence_enable_sw_signaling() haven't been called before.
  *
- * This function requires fence->lock to be held.
+ * This function requires &dma_fence.lock to be held.
+ *
+ * See also dma_fence_is_signaled().
  */
 static inline bool
 dma_fence_is_signaled_locked(struct dma_fence *fence)
@@ -314,17 +383,19 @@ dma_fence_is_signaled_locked(struct dma_fence *fence)
 
 /**
  * dma_fence_is_signaled - Return an indication if the fence is signaled yet.
- * @fence:	[in]	the fence to check
+ * @fence: the fence to check
  *
  * Returns true if the fence was already signaled, false if not. Since this
  * function doesn't enable signaling, it is not guaranteed to ever return
- * true if dma_fence_add_callback, dma_fence_wait or
- * dma_fence_enable_sw_signaling haven't been called before.
+ * true if dma_fence_add_callback(), dma_fence_wait() or
+ * dma_fence_enable_sw_signaling() haven't been called before.
  *
  * It's recommended for seqno fences to call dma_fence_signal when the
  * operation is complete, it makes it possible to prevent issues from
  * wraparound between time of issue and time of use by checking the return
  * value of this function before calling hardware-specific wait instructions.
+ *
+ * See also dma_fence_is_signaled_locked().
  */
 static inline bool
 dma_fence_is_signaled(struct dma_fence *fence)
@@ -342,8 +413,8 @@ dma_fence_is_signaled(struct dma_fence *fence)
 
 /**
  * __dma_fence_is_later - return if f1 is chronologically later than f2
- * @f1:	[in]	the first fence's seqno
- * @f2:	[in]	the second fence's seqno from the same context
+ * @f1: the first fence's seqno
+ * @f2: the second fence's seqno from the same context
  *
  * Returns true if f1 is chronologically later than f2. Both fences must be
  * from the same context, since a seqno is not common across contexts.
@@ -355,8 +426,8 @@ static inline bool __dma_fence_is_later(u32 f1, u32 f2)
 
 /**
  * dma_fence_is_later - return if f1 is chronologically later than f2
- * @f1:	[in]	the first fence from the same context
- * @f2:	[in]	the second fence from the same context
+ * @f1: the first fence from the same context
+ * @f2: the second fence from the same context
  *
  * Returns true if f1 is chronologically later than f2. Both fences must be
  * from the same context, since a seqno is not re-used across contexts.
@@ -372,8 +443,8 @@ static inline bool dma_fence_is_later(struct dma_fence *f1,
 
 /**
  * dma_fence_later - return the chronologically later fence
- * @f1:	[in]	the first fence from the same context
- * @f2:	[in]	the second fence from the same context
+ * @f1:	the first fence from the same context
+ * @f2:	the second fence from the same context
  *
  * Returns NULL if both fences are signaled, otherwise the fence that would be
  * signaled last. Both fences must be from the same context, since a seqno is
@@ -398,7 +469,7 @@ static inline struct dma_fence *dma_fence_later(struct dma_fence *f1,
 
 /**
  * dma_fence_get_status_locked - returns the status upon completion
- * @fence: [in]	the dma_fence to query
+ * @fence: the dma_fence to query
  *
  * Drivers can supply an optional error status condition before they signal
  * the fence (to indicate whether the fence was completed due to an error
@@ -422,8 +493,8 @@ int dma_fence_get_status(struct dma_fence *fence);
 
 /**
  * dma_fence_set_error - flag an error condition on the fence
- * @fence: [in]	the dma_fence
- * @error: [in]	the error to store
+ * @fence: the dma_fence
+ * @error: the error to store
  *
  * Drivers can supply an optional error status condition before they signal
  * the fence, to indicate that the fence was completed due to an error
@@ -449,8 +520,8 @@ signed long dma_fence_wait_any_timeout(struct dma_fence **fences,
 
 /**
  * dma_fence_wait - sleep until the fence gets signaled
- * @fence:	[in]	the fence to wait on
- * @intr:	[in]	if true, do an interruptible wait
+ * @fence: the fence to wait on
+ * @intr: if true, do an interruptible wait
  *
  * This function will return -ERESTARTSYS if interrupted by a signal,
  * or 0 if the fence was signaled. Other error values may be
@@ -459,6 +530,8 @@ signed long dma_fence_wait_any_timeout(struct dma_fence **fences,
  * Performs a synchronous wait on this fence. It is assumed the caller
  * directly or indirectly holds a reference to the fence, otherwise the
  * fence might be freed before return, resulting in undefined behavior.
+ *
+ * See also dma_fence_wait_timeout() and dma_fence_wait_any_timeout().
  */
 static inline signed long dma_fence_wait(struct dma_fence *fence, bool intr)
 {
-- 
2.17.0
