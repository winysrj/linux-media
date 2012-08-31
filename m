Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36999 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2HaIL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Aug 2012 04:11:27 -0400
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
Subject: [PATCH v3 08/16] media: coda: enable user pointer support
Date: Fri, 31 Aug 2012 10:11:02 +0200
Message-Id: <1346400670-16002-9-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
References: <1346400670-16002-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

USERPTR buffer support is provided by the videobuf2 framework.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 6e3f026..2e357394 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1345,7 +1345,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 
 	memset(src_vq, 0, sizeof(*src_vq));
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	src_vq->io_modes = VB2_MMAP;
+	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	src_vq->drv_priv = ctx;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &coda_qops;
@@ -1357,7 +1357,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 
 	memset(dst_vq, 0, sizeof(*dst_vq));
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	dst_vq->io_modes = VB2_MMAP;
+	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
 	dst_vq->drv_priv = ctx;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &coda_qops;
-- 
1.7.10.4

