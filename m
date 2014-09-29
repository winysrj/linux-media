Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40078 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbaI2MyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 08:54:17 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/6] [media] coda: disable rotator if not needed
Date: Mon, 29 Sep 2014 14:53:45 +0200
Message-Id: <1411995227-3623-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
References: <1411995227-3623-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This will still do a 1:1 copy into the internal buffers, but stop
producing visual artifacts in chroma interleaved (NV12) mode.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index f01393c..747b544 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -1037,6 +1037,7 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	int force_ipicture;
 	int quant_param = 0;
 	u32 pic_stream_buffer_addr, pic_stream_buffer_size;
+	u32 rot_mode = 0;
 	u32 dst_fourcc;
 	u32 reg;
 
@@ -1124,8 +1125,9 @@ static int coda_prepare_encode(struct coda_ctx *ctx)
 	}
 
 	/* submit */
-	coda_write(dev, CODA_ROT_MIR_ENABLE | ctx->params.rot_mode,
-		   CODA_CMD_ENC_PIC_ROT_MODE);
+	if (ctx->params.rot_mode)
+		rot_mode = CODA_ROT_MIR_ENABLE | ctx->params.rot_mode;
+	coda_write(dev, rot_mode, CODA_CMD_ENC_PIC_ROT_MODE);
 	coda_write(dev, quant_param, CODA_CMD_ENC_PIC_QS);
 
 
-- 
2.1.0

