Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48382 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2H1KyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 06:54:12 -0400
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
Subject: [PATCH v2 08/14] media: coda: enable user pointer support
Date: Tue, 28 Aug 2012 12:53:55 +0200
Message-Id: <1346151241-10449-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
References: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

USERPTR buffer support is provided by the videobuf2 framework.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/video/coda.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index a67a52a..3d47935 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -1343,7 +1343,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 
 	memset(src_vq, 0, sizeof(*src_vq));
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	src_vq->io_modes = VB2_MMAP;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	src_vq->drv_priv = ctx;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &coda_qops;
@@ -1355,7 +1355,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 
 	memset(dst_vq, 0, sizeof(*dst_vq));
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	dst_vq->io_modes = VB2_MMAP;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	dst_vq->drv_priv = ctx;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &coda_qops;
-- 
1.7.10.4

