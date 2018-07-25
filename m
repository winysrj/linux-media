Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:37526 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728694AbeGYRhl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 13:37:41 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 1/2] media: imx274: use regmap_bulk_write to write multybyte registers
Date: Wed, 25 Jul 2018 18:24:54 +0200
Message-Id: <20180725162455.31381-2-luca@lucaceresoli.net>
In-Reply-To: <20180725162455.31381-1-luca@lucaceresoli.net>
References: <20180725162455.31381-1-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently 2-bytes and 3-bytes registers are set by very similar
functions doing the needed shift & mask manipulation, followed by very
similar for loops setting one byte at a time over I2C.

Replace all of this code by a unique helper function that calls
regmap_bulk_write(), which has two advantages:
 - sets all the bytes in a unique I2C transaction
 - removes lots of now unused code.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>

---
Changed v5 -> v6:
 - fix warning on debug print on 32-bit machines (reported by the
   kbuild test robot)
 - fix line above 80 chars

Changed v4 -> v5:
 - completely replace the former patch adding prepare_regs() by
   directly calling regmap_bulk_write() (Sakari)

Changed v3 -> v4: nothing

Changed v2 -> v3:
 - minor reformatting in prepare_reg() documentation

Changed v1 -> v2:
 - add "media: " prefix to commit message
---
 drivers/media/i2c/imx274.c | 102 ++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 63 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index edca63eaea9b..093c4587832a 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -690,6 +690,35 @@ static inline int imx274_write_reg(struct stimx274 *priv, u16 addr, u8 val)
 	return err;
 }
 
