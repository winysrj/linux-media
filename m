Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35186 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761590AbaGRKXI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 06:23:08 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 07/11] [media] coda: lock capture frame size to output frame size when streaming
Date: Fri, 18 Jul 2014 12:22:41 +0200
Message-Id: <1405678965-10473-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
References: <1405678965-10473-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As soon as the output queue is streaming, let try_fmt on the capture side
only allow the frame size that was set on the output side.

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 924ad58..3076e10 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -721,6 +721,9 @@ static int coda_try_fmt_vid_cap(struct file *file, void *priv,
 					f->fmt.pix.pixelformat);
 		if (!codec)
 			return -EINVAL;
+
+		f->fmt.pix.width = q_data_src->width;
+		f->fmt.pix.height = q_data_src->height;
 	} else {
 		/* Otherwise determine codec by encoded format, if possible */
 		codec = coda_find_codec(ctx->dev, V4L2_PIX_FMT_YUV420,
-- 
2.0.1

