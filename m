Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39279 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934697AbaGQQF0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 12:05:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 04/11] [media] coda: remove VB2_USERPTR from queue io_modes
Date: Thu, 17 Jul 2014 18:05:05 +0200
Message-Id: <1405613112-22442-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
References: <1405613112-22442-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Disallow USERPTR buffers, videobuf2-dma-contig doesn't support them.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index f52d17c..917727e 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2865,7 +2865,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	int ret;
 
 	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	src_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	src_vq->io_modes = VB2_DMABUF | VB2_MMAP;
 	src_vq->drv_priv = ctx;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &coda_qops;
@@ -2878,7 +2878,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 		return ret;
 
 	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP | VB2_USERPTR;
+	dst_vq->io_modes = VB2_DMABUF | VB2_MMAP;
 	dst_vq->drv_priv = ctx;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &coda_qops;
-- 
2.0.1

