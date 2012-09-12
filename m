Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33376 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2ILPCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:02:48 -0400
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
Subject: [PATCH v5 10/13] media: coda: fix sizeimage setting in try_fmt
Date: Wed, 12 Sep 2012 17:02:35 +0200
Message-Id: <1347462158-20417-11-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
References: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_TRY_FMT would incorrectly return bytesperline * height,
instead of width * height * 3 / 2.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/coda.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index fe8a397..e8ed427 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -407,8 +407,8 @@ static int vidioc_try_fmt(struct coda_dev *dev, struct v4l2_format *f)
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
@@ -492,11 +492,7 @@ static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
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

