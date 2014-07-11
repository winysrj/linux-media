Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51468 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaGKJgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:36:53 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 02/32] [media] coda: fix readback of CODA_RET_DEC_SEQ_FRAME_NEED
Date: Fri, 11 Jul 2014 11:36:13 +0200
Message-Id: <1405071403-1859-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously we'd add one to this value, allocating one additional, superfluous
internal buffer.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index a7c5ac5..1770fc2 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1889,7 +1889,7 @@ static int coda_start_decoding(struct coda_ctx *ctx)
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "%s instance %d now: %dx%d\n",
 		 __func__, ctx->idx, width, height);
 
-	ctx->num_internal_frames = coda_read(dev, CODA_RET_DEC_SEQ_FRAME_NEED) + 1;
+	ctx->num_internal_frames = coda_read(dev, CODA_RET_DEC_SEQ_FRAME_NEED);
 	if (ctx->num_internal_frames > CODA_MAX_FRAMEBUFFERS) {
 		v4l2_err(&dev->v4l2_dev,
 			 "not enough framebuffers to decode (%d < %d)\n",
-- 
2.0.0

