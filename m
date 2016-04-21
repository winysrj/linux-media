Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:57909 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751614AbcDUJl1 (ORCPT
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
Subject: [PATCH 4/8] Input: atmel_mxt_ts - handle diagnostic data orientation
Date: Thu, 21 Apr 2016 10:31:37 +0100
Message-Id: <1461231101-1237-5-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1461231101-1237-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Invert the diagnostic data to match the orientation of the input device.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index bcace51..3dd312f 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -125,6 +125,8 @@ struct t9_range {
 
 /* MXT_TOUCH_MULTI_T9 orient */
 #define MXT_T9_ORIENT_SWITCH	(1 << 0)
+#define MXT_T9_ORIENT_INVERTX	(1 << 1)
+#define MXT_T9_ORIENT_INVERTY	(1 << 2)
 
 /* MXT_SPT_COMMSCONFIG_T18 */
 #define MXT_COMMS_CTRL		0
@@ -156,6 +158,8 @@ struct t37_debug {
 #define MXT_T100_YRANGE		24
 
 #define MXT_T100_CFG_SWITCHXY	BIT(5)
+#define MXT_T100_CFG_INVERTY	BIT(6)
+#define MXT_T100_CFG_INVERTX	BIT(7)
 
 #define MXT_T100_TCHAUX_VECT	BIT(0)
 #define MXT_T100_TCHAUX_AMPL	BIT(1)
@@ -260,6 +264,8 @@ struct mxt_data {
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
+	bool invertx;
+	bool inverty;
 	bool xy_switch;
 	u8 xsize;
 	u8 ysize;
@@ -1743,6 +1749,8 @@ static int mxt_read_t9_resolution(struct mxt_data *data)
 		return error;
 
 	data->xy_switch = orient & MXT_T9_ORIENT_SWITCH;
+	data->invertx = orient & MXT_T9_ORIENT_INVERTX;
+	data->inverty = orient & MXT_T9_ORIENT_INVERTY;
 
 	return 0;
 }
@@ -1797,6 +1805,8 @@ static int mxt_read_t100_config(struct mxt_data *data)
 		return error;
 
 	data->xy_switch = cfg & MXT_T100_CFG_SWITCHXY;
+	data->invertx = cfg & MXT_T100_CFG_INVERTX;
+	data->inverty = cfg & MXT_T100_CFG_INVERTY;
 
 	/* allocate aux bytes */
 	error =  __mxt_read_reg(client,
@@ -2140,13 +2150,19 @@ static int mxt_convert_debug_pages(struct mxt_data *data, u16 *outbuf)
 	struct mxt_dbg *dbg = &data->dbg;
 	unsigned int x = 0;
 	unsigned int y = 0;
-	unsigned int i;
+	unsigned int i, rx, ry;
 
 	for (i = 0; i < dbg->t37_nodes; i++) {
-		outbuf[i] = mxt_get_debug_value(data, x, y);
+		/* Handle orientation */
+		rx = data->xy_switch ? y : x;
+		ry = data->xy_switch ? x : y;
+		rx = data->invertx ? (data->xsize - 1 - rx) : rx;
+		ry = data->inverty ? (data->ysize - 1 - ry) : ry;
+
+		outbuf[i] = mxt_get_debug_value(data, rx, ry);
 
 		/* Next value */
-		if (++x >= data->xsize) {
+		if (++x >= (data->xy_switch ? data->ysize : data->xsize)) {
 			x = 0;
 			y++;
 		}
@@ -2310,8 +2326,8 @@ static int mxt_set_input(struct mxt_data *data, unsigned int i)
 	if (i > 0)
 		return -EINVAL;
 
-	f->width = data->xsize;
-	f->height = data->ysize;
+	f->width = data->xy_switch ? data->ysize : data->xsize;
+	f->height = data->xy_switch ? data->xsize : data->ysize;
 	f->pixelformat = V4L2_PIX_FMT_Y16;
 	f->field = V4L2_FIELD_NONE;
 	f->colorspace = V4L2_COLORSPACE_SRGB;
@@ -2367,8 +2383,8 @@ static int mxt_vidioc_enum_framesizes(struct file *file, void *priv,
 	if (f->index > 0)
 		return -EINVAL;
 
-	f->discrete.width = data->xsize;
-	f->discrete.height = data->ysize;
+	f->discrete.width = data->xy_switch ? data->ysize : data->xsize;
+	f->discrete.height = data->xy_switch ? data->xsize : data->ysize;
 	f->type = V4L2_FRMSIZE_TYPE_DISCRETE;
 	return 0;
 }
-- 
2.5.0

