Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42737 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755043AbcKJKbk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 05:31:40 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Donghwa Lee <dh09.lee@samsung.com>
Subject: [PATCH 3/4] s5p-mfc: Skip incomeplete frame
Date: Thu, 10 Nov 2016 11:31:22 +0100
Message-id: <1478773883-12083-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1478773883-12083-1-git-send-email-m.szyprowski@samsung.com>
References: <1478773883-12083-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161110103136eucas1p1e219ba97c554f47b1afee92a2da294b8@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Donghwa Lee <dh09.lee@samsung.com>

Currently, when incomplete frame is recieved in the middle of
decoding, driver have treated it to error, so src/dst queue and
clock are cleaned. Although it is obviously error case, it is need
to maintain video decoding in case of necessity. This patch
supports skip incomplete frame to next.

Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc.h | 3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc.c  | 7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc.h b/drivers/media/platform/s5p-mfc/regs-mfc.h
index 6ccc3f8..57b7e0b 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc.h
@@ -393,6 +393,9 @@
 #define S5P_FIMV_REG_CLEAR_COUNT		0
 
 /* Error handling defines */
+#define S5P_FIMV_ERR_NO_VALID_SEQ_HDR		67
+#define S5P_FIMV_ERR_INCOMPLETE_FRAME		124
+#define S5P_FIMV_ERR_TIMEOUT			140
 #define S5P_FIMV_ERR_WARNINGS_START		145
 #define S5P_FIMV_ERR_DEC_MASK			0xFFFF
 #define S5P_FIMV_ERR_DEC_SHIFT			0
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 0a5b8f5..994a27b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -641,8 +641,11 @@ static irqreturn_t s5p_mfc_irq(int irq, void *priv)
 	case S5P_MFC_R2H_CMD_ERR_RET:
 		/* An error has occurred */
 		if (ctx->state == MFCINST_RUNNING &&
-			s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) >=
-				dev->warn_start)
+			(s5p_mfc_hw_call(dev->mfc_ops, err_dec, err) >=
+				dev->warn_start ||
+				err == S5P_FIMV_ERR_NO_VALID_SEQ_HDR ||
+				err == S5P_FIMV_ERR_INCOMPLETE_FRAME ||
+				err == S5P_FIMV_ERR_TIMEOUT))
 			s5p_mfc_handle_frame(ctx, reason, err);
 		else
 			s5p_mfc_handle_error(dev, ctx, reason, err);
-- 
1.9.1

