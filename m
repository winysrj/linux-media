Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:39533 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751893AbdGGJ6x (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:58:53 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/5] [media] coda: set MPEG-4 encoder class register
Date: Fri,  7 Jul 2017 11:58:30 +0200
Message-Id: <20170707095831.9852-4-p.zabel@pengutronix.de>
In-Reply-To: <20170707095831.9852-1-p.zabel@pengutronix.de>
References: <20170707095831.9852-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Explicitly set MPEG-4 encoder class register instead of relying on the
default value of 0.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c  | 4 ++++
 drivers/media/platform/coda/coda_regs.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index 2f31c672aba04..2a8e13c53f2e1 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1655,6 +1655,10 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 		ctx->params.codec_mode_aux = CODA_MP4_AUX_MPEG4;
 	else
 		ctx->params.codec_mode_aux = 0;
+	if (src_fourcc == V4L2_PIX_FMT_MPEG4) {
+		coda_write(dev, CODA_MP4_CLASS_MPEG4,
+			   CODA_CMD_DEC_SEQ_MP4_ASP_CLASS);
+	}
 	if (src_fourcc == V4L2_PIX_FMT_H264) {
 		if (dev->devtype->product == CODA_7541) {
 			coda_write(dev, ctx->psbuf.paddr,
diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 77ee46a934272..38df5fd9a2fa7 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -158,6 +158,7 @@
 #define CODA_CMD_DEC_SEQ_PS_BB_START		0x194
 #define CODA_CMD_DEC_SEQ_PS_BB_SIZE		0x198
 #define CODA_CMD_DEC_SEQ_MP4_ASP_CLASS		0x19c
+#define		CODA_MP4_CLASS_MPEG4			0
 #define CODA_CMD_DEC_SEQ_X264_MV_EN		0x19c
 #define CODA_CMD_DEC_SEQ_SPP_CHUNK_SIZE		0x1a0
 
-- 
2.11.0
