Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:48424 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbeHXULe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 16:11:34 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] media: imx274: rearrange sensor startup register tables
Date: Fri, 24 Aug 2018 18:35:20 +0200
Message-Id: <20180824163525.12694-3-luca@lucaceresoli.net>
In-Reply-To: <20180824163525.12694-1-luca@lucaceresoli.net>
References: <20180824163525.12694-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rearrange the imx274_start_<N> register tables to better match the
datasheet and slightly simplify code:

 - collapes tables 1 and 2, they are applied one after each other and
   together they implement the fixed part 1 of the startup procedure
   in the datasheet
 - while there, cleanup comments
 - rename tables 3 and 4 -> 2 and 3, coherently with the datasheet

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 4f629e4e53fd..9b524de08470 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -349,20 +349,14 @@ static const struct reg_8 imx274_mode5_1280x720_raw10[] = {
  */
 static const struct reg_8 imx274_start_1[] = {
 	{IMX274_STANDBY_REG, 0x12},
-	{IMX274_TABLE_END, 0x00}
-};
 
-/*
- * imx274 second step register configuration for
- * starting stream
- */
-static const struct reg_8 imx274_start_2[] = {
-	{0x3120, 0xF0}, /* clock settings */
-	{0x3121, 0x00}, /* clock settings */
-	{0x3122, 0x02}, /* clock settings */
-	{0x3129, 0x9C}, /* clock settings */
-	{0x312A, 0x02}, /* clock settings */
-	{0x312D, 0x02}, /* clock settings */
+	/* PLRD: clock settings */
+	{0x3120, 0xF0},
+	{0x3121, 0x00},
+	{0x3122, 0x02},
+	{0x3129, 0x9C},
+	{0x312A, 0x02},
+	{0x312D, 0x02},
 
 	{0x310B, 0x00},
 
@@ -407,20 +401,20 @@ static const struct reg_8 imx274_start_2[] = {
 };
 
 /*
- * imx274 third step register configuration for
+ * imx274 second step register configuration for
  * starting stream
  */
-static const struct reg_8 imx274_start_3[] = {
+static const struct reg_8 imx274_start_2[] = {
 	{IMX274_STANDBY_REG, 0x00},
 	{0x303E, 0x02}, /* SYS_MODE = 2 */
 	{IMX274_TABLE_END, 0x00}
 };
 
 /*
- * imx274 forth step register configuration for
+ * imx274 third step register configuration for
  * starting stream
  */
-static const struct reg_8 imx274_start_4[] = {
+static const struct reg_8 imx274_start_3[] = {
 	{0x30F4, 0x00},
 	{0x3018, 0xA2}, /* XHS VHS OUTUPT */
 	{IMX274_TABLE_END, 0x00}
@@ -708,10 +702,6 @@ static int imx274_mode_regs(struct stimx274 *priv)
 	if (err)
 		return err;
 
-	err = imx274_write_table(priv, imx274_start_2);
-	if (err)
-		return err;
-
 	err = imx274_write_table(priv, priv->mode->init_regs);
 
 	return err;
@@ -733,7 +723,7 @@ static int imx274_start_stream(struct stimx274 *priv)
 	 * give it 1 extra ms for margin
 	 */
 	msleep_range(11);
-	err = imx274_write_table(priv, imx274_start_3);
+	err = imx274_write_table(priv, imx274_start_2);
 	if (err)
 		return err;
 
@@ -743,7 +733,7 @@ static int imx274_start_stream(struct stimx274 *priv)
 	 * give it 1 extra ms for margin
 	 */
 	msleep_range(8);
-	err = imx274_write_table(priv, imx274_start_4);
+	err = imx274_write_table(priv, imx274_start_3);
 	if (err)
 		return err;
 
-- 
2.17.1
