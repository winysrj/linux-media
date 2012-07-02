Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40082 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2GBQHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 12:07:31 -0400
Received: by eeit10 with SMTP id t10so2146537eei.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2012 09:07:29 -0700 (PDT)
Message-ID: <4FF1C73F.6040108@gmail.com>
Date: Mon, 02 Jul 2012 18:07:27 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Subject: [RFC v2] implicit drm synchronization wip with dma-buf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Well,

V2 time! I was hinted to look at ttm_execbuf_util, and it does indeed contain some nice code.
My goal was to extend dma-buf in a generic way now, some elements from v1 are remaining,
most notably a dma-buf used for syncing. However it is expected now that dma-buf syncing will
work in a very specific way now, slightly more strict than in v1.

Instead of each buffer having their own dma-buf I put in 1 per command submission.

This submission hasn't been run-time tested yet, but I expect the api to go something like this.

Intended to be used like this:

list_init(&head);
add_list_tail(&validate1->entry, &head);
add_list_tail(&validate2->entry, &head);
add_list_tail(&validate3->entry, &head);

r = dmabufmgr_eu_reserve_buffers(&head);
if (r) return r;

// add waits on cpu or gpu
list_for_each_entry(validate, ...) {

	if (!validate->sync_buf)
		continue;

	// Check attachments to see if we already imported sync_buf
	// somewhere, if not attach to it.
	// waiting until cur_seq - dmabuf->sync_val >= 0 on either cpu
	// or as command submitted to gpu
	// sync_buf itself is a dma-buf, so it should be trivial
	// TODO: sync_buf should NEVER be validated, add is_sync_buf to dma_buf?

	// If this step fails: dmabufmgr_eu_backoff_reservation
	// else:
	// dmabufmgr_eu_fence_buffer_objects(our_own_sync_buf,
	// hwchannel * max(minhwalign, 4), ++counter[hwchannel]);

	// XXX: Do we still require a minimum alignment? I set up 16 for nouveau,
	// but this is no longer needed in this design since it only matters
	// for writes for which nouveau would already control the offset.
}

