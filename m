Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51848 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751453AbdLFPPq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Dec 2017 10:15:46 -0500
Date: Wed, 6 Dec 2017 16:15:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH v8] uvcvideo: Add a metadata device node
In-Reply-To: <3317467.6k60bZc7Ey@avalon>
Message-ID: <alpine.DEB.2.20.1712061202230.26640@axis700.grange>
References: <1510156814-28645-1-git-send-email-g.liakhovetski@gmx.de> <29678788.jfO5ktnOBC@avalon> <alpine.DEB.2.20.1712051440590.22421@axis700.grange> <3317467.6k60bZc7Ey@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>

Some UVC video cameras contain metadata in their payload headers. This
patch extracts that data, adding more clock synchronisation information,
on both bulk and isochronous endpoints and makes it available to the user
space on a separate video node, using the V4L2_CAP_META_CAPTURE capability
and the V4L2_BUF_TYPE_META_CAPTURE buffer queue type. By default, only the
V4L2_META_FMT_UVC pixel format is available from those nodes. However,
cameras can be added to the device ID table to additionally specify their
own metadata format, in which case that format will also become available
from the metadata node.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---

v8: addressed comments and integrated changes from Laurent, thanks again, 
e.g.:

- multiple stylistic changes
- remove the UVC_DEV_FLAG_METADATA_NODE flag / quirk: nodes are now 
  created unconditionally
- reuse uvc_ioctl_querycap()
- reuse code in uvc_register_video()
- set an error flag when the metadata buffer overflows

 drivers/media/usb/uvc/Makefile       |   2 +-
 drivers/media/usb/uvc/uvc_driver.c   |  15 ++-
 drivers/media/usb/uvc/uvc_isight.c   |   2 +-
 drivers/media/usb/uvc/uvc_metadata.c | 179 +++++++++++++++++++++++++++++++++++
 drivers/media/usb/uvc/uvc_queue.c    |  44 +++++++--
 drivers/media/usb/uvc/uvc_video.c    | 132 ++++++++++++++++++++++++--
 drivers/media/usb/uvc/uvcvideo.h     |  16 +++-
 include/uapi/linux/uvcvideo.h        |  26 +++++
 8 files changed, 394 insertions(+), 22 deletions(-)
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
index 88032c2..36061f3 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1883,6 +1883,7 @@ static void uvc_unregister_video(struct uvc_device *dev)
 			continue;
 
 		video_unregister_device(&stream->vdev);
+		video_unregister_device(&stream->meta.vdev);
 
 		uvc_debugfs_cleanup_stream(stream);
 	}
@@ -1930,6 +1931,9 @@ int uvc_register_video_device(struct uvc_device *dev,
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
 		vdev->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 		break;
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		vdev->device_caps = V4L2_CAP_META_CAPTURE | V4L2_CAP_STREAMING;
+		break;
 	}
 
 	strlcpy(vdev->name, dev->name, sizeof vdev->name);
@@ -1965,7 +1969,8 @@ static int uvc_register_video(struct uvc_device *dev,
 	}
 
 	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE;
+		stream->chain->caps |= V4L2_CAP_VIDEO_CAPTURE
+			| V4L2_CAP_META_CAPTURE;
 	else
 		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
 
@@ -2003,6 +2008,11 @@ static int uvc_register_terms(struct uvc_device *dev,
 		if (ret < 0)
 			return ret;
 
+		/* Register a metadata node, but ignore a possible failure,
+		 * complete registration of video nodes anyway.
+		 */
+		uvc_meta_register(stream);
+
 		term->vdev = &stream->vdev;
 	}
 
