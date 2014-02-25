Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4926 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaBYKQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:16:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 11/13] mem2mem_testdev: return pending buffers in stop_streaming()
Date: Tue, 25 Feb 2014 11:16:01 +0100
Message-Id: <1393323363-30058-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
References: <1393323363-30058-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

To keep the list administration in balance stop_streaming() should return
any pending buffers to the vb2 framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 8ca828a..2ea27cc 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -765,10 +765,30 @@ static void m2mtest_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
+static void m2mtest_stop_streaming(struct vb2_queue *q)
+{
+	struct m2mtest_ctx *ctx = vb2_get_drv_priv(q);
+	struct vb2_buffer *vb;
+	unsigned long flags;
+
+	for (;;) {
+		if (V4L2_TYPE_IS_OUTPUT(q->type))
+			vb = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
+		else
+			vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+		if (vb == NULL)
+			return;
+		spin_lock_irqsave(&ctx->dev->irqlock, flags);
+		v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
+		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
+	}
+}
+
 static struct vb2_ops m2mtest_qops = {
 	.queue_setup	 = m2mtest_queue_setup,
 	.buf_prepare	 = m2mtest_buf_prepare,
 	.buf_queue	 = m2mtest_buf_queue,
+	.stop_streaming  = m2mtest_stop_streaming,
 	.wait_prepare	 = vb2_ops_wait_prepare,
 	.wait_finish	 = vb2_ops_wait_finish,
 };
-- 
1.9.0

