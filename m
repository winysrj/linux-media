Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48367 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2H1KyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 06:54:12 -0400
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
Subject: [PATCH v2 06/14] media: coda: keep track of active instances
Date: Tue, 28 Aug 2012 12:53:53 +0200
Message-Id: <1346151241-10449-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
References: <1346151241-10449-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Determining the next free instance just by incrementing and decrementing
an instance counter does not work: if there are two instances opened,
0 and 1, and instance 0 is released, the next call to coda_open will
create a new instance with index 1, but instance 1 is already in use.

Instead, scan a bitfield of active instances to determine the first
free instance index.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/video/coda.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/coda.c b/drivers/media/video/coda.c
index 9119875..aea8d17 100644
--- a/drivers/media/video/coda.c
+++ b/drivers/media/video/coda.c
@@ -135,7 +135,8 @@ struct coda_dev {
 	struct mutex		dev_mutex;
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct vb2_alloc_ctx	*alloc_ctx;
-	int			instances;
+	struct list_head	instances;
+	unsigned long		instance_mask;
 };
 
 struct coda_params {
@@ -153,6 +154,7 @@ struct coda_params {
 
 struct coda_ctx {
 	struct coda_dev			*dev;
+	struct list_head		list;
 	int				aborting;
 	int				rawstreamon;
 	int				compstreamon;
@@ -1358,14 +1360,22 @@ static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
 	return vb2_queue_init(dst_vq);
 }
 
+static int coda_next_free_instance(struct coda_dev *dev)
+{
+	return ffz(dev->instance_mask);
+}
+
 static int coda_open(struct file *file)
 {
 	struct coda_dev *dev = video_drvdata(file);
 	struct coda_ctx *ctx = NULL;
 	int ret = 0;
+	int idx;
 
-	if (dev->instances >= CODA_MAX_INSTANCES)
+	idx = coda_next_free_instance(dev);
+	if (idx >= CODA_MAX_INSTANCES)
 		return -EBUSY;
+	set_bit(idx, &dev->instance_mask);
 
 	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
 	if (!ctx)
@@ -1375,6 +1385,7 @@ static int coda_open(struct file *file)
 	file->private_data = &ctx->fh;
 	v4l2_fh_add(&ctx->fh);
 	ctx->dev = dev;
+	ctx->idx = idx;
 
 	set_default_params(ctx);
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
@@ -1403,7 +1414,7 @@ static int coda_open(struct file *file)
 	}
 
 	coda_lock(ctx);
-	ctx->idx = dev->instances++;
+	list_add(&ctx->list, &dev->instances);
 	coda_unlock(ctx);
 
 	clk_prepare_enable(dev->clk_per);
@@ -1430,7 +1441,7 @@ static int coda_release(struct file *file)
 		 ctx);
 
 	coda_lock(ctx);
-	dev->instances--;
+	list_del(&ctx->list);
 	coda_unlock(ctx);
 
 	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
@@ -1441,6 +1452,7 @@ static int coda_release(struct file *file)
 	clk_disable_unprepare(dev->clk_ahb);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
+	clear_bit(ctx->idx, &dev->instance_mask);
 	kfree(ctx);
 
 	return 0;
@@ -1823,6 +1835,7 @@ static int __devinit coda_probe(struct platform_device *pdev)
 	}
 
 	spin_lock_init(&dev->irqlock);
+	INIT_LIST_HEAD(&dev->instances);
 
 	dev->plat_dev = pdev;
 	dev->clk_per = devm_clk_get(&pdev->dev, "per");
-- 
1.7.10.4