@@ -2037,6 +2047,7 @@ static int uvc_register_chains(struct uvc_device *dev)
 
 struct uvc_device_info {
 	u32	quirks;
+	u32	meta_format;
 };
 
 static int uvc_probe(struct usb_interface *intf,
@@ -2074,6 +2085,8 @@ static int uvc_probe(struct usb_interface *intf,
 	dev->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
 	dev->quirks = (uvc_quirks_param == -1)
 		    ? quirks : uvc_quirks_param;
+	if (info)
+		dev->meta_format = info->meta_format;
 
 	if (udev->product != NULL)
 		strlcpy(dev->name, udev->product, sizeof dev->name);
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
index 0000000..cd1aec1
--- /dev/null
+++ b/drivers/media/usb/uvc/uvc_metadata.c
@@ -0,0 +1,179 @@
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
+/* -----------------------------------------------------------------------------
+ * V4L2 ioctls
+ */
+
+static int uvc_meta_v4l2_querycap(struct file *file, void *fh,
+				  struct v4l2_capability *cap)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
+	struct uvc_video_chain *chain = stream->chain;
+
+	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
+	strlcpy(cap->card, vfh->vdev->name, sizeof(cap->card));
+	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
+	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
+			  | chain->caps;
+
+	return 0;
+}
+
+static int uvc_meta_v4l2_get_format(struct file *file, void *fh,
+				    struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
+	struct v4l2_meta_format *fmt = &format->fmt.meta;
+
+	if (format->type != vfh->vdev->queue->type)
+		return -EINVAL;
+
+	memset(fmt, 0, sizeof(*fmt));
+
+	fmt->dataformat = stream->meta.format;
+	fmt->buffersize = UVC_METATADA_BUF_SIZE;
+
+	return 0;
+}
+
+static int uvc_meta_v4l2_try_format(struct file *file, void *fh,
+				    struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
+	struct uvc_device *dev = stream->dev;
+	struct v4l2_meta_format *fmt = &format->fmt.meta;
+	u32 fmeta = fmt->dataformat;
+
+	if (format->type != vfh->vdev->queue->type)
+		return -EINVAL;
+
+	memset(fmt, 0, sizeof(*fmt));
+
+	fmt->dataformat = fmeta == dev->meta_format ? fmeta : V4L2_META_FMT_UVC;
+	fmt->buffersize = UVC_METATADA_BUF_SIZE;
+
+	return 0;
+}
+
+static int uvc_meta_v4l2_set_format(struct file *file, void *fh,
+				    struct v4l2_format *format)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
+	struct v4l2_meta_format *fmt = &format->fmt.meta;
+	int ret;
+
+	ret = uvc_meta_v4l2_try_format(file, fh, format);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * We could in principle switch at any time, also during streaming.
+	 * Metadata buffers would still be perfectly parseable, but it's more
+	 * consistent and cleaner to disallow that.
+	 */
+	mutex_lock(&stream->mutex);
+
+	if (uvc_queue_allocated(&stream->queue))
+		ret = -EBUSY;
+	else
+		stream->meta.format = fmt->dataformat;
+
+	mutex_unlock(&stream->mutex);
+
+	return ret;
+}
+
+static int uvc_meta_v4l2_enum_formats(struct file *file, void *fh,
+				      struct v4l2_fmtdesc *fdesc)
+{
+	struct v4l2_fh *vfh = file->private_data;
+	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
+	struct uvc_device *dev = stream->dev;
+	u32 index = fdesc->index;
+
+	if (fdesc->type != vfh->vdev->queue->type ||
+	    index > 1U || (index && !dev->meta_format))
+		return -EINVAL;
+
+	memset(fdesc, 0, sizeof(*fdesc));
+
+	fdesc->type = vfh->vdev->queue->type;
+	fdesc->index = index;
+	fdesc->pixelformat = index ? dev->meta_format : V4L2_META_FMT_UVC;
+
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops uvc_meta_ioctl_ops = {
+	.vidioc_querycap		= uvc_meta_v4l2_querycap,
+	.vidioc_g_fmt_meta_cap		= uvc_meta_v4l2_get_format,
+	.vidioc_s_fmt_meta_cap		= uvc_meta_v4l2_set_format,
+	.vidioc_try_fmt_meta_cap	= uvc_meta_v4l2_try_format,
+	.vidioc_enum_fmt_meta_cap	= uvc_meta_v4l2_enum_formats,
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
+static const struct v4l2_file_operations uvc_meta_fops = {
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
+	struct video_device *vdev = &stream->meta.vdev;
+	struct uvc_video_queue *queue = &stream->meta.queue;
+
+	stream->meta.format = V4L2_META_FMT_UVC;
+
+	/*
+	 * The video interface queue uses manual locking and thus does not set
+	 * the queue pointer. Set it manually here.
+	 */
+	vdev->queue = &queue->queue;
+
+	return uvc_register_video_device(dev, stream, vdev, queue,
+					 V4L2_BUF_TYPE_META_CAPTURE,
+					 &uvc_meta_fops, &uvc_meta_ioctl_ops);
+}
diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index c8d78b2..cd2ea5a 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -79,8 +79,19 @@ static int uvc_queue_setup(struct vb2_queue *vq,
 			   unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
-	unsigned size = stream->ctrl.dwMaxVideoFrameSize;
+	struct uvc_streaming *stream;
+	unsigned int size;
+
+	switch (vq->type) {
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		size = UVC_METATADA_BUF_SIZE;
+		break;
+
+	default:
+		stream = uvc_queue_to_stream(queue);
+		size = stream->ctrl.dwMaxVideoFrameSize;
+		break;
+	}
 
 	/*
 	 * When called with plane sizes, validate them. The driver supports
@@ -114,7 +125,7 @@ static int uvc_buffer_prepare(struct vb2_buffer *vb)
 	buf->error = 0;
 	buf->mem = vb2_plane_vaddr(vb, 0);
 	buf->length = vb2_plane_size(vb, 0);
-	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (vb->type != V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		buf->bytesused = 0;
 	else
 		buf->bytesused = vb2_get_plane_payload(vb, 0);
@@ -177,10 +188,10 @@ static int uvc_start_streaming(struct vb2_queue *vq, unsigned int count)
 static void uvc_stop_streaming(struct vb2_queue *vq)
 {
 	struct uvc_video_queue *queue = vb2_get_drv_priv(vq);
-	struct uvc_streaming *stream = uvc_queue_to_stream(queue);
 	unsigned long flags;
 
-	uvc_video_enable(stream, 0);
+	if (vq->type != V4L2_BUF_TYPE_META_CAPTURE)
+		uvc_video_enable(uvc_queue_to_stream(queue), 0);
 
 	spin_lock_irqsave(&queue->irqlock, flags);
 	uvc_queue_return_buffers(queue, UVC_BUF_STATE_ERROR);
@@ -198,20 +209,39 @@ static void uvc_stop_streaming(struct vb2_queue *vq)
 	.stop_streaming = uvc_stop_streaming,
 };
 
+static const struct vb2_ops uvc_meta_queue_qops = {
+	.queue_setup = uvc_queue_setup,
+	.buf_prepare = uvc_buffer_prepare,
+	.buf_queue = uvc_buffer_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
+	.stop_streaming = uvc_stop_streaming,
+};
+
 int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 		    int drop_corrupted)
 {
 	int ret;
 
 	queue->queue.type = type;
-	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
 	queue->queue.drv_priv = queue;
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
-	queue->queue.ops = &uvc_queue_qops;
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
 	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
 		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
 	queue->queue.lock = &queue->mutex;
+
+	switch (type) {
+	case V4L2_BUF_TYPE_META_CAPTURE:
+		queue->queue.ops = &uvc_meta_queue_qops;
+		break;
+	default:
+		queue->queue.io_modes |= VB2_DMABUF;
+		queue->queue.ops = &uvc_queue_qops;
+		break;
+	}
+
 	ret = vb2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 13f459e..2fc0bf2 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1120,6 +1120,82 @@ static int uvc_video_encode_data(struct uvc_streaming *stream,
 }
 
 /* ------------------------------------------------------------------------
+ * Metadata
+ */
+
+/*
+ * Additionally to the payload headers we also want to provide the user with USB
+ * Frame Numbers and system time values. The resulting buffer is thus composed
+ * of blocks, containing a 64-bit timestamp in  nanoseconds, a 16-bit USB Frame
+ * Number, and a copy of the payload header.
+ *
+ * Ideally we want to capture all payload headers for each frame. However, their
+ * number is unknown and unbound. We thus drop headers that contain no vendor
+ * data and that either contain no SCR value or an SCR value identical to the
+ * previous header.
+ */
+static void uvc_video_decode_meta(struct uvc_streaming *stream,
+				  struct uvc_buffer *meta_buf,
+				  const u8 *mem, unsigned int length)
+{
+	struct uvc_meta_buf *meta;
+	size_t len_std = 2;
+	bool has_pts, has_scr;
+	unsigned long flags;
+	ktime_t time;
+	const u8 *scr;
+
+	if (!meta_buf || length == 2)
+		return;
+
+	if (meta_buf->length - meta_buf->bytesused <
+	    length + sizeof(meta->ns) + sizeof(meta->sof)) {
+		meta_buf->error = 1;
+		return;
+	}
+
+	has_pts = mem[1] & UVC_STREAM_PTS;
+	has_scr = mem[1] & UVC_STREAM_SCR;
+
+	if (has_pts) {
+		len_std += 4;
+		scr = mem + 6;
+	} else {
+		scr = mem + 2;
+	}
+
+	if (has_scr)
+		len_std += 6;
+
+	if (stream->meta.format == V4L2_META_FMT_UVC)
+		length = len_std;
+
+	if (length == len_std && (!has_scr ||
+				  !memcmp(scr, stream->clock.last_scr, 6)))
+		return;
+
+	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf->bytesused);
+	local_irq_save(flags);
+	time = uvc_video_get_time();
+	meta->sof = usb_get_current_frame_number(stream->dev->udev);
+	local_irq_restore(flags);
+	__put_unaligned_cpu64(ktime_to_ns(time), &meta->ns);
+
+	if (has_scr)
+		memcpy(stream->clock.last_scr, scr, 6);
+
+	memcpy(&meta->length, mem, length);
+	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
+
+	uvc_trace(UVC_TRACE_FRAME,
+		  "%s(): t-sys %lluns, SOF %u, len %u, flags 0x%x, PTS %u, STC %u frame SOF %u\n",
+		  __func__, time, meta->sof, meta->length, meta->flags,
+		  has_pts ? *(u32 *)meta->buf : 0,
+		  has_scr ? *(u32 *)scr : 0,
+		  has_scr ? *(u32 *)(scr + 4) & 0x7ff : 0);
+}
+
+/* ------------------------------------------------------------------------
  * URB handling
  */
 
@@ -1137,8 +1213,29 @@ static void uvc_video_validate_buffer(const struct uvc_streaming *stream,
 /*
  * Completion handler for video URBs.
  */
+
+static void uvc_video_next_buffers(struct uvc_streaming *stream,
+		struct uvc_buffer **video_buf, struct uvc_buffer **meta_buf)
+{
+	if (*meta_buf) {
+		struct vb2_v4l2_buffer *vb2_meta = &(*meta_buf)->buf;
+		const struct vb2_v4l2_buffer *vb2_video = &(*video_buf)->buf;
+
+		vb2_meta->sequence = vb2_video->sequence;
+		vb2_meta->field = vb2_video->field;
+		vb2_meta->vb2_buf.timestamp = vb2_video->vb2_buf.timestamp;
+
+		(*meta_buf)->state = UVC_BUF_STATE_READY;
+		if (!(*meta_buf)->error)
+			(*meta_buf)->error = (*video_buf)->error;
+		*meta_buf = uvc_queue_next_buffer(&stream->meta.queue,
+						  *meta_buf);
+	}
+	*video_buf = uvc_queue_next_buffer(&stream->queue, *video_buf);
+}
+
 static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
 	u8 *mem;
 	int ret, i;
@@ -1160,14 +1257,15 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 				urb->iso_frame_desc[i].actual_length);
 			if (ret == -EAGAIN) {
 				uvc_video_validate_buffer(stream, buf);
-				buf = uvc_queue_next_buffer(&stream->queue,
-							    buf);
+				uvc_video_next_buffers(stream, &buf, &meta_buf);
 			}
 		} while (ret == -EAGAIN);
 
 		if (ret < 0)
 			continue;
 
+		uvc_video_decode_meta(stream, meta_buf, mem, ret);
+
 		/* Decode the payload data. */
 		uvc_video_decode_data(stream, buf, mem + ret,
 			urb->iso_frame_desc[i].actual_length - ret);
@@ -1178,13 +1276,13 @@ static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
 
 		if (buf->state == UVC_BUF_STATE_READY) {
 			uvc_video_validate_buffer(stream, buf);
-			buf = uvc_queue_next_buffer(&stream->queue, buf);
+			uvc_video_next_buffers(stream, &buf, &meta_buf);
 		}
 	}
 }
 
 static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+			struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
 	u8 *mem;
 	int len, ret;
