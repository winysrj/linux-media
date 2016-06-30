Return-path: <linux-media-owner@vger.kernel.org>
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:44131 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752617AbcF3Rqw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2016 13:46:52 -0400
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
Subject: [PATCH v6 08/11] Input: atmel_mxt_ts - add diagnostic data support for mXT1386
Date: Thu, 30 Jun 2016 18:38:51 +0100
Message-Id: <1467308334-12580-9-git-send-email-nick@shmanahar.org>
In-Reply-To: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
References: <1467308334-12580-1-git-send-email-nick@shmanahar.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The mXT1386 family of chips have a different architecture which splits
the diagnostic data into 3 columns.

Signed-off-by: Nick Dyer <nick@shmanahar.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c35fca0..7c4d937 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -137,6 +137,10 @@ struct t9_range {
 #define MXT_DIAGNOSTIC_DELTAS	0x10
 #define MXT_DIAGNOSTIC_SIZE	128
 
+#define MXT_FAMILY_1386			160
+#define MXT1386_COLUMNS			3
+#define MXT1386_PAGES_PER_COLUMN	8
+
 struct t37_debug {
 #ifdef CONFIG_TOUCHSCREEN_ATMEL_MXT_T37
 	u8 mode;
@@ -2140,13 +2144,27 @@ recheck:
 static u16 mxt_get_debug_value(struct mxt_data *data, unsigned int x,
 			       unsigned int y)
 {
+	struct mxt_info *info = &data->info;
 	struct mxt_dbg *dbg = &data->dbg;
 	unsigned int ofs, page;
+	unsigned int col = 0;
+	unsigned int col_width;
+
+	if (info->family_id == MXT_FAMILY_1386) {
+		col_width = info->matrix_ysize / MXT1386_COLUMNS;
+		col = y / col_width;
+		y = y % col_width;
+	} else {
+		col_width = info->matrix_ysize;
+	}
 
-	ofs = (y + (x * data->info.matrix_ysize)) * sizeof(u16);
+	ofs = (y + (x * col_width)) * sizeof(u16);
 	page = ofs / MXT_DIAGNOSTIC_SIZE;
 	ofs %= MXT_DIAGNOSTIC_SIZE;
 
+	if (info->family_id == MXT_FAMILY_1386)
+		page += col * MXT1386_PAGES_PER_COLUMN;
+
 	return get_unaligned_le16(&dbg->t37_buf[page].data[ofs]);
 }
 
@@ -2416,6 +2434,7 @@ static const struct video_device mxt_video_device = {
 
 static void mxt_debug_init(struct mxt_data *data)
 {
+	struct mxt_info *info = &data->info;
 	struct mxt_dbg *dbg = &data->dbg;
 	struct mxt_object *object;
 	int error;
@@ -2439,8 +2458,14 @@ static void mxt_debug_init(struct mxt_data *data)
 
 	/* Calculate size of data and allocate buffer */
 	dbg->t37_nodes = data->xsize * data->ysize;
-	dbg->t37_pages = DIV_ROUND_UP(data->xsize * data->info.matrix_ysize *
-				      sizeof(u16), sizeof(dbg->t37_buf->data));
+
+	if (info->family_id == MXT_FAMILY_1386)
+		dbg->t37_pages = MXT1386_COLUMNS * MXT1386_PAGES_PER_COLUMN;
+	else
+		dbg->t37_pages = DIV_ROUND_UP(data->xsize *
+					      data->info.matrix_ysize *
+					      sizeof(u16),
+					      sizeof(dbg->t37_buf->data));
 
 	dbg->t37_buf = devm_kmalloc_array(&data->client->dev, dbg->t37_pages,
 					  sizeof(struct t37_debug), GFP_KERNEL);
-- 
2.5.0

