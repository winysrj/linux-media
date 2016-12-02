Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52094 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751786AbcLBKx1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Dec 2016 05:53:27 -0500
Date: Fri, 2 Dec 2016 11:53:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v2 3/3] uvcvideo: add a metadata device node
In-Reply-To: <Pine.LNX.4.64.1606241327550.23461@axis700.grange>
Message-ID: <Pine.LNX.4.64.1612021141110.11357@axis700.grange>
References: <Pine.LNX.4.64.1606241312130.23461@axis700.grange>
 <Pine.LNX.4.64.1606241327550.23461@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some UVC video cameras contain metadata in their payload headers. This
patch extracts that data, skipping the standard part of the header, on
both bulk and isochronous endpoints and makes it available to the user
space on a separate video node, using the V4L2_CAP_META_CAPTURE
capability and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. Even
though different cameras will have different metadata formats, we use
the same V4L2_META_FMT_UVC pixel format for all of them. Users have to
parse data, based on the specific camera model information.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---

v2:
- updated to the current media/master
- removed superfluous META capability from capture nodes
- now the complete UVC payload header is copied to buffers, including 
  standard fields

Still open for discussion: is this really OK to always create an 
additional metadata node for each UVC camera or UVC video interface.

IIUC, Laurent's metadata node patch 
https://patchwork.linuxtv.org/patch/36810/ has been acked by Hans and the 
only thing, that's preventing it from being merged it the lack of 
documentation. While waiting for documentation, I'd appreciate some 
discussion of this patch to beat it into shape soon enough and have it 
ready for merge soon after Laurent's patches are pulled in.

Thanks
Guennadi

 drivers/media/usb/uvc/Makefile       |   2 +-
 drivers/media/usb/uvc/uvc_driver.c   |  10 ++
 drivers/media/usb/uvc/uvc_isight.c   |   2 +-
 drivers/media/usb/uvc/uvc_metadata.c | 228 +++++++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_video.c    |  47 ++++++--
 drivers/media/usb/uvc/uvcvideo.h     |  12 +-
 drivers/media/v4l2-core/v4l2-ioctl.c |   1 +
 include/uapi/linux/uvcvideo.h        |  10 ++
 include/uapi/linux/videodev2.h       |   3 +
 9 files changed, 304 insertions(+), 11 deletions(-)
 create mode 100644 drivers/media/usb/uvc/uvc_metadata.c

diff --git a/drivers/media/usb/uvc/Makefile b/drivers/media/usb/uvc/Makefile
index c26d12f..06c7cd3 100644
--- a/drivers/media/usb/uvc/Makefile
+++ b/drivers/media/usb/uvc/Makefile
@@ -1,5 +1,5 @@
 uvcvideo-objs  := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o uvc_ctrl.o \
-		  uvc_status.o uvc_isight.o uvc_debugfs.o
+		  uvc_status.o uvc_isight.o uvc_debugfs.o uvc_metadata.o
 ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
 uvcvideo-objs  += uvc_entity.o
 endif
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 04bf350..edb67ac 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1866,6 +1866,9 @@ static void uvc_unregister_video(struct uvc_device *dev)
 
 		video_unregister_device(&stream->vdev);
 
+		if (video_is_registered(&stream->meta.vdev))
+			video_unregister_device(&stream->meta.vdev);
+
 		uvc_debugfs_cleanup_stream(stream);
 	}
 
@@ -1926,6 +1929,13 @@ static int uvc_register_video(struct uvc_device *dev,
 		return ret;
 	}
 
+	/*
+	 * Register a metadata node. TODO: shall this only be enabled for some
+	 * cameras?
+	 */
+	if (!(dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT))
+		uvc_meta_register(stream);
+
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
 	else
diff --git a/drivers/media/usb/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
index 8510e725..fb940cf 100644
--- a/drivers/media/usb/uvc/uvc_isight.c
+++ b/drivers/media/usb/uvc/uvc_isight.c
@@ -100,7 +100,7 @@ static int isight_decode(struct uvc_video_queue *queue, struct uvc_buffer *buf,
 }
 
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
-		struct uvc_buffer *buf)
+			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
 	int ret, i;
 