+/**
+ * Write a multibyte register.
+ *
+ * Uses a bulk write where possible.
+ *
+ * @priv: Pointer to device structure
+ * @addr: Address of the LSB register.  Other registers must be
+ *        consecutive, least-to-most significant.
+ * @val: Value to be written to the register (cpu endianness)
+ * @nbytes: Number of bits to write (range: [1..3])
+ */
+static int imx274_write_mbreg(struct stimx274 *priv, u16 addr, u32 val,
+			      size_t nbytes)
+{
+	__le32 val_le = cpu_to_le32(val);
+	int err;
+
+	err = regmap_bulk_write(priv->regmap, addr, &val_le, nbytes);
+	if (err)
+		dev_err(&priv->client->dev,
+			"%s : i2c bulk write failed, %x = %x (%zu bytes)\n",
+			__func__, addr, val, nbytes);
+	else
+		dev_dbg(&priv->client->dev,
+			"%s : addr 0x%x, val=0x%x (%zu bytes)\n",
+			__func__, addr, val, nbytes);
+	return err;
+}
+
 /*
  * Set mode registers to start stream.
  * @priv: Pointer to device structure
@@ -1163,15 +1192,6 @@ static int imx274_set_digital_gain(struct stimx274 *priv, u32 dgain)
 				reg_val & IMX274_MASK_LSB_4_BITS);
 }
 
-static inline void imx274_calculate_gain_regs(struct reg_8 regs[2], u16 gain)
-{
-	regs->addr = IMX274_ANALOG_GAIN_ADDR_MSB;
-	regs->val = (gain >> IMX274_SHIFT_8_BITS) & IMX274_MASK_LSB_3_BITS;
-
-	(regs + 1)->addr = IMX274_ANALOG_GAIN_ADDR_LSB;
-	(regs + 1)->val = (gain) & IMX274_MASK_LSB_8_BITS;
-}
-
 /*
  * imx274_set_gain - Function called when setting gain
  * @priv: Pointer to device structure
@@ -1185,10 +1205,8 @@ static inline void imx274_calculate_gain_regs(struct reg_8 regs[2], u16 gain)
  */
 static int imx274_set_gain(struct stimx274 *priv, struct v4l2_ctrl *ctrl)
 {
-	struct reg_8 reg_list[2];
 	int err;
 	u32 gain, analog_gain, digital_gain, gain_reg;
-	int i;
 
 	gain = (u32)(ctrl->val);
 
@@ -1229,14 +1247,10 @@ static int imx274_set_gain(struct stimx274 *priv, struct v4l2_ctrl *ctrl)
 	if (gain_reg > IMX274_GAIN_REG_MAX)
 		gain_reg = IMX274_GAIN_REG_MAX;
 
-	imx274_calculate_gain_regs(reg_list, (u16)gain_reg);
-
-	for (i = 0; i < ARRAY_SIZE(reg_list); i++) {
-		err = imx274_write_reg(priv, reg_list[i].addr,
-				       reg_list[i].val);
-		if (err)
-			goto fail;
-	}
+	err = imx274_write_mbreg(priv, IMX274_ANALOG_GAIN_ADDR_LSB, gain_reg,
+				 2);
+	if (err)
+		goto fail;
 
 	if (IMX274_GAIN_CONST - gain_reg == 0) {
 		err = -EINVAL;
@@ -1258,16 +1272,6 @@ static int imx274_set_gain(struct stimx274 *priv, struct v4l2_ctrl *ctrl)
 	return err;
 }
 
-static inline void imx274_calculate_coarse_time_regs(struct reg_8 regs[2],
-						     u32 coarse_time)
-{
-	regs->addr = IMX274_SHR_REG_MSB;
-	regs->val = (coarse_time >> IMX274_SHIFT_8_BITS)
-			& IMX274_MASK_LSB_8_BITS;
-	(regs + 1)->addr = IMX274_SHR_REG_LSB;
-	(regs + 1)->val = (coarse_time) & IMX274_MASK_LSB_8_BITS;
-}
-
 /*
  * imx274_set_coarse_time - Function called when setting SHR value
  * @priv: Pointer to device structure
@@ -1279,10 +1283,8 @@ static inline void imx274_calculate_coarse_time_regs(struct reg_8 regs[2],
  */
 static int imx274_set_coarse_time(struct stimx274 *priv, u32 *val)
 {
-	struct reg_8 reg_list[2];
 	int err;
 	u32 coarse_time, frame_length;
-	int i;
 
 	coarse_time = *val;
 
@@ -1291,16 +1293,9 @@ static int imx274_set_coarse_time(struct stimx274 *priv, u32 *val)
 	if (err)
 		goto fail;
 
-	/* prepare SHR registers */
-	imx274_calculate_coarse_time_regs(reg_list, coarse_time);
-
-	/* write to SHR registers */
-	for (i = 0; i < ARRAY_SIZE(reg_list); i++) {
-		err = imx274_write_reg(priv, reg_list[i].addr,
-				       reg_list[i].val);
-		if (err)
-			goto fail;
-	}
+	err = imx274_write_mbreg(priv, IMX274_SHR_REG_LSB, coarse_time, 2);
+	if (err)
+		goto fail;
 
 	*val = frame_length - coarse_time;
 	return 0;
@@ -1429,19 +1424,6 @@ static int imx274_set_test_pattern(struct stimx274 *priv, int val)
 	return err;
 }
 
-static inline void imx274_calculate_frame_length_regs(struct reg_8 regs[3],
-						      u32 frame_length)
-{
-	regs->addr = IMX274_VMAX_REG_1;
-	regs->val = (frame_length >> IMX274_SHIFT_16_BITS)
-			& IMX274_MASK_LSB_4_BITS;
-	(regs + 1)->addr = IMX274_VMAX_REG_2;
-	(regs + 1)->val = (frame_length >> IMX274_SHIFT_8_BITS)
-			& IMX274_MASK_LSB_8_BITS;
-	(regs + 2)->addr = IMX274_VMAX_REG_3;
-	(regs + 2)->val = (frame_length) & IMX274_MASK_LSB_8_BITS;
-}
-
 /*
  * imx274_set_frame_length - Function called when setting frame length
  * @priv: Pointer to device structure
@@ -1453,23 +1435,17 @@ static inline void imx274_calculate_frame_length_regs(struct reg_8 regs[3],
  */
 static int imx274_set_frame_length(struct stimx274 *priv, u32 val)
 {
-	struct reg_8 reg_list[3];
 	int err;
 	u32 frame_length;
-	int i;
 
 	dev_dbg(&priv->client->dev, "%s : input length = %d\n",
 		__func__, val);
 
 	frame_length = (u32)val;
 
-	imx274_calculate_frame_length_regs(reg_list, frame_length);
-	for (i = 0; i < ARRAY_SIZE(reg_list); i++) {
-		err = imx274_write_reg(priv, reg_list[i].addr,
-				       reg_list[i].val);
-		if (err)
-			goto fail;
-	}
+	err = imx274_write_mbreg(priv, IMX274_VMAX_REG_3, frame_length, 3);
+	if (err)
+		goto fail;
 
 	return 0;
 
-- 
2.17.1
