Return-path: <linux-media-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:32948 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2G0ON6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 10:13:58 -0400
Subject: [RFC PATCH 2/3] dma-buf-mgr: multiple dma-buf synchronization (v2)
To: linaro-mm-sig@lists.linaro.org, rob.clark@linaro.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: patches@linaro.org, linux-kernel@vger.kernel.org,
	sumit.semwal@linaro.org
Date: Fri, 27 Jul 2012 15:40:04 +0200
Message-ID: <20120727134002.2036.52991.stgit@patser.local>
In-Reply-To: <20120727133952.2036.61330.stgit@patser.local>
References: <20120727133952.2036.61330.stgit@patser.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

dma-buf-mgr handles the case of reserving single or multiple dma-bufs
while trying to prevent deadlocks from buffers being reserved
simultaneously. For this to happen extra functions have been introduced:

  + dma_buf_reserve()
  + dma_buf_unreserve()
  + dma_buf_wait_unreserved()

Reserve a single buffer, optionally with a sequence to indicate this
is part of a multi-dmabuf reservation. This function will return
-EDEADLK and return immediately if reserving would cause a deadlock.
In case a single buffer is being reserved, no sequence is needed,
otherwise please use the dmabufmgr calls.

If you want to attach a exclusive dma-fence, you have to wait
until all shared fences have signalled completion. If there are none,
or if a shared fence has to be attached, wait until last exclusive
fence has signalled completion.

The new fence has to be attached before unreserving the buffer,
and in exclusive mode all previous fences will have be removed
from the buffer, and unreffed when done with it.

dmabufmgr methods:

  + dmabufmgr_reserve_buffers()
This function takes a linked list of dmabufmgr_validate's, each one
requires the following members to be set by the caller:
- validate->head, list head
- validate->bo, must be set to the dma-buf to reserve.
- validate->shared, set to true if opened in shared mode.
- validate->priv, can be used by the caller to identify this buffer.

This function will then set the following members on succesful completion:

- validate->num_fences, amount of valid fences to wait on before this
  buffer can be accessed. This can be 0.
- validate->fences[0...num_fences-1] fences to wait on

  + dmabufmgr_backoff_reservation()
This can be used when the caller encounters an error between reservation
and usage. No new fence will be attached and all reservations will be
undone without side effects.

  + dmabufmgr_fence_buffer_objects
Upon successful completion a new fence will have to be attached.
This function releases old fences and attaches the new one.

  + dmabufmgr_wait_completed_cpu
A simple cpu waiter convenience function. Waits until all fences have
signalled completion before returning.
---
 drivers/base/Makefile       |    3 -
 drivers/base/dma-buf-mgr.c  |  230 +++++++++++++++++++++++++++++++++++++++++++
 drivers/base/dma-buf.c      |  113 +++++++++++++++++++++
 drivers/base/dma-fence.c    |    1 
 include/linux/dma-buf-mgr.h |   97 ++++++++++++++++++
 include/linux/dma-buf.h     |   31 ++++++
 include/linux/dma-fence.h   |    2 
 7 files changed, 475 insertions(+), 2 deletions(-)
 create mode 100644 drivers/base/dma-buf-mgr.c
 create mode 100644 include/linux/dma-buf-mgr.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 1e7723b..819281a 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,8 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o dma-bikeshed-fence.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-fence.o dma-buf-mgr.o \
