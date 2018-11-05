Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:53617 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729934AbeKFApj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 19:45:39 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: [PATCH 06/15] media: coda: remove unused instances list
Date: Mon,  5 Nov 2018 16:25:04 +0100
Message-Id: <20181105152513.26345-6-p.zabel@pengutronix.de>
In-Reply-To: <20181105152513.26345-1-p.zabel@pengutronix.de>
References: <20181105152513.26345-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The per-device instance list is unused, remove it.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/coda-common.c | 9 ---------
 drivers/media/platform/coda/coda.h        | 2 --
 2 files changed, 11 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 01deb454e60b..54b7344231c0 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -2214,10 +2214,6 @@ static int coda_open(struct file *file)
 	INIT_LIST_HEAD(&ctx->buffer_meta_list);
 	spin_lock_init(&ctx->buffer_meta_lock);
 
-	mutex_lock(&dev->dev_mutex);
-	list_add(&ctx->list, &dev->instances);
-	mutex_unlock(&dev->dev_mutex);
-
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d (%p)\n",
 		 ctx->idx, ctx);
 
@@ -2264,10 +2260,6 @@ static int coda_release(struct file *file)
 		flush_work(&ctx->seq_end_work);
 	}
 
-	mutex_lock(&dev->dev_mutex);
-	list_del(&ctx->list);
-	mutex_unlock(&dev->dev_mutex);
-
 	if (ctx->dev->devtype->product == CODA_DX6)
 		coda_free_aux_buf(dev, &ctx->workbuf);
 
@@ -2672,7 +2664,6 @@ static int coda_probe(struct platform_device *pdev)
 		return -EINVAL;
 
 	spin_lock_init(&dev->irqlock);
-	INIT_LIST_HEAD(&dev->instances);
 
 	dev->plat_dev = pdev;
 	dev->clk_per = devm_clk_get(&pdev->dev, "per");
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 6cb19f47cbed..aaa90c3d9a16 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -94,7 +94,6 @@ struct coda_dev {
 	struct mutex		coda_mutex;
 	struct workqueue_struct	*workqueue;
 	struct v4l2_m2m_dev	*m2m_dev;
-	struct list_head	instances;
 	struct ida		ida;
 	struct dentry		*debugfs_root;
 };
@@ -192,7 +191,6 @@ struct coda_context_ops {
 struct coda_ctx {
 	struct coda_dev			*dev;
 	struct mutex			buffer_mutex;
-	struct list_head		list;
 	struct work_struct		pic_run_work;
 	struct work_struct		seq_end_work;
 	struct completion		completion;
-- 
2.19.1
