Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:50823 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZGVSAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 14:00:04 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/2] uvcvideo: Restructure the driver to support multiple simultaneous streams.
Date: Wed, 22 Jul 2009 19:59:14 +0200
Cc: linux-uvc-devel@lists.berlios.de,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200907221958.12027.laurent.pinchart@skynet.be>
In-Reply-To: <200907221958.12027.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221959.14669.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As a first step towards multiple streaming interfaces support, reorganize the
driver's data structures to cleanly separate video control and video streaming
data.

Priority: normal

Signed-off-by: Laurent Pinchart <laurent.pinchart@skynet.be>

diff -r da81aafb9c5d linux/drivers/media/video/uvc/uvc_driver.c
--- a/linux/drivers/media/video/uvc/uvc_driver.c	Mon Jul 20 00:16:05 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_driver.c	Tue Jul 21 23:54:32 2009 +0200
@@ -551,6 +551,7 @@
 	}
 
 	mutex_init(&streaming->mutex);
+	streaming->dev = dev;
 	streaming->intf = usb_get_intf(intf);
 	streaming->intfnum = intf->cur_altsetting->desc.bInterfaceNumber;
 
@@ -751,7 +752,7 @@
 			streaming->maxpsize = psize;
 	}
 
-	list_add_tail(&streaming->list, &dev->streaming);
+	list_add_tail(&streaming->list, &dev->streams);
 	return 0;
 
 error:
@@ -1167,15 +1168,77 @@
  */
 static void uvc_unregister_video(struct uvc_device *dev)
 {
-	if (dev->video.vdev) {
-		if (dev->video.vdev->minor == -1)
-			video_device_release(dev->video.vdev);
+	struct uvc_streaming *streaming;
+
+	list_for_each_entry(streaming, &dev->streams, list) {
+		if (streaming->vdev == NULL)
+			continue;
+
+		if (streaming->vdev->minor == -1)
+			video_device_release(streaming->vdev);
 		else
-			video_unregister_device(dev->video.vdev);
-		dev->video.vdev = NULL;
+			video_unregister_device(streaming->vdev);
+		streaming->vdev = NULL;
 	}
 }
 
+static int uvc_register_video(struct uvc_device *dev,
+		struct uvc_streaming *stream)
+{
+	struct video_device *vdev;
+	struct uvc_entity *term;
+	int ret;
+
+	if (uvc_trace_param & UVC_TRACE_PROBE) {
+		uvc_printk(KERN_INFO, "Found a valid video chain (");
+		list_for_each_entry(term, &dev->video.iterms, chain) {
+			printk("%d", term->id);
+			if (term->chain.next != &dev->video.iterms)
+				printk(",");
+		}
+		printk(" -> %d).\n", dev->video.oterm->id);
+	}
+
+	/* Initialize the streaming interface with default streaming
+	 * parameters.
+	 */
+	ret = uvc_video_init(stream);
+	if (ret < 0) {
+		uvc_printk(KERN_ERR, "Failed to initialize the device "
+			"(%d).\n", ret);
+		return ret;
+	}
+
+	/* Register the device with V4L. */
+	vdev = video_device_alloc();
+	if (vdev == NULL)
+		return -1;
+
+	/* We already hold a reference to dev->udev. The video device will be
+	 * unregistered before the reference is released, so we don't need to
+	 * get another one.
+	 */
+	vdev->parent = &dev->intf->dev;
+	vdev->minor = -1;
+	vdev->fops = &uvc_fops;
+	vdev->release = video_device_release;
+	strlcpy(vdev->name, dev->name, sizeof vdev->name);
+
+	/* Set the driver data before calling video_register_device, otherwise
+	 * uvc_v4l2_open might race us.
+	 */
+	stream->vdev = vdev;
+	video_set_drvdata(vdev, stream);
+
+	if (video_register_device(vdev, VFL_TYPE_GRABBER, -1) < 0) {
+		stream->vdev = NULL;
+		video_device_release(vdev);
+		return -1;
+	}
+
+	return 0;
+}
+
 /*
  * Scan the UVC descriptors to locate a chain starting at an Output Terminal
  * and containing the following units:
@@ -1419,7 +1482,7 @@
 }
 
 /*
- * Register the video devices.
+ * Scan the device for video chains and register video devices.
  *
  * The driver currently supports a single video device per control interface
  * only. The terminal and units must match the following structure:
@@ -1432,15 +1495,14 @@
  * Extension Units connected to the main chain as single-unit branches are
  * also supported.
  */
-static int uvc_register_video(struct uvc_device *dev)
+static int uvc_scan_device(struct uvc_device *dev)
 {
-	struct video_device *vdev;
 	struct uvc_entity *term;
-	int found = 0, ret;
+	int found = 0;
 
 	/* Check if the control interface matches the structure we expect. */
 	list_for_each_entry(term, &dev->entities, list) {
-		struct uvc_streaming *streaming;
+		struct uvc_streaming *stream;
 
 		if (!UVC_ENTITY_IS_TERM(term) || !UVC_ENTITY_IS_OTERM(term))
 			continue;
@@ -1454,17 +1516,14 @@
 		if (uvc_scan_chain(&dev->video) < 0)
 			continue;
 
-		list_for_each_entry(streaming, &dev->streaming, list) {
-			if (streaming->header.bTerminalLink ==
+		list_for_each_entry(stream, &dev->streams, list) {
+			if (stream->header.bTerminalLink ==
 			    dev->video.sterm->id) {
-				dev->video.streaming = streaming;
+				uvc_register_video(dev, stream);
 				found = 1;
 				break;
 			}
 		}
-
-		if (found)
-			break;
 	}
 
 	if (!found) {
@@ -1472,55 +1531,6 @@
 		return -1;
 	}
 
-	if (uvc_trace_param & UVC_TRACE_PROBE) {
-		uvc_printk(KERN_INFO, "Found a valid video chain (");
-		list_for_each_entry(term, &dev->video.iterms, chain) {
-			printk("%d", term->id);
-			if (term->chain.next != &dev->video.iterms)
-				printk(",");
-		}
-		printk(" -> %d).\n", dev->video.oterm->id);
-	}
-
-	/* Initialize the video buffers queue. */
-	uvc_queue_init(&dev->video.queue, dev->video.streaming->type);
-
-	/* Initialize the streaming interface with default streaming
-	 * parameters.
-	 */
-	if ((ret = uvc_video_init(&dev->video)) < 0) {
-		uvc_printk(KERN_ERR, "Failed to initialize the device "
-			"(%d).\n", ret);
-		return ret;
-	}
-
-	/* Register the device with V4L. */
-	vdev = video_device_alloc();
-	if (vdev == NULL)
-		return -1;
-
-	/* We already hold a reference to dev->udev. The video device will be
-	 * unregistered before the reference is released, so we don't need to
-	 * get another one.
-	 */
-	vdev->parent = &dev->intf->dev;
-	vdev->minor = -1;
-	vdev->fops = &uvc_fops;
-	vdev->release = video_device_release;
-	strlcpy(vdev->name, dev->name, sizeof vdev->name);
-
-	/* Set the driver data before calling video_register_device, otherwise
-	 * uvc_v4l2_open might race us.
-	 */
-	dev->video.vdev = vdev;
-	video_set_drvdata(vdev, &dev->video);
-
-	if (video_register_device(vdev, VFL_TYPE_GRABBER, -1) < 0) {
-		dev->video.vdev = NULL;
-		video_device_release(vdev);
-		return -1;
-	}
-
 	return 0;
 }
 
@@ -1559,7 +1569,7 @@
 		kfree(entity);
 	}
 
-	list_for_each_safe(p, n, &dev->streaming) {
+	list_for_each_safe(p, n, &dev->streams) {
 		struct uvc_streaming *streaming;
 		streaming = list_entry(p, struct uvc_streaming, list);
 		usb_driver_release_interface(&uvc_driver.driver,
@@ -1593,7 +1603,7 @@
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&dev->entities);
-	INIT_LIST_HEAD(&dev->streaming);
+	INIT_LIST_HEAD(&dev->streams);
 	kref_init(&dev->kref);
 	atomic_set(&dev->users, 0);
 
@@ -1634,8 +1644,8 @@
 	if (uvc_ctrl_init_device(dev) < 0)
 		goto error;
 
-	/* Register the video devices. */
-	if (uvc_register_video(dev) < 0)
+	/* Scan the device for video chains and register video devices. */
+	if (uvc_scan_device(dev) < 0)
 		goto error;
 
 	/* Save our data pointer in the interface data. */
@@ -1689,6 +1699,7 @@
 static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct uvc_device *dev = usb_get_intfdata(intf);
+	struct uvc_streaming *stream;
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Suspending interface %u\n",
 		intf->cur_altsetting->desc.bInterfaceNumber);
@@ -1698,18 +1709,20 @@
 	    UVC_SC_VIDEOCONTROL)
 		return uvc_status_suspend(dev);
 
-	if (dev->video.streaming->intf != intf) {
-		uvc_trace(UVC_TRACE_SUSPEND, "Suspend: video streaming USB "
-				"interface mismatch.\n");
-		return -EINVAL;
+	list_for_each_entry(stream, &dev->streams, list) {
+		if (stream->intf == intf)
+			return uvc_video_suspend(stream);
 	}
 
-	return uvc_video_suspend(&dev->video);
+	uvc_trace(UVC_TRACE_SUSPEND, "Suspend: video streaming USB interface "
+			"mismatch.\n");
+	return -EINVAL;
 }
 
 static int __uvc_resume(struct usb_interface *intf, int reset)
 {
 	struct uvc_device *dev = usb_get_intfdata(intf);
+	struct uvc_streaming *stream;
 
 	uvc_trace(UVC_TRACE_SUSPEND, "Resuming interface %u\n",
 		intf->cur_altsetting->desc.bInterfaceNumber);
@@ -1726,13 +1739,14 @@
 		return uvc_status_resume(dev);
 	}
 
-	if (dev->video.streaming->intf != intf) {
-		uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB "
-				"interface mismatch.\n");
-		return -EINVAL;
+	list_for_each_entry(stream, &dev->streams, list) {
+		if (stream->intf == intf)
+			return uvc_video_resume(stream);
 	}
 
-	return uvc_video_resume(&dev->video);
+	uvc_trace(UVC_TRACE_SUSPEND, "Resume: video streaming USB interface "
+			"mismatch.\n");
+	return -EINVAL;
 }
 
 static int uvc_resume(struct usb_interface *intf)
diff -r da81aafb9c5d linux/drivers/media/video/uvc/uvc_isight.c
--- a/linux/drivers/media/video/uvc/uvc_isight.c	Mon Jul 20 00:16:05 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_isight.c	Tue Jul 21 23:54:32 2009 +0200
@@ -99,7 +99,7 @@
 	return 0;
 }
 
