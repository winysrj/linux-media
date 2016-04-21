Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:21466 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619AbcDUJl3 (ORCPT
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
Subject: [PATCH 7/8] Input: atmel_mxt_ts - single node diagnostic data support
Date: Thu, 21 Apr 2016 10:31:40 +0100
Message-Id: <1461231101-1237-8-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for retrieving a single node of data at high rate.
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 79 ++++++++++++++++++++++++++++----
 1 file changed, 70 insertions(+), 9 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 6a35d94..3bb1179 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -239,6 +239,7 @@ struct mxt_dbg {
 	struct t37_debug *t37_buf;
 	unsigned int t37_pages;
 	unsigned int t37_nodes;
+	unsigned int single_node_ofs;
 
 	struct v4l2_device v4l2;
 	struct v4l2_pix_format format;
@@ -251,6 +252,8 @@ struct mxt_dbg {
 enum v4l_dbg_inputs {
 	MXT_V4L_INPUT_DELTAS,
 	MXT_V4L_INPUT_REFS,
+	MXT_V4L_INPUT_DELTAS_SINGLE,
+	MXT_V4L_INPUT_REFS_SINGLE,
 	MXT_V4L_INPUT_MAX,
 };
 
@@ -2197,17 +2200,19 @@ static int mxt_convert_debug_pages(struct mxt_data *data, u16 *outbuf)
 }
 
 static int mxt_read_diagnostic_debug(struct mxt_data *data, u8 mode,
-				     u16 *outbuf)
+				     u16 *outbuf, bool single_node)
 {
 	struct mxt_dbg *dbg = &data->dbg;
 	int retries = 0;
 	int page;
+	int pages = single_node ? 1 : dbg->t37_pages;
 	int ret;
 	u8 cmd = mode;
 	struct t37_debug *p;
 	u8 cmd_poll;
 
-	for (page = 0; page < dbg->t37_pages; page++) {
+
+	for (page = 0; page < pages; page++) {
 		p = dbg->t37_buf + page;
 
 		ret = mxt_write_reg(data->client, dbg->diag_cmd_address,
@@ -2251,7 +2256,15 @@ wait_cmd:
 		cmd = MXT_DIAGNOSTIC_PAGEUP;
 	}
 
-	return mxt_convert_debug_pages(data, outbuf);
+	if (single_node) {
+		*outbuf = get_unaligned_le16(&dbg->t37_buf[0]
+					     .data[dbg->single_node_ofs]);
+		ret = 0;
+	} else {
+		ret = mxt_convert_debug_pages(data, outbuf);
+	}
+
+	return ret;
 }
 
 static int mxt_queue_setup(struct vb2_queue *q,
@@ -2278,6 +2291,7 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
 	u16 *ptr;
 	int ret;
 	u8 mode;
+	bool single_node = false;
 
 	ptr = vb2_plane_vaddr(vb, 0);
 	if (!ptr) {
@@ -2286,17 +2300,21 @@ static void mxt_buffer_queue(struct vb2_buffer *vb)
 	}
 
 	switch (data->dbg.input) {
+	case MXT_V4L_INPUT_DELTAS_SINGLE:
+		single_node = true; /* fall through */
 	case MXT_V4L_INPUT_DELTAS:
 	default:
 		mode = MXT_DIAGNOSTIC_DELTAS;
 		break;
 
+	case MXT_V4L_INPUT_REFS_SINGLE:
+		single_node = true; /* fall through */
 	case MXT_V4L_INPUT_REFS:
 		mode = MXT_DIAGNOSTIC_REFS;
 		break;
 	}
 
-	ret = mxt_read_diagnostic_debug(data, mode, ptr);
+	ret = mxt_read_diagnostic_debug(data, mode, ptr, single_node);
 	if (ret)
 		goto fault;
 
@@ -2360,6 +2378,12 @@ static int mxt_vidioc_enum_input(struct file *file, void *priv,
 	case MXT_V4L_INPUT_DELTAS:
 		strlcpy(i->name, "Mutual Deltas", sizeof(i->name));
 		break;
+	case MXT_V4L_INPUT_REFS_SINGLE:
+		strlcpy(i->name, "Single node refs", sizeof(i->name));
+		break;
+	case MXT_V4L_INPUT_DELTAS_SINGLE:
+		strlcpy(i->name, "Single node deltas", sizeof(i->name));
+		break;
 	}
 
 	return 0;
@@ -2372,8 +2396,20 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
 	if (i >= MXT_V4L_INPUT_MAX)
 		return -EINVAL;
 
-	f->width = data->xy_switch ? data->ysize : data->xsize;
-	f->height = data->xy_switch ? data->xsize : data->ysize;
+	switch (i) {
+	case MXT_V4L_INPUT_REFS:
+	case MXT_V4L_INPUT_DELTAS:
+		f->width = data->xy_switch ? data->ysize : data->xsize;
+		f->height = data->xy_switch ? data->xsize : data->ysize;
+		break;
+
+	case MXT_V4L_INPUT_REFS_SINGLE:
+	case MXT_V4L_INPUT_DELTAS_SINGLE:
+		f->width = 1;
+		f->height = 1;
+		break;
+	}
+
 	f->pixelformat = V4L2_PIX_FMT_Y16;
 	f->field = V4L2_FIELD_NONE;
 	f->colorspace = V4L2_COLORSPACE_SRGB;
@@ -2426,11 +2462,21 @@ static int mxt_vidioc_enum_framesizes(struct file *file, void *priv,
 {
 	struct mxt_data *data = video_drvdata(file);
 
-	if (f->index > 0)
+	switch (f->index) {
+	case 0:
+		f->discrete.width = data->xy_switch ? data->ysize:data->xsize;
+		f->discrete.height = data->xy_switch ? data->xsize:data->ysize;
+		break;
+
+	case 1:
+		f->discrete.width = 1;
+		f->discrete.height = 1;
+		break;
+
+	default:
 		return -EINVAL;
+	}
 
-	f->discrete.width = data->xy_switch ? data->ysize : data->xsize;
-	f->discrete.height = data->xy_switch ? data->xsize : data->ysize;
 	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
 	return 0;
 }
@@ -2479,6 +2525,19 @@ static const struct video_device mxt_video_device = {
 	.release = video_device_release_empty,
 };
 
+static void mxt_debugfs_calc_single_node_ofs(struct mxt_data *data)
+{
+	struct mxt_info *info = &data->info;
+	int ofs = data->ysize / 2;
+
+	while ((ofs + info->matrix_ysize) <= (MXT_DIAGNOSTIC_SIZE/sizeof(u16)))
+		ofs += info->matrix_ysize;
+
+	dev_dbg(&data->client->dev, "Single node ofs: %d\n", ofs);
+
+	data->dbg.single_node_ofs = ofs;
+}
+
 static void mxt_debug_init(struct mxt_data *data)
 {
 	struct mxt_info *info = &data->info;
@@ -2519,6 +2578,8 @@ static void mxt_debug_init(struct mxt_data *data)
 	if (!dbg->t37_buf)
 		goto error;
 
+	mxt_debugfs_calc_single_node_ofs(data);
+
 	/* init channel to zero */
 	mxt_set_input(data, 0);
 
-- 
2.5.0

