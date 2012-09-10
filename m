Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47441 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab2IJPaQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Sep 2012 11:30:16 -0400
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
Subject: [PATCH v4 15/16] media: coda: set up buffers to be sized as negotiated with s_fmt
Date: Mon, 10 Sep 2012 17:29:59 +0200
Message-Id: <1347291000-340-16-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This fixes a failure in vb2_qbuf in user pointer mode where
__qbuf_userptr checks if the buffer queued by userspace is large
enough. The failure would happen if coda_queue_setup was called
with empty fmt (and thus set the expected buffer size to the maximum
resolution), and userspace queues buffers of smaller size -
corresponding to the negotiated dimensions - were queued.
Explicitly setting sizeimage to the value negotiated via s_fmt
fixes the issue.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 863b96a..4c3e100 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -813,18 +813,11 @@ static int coda_queue_setup(struct vb2_queue *vq,
 				unsigned int sizes[], void *alloc_ctxs[])
 {
 	struct coda_ctx *ctx = vb2_get_drv_priv(vq);
+	struct coda_q_data *q_data;
 	unsigned int size;
 
-	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (fmt)
-			size = fmt->fmt.pix.width *
-				fmt->fmt.pix.height * 3 / 2;
-		else
-			size = MAX_W *
-				MAX_H * 3 / 2;
-	} else {
-		size = CODA_MAX_FRAME_SIZE;
-	}
+	q_data = get_q_data(ctx, vq->type);
+	size = q_data->sizeimage;
 
 	*nplanes = 1;
 	sizes[0] = size;
-- 
1.7.10.4