@@ -1207,8 +1305,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 		do {
 			ret = uvc_video_decode_start(stream, buf, mem, len);
 			if (ret == -EAGAIN)
-				buf = uvc_queue_next_buffer(&stream->queue,
-							    buf);
+				uvc_video_next_buffers(stream, &buf, &meta_buf);
 		} while (ret == -EAGAIN);
 
 		/* If an error occurred skip the rest of the payload. */
@@ -1218,6 +1315,8 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 			memcpy(stream->bulk.header, mem, ret);
 			stream->bulk.header_size = ret;
 
+			uvc_video_decode_meta(stream, meta_buf, mem, ret);
+
 			mem += ret;
 			len -= ret;
 		}
@@ -1241,7 +1340,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 			uvc_video_decode_end(stream, buf, stream->bulk.header,
 				stream->bulk.payload_size);
 			if (buf->state == UVC_BUF_STATE_READY)
-				uvc_queue_next_buffer(&stream->queue, buf);
+				uvc_video_next_buffers(stream, &buf, &meta_buf);
 		}
 
 		stream->bulk.header_size = 0;
@@ -1251,7 +1350,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 }
 
 static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
-	struct uvc_buffer *buf)
+	struct uvc_buffer *buf, struct uvc_buffer *meta_buf)
 {
 	u8 *mem = urb->transfer_buffer;
 	int len = stream->urb_size, ret;
@@ -1297,7 +1396,10 @@ static void uvc_video_complete(struct urb *urb)
 {
 	struct uvc_streaming *stream = urb->context;
 	struct uvc_video_queue *queue = &stream->queue;
+	struct uvc_video_queue *qmeta = &stream->meta.queue;
+	struct vb2_queue *vb2_qmeta = stream->meta.vdev.queue;
 	struct uvc_buffer *buf = NULL;
+	struct uvc_buffer *buf_meta = NULL;
 	unsigned long flags;
 	int ret;
 
@@ -1316,6 +1418,8 @@ static void uvc_video_complete(struct urb *urb)
 	case -ECONNRESET:	/* usb_unlink_urb() called. */
 	case -ESHUTDOWN:	/* The endpoint is being disabled. */
 		uvc_queue_cancel(queue, urb->status == -ESHUTDOWN);
+		if (vb2_qmeta)
+			uvc_queue_cancel(qmeta, urb->status == -ESHUTDOWN);
 		return;
 	}
 
@@ -1325,7 +1429,15 @@ static void uvc_video_complete(struct urb *urb)
 				       queue);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	stream->decode(urb, stream, buf);
