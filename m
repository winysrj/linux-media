Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:34906 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbbJFJ7I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2015 05:59:08 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NVS012WCMEF7A40@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2015 18:59:03 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [PATCH] media: videobuf2: Add new uAPI for DVB streaming I/O
Date: Tue, 06 Oct 2015 18:59:01 +0900
Message-id: <1444125542-1256-2-git-send-email-jh1009.sung@samsung.com>
In-reply-to: <1444125542-1256-1-git-send-email-jh1009.sung@samsung.com>
References: <1444125542-1256-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new uAPI for DVB to use streaming I/O which is implemented
based on videobuf2.

- DMX_REQBUFS : Request kernel to allocate buffers which count and size
  are dedicated by user.
- DMX_QUERYBUF : Get the buffer information like a memory offset which
  will mmap() and be shared with user-space.
- DMX_EXPBUF : Just for testing whether buffer-exporting success or not.
- DMX_QBUF : Pass the buffer to kernel-space.
- DMX_DQBUF : Get back the buffer which may contain TS data.

Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/media/dvb-core/Makefile  |    2 +-
 drivers/media/dvb-core/dmxdev.c  |  189 +++++++++++++++---
 drivers/media/dvb-core/dmxdev.h  |    4 +
 drivers/media/dvb-core/dvb_vb2.c |  406 ++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_vb2.h |   69 +++++++
 include/uapi/linux/dvb/dmx.h     |   66 ++++++-
 6 files changed, 709 insertions(+), 27 deletions(-)
 create mode 100644 drivers/media/dvb-core/dvb_vb2.c
 create mode 100644 drivers/media/dvb-core/dvb_vb2.h

diff --git a/drivers/media/dvb-core/Makefile b/drivers/media/dvb-core/Makefile
index 8f22bcd..9b2e4e9 100644
--- a/drivers/media/dvb-core/Makefile
+++ b/drivers/media/dvb-core/Makefile
@@ -6,6 +6,6 @@ dvb-net-$(CONFIG_DVB_NET) := dvb_net.o
 
 dvb-core-objs := dvbdev.o dmxdev.o dvb_demux.o dvb_filter.o 	\
 		 dvb_ca_en50221.o dvb_frontend.o 		\
-		 $(dvb-net-y) dvb_ringbuffer.o dvb_math.o
+		 $(dvb-net-y) dvb_ringbuffer.o dvb_vb2.o dvb_math.o
 
 obj-$(CONFIG_DVB_CORE) += dvb-core.o
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index d0e3f9d..d386abe 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -30,6 +30,7 @@
 #include <linux/wait.h>
 #include <asm/uaccess.h>
 #include "dmxdev.h"
+#include "dvb_vb2.h"
 
 static int debug;
 
@@ -136,14 +137,8 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 	}
 
-	if ((file->f_flags & O_ACCMODE) == O_RDWR) {
-		if (!(dmxdev->capabilities & DMXDEV_CAP_DUPLEX)) {
-			mutex_unlock(&dmxdev->mutex);
-			return -EOPNOTSUPP;
-		}
-	}
-
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
+	if (((file->f_flags & O_ACCMODE) == O_RDONLY)
+			|| ((file->f_flags & O_ACCMODE) == O_RDWR)) {
 		void *mem;
 		if (!dvbdev->readers) {
 			mutex_unlock(&dmxdev->mutex);
@@ -155,6 +150,8 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 			return -ENOMEM;
 		}
 		dvb_ringbuffer_init(&dmxdev->dvr_buffer, mem, DVR_BUFFER_SIZE);
+		dvb_vb2_init(&dmxdev->dvr_vb2_ctx, "dvr",
+				file->f_flags & O_NONBLOCK);
 		dvbdev->readers--;
 	}
 
@@ -192,7 +189,8 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 		dmxdev->demux->connect_frontend(dmxdev->demux,
 						dmxdev->dvr_orig_fe);
 	}
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
+	if (((file->f_flags & O_ACCMODE) == O_RDONLY)
+			|| ((file->f_flags & O_ACCMODE) == O_RDWR)) {
 		dvbdev->readers++;
 		if (dmxdev->dvr_buffer.data) {
 			void *mem = dmxdev->dvr_buffer.data;
@@ -202,6 +200,9 @@ static int dvb_dvr_release(struct inode *inode, struct file *file)
 			spin_unlock_irq(&dmxdev->lock);
 			vfree(mem);
 		}
+		if (dvb_vb2_is_streaming(&dmxdev->dvr_vb2_ctx))
+			dvb_vb2_stream_off(&dmxdev->dvr_vb2_ctx);
+		dvb_vb2_release(&dmxdev->dvr_vb2_ctx);
 	}
 	/* TODO */
 	dvbdev->users--;
