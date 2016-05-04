Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:64702 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751436AbcEDRH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2016 13:07:27 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
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
	hverkuil@xs4all.nl, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH v2 3/8] [media] v4l2-core: Add VFL_TYPE_TOUCH_SENSOR
Date: Wed,  4 May 2016 18:07:13 +0100
Message-Id: <1462381638-7818-4-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some touch controllers send out raw touch data in a similar way to a
greyscale frame grabber. Add a new device type for these devices.

Use a new device prefix v4l-touch for these devices, to stop generic
capture software from treating them as webcams.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/sur40.c    |  2 +-
 drivers/media/v4l2-core/v4l2-dev.c   | 13 ++++++++++---
 drivers/media/v4l2-core/v4l2-ioctl.c |  6 ++++--
 include/media/v4l2-dev.h             |  3 ++-
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 880c40b..7e5fe2b 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -599,7 +599,7 @@ static int sur40_probe(struct usb_interface *interface,
 	sur40->vdev.queue = &sur40->queue;
 	video_set_drvdata(&sur40->vdev, sur40);
 
-	error = video_register_device(&sur40->vdev, VFL_TYPE_GRABBER, -1);
+	error = video_register_device(&sur40->vdev, VFL_TYPE_TOUCH_SENSOR, -1);
 	if (error) {
 		dev_err(&interface->dev,
 			"Unable to register video subdevice.");
diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
index d8e5994..8d41248 100644
--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -529,6 +529,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	bool is_sdr = vdev->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vdev->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vdev->vfl_dir != VFL_DIR_RX;
+	bool is_touch = vdev->vfl_type == VFL_TYPE_TOUCH_SENSOR;
 
 	bitmap_zero(valid_ioctls, BASE_VIDIOC_PRIVATE);
 
@@ -573,7 +574,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 	if (ops->vidioc_enum_freq_bands || ops->vidioc_g_tuner || ops->vidioc_g_modulator)
 		set_bit(_IOC_NR(VIDIOC_ENUM_FREQ_BANDS), valid_ioctls);
 
-	if (is_vid) {
+	if (is_vid || is_touch) {
 		/* video specific ioctls */
 		if ((is_rx && (ops->vidioc_enum_fmt_vid_cap ||
 			       ops->vidioc_enum_fmt_vid_cap_mplane ||
@@ -662,7 +663,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 			set_bit(_IOC_NR(VIDIOC_TRY_FMT), valid_ioctls);
 	}
 
-	if (is_vid || is_vbi || is_sdr) {
+	if (is_vid || is_vbi || is_sdr || is_touch) {
 		/* ioctls valid for video, vbi or sdr */
 		SET_VALID_IOCTL(ops, VIDIOC_REQBUFS, vidioc_reqbufs);
 		SET_VALID_IOCTL(ops, VIDIOC_QUERYBUF, vidioc_querybuf);
@@ -675,7 +676,7 @@ static void determine_valid_ioctls(struct video_device *vdev)
 		SET_VALID_IOCTL(ops, VIDIOC_STREAMOFF, vidioc_streamoff);
 	}
 
-	if (is_vid || is_vbi) {
+	if (is_vid || is_vbi || is_touch) {
 		/* ioctls valid for video or vbi */
 		if (ops->vidioc_s_std)
 			set_bit(_IOC_NR(VIDIOC_ENUMSTD), valid_ioctls);
@@ -738,6 +739,7 @@ static int video_register_media_controller(struct video_device *vdev, int type)
 	vdev->entity.function = MEDIA_ENT_F_UNKNOWN;
 
 	switch (type) {
+	case VFL_TYPE_TOUCH_SENSOR:
 	case VFL_TYPE_GRABBER:
 		intf_type = MEDIA_INTF_T_V4L_VIDEO;
 		vdev->entity.function = MEDIA_ENT_F_IO_V4L;
@@ -844,6 +846,8 @@ static int video_register_media_controller(struct video_device *vdev, int type)
  *	%VFL_TYPE_SUBDEV - A subdevice
  *
  *	%VFL_TYPE_SDR - Software Defined Radio
+ *
+ *	%VFL_TYPE_TOUCH_SENSOR - A touch sensor
  */
 int __video_register_device(struct video_device *vdev, int type, int nr,
 		int warn_if_nr_in_use, struct module *owner)
@@ -887,6 +891,9 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
 		/* Use device name 'swradio' because 'sdr' was already taken. */
 		name_base = "swradio";
 		break;
+	case VFL_TYPE_TOUCH_SENSOR:
+		name_base = "v4l-touch";
+		break;
 	default:
 		printk(KERN_ERR "%s called with unknown type: %d\n",
 		       __func__, type);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index c7dabaa..4a1093a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -925,13 +925,14 @@ static int check_fmt(struct file *file, enum v4l2_buf_type type)
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
+	bool is_touch = vfd->vfl_type == VFL_TYPE_TOUCH_SENSOR;
 
 	if (ops == NULL)
 		return -EINVAL;
 
 	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (is_vid && is_rx &&
+		if ((is_vid || is_touch) && is_rx &&
 		    (ops->vidioc_g_fmt_vid_cap || ops->vidioc_g_fmt_vid_cap_mplane))
 			return 0;
 		break;
@@ -1349,6 +1350,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 	struct video_device *vfd = video_devdata(file);
 	bool is_vid = vfd->vfl_type == VFL_TYPE_GRABBER;
 	bool is_sdr = vfd->vfl_type == VFL_TYPE_SDR;
+	bool is_touch = vfd->vfl_type == VFL_TYPE_TOUCH_SENSOR;
 	bool is_rx = vfd->vfl_dir != VFL_DIR_TX;
 	bool is_tx = vfd->vfl_dir != VFL_DIR_RX;
 	int ret;
@@ -1379,7 +1381,7 @@ static int v4l_g_fmt(const struct v4l2_ioctl_ops *ops,
 
 	switch (p->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
-		if (unlikely(!is_rx || !is_vid || !ops->vidioc_g_fmt_vid_cap))
+		if (unlikely(!is_rx || (!is_vid && !is_touch) || !ops->vidioc_g_fmt_vid_cap))
 			break;
 		p->fmt.pix.priv = V4L2_PIX_FMT_PRIV_MAGIC;
 		ret = ops->vidioc_g_fmt_vid_cap(file, fh, arg);
diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
index eeabf20..8a4e446 100644
--- a/include/media/v4l2-dev.h
+++ b/include/media/v4l2-dev.h
@@ -25,7 +25,8 @@
 #define VFL_TYPE_RADIO		2
 #define VFL_TYPE_SUBDEV		3
 #define VFL_TYPE_SDR		4
-#define VFL_TYPE_MAX		5
+#define VFL_TYPE_TOUCH_SENSOR	5
+#define VFL_TYPE_MAX		6
 
 /* Is this a receiver, transmitter or mem-to-mem? */
 /* Ignored for VFL_TYPE_SUBDEV. */
-- 
2.5.0

