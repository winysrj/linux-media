Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:2564 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752524AbcFQOQk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 10:16:40 -0400
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
	Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH v4 8/9] Input: atmel_mxt_ts - add support for reference data
Date: Fri, 17 Jun 2016 15:16:27 +0100
Message-Id: <1466172988-3698-9-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1466172988-3698-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are different datatypes available from a maXTouch chip. Add
support to retrieve reference data as well.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 58 ++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 5281325d..bb01fb0 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -135,6 +135,7 @@ struct t9_range {
 /* MXT_DEBUG_DIAGNOSTIC_T37 */
 #define MXT_DIAGNOSTIC_PAGEUP	0x01
 #define MXT_DIAGNOSTIC_DELTAS	0x10
+#define MXT_DIAGNOSTIC_REFS	0x11
 #define MXT_DIAGNOSTIC_SIZE	128
 
 #define MXT_FAMILY_1386			160
@@ -249,6 +250,12 @@ struct mxt_dbg {
 	int input;
 };
 
+enum v4l_dbg_inputs {
+	MXT_V4L_INPUT_DELTAS,
+	MXT_V4L_INPUT_REFS,
+	MXT_V4L_INPUT_MAX,
+};
+
 static const struct v4l2_file_operations mxt_video_fops = {
 	.owner = THIS_MODULE,
 	.open = v4l2_fh_open,
@@ -2273,6 +2280,7 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
 	struct mxt_data *data = vb2_get_drv_priv(vb->vb2_queue);
 	u16 *ptr;
 	int ret;
+	u8 mode;
 
 	ptr = vb2_plane_vaddr(vb, 0);
 	if (!ptr) {
@@ -2280,7 +2288,18 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
 		goto fault;
 	}
 
-	ret = mxt_read_diagnostic_debug(data, MXT_DIAGNOSTIC_DELTAS, ptr);
+	switch (data->dbg.input) {
+	case MXT_V4L_INPUT_DELTAS:
+	default:
+		mode = MXT_DIAGNOSTIC_DELTAS;
+		break;
+
+	case MXT_V4L_INPUT_REFS:
+		mode = MXT_DIAGNOSTIC_REFS;
+		break;
+	}
+
+	ret = mxt_read_diagnostic_debug(data, mode, ptr);
 	if (ret)
 		goto fault;
 
@@ -2325,11 +2344,20 @@ static int mxt_vidioc_querycap(struct file *file, void *priv,
 static int mxt_vidioc_enum_input(struct file *file, void *priv,
 				   struct v4l2_input *i)
 {
-	if (i->index > 0)
+	if (i->index >= MXT_V4L_INPUT_MAX)
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_TOUCH_SENSOR;
-	strlcpy(i->name, "Mutual References", sizeof(i->name));
+
+	switch (i->index) {
+	case MXT_V4L_INPUT_REFS:
+		strlcpy(i->name, "Mutual References", sizeof(i->name));
+		break;
+	case MXT_V4L_INPUT_DELTAS:
+		strlcpy(i->name, "Mutual Deltas", sizeof(i->name));
+		break;
+	}
+
 	return 0;
 }
 
@@ -2337,12 +2365,16 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
 {
 	struct v4l2_pix_format *f = &data->dbg.format;
 
-	if (i > 0)
+	if (i >= MXT_V4L_INPUT_MAX)
 		return -EINVAL;
 
+	if (i == MXT_V4L_INPUT_DELTAS)
+		f->pixelformat = V4L2_PIX_FMT_YS16;
+	else
+		f->pixelformat = V4L2_PIX_FMT_Y16;
+
 	f->width = data->xy_switch ? data->ysize : data->xsize;
 	f->height = data->xy_switch ? data->xsize : data->ysize;
-	f->pixelformat = V4L2_PIX_FMT_YS16;
 	f->field = V4L2_FIELD_NONE;
 	f->colorspace = V4L2_COLORSPACE_RAW;
 	f->bytesperline = f->width * sizeof(u16);
@@ -2380,10 +2412,22 @@ static int mxt_vidioc_fmt(struct file *file, void *priv, struct v4l2_format *f)
 static int mxt_vidioc_enum_fmt(struct file *file, void *priv,
 				 struct v4l2_fmtdesc *fmt)
 {
-	if (fmt->index > 0 || fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (fmt->index) {
+	case 0:
+		fmt->pixelformat = V4L2_PIX_FMT_Y16;
+		break;
+
+	case 1:
+		fmt->pixelformat = V4L2_PIX_FMT_YS16;
+		break;
+
+	default:
 		return -EINVAL;
+	}
 
-	fmt->pixelformat = V4L2_PIX_FMT_YS16;
 	return 0;
 }
 
-- 
2.5.0

