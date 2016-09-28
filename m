Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55782 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933901AbcI1VWx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:22:53 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 25/35] media: ti-vpe: vpdma: Fix race condition for firmware loading
Date: Wed, 28 Sep 2016 16:22:50 -0500
Message-ID: <20160928212250.27445-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

vpdma_create API is supposed to allocated the struct vpdma_data and
return it to the driver. Also, it would call the callback function
when the VPDMA firmware is loaded.

Typically, VPE driver have following function call:
    dev->vpdma = vpdma_create(pdev, firmware_load_callback);
And the callback implementation would continue the probe further.
Also, the dev->vpdma is accessed from the callback implementation.

This may lead to race condition between assignment of dev->vpdma
and the callback function being triggered.
This would lead to kernel crash because of NULL pointer access.

Fix this by passing a driver wrapped &vpdma_data instead of allocating
inside vpdma_create.
Change the vpdma_create prototype accordingly and fix return paths.

Also, update the VPE driver to use the updated API and
initialize the dev->vpdma before hand so that the race condition
is avoided.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 17 +++++------------
 drivers/media/platform/ti-vpe/vpdma.h |  2 +-
 drivers/media/platform/ti-vpe/vpe.c   |  8 ++++----
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 8cf2922c9c6f..54c1174cad75 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -1132,21 +1132,14 @@ static int vpdma_load_firmware(struct vpdma_data *vpdma)
 	return 0;
 }
 
-struct vpdma_data *vpdma_create(struct platform_device *pdev,
+int vpdma_create(struct platform_device *pdev, struct vpdma_data *vpdma,
 		void (*cb)(struct platform_device *pdev))
 {
 	struct resource *res;
-	struct vpdma_data *vpdma;
 	int r;
 
 	dev_dbg(&pdev->dev, "vpdma_create\n");
 
-	vpdma = devm_kzalloc(&pdev->dev, sizeof(*vpdma), GFP_KERNEL);
-	if (!vpdma) {
-		dev_err(&pdev->dev, "couldn't alloc vpdma_dev\n");
-		return ERR_PTR(-ENOMEM);
-	}
-
 	vpdma->pdev = pdev;
 	vpdma->cb = cb;
 	spin_lock_init(&vpdma->lock);
@@ -1154,22 +1147,22 @@ struct vpdma_data *vpdma_create(struct platform_device *pdev,
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "vpdma");
 	if (res == NULL) {
 		dev_err(&pdev->dev, "missing platform resources data\n");
-		return ERR_PTR(-ENODEV);
+		return -ENODEV;
 	}
 
 	vpdma->base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!vpdma->base) {
 		dev_err(&pdev->dev, "failed to ioremap\n");
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 
 	r = vpdma_load_firmware(vpdma);
 	if (r) {
 		pr_err("failed to load firmware %s\n", VPDMA_FIRMWARE);
-		return ERR_PTR(r);
+		return r;
 	}
 
-	return vpdma;
+	return 0;
 }
 EXPORT_SYMBOL(vpdma_create);
 
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 405a6febc254..0df156b7c1cf 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -273,7 +273,7 @@ void vpdma_set_bg_color(struct vpdma_data *vpdma,
 void vpdma_dump_regs(struct vpdma_data *vpdma);
 
 /* initialize vpdma, passed with VPE's platform device pointer */
-struct vpdma_data *vpdma_create(struct platform_device *pdev,
+int vpdma_create(struct platform_device *pdev, struct vpdma_data *vpdma,
 		void (*cb)(struct platform_device *pdev));
 
 #endif
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index fda5e02471c9..c09247960550 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -383,6 +383,7 @@ struct vpe_dev {
 	void __iomem		*base;
 	struct resource		*res;
 
+	struct vpdma_data	vpdma_data;
 	struct vpdma_data	*vpdma;		/* vpdma data handle */
 	struct sc_data		*sc;		/* scaler data handle */
 	struct csc_data		*csc;		/* csc data handle */
@@ -2463,11 +2464,10 @@ static int vpe_probe(struct platform_device *pdev)
 		goto runtime_put;
 	}
 
-	dev->vpdma = vpdma_create(pdev, vpe_fw_cb);
-	if (IS_ERR(dev->vpdma)) {
-		ret = PTR_ERR(dev->vpdma);
+	dev->vpdma = &dev->vpdma_data;
+	ret = vpdma_create(pdev, dev->vpdma, vpe_fw_cb);
+	if (ret)
 		goto runtime_put;
-	}
 
 	return 0;
 
-- 
2.9.0

