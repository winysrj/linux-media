Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48392 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab2H1KyN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 06:54:13 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 10/14] media: coda: fix sizeimage setting in try_fmt
Date: Tue, 28 Aug 2012 12:53:57 +0200
Message-Id: <1346151241-10449-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
References: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_TRY_FMT would incorrectly return bytesperline * height,
instead of width * height * 3 / 2.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/video/coda.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index d41df26..791e702 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -408,8 +408,8 @@ static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
 				      W_ALIGN, &f->fmt.pix.height,
 				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
 		f->fmt.pix.bytesperline = round_up(f->fmt.pix.width, 2);
-		f->fmt.pix.sizeimage = f->fmt.pix.height *
-					f->fmt.pix.bytesperline;
+		f->fmt.pix.sizeimage = f->fmt.pix.width *
+					f->fmt.pix.height * 3 / 2;
 	} else { /*encoded formats h.264/mpeg4 */
 		f->fmt.pix.bytesperline = 0;
 		f->fmt.pix.sizeimage = CODA_MAX_FRAME_SIZE;
@@ -493,11 +493,7 @@ static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
 	q_data->fmt = find_format(ctx->dev, f);
 	q_data->width = f->fmt.pix.width;
 	q_data->height = f->fmt.pix.height;
-	if (q_data->fmt->fourcc == V4L2_PIX_FMT_YUV420) {
-		q_data->sizeimage = q_data->width * q_data->height * 3 / 2;
-	} else { /* encoded format h.264/mpeg-4 */
-		q_data->sizeimage = CODA_MAX_FRAME_SIZE;
-	}
+	q_data->sizeimage = f->fmt.pix.sizeimage;
 
 	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
-- 
1.7.10.4

