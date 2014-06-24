Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57690 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaFXO4a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:30 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 26/29] [media] coda: allow odd width, but still round up bytesperline
Date: Tue, 24 Jun 2014 16:56:08 +0200
Message-Id: <1403621771-11636-27-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even though the CODA h.264 decoder always decodes complete macroblocks, we can
set the stride to the corresponding multiple of 16 and use a value smaller than
that as real width. Unfortunately the same doesn't work for height, as there
is no vertical linesperframe stride for discontiguous planar YUV frames.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 5c00d6e..cc41ab3 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -740,9 +740,9 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 
 	/* The h.264 decoder only returns complete 16x16 macroblocks */
 	if (codec && codec->src_fourcc == V4L2_PIX_FMT_H264) {
-		f->fmt.pix.width = round_up(f->fmt.pix.width, 16);
+		f->fmt.pix.width = f->fmt.pix.width;
 		f->fmt.pix.height = round_up(f->fmt.pix.height, 16);
-		f->fmt.pix.bytesperline = f->fmt.pix.width;
+		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 16);
 		f->fmt.pix.sizeimage = f->fmt.pix.bytesperline *
 				       f->fmt.pix.height * 3 / 2;
 	}
-- 
2.0.0

