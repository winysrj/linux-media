Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45447 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387404AbeKFUGk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 15:06:40 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Ian Arkver <ian.arkver.dev@gmail.com>, kernel@pengutronix.de
Subject: [PATCH v2] media: coda: fix memory corruption in case more than 32 instances are opened
Date: Tue,  6 Nov 2018 11:40:54 +0100
Message-Id: <20181106104054.21599-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ffz() return value is undefined if the instance mask does not
contain any zeros. If it returned 32, the following set_bit would
corrupt the debugfs_root pointer.
Switch to IDA for context index allocation. This also removes the
artificial 32 instance limit for all except CodaDx6.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
 - #include <linux/idr.h> explicitly where struct ida or ida_*
   functions are used, reported by Ian Arkver
---
 drivers/media/platform/coda/coda-common.c | 26 +++++++++--------------
 drivers/media/platform/coda/coda.h        |  3 ++-
 2 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 2848ea5f464d..547acf80c89d 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -17,6 +17,7 @@
 #include <linux/firmware.h>
 #include <linux/gcd.h>
 #include <linux/genalloc.h>
+#include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
@@ -2099,17 +2100,6 @@ int coda_decoder_queue_init(void *priv, struct vb2_queue *src_vq,
 	return coda_queue_init(priv, dst_vq);
 }
 
-static int coda_next_free_instance(struct coda_dev *dev)
-{
-	int idx = ffz(dev->instance_mask);
-
-	if ((idx < 0) ||
-	    (dev->devtype->product == CODA_DX6 && idx > CODADX6_MAX_INSTANCES))
-		return -EBUSY;
-
-	return idx;
-}
-
 /*
  * File operations
  */
@@ -2118,7 +2108,8 @@ static int coda_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct coda_dev *dev = video_get_drvdata(vdev);
-	struct coda_ctx *ctx = NULL;
+	struct coda_ctx *ctx;
+	unsigned int max = ~0;
 	char *name;
 	int ret;
 	int idx;
@@ -2127,12 +2118,13 @@ static int coda_open(struct file *file)
 	if (!ctx)
 		return -ENOMEM;
 
-	idx = coda_next_free_instance(dev);
+	if (dev->devtype->product == CODA_DX6)
+		max = CODADX6_MAX_INSTANCES - 1;
+	idx = ida_alloc_max(&dev->ida, max, GFP_KERNEL);
 	if (idx < 0) {
 		ret = idx;
 		goto err_coda_max;
 	}
-	set_bit(idx, &dev->instance_mask);
 
 	name = kasprintf(GFP_KERNEL, "context%d", idx);
 	if (!name) {
@@ -2241,8 +2233,8 @@ static int coda_open(struct file *file)
 err_pm_get:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-	clear_bit(ctx->idx, &dev->instance_mask);
 err_coda_name_init:
+	ida_free(&dev->ida, ctx->idx);
 err_coda_max:
 	kfree(ctx);
 	return ret;
@@ -2284,7 +2276,7 @@ static int coda_release(struct file *file)
 	pm_runtime_put_sync(&dev->plat_dev->dev);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
-	clear_bit(ctx->idx, &dev->instance_mask);
+	ida_free(&dev->ida, ctx->idx);
 	if (ctx->ops->release)
 		ctx->ops->release(ctx);
 	debugfs_remove_recursive(ctx->debugfs_entry);
@@ -2745,6 +2737,7 @@ static int coda_probe(struct platform_device *pdev)
 
 	mutex_init(&dev->dev_mutex);
 	mutex_init(&dev->coda_mutex);
+	ida_init(&dev->ida);
 
 	dev->debugfs_root = debugfs_create_dir("coda", NULL);
 	if (!dev->debugfs_root)
@@ -2832,6 +2825,7 @@ static int coda_remove(struct platform_device *pdev)
 	coda_free_aux_buf(dev, &dev->tempbuf);
 	coda_free_aux_buf(dev, &dev->workbuf);
 	debugfs_remove_recursive(dev->debugfs_root);
+	ida_destroy(&dev->ida);
 	return 0;
 }
 
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index 19ac0b9dc6eb..680c7035c9d4 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -16,6 +16,7 @@
 #define __CODA_H__
 
 #include <linux/debugfs.h>
+#include <linux/idr.h>
 #include <linux/irqreturn.h>
 #include <linux/mutex.h>
 #include <linux/kfifo.h>
@@ -95,7 +96,7 @@ struct coda_dev {
 	struct workqueue_struct	*workqueue;
 	struct v4l2_m2m_dev	*m2m_dev;
 	struct list_head	instances;
-	unsigned long		instance_mask;
+	struct ida		ida;
 	struct dentry		*debugfs_root;
 };
 
-- 
2.19.1