diff --git a/drivers/media/usb/uvc/uvc_metadata.c b/drivers/media/usb/uvc/uvc_metadata.c
new file mode 100644
index 0000000..ddf77d9
--- /dev/null
+++ b/drivers/media/usb/uvc/uvc_metadata.c
@@ -0,0 +1,228 @@
+/*
+ *      uvc_metadata.c  --  USB Video Class driver - Metadata handling
+ *
+ *      Copyright (C) 2016
+ *          Guennadi Liakhovetski (guennadi.liakhovetski@intel.com)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-v4l2.h>
+#include <media/videobuf2-vmalloc.h>
+
+#include "uvcvideo.h"
+
+static inline struct uvc_buffer *to_uvc_buffer(struct vb2_v4l2_buffer *vbuf)
+{
+	return container_of(vbuf, struct uvc_buffer, buf);
+}
+
+/* -----------------------------------------------------------------------------
+ * videobuf2 Queue Operations
+ */
+
+static int meta_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
+			    unsigned int *nplanes, unsigned int sizes[],
+			    struct device *alloc_devs[])
+{
+	if (*nplanes) {
+		if (*nplanes != 1)
+			return -EINVAL;
+
+		if (sizes[0] < UVC_PAYLOAD_HEADER_MAX_SIZE)
+			return -EINVAL;
+
+		return 0;
+	}
+
+	*nplanes = 1;
+	sizes[0] = UVC_PAYLOAD_HEADER_MAX_SIZE;
+
+	return 0;
+}
+
+static int meta_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct uvc_buffer *buf = to_uvc_buffer(vbuf);
+
+	if (vb->num_planes != 1)
+		return -EINVAL;
+
+	if (vb2_plane_size(vb, 0) < UVC_PAYLOAD_HEADER_MAX_SIZE)
+		return -EINVAL;
+
+	buf->state = UVC_BUF_STATE_QUEUED;
+	buf->error = 0;
+	buf->mem = vb2_plane_vaddr(vb, 0);
+	buf->length = vb2_plane_size(vb, 0);
+	buf->bytesused = 0;
+
+	return 0;
+}
+
+static void meta_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vb->vb2_queue);
+	struct uvc_buffer *buf = to_uvc_buffer(vbuf);
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+	list_add_tail(&buf->queue, &queue->irqqueue);
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+}
+
+static int meta_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	return 0;
+}
+
+static void meta_stop_streaming(struct vb2_queue *vq)
+{
+	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
+	struct uvc_buffer *buffer;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->irqlock, flags);
+
+	/* Remove all buffers from the IRQ queue. */
+	list_for_each_entry(buffer, &queue->irqqueue, queue)
+		vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_ERROR);
+	INIT_LIST_HEAD(&queue->irqqueue);
+
+	spin_unlock_irqrestore(&queue->irqlock, flags);
+}
+
+static struct vb2_ops uvc_meta_queue_ops = {
+	.queue_setup = meta_queue_setup,
+	.buf_prepare = meta_buffer_prepare,
+	.buf_queue = meta_buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.start_streaming = meta_start_streaming,
+	.stop_streaming = meta_stop_streaming,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int meta_v4l2_querycap(struct file *file, void *fh,
+			      struct v4l2_capability *cap)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
+
+	cap->device_caps = V4L2_CAP_META_CAPTURE
+			 | V4L2_CAP_STREAMING;
+	cap->capabilities = V4L2_CAP_DEVICE_CAPS | cap->device_caps
+			  | stream->chain->caps;
+
+	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
+	strlcpy(cap->card, vfh->vdev->name, sizeof(cap->card));
+	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
+
+	return 0;
+}
+
+static int meta_v4l2_get_format(struct file *file, void *fh,
+				struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct v4l2_meta_format *fmt = &format->fmt.meta;
+
+	if (format->type != vfh->vdev->queue->type)
+		return -EINVAL;
+
+	memset(fmt, 0, sizeof(*fmt));
+
+	fmt->dataformat = V4L2_META_FMT_UVC;
+	fmt->buffersize = UVC_PAYLOAD_HEADER_MAX_SIZE;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops uvc_meta_ioctl_ops = {
+	.vidioc_querycap		= meta_v4l2_querycap,
+	.vidioc_g_fmt_meta_cap		= meta_v4l2_get_format,
+	.vidioc_s_fmt_meta_cap		= meta_v4l2_get_format,
+	.vidioc_try_fmt_meta_cap	= meta_v4l2_get_format,
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 File Operations
+ */
+
+static struct v4l2_file_operations uvc_meta_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = video_ioctl2,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.poll = vb2_fop_poll,
+	.mmap = vb2_fop_mmap,
+};
+
+int uvc_meta_register(struct uvc_streaming *stream)
+{
+	struct uvc_device *dev = stream->dev;
+	struct uvc_meta_dev *meta = &stream->meta;
+	struct video_device *vdev = &meta->vdev;
+	struct uvc_video_queue *quvc = &meta->queue;
+	struct vb2_queue *queue = &quvc->queue;
+	int ret;
+
+	vdev->v4l2_dev = &dev->vdev;
+	vdev->fops = &uvc_meta_fops;
+	vdev->ioctl_ops = &uvc_meta_ioctl_ops;
+	vdev->release = video_device_release_empty;
+	vdev->prio = &stream->chain->prio;
+	vdev->vfl_dir = VFL_DIR_RX;
+	strlcpy(vdev->name, dev->name, sizeof(vdev->name));
+
+	video_set_drvdata(vdev, stream);
+
+	/* Initialize the video buffer queue. */
+	queue->type = V4L2_BUF_TYPE_META_CAPTURE;
+	queue->io_modes = VB2_MMAP | VB2_USERPTR;
+	queue->drv_priv = quvc;
+	queue->buf_struct_size = sizeof(struct uvc_buffer);
+	queue->ops = &uvc_meta_queue_ops;
+	queue->mem_ops = &vb2_vmalloc_memops;
+	queue->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
+		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
+	queue->lock = &quvc->mutex;
+	ret = vb2_queue_init(queue);
+	if (ret < 0)
+		return ret;
+
+	mutex_init(&quvc->mutex);
+	spin_lock_init(&quvc->irqlock);
+	INIT_LIST_HEAD(&quvc->irqqueue);
+
+	vdev->queue = queue;
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret < 0)
+		uvc_printk(KERN_ERR, "Failed to register metadata device (%d).\n", ret);
+
+	return ret;
+}
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index b5589d5..1bda8e1 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1158,8 +1158,30 @@ static void uvc_video_validate_buffer(const struct uvc_streaming *stream,
 /*
  * Completion handler for video URBs.
  */
+static void uvc_video_decode_meta(struct uvc_streaming *stream,
+			struct uvc_buffer *buf, struct uvc_buffer *meta_buf,
+			u8 *mem, int length)
+{
+	size_t nbytes;
+
+	if (!meta_buf || !length)
+		return;
+
+	nbytes = min_t(unsigned int, length, meta_buf->length);
+
+	meta_buf->buf.sequence = buf->buf.sequence;
+	meta_buf->buf.field = buf->buf.field;
+	meta_buf->buf.vb2_buf.timestamp = buf->buf.vb2_buf.timestamp;
+
+	memcpy(meta_buf->mem, mem, nbytes);
+	meta_buf->bytesused = nbytes;
+	meta_buf->state = UVC_BUF_STATE_READY;
+
+	uvc_queue_next_buffer(&stream->meta.queue, meta_buf);
+}
+
 static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
 	u8 *mem;
 	int ret, i;
@@ -1189,6 +1211,8 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 		if (ret < 0)
 			continue;
 
+		uvc_video_decode_meta(stream, buf, meta_buf, mem, ret);
+
 		/* Decode the payload data. */
 		uvc_video_decode_data(stream, buf, mem + ret,
 			urb->iso_frame_desc[i].actual_length - ret);
@@ -1205,7 +1229,7 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 }
 
 static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
 	u8 *mem;
 	int len, ret;
