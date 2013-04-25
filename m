Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55876 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757514Ab3DYLhN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 07:37:13 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT000VE6XM3GN0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 20:37:13 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 2/7 v2] s5p-jpeg: Add copy time stamp handling
Date: Thu, 25 Apr 2013 13:36:03 +0200
Message-id: <1366889768-16677-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
References: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the introduction of the timestamp_type field, it is necessary that
the driver chooses which type it will use. This patch adds support for
the timestamp_type.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 3b02375..15d2396 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1229,6 +1229,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &s5p_jpeg_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -1240,6 +1241,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &s5p_jpeg_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_queue_init(dst_vq);
 }
@@ -1287,6 +1289,9 @@ static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
 		payload_size = jpeg_compressed_size(jpeg->regs);
 	}
 
+	dst_buf->v4l2_buf.timecode = src_buf->v4l2_buf.timecode;
+	dst_buf->v4l2_buf.timestamp = src_buf->v4l2_buf.timestamp;
+
 	v4l2_m2m_buf_done(src_buf, state);
 	if (curr_ctx->mode == S5P_JPEG_ENCODE)
 		vb2_set_plane_payload(dst_buf, 0, payload_size);
-- 
1.7.9.5

