Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41946 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143Ab3DYJvO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 05:51:14 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MLT00JTK20XNNL0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Apr 2013 18:51:09 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 7/7] mx2-emmaprp: Add copy time stamp handling
Date: Thu, 25 Apr 2013 11:49:50 +0200
Message-id: <1366883390-12890-8-git-send-email-k.debski@samsung.com>
In-reply-to: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
References: <1366883390-12890-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com> 
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/mx2_emmaprp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 4b9e0a2..f7440e5 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -377,6 +377,9 @@ static irqreturn_t emmaprp_irq(int irq_emma, void *data)
 			src_vb = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
 			dst_vb = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
 
+			src_vb->v4l2_buf.timestamp = dst_vb->v4l2_buf.timestamp;
+			src_vb->v4l2_buf.timecode = dst_vb->v4l2_buf.timecode;
+
 			spin_lock_irqsave(&pcdev->irqlock, flags);
 			v4l2_m2m_buf_done(src_vb, VB2_BUF_STATE_DONE);
 			v4l2_m2m_buf_done(dst_vb, VB2_BUF_STATE_DONE);
@@ -763,6 +766,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	src_vq->ops = &emmaprp_qops;
 	src_vq->mem_ops = &vb2_dma_contig_memops;
+	src_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	ret = vb2_queue_init(src_vq);
 	if (ret)
@@ -774,6 +778,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
 	dst_vq->ops = &emmaprp_qops;
 	dst_vq->mem_ops = &vb2_dma_contig_memops;
+	dst_vq->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
1.7.9.5

