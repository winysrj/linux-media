Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35154 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbbCIWLN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 18:11:13 -0400
Received: by wibbs8 with SMTP id bs8so25388301wib.0
        for <linux-media@vger.kernel.org>; Mon, 09 Mar 2015 15:11:12 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/2] media: sh_vou: use devres api
Date: Mon,  9 Mar 2015 22:10:52 +0000
Message-Id: <1425939052-6375-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1425939052-6375-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1425939052-6375-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

use devres API while allocating resources so that these
resources are released automatically on driver detach.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/sh_vou.c | 51 +++++++++--------------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index dde1ccc..1c52cd1 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1297,7 +1297,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	struct i2c_adapter *i2c_adap;
 	struct video_device *vdev;
 	struct sh_vou_device *vou_dev;
-	struct resource *reg_res, *region;
+	struct resource *reg_res;
 	struct v4l2_subdev *subdev;
 	int irq, ret;
 
@@ -1309,7 +1309,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	vou_dev = kzalloc(sizeof(*vou_dev), GFP_KERNEL);
+	vou_dev = devm_kzalloc(&pdev->dev, sizeof(*vou_dev), GFP_KERNEL);
 	if (!vou_dev)
 		return -ENOMEM;
 
@@ -1337,28 +1337,18 @@ static int sh_vou_probe(struct platform_device *pdev)
 	pix->sizeimage		= VOU_MAX_IMAGE_WIDTH * 2 * 480;
 	pix->colorspace		= V4L2_COLORSPACE_SMPTE170M;
 
-	region = request_mem_region(reg_res->start, resource_size(reg_res),
-				    pdev->name);
-	if (!region) {
-		dev_err(&pdev->dev, "VOU region already claimed\n");
-		ret = -EBUSY;
-		goto ereqmemreg;
-	}
-
-	vou_dev->base = ioremap(reg_res->start, resource_size(reg_res));
-	if (!vou_dev->base) {
-		ret = -ENOMEM;
-		goto emap;
-	}
+	vou_dev->base = devm_ioremap_resource(&pdev->dev, reg_res);
+	if (IS_ERR(vou_dev->base))
+		return PTR_ERR(vou_dev->base);
 
-	ret = request_irq(irq, sh_vou_isr, 0, "vou", vou_dev);
-	if (ret < 0)
-		goto ereqirq;
+	ret = devm_request_irq(&pdev->dev, irq, sh_vou_isr, 0, "vou", vou_dev);
+	if (ret)
+		return ret;
 
 	ret = v4l2_device_register(&pdev->dev, &vou_dev->v4l2_dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error registering v4l2 device\n");
-		goto ev4l2devreg;
+		return ret;
 	}
 
 	vdev = &vou_dev->vdev;
@@ -1382,7 +1372,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 
 	ret = sh_vou_hw_init(vou_dev);
 	if (ret < 0)
-		goto ereset;
+		goto ei2cnd;
 
 	subdev = v4l2_i2c_new_subdev_board(&vou_dev->v4l2_dev, i2c_adap,
 			vou_pdata->board_info, NULL);
@@ -1393,50 +1383,31 @@ static int sh_vou_probe(struct platform_device *pdev)
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
-		goto evregdev;
+		goto ei2cnd;
 
 	return 0;
 
-evregdev:
 ei2cnd:
-ereset:
 	i2c_put_adapter(i2c_adap);
 ei2cgadap:
 	pm_runtime_disable(&pdev->dev);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
-ev4l2devreg:
-	free_irq(irq, vou_dev);
-ereqirq:
-	iounmap(vou_dev->base);
-emap:
-	release_mem_region(reg_res->start, resource_size(reg_res));
-ereqmemreg:
-	kfree(vou_dev);
 	return ret;
 }
 
 static int sh_vou_remove(struct platform_device *pdev)
 {
-	int irq = platform_get_irq(pdev, 0);
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
 	struct sh_vou_device *vou_dev = container_of(v4l2_dev,
 						struct sh_vou_device, v4l2_dev);
 	struct v4l2_subdev *sd = list_entry(v4l2_dev->subdevs.next,
 					    struct v4l2_subdev, list);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	struct resource *reg_res;
 
-	if (irq > 0)
-		free_irq(irq, vou_dev);
 	pm_runtime_disable(&pdev->dev);
 	video_unregister_device(&vou_dev->vdev);
 	i2c_put_adapter(client->adapter);
 	v4l2_device_unregister(&vou_dev->v4l2_dev);
-	iounmap(vou_dev->base);
-	reg_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (reg_res)
-		release_mem_region(reg_res->start, resource_size(reg_res));
-	kfree(vou_dev);
 	return 0;
 }
 
-- 
2.1.0

