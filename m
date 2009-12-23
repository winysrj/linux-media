Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:36343 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbZLWNRs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 08:17:48 -0500
Date: Wed, 23 Dec 2009 14:17:33 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v2.1 1/2] V4L: Add memory-to-memory device helper framework for
 V4L2.
In-reply-to: <1261574255-23386-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1261574255-23386-2-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1261574255-23386-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A mem-to-mem device is a device that uses memory buffers passed by
userspace applications for both source and destination data. This is
different from existing drivers, which use memory buffers for only one
of those at once.

In terms of V4L2 such a device would be both of OUTPUT and CAPTURE type.
Although no such devices are present in the V4L2 framework, a demand for such
a model exists, e.g. for 'resizer devices'.

This patch also adds a separate kconfig submenu for mem-to-mem V4L devices.

Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig        |   14 +
 drivers/media/video/Makefile       |    2 +
 drivers/media/video/v4l2-mem2mem.c |  671 ++++++++++++++++++++++++++++++++++++
 include/media/v4l2-mem2mem.h       |  153 ++++++++
 4 files changed, 840 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/v4l2-mem2mem.c
 create mode 100644 include/media/v4l2-mem2mem.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 2f83be7..4e97dcf 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -45,6 +45,10 @@ config VIDEO_TUNER
 	tristate
 	depends on MEDIA_TUNER
 
+config V4L2_MEM2MEM_DEV
+	tristate
+	depends on VIDEOBUF_GEN
+
 #
 # Multimedia Video device configuration
 #
@@ -1075,3 +1079,13 @@ config USB_S2255
 
 endif # V4L_USB_DRIVERS
 endif # VIDEO_CAPTURE_DRIVERS
+
+menuconfig V4L_MEM2MEM_DRIVERS
+	bool "Memory-to-memory multimedia devices"
+	depends on VIDEO_V4L2
+	default n
+	---help---
+	  Say Y here to enable selecting drivers for V4L devices that
+	  use system memory for both source and destination buffers, as opposed
+	  to capture and output drivers, which use memory buffers for just
+	  one of those.
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 2af68ee..9fe7d40 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -115,6 +115,8 @@ obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
 obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 
+obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
+
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
diff --git a/drivers/media/video/v4l2-mem2mem.c b/drivers/media/video/v4l2-mem2mem.c
new file mode 100644
index 0000000..417ee2c
--- /dev/null
+++ b/drivers/media/video/v4l2-mem2mem.c
@@ -0,0 +1,671 @@
+/*
+ * Memory-to-memory device framework for Video for Linux 2.
+ *
+ * Helper functions for devices that use memory buffers for both source
+ * and destination.
+ *
+ * Copyright (c) 2009 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <p.osciak@samsung.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <media/videobuf-core.h>
+#include <media/v4l2-mem2mem.h>
+
+MODULE_DESCRIPTION("Mem to mem device framework for V4L2");
+MODULE_AUTHOR("Pawel Osciak, <p.osciak@samsung.com>");
+MODULE_LICENSE("GPL");
+
+static int debug;
+module_param(debug, int, 0644);
+
+#define dprintk(fmt, arg...) do {\
+	if (debug >= 1)\
+		printk(KERN_DEBUG "%s: " fmt, __func__, ## arg); } while (0)
+
+
+/* The instance is already queued on the jobqueue */
+#define TRANS_QUEUED		(1 << 0)
+/* The instance is currently running in hardware */
+#define TRANS_RUNNING		(1 << 1)
+
+
+/* Offset base for buffers on the destination queue - used to distinguish
+ * between source and destination buffers when mmapping - they receive the same
+ * offsets but for different queues */
+#define DST_QUEUE_OFF_BASE	(TASK_SIZE / 2)
+
+
+struct v4l2_m2m_dev {
+	/* Currently running instance */
+	struct v4l2_m2m_ctx	*curr_ctx;
+	/* Instances queued to run */
+	struct list_head	jobqueue;
+	spinlock_t		job_spinlock;
+
+	struct v4l2_m2m_ops	*m2m_ops;
+};
+
+static inline
+struct v4l2_m2m_queue_ctx *get_queue_ctx(struct v4l2_m2m_ctx *m2m_ctx,
+					 enum v4l2_buf_type type)
+{
+	switch (type) {
+	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+		return &m2m_ctx->cap_q_ctx;
+	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
+		return &m2m_ctx->out_q_ctx;
+	default:
+		printk(KERN_ERR "Invalid buffer type\n");
+		return NULL;
+	}
+}
+
+/**
+ * v4l2_m2m_get_vq() - return videobuf_queue for the given type
+ */
+struct videobuf_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
+				       enum v4l2_buf_type type)
+{
+	struct v4l2_m2m_queue_ctx *q_ctx;
+
+	q_ctx = get_queue_ctx(m2m_ctx, type);
+	if (!q_ctx)
+		return NULL;
+
+	return &q_ctx->q;
+}
+EXPORT_SYMBOL(v4l2_m2m_get_vq);
+
+/**
+ * v4l2_m2m_get_src_vq() - return videobuf_queue for source buffers
+ */
+struct videobuf_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+}
+EXPORT_SYMBOL(v4l2_m2m_get_src_vq);
+
+/**
+ * v4l2_m2m_get_dst_vq() - return videobuf_queue for destination buffers
+ */
+struct videobuf_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return v4l2_m2m_get_vq(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+}
+EXPORT_SYMBOL(v4l2_m2m_get_dst_vq);
+
+/**
+ * v4l2_m2m_next_buf() - return next buffer from the list of ready buffers
+ */
+static void *v4l2_m2m_next_buf(struct v4l2_m2m_ctx *m2m_ctx,
+			       enum v4l2_buf_type type)
+{
+	struct v4l2_m2m_queue_ctx *q_ctx;
+	struct videobuf_buffer *vb = NULL;
+
+	q_ctx = get_queue_ctx(m2m_ctx, type);
+
+	vb = list_entry(q_ctx->rdy_queue.next, struct videobuf_buffer, queue);
+	vb->state = VIDEOBUF_ACTIVE;
+
+	return vb;
+}
+
+/**
+ * v4l2_m2m_next_src_buf() - return next source buffer from the list of ready
+ * buffers
+ */
+inline void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return v4l2_m2m_next_buf(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+}
+EXPORT_SYMBOL(v4l2_m2m_next_src_buf);
+
+/**
+ * v4l2_m2m_next_dst_buf() - return next destination buffer from the list of
+ * ready buffers
+ */
+inline void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return v4l2_m2m_next_buf(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+}
+EXPORT_SYMBOL(v4l2_m2m_next_dst_buf);
+
+/**
+ * v4l2_m2m_buf_remove() - take off a buffer from the list of ready buffers and
+ * return it
+ */
+static void *v4l2_m2m_buf_remove(struct v4l2_m2m_ctx *m2m_ctx,
+				 enum v4l2_buf_type type)
+{
+	struct v4l2_m2m_queue_ctx *q_ctx;
+	struct videobuf_buffer *vb = NULL;
+	unsigned long flags = 0;
+
+	q_ctx = get_queue_ctx(m2m_ctx, type);
+
+	spin_lock_irqsave(q_ctx->q.irqlock, flags);
+	vb = list_entry(q_ctx->rdy_queue.next, struct videobuf_buffer, queue);
+	list_del(&vb->queue);
+	q_ctx->num_rdy--;
+	spin_unlock_irqrestore(q_ctx->q.irqlock, flags);
+
+	return vb;
+}
+
+/**
+ * v4l2_m2m_src_buf_remove() - take off a srouce buffer from the list of ready
+ * buffers and return it
+ */
+void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return v4l2_m2m_buf_remove(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+}
+EXPORT_SYMBOL(v4l2_m2m_src_buf_remove);
+
+/**
+ * v4l2_m2m_dst_buf_remove() - take off a destination buffer from the list of
+ * ready buffers and return it
+ */
+void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return v4l2_m2m_buf_remove(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+}
+EXPORT_SYMBOL(v4l2_m2m_dst_buf_remove);
+
+
+/*
+ * Scheduling handlers
+ */
+
+/**
+ * v4l2_m2m_get_curr_priv() - return driver private data for the currently
+ * running instance or NULL if no instance is running
+ */
+void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev)
+{
+	if (!m2m_dev->curr_ctx)
+		return NULL;
+	else
+		return m2m_dev->curr_ctx->priv;
+}
+EXPORT_SYMBOL(v4l2_m2m_get_curr_priv);
+
+/**
+ * v4l2_m2m_try_run() - select next job to perform and run it if possible
+ *
+ * Get next transaction (if present) from the waiting jobs list and run it.
+ */
+static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
+	if (NULL != m2m_dev->curr_ctx) {
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		dprintk("Another instance is running, won't run now\n");
+		return;
+	}
+
+	if (list_empty(&m2m_dev->jobqueue)) {
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		dprintk("No job pending\n");
+		return;
+	}
+
+	m2m_dev->curr_ctx = list_entry(m2m_dev->jobqueue.next,
+				   struct v4l2_m2m_ctx, queue);
+	m2m_dev->curr_ctx->job_flags |= TRANS_RUNNING;
+	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+
+	m2m_dev->m2m_ops->device_run(m2m_dev->curr_ctx->priv);
+
+	return;
+}
+
+/**
+ * v4l2_m2m_schedule() - add an instance to the pending job queue
+ * @m2m_ctx:	The instance to be added to the pending job queue
+ *
+ * Called when an instance is fully prepared to run a transaction, i.e. the
+ * instance will not sleep before finishing the transaction when run.
+ * If an instance is already on the queue, it will not be added for the second
+ * time and it is the responsibility of the instance to retry this at a later
+ * time.
+ */
+static void v4l2_m2m_schedule(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	struct v4l2_m2m_dev *dev = m2m_ctx->m2m_dev;
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&dev->job_spinlock, flags);
+	if (!(m2m_ctx->job_flags & TRANS_QUEUED)) {
+		list_add_tail(&m2m_ctx->queue, &dev->jobqueue);
+		m2m_ctx->job_flags |= TRANS_QUEUED;
+	}
+	spin_unlock_irqrestore(&dev->job_spinlock, flags);
+
+	v4l2_m2m_try_run(dev);
+}
+
+/**
+ * v4l2_m2m_try_schedule() - check whether an instance is ready to be added to
+ * the pending job queue and add it if so.
+ * @m2m_ctx:	m2m context assigned to the instance to be checked
+ *
+ * There are three basic requirements an instance has to meet to be able to run:
+ * 1) at least one source buffer has to be queued,
+ * 2) at least one destination buffer has to be queued,
+ * 3) streaming has to be on.
+ *
+ * There can also be additional, custom requirements. In such case the driver
+ * should supply a custom method (job_ready in v4l2_m2m_ops) that should
+ * return 1 * if the instance is ready.
+ * An example of the above could be an instance that requires more than one
+ * src/dst buffer per transaction.
+ */
+static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	struct v4l2_m2m_dev *m2m_dev;
+	unsigned long flags = 0;
+
+	m2m_dev = m2m_ctx->m2m_dev;
+	dprintk("Trying to schedule a job for m2m_ctx: %p\n", m2m_ctx);
+
+	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
+	if (m2m_ctx->job_flags & TRANS_QUEUED) {
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		dprintk("On job queue already\n");
+		return;
+	}
+	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+
+	/* Checking only one queue is enough, we always turn on both */
+	if (!m2m_ctx->out_q_ctx.q.streaming) {
+		dprintk("Streaming not on, will not schedule\n");
+		return;
+	}
+
+	if (list_empty(&m2m_ctx->out_q_ctx.rdy_queue)) {
+		dprintk("No input buffers available\n");
+		return;
+	}
+	if (list_empty(&m2m_ctx->cap_q_ctx.rdy_queue)) {
+		dprintk("No output buffers available\n");
+		return;
+	}
+
+	if (m2m_dev->m2m_ops->job_ready
+		&& (!m2m_dev->m2m_ops->job_ready(m2m_ctx->priv))) {
+		dprintk("Driver not ready\n");
+		return;
+	}
+
+	dprintk("Instance ready to be scheduled\n");
+	v4l2_m2m_schedule(m2m_ctx);
+}
+
+/**
+ * v4l2_m2m_job_finish() - inform the framework that a job has been finished
+ * and have it clean up
+ *
+ * Called by a driver to yield back the device after it has finished with it.
+ * Should be called as soon as possible after reaching a state which allows
+ * other instances to take control of the device.
+ *
+ * TODO: An instance that fails to give back the device before a predefined
+ * amount of time may have its device ownership taken away forcibly.
+ */
+void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
+			 struct v4l2_m2m_ctx *m2m_ctx)
+{
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
+	if (!m2m_dev->curr_ctx || m2m_dev->curr_ctx != m2m_ctx) {
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		dprintk("Called by an instance not currently running\n");
+		return;
+	}
+
+	/*mutex_lock(&m2m_dev->dev_mutex);*/
+	list_del(&m2m_dev->curr_ctx->queue);
+	m2m_dev->curr_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
+	m2m_dev->curr_ctx = NULL;
+
+	spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+
+	v4l2_m2m_try_run(m2m_dev);
+}
+EXPORT_SYMBOL(v4l2_m2m_job_finish);
+
+/**
+ * v4l2_m2m_reqbufs() - multi-queue-aware REQBUFS multiplexer
+ */
+int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		     struct v4l2_requestbuffers *reqbufs)
+{
+	struct videobuf_queue *vq;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, reqbufs->type);
+	return videobuf_reqbufs(vq, reqbufs);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_reqbufs);
+
+/**
+ * v4l2_m2m_querybuf() - multi-queue-aware QUERYBUF multiplexer
+ *
+ * See v4l2_m2m_mmap() documentation for details.
+ */
+int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_buffer *buf)
+{
+	struct videobuf_queue *vq;
+	int ret = 0;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	ret = videobuf_querybuf(vq, buf);
+
+	if (buf->memory == V4L2_MEMORY_MMAP
+	    && vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		buf->m.offset += DST_QUEUE_OFF_BASE;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_querybuf);
+
+/**
+ * v4l2_m2m_qbuf() - enqueue a source or destination buffer, depending on
+ * the type
+ */
+int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		  struct v4l2_buffer *buf)
+{
+	struct videobuf_queue *vq;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	return videobuf_qbuf(vq, buf);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);
+
+/**
+ * v4l2_m2m_dqbuf() - dequeue a source or destination buffer, depending on
+ * the type
+ */
+int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		   struct v4l2_buffer *buf)
+{
+	struct videobuf_queue *vq;
+
+	vq = v4l2_m2m_get_vq(m2m_ctx, buf->type);
+	return videobuf_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_dqbuf);
+
+/**
+ * v4l2_M2m_streamon() - start streaming
+ */
+int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      enum v4l2_buf_type type)
+{
+	int ret = 0;
+
+	/* These can fail only if the queues are in use,
+	 * but they shouldn't be as we are managing instances manually */
+	ret = videobuf_streamon(&m2m_ctx->out_q_ctx.q);
+	if (ret) {
+		printk(KERN_ERR "Streamon on output queue failed\n");
+		return ret;
+	}
+
+	ret = videobuf_streamon(&m2m_ctx->cap_q_ctx.q);
+	if (ret) {
+		printk(KERN_ERR "Streamon on capture queue failed\n");
+		return ret;
+	}
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_streamon);
+
+/**
+ * v4l2_m2m_streamoff() - stop streaming
+ */
+int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		       enum v4l2_buf_type type)
+{
+	/* streamoff() fails only when we are not streaming */
+	if (videobuf_streamoff(&m2m_ctx->out_q_ctx.q)
+	    || videobuf_streamoff(&m2m_ctx->cap_q_ctx.q))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_streamoff);
+
+/**
+ * v4l2_m2m_poll() - poll replacement, for destination buffers only
+ *
+ * Call from driver's poll() function. Will poll the destination queue only.
+ */
+unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			   struct poll_table_struct *wait)
+{
+	struct videobuf_queue *dst_q = NULL;
+	struct videobuf_buffer *vb = NULL;
+	unsigned int rc = 0;
+
+	dst_q = v4l2_m2m_get_dst_vq(m2m_ctx);
+
+	mutex_lock(&dst_q->vb_lock);
+
+	if (dst_q->streaming) {
+		if (!list_empty(&dst_q->stream))
+			vb = list_entry(dst_q->stream.next,
+					struct videobuf_buffer, stream);
+	}
+	
+	if (!vb)
+		rc = POLLERR;
+
+	if (0 == rc) {
+		poll_wait(file, &vb->done, wait);
+		if (vb->state == VIDEOBUF_DONE || vb->state == VIDEOBUF_ERROR)
+			rc = POLLOUT | POLLRDNORM;
+	}
+
+	mutex_unlock(&dst_q->vb_lock);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_poll);
+
+/**
+ * v4l2_m2m_mmap() - source and destination queues-aware mmap multiplexer
+ *
+ * Call from driver's mmap() function. Will handle mmap() for both queues
+ * seamlessly for videobuffer, which will receive normal per-queue offsets and
+ * proper videobuf queue pointers. The differentation is made outside videobuf
+ * by adding a predefined offset to buffers from one of the queues and
+ * subtracting it before passing it back to videobuf. Only drivers (and
+ * thus applications) receive modified offsets.
+ */
+int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			 struct vm_area_struct *vma)
+{
+	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
+	struct videobuf_queue *vq;
+
+	if (offset < DST_QUEUE_OFF_BASE) {
+		vq = v4l2_m2m_get_src_vq(m2m_ctx);
+	} else {
+		vq = v4l2_m2m_get_dst_vq(m2m_ctx);
+		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
+	}
+
+	return videobuf_mmap_mapper(vq, vma);
+}
+EXPORT_SYMBOL(v4l2_m2m_mmap);
+
+/**
+ * v4l2_m2m_init() - initialize per-driver m2m data
+ *
+ * Usually called from driver's probe() function.
+ */
+struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops)
+{
+	struct v4l2_m2m_dev *m2m_dev;
+
+	if (!m2m_ops)
+		return ERR_PTR(-EINVAL);
+
+	/*BUG_ON(!m2m_ops->job_ready);*/
+	BUG_ON(!m2m_ops->device_run);
+	BUG_ON(!m2m_ops->job_abort);
+
+	m2m_dev = kzalloc(sizeof *m2m_dev, GFP_KERNEL);
+	if (!m2m_dev)
+		return ERR_PTR(-ENOMEM);
+
+	m2m_dev->curr_ctx = NULL;
+	m2m_dev->m2m_ops = m2m_ops;
+	INIT_LIST_HEAD(&m2m_dev->jobqueue);
+	spin_lock_init(&m2m_dev->job_spinlock);
+
+	return m2m_dev;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_init);
+
+/**
+ * v4l2_m2m_release() - cleans up and frees a m2m_dev structure
+ *
+ * Usually called from driver's remove() function.
+ */
+void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev)
+{
+	kfree(m2m_dev);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_release);
+
+/**
+ * v4l2_m2m_ctx_init() - allocate and initialize a m2m context
+ * @priv - driver's instance private data
+ * @m2m_dev - a previously initialized m2m_dev struct
+ * @vq_init - a callback for queue type-specific initialization function to be
+ * used for initializing videobuf_queues
+ *
+ * Usually called from driver's open() function.
+ */
+struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev *m2m_dev,
+			void (*vq_init)(void *priv, struct videobuf_queue *,
+					enum v4l2_buf_type))
+{
+	struct v4l2_m2m_ctx *m2m_ctx;
+	struct v4l2_m2m_queue_ctx *out_q_ctx;
+	struct v4l2_m2m_queue_ctx *cap_q_ctx;
+
+	if (!vq_init)
+		return ERR_PTR(-EINVAL);
+
+	m2m_ctx = kzalloc(sizeof *m2m_ctx, GFP_KERNEL);
+	if (!m2m_ctx)
+		return ERR_PTR(-ENOMEM);
+
+	m2m_ctx->priv = priv;
+	m2m_ctx->m2m_dev = m2m_dev;
+
+	out_q_ctx = get_queue_ctx(m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	cap_q_ctx = get_queue_ctx(m2m_ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	INIT_LIST_HEAD(&out_q_ctx->rdy_queue);
+	INIT_LIST_HEAD(&cap_q_ctx->rdy_queue);
+
+	/*spin_lock_init(&m2m_ctx->queue_lock);*/
+	INIT_LIST_HEAD(&m2m_ctx->queue);
+
+	vq_init(priv, &out_q_ctx->q, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	vq_init(priv, &cap_q_ctx->q, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	out_q_ctx->q.priv_data = cap_q_ctx->q.priv_data = priv;
+
+	return m2m_ctx;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_init);
+
+/**
+ * v4l2_m2m_ctx_release() - release m2m context
+ *
+ * Usually called from driver's release() function.
+ */
+void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	struct v4l2_m2m_dev *m2m_dev;
+	struct videobuf_buffer *vb;
+	unsigned long flags = 0;
+
+	m2m_dev = m2m_ctx->m2m_dev;
+
+	spin_lock_irqsave(&m2m_dev->job_spinlock, flags);
+	if (m2m_ctx->job_flags & TRANS_RUNNING) {
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		m2m_dev->m2m_ops->job_abort(m2m_ctx->priv);
+		dprintk("m2m_ctx %p running, will wait to complete", m2m_ctx);
+		vb = v4l2_m2m_next_dst_buf(m2m_ctx);
+		BUG_ON(NULL == vb);
+		wait_event(vb->done, vb->state != VIDEOBUF_ACTIVE
+				     && vb->state != VIDEOBUF_QUEUED);
+	} else if (m2m_ctx->job_flags & TRANS_QUEUED) {
+		list_del(&m2m_ctx->queue);
+		m2m_ctx->job_flags &= ~(TRANS_QUEUED | TRANS_RUNNING);
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+		dprintk("m2m_ctx: %p had been on queue and was removed\n",
+			m2m_ctx);
+	} else {
+		/* Do nothing, was not on queue/running */
+		spin_unlock_irqrestore(&m2m_dev->job_spinlock, flags);
+	}
+
+	videobuf_stop(&m2m_ctx->cap_q_ctx.q);
+	videobuf_stop(&m2m_ctx->out_q_ctx.q);
+
+	videobuf_mmap_free(&m2m_ctx->cap_q_ctx.q);
+	videobuf_mmap_free(&m2m_ctx->out_q_ctx.q);
+
+	kfree(m2m_ctx);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_ctx_release);
+
+/**
+ * v4l2_m2m_buf_queue() - add a buffer to the proper ready buffers list.
+ *
+ * Call from withing buf_queue() videobuf_queue_ops callback.
+ */
+/* Locking: Caller holds q->irqlock */
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct videobuf_queue *vq,
+			struct videobuf_buffer *vb)
+{
+	struct v4l2_m2m_queue_ctx *q_ctx;
+
+	q_ctx = get_queue_ctx(m2m_ctx, vq->type);
+	if (!q_ctx)
+		return;
+
+	list_add_tail(&vb->queue, &q_ctx->rdy_queue);
+	q_ctx->num_rdy++;
+
+	vb->state = VIDEOBUF_QUEUED;
+
+	v4l2_m2m_try_schedule(m2m_ctx);
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
+
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
new file mode 100644
index 0000000..a5ac3ec
--- /dev/null
+++ b/include/media/v4l2-mem2mem.h
@@ -0,0 +1,153 @@
+/*
+ * Memory-to-memory device framework for Video for Linux 2.
+ *
+ * Helper functions for devices that use memory buffers for both source
+ * and destination.
+ *
+ * Copyright (c) 2009 Samsung Electronics Co., Ltd.
+ * Pawel Osciak, <p.osciak@samsung.com>
+ * Marek Szyprowski, <m.szyprowski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef _MEDIA_V4L2_MEM2MEM_H
+#define _MEDIA_V4L2_MEM2MEM_H
+
+#include <media/videobuf-core.h>
+
+/**
+ * struct v4l2_m2m_ops - mem-to-mem device driver callbacks
+ * @device_run:	required. Begin the actual job (transaction) inside this
+ *		callback.
+ *		The job does NOT have to end before this callback returns
+ *		(and it will be the usual case). When the job finishes,
+ *		v4l2_m2m_job_finish() has to be called.
+ * @job_ready:	optional. Should return 0 if the driver does not have a job
+ *		fully prepared to run yet (i.e. it will not be able to finish a
+ *		transactio without sleeping). If not provided, it will be
+ *		assumed that one source and one destination buffer are all
+ *		that is required for the driver to perform one full transaction.
+ * @job_abort:	required. Informs the driver that it has to abort the currently
+ *		running transaction as soon as possible (i.e. as soon as it can
+ *		stop the device safely; e.g. in the next interrupt handler),
+ *		even if the transaction would not have been finished by then.
+ *		After the driver performs the necessary steps, it has to call
+ *		v4l2_m2m_job_finish() (as if the transaction ended normally).
+ *		This function does not have to (and will usually not) wait
+ *		until the device enters a state when it can be stopped.
+ */
+struct v4l2_m2m_ops {
+	void (*device_run)(void *priv);
+	int (*job_ready)(void *priv);
+	void (*job_abort)(void *priv);
+};
+
+struct v4l2_m2m_dev;
+
+struct v4l2_m2m_queue_ctx {
+/* private: internal use only */
+	struct videobuf_queue	q;
+
+	/* Base value for offsets of mmaped buffers on this queue */
+	unsigned long		offset_base;
+
+	/* Queue for buffers ready to be processed as soon as this
+	 * instance receives access to the device */
+	struct list_head	rdy_queue;
+	u8			num_rdy;
+};
+
+struct v4l2_m2m_ctx {
+/* private: internal use only */
+	struct v4l2_m2m_dev		*m2m_dev;
+
+	/* Capture (output to memory) queue context */
+	struct v4l2_m2m_queue_ctx	cap_q_ctx;
+
+	/* Output (input from memory) queue context */
+	struct v4l2_m2m_queue_ctx	out_q_ctx;
+
+	/* For device job queue */
+	struct list_head		queue;
+	unsigned long			job_flags;
+
+	/* Instance private data */
+	void				*priv;
+};
+
+void *v4l2_m2m_get_curr_priv(struct v4l2_m2m_dev *m2m_dev);
+
+struct videobuf_queue *v4l2_m2m_get_src_vq(struct v4l2_m2m_ctx *m2m_ctx);
+struct videobuf_queue *v4l2_m2m_get_dst_vq(struct v4l2_m2m_ctx *m2m_ctx);
+struct videobuf_queue *v4l2_m2m_get_vq(struct v4l2_m2m_ctx *m2m_ctx,
+				       enum v4l2_buf_type type);
+
+void v4l2_m2m_job_finish(struct v4l2_m2m_dev *m2m_dev,
+			 struct v4l2_m2m_ctx *m2m_ctx);
+
+void *v4l2_m2m_next_src_buf(struct v4l2_m2m_ctx *m2m_ctx);
+void *v4l2_m2m_next_dst_buf(struct v4l2_m2m_ctx *m2m_ctx);
+
+void *v4l2_m2m_src_buf_remove(struct v4l2_m2m_ctx *m2m_ctx);
+void *v4l2_m2m_dst_buf_remove(struct v4l2_m2m_ctx *m2m_ctx);
+
+
+int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		     struct v4l2_requestbuffers *reqbufs);
+
+int v4l2_m2m_querybuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      struct v4l2_buffer *buf);
+
+int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		  struct v4l2_buffer *buf);
+int v4l2_m2m_dqbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		   struct v4l2_buffer *buf);
+
+int v4l2_m2m_streamon(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		      enum v4l2_buf_type type);
+int v4l2_m2m_streamoff(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		       enum v4l2_buf_type type);
+
+unsigned int v4l2_m2m_poll(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+			   struct poll_table_struct *wait);
+
+int v4l2_m2m_mmap(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
+		  struct vm_area_struct *vma);
+
+struct v4l2_m2m_dev *v4l2_m2m_init(struct v4l2_m2m_ops *m2m_ops);
+void v4l2_m2m_release(struct v4l2_m2m_dev *m2m_dev);
+
+struct v4l2_m2m_ctx *v4l2_m2m_ctx_init(void *priv, struct v4l2_m2m_dev *m2m_dev,
+			void (*vq_init)(void *priv, struct videobuf_queue *,
+					enum v4l2_buf_type));
+void v4l2_m2m_ctx_release(struct v4l2_m2m_ctx *m2m_ctx);
+
+void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx, struct videobuf_queue *vq,
+			struct videobuf_buffer *vb);
+
+/**
+ * v4l2_m2m_num_src_bufs_ready() - return the number of source buffers ready for
+ * use
+ */
+static inline
+unsigned int v4l2_m2m_num_src_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return m2m_ctx->cap_q_ctx.num_rdy;
+}
+
+/**
+ * v4l2_m2m_num_src_bufs_ready() - return the number of destination buffers
+ * ready for use
+ */
+static inline
+unsigned int v4l2_m2m_num_dst_bufs_ready(struct v4l2_m2m_ctx *m2m_ctx)
+{
+	return m2m_ctx->out_q_ctx.num_rdy;
+}
+
+#endif /* _MEDIA_V4L2_MEM2MEM_H */
+
-- 
1.6.4.2.253.g0b1fac

