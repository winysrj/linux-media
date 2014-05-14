Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:58904 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaENGNq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 02:13:46 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH v3] [media] s5p-mfc: add init buffer cmd to MFCV6
Date: Wed, 14 May 2014 11:43:35 +0530
Message-Id: <1400048015-485-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: avnd kiran <avnd.kiran@samsung.com>

Latest MFC v6 firmware requires tile mode and loop filter
setting to be done as part of Init buffer command, in sync
with v7. Since there are two versions of v6 firmware with
different interfaces, it is differenciated using the version
number read back from firmware which is a hexadecimal value
based on the firmware date.

Signed-off-by: avnd kiran <avnd.kiran@samsung.com>
Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
Changes from v2
- Addressed Kamil's comment
  https://patchwork.linuxtv.org/patch/22989/
Changes from v1
- Check for v6 firmware date for differenciating old and new firmware
  as per comments from Kamil and Sylwester.
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h    |    2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   |    8 ++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |   21 ++++++++++++++++++---
 5 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 8d0b686..b47567c 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -132,6 +132,7 @@
 #define S5P_FIMV_D_METADATA_BUFFER_ADDR_V6	0xf448
 #define S5P_FIMV_D_METADATA_BUFFER_SIZE_V6	0xf44c
 #define S5P_FIMV_D_NUM_MV_V6			0xf478
+#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6	0xf47c
 #define S5P_FIMV_D_CPB_BUFFER_ADDR_V6		0xf4b0
 #define S5P_FIMV_D_CPB_BUFFER_SIZE_V6		0xf4b4
 
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
index ea5ec2a..82c96fa 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
@@ -18,8 +18,6 @@
 #define S5P_FIMV_CODEC_VP8_ENC_V7	25
 
 /* Additional registers for v7 */
-#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7		0xf47c
-
 #define S5P_FIMV_E_SOURCE_FIRST_ADDR_V7			0xf9e0
 #define S5P_FIMV_E_SOURCE_SECOND_ADDR_V7		0xf9e4
 #define S5P_FIMV_E_SOURCE_THIRD_ADDR_V7			0xf9e8
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 4d17df9..f5404a6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -287,6 +287,7 @@ struct s5p_mfc_priv_buf {
  * @warn_start:		hardware error code from which warnings start
  * @mfc_ops:		ops structure holding HW operation function pointers
  * @mfc_cmds:		cmd structure holding HW commands function pointers
+ * @ver:		firmware sub version
  *
  */
 struct s5p_mfc_dev {
@@ -330,6 +331,7 @@ struct s5p_mfc_dev {
 	int warn_start;
 	struct s5p_mfc_hw_ops *mfc_ops;
 	struct s5p_mfc_hw_cmds *mfc_cmds;
+	int ver;
 };
 
 /**
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index ee05f2d..b86744f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -238,7 +238,6 @@ static inline void s5p_mfc_clear_cmds(struct s5p_mfc_dev *dev)
 /* Initialize hardware */
 int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 {
-	unsigned int ver;
 	int ret;
 
 	mfc_debug_enter();
@@ -300,12 +299,13 @@ int s5p_mfc_init_hw(struct s5p_mfc_dev *dev)
 		return -EIO;
 	}
 	if (IS_MFCV6_PLUS(dev))
-		ver = mfc_read(dev, S5P_FIMV_FW_VERSION_V6);
+		dev->ver = mfc_read(dev, S5P_FIMV_FW_VERSION_V6);
 	else
-		ver = mfc_read(dev, S5P_FIMV_FW_VERSION);
+		dev->ver = mfc_read(dev, S5P_FIMV_FW_VERSION);
 
 	mfc_debug(2, "MFC F/W version : %02xyy, %02xmm, %02xdd\n",
-		(ver >> 16) & 0xFF, (ver >> 8) & 0xFF, ver & 0xFF);
+		(dev->ver >> 16) & 0xFF, (dev->ver >> 8) & 0xFF,
+		dev->ver & 0xFF);
 	s5p_mfc_clock_off();
 	mfc_debug_leave();
 	return 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 90edb19..444f0e8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -48,6 +48,9 @@
 #define OFFSETA(x)		(((x) - dev->port_a) >> S5P_FIMV_MEM_OFFSET)
 #define OFFSETB(x)		(((x) - dev->port_b) >> S5P_FIMV_MEM_OFFSET)
 
+/* v2 interface version date of MFCv6 firmware */
+#define MFC_V6_FIRMWARE_INTERFACE_V2 0x120629
+
 /* Allocate temporary buffers for decoding */
 static int s5p_mfc_alloc_dec_temp_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
@@ -1269,6 +1272,18 @@ static int s5p_mfc_set_enc_params_vp8(struct s5p_mfc_ctx *ctx)
 	return 0;
 }
 
+/* Check if newer v6 firmware with changed init buffer interface */
+static bool s5p_mfc_is_v6_fw_v2(struct s5p_mfc_dev *dev)
+{
+	if (IS_MFCV7(dev))
+		return false;
+	/*
+	 * FW date is in BCD format xx120629. So checking for
+	 * LSB 24 bits is greater than new interface date.
+	 */
+	return (dev->ver & 0xffffff) >= MFC_V6_FIRMWARE_INTERFACE_V2;
+}
+
 /* Initialize decoding */
 static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 {
@@ -1296,7 +1311,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		WRITEL(ctx->display_delay, S5P_FIMV_D_DISPLAY_DELAY_V6);
 	}
 
-	if (IS_MFCV7(dev)) {
+	if (IS_MFCV7(dev) || s5p_mfc_is_v6_fw_v2(dev)) {
 		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
 		reg = 0;
 	}
@@ -1311,8 +1326,8 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
-	if (IS_MFCV7(dev))
-		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7);
+	if (IS_MFCV7(dev) || s5p_mfc_is_v6_fw_v2(dev))
+		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6);
 	else
 		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
 
-- 
1.7.9.5

