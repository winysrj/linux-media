Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:32893 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751583AbcDUJl1 (ORCPT
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
Subject: [PATCH 3/8] Input: atmel_mxt_ts - read touchscreen size
Date: Thu, 21 Apr 2016 10:31:36 +0100
Message-Id: <1461231101-1237-4-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The touchscreen may have a margin where not all the matrix is used. Read
the parameters from T9 and T100 and take account of the difference.

Note: this does not read the XORIGIN/YORIGIN fields so it assumes that
the touchscreen starts at (0,0)

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 47 ++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 81eecf1..bcace51 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -103,6 +103,8 @@ struct t7_config {
 
 /* MXT_TOUCH_MULTI_T9 field */
 #define MXT_T9_CTRL		0
+#define MXT_T9_XSIZE		3
+#define MXT_T9_YSIZE		4
 #define MXT_T9_ORIENT		9
 #define MXT_T9_RANGE		18
 
@@ -148,7 +150,9 @@ struct t37_debug {
 #define MXT_T100_CTRL		0
 #define MXT_T100_CFG1		1
 #define MXT_T100_TCHAUX		3
+#define MXT_T100_XSIZE		9
 #define MXT_T100_XRANGE		13
+#define MXT_T100_YSIZE		20
 #define MXT_T100_YRANGE		24
 
 #define MXT_T100_CFG_SWITCHXY	BIT(5)
@@ -257,6 +261,8 @@ struct mxt_data {
 	unsigned int max_x;
 	unsigned int max_y;
 	bool xy_switch;
+	u8 xsize;
+	u8 ysize;
 	bool in_bootloader;
 	u16 mem_size;
 	u8 t100_aux_ampl;
@@ -1710,6 +1716,18 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 		return -EINVAL;
 
 	error = __mxt_read_reg(client,
+			       object->start_address + MXT_T9_XSIZE,
+			       sizeof(data->xsize), &data->xsize);
+	if (error)
+		return error;
+
+	error = __mxt_read_reg(client,
+			       object->start_address + MXT_T9_YSIZE,
+			       sizeof(data->ysize), &data->ysize);
+	if (error)
+		return error;
+
+	error = __mxt_read_reg(client,
 			       object->start_address + MXT_T9_RANGE,
 			       sizeof(range), &range);
 	if (error)
@@ -1759,6 +1777,18 @@ static int mxt_read_t100_config(struct mxt_data *data)
 
 	data->max_y = get_unaligned_le16(&range_y);
 
+	error = __mxt_read_reg(client,
+			       object->start_address + MXT_T100_XSIZE,
+			       sizeof(data->xsize), &data->xsize);
+	if (error)
+		return error;
+
+	error = __mxt_read_reg(client,
+			       object->start_address + MXT_T100_YSIZE,
+			       sizeof(data->ysize), &data->ysize);
+	if (error)
+		return error;
+
 	/* read orientation config */
 	error =  __mxt_read_reg(client,
 				object->start_address + MXT_T100_CFG1,
@@ -2116,7 +2146,7 @@ static int mxt_convert_debug_pages(struct mxt_data *data, u16 *outbuf)
 		outbuf[i] = mxt_get_debug_value(data, x, y);
 
 		/* Next value */
-		if (++x >= data->info.matrix_xsize) {
+		if (++x >= data->xsize) {
 			x = 0;
 			y++;
 		}
@@ -2280,8 +2310,8 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
 	if (i > 0)
 		return -EINVAL;
 
-	f->width = data->info.matrix_xsize;
-	f->height = data->info.matrix_ysize;
+	f->width = data->xsize;
+	f->height = data->ysize;
 	f->pixelformat = V4L2_PIX_FMT_Y16;
 	f->field = V4L2_FIELD_NONE;
 	f->colorspace = V4L2_COLORSPACE_SRGB;
@@ -2337,8 +2367,8 @@ static int mxt_vidioc_enum_framesizes(struct file *file, void *priv,
 	if (f->index > 0)
 		return -EINVAL;
 
-	f->discrete.width = data->info.matrix_xsize;
-	f->discrete.height = data->info.matrix_ysize;
+	f->discrete.width = data->xsize;
+	f->discrete.height = data->ysize;
 	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
 	return 0;
 }
@@ -2411,9 +2441,10 @@ static void mxt_debug_init(struct mxt_data *data)
 	dbg->t37_address = object->start_address;
 
 	/* Calculate size of data and allocate buffer */
-	dbg->t37_nodes = data->info.matrix_xsize * data->info.matrix_ysize;
-	dbg->t37_pages = dbg->t37_nodes * sizeof(u16)
-					/ sizeof(dbg->t37_buf->data) + 1;
+	dbg->t37_nodes = data->xsize * data->ysize;
+	dbg->t37_pages = ((data->xsize * data->info.matrix_ysize)
+			  * sizeof(u16) / sizeof(dbg->t37_buf->data)) + 1;
+
 
 	dbg->t37_buf = devm_kzalloc(&data->client->dev,
 				     sizeof(struct t37_debug) * dbg->t37_pages,
-- 
2.5.0