+			   dma-bikeshed-fence.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-buf-mgr.c b/drivers/base/dma-buf-mgr.c
new file mode 100644
index 0000000..71b5f96
--- /dev/null
+++ b/drivers/base/dma-buf-mgr.c
@@ -0,0 +1,230 @@
+/*
+ * Copyright (C) 2012 Canonical Ltd
+ *
+ * Based on ttm_bo.c which bears the following copyright notice,
+ * but is dual licensed:
+ *
+ * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ */
+
+
+#include <linux/dma-buf-mgr.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+
+static void dmabufmgr_backoff_reservation_locked(struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+
+	list_for_each_entry(entry, list, head) {
+		struct dma_buf *bo = entry->bo;
+		if (!entry->reserved)
+			continue;
+		entry->reserved = false;
+
+		entry->num_fences = 0;
+
+		atomic_set(&bo->reserved, 0);
+		wake_up_all(&bo->event_queue);
+	}
+}
+
+static int
+dmabufmgr_wait_unreserved_locked(struct list_head *list,
+				    struct dma_buf *bo)
+{
+	int ret;
+
+	spin_unlock(&dma_buf_reserve_lock);
+	ret = dma_buf_wait_unreserved(bo, true);
+	spin_lock(&dma_buf_reserve_lock);
+	if (unlikely(ret != 0))
+		dmabufmgr_backoff_reservation_locked(list);
+	return ret;
+}
+
+void
+dmabufmgr_backoff_reservation(struct list_head *list)
+{
+	if (list_empty(list))
+		return;
+
+	spin_lock(&dma_buf_reserve_lock);
+	dmabufmgr_backoff_reservation_locked(list);
+	spin_unlock(&dma_buf_reserve_lock);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_backoff_reservation);
+
+int
+dmabufmgr_reserve_buffers(struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+	int ret;
+	u32 val_seq;
+
+	if (list_empty(list))
+		return 0;
+
+	list_for_each_entry(entry, list, head) {
+		entry->reserved = false;
+		entry->num_fences = 0;
+	}
+
+retry:
+	spin_lock(&dma_buf_reserve_lock);
+	val_seq = atomic_inc_return(&dma_buf_reserve_counter);
+
+	list_for_each_entry(entry, list, head) {
+		struct dma_buf *bo = entry->bo;
+
+retry_this_bo:
+		ret = dma_buf_reserve_locked(bo, true, true, true, val_seq);
+		switch (ret) {
+		case 0:
+			break;
+		case -EBUSY:
+			ret = dmabufmgr_wait_unreserved_locked(list, bo);
+			if (unlikely(ret != 0)) {
+				spin_unlock(&dma_buf_reserve_lock);
+				return ret;
+			}
+			goto retry_this_bo;
+		case -EAGAIN:
+			dmabufmgr_backoff_reservation_locked(list);
+			spin_unlock(&dma_buf_reserve_lock);
+			ret = dma_buf_wait_unreserved(bo, true);
+			if (unlikely(ret != 0))
+				return ret;
+			goto retry;
+		default:
+			dmabufmgr_backoff_reservation_locked(list);
+			spin_unlock(&dma_buf_reserve_lock);
+			return ret;
+		}
+
+		entry->reserved = true;
+
+		if (entry->shared &&
+		    bo->fence_shared_count == DMA_BUF_MAX_SHARED_FENCE) {
+			WARN_ON_ONCE(1);
+			dmabufmgr_backoff_reservation_locked(list);
+			spin_unlock(&dma_buf_reserve_lock);
+			return -EINVAL;
+		}
+
+		if (!entry->shared && bo->fence_shared_count) {
+			entry->num_fences = bo->fence_shared_count;
+			BUILD_BUG_ON(sizeof(entry->fences) != sizeof(bo->fence_shared));
+			memcpy(entry->fences, bo->fence_shared, sizeof(bo->fence_shared));
+		} else if (bo->fence_excl) {
+			entry->num_fences = 1;
+			entry->fences[0] = bo->fence_excl;
+		} else
+			entry->num_fences = 0;
+	}
+	spin_unlock(&dma_buf_reserve_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_reserve_buffers);
+
+static int
+dmabufmgr_wait_single(struct dmabufmgr_validate *val, bool intr, bool lazy,
+		unsigned long timeout)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < val->num_fences && !ret; i++)
+		ret = dma_fence_wait(val->fences[i], intr, timeout);
+	return ret;
+}
+
+int
+dmabufmgr_wait_completed_cpu(struct list_head *list, bool intr, bool lazy)
+{
+	struct dmabufmgr_validate *entry;
+	unsigned long timeout = jiffies + 4 * HZ;
+	int ret;
+
+	list_for_each_entry(entry, list, head) {
+		ret = dmabufmgr_wait_single(entry, intr, lazy, timeout);
+		if (ret && ret != -ERESTARTSYS)
+			pr_err("waiting returns %i\n", ret);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_wait_completed_cpu);
+
+void
+dmabufmgr_fence_buffer_objects(struct dma_fence *fence, struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+	struct dma_buf *bo;
+
+	if (list_empty(list) || WARN_ON(!fence))
+		return;
+
+	/* Until deferred fput hits mainline, release old things here */
+	list_for_each_entry(entry, list, head) {
+		bo = entry->bo;
+
+		if (!entry->shared) {
+			int i;
+			for (i = 0; i < bo->fence_shared_count; ++i) {
+				dma_fence_put(bo->fence_shared[i]);
+				bo->fence_shared[i] = NULL;
+			}
+			bo->fence_shared_count = 0;
+			if (bo->fence_excl) {
+				dma_fence_put(bo->fence_excl);
+				bo->fence_excl = NULL;
+			}
+		}
+
+		entry->reserved = false;
+	}
+
+	spin_lock(&dma_buf_reserve_lock);
+
+	list_for_each_entry(entry, list, head) {
+		bo = entry->bo;
+
+		dma_fence_get(fence);
+		if (entry->shared)
+			bo->fence_shared[bo->fence_shared_count++] = fence;
+		else
+			bo->fence_excl = fence;
+
+		dma_buf_unreserve_locked(bo);
+	}
+
+	spin_unlock(&dma_buf_reserve_lock);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_fence_buffer_objects);
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 757ee20..6e76baf 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -27,12 +27,17 @@
 #include <linux/dma-buf.h>
 #include <linux/anon_inodes.h>
 #include <linux/export.h>
+#include <linux/sched.h>
+
+atomic_t dma_buf_reserve_counter = ATOMIC_INIT(1);
+DEFINE_SPINLOCK(dma_buf_reserve_lock);
 
 static inline int is_dma_buf_file(struct file *);
 
 static int dma_buf_release(struct inode *inode, struct file *file)
 {
 	struct dma_buf *dmabuf;
+	int i;
 
 	if (!is_dma_buf_file(file))
 		return -EINVAL;
@@ -40,6 +45,15 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	dmabuf = file->private_data;
 
 	dmabuf->ops->release(dmabuf);
+
+	BUG_ON(waitqueue_active(&dmabuf->event_queue));
+	BUG_ON(atomic_read(&dmabuf->reserved));
+
+	if (dmabuf->fence_excl)
+		dma_fence_put(dmabuf->fence_excl);
+	for (i = 0; i < dmabuf->fence_shared_count; ++i)
+		dma_fence_put(dmabuf->fence_shared[i]);
+
 	kfree(dmabuf);
 	return 0;
 }
@@ -119,6 +133,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 
 	mutex_init(&dmabuf->lock);
 	INIT_LIST_HEAD(&dmabuf->attachments);
+	init_waitqueue_head(&dmabuf->event_queue);
 
 	return dmabuf;
 }
