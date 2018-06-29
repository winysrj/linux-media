Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:36940 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934086AbeF2Vus (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 17:50:48 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org, sil2review@lists.osadl.org
Subject: [PATCH] media: fsl-viu: fix error handling in viu_of_probe()
Date: Sat, 30 Jun 2018 00:49:22 +0300
Message-Id: <1530308962-15027-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

viu_of_probe() ignores fails in i2c_get_adapter(),
tries to unlock uninitialized mutex on error path.

The patch streamlining the error handling in viu_of_probe().

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/platform/fsl-viu.c | 38 +++++++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index e41510ce69a4..0273302aa741 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1414,7 +1414,7 @@ static int viu_of_probe(struct platform_device *op)
 				     sizeof(struct viu_reg), DRV_NAME)) {
 		dev_err(&op->dev, "Error while requesting mem region\n");
 		ret = -EBUSY;
-		goto err;
+		goto err_irq;
 	}
 
 	/* remap registers */
@@ -1422,7 +1422,7 @@ static int viu_of_probe(struct platform_device *op)
 	if (!viu_regs) {
 		dev_err(&op->dev, "Can't map register set\n");
 		ret = -ENOMEM;
-		goto err;
+		goto err_irq;
 	}
 
 	/* Prepare our private structure */
@@ -1430,7 +1430,7 @@ static int viu_of_probe(struct platform_device *op)
 	if (!viu_dev) {
 		dev_err(&op->dev, "Can't allocate private structure\n");
 		ret = -ENOMEM;
-		goto err;
+		goto err_irq;
 	}
 
 	viu_dev->vr = viu_regs;
@@ -1446,16 +1446,21 @@ static int viu_of_probe(struct platform_device *op)
 	ret = v4l2_device_register(viu_dev->dev, &viu_dev->v4l2_dev);
 	if (ret < 0) {
 		dev_err(&op->dev, "v4l2_device_register() failed: %d\n", ret);
-		goto err;
+		goto err_irq;
 	}
 
 	ad = i2c_get_adapter(0);
+	if (!ad) {
+		ret = -EFAULT;
+		dev_err(&op->dev, "couldn't get i2c adapter\n");
+		goto err_v4l2;
+	}
 
 	v4l2_ctrl_handler_init(&viu_dev->hdl, 5);
 	if (viu_dev->hdl.error) {
 		ret = viu_dev->hdl.error;
 		dev_err(&op->dev, "couldn't register control\n");
-		goto err_vdev;
+		goto err_i2c;
 	}
 	/* This control handler will inherit the control(s) from the
 	   sub-device(s). */
@@ -1471,7 +1476,7 @@ static int viu_of_probe(struct platform_device *op)
 	vdev = video_device_alloc();
 	if (vdev == NULL) {
 		ret = -ENOMEM;
-		goto err_vdev;
+		goto err_hdl;
 	}
 
 	*vdev = viu_template;
@@ -1492,7 +1497,7 @@ static int viu_of_probe(struct platform_device *op)
 	ret = video_register_device(viu_dev->vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
 		video_device_release(viu_dev->vdev);
-		goto err_vdev;
+		goto err_unlock;
 	}
 
 	/* enable VIU clock */
@@ -1500,12 +1505,12 @@ static int viu_of_probe(struct platform_device *op)
 	if (IS_ERR(clk)) {
 		dev_err(&op->dev, "failed to lookup the clock!\n");
 		ret = PTR_ERR(clk);
-		goto err_clk;
+		goto err_vdev;
 	}
 	ret = clk_prepare_enable(clk);
 	if (ret) {
 		dev_err(&op->dev, "failed to enable the clock!\n");
-		goto err_clk;
+		goto err_vdev;
 	}
 	viu_dev->clk = clk;
 
@@ -1516,7 +1521,7 @@ static int viu_of_probe(struct platform_device *op)
 	if (request_irq(viu_dev->irq, viu_intr, 0, "viu", (void *)viu_dev)) {
 		dev_err(&op->dev, "Request VIU IRQ failed.\n");
 		ret = -ENODEV;
-		goto err_irq;
+		goto err_clk;
 	}
 
 	mutex_unlock(&viu_dev->lock);
@@ -1524,16 +1529,19 @@ static int viu_of_probe(struct platform_device *op)
 	dev_info(&op->dev, "Freescale VIU Video Capture Board\n");
 	return ret;
 
-err_irq:
-	clk_disable_unprepare(viu_dev->clk);
 err_clk:
-	video_unregister_device(viu_dev->vdev);
+	clk_disable_unprepare(viu_dev->clk);
 err_vdev:
-	v4l2_ctrl_handler_free(&viu_dev->hdl);
+	video_unregister_device(viu_dev->vdev);
+err_unlock:
 	mutex_unlock(&viu_dev->lock);
+err_hdl:
+	v4l2_ctrl_handler_free(&viu_dev->hdl);
+err_i2c:
 	i2c_put_adapter(ad);
+err_v4l2:
 	v4l2_device_unregister(&viu_dev->v4l2_dev);
-err:
+err_irq:
 	irq_dispose_mapping(viu_irq);
 	return ret;
 }
-- 
2.7.4
