Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52729 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933949AbeF2Mq4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 08:46:56 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de
Subject: [PATCH 3/3] media: coda: jpeg: explicitly disable thumbnails in SEQ_INIT
Date: Fri, 29 Jun 2018 14:46:48 +0200
Message-Id: <20180629124648.31739-3-p.zabel@pengutronix.de>
In-Reply-To: <20180629124648.31739-1-p.zabel@pengutronix.de>
References: <20180629124648.31739-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Explicitly clear DEC_SEQ_JPG_THUMB_EN during sequence initialization.
Not clearing the register does not cause problems, since the only other
codec (MPEG-4 decode) that writes to this register happens to always
write 0 as well.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c  | 2 ++
 drivers/media/platform/coda/coda_regs.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index b4ff89200869..5d575da3efad 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1695,6 +1695,8 @@ static int __coda_start_decoding(struct coda_ctx *ctx)
 			coda_write(dev, 512, CODA_CMD_DEC_SEQ_SPP_CHUNK_SIZE);
 		}
 	}
+	if (src_fourcc == V4L2_PIX_FMT_JPEG)
+		coda_write(dev, 0, CODA_CMD_DEC_SEQ_JPG_THUMB_EN);
 	if (dev->devtype->product != CODA_960)
 		coda_write(dev, 0, CODA_CMD_DEC_SEQ_SRC_SIZE);
 
diff --git a/drivers/media/platform/coda/coda_regs.h b/drivers/media/platform/coda/coda_regs.h
index 3b650b8aabe9..5e7b00a97671 100644
--- a/drivers/media/platform/coda/coda_regs.h
+++ b/drivers/media/platform/coda/coda_regs.h
@@ -157,6 +157,7 @@
 #define CODA_CMD_DEC_SEQ_START_BYTE		0x190
 #define CODA_CMD_DEC_SEQ_PS_BB_START		0x194
 #define CODA_CMD_DEC_SEQ_PS_BB_SIZE		0x198
+#define CODA_CMD_DEC_SEQ_JPG_THUMB_EN		0x19c
 #define CODA_CMD_DEC_SEQ_MP4_ASP_CLASS		0x19c
 #define		CODA_MP4_CLASS_MPEG4			0
 #define CODA_CMD_DEC_SEQ_X264_MV_EN		0x19c
-- 
2.17.1
