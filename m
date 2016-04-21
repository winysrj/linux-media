Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:24003 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751584AbcDUJl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 05:41:27 -0400
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
Subject: [PATCH 6/8] Input: atmel_mxt_ts - add support for reference data
Date: Thu, 21 Apr 2016 10:31:39 +0100
Message-Id: <1461231101-1237-7-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are different datatypes available from a maXTouch chip. Add
support to retrieve reference data as well.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 36 ++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index bac0aa0..6a35d94 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -135,6 +135,7 @@ struct t9_range {
 /* MXT_DEBUG_DIAGNOSTIC_T37 */
 #define MXT_DIAGNOSTIC_PAGEUP 0x01
 #define MXT_DIAGNOSTIC_DELTAS 0x10
+#define MXT_DIAGNOSTIC_REFS   0x11
 #define MXT_DIAGNOSTIC_SIZE    128
 
 #define MXT_FAMILY_1386			160
@@ -247,6 +248,12 @@ struct mxt_dbg {
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
@@ -2270,6 +2277,7 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
 	struct mxt_data *data = vb2_get_drv_priv(vb->vb2_queue);
 	u16 *ptr;
 	int ret;
+	u8 mode;
 
 	ptr = vb2_plane_vaddr(vb, 0);
 	if (!ptr) {
@@ -2277,7 +2285,18 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
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
 
@@ -2327,13 +2346,22 @@ static int mxt_vidioc_querycap(struct file *file, void *priv,
 static int mxt_vidioc_enum_input(struct file *file, void *priv,
 				   struct v4l2_input *i)
 {
-	if (i->index > 0)
+	if (i->index >= MXT_V4L_INPUT_MAX)
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	i->std = V4L2_STD_UNKNOWN;
 	i->capabilities = 0;
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
 
@@ -2341,7 +2369,7 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
 {
 	struct v4l2_pix_format *f = &data->dbg.format;
 
-	if (i > 0)
+	if (i >= MXT_V4L_INPUT_MAX)
 		return -EINVAL;
 
 	f->width = data->xy_switch ? data->ysize : data->xsize;
-- 
2.5.0