// Some time after execbuffer was executed, doesn't have to be right away but before
// getting in the danger of our own counter wrapping around:
	// grab dmabufmgr.lru_lock, and cleanup by unreffing sync_buf when
	// sync_buf == ownbuf, sync_ofs == ownofs, and sync_val == saved_counter
	// In the meantime someone else or even us might have reserved this dma_buf
	// again, which is why all those checks are needed before unreffing.

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5aa2d70..86e7598 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o dma-buf-mgr.o dma-buf-mgr-eu.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/dma-buf-mgr-eu.c b/drivers/base/dma-buf-mgr-eu.c
new file mode 100644
index 0000000..27ebc68
--- /dev/null
+++ b/drivers/base/dma-buf-mgr-eu.c
@@ -0,0 +1,170 @@
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
+
+#include <linux/dma-buf-mgr.h>
+#include <linux/sched.h>
+#include <linux/export.h>
+
+static void dmabufmgr_eu_backoff_reservation_locked(struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+
+	list_for_each_entry(entry, list, head) {
+		struct dma_buf *bo = entry->bo;
+		if (!entry->reserved)
+			continue;
+
+		entry->reserved = false;
+		atomic_set(&bo->reserved, 0);
+		wake_up_all(&bo->event_queue);
+		if (entry->sync_buf)
+			dma_buf_put(entry->sync_buf);
+		entry->sync_buf = NULL;
+	}
+}
+
+static int
+dmabufmgr_eu_wait_unreserved_locked(struct list_head *list,
+				    struct dma_buf *bo)
+{
+	int ret;
+
+	spin_unlock(&dmabufmgr.lru_lock);
+	ret = dmabufmgr_bo_wait_unreserved(bo, true);
+	spin_lock(&dmabufmgr.lru_lock);
+	if (unlikely(ret != 0))
+		dmabufmgr_eu_backoff_reservation_locked(list);
+	return ret;
+}
+
+void
+dmabufmgr_eu_backoff_reservation(struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+
+	if (list_empty(list))
+		return;
+
+	entry = list_first_entry(list, struct dmabufmgr_validate, head);
+	spin_lock(&dmabufmgr.lru_lock);
+	dmabufmgr_eu_backoff_reservation_locked(list);
+	spin_unlock(&dmabufmgr.lru_lock);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_eu_backoff_reservation);
+
+int
+dmabufmgr_eu_reserve_buffers(struct list_head *list)
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
+		entry->sync_buf = NULL;
+	}
+
+retry:
+	spin_lock(&dmabufmgr.lru_lock);
+	val_seq = dmabufmgr.counter++;
+
+	list_for_each_entry(entry, list, head) {
+		struct dma_buf *bo = entry->bo;
+
+retry_this_bo:
+		ret = dmabufmgr_bo_reserve_locked(bo, true, true, true, val_seq);
+		switch (ret) {
+		case 0:
+			break;
+		case -EBUSY:
+			ret = dmabufmgr_eu_wait_unreserved_locked(list, bo);
+			if (unlikely(ret != 0)) {
+				spin_unlock(&dmabufmgr.lru_lock);
+				return ret;
+			}
+			goto retry_this_bo;
+		case -EAGAIN:
+			dmabufmgr_eu_backoff_reservation_locked(list);
+			spin_unlock(&dmabufmgr.lru_lock);
+			ret = dmabufmgr_bo_wait_unreserved(bo, true);
+			if (unlikely(ret != 0))
+				return ret;
+			goto retry;
+		default:
+			dmabufmgr_eu_backoff_reservation_locked(list);
+			spin_unlock(&dmabufmgr.lru_lock);
+			return ret;
+		}
+
+		entry->reserved = true;
+		if (bo->sync_buf)
+			get_dma_buf(bo->sync_buf);
+		entry->sync_buf = bo->sync_buf;
+		entry->sync_ofs = bo->sync_ofs;
+		entry->sync_val = bo->sync_val;
+	}
+	spin_unlock(&dmabufmgr.lru_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_eu_reserve_buffers);
+
+void
+dmabufmgr_eu_fence_buffer_objects(struct dma_buf *sync_buf, u32 ofs, u32 seq, struct list_head *list)
+{
+	struct dmabufmgr_validate *entry;
+	struct dma_buf *bo;
+
+	if (list_empty(list) || WARN_ON(!sync_buf))
+		return;
+
+	spin_lock(&dmabufmgr.lru_lock);
+
+	list_for_each_entry(entry, list, head) {
+		bo = entry->bo;
+		dmabufmgr_bo_unreserve_locked(bo);
+		entry->reserved = false;
+		if (entry->sync_buf)
+			dma_buf_put(entry->sync_buf);
+		entry->sync_buf = NULL;
+
+		get_dma_buf(sync_buf);
+		bo->sync_buf = sync_buf;
+		bo->sync_ofs = ofs;
+		bo->sync_val = seq;
+	}
+
+	spin_unlock(&dmabufmgr.lru_lock);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_eu_fence_buffer_objects);
diff --git a/drivers/base/dma-buf-mgr.c b/drivers/base/dma-buf-mgr.c
new file mode 100644
index 0000000..14756ff
--- /dev/null
+++ b/drivers/base/dma-buf-mgr.c
@@ -0,0 +1,149 @@
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
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/dma-buf-mgr.h>
+#include <linux/anon_inodes.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/list.h>
+
+/* Based on ttm_bo.c with vm_lock and fence_lock removed
+ * lru_lock takes care of fence_lock as well
+ */
+struct dmabufmgr dmabufmgr = {
+	.lru_lock = __SPIN_LOCK_UNLOCKED(dmabufmgr.lru_lock),
+	.counter = 1,
+};
+
+int
+dmabufmgr_bo_reserve_locked(struct dma_buf *bo,
+			    bool interruptible, bool no_wait,
+			    bool use_sequence, u32 sequence)
+{
+	int ret;
+
+	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+		/**
+		 * Deadlock avoidance for multi-bo reserving.
+		 */
+		if (use_sequence && bo->seq_valid) {
+			/**
+			 * We've already reserved this one.
+			 */
+			if (unlikely(sequence == bo->val_seq))
+				return -EDEADLK;
+			/**
+			 * Already reserved by a thread that will not back
+			 * off for us. We need to back off.
+			 */
+			if (unlikely(sequence - bo->val_seq < (1 << 31)))
+				return -EAGAIN;
+		}
+
+		if (no_wait)
+			return -EBUSY;
+
+		spin_unlock(&dmabufmgr.lru_lock);
+		ret = dmabufmgr_bo_wait_unreserved(bo, interruptible);
+		spin_lock(&dmabufmgr.lru_lock);
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
+		if (unlikely((bo->val_seq - sequence < (1 << 31))
+			     || !bo->seq_valid))
+			wake_up_all(&bo->event_queue);
+
+		bo->val_seq = sequence;
+		bo->seq_valid = true;
+	} else {
+		bo->seq_valid = false;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_reserve_locked);
+
+int
+dmabufmgr_bo_reserve(struct dma_buf *bo,
+		     bool interruptible, bool no_wait,
+		     bool use_sequence, u32 sequence)
+{
+	int ret;
+
+	spin_lock(&dmabufmgr.lru_lock);
+	ret = dmabufmgr_bo_reserve_locked(bo, interruptible, no_wait,
+					  use_sequence, sequence);
+	spin_unlock(&dmabufmgr.lru_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_reserve);
+
+int
+dmabufmgr_bo_wait_unreserved(struct dma_buf *bo, bool interruptible)
+{
+	if (interruptible) {
+		return wait_event_interruptible(bo->event_queue,
+					       atomic_read(&bo->reserved) == 0);
+	} else {
+		wait_event(bo->event_queue, atomic_read(&bo->reserved) == 0);
+		return 0;
+	}
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_wait_unreserved);
+
+void dmabufmgr_bo_unreserve_locked(struct dma_buf *bo)
+{
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_unreserve_locked);
+
+void dmabufmgr_bo_unreserve(struct dma_buf *bo)
+{
+	spin_lock(&dmabufmgr.lru_lock);
+	dmabufmgr_bo_unreserve_locked(bo);
+	spin_unlock(&dmabufmgr.lru_lock);
+}
+EXPORT_SYMBOL_GPL(dmabufmgr_bo_unreserve);
diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
index 24e88fe..01c4f71 100644
--- a/drivers/base/dma-buf.c
+++ b/drivers/base/dma-buf.c
@@ -40,6 +40,9 @@ static int dma_buf_release(struct inode *inode, struct file *file)
 	dmabuf = file->private_data;
 
 	dmabuf->ops->release(dmabuf);
+	BUG_ON(waitqueue_active(&dmabuf->event_queue));
+	if (dmabuf->sync_buf)
+		dma_buf_put(dmabuf->sync_buf);
 	kfree(dmabuf);
 	return 0;
 }
