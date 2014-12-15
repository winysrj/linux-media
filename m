Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38205 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLOVLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Dec 2014 16:11:34 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: [PATCH 1/3] s5p-mfc-v6+: Use display_delay_enable CID
Date: Mon, 15 Dec 2014 16:10:57 -0500
Message-Id: <1418677859-31440-2-git-send-email-nicolas.dufresne@collabora.com>
In-Reply-To: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
References: <1418677859-31440-1-git-send-email-nicolas.dufresne@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MFC driver has two controls, DISPLAY_DELAY and DISPLAY_DELAY_ENABLE
that allow forcing the decoder to return a decoded frame sooner
regardless of the order. The added support for firmware version 6 and
higher was not taking into account the DISPLAY_DELAY_ENABLE boolean.
Instead it had a comment stating that DISPLAY_DELAY should be set to a
negative value to disable it. This is not possible since the control
range is from 0 to 65535. This feature was also supposed to be disabled
by default in order to produce frames in display order.

Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 92032a0..0675515 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1340,11 +1340,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 	/* FMO_ASO_CTRL - 0: Enable, 1: Disable */
 	reg |= (fmo_aso_ctrl << S5P_FIMV_D_OPT_FMO_ASO_CTRL_MASK_V6);
 
-	/* When user sets desplay_delay to 0,
-	 * It works as "display_delay enable" and delay set to 0.
-	 * If user wants display_delay disable, It should be
-	 * set to negative value. */
-	if (ctx->display_delay >= 0) {
+	if (ctx->display_delay_enable) {
 		reg |= (0x1 << S5P_FIMV_D_OPT_DDELAY_EN_SHIFT_V6);
 		writel(ctx->display_delay, mfc_regs->d_display_delay);
 	}
-- 
2.1.0