@@ -1239,6 +1263,8 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 			memcpy(stream->bulk.header, mem, ret);
 			stream->bulk.header_size = ret;
 
+			uvc_video_decode_meta(stream, buf, meta_buf, mem, ret);
+
 			mem += ret;
 			len -= ret;
 		}
@@ -1262,8 +1288,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 			uvc_video_decode_end(stream, buf, stream->bulk.header,
 				stream->bulk.payload_size);
 			if (buf->state == UVC_BUF_STATE_READY)
-				buf = uvc_queue_next_buffer(&stream->queue,
-							    buf);
+				uvc_queue_next_buffer(&stream->queue, buf);
 		}
 
 		stream->bulk.header_size = 0;
@@ -1273,7 +1298,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 }
 
 static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+	struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
 	u8 *mem = urb->transfer_buffer;
 	int len = stream->urb_size, ret;
@@ -1319,7 +1344,8 @@ static void uvc_video_complete(struct urb *urb)
 {
 	struct uvc_streaming *stream = urb->context;
 	struct uvc_video_queue *queue = &stream->queue;
-	struct uvc_buffer *buf = NULL;
+	struct uvc_video_queue *qmeta = &stream->meta.queue;
+	struct uvc_buffer *buf = NULL, *buf_meta = NULL;
 	unsigned long flags;
 	int ret;
 
@@ -1338,6 +1364,7 @@ static void uvc_video_complete(struct urb *urb)
 	case -ECONNRESET:	/* usb_unlink_urb() called. */
 	case -ESHUTDOWN:	/* The endpoint is being disabled. */
 		uvc_queue_cancel(queue, urb->status == -ESHUTDOWN);
+		uvc_queue_cancel(qmeta, urb->status == -ESHUTDOWN);
 		return;
 	}
 