-void uvc_video_decode_isight(struct urb *urb, struct uvc_video_device *video,
+void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
 		struct uvc_buffer *buf)
 {
 	int ret, i;
@@ -120,7 +120,7 @@
 		 * processes the data of the first payload of the new frame.
 		 */
 		do {
-			ret = isight_decode(&video->queue, buf,
+			ret = isight_decode(&stream->queue, buf,
 					urb->transfer_buffer +
 					urb->iso_frame_desc[i].offset,
 					urb->iso_frame_desc[i].actual_length);
@@ -130,7 +130,8 @@
 
 			if (buf->state == UVC_BUF_STATE_DONE ||
 			    buf->state == UVC_BUF_STATE_ERROR)
-				buf = uvc_queue_next_buffer(&video->queue, buf);
+				buf = uvc_queue_next_buffer(&stream->queue,
+							buf);
 		} while (ret == -EAGAIN);
 	}
 }
diff -r da81aafb9c5d linux/drivers/media/video/uvc/uvc_v4l2.c
--- a/linux/drivers/media/video/uvc/uvc_v4l2.c	Mon Jul 20 00:16:05 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_v4l2.c	Tue Jul 21 23:54:32 2009 +0200
@@ -103,7 +103,7 @@
 	return interval;
 }
 
-static int uvc_v4l2_try_format(struct uvc_video_device *video,
+static int uvc_v4l2_try_format(struct uvc_streaming *stream,
 	struct v4l2_format *fmt, struct uvc_streaming_control *probe,
 	struct uvc_format **uvc_format, struct uvc_frame **uvc_frame)
 {
@@ -116,7 +116,7 @@
 	int ret = 0;
 	__u8 *fcc;
 
-	if (fmt->type != video->streaming->type)
+	if (fmt->type != stream->type)
 		return -EINVAL;
 
 	fcc = (__u8 *)&fmt->fmt.pix.pixelformat;
@@ -126,8 +126,8 @@
 			fmt->fmt.pix.width, fmt->fmt.pix.height);
 
 	/* Check if the hardware supports the requested format. */
-	for (i = 0; i < video->streaming->nformats; ++i) {
-		format = &video->streaming->format[i];
+	for (i = 0; i < stream->nformats; ++i) {
+		format = &stream->format[i];
 		if (format->fcc == fmt->fmt.pix.pixelformat)
 			break;
 	}
@@ -191,12 +191,13 @@
 	 * developers test their webcams with the Linux driver as well as with
 	 * the Windows driver).
 	 */
-	if (video->dev->quirks & UVC_QUIRK_PROBE_EXTRAFIELDS)
+	if (stream->dev->quirks & UVC_QUIRK_PROBE_EXTRAFIELDS)
 		probe->dwMaxVideoFrameSize =
-			video->streaming->ctrl.dwMaxVideoFrameSize;
+			stream->ctrl.dwMaxVideoFrameSize;
 
 	/* Probe the device. */
-	if ((ret = uvc_probe_video(video, probe)) < 0)
+	ret = uvc_probe_video(stream, probe);
+	if (ret < 0)
 		goto done;
 
 	fmt->fmt.pix.width = frame->wWidth;
@@ -216,13 +217,13 @@
 	return ret;
 }
 
