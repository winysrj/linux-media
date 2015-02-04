Return-path: <linux-media-owner@vger.kernel.org>
Received: from butterbrot.org ([176.9.106.16]:48713 "EHLO butterbrot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964864AbbBDK5T (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Feb 2015 05:57:19 -0500
From: Florian Echtler <floe@butterbrot.org>
To: hverkuil@xs4all.nl
Cc: laurent.pinchart@ideasonboard.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, Florian Echtler <floe@butterbrot.org>
Subject: [PATCH v2][RFC] add raw video support for Samsung SUR40 touchscreen
Date: Wed,  4 Feb 2015 11:57:04 +0100
Message-Id: <1423047424-11772-1-git-send-email-floe@butterbrot.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here's my updated version of the previous patch to add raw video streaming
support to the SUR40. So far, for reasons opaque to me, dma-contig is the
only allocator that works properly. Hoping for some feedback where the issue
might be hidden; perhaps it's related to the following test failure from
v4l2-compliance:

Streaming ioctls:
	test read/write: OK
	test MMAP: OK
		fail: v4l2-test-buffers.cpp(951): buf.qbuf(node)
		fail: v4l2-test-buffers.cpp(994): setupUserPtr(node, q)
	test USERPTR: FAIL
	test DMABUF: Cannot test, specify --expbuf-device

Total: 45, Succeeded: 44, Failed: 1, Warnings: 0

Signed-off-by: Florian Echtler <floe@butterbrot.org>
---
 drivers/input/touchscreen/Kconfig |   2 +
 drivers/input/touchscreen/sur40.c | 422 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 412 insertions(+), 12 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 5891752..f8d16f1 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -953,7 +953,9 @@ config TOUCHSCREEN_SUN4I
 config TOUCHSCREEN_SUR40
 	tristate "Samsung SUR40 (Surface 2.0/PixelSense) touchscreen"
 	depends on USB
+	depends on MEDIA_USB_SUPPORT
 	select INPUT_POLLDEV
+	select VIDEOBUF2_DMA_SG
 	help
 	  Say Y here if you want support for the Samsung SUR40 touchscreen
 	  (also known as Microsoft Surface 2.0 or Microsoft PixelSense).
diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index f1cb051..5962899 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -1,7 +1,7 @@
 /*
  * Surface2.0/SUR40/PixelSense input driver
  *
- * Copyright (c) 2013 by Florian 'floe' Echtler <floe@butterbrot.org>
+ * Copyright (c) 2014 by Florian 'floe' Echtler <floe@butterbrot.org>
  *
  * Derived from the USB Skeleton driver 1.1,
  * Copyright (c) 2003 Greg Kroah-Hartman (greg@kroah.com)
@@ -12,6 +12,9 @@
  * and from the generic hid-multitouch driver,
  * Copyright (c) 2010-2012 Stephane Chatty <chatty@enac.fr>
  *
+ * and from the v4l2-pci-skeleton driver,
+ * Copyright (c) Copyright 2014 Cisco Systems, Inc.
+ *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
  * published by the Free Software Foundation; either version 2 of
@@ -31,6 +34,11 @@
 #include <linux/input-polldev.h>
 #include <linux/input/mt.h>
 #include <linux/usb/input.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
 
 /* read 512 bytes from endpoint 0x86 -> get header + blobs */
 struct sur40_header {
@@ -82,9 +90,19 @@ struct sur40_data {
 	struct sur40_blob   blobs[];
 } __packed;
 
+/* read 512 bytes from endpoint 0x82 -> get header below
+ * continue reading 16k blocks until header.size bytes read */
+struct sur40_image_header {
+	__le32 magic;     /* "SUBF" */
+	__le32 packet_id;
+	__le32 size;      /* always 0x0007e900 = 960x540 */
+	__le32 timestamp; /* milliseconds (increases by 16 or 17 each frame) */
+	__le32 unknown;   /* "epoch?" always 02/03 00 00 00 */
+} __packed;
 
 /* version information */
 #define DRIVER_SHORT   "sur40"
+#define DRIVER_LONG    "Samsung SUR40"
 #define DRIVER_AUTHOR  "Florian 'floe' Echtler <floe@butterbrot.org>"
 #define DRIVER_DESC    "Surface2.0/SUR40/PixelSense input driver"
 
@@ -99,6 +117,13 @@ struct sur40_data {
 /* touch data endpoint */
 #define TOUCH_ENDPOINT 0x86
 
+/* video data endpoint */
+#define VIDEO_ENDPOINT 0x82
+
+/* video header fields */
+#define VIDEO_HEADER_MAGIC 0x46425553
+#define VIDEO_PACKET_SIZE  16384
+
 /* polling interval (ms) */
 #define POLL_INTERVAL 10
 
@@ -113,21 +138,23 @@ struct sur40_data {
 #define SUR40_GET_STATE   0xc5 /*  4 bytes state (?) */
 #define SUR40_GET_SENSORS 0xb1 /*  8 bytes sensors   */
 
-/*
- * Note: an earlier, non-public version of this driver used USB_RECIP_ENDPOINT
- * here by mistake which is very likely to have corrupted the firmware EEPROM
- * on two separate SUR40 devices. Thanks to Alan Stern who spotted this bug.
- * Should you ever run into a similar problem, the background story to this
- * incident and instructions on how to fix the corrupted EEPROM are available
- * at https://floe.butterbrot.org/matrix/hacking/surface/brick.html
-*/
-
+/* master device state */
 struct sur40_state {
 
 	struct usb_device *usbdev;
 	struct device *dev;
 	struct input_polled_dev *input;
 
+	struct v4l2_device v4l2;
+	struct video_device vdev;
+	struct mutex lock;
+
+	struct vb2_queue queue;
+	struct vb2_alloc_ctx *alloc_ctx;
+	struct list_head buf_list;
+	spinlock_t qlock;
+	int sequence;
+
 	struct sur40_data *bulk_in_buffer;
 	size_t bulk_in_size;
 	u8 bulk_in_epaddr;
@@ -135,6 +162,27 @@ struct sur40_state {
 	char phys[64];
 };
 
+struct sur40_buffer {
+	struct vb2_buffer vb;
+	struct list_head list;
+};
+
+/* forward declarations */
+static const struct video_device sur40_video_device;
+static const struct v4l2_pix_format sur40_video_format;
+static const struct vb2_queue sur40_queue;
+static void sur40_process_video(struct sur40_state *sur40);
+
+/*
+ * Note: an earlier, non-public version of this driver used USB_RECIP_ENDPOINT
+ * here by mistake which is very likely to have corrupted the firmware EEPROM
+ * on two separate SUR40 devices. Thanks to Alan Stern who spotted this bug.
+ * Should you ever run into a similar problem, the background story to this
+ * incident and instructions on how to fix the corrupted EEPROM are available
+ * at https://floe.butterbrot.org/matrix/hacking/surface/brick.html
+*/
+
+/* command wrapper */
 static int sur40_command(struct sur40_state *dev,
 			 u8 command, u16 index, void *buffer, u16 size)
 {
@@ -247,7 +295,6 @@ static void sur40_report_blob(struct sur40_blob *blob, struct input_dev *input)
 /* core function: poll for new input data */
 static void sur40_poll(struct input_polled_dev *polldev)
 {
-
 	struct sur40_state *sur40 = polldev->private;
 	struct input_dev *input = polldev->input;
 	int result, bulk_read, need_blobs, packet_blobs, i;
@@ -314,6 +361,79 @@ static void sur40_poll(struct input_polled_dev *polldev)
 
 	input_mt_sync_frame(input);
 	input_sync(input);
+
+	sur40_process_video(sur40);
+}
+
+/* deal with video data */
+static void sur40_process_video(struct sur40_state *sur40)
+{
+
+	struct sur40_image_header *img = (void *)(sur40->bulk_in_buffer);
+	int result, bulk_read, bufpos;
+	struct sur40_buffer *new_buf;
+	uint8_t *buffer;
+
+	if (list_empty(&sur40->buf_list))
+		return;
+
+	/* get a new buffer from the list */
+	spin_lock(&sur40->qlock);
+	new_buf = list_entry(sur40->buf_list.next, struct sur40_buffer, list);
+	list_del(&new_buf->list);
+	spin_unlock(&sur40->qlock);
+
+	/* retrieve data via bulk read */
+	bufpos = 0;
+
+	result = usb_bulk_msg(sur40->usbdev,
+			usb_rcvbulkpipe(sur40->usbdev, VIDEO_ENDPOINT),
+			sur40->bulk_in_buffer, sur40->bulk_in_size,
+			&bulk_read, 1000);
+
+	if (result < 0) {
+		dev_err(sur40->dev, "error in usb_bulk_read\n");
+		goto err_poll;
+	}
+
+	if (bulk_read != sizeof(struct sur40_image_header)) {
+		dev_err(sur40->dev, "received %d bytes (%ld expected)\n",
+			bulk_read, sizeof(struct sur40_image_header));
+		goto err_poll;
+	}
+
+	if (le32_to_cpu(img->magic) != VIDEO_HEADER_MAGIC) {
+		dev_err(sur40->dev, "image magic mismatch\n");
+		goto err_poll;
+	}
+
+	if (le32_to_cpu(img->size) != sur40_video_format.sizeimage) {
+		dev_err(sur40->dev, "image size mismatch\n");
+		goto err_poll;
+	}
+
+	buffer = vb2_plane_vaddr(&new_buf->vb, 0);
+	while (bufpos < sur40_video_format.sizeimage) {
+		result = usb_bulk_msg(sur40->usbdev,
+			usb_rcvbulkpipe(sur40->usbdev, VIDEO_ENDPOINT),
+			buffer+bufpos, VIDEO_PACKET_SIZE,
+			&bulk_read, 1000);
+		if (result < 0) {
+			dev_err(sur40->dev, "error in usb_bulk_read\n");
+			goto err_poll;
+		}
+		bufpos += bulk_read;
+	}
+
+	/* mark as finished */
+	v4l2_get_timestamp(&new_buf->vb.v4l2_buf.timestamp);
+	new_buf->vb.v4l2_buf.sequence = sur40->sequence++;
+	new_buf->vb.v4l2_buf.field = V4L2_FIELD_NONE;
+	vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_DONE);
+	return;
+
+err_poll:
+	vb2_buffer_done(&new_buf->vb, VB2_BUF_STATE_ERROR);
 }
 
 /* Initialize input device parameters. */
@@ -377,6 +497,11 @@ static int sur40_probe(struct usb_interface *interface,
 		goto err_free_dev;
 	}
 
+	/* initialize locks/lists */
+	INIT_LIST_HEAD(&sur40->buf_list);
+	spin_lock_init(&sur40->qlock);
+	mutex_init(&sur40->lock);
+
 	/* Set up polled input device control structure */
 	poll_dev->private = sur40;
 	poll_dev->poll_interval = POLL_INTERVAL;
@@ -387,7 +512,7 @@ static int sur40_probe(struct usb_interface *interface,
 	/* Set up regular input device structure */
 	sur40_input_setup(poll_dev->input);
 
-	poll_dev->input->name = "Samsung SUR40";
+	poll_dev->input->name = DRIVER_LONG;
 	usb_to_input_id(usbdev, &poll_dev->input->id);
 	usb_make_path(usbdev, sur40->phys, sizeof(sur40->phys));
 	strlcat(sur40->phys, "/input0", sizeof(sur40->phys));
@@ -408,6 +533,7 @@ static int sur40_probe(struct usb_interface *interface,
 		goto err_free_polldev;
 	}
 
+	/* register the polled input device */
 	error = input_register_polled_device(poll_dev);
 	if (error) {
 		dev_err(&interface->dev,
@@ -415,12 +541,54 @@ static int sur40_probe(struct usb_interface *interface,
 		goto err_free_buffer;
 	}
 
+	/* register the video master device */
+	snprintf(sur40->v4l2.name, sizeof(sur40->v4l2.name), "%s", DRIVER_LONG);
+	error = v4l2_device_register(sur40->dev, &sur40->v4l2);
+	if (error) {
+		dev_err(&interface->dev,
+			"Unable to register video master device.");
+		goto err_unreg_v4l2;
+	}
+
+	/* initialize the lock and subdevice */
+	sur40->queue = sur40_queue;
+	sur40->queue.drv_priv = sur40;
+	sur40->queue.lock = &sur40->lock;
+
+	/* initialize the queue */
+	error = vb2_queue_init(&sur40->queue);
+	if (error)
+		goto err_unreg_v4l2;
+
+	sur40->alloc_ctx = vb2_dma_contig_init_ctx(sur40->dev);
+	if (IS_ERR(sur40->alloc_ctx)) {
+		dev_err(sur40->dev, "Can't allocate buffer context");
+		goto err_unreg_v4l2;
+	}
+
+	sur40->vdev = sur40_video_device;
+	sur40->vdev.v4l2_dev = &sur40->v4l2;
+	sur40->vdev.lock = &sur40->lock;
+	sur40->vdev.queue = &sur40->queue;
+	video_set_drvdata(&sur40->vdev, sur40);
+
+	error = video_register_device(&sur40->vdev, VFL_TYPE_GRABBER, -1);
+	if (error) {
+		dev_err(&interface->dev,
+			"Unable to register video subdevice.");
+		goto err_unreg_video;
+	}
+
 	/* we can register the device now, as it is ready */
 	usb_set_intfdata(interface, sur40);
 	dev_dbg(&interface->dev, "%s is now attached\n", DRIVER_DESC);
 
 	return 0;
 
+err_unreg_video:
+	video_unregister_device(&sur40->vdev);
+err_unreg_v4l2:
+	v4l2_device_unregister(&sur40->v4l2);
 err_free_buffer:
 	kfree(sur40->bulk_in_buffer);
 err_free_polldev:
@@ -436,6 +604,10 @@ static void sur40_disconnect(struct usb_interface *interface)
 {
 	struct sur40_state *sur40 = usb_get_intfdata(interface);
 
+	video_unregister_device(&sur40->vdev);
+	v4l2_device_unregister(&sur40->v4l2);
+	vb2_dma_contig_cleanup_ctx(sur40->alloc_ctx);
+
 	input_unregister_polled_device(sur40->input);
 	input_free_polled_device(sur40->input);
 	kfree(sur40->bulk_in_buffer);
@@ -445,12 +617,238 @@ static void sur40_disconnect(struct usb_interface *interface)
 	dev_dbg(&interface->dev, "%s is now disconnected\n", DRIVER_DESC);
 }
 
+/*
+ * Setup the constraints of the queue: besides setting the number of planes
+ * per buffer and the size and allocation context of each plane, it also
+ * checks if sufficient buffers have been allocated. Usually 3 is a good
+ * minimum number: many DMA engines need a minimum of 2 buffers in the
+ * queue and you need to have another available for userspace processing.
+ */
+static int sur40_queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
+		       unsigned int *nbuffers, unsigned int *nplanes,
+		       unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct sur40_state *sur40 = vb2_get_drv_priv(q);
+
+	if (q->num_buffers + *nbuffers < 3)
+		*nbuffers = 3 - q->num_buffers;
+
+	if (fmt && fmt->fmt.pix.sizeimage < sur40_video_format.sizeimage)
+		return -EINVAL;
+
+	*nplanes = 1;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : sur40_video_format.sizeimage;
+	alloc_ctxs[0] = sur40->alloc_ctx;
+
+	return 0;
+}
+
+/*
+ * Prepare the buffer for queueing to the DMA engine: check and set the
+ * payload size.
+ */
+static int sur40_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct sur40_state *sur40 = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size = sur40_video_format.sizeimage;
+
+	if (vb2_plane_size(vb, 0) < size) {
+		dev_err(&sur40->usbdev->dev, "buffer too small (%lu < %lu)\n",
+			 vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
+	return 0;
+}
+
+/*
+ * Queue this buffer to the DMA engine.
+ */
+static void sur40_buffer_queue(struct vb2_buffer *vb)
+{
+	struct sur40_state *sur40 = vb2_get_drv_priv(vb->vb2_queue);
+	struct sur40_buffer *buf = (struct sur40_buffer *)vb;
+
+	spin_lock(&sur40->qlock);
+	list_add_tail(&buf->list, &sur40->buf_list);
+	spin_unlock(&sur40->qlock);
+}
+
+static void return_all_buffers(struct sur40_state *sur40,
+			       enum vb2_buffer_state state)
+{
+	struct sur40_buffer *buf, *node;
+
+	spin_lock(&sur40->qlock);
+	list_for_each_entry_safe(buf, node, &sur40->buf_list, list) {
+		vb2_buffer_done(&buf->vb, state);
+		list_del(&buf->list);
+	}
+	spin_unlock(&sur40->qlock);
+}
+
+/*
+ * Start streaming. First check if the minimum number of buffers have been
+ * queued. If not, then return -ENOBUFS and the vb2 framework will call
+ * this function again the next time a buffer has been queued until enough
+ * buffers are available to actually start the DMA engine.
+ */
+static int sur40_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct sur40_state *sur40 = vb2_get_drv_priv(vq);
+
+	sur40->sequence = 0;
+	return 0;
+}
+
+/*
+ * Stop the DMA engine. Any remaining buffers in the DMA queue are dequeued
+ * and passed on to the vb2 framework marked as STATE_ERROR.
+ */
+static void sur40_stop_streaming(struct vb2_queue *vq)
+{
+	struct sur40_state *sur40 = vb2_get_drv_priv(vq);
+
+	/* Release all active buffers */
+	return_all_buffers(sur40, VB2_BUF_STATE_ERROR);
+}
+
+/* V4L ioctl */
+static int sur40_vidioc_querycap(struct file *file, void *priv,
+				 struct v4l2_capability *cap)
+{
+	struct sur40_state *sur40 = video_drvdata(file);
+
+	strlcpy(cap->driver, DRIVER_SHORT, sizeof(cap->driver));
+	strlcpy(cap->card, DRIVER_LONG, sizeof(cap->card));
+	usb_make_path(sur40->usbdev, cap->bus_info, sizeof(cap->bus_info));
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_READWRITE |
+		V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+	return 0;
+}
+
+static int sur40_vidioc_enum_input(struct file *file, void *priv,
+				   struct v4l2_input *i)
+{
+	if (i->index != 0)
+		return -EINVAL;
+	i->type = V4L2_INPUT_TYPE_CAMERA;
+	i->std = V4L2_STD_UNKNOWN;
+	strlcpy(i->name, "In-Cell Sensor", sizeof(i->name));
+	i->capabilities = 0;
+	return 0;
+}
+
+static int sur40_vidioc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	return (i == 0) ? 0 : -EINVAL;
+}
+
+static int sur40_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int sur40_vidioc_fmt(struct file *file, void *priv,
+			    struct v4l2_format *f)
+{
+	f->fmt.pix = sur40_video_format;
+	return 0;
+}
+
+static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
+				 struct v4l2_fmtdesc *f)
+{
+	if (f->index != 0)
+		return -EINVAL;
+	strlcpy(f->description, "8-bit greyscale", sizeof(f->description));
+	f->pixelformat = V4L2_PIX_FMT_GREY;
+	f->flags = 0;
+	return 0;
+}
+
 static const struct usb_device_id sur40_table[] = {
 	{ USB_DEVICE(ID_MICROSOFT, ID_SUR40) },  /* Samsung SUR40 */
 	{ }                                      /* terminating null entry */
 };
 MODULE_DEVICE_TABLE(usb, sur40_table);
 
+/* V4L2 structures */
+static const struct vb2_ops sur40_queue_ops = {
+	.queue_setup		= sur40_queue_setup,
+	.buf_prepare		= sur40_buffer_prepare,
+	.buf_queue		= sur40_buffer_queue,
+	.start_streaming	= sur40_start_streaming,
+	.stop_streaming		= sur40_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+};
+
+static const struct vb2_queue sur40_queue = {
+	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	.io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF | VB2_USERPTR,
+	.buf_struct_size = sizeof(struct sur40_buffer),
+	.ops = &sur40_queue_ops,
+	.mem_ops = &vb2_dma_contig_memops,
+	.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC,
+	.min_buffers_needed = 3,
+};
+
+static const struct v4l2_file_operations sur40_video_fops = {
+	.owner = THIS_MODULE,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
+	.unlocked_ioctl = video_ioctl2,
+	.read = vb2_fop_read,
+	.mmap = vb2_fop_mmap,
+	.poll = vb2_fop_poll,
+};
+
+static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
+
+	.vidioc_querycap	= sur40_vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap = sur40_vidioc_enum_fmt,
+	.vidioc_try_fmt_vid_cap	= sur40_vidioc_fmt,
+	.vidioc_s_fmt_vid_cap	= sur40_vidioc_fmt,
+	.vidioc_g_fmt_vid_cap	= sur40_vidioc_fmt,
+
+	.vidioc_enum_input	= sur40_vidioc_enum_input,
+	.vidioc_g_input		= sur40_vidioc_g_input,
+	.vidioc_s_input		= sur40_vidioc_s_input,
+
+	.vidioc_reqbufs		= vb2_ioctl_reqbufs,
+	.vidioc_create_bufs	= vb2_ioctl_create_bufs,
+	.vidioc_querybuf	= vb2_ioctl_querybuf,
+	.vidioc_qbuf		= vb2_ioctl_qbuf,
+	.vidioc_dqbuf		= vb2_ioctl_dqbuf,
+	.vidioc_expbuf		= vb2_ioctl_expbuf,
+
+	.vidioc_streamon	= vb2_ioctl_streamon,
+	.vidioc_streamoff	= vb2_ioctl_streamoff,
+};
+
+static const struct video_device sur40_video_device = {
+	.name = DRIVER_LONG,
+	.fops = &sur40_video_fops,
+	.ioctl_ops = &sur40_video_ioctl_ops,
+	.release = video_device_release_empty,
+};
+
+static const struct v4l2_pix_format sur40_video_format = {
+	.pixelformat = V4L2_PIX_FMT_GREY,
+	.width  = SENSOR_RES_X / 2,
+	.height = SENSOR_RES_Y / 2,
+	.field = V4L2_FIELD_NONE,
+	.colorspace = V4L2_COLORSPACE_SRGB,
+	.bytesperline = SENSOR_RES_X / 2,
+	.sizeimage = (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
+};
+
 /* USB-specific object needed to register this driver with the USB subsystem. */
 static struct usb_driver sur40_driver = {
 	.name = DRIVER_SHORT,
-- 
1.9.1

