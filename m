Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:65457 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751443AbdIOSqM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 14:46:12 -0400
Subject: [PATCH 2/2] [media] ti-vpe: Adjust nine checks for null pointers
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org, Archit Taneja <archit@ti.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <8137a759-cbfd-e04d-0adb-06de1b3246d1@users.sourceforge.net>
Message-ID: <1af449dd-d42d-bcf6-8f0c-7a8dc91dc928@users.sourceforge.net>
Date: Fri, 15 Sep 2017 20:45:53 +0200
MIME-Version: 1.0
In-Reply-To: <8137a759-cbfd-e04d-0adb-06de1b3246d1@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 15 Sep 2017 20:22:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The script “checkpatch.pl” pointed information out like the following.

Comparison to NULL could be written !…

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/ti-vpe/csc.c   |  2 +-
 drivers/media/platform/ti-vpe/vpdma.c |  2 +-
 drivers/media/platform/ti-vpe/vpe.c   | 14 +++++++-------
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
index 135fc9993679..b6568e620a8d 100644
--- a/drivers/media/platform/ti-vpe/csc.c
+++ b/drivers/media/platform/ti-vpe/csc.c
@@ -181,7 +181,7 @@ struct csc_data *csc_create(struct platform_device *pdev, const char *res_name)
 
 	csc->res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
 						res_name);
-	if (csc->res == NULL) {
+	if (!csc->res) {
 		dev_err(&pdev->dev, "missing '%s' platform resources data\n",
 			res_name);
 		return ERR_PTR(-ENODEV);
diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index e2cf2b90e500..b9acd29ebd9a 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -1145,7 +1145,7 @@ int vpdma_create(struct platform_device *pdev, struct vpdma_data *vpdma,
 	spin_lock_init(&vpdma->lock);
 
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpdma");
-	if (res == NULL) {
+	if (!res) {
 		dev_err(&pdev->dev, "missing platform resources data\n");
 		return -ENODEV;
 	}
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 45bd10544189..6bc210e68f6a 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -601,7 +601,7 @@ static void free_vbs(struct vpe_ctx *ctx)
 	struct vpe_dev *dev = ctx->dev;
 	unsigned long flags;
 
-	if (ctx->src_vbs[2] == NULL)
+	if (!ctx->src_vbs[2])
 		return;
 
 	spin_lock_irqsave(&dev->lock, flags);
@@ -1216,22 +1216,22 @@ static void device_run(void *priv)
 		 * It will be removed when using bottom field
 		 */
 		ctx->src_vbs[0] = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
-		WARN_ON(ctx->src_vbs[0] == NULL);
+		WARN_ON(!ctx->src_vbs[0]);
 	} else {
 		ctx->src_vbs[0] = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-		WARN_ON(ctx->src_vbs[0] == NULL);
+		WARN_ON(!ctx->src_vbs[0]);
 	}
 
 	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	WARN_ON(ctx->dst_vb == NULL);
+	WARN_ON(!ctx->dst_vb);
 
 	if (ctx->deinterlacing) {
 
-		if (ctx->src_vbs[2] == NULL) {
+		if (!ctx->src_vbs[2]) {
 			ctx->src_vbs[2] = ctx->src_vbs[0];
-			WARN_ON(ctx->src_vbs[2] == NULL);
+			WARN_ON(!ctx->src_vbs[2]);
 			ctx->src_vbs[1] = ctx->src_vbs[0];
-			WARN_ON(ctx->src_vbs[1] == NULL);
+			WARN_ON(!ctx->src_vbs[1]);
 		}
 
 		/*
-- 
2.14.1