@@ -566,3 +581,101 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 		dmabuf->ops->vunmap(dmabuf, vaddr);
 }
 EXPORT_SYMBOL_GPL(dma_buf_vunmap);
+
+int
+dma_buf_reserve_locked(struct dma_buf *dmabuf, bool interruptible,
+		       bool no_wait, bool use_sequence, u32 sequence)
+{
+	int ret;
+
+	while (unlikely(atomic_cmpxchg(&dmabuf->reserved, 0, 1) != 0)) {
+		/**
+		 * Deadlock avoidance for multi-dmabuf reserving.
+		 */
+		if (use_sequence && dmabuf->seq_valid) {
+			/**
+			 * We've already reserved this one.
+			 */
+			if (unlikely(sequence == dmabuf->val_seq))
+				return -EDEADLK;
+			/**
+			 * Already reserved by a thread that will not back
+			 * off for us. We need to back off.
+			 */
+			if (unlikely(sequence - dmabuf->val_seq < (1 << 31)))
+				return -EAGAIN;
+		}
+
+		if (no_wait)
+			return -EBUSY;
+
+		spin_unlock(&dma_buf_reserve_lock);
+		ret = dma_buf_wait_unreserved(dmabuf, interruptible);
+		spin_lock(&dma_buf_reserve_lock);
+
+		if (unlikely(ret))
+			return ret;
+	}
+
+	if (use_sequence) {
+		/**
+		 * Wake up waiters that may need to recheck for deadlock,
+		 * if we decreased the sequence number.
+		 */
+		if (unlikely((dmabuf->val_seq - sequence < (1 << 31))
+			     || !dmabuf->seq_valid))
+			wake_up_all(&dmabuf->event_queue);
+
+		dmabuf->val_seq = sequence;
+		dmabuf->seq_valid = true;
+	} else {
+		dmabuf->seq_valid = false;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dma_buf_reserve_locked);
+
+int
+dma_buf_reserve(struct dma_buf *dmabuf, bool interruptible, bool no_wait,
+		bool use_sequence, u32 sequence)
+{
+	int ret;
+
+	spin_lock(&dma_buf_reserve_lock);
+	ret = dma_buf_reserve_locked(dmabuf, interruptible, no_wait,
+				     use_sequence, sequence);
+	spin_unlock(&dma_buf_reserve_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dma_buf_reserve);
+
+int
+dma_buf_wait_unreserved(struct dma_buf *dmabuf, bool interruptible)
+{
+	if (interruptible) {
+		return wait_event_interruptible(dmabuf->event_queue,
+				atomic_read(&dmabuf->reserved) == 0);
+	} else {
+		wait_event(dmabuf->event_queue,
+			   atomic_read(&dmabuf->reserved) == 0);
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(dma_buf_wait_unreserved);
+
+void dma_buf_unreserve_locked(struct dma_buf *dmabuf)
+{
+	atomic_set(&dmabuf->reserved, 0);
+	wake_up_all(&dmabuf->event_queue);
+}
+EXPORT_SYMBOL_GPL(dma_buf_unreserve_locked);
+
+void dma_buf_unreserve(struct dma_buf *dmabuf)
+{
+	spin_lock(&dma_buf_reserve_lock);
+	dma_buf_unreserve_locked(dmabuf);
+	spin_unlock(&dma_buf_reserve_lock);
+}
+EXPORT_SYMBOL_GPL(dma_buf_unreserve);
diff --git a/drivers/base/dma-fence.c b/drivers/base/dma-fence.c
index 6798dc4..7fa4c74 100644
--- a/drivers/base/dma-fence.c
+++ b/drivers/base/dma-fence.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/export.h>
+#include <linux/dma-buf.h>
 #include <linux/dma-fence.h>
 
 /**
diff --git a/include/linux/dma-buf-mgr.h b/include/linux/dma-buf-mgr.h
new file mode 100644
index 0000000..64baab1
--- /dev/null
+++ b/include/linux/dma-buf-mgr.h
@@ -0,0 +1,97 @@
+/*
+ * Header file for dma buffer sharing framework.
+ *
+ * Copyright(C) 2011 Linaro Limited. All rights reserved.
+ * Author: Sumit Semwal <sumit.semwal@ti.com>
+ *
+ * Many thanks to linaro-mm-sig list, and specially
+ * Arnd Bergmann <arnd@arndb.de>, Rob Clark <rob@ti.com> and
+ * Daniel Vetter <daniel@ffwll.ch> for their support in creation and
+ * refining of this idea.
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
+#ifndef __DMA_BUF_MGR_H__
+#define __DMA_BUF_MGR_H__
+
+#include <linux/dma-buf.h>
+#include <linux/list.h>
+
+/** based on ttm_execbuf_util
+ */
+struct dmabufmgr_validate {
+	/* Input parameters, set before reserve */
+	struct list_head head;
+	struct dma_buf *bo;
+	void *priv;
+	bool shared;
+
+	/* for internal use */
+	bool reserved;
+	/* fences to wait on, if shared, last exclusive fence
+	 * if exclusive, last shared fences (if non-null), or
+	 * last exclusive fence
+	 */
+	unsigned num_fences;
+	struct dma_fence *fences[DMA_BUF_MAX_SHARED_FENCE];
+};
+
+#ifdef CONFIG_DMA_SHARED_BUFFER
+
+/** reserve a linked list of struct dmabufmgr_validate entries */
+extern int
+dmabufmgr_reserve_buffers(struct list_head *list);
+
+/** Undo reservation */
+extern void
+dmabufmgr_backoff_reservation(struct list_head *list);
+
+/** Commit reservation */
+extern void
+dmabufmgr_fence_buffer_objects(struct dma_fence *fence, struct list_head *list);
+
+/** Wait for completion on cpu
+ * intr: interruptible wait
+ * lazy: try once every tick instead of busywait
+ */
+extern int
+dmabufmgr_wait_completed_cpu(struct list_head *list, bool intr, bool lazy);
+
+#else /* CONFIG_DMA_SHARED_BUFFER */
+
+/** reserve a linked list of struct dmabufmgr_validate entries */
+static inline int
+dmabufmgr_reserve_buffers(struct list_head *list)
+{
+	return list_empty(list) ? 0 : -ENODEV;
+}
+
+/** Undo reservation */
+static inline void
+dmabufmgr_backoff_reservation(struct list_head *list)
+{}
+
+/** Commit reservation */
+static inline void
+dmabufmgr_fence_buffer_objects(struct dma_fence *fence, struct list_head *list)
+{}
+
+static inline int
+dmabufmgr_wait_completed_cpu(struct list_head *list, bool intr, bool lazy)
+{
+	return list_empty(list) ? 0 : -ENODEV;
+}
+
+#endif /* CONFIG_DMA_SHARED_BUFFER */
+
+#endif /* __DMA_BUF_MGR_H__ */
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 9533b9b..d3d76e5 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -35,6 +35,13 @@ struct device;
 struct dma_buf;
 struct dma_buf_attachment;
 
+#include <linux/dma-fence.h>
+
+extern atomic_t dma_buf_reserve_counter;
+extern spinlock_t dma_buf_reserve_lock;
+
+#define DMA_BUF_MAX_SHARED_FENCE 8
+
 /**
  * struct dma_buf_ops - operations possible on struct dma_buf
  * @attach: [optional] allows different devices to 'attach' themselves to the
@@ -113,6 +120,8 @@ struct dma_buf_ops {
  * @attachments: list of dma_buf_attachment that denotes all devices attached.
  * @ops: dma_buf_ops associated with this buffer object.
  * @priv: exporter specific private data for this buffer object.
+ * @bufmgr_entry: used by dmabufmgr
+ * @bufdev: used by dmabufmgr
  */
 struct dma_buf {
 	size_t size;
@@ -122,6 +131,18 @@ struct dma_buf {
 	/* mutex to serialize list manipulation and attach/detach */
 	struct mutex lock;
 	void *priv;
+
+	/** event queue for waking up when this dmabuf becomes unreserved */
+	wait_queue_head_t event_queue;
+
+	atomic_t reserved;
+
+	/** These require dma_buf_reserve to be called before modification */
+	bool seq_valid;
+	u32 val_seq;
+	struct dma_fence *fence_excl;
+	struct dma_fence *fence_shared[DMA_BUF_MAX_SHARED_FENCE];
+	u32 fence_shared_count;
 };
 
 /**
@@ -188,6 +209,14 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
 		 unsigned long);
 void *dma_buf_vmap(struct dma_buf *);
 void dma_buf_vunmap(struct dma_buf *, void *vaddr);
+int dma_buf_reserve_locked(struct dma_buf *, bool intr, bool no_wait,
+			   bool use_seq, u32 seq);
+int dma_buf_reserve(struct dma_buf *, bool intr, bool no_wait,
+		    bool use_seq, u32 seq);
+int dma_buf_wait_unreserved(struct dma_buf *, bool interruptible);
+void dma_buf_unreserve_locked(struct dma_buf *);
+void dma_buf_unreserve(struct dma_buf *);
+
 #else
 
 static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
@@ -300,6 +329,8 @@ static inline void *dma_buf_vmap(struct dma_buf *dmabuf)
 static inline void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
 {
 }
+
+// TODO
 #endif /* CONFIG_DMA_SHARED_BUFFER */
 
 #endif /* __DMA_BUF_H__ */
diff --git a/include/linux/dma-fence.h b/include/linux/dma-fence.h
index 648f136..8938f48 100644
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -24,7 +24,7 @@
 #include <linux/list.h>
 #include <linux/wait.h>
 #include <linux/list.h>
-#include <linux/dma-buf.h>
+#include <linux/kref.h>
 
 struct dma_fence;
 struct dma_fence_ops;

