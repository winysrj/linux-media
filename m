Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:44009 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751893AbdGGJ6r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 05:58:47 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 3/5] [media] coda: align internal mpeg4 framebuffers to 16x16 macroblocks
Date: Fri,  7 Jul 2017 11:58:29 +0200
Message-Id: <20170707095831.9852-3-p.zabel@pengutronix.de>
In-Reply-To: <20170707095831.9852-1-p.zabel@pengutronix.de>
References: <20170707095831.9852-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes visual artifacts in the first macroblock row of encoded
MPEG-4 video output caused by 8 additional lines of luma data leaking
into the chroma planes of the internal reference framebuffers: the
buffer size is rounded up to a multiple of 16x16 macroblock size, same
as for the h.264 encoder.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-bit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda/coda-bit.c b/drivers/media/platform/coda/coda-bit.c
index a4abeabfa5377..2f31c672aba04 100644
--- a/drivers/media/platform/coda/coda-bit.c
+++ b/drivers/media/platform/coda/coda-bit.c
@@ -394,7 +394,8 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx,
 	int i;
 
 	if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 ||
-	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264) {
+	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_H264 ||
+	    ctx->codec->dst_fourcc == V4L2_PIX_FMT_MPEG4) {
 		width = round_up(q_data->width, 16);
 		height = round_up(q_data->height, 16);
 	} else {
-- 
2.11.0
