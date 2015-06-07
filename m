Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:48518 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbbFGI60 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Jun 2015 04:58:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Magnus Damm <damm@opensource.se>
Subject: [PATCHv2 02/11] sh-vou: use resource managed calls
Date: Sun,  7 Jun 2015 10:57:56 +0200
Message-Id: <1433667485-35711-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
References: <1433667485-35711-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Simplify the sh-vou clean up by using devm_* were possible.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Magnus Damm <damm@opensource.se>
---
 drivers/media/platform/sh_vou.c | 43 ++++++++---------------------------------
 1 file changed, 8 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 8b799ba..801d5ef 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1300,7 +1300,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 	struct i2c_adapter *i2c_adap;
 	struct video_device *vdev;
 	struct sh_vou_device *vou_dev;
-	struct resource *reg_res, *region;
+	struct resource *reg_res;
 	struct v4l2_subdev *subdev;
 	int irq, ret;
 
@@ -1312,7 +1312,7 @@ static int sh_vou_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	vou_dev = kzalloc(sizeof(*vou_dev), GFP_KERNEL);
+	vou_dev = devm_kzalloc(&pdev->dev, sizeof(*vou_dev), GFP_KERNEL);
 	if (!vou_dev)
 		return -ENOMEM;
 
@@ -1340,28 +1340,18 @@ static int sh_vou_probe(struct platform_device *pdev)
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
+	ret = devm_request_irq(&pdev->dev, irq, sh_vou_isr, 0, "vou", vou_dev);
 	if (ret < 0)
-		goto ereqirq;
+		return ret;
 
 	ret = v4l2_device_register(&pdev->dev, &vou_dev->v4l2_dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error registering v4l2 device\n");
-		goto ev4l2devreg;
+		return ret;
 	}
 
 	vdev = &vou_dev->vdev;
@@ -1407,39 +1397,22 @@ ereset:
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
2.1.4

