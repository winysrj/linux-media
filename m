Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51356 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbGIKKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 06:10:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Kamil Debski <kamil@wypas.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 03/10] [media] coda: fix bitstream preloading for MPEG4 decoding
Date: Thu,  9 Jul 2015 12:10:14 +0200
Message-Id: <1436436621-12291-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
References: <1436436621-12291-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All decoder instances using the BIT processor should preload buffers
into the bitstream ring buffer, including MPEG4 decoding. Fix this
by explicitly stating the above condition instead of listing all
relevant input formats.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 58f6548..3259ea6 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1244,9 +1244,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (q_data_src->fourcc == V4L2_PIX_FMT_H264 ||
-		    (q_data_src->fourcc == V4L2_PIX_FMT_JPEG &&
-		     ctx->dev->devtype->product == CODA_7541)) {
+		if (ctx->inst_type == CODA_INST_DECODER && ctx->use_bit) {
 			/* copy the buffers that were queued before streamon */
 			mutex_lock(&ctx->bitstream_mutex);
 			coda_fill_bitstream(ctx, false);
-- 
2.1.4

