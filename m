Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:8213 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752594AbcF3Rqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 13:46:49 -0400
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
Subject: [PATCH v6 09/11] Input: atmel_mxt_ts - add support for reference data
Date: Thu, 30 Jun 2016 18:38:52 +0100
Message-Id: <1467308334-12580-10-git-send-email-nick@shmanahar.org>
In-Reply-To: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
References: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are different datatypes available from a maXTouch chip. Add
support to retrieve reference data as well.

Signed-off-by: Nick Dyer <nick@shmanahar.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 57 ++++++++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 7c4d937..f75f2ce 100644
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
 
@@ -2325,11 +2344,21 @@ static int mxt_vidioc_querycap(struct file *file, void *priv,
 static int mxt_vidioc_enum_input(struct file *file, void *priv,
 				   struct v4l2_input *i)
 {
-	if (i->index > 0)
+	if (i->index >= MXT_V4L_INPUT_MAX)
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_TOUCH;
-	strlcpy(i->name, "Mutual Capacitance Deltas", sizeof(i->name));
+
+	switch (i->index) {
+	case MXT_V4L_INPUT_REFS:
+		strlcpy(i->name, "Mutual Capacitance References",
+			sizeof(i->name));
+		break;
+	case MXT_V4L_INPUT_DELTAS:
+		strlcpy(i->name, "Mutual Capacitance Deltas", sizeof(i->name));
+		break;
+	}
+
 	return 0;
 }
 
@@ -2337,12 +2366,16 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
 {
 	struct v4l2_pix_format *f = &data->dbg.format;
 
-	if (i > 0)
+	if (i >= MXT_V4L_INPUT_MAX)
 		return -EINVAL;
 
+	if (i == MXT_V4L_INPUT_DELTAS)
+		f->pixelformat = V4L2_TCH_FMT_DELTA_TD16;
+	else
+		f->pixelformat = V4L2_TCH_FMT_TU16;
+
 	f->width = data->xy_switch ? data->ysize : data->xsize;
 	f->height = data->xy_switch ? data->xsize : data->ysize;
-	f->pixelformat = V4L2_TCH_FMT_DELTA_TD16;
 	f->field = V4L2_FIELD_NONE;
 	f->colorspace = V4L2_COLORSPACE_RAW;
 	f->bytesperline = f->width * sizeof(u16);
@@ -2383,7 +2416,19 @@ static int mxt_vidioc_enum_fmt(struct file *file, void *priv,
 	if (fmt->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	fmt->pixelformat = V4L2_TCH_FMT_DELTA_TD16;
+	switch (fmt->index) {
+	case 0:
+		fmt->pixelformat = V4L2_TCH_FMT_TU16;
+		break;
+
+	case 1:
+		fmt->pixelformat = V4L2_TCH_FMT_DELTA_TD16;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
-- 
2.5.0