@@ -358,7 +359,8 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 	struct dmxdev_filter *dmxdevfilter = filter->priv;
 	int ret;
 
-	if (dmxdevfilter->buffer.error) {
+	if (!dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx)
+			&& dmxdevfilter->buffer.error) {
 		wake_up(&dmxdevfilter->buffer.queue);
 		return 0;
 	}
@@ -369,11 +371,20 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 	}
 	del_timer(&dmxdevfilter->timer);
 	dprintk("dmxdev: section callback %*ph\n", 6, buffer1);
-	ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer, buffer1,
-				      buffer1_len);
-	if (ret == buffer1_len) {
-		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer, buffer2,
-					      buffer2_len);
+
+	if (dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx)) {
+		ret = dvb_vb2_fill_buffer(&dmxdevfilter->vb2_ctx,
+				buffer1, buffer1_len);
+		if (ret == buffer1_len)
+			ret = dvb_vb2_fill_buffer(&dmxdevfilter->vb2_ctx,
+					buffer2, buffer2_len);
+	} else {
+		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer,
+				buffer1, buffer1_len);
+		if (ret == buffer1_len) {
+			ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer,
+					buffer2, buffer2_len);
+		}
 	}
 	if (ret < 0)
 		dmxdevfilter->buffer.error = ret;
@@ -391,6 +402,7 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 {
 	struct dmxdev_filter *dmxdevfilter = feed->priv;
 	struct dvb_ringbuffer *buffer;
+	struct dvb_vb2_ctx *ctx;
 	int ret;
 
 	spin_lock(&dmxdevfilter->dev->lock);
@@ -400,18 +412,29 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	}
 
 	if (dmxdevfilter->params.pes.output == DMX_OUT_TAP
-	    || dmxdevfilter->params.pes.output == DMX_OUT_TSDEMUX_TAP)
+	    || dmxdevfilter->params.pes.output == DMX_OUT_TSDEMUX_TAP) {
 		buffer = &dmxdevfilter->buffer;
-	else
+		ctx = &dmxdevfilter->vb2_ctx;
+	} else {
 		buffer = &dmxdevfilter->dev->dvr_buffer;
-	if (buffer->error) {
-		spin_unlock(&dmxdevfilter->dev->lock);
-		wake_up(&buffer->queue);
-		return 0;
+		ctx = &dmxdevfilter->dev->dvr_vb2_ctx;
+	}
+
+	if (dvb_vb2_is_streaming(ctx)) {
+		ret = dvb_vb2_fill_buffer(ctx, buffer1, buffer1_len);
+		if (ret == buffer1_len)
+			ret = dvb_vb2_fill_buffer(ctx, buffer2, buffer2_len);
+	} else {
+		if (buffer->error) {
+			spin_unlock(&dmxdevfilter->dev->lock);
+			wake_up(&buffer->queue);
+			return 0;
+		}
+		ret = dvb_dmxdev_buffer_write(buffer, buffer1, buffer1_len);
+		if (ret == buffer1_len)
+			ret = dvb_dmxdev_buffer_write(buffer,
+					buffer2, buffer2_len);
 	}
-	ret = dvb_dmxdev_buffer_write(buffer, buffer1, buffer1_len);
-	if (ret == buffer1_len)
-		ret = dvb_dmxdev_buffer_write(buffer, buffer2, buffer2_len);
 	if (ret < 0)
 		buffer->error = ret;
 	spin_unlock(&dmxdevfilter->dev->lock);
@@ -750,6 +773,8 @@ static int dvb_demux_open(struct inode *inode, struct file *file)
 	file->private_data = dmxdevfilter;
 
 	dvb_ringbuffer_init(&dmxdevfilter->buffer, NULL, 8192);
+	dvb_vb2_init(&dmxdevfilter->vb2_ctx, "demux_filter",
+			file->f_flags & O_NONBLOCK);
 	dmxdevfilter->type = DMXDEV_TYPE_NONE;
 	dvb_dmxdev_filter_state_set(dmxdevfilter, DMXDEV_STATE_ALLOCATED);
 	init_timer(&dmxdevfilter->timer);
@@ -766,6 +791,10 @@ static int dvb_dmxdev_filter_free(struct dmxdev *dmxdev,
 	mutex_lock(&dmxdev->mutex);
 	mutex_lock(&dmxdevfilter->mutex);
 
+	if (dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx))
+		dvb_vb2_stream_off(&dmxdevfilter->vb2_ctx);
+	dvb_vb2_release(&dmxdevfilter->vb2_ctx);
+
 	dvb_dmxdev_filter_stop(dmxdevfilter);
 	dvb_dmxdev_filter_reset(dmxdevfilter);
 
@@ -1068,6 +1097,53 @@ static int dvb_demux_do_ioctl(struct file *file,
 		mutex_unlock(&dmxdevfilter->mutex);
 		break;
 
+	case DMX_REQBUFS:
+		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
+			mutex_unlock(&dmxdev->mutex);
+			return -ERESTARTSYS;
+		}
+		ret = dvb_vb2_reqbufs(&dmxdevfilter->vb2_ctx, parg);
+		mutex_unlock(&dmxdevfilter->mutex);
+		break;
+
+	case DMX_QUERYBUF:
+		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
+			mutex_unlock(&dmxdev->mutex);
+			return -ERESTARTSYS;
+		}
+		ret = dvb_vb2_querybuf(&dmxdevfilter->vb2_ctx, parg);
+		mutex_unlock(&dmxdevfilter->mutex);
+		break;
+
+	case DMX_EXPBUF:
+		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
+			mutex_unlock(&dmxdev->mutex);
+			return -ERESTARTSYS;
+		}
+		ret = dvb_vb2_expbuf(&dmxdevfilter->vb2_ctx, parg);
+		mutex_unlock(&dmxdevfilter->mutex);
+		break;
+
+	case DMX_QBUF:
+		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
+			mutex_unlock(&dmxdev->mutex);
+			return -ERESTARTSYS;
+		}
+		ret = dvb_vb2_qbuf(&dmxdevfilter->vb2_ctx, parg);
+		if (ret == 0 && !dvb_vb2_is_streaming(&dmxdevfilter->vb2_ctx))
+			ret = dvb_vb2_stream_on(&dmxdevfilter->vb2_ctx);
+		mutex_unlock(&dmxdevfilter->mutex);
+		break;
+
+	case DMX_DQBUF:
+		if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
+			mutex_unlock(&dmxdev->mutex);
+			return -ERESTARTSYS;
+		}
+		ret = dvb_vb2_dqbuf(&dmxdevfilter->vb2_ctx, parg);
+		mutex_unlock(&dmxdevfilter->mutex);
+		break;
+
 	default:
 		ret = -EINVAL;
 		break;
