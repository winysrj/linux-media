Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:40109 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932957AbeFKLgQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 07:36:16 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/8] media: imx274: add helper function to fill a reg_8 table chunk
Date: Mon, 11 Jun 2018 13:35:37 +0200
Message-Id: <1528716939-17015-7-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
References: <1528716939-17015-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tables of struct reg_8 are used to simplify multi-byte register
assignment. However filling these snippets with values computed at
runtime is currently implemented by very similar functions doing the
needed shift & mask manipulation.

Replace all those functions with a unique helper function to fill
reg_8 tables in a simple and clean way.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>

---
Changed v3 -> v4: nothing

Changed v2 -> v3:
 - minor reformatting in prepare_reg() documentation

Changed v1 -> v2:
 - add "media: " prefix to commit message
---
 drivers/media/i2c/imx274.c | 90 ++++++++++++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 35 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 48343c2ade83..e5ba19b97083 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -597,6 +597,58 @@ static inline struct stimx274 *to_imx274(struct v4l2_subdev *sd)
 }
 
 /*
+ * Fill consecutive reg_8 items in order to set a multibyte register.
+ *
+ * The sensor has many 2-bytes registers and a 3-byte register. This
+ * simplifies code to set them by filling consecutive entries of a
+ * struct reg_8 table with the data to set a register.
+ *
+ * The number of table entries that is filled is the minimum needed
+ * for the given number of bits (i.e. nbits / 8, rounded up). If nbits
+ * is not a multiple of 8, extra bits in the most significant byte are
+ * zeroed.
+ *
+ * Example:
+ *   Calling prepare_reg(&regs[10], 0x3000, 0xcafe, 12) will set:
+ *   regs[10] = { .addr = 0x3000, .val = 0xfe }
+ *   regs[11] = { .addr = 0x3001, .val = 0x0a }
+ *
+ * @table_base: Pointer to the first reg_8 struct to be filled.  The
+ *              following entries will also be set, make sure they are
+ *              properly allocated!
+ * @addr_lsb: Address of the LSB register.  Other registers must be
+ *            consecutive, least-to-most significant.
+ * @value: Value to be written to the register.
+ * @nbits: Number of bits to write (range: [1..24])
+ */
+static void prepare_reg(struct reg_8 *table_base,
+			u16 addr_lsb,
+			u32 value,
+			size_t nbits)
+{
+	struct reg_8 *cmd = table_base;
+	u16 addr = addr_lsb;
+	size_t bits; /* how many bits at this round */
+
+	WARN_ON(nbits > 24);
+
+	if (nbits > 24)
+		nbits = 24;
+
+	while (nbits > 0) {
+		bits = min_t(size_t, 8, nbits);
+
+		cmd->addr = addr;
+		cmd->val = value & ((1 << bits) - 1);
+
+		nbits -= bits;
+		value >>= 8;
+		addr++;
+		cmd++;
+	}
+}
+
+/*
  * Writing a register table
  *
  * @priv: Pointer to device
@@ -1163,15 +1215,6 @@ static int imx274_set_digital_gain(struct stimx274 *priv, u32 dgain)
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
@@ -1229,7 +1272,7 @@ static int imx274_set_gain(struct stimx274 *priv, struct v4l2_ctrl *ctrl)
 	if (gain_reg > IMX274_GAIN_REG_MAX)
 		gain_reg = IMX274_GAIN_REG_MAX;
 
-	imx274_calculate_gain_regs(reg_list, (u16)gain_reg);
+	prepare_reg(reg_list, IMX274_ANALOG_GAIN_ADDR_LSB, gain_reg, 11);
 
 	for (i = 0; i < ARRAY_SIZE(reg_list); i++) {
 		err = imx274_write_reg(priv, reg_list[i].addr,
@@ -1258,16 +1301,6 @@ static int imx274_set_gain(struct stimx274 *priv, struct v4l2_ctrl *ctrl)
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
@@ -1292,7 +1325,7 @@ static int imx274_set_coarse_time(struct stimx274 *priv, u32 *val)
 		goto fail;
 
 	/* prepare SHR registers */
-	imx274_calculate_coarse_time_regs(reg_list, coarse_time);
+	prepare_reg(reg_list, IMX274_SHR_REG_LSB, coarse_time, 16);
 
 	/* write to SHR registers */
 	for (i = 0; i < ARRAY_SIZE(reg_list); i++) {
@@ -1429,19 +1462,6 @@ static int imx274_set_test_pattern(struct stimx274 *priv, int val)
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
@@ -1463,7 +1483,7 @@ static int imx274_set_frame_length(struct stimx274 *priv, u32 val)
 
 	frame_length = (u32)val;
 
-	imx274_calculate_frame_length_regs(reg_list, frame_length);
+	prepare_reg(reg_list, IMX274_VMAX_REG_3, frame_length, 20);
 	for (i = 0; i < ARRAY_SIZE(reg_list); i++) {
 		err = imx274_write_reg(priv, reg_list[i].addr,
 				       reg_list[i].val);
-- 
2.7.4
