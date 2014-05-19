Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52267 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaESMdh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 08:33:37 -0400
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, posciak@chromium.org, avnd.kiran@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH 08/10] [media] s5p-mfc: Move INIT_BUFFER_OPTIONS from v7 to v6
Date: Mon, 19 May 2014 18:03:04 +0530
Message-Id: <1400502786-4826-9-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
References: <1400502786-4826-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The register S5P_FIMV_D_INIT_BUFFER_OPTIONS holds good for v6
firmware too. So moving the definition from v7 regs to v6.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/regs-mfc-v7.h    |    2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 8e4021c..51cb2dd 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -141,6 +141,7 @@
 #define S5P_FIMV_D_SLICE_IF_ENABLE_V6		0xf4c4
 #define S5P_FIMV_D_PICTURE_TAG_V6		0xf4c8
 #define S5P_FIMV_D_STREAM_DATA_SIZE_V6		0xf4d0
+#define S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6	0xf47c
 
 /* Display information register */
 #define S5P_FIMV_D_DISPLAY_FRAME_WIDTH_V6	0xf500
diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v7.h b/drivers/media/platform/s5p-mfc/regs-mfc-v7.h
index 5dfa149..1a5c6fd 100644
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
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index f64621a..518d9a0 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1310,7 +1310,7 @@ static int s5p_mfc_init_decode_v6(struct s5p_mfc_ctx *ctx)
 		reg |= (0x1 << S5P_FIMV_D_OPT_TILE_MODE_SHIFT_V6);
 
 	if (IS_MFCV7(dev))
-		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V7);
+		WRITEL(reg, S5P_FIMV_D_INIT_BUFFER_OPTIONS_V6);
 	else
 		WRITEL(reg, S5P_FIMV_D_DEC_OPTIONS_V6);
 
-- 
1.7.9.5

