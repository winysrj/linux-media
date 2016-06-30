Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:13276 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752609AbcF3Rqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 13:46:51 -0400
From: Nick Dyer <nick@shmanahar.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com,
	jon.older@itdev.co.uk, nick.dyer@itdev.co.uk,
	Nick Dyer <nick@shmanahar.org>
Subject: [PATCH v6 11/11] Input: sur40 - use new V4L2 touch input type
Date: Thu, 30 Jun 2016 18:38:54 +0100
Message-Id: <1467308334-12580-12-git-send-email-nick@shmanahar.org>
In-Reply-To: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
References: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support both V4L2_TCH_FMT_TU08 and V4L2_PIX_FMT_GREY for backwards
compatibility.

Note: I have not tested these changes (I have no access to the hardware)
so not signing off.
---
 drivers/input/touchscreen/sur40.c | 121 +++++++++++++++++++++++++++-----------
 1 file changed, 88 insertions(+), 33 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 880c40b..9ba68cf 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -139,6 +139,27 @@ struct sur40_image_header {
 #define SUR40_GET_STATE   0xc5 /*  4 bytes state (?) */
 #define SUR40_GET_SENSORS 0xb1 /*  8 bytes sensors   */
 
+static const struct v4l2_pix_format sur40_pix_format[] = {
+	{
+		.pixelformat = V4L2_TCH_FMT_TU08,
+		.width  = SENSOR_RES_X / 2,
+		.height = SENSOR_RES_Y / 2,
+		.field = V4L2_FIELD_NONE,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.bytesperline = SENSOR_RES_X / 2,
+		.sizeimage = (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
+	},
+	{
+		.pixelformat = V4L2_PIX_FMT_GREY,
+		.width  = SENSOR_RES_X / 2,
+		.height = SENSOR_RES_Y / 2,
+		.field = V4L2_FIELD_NONE,
+		.colorspace = V4L2_COLORSPACE_SRGB,
+		.bytesperline = SENSOR_RES_X / 2,
+		.sizeimage = (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
+	}
+};
+
 /* master device state */
 struct sur40_state {
 
@@ -149,6 +170,7 @@ struct sur40_state {
 	struct v4l2_device v4l2;
 	struct video_device vdev;
 	struct mutex lock;
+	struct v4l2_pix_format pix_fmt;
 
 	struct vb2_queue queue;
 	struct vb2_alloc_ctx *alloc_ctx;
@@ -170,7 +192,6 @@ struct sur40_buffer {
 
 /* forward declarations */
 static const struct video_device sur40_video_device;
-static const struct v4l2_pix_format sur40_video_format;
 static const struct vb2_queue sur40_queue;
 static void sur40_process_video(struct sur40_state *sur40);
 
@@ -421,7 +442,7 @@ static void sur40_process_video(struct sur40_state *sur40)
 		goto err_poll;
 	}
 
-	if (le32_to_cpu(img->size) != sur40_video_format.sizeimage) {
+	if (le32_to_cpu(img->size) != sur40->pix_fmt.sizeimage) {
 		dev_err(sur40->dev, "image size mismatch\n");
 		goto err_poll;
 	}
@@ -432,7 +453,7 @@ static void sur40_process_video(struct sur40_state *sur40)
 
 	result = usb_sg_init(&sgr, sur40->usbdev,
 		usb_rcvbulkpipe(sur40->usbdev, VIDEO_ENDPOINT), 0,
-		sgt->sgl, sgt->nents, sur40_video_format.sizeimage, 0);
+		sgt->sgl, sgt->nents, sur40->pix_fmt.sizeimage, 0);
 	if (result < 0) {
 		dev_err(sur40->dev, "error %d in usb_sg_init\n", result);
 		goto err_poll;
@@ -593,13 +614,14 @@ static int sur40_probe(struct usb_interface *interface,
 		goto err_unreg_v4l2;
 	}
 
+	sur40->pix_fmt = sur40_pix_format[0];
 	sur40->vdev = sur40_video_device;
 	sur40->vdev.v4l2_dev = &sur40->v4l2;
 	sur40->vdev.lock = &sur40->lock;
 	sur40->vdev.queue = &sur40->queue;
 	video_set_drvdata(&sur40->vdev, sur40);
 
-	error = video_register_device(&sur40->vdev, VFL_TYPE_GRABBER, -1);
+	error = video_register_device(&sur40->vdev, VFL_TYPE_TOUCH, -1);
 	if (error) {
 		dev_err(&interface->dev,
 			"Unable to register video subdevice.");
@@ -662,10 +684,10 @@ static int sur40_queue_setup(struct vb2_queue *q,
 	alloc_ctxs[0] = sur40->alloc_ctx;
 
 	if (*nplanes)
-		return sizes[0] < sur40_video_format.sizeimage ? -EINVAL : 0;
+		return sizes[0] < sur40->pix_fmt.sizeimage ? -EINVAL : 0;
 
 	*nplanes = 1;
-	sizes[0] = sur40_video_format.sizeimage;
+	sizes[0] = sur40->pix_fmt.sizeimage;
 
 	return 0;
 }
@@ -677,7 +699,7 @@ static int sur40_queue_setup(struct vb2_queue *q,
 static int sur40_buffer_prepare(struct vb2_buffer *vb)
 {
 	struct sur40_state *sur40 = vb2_get_drv_priv(vb->vb2_queue);
-	unsigned long size = sur40_video_format.sizeimage;
+	unsigned long size = sur40->pix_fmt.sizeimage;
 
 	if (vb2_plane_size(vb, 0) < size) {
 		dev_err(&sur40->usbdev->dev, "buffer too small (%lu < %lu)\n",
@@ -751,7 +773,7 @@ static int sur40_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(cap->driver, DRIVER_SHORT, sizeof(cap->driver));
 	strlcpy(cap->card, DRIVER_LONG, sizeof(cap->card));
 	usb_make_path(sur40->usbdev, cap->bus_info, sizeof(cap->bus_info));
-	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TOUCH |
 		V4L2_CAP_READWRITE |
 		V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -763,7 +785,7 @@ static int sur40_vidioc_enum_input(struct file *file, void *priv,
 {
 	if (i->index != 0)
 		return -EINVAL;
-	i->type = V4L2_INPUT_TYPE_CAMERA;
+	i->type = V4L2_INPUT_TYPE_TOUCH;
 	i->std = V4L2_STD_UNKNOWN;
 	strlcpy(i->name, "In-Cell Sensor", sizeof(i->name));
 	i->capabilities = 0;
@@ -781,20 +803,57 @@ static int sur40_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 	return 0;
 }
 
-static int sur40_vidioc_fmt(struct file *file, void *priv,
+static int sur40_vidioc_try_fmt(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
-	f->fmt.pix = sur40_video_format;
+	switch (f->fmt.pix.pixelformat) {
+		case V4L2_PIX_FMT_GREY:
+			f->fmt.pix = sur40_pix_format[1];
+			break;
+
+		default:
+			f->fmt.pix = sur40_pix_format[0];
+			break;
+	}
+
+	return 0;
+}
+
+static int sur40_vidioc_s_fmt(struct file *file, void *priv,
+			    struct v4l2_format *f)
+{
+	struct sur40_state *sur40 = video_drvdata(file);
+
+	switch (f->fmt.pix.pixelformat) {
+		case V4L2_PIX_FMT_GREY:
+			sur40->pix_fmt = sur40_pix_format[1];
+			break;
+
+		default:
+			sur40->pix_fmt = sur40_pix_format[0];
+			break;
+	}
+
+	f->fmt.pix = sur40->pix_fmt;
+	return 0;
+}
+
+static int sur40_vidioc_g_fmt(struct file *file, void *priv,
+			    struct v4l2_format *f)
+{
+	struct sur40_state *sur40 = video_drvdata(file);
+
+	f->fmt.pix = sur40->pix_fmt;
 	return 0;
 }
 
 static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
 				 struct v4l2_fmtdesc *f)
 {
-	if (f->index != 0)
+	if (f->index >= ARRAY_SIZE(sur40_pix_format))
 		return -EINVAL;
-	strlcpy(f->description, "8-bit greyscale", sizeof(f->description));
-	f->pixelformat = V4L2_PIX_FMT_GREY;
+
+	f->pixelformat = sur40_pix_format[f->index].pixelformat;
 	f->flags = 0;
 	return 0;
 }
@@ -802,21 +861,27 @@ static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
 static int sur40_vidioc_enum_framesizes(struct file *file, void *priv,
 					struct v4l2_frmsizeenum *f)
 {
-	if ((f->index != 0) || (f->pixel_format != V4L2_PIX_FMT_GREY))
+	struct sur40_state *sur40 = video_drvdata(file);
+
+	if ((f->index != 0) || ((f->pixel_format != V4L2_TCH_FMT_TU08)
+		&& (f->pixel_format != V4L2_PIX_FMT_GREY)))
 		return -EINVAL;
 
 	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
-	f->discrete.width  = sur40_video_format.width;
-	f->discrete.height = sur40_video_format.height;
+	f->discrete.width  = sur40->pix_fmt.width;
+	f->discrete.height = sur40->pix_fmt.height;
 	return 0;
 }
 
 static int sur40_vidioc_enum_frameintervals(struct file *file, void *priv,
 					    struct v4l2_frmivalenum *f)
 {
-	if ((f->index > 1) || (f->pixel_format != V4L2_PIX_FMT_GREY)
-		|| (f->width  != sur40_video_format.width)
-		|| (f->height != sur40_video_format.height))
+	struct sur40_state *sur40 = video_drvdata(file);
+
+	if ((f->index > 1) || ((f->pixel_format != V4L2_TCH_FMT_TU08)
+	        && (f->pixel_format != V4L2_PIX_FMT_GREY))
+		|| (f->width  != sur40->pix_fmt.width)
+		|| (f->height != sur40->pix_fmt.height))
 			return -EINVAL;
 
 	f->type = V4L2_FRMIVAL_TYPE_DISCRETE;
@@ -873,9 +938,9 @@ static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
 	.vidioc_querycap	= sur40_vidioc_querycap,
 
 	.vidioc_enum_fmt_vid_cap = sur40_vidioc_enum_fmt,
-	.vidioc_try_fmt_vid_cap	= sur40_vidioc_fmt,
-	.vidioc_s_fmt_vid_cap	= sur40_vidioc_fmt,
-	.vidioc_g_fmt_vid_cap	= sur40_vidioc_fmt,
+	.vidioc_try_fmt_vid_cap	= sur40_vidioc_try_fmt,
+	.vidioc_s_fmt_vid_cap	= sur40_vidioc_s_fmt,
+	.vidioc_g_fmt_vid_cap	= sur40_vidioc_g_fmt,
 
 	.vidioc_enum_framesizes = sur40_vidioc_enum_framesizes,
 	.vidioc_enum_frameintervals = sur40_vidioc_enum_frameintervals,
@@ -902,16 +967,6 @@ static const struct video_device sur40_video_device = {
 	.release = video_device_release_empty,
 };
 
-static const struct v4l2_pix_format sur40_video_format = {
-	.pixelformat = V4L2_PIX_FMT_GREY,
-	.width  = SENSOR_RES_X / 2,
-	.height = SENSOR_RES_Y / 2,
-	.field = V4L2_FIELD_NONE,
-	.colorspace = V4L2_COLORSPACE_SRGB,
-	.bytesperline = SENSOR_RES_X / 2,
-	.sizeimage = (SENSOR_RES_X/2) * (SENSOR_RES_Y/2),
-};
-
 /* USB-specific object needed to register this driver with the USB subsystem. */
 static struct usb_driver sur40_driver = {
 	.name = DRIVER_SHORT,
-- 
2.5.0