@@ -1347,7 +1374,13 @@ static void uvc_video_complete(struct urb *urb)
 				       queue);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	stream->decode(urb, stream, buf);
+	spin_lock_irqsave(&qmeta->irqlock, flags);
+	if (!list_empty(&qmeta->irqqueue))
+		buf_meta = list_first_entry(&qmeta->irqqueue, struct uvc_buffer,
+					    queue);
+	spin_unlock_irqrestore(&qmeta->irqlock, flags);
+
+	stream->decode(urb, stream, buf, buf_meta);
 
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
 		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 3d6cc62..ebff4b6 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -464,6 +464,11 @@ struct uvc_stats_stream {
 	unsigned int max_sof;		/* Maximum STC.SOF value */
 };
 
+struct uvc_meta_dev {
+	struct video_device vdev;
+	struct uvc_video_queue queue;
+};
+
 struct uvc_streaming {
 	struct list_head list;
 	struct uvc_device *dev;
@@ -495,7 +500,9 @@ struct uvc_streaming {
 	unsigned int frozen : 1;
 	struct uvc_video_queue queue;
 	void (*decode) (struct urb *urb, struct uvc_streaming *video,
-			struct uvc_buffer *buf);
+			struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
+
+	struct uvc_meta_dev meta;
 
 	/* Context data used by the bulk completion handler. */
 	struct {
@@ -700,6 +707,7 @@ extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 void uvc_video_clock_update(struct uvc_streaming *stream,
 			    struct vb2_v4l2_buffer *vbuf,
 			    struct uvc_buffer *buf);
+int uvc_meta_register(struct uvc_streaming *stream);
 
 /* Status */
 extern int uvc_status_init(struct uvc_device *dev);
@@ -754,7 +762,7 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
 
 /* Quirks support */
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
-		struct uvc_buffer *buf);
+		struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
 
 /* debugfs and statistics */
 int uvc_debugfs_init(void);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 44a29af..1618be4 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1232,6 +1232,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	case V4L2_TCH_FMT_DELTA_TD08:	descr = "8-bit signed deltas"; break;
 	case V4L2_TCH_FMT_TU16:		descr = "16-bit unsigned touch data"; break;
 	case V4L2_TCH_FMT_TU08:		descr = "8-bit unsigned touch data"; break;
+	case V4L2_META_FMT_UVC:		descr = "UVC payload header metadata"; break;
 
 	default:
 		/* Compressed formats */
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index 3b08186..e98de14 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -67,4 +67,14 @@ struct uvc_xu_control_query {
 #define UVCIOC_CTRL_MAP		_IOWR('u', 0x20, struct uvc_xu_control_mapping)
 #define UVCIOC_CTRL_QUERY	_IOWR('u', 0x21, struct uvc_xu_control_query)
 
+/*
+ * Metadata node
+ */
+
+/*
+ * Actually 255 bytes, but 256 is just a nicer number. We keep the buffer size
+ * constant and just set .usedbytes accordingly
+ */
+#define UVC_PAYLOAD_HEADER_MAX_SIZE 256
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1b894db..6b74191 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -678,6 +678,9 @@ struct v4l2_pix_format {
 #define V4L2_TCH_FMT_TU16	v4l2_fourcc('T', 'U', '1', '6') /* 16-bit unsigned touch data */
 #define V4L2_TCH_FMT_TU08	v4l2_fourcc('T', 'U', '0', '8') /* 8-bit unsigned touch data */
 
+/* Meta-data formats */
+#define V4L2_META_FMT_UVC         v4l2_fourcc('U', 'V', 'C', 'H') /* UVC Payload Header metadata */
+
 /* priv field value to indicates that subsequent fields are valid. */
 #define V4L2_PIX_FMT_PRIV_MAGIC		0xfeedcafe
 
-- 
1.9.3

