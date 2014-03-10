Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1797 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaCJN6w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 09:58:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, k.debski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv1 PATCH 5/7] mem2mem_testdev: return pending buffers in stop_streaming()
Date: Mon, 10 Mar 2014 14:58:27 +0100
Message-Id: <1394459909-36497-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394459909-36497-1-git-send-email-hverkuil@xs4all.nl>
References: <1394459909-36497-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

To keep the vb2 buffer administration in balance stop_streaming() must
return any pending buffers to the vb2 framework.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/mem2mem_testdev.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/media/platform/mem2mem_testdev.c b/drivers/media/platform/mem2mem_testdev.c
index 8e2aed2..1ba1a83 100644
--- a/drivers/media/platform/mem2mem_testdev.c
+++ b/drivers/media/platform/mem2mem_testdev.c
@@ -768,10 +768,31 @@ static void m2mtest_buf_queue(struct vb2_buffer *vb)
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vb);
 }
 
+static int m2mtest_stop_streaming(struct vb2_queue *q)
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
+			return 0;
+		spin_lock_irqsave(&ctx->dev->irqlock, flags);
+		v4l2_m2m_buf_done(vb, VB2_BUF_STATE_ERROR);
+		spin_unlock_irqrestore(&ctx->dev->irqlock, flags);
+	}
+	return 0;
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

