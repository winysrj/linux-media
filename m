Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55913 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3DYLh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 07:37:28 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT00JWJ6YCNNP0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 20:37:28 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 4/7 v2] coda: Add copy time stamp handling
Date: Thu, 25 Apr 2013 13:36:05 +0200
Message-id: <1366889768-16677-5-git-send-email-k.debski@samsung.com>
In-reply-to: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
References: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the introduction of the timestamp_type field, it is necessary that
the driver chooses which type it will use. This patch adds support for
the timestamp_type.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/media/platform/coda.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 20827ba..5612329 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1422,6 +1422,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &coda_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1433,6 +1434,7 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &coda_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -1628,6 +1630,9 @@ static irqreturn_t coda_irq_handler(int irq, void *data)
 		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
 	}
 
+	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
+	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
+
 	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 
-- 
1.7.9.5

