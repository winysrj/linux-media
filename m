Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43496 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907Ab2BJMXw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 07:23:52 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZ6006PQFRRVA@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 12:23:51 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZ600MF4FRQP9@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 12:23:50 +0000 (GMT)
Date: Fri, 10 Feb 2012 13:23:46 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-g2d: Added locking for writing control values to registers
In-reply-to: <1328876626-6931-1-git-send-email-k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1328876626-6931-2-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1328876626-6931-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While at it I have removed an unused default case (control fw takes care of that).

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-g2d/g2d.c |   14 ++++++++++----
 drivers/media/video/s5p-g2d/g2d.h |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-g2d/g2d.c
index e41357f..789de74 100644
--- a/drivers/media/video/s5p-g2d/g2d.c
+++ b/drivers/media/video/s5p-g2d/g2d.c
@@ -178,6 +178,9 @@ static int g2d_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct g2d_ctx *ctx = container_of(ctrl->handler, struct g2d_ctx,
 								ctrl_handler);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->dev->ctrl_lock, flags);
 	switch (ctrl->id) {
 	case V4L2_CID_COLORFX:
 		if (ctrl->val == V4L2_COLORFX_NEGATIVE)
@@ -190,10 +193,8 @@ static int g2d_s_ctrl(struct v4l2_ctrl *ctrl)
 		ctx->flip = ctx->ctrl_hflip->val | (ctx->ctrl_vflip->val << 1);
 		break;
 
-	default:
-		v4l2_err(&ctx->dev->v4l2_dev, "unknown control\n");
-		return -EINVAL;
 	}
+	spin_unlock_irqrestore(&ctx->dev->ctrl_lock, flags);
 	return 0;
 }
 
@@ -558,6 +559,7 @@ static void device_run(void *prv)
 	struct g2d_ctx *ctx = prv;
 	struct g2d_dev *dev = ctx->dev;
 	struct vb2_buffer *src, *dst;
+	unsigned long flags;
 	u32 cmd = 0;
 
 	dev->curr = ctx;
@@ -568,6 +570,8 @@ static void device_run(void *prv)
 	clk_enable(dev->gate);
 	g2d_reset(dev);
 
+	spin_lock_irqsave(&dev->ctrl_lock, flags);
+
 	g2d_set_src_size(dev, &ctx->in);
 	g2d_set_src_addr(dev, vb2_dma_contig_plane_dma_addr(src, 0));
 
@@ -582,6 +586,8 @@ static void device_run(void *prv)
 		cmd |= g2d_cmd_stretch(1);
 	g2d_set_cmd(dev, cmd);
 	g2d_start(dev);
+
+	spin_unlock_irqrestore(&dev->ctrl_lock, flags);
 }
 
 static irqreturn_t g2d_isr(int irq, void *prv)
@@ -671,7 +677,7 @@ static int g2d_probe(struct platform_device *pdev)
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
-	spin_lock_init(&dev->irqlock);
+	spin_lock_init(&dev->ctrl_lock);
 	mutex_init(&dev->mutex);
 	atomic_set(&dev->num_inst, 0);
 	init_waitqueue_head(&dev->irq_queue);
diff --git a/drivers/media/video/s5p-g2d/g2d.h b/drivers/media/video/s5p-g2d/g2d.h
index 78848d2..1b82065 100644
--- a/drivers/media/video/s5p-g2d/g2d.h
+++ b/drivers/media/video/s5p-g2d/g2d.h
@@ -20,7 +20,7 @@ struct g2d_dev {
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct video_device	*vfd;
 	struct mutex		mutex;
-	spinlock_t		irqlock;
+	spinlock_t		ctrl_lock;
 	atomic_t		num_inst;
 	struct vb2_alloc_ctx	*alloc_ctx;
 	struct resource		*res_regs;
-- 
1.7.0.4