@@ -1106,6 +1182,27 @@ static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
+static int dvb_demux_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct dmxdev_filter *dmxdevfilter = file->private_data;
+	struct dmxdev *dmxdev = dmxdevfilter->dev;
+	int ret;
+
+	if (mutex_lock_interruptible(&dmxdev->mutex))
+		return -ERESTARTSYS;
+
+	if (mutex_lock_interruptible(&dmxdevfilter->mutex)) {
+		mutex_unlock(&dmxdev->mutex);
+		return -ERESTARTSYS;
+	}
+	ret = dvb_vb2_mmap(&dmxdevfilter->vb2_ctx, vma);
+
+	mutex_unlock(&dmxdevfilter->mutex);
+	mutex_unlock(&dmxdev->mutex);
+
+	return ret;
+}
+
 static int dvb_demux_release(struct inode *inode, struct file *file)
 {
 	struct dmxdev_filter *dmxdevfilter = file->private_data;
@@ -1134,6 +1231,7 @@ static const struct file_operations dvb_demux_fops = {
 	.release = dvb_demux_release,
 	.poll = dvb_demux_poll,
 	.llseek = default_llseek,
+	.mmap = dvb_demux_mmap,
 };
 
 static const struct dvb_device dvbdev_demux = {
@@ -1162,6 +1260,28 @@ static int dvb_dvr_do_ioctl(struct file *file,
 		ret = dvb_dvr_set_buffer_size(dmxdev, arg);
 		break;
 
+	case DMX_REQBUFS:
+		ret = dvb_vb2_reqbufs(&dmxdev->dvr_vb2_ctx, parg);
+		break;
+
+	case DMX_QUERYBUF:
+		ret = dvb_vb2_querybuf(&dmxdev->dvr_vb2_ctx, parg);
+		break;
+
+	case DMX_EXPBUF:
+		ret = dvb_vb2_expbuf(&dmxdev->dvr_vb2_ctx, parg);
+		break;
+
+	case DMX_QBUF:
+		ret = dvb_vb2_qbuf(&dmxdev->dvr_vb2_ctx, parg);
+		if (ret == 0 && !dvb_vb2_is_streaming(&dmxdev->dvr_vb2_ctx))
+			ret = dvb_vb2_stream_on(&dmxdev->dvr_vb2_ctx);
+		break;
+
+	case DMX_DQBUF:
+		ret = dvb_vb2_dqbuf(&dmxdev->dvr_vb2_ctx, parg);
+		break;
+
 	default:
 		ret = -EINVAL;
 		break;
@@ -1189,7 +1309,8 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
 
-	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
+	if (((file->f_flags & O_ACCMODE) == O_RDONLY)
+			|| ((file->f_flags & O_ACCMODE) == O_RDWR)) {
 		if (dmxdev->dvr_buffer.error)
 			mask |= (POLLIN | POLLRDNORM | POLLPRI | POLLERR);
 
@@ -1201,6 +1322,23 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
+static int dvb_dvr_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct dmxdev *dmxdev = dvbdev->priv;
+	int ret;
+
+	if (dmxdev->exit)
+		return -ENODEV;
+
+	if (mutex_lock_interruptible(&dmxdev->mutex))
+		return -ERESTARTSYS;
+
+	ret = dvb_vb2_mmap(&dmxdev->dvr_vb2_ctx, vma);
+	mutex_unlock(&dmxdev->mutex);
+	return ret;
+}
+
 static const struct file_operations dvb_dvr_fops = {
 	.owner = THIS_MODULE,
 	.read = dvb_dvr_read,
@@ -1210,6 +1348,7 @@ static const struct file_operations dvb_dvr_fops = {
 	.release = dvb_dvr_release,
 	.poll = dvb_dvr_poll,
 	.llseek = default_llseek,
+	.mmap = dvb_dvr_mmap,
 };
 
 static const struct dvb_device dvbdev_dvr = {
diff --git a/drivers/media/dvb-core/dmxdev.h b/drivers/media/dvb-core/dmxdev.h
index 48c6cf9..40983de 100644
--- a/drivers/media/dvb-core/dmxdev.h
+++ b/drivers/media/dvb-core/dmxdev.h
@@ -39,6 +39,7 @@
 #include "dvbdev.h"
 #include "demux.h"
 #include "dvb_ringbuffer.h"
+#include "dvb_vb2.h"
 
 enum dmxdev_type {
 	DMXDEV_TYPE_NONE,
@@ -81,6 +82,7 @@ struct dmxdev_filter {
 	enum dmxdev_state state;
 	struct dmxdev *dev;
 	struct dvb_ringbuffer buffer;
+	struct dvb_vb2_ctx vb2_ctx;
 
 	struct mutex mutex;
 
@@ -108,6 +110,8 @@ struct dmxdev {
 	struct dvb_ringbuffer dvr_buffer;
 #define DVR_BUFFER_SIZE (10*188*1024)
 
+	struct dvb_vb2_ctx dvr_vb2_ctx;
+
 	struct mutex mutex;
 	spinlock_t lock;
 };
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
new file mode 100644
index 0000000..1a2dc55
--- /dev/null
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -0,0 +1,406 @@
+/*
+ * dvb-vb2.c - dvb-vb2
+ *
+ * Copyright (C) 2015 Samsung Electronics
+ *
+ * Author: jh1009.sung@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+
+#include "dvbdev.h"
+#include "dvb_vb2.h"
+
+static int vb2_debug;
+module_param(vb2_debug, int, 0644);
+
+#define dprintk(level, fmt, arg...)					      \
+	do {								      \
+		if (vb2_debug >= level)					      \
+			pr_info("vb2: %s: " fmt, __func__, ## arg); \
+	} while (0)
+
+static int _queue_setup(struct vb2_queue *vq, const struct vb2_format *fmt,
+				unsigned int *nbuffers, unsigned int *nplanes,
+				unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
+
+	*nbuffers = ctx->buf_cnt;
+	*nplanes = 1;
+	sizes[0] = ctx->buf_siz;
+
+	/*
+	 * videobuf2-vmalloc allocator is context-less so no need to set
+	 * alloc_ctxs array.
+	 */
+
+	dprintk(3, "[%s] count=%d, size=%d\n", ctx->name,
+			*nbuffers, sizes[0]);
+
+	return 0;
+}
+
+static int _buffer_prepare(struct vb2_buffer *vb)
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size = ctx->buf_siz;
+
+	if (vb2_plane_size(vb, 0) < size) {
+		dprintk(1, "[%s] data will not fit into plane (%lu < %lu)\n",
+				ctx->name, vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
+	dprintk(3, "[%s]\n", ctx->name);
+
+	return 0;
+}
+
+static void _buffer_queue(struct vb2_buffer *vb)
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct dvb_buffer *buf = container_of(vb, struct dvb_buffer, vb);
+	unsigned long flags = 0;
+
+	spin_lock_irqsave(&ctx->slock, flags);
+	list_add_tail(&buf->list, &ctx->dvb_q);
+	spin_unlock_irqrestore(&ctx->slock, flags);
+
+	dprintk(3, "[%s]\n", ctx->name);
+}
+
+static int _start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
+
+	dprintk(3, "[%s] count=%d\n", ctx->name, count);
+	return 0;
+}
+
+static void _stop_streaming(struct vb2_queue *vq)
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
+
+	dprintk(3, "[%s]\n", ctx->name);
+}
+
+static void _dmxdev_lock(struct vb2_queue *vq)
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
+
+	mutex_lock(&ctx->mutex);
+	dprintk(3, "[%s]\n", ctx->name);
+}
+
+static void _dmxdev_unlock(struct vb2_queue *vq)
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vq);
+
+	if (mutex_is_locked(&ctx->mutex))
+		mutex_unlock(&ctx->mutex);
+	dprintk(3, "[%s]\n", ctx->name);
+}
+
+static const struct vb2_ops dvb_vb2_qops = {
+	.queue_setup		= _queue_setup,
+	.buf_prepare		= _buffer_prepare,
+	.buf_queue		= _buffer_queue,
+	.start_streaming	= _start_streaming,
+	.stop_streaming		= _stop_streaming,
+	.wait_prepare		= _dmxdev_unlock,
+	.wait_finish		= _dmxdev_lock,
+};
+
+static int _fill_dmx_buffer(struct vb2_buffer *vb, void *pb)
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct dmx_buffer *b = pb;
+
+	b->index = vb->index;
+	b->length = vb->planes[0].length;
+	b->bytesused = vb->planes[0].bytesused;
+	b->offset = vb->planes[0].m.offset;
+	memset(b->reserved, 0, sizeof(b->reserved));
+	dprintk(3, "[%s]\n", ctx->name);
+
+	return 0;
+}
+
+static int _fill_vb2_buffer(struct vb2_buffer *vb,
+		const void *pb, struct vb2_plane *planes)
+{
+	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	planes[0].bytesused = 0;
+	dprintk(3, "[%s]\n", ctx->name);
+
+	return 0;
+}
+
+static const struct vb2_buf_ops dvb_vb2_buf_ops = {
+	.fill_user_buffer	= _fill_dmx_buffer,
+	.fill_vb2_buffer	= _fill_vb2_buffer,
+};
+
+/*
+ * Videobuf operations
+ */
+int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int nonblocking)
+{
+	struct vb2_queue *q = &ctx->vb_q;
+	int ret;
+
+	memset(ctx, 0, sizeof(struct dvb_vb2_ctx));
+	q->type = DVB_BUF_TYPE_CAPTURE;
+	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ | VB2_DMABUF;
+	q->drv_priv = ctx;
+	q->buf_struct_size = sizeof(struct dvb_buffer);
+	q->min_buffers_needed = 1;
+	q->ops = &dvb_vb2_qops;
+	q->mem_ops = &vb2_vmalloc_memops;
+	q->buf_ops = &dvb_vb2_buf_ops;
+	q->num_buffers = 0;
+
+	ret = vb2_core_queue_init(q);
+	if (ret) {
+		ctx->state = DVB_VB2_STATE_NONE;
+		dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
+		return ret;
+	}
+
+	mutex_init(&ctx->mutex);
+	spin_lock_init(&ctx->slock);
+	INIT_LIST_HEAD(&ctx->dvb_q);
+
+	strncpy(ctx->name, name, DVB_VB2_NAME_MAX);
+	ctx->nonblocking = nonblocking;
+	ctx->state = DVB_VB2_STATE_INIT;
+
+	dprintk(3, "[%s]\n", ctx->name);
+
+	return 0;
+}
+
+int dvb_vb2_release(struct dvb_vb2_ctx *ctx)
+{
+	struct vb2_queue *q = (struct vb2_queue *)&ctx->vb_q;
+
+	if (ctx->state && DVB_VB2_STATE_INIT)
+		vb2_core_queue_release(q);
+
+	ctx->state = DVB_VB2_STATE_NONE;
+	dprintk(3, "[%s]\n", ctx->name);
+
+	return 0;
+}
+
+int dvb_vb2_stream_on(struct dvb_vb2_ctx *ctx)
+{
+	struct vb2_queue *q = &ctx->vb_q;
+	int ret;
+
+	ret = vb2_core_streamon(q, q->type);
+	if (ret) {
+		ctx->state = DVB_VB2_STATE_NONE;
+		dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
+		return ret;
+	}
+	ctx->state |= DVB_VB2_STATE_STREAMON;
+	dprintk(3, "[%s]\n", ctx->name);
+
+	return 0;
+}
+
+int dvb_vb2_stream_off(struct dvb_vb2_ctx *ctx)
+{
+	struct vb2_queue *q = (struct vb2_queue *)&ctx->vb_q;
+	int ret;
+	int i;
+
+	ctx->state &= ~DVB_VB2_STATE_STREAMON;
+
+	for (i = 0; i < q->num_buffers; ++i) {
+		if (q->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
+			vb2_buffer_done(q->bufs[i], VB2_BUF_STATE_ERROR);
+
+	}
+
+	ret = vb2_core_streamoff(q, q->type);
+	if (ret) {
+		ctx->state = DVB_VB2_STATE_NONE;
+		dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
+		return ret;
+	}
+	dprintk(3, "[%s]\n", ctx->name);
+
+	return 0;
+}
+
+int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx)
+{
+	return (ctx->state & DVB_VB2_STATE_STREAMON);
+}
+
+int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
+		const unsigned char *src, int len)
+{
+	unsigned long flags = 0;
+	void *vbuf;
+	int todo = len;
+	unsigned char *psrc = (unsigned char *)src;
+	int ll;
+
+	while (todo) {
+		if (!ctx->buf) {
+			if (list_empty(&ctx->dvb_q)) {
+				dprintk(3, "[%s] Buffer overflow!!!\n",
+						ctx->name);
+				break;
+			}
+
+			spin_lock_irqsave(&ctx->slock, flags);
+			ctx->buf = list_entry(ctx->dvb_q.next,
+					struct dvb_buffer, list);
+			list_del(&ctx->buf->list);
+			ctx->remain = vb2_plane_size(&ctx->buf->vb, 0);
+			ctx->offset = 0;
+			spin_unlock_irqrestore(&ctx->slock, flags);
+		}
+
+		if (!dvb_vb2_is_streaming(ctx)) {
+			vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_ERROR);
+			ctx->buf = NULL;
+			break;
+		}
+
+		/* Fill buffer */
+		vbuf = vb2_plane_vaddr(&ctx->buf->vb, 0);
+
+		ll = min(todo, ctx->remain);
+		memcpy(vbuf+ctx->offset, psrc, ll);
+		todo -= ll;
+		psrc += ll;
+
+		ctx->remain -= ll;
+		ctx->offset += ll;
+
+		if (ctx->remain == 0) {
+			vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_DONE);
+			ctx->buf = NULL;
+		}
+	}
+
+	if (ctx->nonblocking && ctx->buf) {
+		vb2_buffer_done(&ctx->buf->vb, VB2_BUF_STATE_DONE);
+		ctx->buf = NULL;
+	}
+
+	if (todo)
+		dprintk(1, "[%s] %d bytes are dropped.\n", ctx->name, todo);
+	else
+		dprintk(3, "[%s]\n", ctx->name);
+
+	return (len - todo);
+}
+
+int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req)
+{
+	int ret;
+
+	ctx->buf_siz = req->size;
+	ctx->buf_cnt = req->count;
+
+	ret = vb2_core_reqbufs(&ctx->vb_q, VB2_MEMORY_MMAP, &req->count);
+	if (ret) {
+		ctx->state = DVB_VB2_STATE_NONE;
+		dprintk(1, "[%s] count=%d size=%d errno=%d\n", ctx->name,
+			ctx->buf_cnt, ctx->buf_siz, ret);
+		return ret;
+	}
+	ctx->state |= DVB_VB2_STATE_REQBUFS;
+	dprintk(3, "[%s] count=%d size=%d\n", ctx->name,
+			ctx->buf_cnt, ctx->buf_siz);
+
+	return 0;
+}
+
+int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
+{
+	int ret;
+
+	ret = vb2_core_querybuf(&ctx->vb_q, b->index, b);
+	if (ret) {
+		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
+				b->index, ret);
+		return ret;
+	}
+	dprintk(3, "[%s] index=%d\n", ctx->name, b->index);
+
+	return 0;
+}
+
+int dvb_vb2_expbuf(struct dvb_vb2_ctx *ctx, struct dmx_exportbuffer *exp)
+{
+	struct vb2_queue *q = &ctx->vb_q;
+	int ret;
+
+	ret = vb2_core_expbuf(&ctx->vb_q, &exp->fd, q->type, exp->index,
+				0, exp->flags);
+	if (ret) {
+		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
+				exp->index, ret);
+		return ret;
+	}
+	dprintk(3, "[%s] index=%d fd=%d\n", ctx->name, exp->index, exp->fd);
+
+	return 0;
+}
+
+int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
+{
+	int ret;
+
+	ret = vb2_core_qbuf(&ctx->vb_q, b->index, b);
+	if (ret) {
+		dprintk(1, "[%s] index=%d errno=%d\n", ctx->name,
+				b->index, ret);
+		return ret;
+	}
+	dprintk(5, "[%s] index=%d\n", ctx->name, b->index);
+
+	return 0;
+}
+
+int dvb_vb2_dqbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b)
+{
+	int ret;
+
+	ret = vb2_core_dqbuf(&ctx->vb_q, b, ctx->nonblocking);
+	if (ret) {
+		dprintk(1, "[%s] errno=%d\n", ctx->name, ret);
+		return ret;
+	}
+	dprintk(5, "[%s] index=%d\n", ctx->name, b->index);
+
+	return 0;
+}
+
+int dvb_vb2_mmap(struct dvb_vb2_ctx *ctx, struct vm_area_struct *vma)
+{
+	int ret;
+
+	ret = vb2_mmap(&ctx->vb_q, vma);
+	dprintk(3, "[%s] ret=%d\n", ctx->name, ret);
+
+	return 0;
+
+}
diff --git a/drivers/media/dvb-core/dvb_vb2.h b/drivers/media/dvb-core/dvb_vb2.h
new file mode 100644
index 0000000..5c6377d
--- /dev/null
+++ b/drivers/media/dvb-core/dvb_vb2.h
@@ -0,0 +1,69 @@
+/*
+ * dvb-vb2.h - DVB driver helper framework for streaming I/O
+ *
+ * Copyright (C) 2015 Samsung Electronics
+ *
+ * Author: jh1009.sung@samsung.com
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _DVB_VB2_H
+#define _DVB_VB2_H
+
+#include <linux/mutex.h>
+#include <linux/dvb/dmx.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/videobuf2-vmalloc.h>
+
+enum dvb_buf_type {
+	DVB_BUF_TYPE_CAPTURE        = 1,
+	DVB_BUF_TYPE_OUTPUT         = 2,
+};
+
+#define DVB_VB2_STATE_NONE (0x0)
+#define DVB_VB2_STATE_INIT (0x1)
+#define DVB_VB2_STATE_REQBUFS (0x2)
+#define DVB_VB2_STATE_STREAMON (0x4)
+
+#define DVB_VB2_NAME_MAX (20)
+
+struct dvb_buffer {
+	struct vb2_buffer	vb;
+	struct list_head	list;
+};
+
+struct dvb_vb2_ctx {
+	struct vb2_queue	vb_q;
+	struct mutex		mutex;
+	spinlock_t		slock;
+	struct list_head	dvb_q;
+	struct dvb_buffer	*buf;
+	int	offset;
+	int	remain;
+	int	state;
+	int	buf_siz;
+	int	buf_cnt;
+	int	nonblocking;
+	char	name[DVB_VB2_NAME_MAX+1];
+};
+
+int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int non_blocking);
+int dvb_vb2_release(struct dvb_vb2_ctx *ctx);
+int dvb_vb2_stream_on(struct dvb_vb2_ctx *ctx);
+int dvb_vb2_stream_off(struct dvb_vb2_ctx *ctx);
+int dvb_vb2_is_streaming(struct dvb_vb2_ctx *ctx);
+int dvb_vb2_fill_buffer(struct dvb_vb2_ctx *ctx,
+			const unsigned char *src, int len);
+
+int dvb_vb2_reqbufs(struct dvb_vb2_ctx *ctx, struct dmx_requestbuffers *req);
+int dvb_vb2_querybuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
+int dvb_vb2_expbuf(struct dvb_vb2_ctx *ctx, struct dmx_exportbuffer *exp);
+int dvb_vb2_qbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
+int dvb_vb2_dqbuf(struct dvb_vb2_ctx *ctx, struct dmx_buffer *b);
+int dvb_vb2_mmap(struct dvb_vb2_ctx *ctx, struct vm_area_struct *vma);
+
+#endif /* _DVB_VB2_H */
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index 427e489..a8b062d 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -140,6 +140,64 @@ struct dmx_stc {
 	__u64 stc;		/* output: stc in 'base'*90 kHz units */
 };
 
