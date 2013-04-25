Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:58890 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab3DYLhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 07:37:07 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT005BD6XQOOO0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 20:37:06 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/7 v2] s5p-g2d: Add copy time stamp handling
Date: Thu, 25 Apr 2013 13:36:02 +0200
Message-id: <1366889768-16677-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
References: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the introduction of the timestamp_type field, it is necessary that
the driver chooses which type it will use. This patch adds support for
the timestamp_type.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-g2d/g2d.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 14d663d..553d87e 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -158,6 +158,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->ops = &g2d_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -169,6 +170,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->ops = &g2d_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -635,6 +637,9 @@ static irqreturn_t g2d_isr(int irq, void *prv)
 	BUG_ON(src == NULL);
 	BUG_ON(dst == NULL);
 
+	dst->v4l2_buf.timecode = src->v4l2_buf.timecode;
+	dst->v4l2_buf.timestamp = src->v4l2_buf.timestamp;
+
 	v4l2_m2m_buf_done(src, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst, VB2_BUF_STATE_DONE);
 	v4l2_m2m_job_finish(dev->m2m_dev, ctx->m2m_ctx);
-- 
1.7.9.5