-static int uvc_v4l2_get_format(struct uvc_video_device *video,
+static int uvc_v4l2_get_format(struct uvc_streaming *stream,
 	struct v4l2_format *fmt)
 {
-	struct uvc_format *format = video->streaming->cur_format;
-	struct uvc_frame *frame = video->streaming->cur_frame;
+	struct uvc_format *format = stream->cur_format;
+	struct uvc_frame *frame = stream->cur_frame;
 
-	if (fmt->type != video->streaming->type)
+	if (fmt->type != stream->type)
 		return -EINVAL;
 
 	if (format == NULL || frame == NULL)
@@ -233,14 +234,14 @@
 	fmt->fmt.pix.height = frame->wHeight;
 	fmt->fmt.pix.field = V4L2_FIELD_NONE;
 	fmt->fmt.pix.bytesperline = format->bpp * frame->wWidth / 8;
-	fmt->fmt.pix.sizeimage = video->streaming->ctrl.dwMaxVideoFrameSize;
+	fmt->fmt.pix.sizeimage = stream->ctrl.dwMaxVideoFrameSize;
 	fmt->fmt.pix.colorspace = format->colorspace;
 	fmt->fmt.pix.priv = 0;
 
 	return 0;
 }
 
-static int uvc_v4l2_set_format(struct uvc_video_device *video,
+static int uvc_v4l2_set_format(struct uvc_streaming *stream,
 	struct v4l2_format *fmt)
 {
 	struct uvc_streaming_control probe;
@@ -248,39 +249,39 @@
 	struct uvc_frame *frame;
 	int ret;
 
-	if (fmt->type != video->streaming->type)
+	if (fmt->type != stream->type)
 		return -EINVAL;
 
-	if (uvc_queue_allocated(&video->queue))
+	if (uvc_queue_allocated(&stream->queue))
 		return -EBUSY;
 
-	ret = uvc_v4l2_try_format(video, fmt, &probe, &format, &frame);
+	ret = uvc_v4l2_try_format(stream, fmt, &probe, &format, &frame);
 	if (ret < 0)
 		return ret;
 
-	memcpy(&video->streaming->ctrl, &probe, sizeof probe);
-	video->streaming->cur_format = format;
-	video->streaming->cur_frame = frame;
+	memcpy(&stream->ctrl, &probe, sizeof probe);
+	stream->cur_format = format;
+	stream->cur_frame = frame;
 
 	return 0;
 }
 
-static int uvc_v4l2_get_streamparm(struct uvc_video_device *video,
+static int uvc_v4l2_get_streamparm(struct uvc_streaming *stream,
 		struct v4l2_streamparm *parm)
 {
 	uint32_t numerator, denominator;
 
-	if (parm->type != video->streaming->type)
+	if (parm->type != stream->type)
 		return -EINVAL;
 
-	numerator = video->streaming->ctrl.dwFrameInterval;
+	numerator = stream->ctrl.dwFrameInterval;
 	denominator = 10000000;
 	uvc_simplify_fraction(&numerator, &denominator, 8, 333);
 
 	memset(parm, 0, sizeof *parm);
-	parm->type = video->streaming->type;
+	parm->type = stream->type;
 
-	if (video->streaming->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		parm->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
 		parm->parm.capture.capturemode = 0;
 		parm->parm.capture.timeperframe.numerator = numerator;
@@ -297,19 +298,19 @@
 	return 0;
 }
 
-static int uvc_v4l2_set_streamparm(struct uvc_video_device *video,
+static int uvc_v4l2_set_streamparm(struct uvc_streaming *stream,
 		struct v4l2_streamparm *parm)
 {
-	struct uvc_frame *frame = video->streaming->cur_frame;
+	struct uvc_frame *frame = stream->cur_frame;
 	struct uvc_streaming_control probe;
 	struct v4l2_fract timeperframe;
 	uint32_t interval;
 	int ret;
 
-	if (parm->type != video->streaming->type)
+	if (parm->type != stream->type)
 		return -EINVAL;
 
-	if (uvc_queue_streaming(&video->queue))
+	if (uvc_queue_streaming(&stream->queue))
 		return -EBUSY;
 
 	if (parm->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -317,7 +318,7 @@
 	else
 		timeperframe = parm->parm.output.timeperframe;
 
-	memcpy(&probe, &video->streaming->ctrl, sizeof probe);
+	memcpy(&probe, &stream->ctrl, sizeof probe);
 	interval = uvc_fraction_to_interval(timeperframe.numerator,
 		timeperframe.denominator);
 
@@ -326,10 +327,11 @@
 	probe.dwFrameInterval = uvc_try_frame_interval(frame, interval);
 
 	/* Probe the device with the new settings. */
-	if ((ret = uvc_probe_video(video, &probe)) < 0)
+	ret = uvc_probe_video(stream, &probe);
+	if (ret < 0)
 		return ret;
 
-	memcpy(&video->streaming->ctrl, &probe, sizeof probe);
+	memcpy(&stream->ctrl, &probe, sizeof probe);
 
 	/* Return the actual frame period. */
 	timeperframe.numerator = probe.dwFrameInterval;
@@ -382,8 +384,8 @@
 
 	/* Check if the device already has a privileged handle. */
 	mutex_lock(&uvc_driver.open_mutex);
-	if (atomic_inc_return(&handle->device->active) != 1) {
-		atomic_dec(&handle->device->active);
+	if (atomic_inc_return(&handle->stream->active) != 1) {
+		atomic_dec(&handle->stream->active);
 		ret = -EBUSY;
 		goto done;
 	}
@@ -398,7 +400,7 @@
 static void uvc_dismiss_privileges(struct uvc_fh *handle)
 {
 	if (handle->state == UVC_HANDLE_ACTIVE)
-		atomic_dec(&handle->device->active);
+		atomic_dec(&handle->stream->active);
 
 	handle->state = UVC_HANDLE_PASSIVE;
 }
@@ -414,21 +416,21 @@
 
 static int uvc_v4l2_open(struct file *file)
 {
-	struct uvc_video_device *video;
+	struct uvc_streaming *stream;
 	struct uvc_fh *handle;
 	int ret = 0;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_open\n");
 	mutex_lock(&uvc_driver.open_mutex);
-	video = video_drvdata(file);
+	stream = video_drvdata(file);
 
-	if (video->dev->state & UVC_DEV_DISCONNECTED) {
+	if (stream->dev->state & UVC_DEV_DISCONNECTED) {
 		ret = -ENODEV;
 		goto done;
 	}
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
-	ret = usb_autopm_get_interface(video->dev->intf);
+	ret = usb_autopm_get_interface(stream->dev->intf);
 	if (ret < 0)
 		goto done;
 #endif
@@ -437,28 +439,30 @@
 	handle = kzalloc(sizeof *handle, GFP_KERNEL);
 	if (handle == NULL) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
-		usb_autopm_put_interface(video->dev->intf);
+		usb_autopm_put_interface(stream->dev->intf);
 #endif
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	if (atomic_inc_return(&video->dev->users) == 1) {
-		if ((ret = uvc_status_start(video->dev)) < 0) {
+	if (atomic_inc_return(&stream->dev->users) == 1) {
+		ret = uvc_status_start(stream->dev);
+		if (ret < 0) {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
-			usb_autopm_put_interface(video->dev->intf);
+			usb_autopm_put_interface(stream->dev->intf);
 #endif
-			atomic_dec(&video->dev->users);
+			atomic_dec(&stream->dev->users);
 			kfree(handle);
 			goto done;
 		}
 	}
 
-	handle->device = video;
+	handle->video = &stream->dev->video;
+	handle->stream = stream;
 	handle->state = UVC_HANDLE_PASSIVE;
 	file->private_data = handle;
 
-	kref_get(&video->dev->kref);
+	kref_get(&stream->dev->kref);
 
 done:
 	mutex_unlock(&uvc_driver.open_mutex);
@@ -467,20 +471,20 @@
 
 static int uvc_v4l2_release(struct file *file)
 {
-	struct uvc_video_device *video = video_drvdata(file);
 	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_streaming *stream = handle->stream;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_release\n");
 
 	/* Only free resources if this is a privileged handle. */
 	if (uvc_has_privileges(handle)) {
-		uvc_video_enable(video, 0);
+		uvc_video_enable(stream, 0);
 
-		mutex_lock(&video->queue.mutex);
-		if (uvc_free_buffers(&video->queue) < 0)
+		mutex_lock(&stream->queue.mutex);
+		if (uvc_free_buffers(&stream->queue) < 0)
 			uvc_printk(KERN_ERR, "uvc_v4l2_release: Unable to "
 					"free buffers.\n");
-		mutex_unlock(&video->queue.mutex);
+		mutex_unlock(&stream->queue.mutex);
 	}
 
 	/* Release the file handle. */
@@ -488,21 +492,22 @@
 	kfree(handle);
 	file->private_data = NULL;
 
-	if (atomic_dec_return(&video->dev->users) == 0)
-		uvc_status_stop(video->dev);
+	if (atomic_dec_return(&stream->dev->users) == 0)
+		uvc_status_stop(stream->dev);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 19)
-	usb_autopm_put_interface(video->dev->intf);
+	usb_autopm_put_interface(stream->dev->intf);
 #endif
-	kref_put(&video->dev->kref, uvc_delete);
+	kref_put(&stream->dev->kref, uvc_delete);
 	return 0;
 }
 
 static long uvc_v4l2_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct uvc_video_device *video = video_get_drvdata(vdev);
 	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_video_device *video = handle->video;
+	struct uvc_streaming *stream = handle->stream;
 	long ret = 0;
 
 	switch (cmd) {
@@ -514,10 +519,10 @@
 		memset(cap, 0, sizeof *cap);
 		strlcpy(cap->driver, "uvcvideo", sizeof cap->driver);
 		strlcpy(cap->card, vdev->name, sizeof cap->card);
-		usb_make_path(video->dev->udev,
+		usb_make_path(stream->dev->udev,
 			      cap->bus_info, sizeof(cap->bus_info));
 		cap->version = DRIVER_VERSION_NUMBER;
-		if (video->streaming->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 			cap->capabilities = V4L2_CAP_VIDEO_CAPTURE
 					  | V4L2_CAP_STREAMING;
 		else
@@ -711,15 +716,15 @@
 		enum v4l2_buf_type type = fmt->type;
 		__u32 index = fmt->index;
 
-		if (fmt->type != video->streaming->type ||
-		    fmt->index >= video->streaming->nformats)
+		if (fmt->type != stream->type ||
+		    fmt->index >= stream->nformats)
 			return -EINVAL;
 
 		memset(fmt, 0, sizeof(*fmt));
 		fmt->index = index;
 		fmt->type = type;
 
-		format = &video->streaming->format[fmt->index];
+		format = &stream->format[fmt->index];
 		fmt->flags = 0;
 		if (format->flags & UVC_FMT_FLAG_COMPRESSED)
 			fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
@@ -737,17 +742,17 @@
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
-		return uvc_v4l2_try_format(video, arg, &probe, NULL, NULL);
+		return uvc_v4l2_try_format(stream, arg, &probe, NULL, NULL);
 	}
 
 	case VIDIOC_S_FMT:
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
-		return uvc_v4l2_set_format(video, arg);
+		return uvc_v4l2_set_format(stream, arg);
 
 	case VIDIOC_G_FMT:
-		return uvc_v4l2_get_format(video, arg);
+		return uvc_v4l2_get_format(stream, arg);
 
 	/* Frame size enumeration */
 	case VIDIOC_ENUM_FRAMESIZES:
@@ -758,10 +763,10 @@
 		int i;
 
 		/* Look for the given pixel format */
-		for (i = 0; i < video->streaming->nformats; i++) {
-			if (video->streaming->format[i].fcc ==
+		for (i = 0; i < stream->nformats; i++) {
+			if (stream->format[i].fcc ==
 					fsize->pixel_format) {
-				format = &video->streaming->format[i];
+				format = &stream->format[i];
 				break;
 			}
 		}
@@ -787,10 +792,10 @@
 		int i;
 
 		/* Look for the given pixel format and frame size */
-		for (i = 0; i < video->streaming->nformats; i++) {
-			if (video->streaming->format[i].fcc ==
+		for (i = 0; i < stream->nformats; i++) {
+			if (stream->format[i].fcc ==
 					fival->pixel_format) {
-				format = &video->streaming->format[i];
+				format = &stream->format[i];
 				break;
 			}
 		}
@@ -840,21 +845,21 @@
 
 	/* Get & Set streaming parameters */
 	case VIDIOC_G_PARM:
-		return uvc_v4l2_get_streamparm(video, arg);
+		return uvc_v4l2_get_streamparm(stream, arg);
 
 	case VIDIOC_S_PARM:
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
-		return uvc_v4l2_set_streamparm(video, arg);
+		return uvc_v4l2_set_streamparm(stream, arg);
 
 	/* Cropping and scaling */
 	case VIDIOC_CROPCAP:
 	{
 		struct v4l2_cropcap *ccap = arg;
-		struct uvc_frame *frame = video->streaming->cur_frame;
+		struct uvc_frame *frame = stream->cur_frame;
 
-		if (ccap->type != video->streaming->type)
+		if (ccap->type != stream->type)
 			return -EINVAL;
 
 		ccap->bounds.left = 0;
@@ -878,16 +883,16 @@
 	{
 		struct v4l2_requestbuffers *rb = arg;
 		unsigned int bufsize =
-			video->streaming->ctrl.dwMaxVideoFrameSize;
+			stream->ctrl.dwMaxVideoFrameSize;
 
-		if (rb->type != video->streaming->type ||
+		if (rb->type != stream->type ||
 		    rb->memory != V4L2_MEMORY_MMAP)
 			return -EINVAL;
 
 		if ((ret = uvc_acquire_privileges(handle)) < 0)
 			return ret;
 
-		ret = uvc_alloc_buffers(&video->queue, rb->count, bufsize);
+		ret = uvc_alloc_buffers(&stream->queue, rb->count, bufsize);
 		if (ret < 0)
 			return ret;
 
@@ -900,39 +905,40 @@
 	{
 		struct v4l2_buffer *buf = arg;
 
-		if (buf->type != video->streaming->type)
+		if (buf->type != stream->type)
 			return -EINVAL;
 
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		return uvc_query_buffer(&video->queue, buf);
+		return uvc_query_buffer(&stream->queue, buf);
 	}
 
 	case VIDIOC_QBUF:
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		return uvc_queue_buffer(&video->queue, arg);
+		return uvc_queue_buffer(&stream->queue, arg);
 
 	case VIDIOC_DQBUF:
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		return uvc_dequeue_buffer(&video->queue, arg,
+		return uvc_dequeue_buffer(&stream->queue, arg,
 			file->f_flags & O_NONBLOCK);
 
 	case VIDIOC_STREAMON:
 	{
 		int *type = arg;
 
-		if (*type != video->streaming->type)
+		if (*type != stream->type)
 			return -EINVAL;
 
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		if ((ret = uvc_video_enable(video, 1)) < 0)
+		ret = uvc_video_enable(stream, 1);
+		if (ret < 0)
 			return ret;
 		break;
 	}
@@ -941,13 +947,13 @@
 	{
 		int *type = arg;
 
-		if (*type != video->streaming->type)
+		if (*type != stream->type)
 			return -EINVAL;
 
 		if (!uvc_has_privileges(handle))
 			return -EBUSY;
 
-		return uvc_video_enable(video, 0);
+		return uvc_video_enable(stream, 0);
 	}
 
 	/* Analog video standards make no sense for digital cameras. */
@@ -1078,7 +1084,9 @@
 
 static int uvc_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct uvc_video_device *video = video_drvdata(file);
+	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_streaming *stream = handle->stream;
+	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_buffer *uninitialized_var(buffer);
 	struct page *page;
 	unsigned long addr, start, size;
@@ -1090,15 +1098,15 @@
 	start = vma->vm_start;
 	size = vma->vm_end - vma->vm_start;
 
-	mutex_lock(&video->queue.mutex);
+	mutex_lock(&queue->mutex);
 
-	for (i = 0; i < video->queue.count; ++i) {
-		buffer = &video->queue.buffer[i];
+	for (i = 0; i < queue->count; ++i) {
+		buffer = &queue->buffer[i];
 		if ((buffer->buf.m.offset >> PAGE_SHIFT) == vma->vm_pgoff)
 			break;
 	}
 
-	if (i == video->queue.count || size != video->queue.buf_size) {
+	if (i == queue->count || size != queue->buf_size) {
 		ret = -EINVAL;
 		goto done;
 	}
@@ -1109,7 +1117,7 @@
 	 */
 	vma->vm_flags |= VM_IO;
 
-	addr = (unsigned long)video->queue.mem + buffer->buf.m.offset;
+	addr = (unsigned long)queue->mem + buffer->buf.m.offset;
 	while (size > 0) {
 		page = vmalloc_to_page((void *)addr);
 		if ((ret = vm_insert_page(vma, start, page)) < 0)
@@ -1125,17 +1133,18 @@
 	uvc_vm_open(vma);
 
 done:
-	mutex_unlock(&video->queue.mutex);
+	mutex_unlock(&queue->mutex);
 	return ret;
 }
 
 static unsigned int uvc_v4l2_poll(struct file *file, poll_table *wait)
 {
-	struct uvc_video_device *video = video_drvdata(file);
+	struct uvc_fh *handle = (struct uvc_fh *)file->private_data;
+	struct uvc_streaming *stream = handle->stream;
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_poll\n");
 
-	return uvc_queue_poll(&video->queue, file, wait);
+	return uvc_queue_poll(&stream->queue, file, wait);
 }
 
 const struct v4l2_file_operations uvc_fops = {
diff -r da81aafb9c5d linux/drivers/media/video/uvc/uvc_video.c
--- a/linux/drivers/media/video/uvc/uvc_video.c	Mon Jul 20 00:16:05 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvc_video.c	Tue Jul 21 23:54:32 2009 +0200
@@ -61,7 +61,7 @@
 	return 0;
 }
 
-static void uvc_fixup_video_ctrl(struct uvc_video_device *video,
+static void uvc_fixup_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl)
 {
 	struct uvc_format *format;
@@ -69,10 +69,10 @@
 	unsigned int i;
 
 	if (ctrl->bFormatIndex <= 0 ||
-	    ctrl->bFormatIndex > video->streaming->nformats)
+	    ctrl->bFormatIndex > stream->nformats)
 		return;
 
-	format = &video->streaming->format[ctrl->bFormatIndex - 1];
+	format = &stream->format[ctrl->bFormatIndex - 1];
 
 	for (i = 0; i < format->nframes; ++i) {
 		if (format->frame[i].bFrameIndex == ctrl->bFrameIndex) {
@@ -86,12 +86,12 @@
 
 	if (!(format->flags & UVC_FMT_FLAG_COMPRESSED) ||
 	     (ctrl->dwMaxVideoFrameSize == 0 &&
-	      video->dev->uvc_version < 0x0110))
+	      stream->dev->uvc_version < 0x0110))
 		ctrl->dwMaxVideoFrameSize =
 			frame->dwMaxVideoFrameBufferSize;
 
-	if (video->dev->quirks & UVC_QUIRK_FIX_BANDWIDTH &&
-	    video->streaming->intf->num_altsetting > 1) {
+	if (stream->dev->quirks & UVC_QUIRK_FIX_BANDWIDTH &&
+	    stream->intf->num_altsetting > 1) {
 		u32 interval;
 		u32 bandwidth;
 
@@ -108,7 +108,7 @@
 		bandwidth = frame->wWidth * frame->wHeight / 8 * format->bpp;
 		bandwidth *= 10000000 / interval + 1;
 		bandwidth /= 1000;
-		if (video->dev->udev->speed == USB_SPEED_HIGH)
+		if (stream->dev->udev->speed == USB_SPEED_HIGH)
 			bandwidth /= 8;
 		bandwidth += 12;
 
@@ -116,14 +116,14 @@
 	}
 }
 
-static int uvc_get_video_ctrl(struct uvc_video_device *video,
+static int uvc_get_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl, int probe, __u8 query)
 {
 	__u8 *data;
 	__u16 size;
 	int ret;
 
-	size = video->dev->uvc_version >= 0x0110 ? 34 : 26;
+	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
 	data = kmalloc(size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
@@ -131,7 +131,7 @@
 	if ((video->dev->quirks & UVC_QUIRK_PROBE_DEF) && query == UVC_GET_DEF)
 		return -EIO;
 
-	ret = __uvc_query_ctrl(video->dev, query, 0, video->streaming->intfnum,
+	ret = __uvc_query_ctrl(stream->dev, query, 0, stream->intfnum,
 		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
 		size, UVC_CTRL_STREAMING_TIMEOUT);
 
@@ -140,7 +140,7 @@
 		 * answer a GET_MIN or GET_MAX request with the wCompQuality
 		 * field only.
 		 */
-		uvc_warn_once(video->dev, UVC_WARN_MINMAX, "UVC non "
+		uvc_warn_once(stream->dev, UVC_WARN_MINMAX, "UVC non "
 			"compliance - GET_MIN/MAX(PROBE) incorrectly "
 			"supported. Enabling workaround.\n");
 		memset(ctrl, 0, sizeof ctrl);
@@ -152,7 +152,7 @@
 		 * video probe control. Warn once and return, the caller will
 		 * fall back to GET_CUR.
 		 */
-		uvc_warn_once(video->dev, UVC_WARN_PROBE_DEF, "UVC non "
+		uvc_warn_once(stream->dev, UVC_WARN_PROBE_DEF, "UVC non "
 			"compliance - GET_DEF(PROBE) not supported. "
 			"Enabling workaround.\n");
 		ret = -EIO;
@@ -184,7 +184,7 @@
 		ctrl->bMinVersion = data[32];
 		ctrl->bMaxVersion = data[33];
 	} else {
-		ctrl->dwClockFrequency = video->dev->clock_frequency;
+		ctrl->dwClockFrequency = stream->dev->clock_frequency;
 		ctrl->bmFramingInfo = 0;
 		ctrl->bPreferedVersion = 0;
 		ctrl->bMinVersion = 0;
@@ -195,7 +195,7 @@
 	 * dwMaxPayloadTransferSize fields. Try to get the value from the
 	 * format and frame descriptors.
 	 */
-	uvc_fixup_video_ctrl(video, ctrl);
+	uvc_fixup_video_ctrl(stream, ctrl);
 	ret = 0;
 
 out:
@@ -203,14 +203,14 @@
 	return ret;
 }
 
-static int uvc_set_video_ctrl(struct uvc_video_device *video,
+static int uvc_set_video_ctrl(struct uvc_streaming *stream,
 	struct uvc_streaming_control *ctrl, int probe)
 {
 	__u8 *data;
 	__u16 size;
 	int ret;
 
-	size = video->dev->uvc_version >= 0x0110 ? 34 : 26;
+	size = stream->dev->uvc_version >= 0x0110 ? 34 : 26;
 	data = kzalloc(size, GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
@@ -235,8 +235,7 @@
 		data[33] = ctrl->bMaxVersion;
 	}
 
-	ret = __uvc_query_ctrl(video->dev, UVC_SET_CUR, 0,
-		video->streaming->intfnum,
+	ret = __uvc_query_ctrl(stream->dev, UVC_SET_CUR, 0, stream->intfnum,
 		probe ? UVC_VS_PROBE_CONTROL : UVC_VS_COMMIT_CONTROL, data,
 		size, UVC_CTRL_STREAMING_TIMEOUT);
 	if (ret != size) {
@@ -250,7 +249,7 @@
 	return ret;
 }
 
-int uvc_probe_video(struct uvc_video_device *video,
+int uvc_probe_video(struct uvc_streaming *stream,
 	struct uvc_streaming_control *probe)
 {
 	struct uvc_streaming_control probe_min, probe_max;
@@ -258,7 +257,7 @@
 	unsigned int i;
 	int ret;
 
-	mutex_lock(&video->streaming->mutex);
+	mutex_lock(&stream->mutex);
 
 	/* Perform probing. The device should adjust the requested values
 	 * according to its capabilities. However, some devices, namely the
@@ -267,15 +266,16 @@
 	 * that reason, if the needed bandwidth exceeds the maximum available
 	 * bandwidth, try to lower the quality.
 	 */
-	if ((ret = uvc_set_video_ctrl(video, probe, 1)) < 0)
+	ret = uvc_set_video_ctrl(stream, probe, 1);
+	if (ret < 0)
 		goto done;
 
 	/* Get the minimum and maximum values for compression settings. */
-	if (!(video->dev->quirks & UVC_QUIRK_PROBE_MINMAX)) {
-		ret = uvc_get_video_ctrl(video, &probe_min, 1, UVC_GET_MIN);
+	if (!(stream->dev->quirks & UVC_QUIRK_PROBE_MINMAX)) {
+		ret = uvc_get_video_ctrl(stream, &probe_min, 1, UVC_GET_MIN);
 		if (ret < 0)
 			goto done;
-		ret = uvc_get_video_ctrl(video, &probe_max, 1, UVC_GET_MAX);
+		ret = uvc_get_video_ctrl(stream, &probe_max, 1, UVC_GET_MAX);
 		if (ret < 0)
 			goto done;
 
@@ -283,21 +283,21 @@
 	}
 
 	for (i = 0; i < 2; ++i) {
-		ret = uvc_set_video_ctrl(video, probe, 1);
+		ret = uvc_set_video_ctrl(stream, probe, 1);
 		if (ret < 0)
 			goto done;
-		ret = uvc_get_video_ctrl(video, probe, 1, UVC_GET_CUR);
+		ret = uvc_get_video_ctrl(stream, probe, 1, UVC_GET_CUR);
 		if (ret < 0)
 			goto done;
 
-		if (video->streaming->intf->num_altsetting == 1)
+		if (stream->intf->num_altsetting == 1)
 			break;
 
 		bandwidth = probe->dwMaxPayloadTransferSize;
-		if (bandwidth <= video->streaming->maxpsize)
+		if (bandwidth <= stream->maxpsize)
 			break;
 
-		if (video->dev->quirks & UVC_QUIRK_PROBE_MINMAX) {
+		if (stream->dev->quirks & UVC_QUIRK_PROBE_MINMAX) {
 			ret = -ENOSPC;
 			goto done;
 		}
@@ -310,14 +310,14 @@
 	}
 
 done:
-	mutex_unlock(&video->streaming->mutex);
+	mutex_unlock(&stream->mutex);
 	return ret;
 }
 
-int uvc_commit_video(struct uvc_video_device *video,
+int uvc_commit_video(struct uvc_streaming *stream,
 	struct uvc_streaming_control *probe)
 {
-	return uvc_set_video_ctrl(video, probe, 0);
+	return uvc_set_video_ctrl(stream, probe, 0);
 }
 
 /* ------------------------------------------------------------------------
@@ -369,7 +369,7 @@
  * to be called with a NULL buf parameter. uvc_video_decode_data and
  * uvc_video_decode_end will never be called with a NULL buffer.
  */
-static int uvc_video_decode_start(struct uvc_video_device *video,
+static int uvc_video_decode_start(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, const __u8 *data, int len)
 {
 	__u8 fid;
@@ -395,25 +395,25 @@
 	 * NULL.
 	 */
 	if (buf == NULL) {
-		video->last_fid = fid;
+		stream->last_fid = fid;
 		return -ENODATA;
 	}
 
 	/* Synchronize to the input stream by waiting for the FID bit to be
 	 * toggled when the the buffer state is not UVC_BUF_STATE_ACTIVE.
-	 * video->last_fid is initialized to -1, so the first isochronous
+	 * stream->last_fid is initialized to -1, so the first isochronous
 	 * frame will always be in sync.
 	 *
-	 * If the device doesn't toggle the FID bit, invert video->last_fid
+	 * If the device doesn't toggle the FID bit, invert stream->last_fid
 	 * when the EOF bit is set to force synchronisation on the next packet.
 	 */
 	if (buf->state != UVC_BUF_STATE_ACTIVE) {
-		if (fid == video->last_fid) {
+		if (fid == stream->last_fid) {
 			uvc_trace(UVC_TRACE_FRAME, "Dropping payload (out of "
 				"sync).\n");
-			if ((video->dev->quirks & UVC_QUIRK_STREAM_NO_FID) &&
+			if ((stream->dev->quirks & UVC_QUIRK_STREAM_NO_FID) &&
 			    (data[1] & UVC_STREAM_EOF))
-				video->last_fid ^= UVC_STREAM_FID;
+				stream->last_fid ^= UVC_STREAM_FID;
 			return -ENODATA;
 		}
 
@@ -428,7 +428,7 @@
 	 * last payload can be lost anyway). We thus must check if the FID has
 	 * been toggled.
 	 *
-	 * video->last_fid is initialized to -1, so the first isochronous
+	 * stream->last_fid is initialized to -1, so the first isochronous
 	 * frame will never trigger an end of frame detection.
 	 *
 	 * Empty buffers (bytesused == 0) don't trigger end of frame detection
@@ -436,22 +436,22 @@
 	 * avoids detecting end of frame conditions at FID toggling if the
 	 * previous payload had the EOF bit set.
 	 */
-	if (fid != video->last_fid && buf->buf.bytesused != 0) {
+	if (fid != stream->last_fid && buf->buf.bytesused != 0) {
 		uvc_trace(UVC_TRACE_FRAME, "Frame complete (FID bit "
 				"toggled).\n");
 		buf->state = UVC_BUF_STATE_DONE;
 		return -EAGAIN;
 	}
 
-	video->last_fid = fid;
+	stream->last_fid = fid;
 
 	return data[0];
 }
 
-static void uvc_video_decode_data(struct uvc_video_device *video,
+static void uvc_video_decode_data(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, const __u8 *data, int len)
 {
-	struct uvc_video_queue *queue = &video->queue;
+	struct uvc_video_queue *queue = &stream->queue;
 	unsigned int maxlen, nbytes;
 	void *mem;
 
@@ -472,7 +472,7 @@
 	}
 }
 
-static void uvc_video_decode_end(struct uvc_video_device *video,
+static void uvc_video_decode_end(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, const __u8 *data, int len)
 {
 	/* Mark the buffer as done if the EOF marker is set. */
@@ -481,8 +481,8 @@
 		if (data[0] == len)
 			uvc_trace(UVC_TRACE_FRAME, "EOF in empty payload.\n");
 		buf->state = UVC_BUF_STATE_DONE;
-		if (video->dev->quirks & UVC_QUIRK_STREAM_NO_FID)
-			video->last_fid ^= UVC_STREAM_FID;
+		if (stream->dev->quirks & UVC_QUIRK_STREAM_NO_FID)
+			stream->last_fid ^= UVC_STREAM_FID;
 	}
 }
 
@@ -497,26 +497,26 @@
  * uvc_video_encode_data is called for every URB and copies the data from the
  * video buffer to the transfer buffer.
  */
-static int uvc_video_encode_header(struct uvc_video_device *video,
+static int uvc_video_encode_header(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, __u8 *data, int len)
 {
 	data[0] = 2;	/* Header length */
 	data[1] = UVC_STREAM_EOH | UVC_STREAM_EOF
-		| (video->last_fid & UVC_STREAM_FID);
+		| (stream->last_fid & UVC_STREAM_FID);
 	return 2;
 }
 
-static int uvc_video_encode_data(struct uvc_video_device *video,
+static int uvc_video_encode_data(struct uvc_streaming *stream,
 		struct uvc_buffer *buf, __u8 *data, int len)
 {
-	struct uvc_video_queue *queue = &video->queue;
+	struct uvc_video_queue *queue = &stream->queue;
 	unsigned int nbytes;
 	void *mem;
 
 	/* Copy video data to the URB buffer. */
 	mem = queue->mem + buf->buf.m.offset + queue->buf_used;
 	nbytes = min((unsigned int)len, buf->buf.bytesused - queue->buf_used);
-	nbytes = min(video->bulk.max_payload_size - video->bulk.payload_size,
+	nbytes = min(stream->bulk.max_payload_size - stream->bulk.payload_size,
 			nbytes);
 	memcpy(data, mem, nbytes);
 
@@ -532,8 +532,8 @@
 /*
  * Completion handler for video URBs.
  */
-static void uvc_video_decode_isoc(struct urb *urb,
-	struct uvc_video_device *video, struct uvc_buffer *buf)
+static void uvc_video_decode_isoc(struct urb *urb, struct uvc_streaming *stream,
+	struct uvc_buffer *buf)
 {
 	u8 *mem;
 	int ret, i;
@@ -548,31 +548,32 @@
 		/* Decode the payload header. */
 		mem = urb->transfer_buffer + urb->iso_frame_desc[i].offset;
 		do {
-			ret = uvc_video_decode_start(video, buf, mem,
+			ret = uvc_video_decode_start(stream, buf, mem,
 				urb->iso_frame_desc[i].actual_length);
 			if (ret == -EAGAIN)
-				buf = uvc_queue_next_buffer(&video->queue, buf);
+				buf = uvc_queue_next_buffer(&stream->queue,
+							    buf);
 		} while (ret == -EAGAIN);
 
 		if (ret < 0)
 			continue;
 
 		/* Decode the payload data. */
-		uvc_video_decode_data(video, buf, mem + ret,
+		uvc_video_decode_data(stream, buf, mem + ret,
 			urb->iso_frame_desc[i].actual_length - ret);
 
 		/* Process the header again. */
-		uvc_video_decode_end(video, buf, mem,
+		uvc_video_decode_end(stream, buf, mem,
 			urb->iso_frame_desc[i].actual_length);
 
 		if (buf->state == UVC_BUF_STATE_DONE ||
 		    buf->state == UVC_BUF_STATE_ERROR)
-			buf = uvc_queue_next_buffer(&video->queue, buf);
+			buf = uvc_queue_next_buffer(&stream->queue, buf);
 	}
 }
 
-static void uvc_video_decode_bulk(struct urb *urb,
-	struct uvc_video_device *video, struct uvc_buffer *buf)
+static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
+	struct uvc_buffer *buf)
 {
 	u8 *mem;
 	int len, ret;
@@ -582,24 +583,25 @@
 
 	mem = urb->transfer_buffer;
 	len = urb->actual_length;
-	video->bulk.payload_size += len;
+	stream->bulk.payload_size += len;
 
 	/* If the URB is the first of its payload, decode and save the
 	 * header.
 	 */
-	if (video->bulk.header_size == 0 && !video->bulk.skip_payload) {
+	if (stream->bulk.header_size == 0 && !stream->bulk.skip_payload) {
 		do {
-			ret = uvc_video_decode_start(video, buf, mem, len);
+			ret = uvc_video_decode_start(stream, buf, mem, len);
 			if (ret == -EAGAIN)
-				buf = uvc_queue_next_buffer(&video->queue, buf);
+				buf = uvc_queue_next_buffer(&stream->queue,
+							    buf);
 		} while (ret == -EAGAIN);
 
 		/* If an error occured skip the rest of the payload. */
 		if (ret < 0 || buf == NULL) {
-			video->bulk.skip_payload = 1;
+			stream->bulk.skip_payload = 1;
 		} else {
-			memcpy(video->bulk.header, mem, ret);
-			video->bulk.header_size = ret;
+			memcpy(stream->bulk.header, mem, ret);
+			stream->bulk.header_size = ret;
 
 			mem += ret;
 			len -= ret;
@@ -612,33 +614,34 @@
 	 */
 
 	/* Process video data. */
-	if (!video->bulk.skip_payload && buf != NULL)
-		uvc_video_decode_data(video, buf, mem, len);
+	if (!stream->bulk.skip_payload && buf != NULL)
+		uvc_video_decode_data(stream, buf, mem, len);
 
 	/* Detect the payload end by a URB smaller than the maximum size (or
 	 * a payload size equal to the maximum) and process the header again.
 	 */
 	if (urb->actual_length < urb->transfer_buffer_length ||
-	    video->bulk.payload_size >= video->bulk.max_payload_size) {
-		if (!video->bulk.skip_payload && buf != NULL) {
-			uvc_video_decode_end(video, buf, video->bulk.header,
-				video->bulk.payload_size);
+	    stream->bulk.payload_size >= stream->bulk.max_payload_size) {
+		if (!stream->bulk.skip_payload && buf != NULL) {
+			uvc_video_decode_end(stream, buf, stream->bulk.header,
+				stream->bulk.payload_size);
 			if (buf->state == UVC_BUF_STATE_DONE ||
 			    buf->state == UVC_BUF_STATE_ERROR)
-				buf = uvc_queue_next_buffer(&video->queue, buf);
+				buf = uvc_queue_next_buffer(&stream->queue,
+							    buf);
 		}
 
-		video->bulk.header_size = 0;
-		video->bulk.skip_payload = 0;
-		video->bulk.payload_size = 0;
+		stream->bulk.header_size = 0;
+		stream->bulk.skip_payload = 0;
+		stream->bulk.payload_size = 0;
 	}
 }
 
-static void uvc_video_encode_bulk(struct urb *urb,
-	struct uvc_video_device *video, struct uvc_buffer *buf)
+static void uvc_video_encode_bulk(struct urb *urb, struct uvc_streaming *stream,
+	struct uvc_buffer *buf)
 {
 	u8 *mem = urb->transfer_buffer;
-	int len = video->urb_size, ret;
+	int len = stream->urb_size, ret;
 
 	if (buf == NULL) {
 		urb->transfer_buffer_length = 0;
@@ -646,34 +649,34 @@
 	}
 
 	/* If the URB is the first of its payload, add the header. */
-	if (video->bulk.header_size == 0) {
-		ret = uvc_video_encode_header(video, buf, mem, len);
-		video->bulk.header_size = ret;
-		video->bulk.payload_size += ret;
+	if (stream->bulk.header_size == 0) {
+		ret = uvc_video_encode_header(stream, buf, mem, len);
+		stream->bulk.header_size = ret;
+		stream->bulk.payload_size += ret;
 		mem += ret;
 		len -= ret;
 	}
 
 	/* Process video data. */
-	ret = uvc_video_encode_data(video, buf, mem, len);
+	ret = uvc_video_encode_data(stream, buf, mem, len);
 
-	video->bulk.payload_size += ret;
+	stream->bulk.payload_size += ret;
 	len -= ret;
 
-	if (buf->buf.bytesused == video->queue.buf_used ||
-	    video->bulk.payload_size == video->bulk.max_payload_size) {
-		if (buf->buf.bytesused == video->queue.buf_used) {
-			video->queue.buf_used = 0;
+	if (buf->buf.bytesused == stream->queue.buf_used ||
+	    stream->bulk.payload_size == stream->bulk.max_payload_size) {
+		if (buf->buf.bytesused == stream->queue.buf_used) {
+			stream->queue.buf_used = 0;
 			buf->state = UVC_BUF_STATE_DONE;
-			uvc_queue_next_buffer(&video->queue, buf);
-			video->last_fid ^= UVC_STREAM_FID;
+			uvc_queue_next_buffer(&stream->queue, buf);
+			stream->last_fid ^= UVC_STREAM_FID;
 		}
 
-		video->bulk.header_size = 0;
-		video->bulk.payload_size = 0;
+		stream->bulk.header_size = 0;
+		stream->bulk.payload_size = 0;
 	}
 
-	urb->transfer_buffer_length = video->urb_size - len;
+	urb->transfer_buffer_length = stream->urb_size - len;
 }
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 19)
@@ -682,8 +685,8 @@
 static void uvc_video_complete(struct urb *urb)
 #endif
 {
-	struct uvc_video_device *video = urb->context;
-	struct uvc_video_queue *queue = &video->queue;
+	struct uvc_streaming *stream = urb->context;
+	struct uvc_video_queue *queue = &stream->queue;
 	struct uvc_buffer *buf = NULL;
 	unsigned long flags;
 	int ret;
@@ -697,7 +700,7 @@
 			"completion handler.\n", urb->status);
 
 	case -ENOENT:		/* usb_kill_urb() called. */
-		if (video->frozen)
+		if (stream->frozen)
 			return;
 
 	case -ECONNRESET:	/* usb_unlink_urb() called. */
@@ -712,7 +715,7 @@
 				       queue);
 	spin_unlock_irqrestore(&queue->irqlock, flags);
 
-	video->decode(urb, video, buf);
+	stream->decode(urb, stream, buf);
 
 	if ((ret = usb_submit_urb(urb, GFP_ATOMIC)) < 0) {
 		uvc_printk(KERN_ERR, "Failed to resubmit video URB (%d).\n",
@@ -723,19 +726,19 @@
 /*
  * Free transfer buffers.
  */
-static void uvc_free_urb_buffers(struct uvc_video_device *video)
+static void uvc_free_urb_buffers(struct uvc_streaming *stream)
 {
 	unsigned int i;
 
 	for (i = 0; i < UVC_URBS; ++i) {
-		if (video->urb_buffer[i]) {
-			usb_buffer_free(video->dev->udev, video->urb_size,
-				video->urb_buffer[i], video->urb_dma[i]);
-			video->urb_buffer[i] = NULL;
+		if (stream->urb_buffer[i]) {
+			usb_buffer_free(stream->dev->udev, stream->urb_size,
+				stream->urb_buffer[i], stream->urb_dma[i]);
+			stream->urb_buffer[i] = NULL;
 		}
 	}
 
-	video->urb_size = 0;
+	stream->urb_size = 0;
 }
 
 /*
@@ -749,15 +752,15 @@
  *
  * Return the number of allocated packets on success or 0 when out of memory.
  */
-static int uvc_alloc_urb_buffers(struct uvc_video_device *video,
+static int uvc_alloc_urb_buffers(struct uvc_streaming *stream,
 	unsigned int size, unsigned int psize, gfp_t gfp_flags)
 {
 	unsigned int npackets;
 	unsigned int i;
 
 	/* Buffers are already allocated, bail out. */
-	if (video->urb_size)
-		return video->urb_size / psize;
+	if (stream->urb_size)
+		return stream->urb_size / psize;
 
 	/* Compute the number of packets. Bulk endpoints might transfer UVC
 	 * payloads accross multiple URBs.
@@ -769,17 +772,17 @@
 	/* Retry allocations until one succeed. */
 	for (; npackets > 1; npackets /= 2) {
 		for (i = 0; i < UVC_URBS; ++i) {
-			video->urb_buffer[i] = usb_buffer_alloc(
-				video->dev->udev, psize * npackets,
-				gfp_flags | __GFP_NOWARN, &video->urb_dma[i]);
-			if (!video->urb_buffer[i]) {
-				uvc_free_urb_buffers(video);
+			stream->urb_buffer[i] = usb_buffer_alloc(
+				stream->dev->udev, psize * npackets,
+				gfp_flags | __GFP_NOWARN, &stream->urb_dma[i]);
+			if (!stream->urb_buffer[i]) {
+				uvc_free_urb_buffers(stream);
 				break;
 			}
 		}
 
 		if (i == UVC_URBS) {
-			video->urb_size = psize * npackets;
+			stream->urb_size = psize * npackets;
 			return npackets;
 		}
 	}
@@ -790,29 +793,30 @@
 /*
  * Uninitialize isochronous/bulk URBs and free transfer buffers.
  */
-static void uvc_uninit_video(struct uvc_video_device *video, int free_buffers)
+static void uvc_uninit_video(struct uvc_streaming *stream, int free_buffers)
 {
 	struct urb *urb;
 	unsigned int i;
 
 	for (i = 0; i < UVC_URBS; ++i) {
-		if ((urb = video->urb[i]) == NULL)
+		urb = stream->urb[i];
+		if (urb == NULL)
 			continue;
 
 		usb_kill_urb(urb);
 		usb_free_urb(urb);
-		video->urb[i] = NULL;
+		stream->urb[i] = NULL;
 	}
 
 	if (free_buffers)
-		uvc_free_urb_buffers(video);
+		uvc_free_urb_buffers(stream);
 }
 
 /*
  * Initialize isochronous URBs and allocate transfer buffers. The packet size
  * is given by the endpoint.
  */
-static int uvc_init_video_isoc(struct uvc_video_device *video,
+static int uvc_init_video_isoc(struct uvc_streaming *stream,
 	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
@@ -822,9 +826,9 @@
 
 	psize = le16_to_cpu(ep->desc.wMaxPacketSize);
 	psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
-	size = video->streaming->ctrl.dwMaxVideoFrameSize;
+	size = stream->ctrl.dwMaxVideoFrameSize;
 
-	npackets = uvc_alloc_urb_buffers(video, size, psize, gfp_flags);
+	npackets = uvc_alloc_urb_buffers(stream, size, psize, gfp_flags);
 	if (npackets == 0)
 		return -ENOMEM;
 
@@ -833,18 +837,18 @@
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = usb_alloc_urb(npackets, gfp_flags);
 		if (urb == NULL) {
-			uvc_uninit_video(video, 1);
+			uvc_uninit_video(stream, 1);
 			return -ENOMEM;
 		}
 
-		urb->dev = video->dev->udev;
-		urb->context = video;
-		urb->pipe = usb_rcvisocpipe(video->dev->udev,
+		urb->dev = stream->dev->udev;
+		urb->context = stream;
+		urb->pipe = usb_rcvisocpipe(stream->dev->udev,
 				ep->desc.bEndpointAddress);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->interval = ep->desc.bInterval;
-		urb->transfer_buffer = video->urb_buffer[i];
-		urb->transfer_dma = video->urb_dma[i];
+		urb->transfer_buffer = stream->urb_buffer[i];
+		urb->transfer_dma = stream->urb_dma[i];
 		urb->complete = uvc_video_complete;
 		urb->number_of_packets = npackets;
 		urb->transfer_buffer_length = size;
@@ -854,7 +858,7 @@
 			urb->iso_frame_desc[j].length = psize;
 		}
 
-		video->urb[i] = urb;
+		stream->urb[i] = urb;
 	}
 
 	return 0;
@@ -864,7 +868,7 @@
  * Initialize bulk URBs and allocate transfer buffers. The packet size is
  * given by the endpoint.
  */
-static int uvc_init_video_bulk(struct uvc_video_device *video,
+static int uvc_init_video_bulk(struct uvc_streaming *stream,
 	struct usb_host_endpoint *ep, gfp_t gfp_flags)
 {
 	struct urb *urb;
@@ -873,39 +877,39 @@
 	u32 size;
 
 	psize = le16_to_cpu(ep->desc.wMaxPacketSize) & 0x07ff;
-	size = video->streaming->ctrl.dwMaxPayloadTransferSize;
-	video->bulk.max_payload_size = size;
+	size = stream->ctrl.dwMaxPayloadTransferSize;
+	stream->bulk.max_payload_size = size;
 
-	npackets = uvc_alloc_urb_buffers(video, size, psize, gfp_flags);
+	npackets = uvc_alloc_urb_buffers(stream, size, psize, gfp_flags);
 	if (npackets == 0)
 		return -ENOMEM;
 
 	size = npackets * psize;
 
 	if (usb_endpoint_dir_in(&ep->desc))
-		pipe = usb_rcvbulkpipe(video->dev->udev,
+		pipe = usb_rcvbulkpipe(stream->dev->udev,
 				       ep->desc.bEndpointAddress);
 	else
-		pipe = usb_sndbulkpipe(video->dev->udev,
+		pipe = usb_sndbulkpipe(stream->dev->udev,
 				       ep->desc.bEndpointAddress);
 
-	if (video->streaming->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+	if (stream->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
 		size = 0;
 
 	for (i = 0; i < UVC_URBS; ++i) {
 		urb = usb_alloc_urb(0, gfp_flags);
 		if (urb == NULL) {
-			uvc_uninit_video(video, 1);
+			uvc_uninit_video(stream, 1);
 			return -ENOMEM;
 		}
 
-		usb_fill_bulk_urb(urb, video->dev->udev, pipe,
-			video->urb_buffer[i], size, uvc_video_complete,
-			video);
+		usb_fill_bulk_urb(urb, stream->dev->udev, pipe,
+			stream->urb_buffer[i], size, uvc_video_complete,
+			stream);
 		urb->transfer_flags = URB_NO_TRANSFER_DMA_MAP;
-		urb->transfer_dma = video->urb_dma[i];
+		urb->transfer_dma = stream->urb_dma[i];
 
-		video->urb[i] = urb;
+		stream->urb[i] = urb;
 	}
 
 	return 0;
@@ -914,35 +918,35 @@
 /*
  * Initialize isochronous/bulk URBs and allocate transfer buffers.
  */
-static int uvc_init_video(struct uvc_video_device *video, gfp_t gfp_flags)
+static int uvc_init_video(struct uvc_streaming *stream, gfp_t gfp_flags)
 {
-	struct usb_interface *intf = video->streaming->intf;
+	struct usb_interface *intf = stream->intf;
 	struct usb_host_interface *alts;
 	struct usb_host_endpoint *ep = NULL;
-	int intfnum = video->streaming->intfnum;
+	int intfnum = stream->intfnum;
 	unsigned int bandwidth, psize, i;
 	int ret;
 
-	video->last_fid = -1;
-	video->bulk.header_size = 0;
-	video->bulk.skip_payload = 0;
-	video->bulk.payload_size = 0;
+	stream->last_fid = -1;
+	stream->bulk.header_size = 0;
+	stream->bulk.skip_payload = 0;
+	stream->bulk.payload_size = 0;
 
 	if (intf->num_altsetting > 1) {
 		/* Isochronous endpoint, select the alternate setting. */
-		bandwidth = video->streaming->ctrl.dwMaxPayloadTransferSize;
+		bandwidth = stream->ctrl.dwMaxPayloadTransferSize;
 
 		if (bandwidth == 0) {
 			uvc_printk(KERN_WARNING, "device %s requested null "
 				"bandwidth, defaulting to lowest.\n",
-				video->vdev->name);
+				stream->dev->name);
 			bandwidth = 1;
 		}
 
 		for (i = 0; i < intf->num_altsetting; ++i) {
 			alts = &intf->altsetting[i];
 			ep = uvc_find_endpoint(alts,
-				video->streaming->header.bEndpointAddress);
+				stream->header.bEndpointAddress);
 			if (ep == NULL)
 				continue;
 
@@ -956,18 +960,19 @@
 		if (i >= intf->num_altsetting)
 			return -EIO;
 
-		if ((ret = usb_set_interface(video->dev->udev, intfnum, i)) < 0)
+		ret = usb_set_interface(stream->dev->udev, intfnum, i);
+		if (ret < 0)
 			return ret;
 
-		ret = uvc_init_video_isoc(video, ep, gfp_flags);
+		ret = uvc_init_video_isoc(stream, ep, gfp_flags);
 	} else {
 		/* Bulk endpoint, proceed to URB initialization. */
 		ep = uvc_find_endpoint(&intf->altsetting[0],
-				video->streaming->header.bEndpointAddress);
+				stream->header.bEndpointAddress);
 		if (ep == NULL)
 			return -EIO;
 
-		ret = uvc_init_video_bulk(video, ep, gfp_flags);
+		ret = uvc_init_video_bulk(stream, ep, gfp_flags);
 	}
 
 	if (ret < 0)
@@ -975,10 +980,11 @@
 
 	/* Submit the URBs. */
 	for (i = 0; i < UVC_URBS; ++i) {
-		if ((ret = usb_submit_urb(video->urb[i], gfp_flags)) < 0) {
+		ret = usb_submit_urb(stream->urb[i], gfp_flags);
+		if (ret < 0) {
 			uvc_printk(KERN_ERR, "Failed to submit URB %u "
 					"(%d).\n", i, ret);
-			uvc_uninit_video(video, 1);
+			uvc_uninit_video(stream, 1);
 			return ret;
 		}
 	}
@@ -997,14 +1003,14 @@
  * video buffers in any way. We mark the device as frozen to make sure the URB
  * completion handler won't try to cancel the queue when we kill the URBs.
  */
-int uvc_video_suspend(struct uvc_video_device *video)
+int uvc_video_suspend(struct uvc_streaming *stream)
 {
-	if (!uvc_queue_streaming(&video->queue))
+	if (!uvc_queue_streaming(&stream->queue))
 		return 0;
 
-	video->frozen = 1;
-	uvc_uninit_video(video, 0);
-	usb_set_interface(video->dev->udev, video->streaming->intfnum, 0);
+	stream->frozen = 1;
+	uvc_uninit_video(stream, 0);
+	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
 	return 0;
 }
 
@@ -1016,22 +1022,24 @@
  * buffers, making sure userspace applications are notified of the problem
  * instead of waiting forever.
  */
-int uvc_video_resume(struct uvc_video_device *video)
+int uvc_video_resume(struct uvc_streaming *stream)
 {
 	int ret;
 
-	video->frozen = 0;
+	stream->frozen = 0;
 
-	if ((ret = uvc_commit_video(video, &video->streaming->ctrl)) < 0) {
-		uvc_queue_enable(&video->queue, 0);
+	ret = uvc_commit_video(stream, &stream->ctrl);
+	if (ret < 0) {
+		uvc_queue_enable(&stream->queue, 0);
 		return ret;
 	}
 
-	if (!uvc_queue_streaming(&video->queue))
+	if (!uvc_queue_streaming(&stream->queue))
 		return 0;
 
-	if ((ret = uvc_init_video(video, GFP_NOIO)) < 0)
-		uvc_queue_enable(&video->queue, 0);
+	ret = uvc_init_video(stream, GFP_NOIO);
+	if (ret < 0)
+		uvc_queue_enable(&stream->queue, 0);
 
 	return ret;
 }
@@ -1050,48 +1058,53 @@
  *
  * This function is called before registering the device with V4L.
  */
-int uvc_video_init(struct uvc_video_device *video)
+int uvc_video_init(struct uvc_streaming *stream)
 {
-	struct uvc_streaming_control *probe = &video->streaming->ctrl;
+	struct uvc_streaming_control *probe = &stream->ctrl;
 	struct uvc_format *format = NULL;
 	struct uvc_frame *frame = NULL;
 	unsigned int i;
 	int ret;
 
-	if (video->streaming->nformats == 0) {
+	if (stream->nformats == 0) {
 		uvc_printk(KERN_INFO, "No supported video formats found.\n");
 		return -EINVAL;
 	}
 
+	atomic_set(&stream->active, 0);
+
+	/* Initialize the video buffers queue. */
+	uvc_queue_init(&stream->queue, stream->type);
+
 	/* Alternate setting 0 should be the default, yet the XBox Live Vision
 	 * Cam (and possibly other devices) crash or otherwise misbehave if
 	 * they don't receive a SET_INTERFACE request before any other video
 	 * control request.
 	 */
-	usb_set_interface(video->dev->udev, video->streaming->intfnum, 0);
+	usb_set_interface(stream->dev->udev, stream->intfnum, 0);
 
 	/* Set the streaming probe control with default streaming parameters
 	 * retrieved from the device. Webcams that don't suport GET_DEF
 	 * requests on the probe control will just keep their current streaming
 	 * parameters.
 	 */
-	if (uvc_get_video_ctrl(video, probe, 1, UVC_GET_DEF) == 0)
-		uvc_set_video_ctrl(video, probe, 1);
+	if (uvc_get_video_ctrl(stream, probe, 1, UVC_GET_DEF) == 0)
+		uvc_set_video_ctrl(stream, probe, 1);
 
 	/* Initialize the streaming parameters with the probe control current
 	 * value. This makes sure SET_CUR requests on the streaming commit
 	 * control will always use values retrieved from a successful GET_CUR
 	 * request on the probe control, as required by the UVC specification.
 	 */
-	ret = uvc_get_video_ctrl(video, probe, 1, UVC_GET_CUR);
+	ret = uvc_get_video_ctrl(stream, probe, 1, UVC_GET_CUR);
 	if (ret < 0)
 		return ret;
 
 	/* Check if the default format descriptor exists. Use the first
 	 * available format otherwise.
 	 */
-	for (i = video->streaming->nformats; i > 0; --i) {
-		format = &video->streaming->format[i-1];
+	for (i = stream->nformats; i > 0; --i) {
+		format = &stream->format[i-1];
 		if (format->index == probe->bFormatIndex)
 			break;
 	}
@@ -1116,21 +1129,20 @@
 	probe->bFormatIndex = format->index;
 	probe->bFrameIndex = frame->bFrameIndex;
 
-	video->streaming->cur_format = format;
-	video->streaming->cur_frame = frame;
-	atomic_set(&video->active, 0);
+	stream->cur_format = format;
+	stream->cur_frame = frame;
 
 	/* Select the video decoding function */
-	if (video->streaming->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (video->dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT)
-			video->decode = uvc_video_decode_isight;
-		else if (video->streaming->intf->num_altsetting > 1)
-			video->decode = uvc_video_decode_isoc;
+	if (stream->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		if (stream->dev->quirks & UVC_QUIRK_BUILTIN_ISIGHT)
+			stream->decode = uvc_video_decode_isight;
+		else if (stream->intf->num_altsetting > 1)
+			stream->decode = uvc_video_decode_isoc;
 		else
-			video->decode = uvc_video_decode_bulk;
+			stream->decode = uvc_video_decode_bulk;
 	} else {
-		if (video->streaming->intf->num_altsetting == 1)
-			video->decode = uvc_video_encode_bulk;
+		if (stream->intf->num_altsetting == 1)
+			stream->decode = uvc_video_encode_bulk;
 		else {
 			uvc_printk(KERN_INFO, "Isochronous endpoints are not "
 				"supported for video output devices.\n");
@@ -1144,31 +1156,32 @@
 /*
  * Enable or disable the video stream.
  */
-int uvc_video_enable(struct uvc_video_device *video, int enable)
+int uvc_video_enable(struct uvc_streaming *stream, int enable)
 {
 	int ret;
 
 	if (!enable) {
-		uvc_uninit_video(video, 1);
-		usb_set_interface(video->dev->udev,
-			video->streaming->intfnum, 0);
-		uvc_queue_enable(&video->queue, 0);
+		uvc_uninit_video(stream, 1);
+		usb_set_interface(stream->dev->udev, stream->intfnum, 0);
+		uvc_queue_enable(&stream->queue, 0);
 		return 0;
 	}
 
-	if ((video->streaming->cur_format->flags & UVC_FMT_FLAG_COMPRESSED) ||
+	if ((stream->cur_format->flags & UVC_FMT_FLAG_COMPRESSED) ||
 	    uvc_no_drop_param)
-		video->queue.flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
+		stream->queue.flags &= ~UVC_QUEUE_DROP_INCOMPLETE;
 	else
-		video->queue.flags |= UVC_QUEUE_DROP_INCOMPLETE;
+		stream->queue.flags |= UVC_QUEUE_DROP_INCOMPLETE;
 
-	if ((ret = uvc_queue_enable(&video->queue, 1)) < 0)
+	ret = uvc_queue_enable(&stream->queue, 1);
+	if (ret < 0)
 		return ret;
 
 	/* Commit the streaming parameters. */
-	if ((ret = uvc_commit_video(video, &video->streaming->ctrl)) < 0)
+	ret = uvc_commit_video(stream, &stream->ctrl);
+	if (ret < 0)
 		return ret;
 
-	return uvc_init_video(video, GFP_KERNEL);
+	return uvc_init_video(stream, GFP_KERNEL);
 }
 
diff -r da81aafb9c5d linux/drivers/media/video/uvc/uvcvideo.h
--- a/linux/drivers/media/video/uvc/uvcvideo.h	Mon Jul 20 00:16:05 2009 +0200
+++ b/linux/drivers/media/video/uvc/uvcvideo.h	Tue Jul 21 23:54:32 2009 +0200
@@ -362,26 +362,6 @@
 	__u8 bTriggerUsage;
 };
 
-struct uvc_streaming {
-	struct list_head list;
-
-	struct usb_interface *intf;
-	int intfnum;
-	__u16 maxpsize;
-
-	struct uvc_streaming_header header;
-	enum v4l2_buf_type type;
-
-	unsigned int nformats;
-	struct uvc_format *format;
-
-	struct uvc_streaming_control ctrl;
-	struct uvc_format *cur_format;
-	struct uvc_frame *cur_frame;
-
-	struct mutex mutex;
-};
-
 enum uvc_buffer_state {
 	UVC_BUF_STATE_IDLE	= 0,
 	UVC_BUF_STATE_QUEUED	= 1,
@@ -423,26 +403,31 @@
 	struct list_head irqqueue;
 };
 
-struct uvc_video_device {
+struct uvc_streaming {
+	struct list_head list;
 	struct uvc_device *dev;
 	struct video_device *vdev;
 	atomic_t active;
+
+	struct usb_interface *intf;
+	int intfnum;
+	__u16 maxpsize;
+
+	struct uvc_streaming_header header;
+	enum v4l2_buf_type type;
+
+	unsigned int nformats;
+	struct uvc_format *format;
+
+	struct uvc_streaming_control ctrl;
+	struct uvc_format *cur_format;
+	struct uvc_frame *cur_frame;
+
+	struct mutex mutex;
+
 	unsigned int frozen : 1;
-
-	struct list_head iterms;		/* Input terminals */
-	struct uvc_entity *oterm;		/* Output terminal */
-	struct uvc_entity *sterm;		/* USB streaming terminal */
-	struct uvc_entity *processing;
-	struct uvc_entity *selector;
-	struct list_head extensions;
-	struct mutex ctrl_mutex;
-
 	struct uvc_video_queue queue;
-
-	/* Video streaming object, must always be non-NULL. */
-	struct uvc_streaming *streaming;
-
-	void (*decode) (struct urb *urb, struct uvc_video_device *video,
+	void (*decode) (struct urb *urb, struct uvc_streaming *video,
 			struct uvc_buffer *buf);
 
 	/* Context data used by the bulk completion handler. */
@@ -462,6 +447,18 @@
 	__u8 last_fid;
 };
 
+struct uvc_video_device {
+	struct uvc_device *dev;
+
+	struct list_head iterms;		/* Input terminals */
+	struct uvc_entity *oterm;		/* Output terminal */
+	struct uvc_entity *sterm;		/* USB streaming terminal */
+	struct uvc_entity *processing;
+	struct uvc_entity *selector;
+	struct list_head extensions;
+	struct mutex ctrl_mutex;
+};
+
 enum uvc_device_state {
 	UVC_DEV_DISCONNECTED = 1,
 };
@@ -487,15 +484,15 @@
 
 	struct uvc_video_device video;
 
+	/* Video Streaming interfaces */
+	struct list_head streams;
+
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
 	__u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
-
-	/* Video Streaming interfaces */
-	struct list_head streaming;
 };
 
 enum uvc_handle_state {
@@ -504,7 +501,8 @@
 };
 
 struct uvc_fh {
-	struct uvc_video_device *device;
+	struct uvc_video_device *video;
+	struct uvc_streaming *stream;
 	enum uvc_handle_state state;
 };
 
@@ -601,13 +599,13 @@
 extern const struct v4l2_file_operations uvc_fops;
 
 /* Video */
-extern int uvc_video_init(struct uvc_video_device *video);
-extern int uvc_video_suspend(struct uvc_video_device *video);
-extern int uvc_video_resume(struct uvc_video_device *video);
-extern int uvc_video_enable(struct uvc_video_device *video, int enable);
-extern int uvc_probe_video(struct uvc_video_device *video,
+extern int uvc_video_init(struct uvc_streaming *stream);
+extern int uvc_video_suspend(struct uvc_streaming *stream);
+extern int uvc_video_resume(struct uvc_streaming *stream);
+extern int uvc_video_enable(struct uvc_streaming *stream, int enable);
+extern int uvc_probe_video(struct uvc_streaming *stream,
 		struct uvc_streaming_control *probe);
-extern int uvc_commit_video(struct uvc_video_device *video,
+extern int uvc_commit_video(struct uvc_streaming *stream,
 		struct uvc_streaming_control *ctrl);
 extern int uvc_query_ctrl(struct uvc_device *dev, __u8 query, __u8 unit,
 		__u8 intfnum, __u8 cs, void *data, __u16 size);
@@ -661,7 +659,7 @@
 		struct usb_host_interface *alts, __u8 epaddr);
 
 /* Quirks support */
-void uvc_video_decode_isight(struct urb *urb, struct uvc_video_device *video,
+void uvc_video_decode_isight(struct urb *urb, struct uvc_streaming *stream,
 		struct uvc_buffer *buf);
 
 #endif /* __KERNEL__ */