+	if (vb2_qmeta) {
+		spin_lock_irqsave(&qmeta->irqlock, flags);
+		if (!list_empty(&qmeta->irqqueue))
+			buf_meta = list_first_entry(&qmeta->irqqueue,
+						    struct uvc_buffer, queue);
+		spin_unlock_irqrestore(&qmeta->irqlock, flags);
+	}
+
+	stream->decode(urb, stream, buf, buf_meta);
 
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
 		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index e0266bf..b65e86b 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -478,6 +478,8 @@ struct uvc_stats_stream {
 	unsigned int max_sof;		/* Maximum STC.SOF value */
 };
 
+#define UVC_METATADA_BUF_SIZE 1024
+
 struct uvc_streaming {
 	struct list_head list;
 	struct uvc_device *dev;
@@ -509,7 +511,13 @@ struct uvc_streaming {
 	unsigned int frozen : 1;
 	struct uvc_video_queue queue;
 	void (*decode) (struct urb *urb, struct uvc_streaming *video,
-			struct uvc_buffer *buf);
+			struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
+
+	struct {
+		struct video_device vdev;
+		struct uvc_video_queue queue;
+		__u32 format;
+	} meta;
 
 	/* Context data used by the bulk completion handler. */
 	struct {
@@ -551,6 +559,8 @@ struct uvc_streaming {
 		u16 last_sof;
 		u16 sof_offset;
 
+		u8 last_scr[6];
+
 		spinlock_t lock;
 	} clock;
 };
@@ -560,6 +570,7 @@ struct uvc_device {
 	struct usb_interface *intf;
 	unsigned long warnings;
 	__u32 quirks;
+	__u32 meta_format;
 	int intfnum;
 	char name[32];
 
@@ -714,6 +725,7 @@ extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 void uvc_video_clock_update(struct uvc_streaming *stream,
 			    struct vb2_v4l2_buffer *vbuf,
 			    struct uvc_buffer *buf);
+int uvc_meta_register(struct uvc_streaming *stream);
 
 int uvc_register_video_device(struct uvc_device *dev,
 			      struct uvc_streaming *stream,
@@ -776,7 +788,7 @@ extern struct usb_host_endpoint *uvc_find_endpoint(
 
 /* Quirks support */
 void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
-		struct uvc_buffer *buf);
+		struct uvc_buffer *buf, struct uvc_buffer *meta_buf);
 
 /* debugfs and statistics */
 void uvc_debugfs_init(void);
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index 3b08186..8381ca7c 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -67,4 +67,30 @@ struct uvc_xu_control_query {
 #define UVCIOC_CTRL_MAP		_IOWR('u', 0x20, struct uvc_xu_control_mapping)
 #define UVCIOC_CTRL_QUERY	_IOWR('u', 0x21, struct uvc_xu_control_query)
 
+/*
+ * Metadata node
+ */
+
+/**
+ * struct uvc_meta_buf - metadata buffer building block
+ * @ns		- system timestamp of the payload in nanoseconds
+ * @sof		- USB Frame Number
+ * @length	- length of the payload header
+ * @flags	- payload header flags
+ * @buf		- optional device-specific header data
+ *
+ * UVC metadata nodes fill buffers with possibly multiple instances of this
+ * struct. The first two fields are added by the driver, they can be used for
+ * clock synchronisation. The rest is an exact copy of a UVC payload header.
+ * Only complete objects with complete buffers are included. Therefore it's
+ * always sizeof(meta->ts) + sizeof(meta->sof) + meta->length bytes large.
+ */
+struct uvc_meta_buf {
+	__u64 ns;
+	__u16 sof;
+	__u8 length;
+	__u8 flags;
+	__u8 buf[];
+} __packed;
+
 #endif
-- 
1.9.3
