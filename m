Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51605 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaGKJhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 05:37:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 26/32] [media] coda: allow odd width, but still round up bytesperline
Date: Fri, 11 Jul 2014 11:36:37 +0200
Message-Id: <1405071403-1859-27-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
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
index 75a5477..2acd715 100644
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

