Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:55196 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932264AbeEWKFo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 May 2018 06:05:44 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v3 5/7] media: imx274: simplify imx274_write_table()
Date: Wed, 23 May 2018 12:05:18 +0200
Message-Id: <1527069921-21084-6-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1527069921-21084-1-git-send-email-luca@lucaceresoli.net>
References: <1527069921-21084-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

imx274_write_table() is a mere wrapper (and the only user) to
imx274_regmap_util_write_table_8(). Remove this useless indirection by
merging the two functions into one.

Also get rid of the wait_ms_addr and end_addr parameters since it does
not make any sense to give them any values other than
IMX274_TABLE_WAIT_MS and IMX274_TABLE_END.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>

---
Changed v2 -> v3: nothing

Changed v1 -> v2:
 - add "media: " prefix to commit message
---
 drivers/media/i2c/imx274.c | 28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index ceeec97cd330..48343c2ade83 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -597,20 +597,18 @@ static inline struct stimx274 *to_imx274(struct v4l2_subdev *sd)
 }
 
 /*
- * imx274_regmap_util_write_table_8 - Function for writing register table
- * @regmap: Pointer to device reg map structure
- * @table: Table containing register values
- * @wait_ms_addr: Flag for performing delay
- * @end_addr: Flag for incating end of table
+ * Writing a register table
+ *
+ * @priv: Pointer to device
+ * @table: Table containing register values (with optional delays)
  *
  * This is used to write register table into sensor's reg map.
  *
  * Return: 0 on success, errors otherwise
  */
-static int imx274_regmap_util_write_table_8(struct regmap *regmap,
-					    const struct reg_8 table[],
-					    u16 wait_ms_addr, u16 end_addr)
+static int imx274_write_table(struct stimx274 *priv, const struct reg_8 table[])
 {
+	struct regmap *regmap = priv->regmap;
 	int err = 0;
 	const struct reg_8 *next;
 	u8 val;
@@ -622,8 +620,8 @@ static int imx274_regmap_util_write_table_8(struct regmap *regmap,
 
 	for (next = table;; next++) {
 		if ((next->addr != range_start + range_count) ||
-		    (next->addr == end_addr) ||
-		    (next->addr == wait_ms_addr) ||
+		    (next->addr == IMX274_TABLE_END) ||
+		    (next->addr == IMX274_TABLE_WAIT_MS) ||
 		    (range_count == max_range_vals)) {
 			if (range_count == 1)
 				err = regmap_write(regmap,
@@ -642,10 +640,10 @@ static int imx274_regmap_util_write_table_8(struct regmap *regmap,
 			range_count = 0;
 
 			/* Handle special address values */
-			if (next->addr == end_addr)
+			if (next->addr == IMX274_TABLE_END)
 				break;
 
-			if (next->addr == wait_ms_addr) {
+			if (next->addr == IMX274_TABLE_WAIT_MS) {
 				msleep_range(next->val);
 				continue;
 			}
@@ -692,12 +690,6 @@ static inline int imx274_write_reg(struct stimx274 *priv, u16 addr, u8 val)
 	return err;
 }
 
-static int imx274_write_table(struct stimx274 *priv, const struct reg_8 table[])
-{
-	return imx274_regmap_util_write_table_8(priv->regmap,
-		table, IMX274_TABLE_WAIT_MS, IMX274_TABLE_END);
-}
-
 /*
  * Set mode registers to start stream.
  * @priv: Pointer to device structure
-- 
2.7.4
