Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:54233 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756941Ab3JIX6i (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Oct 2013 19:58:38 -0400
Received: by mail-oa0-f73.google.com with SMTP id n10so348655oag.2
        for <linux-media@vger.kernel.org>; Wed, 09 Oct 2013 16:58:37 -0700 (PDT)
From: John Sheu <sheu@google.com>
To: linux-media@vger.kernel.org
Cc: John Sheu <sheu@google.com>, m.chehab@samsung.com,
	k.debski@samsung.com, pawel@osciak.com
Subject: [PATCH 1/6] [media] s5p-mfc: fix DISPLAY_DELAY
Date: Wed,  9 Oct 2013 16:49:44 -0700
Message-Id: <1381362589-32237-2-git-send-email-sheu@google.com>
In-Reply-To: <1381362589-32237-1-git-send-email-sheu@google.com>
References: <1381362589-32237-1-git-send-email-sheu@google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2_CID_MPEG_MFC51_VIDEO_DECODER_H264_DISPLAY_DELAY_ENABLE is being
ignored, and the display delay is always being applied.  Fix this.

Signed-off-by: John Sheu <sheu@google.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 461358c..5bf6efd 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1271,11 +1271,8 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	/* FMO_ASO_CTRL - 0: Enable, 1: Disable */
 	reg |= (fmo_aso_ctrl << S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK_V6);
 
-	/* When user sets desplay_delay to 0,
-	 * It works as "display_delay enable" and delay set to 0.
-	 * If user wants display_delay disable, It should be
-	 * set to negative value. */
-	if (ctx->display_delay >= 0) {
+	/* Setup display delay, only if enabled. */
+	if (ctx->display_delay_enable) {
 		reg |= (0x1 << S5P_FIMV_D_OPT_DDELAY_EN_SHIFT_V6);
 		WRITEL(ctx->display_delay, S5P_FIMV_D_DISPLAY_DELAY_V6);
 	}
-- 
1.8.4

