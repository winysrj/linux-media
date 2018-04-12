Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:41282 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752793AbeDLQvd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 12:51:33 -0400
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: Luca Ceresoli <luca@lucaceresoli.net>,
        Leon Luo <leonl@leopardimaging.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] imx274: rename and reorder register address definitions
Date: Thu, 12 Apr 2018 18:51:10 +0200
Message-Id: <1523551878-15754-6-git-send-email-luca@lucaceresoli.net>
In-Reply-To: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
References: <1523551878-15754-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most registers are defined using the name used in the datasheet.
E.g. the defines for the HMAX register are IMX274_HMAX_REG_*.

Rename the SHR and VMAX register accordingly. Also move them close to
related registers: SHR close to SVR, VMAX close to HMAX.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
---
 drivers/media/i2c/imx274.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 9203d377cfe2..62a0d7af0e51 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -107,15 +107,15 @@
 /*
  * IMX274 register definitions
  */
-#define IMX274_FRAME_LENGTH_ADDR_1		0x30FA /* VMAX, MSB */
-#define IMX274_FRAME_LENGTH_ADDR_2		0x30F9 /* VMAX */
-#define IMX274_FRAME_LENGTH_ADDR_3		0x30F8 /* VMAX, LSB */
+#define IMX274_SHR_REG_MSB			0x300D /* SHR */
+#define IMX274_SHR_REG_LSB			0x300C /* SHR */
 #define IMX274_SVR_REG_MSB			0x300F /* SVR */
 #define IMX274_SVR_REG_LSB			0x300E /* SVR */
+#define IMX274_VMAX_REG_1			0x30FA /* VMAX, MSB */
+#define IMX274_VMAX_REG_2			0x30F9 /* VMAX */
+#define IMX274_VMAX_REG_3			0x30F8 /* VMAX, LSB */
 #define IMX274_HMAX_REG_MSB			0x30F7 /* HMAX */
 #define IMX274_HMAX_REG_LSB			0x30F6 /* HMAX */
-#define IMX274_COARSE_TIME_ADDR_MSB		0x300D /* SHR */
-#define IMX274_COARSE_TIME_ADDR_LSB		0x300C /* SHR */
 #define IMX274_ANALOG_GAIN_ADDR_LSB		0x300A /* ANALOG GAIN LSB */
 #define IMX274_ANALOG_GAIN_ADDR_MSB		0x300B /* ANALOG GAIN MSB */
 #define IMX274_DIGITAL_GAIN_REG			0x3012 /* Digital Gain */
@@ -1126,15 +1126,15 @@ static int imx274_get_frame_length(struct stimx274 *priv, u32 *val)
 	svr = (reg_val[1] << IMX274_SHIFT_8_BITS) + reg_val[0];
 
 	/* vmax */
-	err = imx274_read_reg(priv, IMX274_FRAME_LENGTH_ADDR_3, &reg_val[0]);
+	err = imx274_read_reg(priv, IMX274_VMAX_REG_3, &reg_val[0]);
 	if (err)
 		goto fail;
 
-	err = imx274_read_reg(priv, IMX274_FRAME_LENGTH_ADDR_2, &reg_val[1]);
+	err = imx274_read_reg(priv, IMX274_VMAX_REG_2, &reg_val[1]);
 	if (err)
 		goto fail;
 
-	err = imx274_read_reg(priv, IMX274_FRAME_LENGTH_ADDR_1, &reg_val[2]);
+	err = imx274_read_reg(priv, IMX274_VMAX_REG_1, &reg_val[2]);
 	if (err)
 		goto fail;
 
@@ -1293,10 +1293,10 @@ static int imx274_set_gain(struct stimx274 *priv, struct v4l2_ctrl *ctrl)
 static inline void imx274_calculate_coarse_time_regs(struct reg_8 regs[2],
 						     u32 coarse_time)
 {
-	regs->addr = IMX274_COARSE_TIME_ADDR_MSB;
+	regs->addr = IMX274_SHR_REG_MSB;
 	regs->val = (coarse_time >> IMX274_SHIFT_8_BITS)
 			& IMX274_MASK_LSB_8_BITS;
-	(regs + 1)->addr = IMX274_COARSE_TIME_ADDR_LSB;
+	(regs + 1)->addr = IMX274_SHR_REG_LSB;
 	(regs + 1)->val = (coarse_time) & IMX274_MASK_LSB_8_BITS;
 }
 
@@ -1464,13 +1464,13 @@ static int imx274_set_test_pattern(struct stimx274 *priv, int val)
 static inline void imx274_calculate_frame_length_regs(struct reg_8 regs[3],
 						      u32 frame_length)
 {
-	regs->addr = IMX274_FRAME_LENGTH_ADDR_1;
+	regs->addr = IMX274_VMAX_REG_1;
 	regs->val = (frame_length >> IMX274_SHIFT_16_BITS)
 			& IMX274_MASK_LSB_4_BITS;
-	(regs + 1)->addr = IMX274_FRAME_LENGTH_ADDR_2;
+	(regs + 1)->addr = IMX274_VMAX_REG_2;
 	(regs + 1)->val = (frame_length >> IMX274_SHIFT_8_BITS)
 			& IMX274_MASK_LSB_8_BITS;
-	(regs + 2)->addr = IMX274_FRAME_LENGTH_ADDR_3;
+	(regs + 2)->addr = IMX274_VMAX_REG_3;
 	(regs + 2)->val = (frame_length) & IMX274_MASK_LSB_8_BITS;
 }
 
-- 
2.7.4
