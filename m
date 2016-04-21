Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:46240 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751571AbcDUJl3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 05:41:29 -0400
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
	Florian Echtler <floe@butterbrot.org>,
	Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 8/8] Input: atmel_mxt_ts - add v4l pixelformat definition for touch refs output
Date: Thu, 21 Apr 2016 10:31:41 +0100
Message-Id: <1461231101-1237-9-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/input/touchscreen/atmel_mxt_ts.c | 33 ++++++++++++++++++++++++--------
 include/uapi/linux/videodev2.h           |  1 +
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 3bb1179..94ed8bd 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2396,21 +2396,24 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
 	if (i >= MXT_V4L_INPUT_MAX)
 		return -EINVAL;
 
+	f->pixelformat = V4L2_PIX_FMT_Y16;
+
 	switch (i) {
-	case MXT_V4L_INPUT_REFS:
 	case MXT_V4L_INPUT_DELTAS:
+		f->pixelformat = V4L2_PIX_FMT_YS16; /* fall-through */
+	case MXT_V4L_INPUT_REFS:
 		f->width = data->xy_switch ? data->ysize : data->xsize;
 		f->height = data->xy_switch ? data->xsize : data->ysize;
 		break;
 
-	case MXT_V4L_INPUT_REFS_SINGLE:
 	case MXT_V4L_INPUT_DELTAS_SINGLE:
+		f->pixelformat = V4L2_PIX_FMT_YS16; /* fall-through */
+	case MXT_V4L_INPUT_REFS_SINGLE:
 		f->width = 1;
 		f->height = 1;
 		break;
 	}
 
-	f->pixelformat = V4L2_PIX_FMT_Y16;
 	f->field = V4L2_FIELD_NONE;
 	f->colorspace = V4L2_COLORSPACE_SRGB;
 	f->bytesperline = f->width * sizeof(u16);
@@ -2447,12 +2450,26 @@ static int mxt_vidioc_fmt(struct file *file, void *priv, struct v4l2_format *f)
 static int mxt_vidioc_enum_fmt(struct file *file, void *priv,
 				 struct v4l2_fmtdesc *fmt)
 {
-	if (fmt->index > 0 || fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	fmt->pixelformat = V4L2_PIX_FMT_Y16;
-	strlcpy(fmt->description, "16-bit raw debug data",
-		sizeof(fmt->description));
+	switch (fmt->index) {
+	case 0:
+		fmt->pixelformat = V4L2_PIX_FMT_Y16;
+		strlcpy(fmt->description, "16-bit unsigned raw debug data",
+			sizeof(fmt->description));
+		break;
+
+	case 1:
+		fmt->pixelformat = V4L2_PIX_FMT_YS16;
+		strlcpy(fmt->description, "16-bit signed raw debug data",
+			sizeof(fmt->description));
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
 	fmt->flags = 0;
 	return 0;
 }
@@ -2484,7 +2501,7 @@ static int mxt_vidioc_enum_framesizes(struct file *file, void *priv,
 static int mxt_vidioc_enum_frameintervals(struct file *file, void *priv,
 					  struct v4l2_frmivalenum *f)
 {
-	if ((f->index > 0) || (f->pixel_format != V4L2_PIX_FMT_Y16))
+	if (f->index > 0)
 		return -EINVAL;
 
 	f->type = V4L2_FRMIVAL_TYPE_DISCRETE;
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 14cd5eb..ab577dd 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -496,6 +496,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_Y12     v4l2_fourcc('Y', '1', '2', ' ') /* 12  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 #define V4L2_PIX_FMT_Y16_BE  v4l2_fourcc_be('Y', '1', '6', ' ') /* 16  Greyscale BE  */
+#define V4L2_PIX_FMT_YS16    v4l2_fourcc('Y', 'S', '1', '6') /* signed 16-bit Greyscale */
 
 /* Grey bit-packed formats */
 #define V4L2_PIX_FMT_Y10BPACK    v4l2_fourcc('Y', '1', '0', 'B') /* 10  Greyscale bit-packed */
-- 
2.5.0

