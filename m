Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52387 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaETKR0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 May 2014 06:17:26 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, s.nawrocki@samsung.com, posciak@chromium.org,
	avnd.kiran@samsung.com, arunkk.samsung@gmail.com
Subject: [PATCH 3/3] [media] s5p-mfc: Add init buffer cmd to MFCV6
Date: Tue, 20 May 2014 15:47:09 +0530
Message-Id: <1400581029-3475-4-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400581029-3475-1-git-send-email-arun.kk@samsung.com>
References: <1400581029-3475-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Latest MFC v6 firmware requires tile mode and loop filter
setting to be done as part of Init buffer command, in sync
with v7. This patch adds this support for new v6 firmware.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kiran AVND <avnd.kiran@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 4f5e0ea..c1c12f8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -48,6 +48,8 @@
 #define WRITEL(data, reg) \
 	(WARN_ON_ONCE(!(reg)) ? 0 : writel((data), (reg)))
 
+#define IS_MFCV6_V2(dev) (!IS_MFCV7_PLUS(dev) && dev->fw_ver == MFC_FW_V2)
+
 /* Allocate temporary buffers for decoding */
 static int s5p_mfc_alloc_dec_temp_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
@@ -1352,7 +1354,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		WRITEL(ctx->display_delay, mfc_regs->d_display_delay);
 	}
 
-	if (IS_MFCV7_PLUS(dev)) {
+	if (IS_MFCV7_PLUS(dev) || IS_MFCV6_V2(dev)) {
 		WRITEL(reg, mfc_regs->d_dec_options);
 		reg = 0;
 	}
@@ -1367,7 +1369,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	if (ctx->dst_fmt->fourcc == V4L2_PIX_FMT_NV12MT_16X16)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
-	if (IS_MFCV7_PLUS(dev))
+	if (IS_MFCV7_PLUS(dev) || IS_MFCV6_V2(dev))
 		WRITEL(reg, mfc_regs->d_init_buffer_options);
 	else
 		WRITEL(reg, mfc_regs->d_dec_options);
-- 
1.7.9.5