@@ -119,6 +122,7 @@ struct dma_buf *dma_buf_export(void *priv, const struct dma_buf_ops *ops,
 
 	mutex_init(&dmabuf->lock);
 	INIT_LIST_HEAD(&dmabuf->attachments);
+	init_waitqueue_head(&dmabuf->event_queue);
 
 	return dmabuf;
 }
diff --git a/include/linux/dma-buf-mgr.h b/include/linux/dma-buf-mgr.h
new file mode 100644
index 0000000..b26462e
--- /dev/null
+++ b/include/linux/dma-buf-mgr.h
@@ -0,0 +1,84 @@
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
+/** Size of each hwcontext in synchronization dma-buf */
+#define DMABUFMGR_HWCONTEXT_SYNC_ALIGN 16
+
+struct dmabufmgr {
+	spinlock_t lru_lock;
+
+	u32 counter;
+};
+extern struct dmabufmgr dmabufmgr;
+
+extern int
+dmabufmgr_bo_reserve_locked(struct dma_buf *bo,
+			    bool interruptible, bool no_wait,
+			    bool use_sequence, u32 sequence);
+
+extern int
+dmabufmgr_bo_reserve(struct dma_buf *bo,
+		     bool interruptible, bool no_wait,
+		     bool use_sequence, u32 sequence);
+
+extern void
+dmabufmgr_bo_unreserve_locked(struct dma_buf *bo);
+
+extern void
+dmabufmgr_bo_unreserve(struct dma_buf *bo);
+
+extern int
+dmabufmgr_bo_wait_unreserved(struct dma_buf *bo, bool interruptible);
+
+/* execbuf util support for reservations
+ * matches ttm_execbuf_util
+ */
+struct dmabufmgr_validate {
+	struct list_head head;
+	struct dma_buf *bo;
+	bool reserved;
+
+	/* If non-null, check for attachments */
+	struct dma_buf *sync_buf;
+	u32 sync_ofs, sync_val;
+};
+
+/** reserve a linked list of struct dmabufmgr_validate entries */
+extern int
+dmabufmgr_eu_reserve_buffers(struct list_head *list);
+
+/** Undo reservation */
+extern void
+dmabufmgr_eu_backoff_reservation(struct list_head *list);
+
+/** Commit reservation */
+extern void
+dmabufmgr_eu_fence_buffer_objects(struct dma_buf *sync_buf, u32 ofs, u32 val, struct list_head *list);
+
+#endif /* __DMA_BUF_MGR_H__ */
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index eb48f38..b2ab395 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -113,6 +113,8 @@ struct dma_buf_ops {
  * @attachments: list of dma_buf_attachment that denotes all devices attached.
  * @ops: dma_buf_ops associated with this buffer object.
  * @priv: exporter specific private data for this buffer object.
+ * @bufmgr_entry: used by dmabufmgr
+ * @bufdev: used by dmabufmgr
  */
 struct dma_buf {
 	size_t size;
@@ -122,6 +124,24 @@ struct dma_buf {
 	/* mutex to serialize list manipulation and attach/detach */
 	struct mutex lock;
 	void *priv;
+
+	/** dmabufmgr members */
+	wait_queue_head_t event_queue;
+
+	/**
+	 * dmabufmgr members protected by the dmabufmgr::lru_lock.
+	 */
+	u32 val_seq;
+	bool seq_valid;
+
+	struct dma_buf *sync_buf;
+	u32 sync_ofs, sync_val;
+
+	/**
+	 * dmabufmgr members protected by the dmabufmgr::lru_lock
+	 * only when written to.
+	 */
+	atomic_t reserved;
 };
 
 /**
