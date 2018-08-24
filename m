Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:37647 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727808AbeHXULf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 16:11:35 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] media: imx274: add helper to read multibyte registers
Date: Fri, 24 Aug 2018 18:35:24 +0200
Message-Id: <20180824163525.12694-7-luca@lucaceresoli.net>
In-Reply-To: <20180824163525.12694-1-luca@lucaceresoli.net>
References: <20180824163525.12694-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently 2-bytes and 3-bytes registers are read one byte at a time,
doing the needed shift & mask each time.

Replace all of this code by a unique helper function that calls
regmap_bulk_read(), which has two advantages:
 - reads all the bytes in a unique I2C transaction
 - simplifies code to read multibyte registers

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 93 +++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 46 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 07bc41f537c5..783277068b45 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -659,6 +659,41 @@ static inline int imx274_write_reg(struct stimx274 *priv, u16 addr, u8 val)
 	return err;
 }
 
+/**
+ * Read a multibyte register.
+ *
+ * Uses a bulk read where possible.
+ *
+ * @priv: Pointer to device structure
+ * @addr: Address of the LSB register.  Other registers must be
+ *        consecutive, least-to-most significant.
+ * @val: Pointer to store the register value (cpu endianness)
+ * @nbytes: Number of bytes to read (range: [1..3]).
+ *          Other bytes are zet to 0.
+ *
+ * Return: 0 on success, errors otherwise
+ */
+static int imx274_read_mbreg(struct stimx274 *priv, u16 addr, u32 *val,
+			     size_t nbytes)
+{
+	__le32 val_le = 0;
+	int err;
+
+	err = regmap_bulk_read(priv->regmap, addr, &val_le, nbytes);
+	if (err) {
+		dev_err(&priv->client->dev,
+			"%s : i2c bulk read failed, %x (%zu bytes)\n",
+			__func__, addr, nbytes);
+	} else {
+		*val = le32_to_cpu(val_le);
+		dev_dbg(&priv->client->dev,
+			"%s : addr 0x%x, val=0x%x (%zu bytes)\n",
+			__func__, addr, *val, nbytes);
+	}
+
+	return err;
+}
+
 /**
  * Write a multibyte register.
  *
@@ -1377,37 +1412,17 @@ static int imx274_s_stream(struct v4l2_subdev *sd, int on)
 static int imx274_get_frame_length(struct stimx274 *priv, u32 *val)
 {
 	int err;
-	u16 svr;
+	u32 svr;
 	u32 vmax;
-	u8 reg_val[3];
 
-	/* svr */
-	err = imx274_read_reg(priv, IMX274_SVR_REG_LSB, &reg_val[0]);
+	err = imx274_read_mbreg(priv, IMX274_SVR_REG_LSB, &svr, 2);
 	if (err)
 		goto fail;
 
-	err = imx274_read_reg(priv, IMX274_SVR_REG_MSB, &reg_val[1]);
+	err = imx274_read_mbreg(priv, IMX274_VMAX_REG_3, &vmax, 3);
 	if (err)
 		goto fail;
 
-	svr = (reg_val[1] << IMX274_SHIFT_8_BITS) + reg_val[0];
-
-	/* vmax */
-	err = imx274_read_reg(priv, IMX274_VMAX_REG_3, &reg_val[0]);
-	if (err)
-		goto fail;
-
-	err = imx274_read_reg(priv, IMX274_VMAX_REG_2, &reg_val[1]);
-	if (err)
-		goto fail;
-
-	err = imx274_read_reg(priv, IMX274_VMAX_REG_1, &reg_val[2]);
-	if (err)
-		goto fail;
-
-	vmax = ((reg_val[2] & IMX274_MASK_LSB_3_BITS) << IMX274_SHIFT_16_BITS)
-		+ (reg_val[1] << IMX274_SHIFT_8_BITS) + reg_val[0];
-
 	*val = vmax * (svr + 1);
 
 	return 0;
@@ -1588,8 +1603,7 @@ static int imx274_set_coarse_time(struct stimx274 *priv, u32 *val)
 static int imx274_set_exposure(struct stimx274 *priv, int val)
 {
 	int err;
-	u16 hmax;
-	u8 reg_val[2];
+	u32 hmax;
 	u32 coarse_time; /* exposure time in unit of line (HMAX)*/
 
 	dev_dbg(&priv->client->dev,
@@ -1597,14 +1611,10 @@ static int imx274_set_exposure(struct stimx274 *priv, int val)
 
 	/* step 1: convert input exposure_time (val) into number of 1[HMAX] */
 
-	/* obtain HMAX value */
-	err = imx274_read_reg(priv, IMX274_HMAX_REG_LSB, &reg_val[0]);
-	if (err)
-		goto fail;
-	err = imx274_read_reg(priv, IMX274_HMAX_REG_MSB, &reg_val[1]);
+	err = imx274_read_mbreg(priv, IMX274_HMAX_REG_LSB, &hmax, 2);
 	if (err)
 		goto fail;
-	hmax = (reg_val[1] << IMX274_SHIFT_8_BITS) + reg_val[0];
+
 	if (hmax == 0) {
 		err = -EINVAL;
 		goto fail;
@@ -1739,9 +1749,8 @@ static int imx274_set_frame_interval(struct stimx274 *priv,
 {
 	int err;
 	u32 frame_length, req_frame_rate;
-	u16 svr;
-	u16 hmax;
-	u8 reg_val[2];
+	u32 svr;
+	u32 hmax;
 
 	dev_dbg(&priv->client->dev, "%s: input frame interval = %d / %d",
 		__func__, frame_interval.numerator,
@@ -1769,25 +1778,17 @@ static int imx274_set_frame_interval(struct stimx274 *priv,
 	 * frame_length (i.e. VMAX) = (frame_interval) x 72M /(SVR+1) / HMAX
 	 */
 
-	/* SVR */
-	err = imx274_read_reg(priv, IMX274_SVR_REG_LSB, &reg_val[0]);
+	err = imx274_read_mbreg(priv, IMX274_SVR_REG_LSB, &svr, 2);
 	if (err)
 		goto fail;
-	err = imx274_read_reg(priv, IMX274_SVR_REG_MSB, &reg_val[1]);
-	if (err)
-		goto fail;
-	svr = (reg_val[1] << IMX274_SHIFT_8_BITS) + reg_val[0];
+
 	dev_dbg(&priv->client->dev,
 		"%s : register SVR = %d\n", __func__, svr);
 
-	/* HMAX */
-	err = imx274_read_reg(priv, IMX274_HMAX_REG_LSB, &reg_val[0]);
+	err = imx274_read_mbreg(priv, IMX274_HMAX_REG_LSB, &hmax, 2);
 	if (err)
 		goto fail;
-	err = imx274_read_reg(priv, IMX274_HMAX_REG_MSB, &reg_val[1]);
-	if (err)
-		goto fail;
-	hmax = (reg_val[1] << IMX274_SHIFT_8_BITS) + reg_val[0];
+
 	dev_dbg(&priv->client->dev,
 		"%s : register HMAX = %d\n", __func__, hmax);
 
-- 
2.17.1