+/**
+ * struct dmx_buffer - dmx buffer info
+ *
+ * @index:	id number of the buffer
+ * @bytesused:	number of bytes occupied by data in the buffer (payload);
+ * @offset:	for buffers with memory == DMX_MEMORY_MMAP;
+ *		offset from the start of the device memory for this plane,
+ *		(or a "cookie" that should be passed to mmap() as offset)
+ * @length:	size in bytes of the buffer
+ *
+ * Contains data exchanged by application and driver using one of the streaming
+ * I/O methods.
+ */
+struct dmx_buffer {
+	__u32			index;
+	__u32			bytesused;
+	__u32			offset;
+	__u32			length;
+	__u32			reserved[4];
+};
+
+/**
+ * struct dmx_requestbuffers - request dmx buffer information
+ *
+ * @count:	number of requested buffers,
+ * @size:	size in bytes of the requested buffer
+ *
+ * Contains data used for requesting a dmx buffer.
+ * All reserved fields must be set to zero.
+ */
+struct dmx_requestbuffers {
+	__u32			count;
+	__u32			size;
+	__u32			reserved[2];
+};
+
+/**
+ * struct dmx_exportbuffer - export of dmx buffer as DMABUF file descriptor
+ *
+ * @index:	id number of the buffer
+ * @flags:	flags for newly created file, currently only O_CLOEXEC is
+ *		supported, refer to manual of open syscall for more details
+ * @fd:		file descriptor associated with DMABUF (set by driver)
+ *
+ * Contains data used for exporting a dmx buffer as DMABUF file descriptor.
+ * The buffer is identified by a 'cookie' returned by DMX_QUERYBUF
+ * (identical to the cookie used to mmap() the buffer to userspace). All
+ * reserved fields must be set to zero. The field reserved0 is expected to
+ * become a structure 'type' allowing an alternative layout of the structure
+ * content. Therefore this field should not be used for any other extensions.
+ */
+struct dmx_exportbuffer {
+	__u32		index;
+	__u32		flags;
+	__s32		fd;
+	__u32		reserved[5];
+};
+
 #define DMX_START                _IO('o', 41)
 #define DMX_STOP                 _IO('o', 42)
 #define DMX_SET_FILTER           _IOW('o', 43, struct dmx_sct_filter_params)
@@ -152,4 +210,10 @@ struct dmx_stc {
 #define DMX_ADD_PID              _IOW('o', 51, __u16)
 #define DMX_REMOVE_PID           _IOW('o', 52, __u16)
 
-#endif /* _UAPI_DVBDMX_H_ */
+#define DMX_REQBUFS              _IOWR('o', 60, struct dmx_requestbuffers)
+#define DMX_QUERYBUF             _IOWR('o', 61, struct dmx_buffer)
+#define DMX_EXPBUF               _IOWR('o', 62, struct dmx_exportbuffer)
+#define DMX_QBUF                 _IOWR('o', 63, struct dmx_buffer)
+#define DMX_DQBUF                _IOWR('o', 64, struct dmx_buffer)
+
+#endif /* _DVBDMX_H_ */
-- 
1.7.9.5

