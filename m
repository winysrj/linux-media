Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:34360 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750997AbcFVWI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 18:08:57 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
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
	nick.dyer@itdev.co.uk
Subject: [PATCH v5 9/9] Input: sur40 - use new V4L2 touch input type
Date: Wed, 22 Jun 2016 23:08:33 +0100
Message-Id: <1466633313-15339-10-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1466633313-15339-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/sur40.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
index 880c40b..841e045 100644
--- a/drivers/input/touchscreen/sur40.c
+++ b/drivers/input/touchscreen/sur40.c
@@ -599,7 +599,7 @@ static int sur40_probe(struct usb_interface *interface,
 	sur40->vdev.queue = &sur40->queue;
 	video_set_drvdata(&sur40->vdev, sur40);
 
-	error = video_register_device(&sur40->vdev, VFL_TYPE_GRABBER, -1);
+	error = video_register_device(&sur40->vdev, VFL_TYPE_TOUCH, -1);
 	if (error) {
 		dev_err(&interface->dev,
 			"Unable to register video subdevice.");
@@ -763,7 +763,7 @@ static int sur40_vidioc_enum_input(struct file *file, void *priv,
 {
 	if (i->index != 0)
 		return -EINVAL;
-	i->type = V4L2_INPUT_TYPE_CAMERA;
+	i->type = V4L2_INPUT_TYPE_TOUCH;
 	i->std = V4L2_STD_UNKNOWN;
 	strlcpy(i->name, "In-Cell Sensor", sizeof(i->name));
 	i->capabilities = 0;
@@ -794,7 +794,7 @@ static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
 	if (f->index != 0)
 		return -EINVAL;
 	strlcpy(f->description, "8-bit greyscale", sizeof(f->description));
-	f->pixelformat = V4L2_PIX_FMT_GREY;
+	f->pixelformat = V4L2_TCH_FMT_TU08;
 	f->flags = 0;
 	return 0;
 }
@@ -802,7 +802,7 @@ static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
 static int sur40_vidioc_enum_framesizes(struct file *file, void *priv,
 					struct v4l2_frmsizeenum *f)
 {
-	if ((f->index != 0) || (f->pixel_format != V4L2_PIX_FMT_GREY))
+	if ((f->index != 0) || (f->pixel_format != V4L2_TCH_FMT_TU08))
 		return -EINVAL;
 
 	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
@@ -814,7 +814,7 @@ static int sur40_vidioc_enum_framesizes(struct file *file, void *priv,
 static int sur40_vidioc_enum_frameintervals(struct file *file, void *priv,
 					    struct v4l2_frmivalenum *f)
 {
-	if ((f->index > 1) || (f->pixel_format != V4L2_PIX_FMT_GREY)
+	if ((f->index > 1) || (f->pixel_format != V4L2_TCH_FMT_TU08)
 		|| (f->width  != sur40_video_format.width)
 		|| (f->height != sur40_video_format.height))
 			return -EINVAL;
@@ -903,7 +903,7 @@ static const struct video_device sur40_video_device = {
 };
 
 static const struct v4l2_pix_format sur40_video_format = {
-	.pixelformat = V4L2_PIX_FMT_GREY,
+	.pixelformat = V4L2_TCH_FMT_TU08,
 	.width  = SENSOR_RES_X / 2,
 	.height = SENSOR_RES_Y / 2,
 	.field = V4L2_FIELD_NONE,
-- 
2.5.0

