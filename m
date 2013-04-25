Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:55932 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab3DYLhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 07:37:38 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT00K4U6YM8IP0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 20:37:37 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 6/7 v2] m2m-deinterlace: Add copy time stamp handling
Date: Thu, 25 Apr 2013 13:36:07 +0200
Message-id: <1366889768-16677-7-git-send-email-k.debski@samsung.com>
In-reply-to: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
References: <1366889768-16677-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since the introduction of the timestamp_type field, it is necessary that
the driver chooses which type it will use. This patch adds support for
the timestamp_type.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/m2m-deinterlace.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 6c4db9b..7585646 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -207,6 +207,9 @@ static void dma_callback(void *data)
 	src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 	dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
+	src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
+	src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
+
 	v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 	v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
 
@@ -866,6 +869,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &deinterlace_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	q_data[V4L2_M2M_SRC].fmt = &formats[0];
 	q_data[V4L2_M2M_SRC].width = 640;
 	q_data[V4L2_M2M_SRC].height = 480;
@@ -882,6 +886,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &deinterlace_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	q_data[V4L2_M2M_DST].fmt = &formats[0];
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
-- 
1.7.9.5

