Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:52392 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1GPAOB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 20:14:01 -0400
Date: Sat, 16 Jul 2011 02:13:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 4/6] V4L: sh_mobile_csi2: switch away from using the soc-camera
 bus notifier
In-Reply-To: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
Message-ID: <Pine.LNX.4.64.1107160203380.27399@axis700.grange>
References: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This moves us one more step closer to eliminating the soc-camera bus
and devices on it. Besides, as a side effect, CSI-2 runtime PM on
sh-mobile secomes finer grained now: we only have to power on the
interface, when the device nodes are open.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 arch/arm/mach-shmobile/board-ap4evb.c      |   12 +--
 drivers/media/video/sh_mobile_ceu_camera.c |  117 ++++++++++++++++++------
 drivers/media/video/sh_mobile_csi2.c       |  135 +++++++++++++++-------------
 include/media/sh_mobile_ceu.h              |   10 ++-
 include/media/sh_mobile_csi2.h             |    8 +-
 5 files changed, 180 insertions(+), 102 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-ap4evb.c b/arch/arm/mach-shmobile/board-ap4evb.c
index 08acb6e..08977ec 100644
--- a/arch/arm/mach-shmobile/board-ap4evb.c
+++ b/arch/arm/mach-shmobile/board-ap4evb.c
@@ -902,19 +902,16 @@ static struct resource csi2_resources[] = {
 	},
 };
 
-static struct platform_device csi2_device = {
-	.name   = "sh-mobile-csi2",
-	.id     = 0,
+static struct sh_mobile_ceu_companion csi2 = {
+	.id		= 0,
 	.num_resources	= ARRAY_SIZE(csi2_resources),
 	.resource	= csi2_resources,
-	.dev    = {
-		.platform_data = &csi2_info,
-	},
+	.platform_data	= &csi2_info,
 };
 
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
 	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
-	.csi2_dev = &csi2_device.dev,
+	.csi2 = &csi2,
 };
 
 static struct resource ceu_resources[] = {
@@ -958,7 +955,6 @@ static struct platform_device *ap4evb_devices[] __initdata = {
 	&lcdc1_device,
 	&lcdc_device,
 	&hdmi_device,
-	&csi2_device,
 	&ceu_device,
 	&ap4evb_camera,
 };
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index b08debc..6d574ca 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -39,6 +39,7 @@
 #include <media/v4l2-dev.h>
 #include <media/soc_camera.h>
 #include <media/sh_mobile_ceu.h>
+#include <media/sh_mobile_csi2.h>
 #include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-mediabus.h>
 #include <media/soc_mediabus.h>
@@ -96,6 +97,7 @@ struct sh_mobile_ceu_buffer {
 struct sh_mobile_ceu_dev {
 	struct soc_camera_host ici;
 	struct soc_camera_device *icd;
+	struct platform_device *csi2_pdev;
 
 	unsigned int irq;
 	void __iomem *base;
@@ -499,11 +501,26 @@ out:
 	return IRQ_HANDLED;
 }
 
+static struct v4l2_subdev *find_csi2(struct sh_mobile_ceu_dev *pcdev)
+{
+	struct v4l2_subdev *sd;
+
+	if (!pcdev->csi2_pdev)
+		return NULL;
+
+	v4l2_device_for_each_subdev(sd, &pcdev->ici.v4l2_dev)
+		if (&pcdev->csi2_pdev->dev == v4l2_get_subdevdata(sd))
+			return sd;
+
+	return NULL;
+}
+
 /* Called with .video_lock held */
 static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	struct v4l2_subdev *csi2_sd;
 	int ret;
 
 	if (pcdev->icd)
@@ -516,8 +533,16 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	pm_runtime_get_sync(ici->v4l2_dev.dev);
 
 	ret = sh_mobile_ceu_soft_reset(pcdev);
-	if (!ret)
+
+	csi2_sd = find_csi2(pcdev);
+
+	ret = v4l2_subdev_call(csi2_sd, core, s_power, 1);
+	if (ret != -ENODEV && ret != -ENOIOCTLCMD && ret < 0) {
+		pm_runtime_put_sync(ici->v4l2_dev.dev);
+	} else {
 		pcdev->icd = icd;
+		ret = 0;
+	}
 
 	return ret;
 }
@@ -527,9 +552,11 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
 
 	BUG_ON(icd != pcdev->icd);
 
+	v4l2_subdev_call(csi2_sd, core, s_power, 0);
 	/* disable capture, disable interrupts */
 	ceu_write(pcdev, CEIER, 0);
 	sh_mobile_ceu_soft_reset(pcdev);
@@ -641,7 +668,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 	}
 
 	/* CSI2 special configuration */
-	if (pcdev->pdata->csi2_dev) {
+	if (pcdev->pdata->csi2) {
 		in_width = ((in_width - 2) * 2);
 		left_offset *= 2;
 	}
@@ -783,7 +810,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	value |= pcdev->is_16bit ? 1 << 12 : 0;
 
 	/* CSI2 mode */
-	if (pcdev->pdata->csi2_dev)
+	if (pcdev->pdata->csi2)
 		value |= 3 << 12;
 
 	ceu_write(pcdev, CAMCR, value);
@@ -921,7 +948,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		return 0;
 	}
 
-	if (!pcdev->pdata->csi2_dev) {
+	if (!pcdev->pdata->csi2) {
 		ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
 		if (ret < 0)
 			return 0;
@@ -1945,7 +1972,7 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 		.completion = COMPLETION_INITIALIZER_ONSTACK(wait.completion),
 		.notifier.notifier_call = bus_notify,
 	};
-	struct device *csi2;
+	struct sh_mobile_ceu_companion *csi2;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
@@ -2018,26 +2045,61 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 	pcdev->ici.drv_name = dev_name(&pdev->dev);
 	pcdev->ici.ops = &sh_mobile_ceu_host_ops;
 
+	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
+	if (IS_ERR(pcdev->alloc_ctx)) {
+		err = PTR_ERR(pcdev->alloc_ctx);
+		goto exit_free_clk;
+	}
+
+	err = soc_camera_host_register(&pcdev->ici);
+	if (err)
+		goto exit_free_ctx;
+
 	/* CSI2 interfacing */
-	csi2 = pcdev->pdata->csi2_dev;
+	csi2 = pcdev->pdata->csi2;
 	if (csi2) {
-		wait.dev = csi2;
+		struct platform_device *csi2_pdev =
+			platform_device_alloc("sh-mobile-csi2", csi2->id);
+		struct sh_csi2_pdata *csi2_pdata = csi2->platform_data;
+
+		if (!csi2_pdev) {
+			err = -ENOMEM;
+			goto exit_host_unregister;
+		}
+
+		pcdev->csi2_pdev		= csi2_pdev;
+
+		err = platform_device_add_data(csi2_pdev, csi2_pdata, sizeof(*csi2_pdata));
+		if (err < 0)
+			goto exit_pdev_put;
+
+		csi2_pdata			= csi2_pdev->dev.platform_data;
+		csi2_pdata->v4l2_dev		= &pcdev->ici.v4l2_dev;
+
+		csi2_pdev->resource		= csi2->resource;
+		csi2_pdev->num_resources	= csi2->num_resources;
+
+		err = platform_device_add(csi2_pdev);
+		if (err < 0)
+			goto exit_pdev_put;
+
+		wait.dev = &csi2_pdev->dev;
 
 		err = bus_register_notifier(&platform_bus_type, &wait.notifier);
 		if (err < 0)
-			goto exit_free_clk;
+			goto exit_pdev_unregister;
 
 		/*
 		 * From this point the driver module will not unload, until
 		 * we complete the completion.
 		 */
 
-		if (!csi2->driver) {
+		if (!csi2_pdev->dev.driver) {
 			complete(&wait.completion);
 			/* Either too late, or probing failed */
 			bus_unregister_notifier(&platform_bus_type, &wait.notifier);
 			err = -ENXIO;
-			goto exit_free_clk;
+			goto exit_pdev_unregister;
 		}
 
 		/*
@@ -2046,34 +2108,28 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 		 * the "owner" is safe!
 		 */
 
-		err = try_module_get(csi2->driver->owner);
+		err = try_module_get(csi2_pdev->dev.driver->owner);
 
 		/* Let notifier complete, if it has been locked */
 		complete(&wait.completion);
 		bus_unregister_notifier(&platform_bus_type, &wait.notifier);
 		if (!err) {
 			err = -ENODEV;
-			goto exit_free_clk;
+			goto exit_pdev_unregister;
 		}
 	}
 
-	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
-	if (IS_ERR(pcdev->alloc_ctx)) {
-		err = PTR_ERR(pcdev->alloc_ctx);
-		goto exit_module_put;
-	}
-
-	err = soc_camera_host_register(&pcdev->ici);
-	if (err)
-		goto exit_free_ctx;
-
 	return 0;
 
+exit_pdev_unregister:
+	platform_device_del(pcdev->csi2_pdev);
+exit_pdev_put:
+	pcdev->csi2_pdev->resource = NULL;
+	platform_device_put(pcdev->csi2_pdev);
+exit_host_unregister:
+	soc_camera_host_unregister(&pcdev->ici);
 exit_free_ctx:
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
-exit_module_put:
-	if (csi2 && csi2->driver)
-		module_put(csi2->driver->owner);
 exit_free_clk:
 	pm_runtime_disable(&pdev->dev);
 	free_irq(pcdev->irq, pcdev);
@@ -2093,7 +2149,7 @@ static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct sh_mobile_ceu_dev *pcdev = container_of(soc_host,
 					struct sh_mobile_ceu_dev, ici);
-	struct device *csi2 = pcdev->pdata->csi2_dev;
+	struct platform_device *csi2_pdev = pcdev->csi2_pdev;
 
 	soc_camera_host_unregister(soc_host);
 	pm_runtime_disable(&pdev->dev);
@@ -2102,8 +2158,13 @@ static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
 		dma_release_declared_memory(&pdev->dev);
 	iounmap(pcdev->base);
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
-	if (csi2 && csi2->driver)
-		module_put(csi2->driver->owner);
+	if (csi2_pdev && csi2_pdev->dev.driver) {
+		struct module *csi2_drv = csi2_pdev->dev.driver->owner;
+		platform_device_del(csi2_pdev);
+		csi2_pdev->resource = NULL;
+		platform_device_put(csi2_pdev);
+		module_put(csi2_drv);
+	}
 	kfree(pcdev);
 
 	return 0;
diff --git a/drivers/media/video/sh_mobile_csi2.c b/drivers/media/video/sh_mobile_csi2.c
index 98b8748..2893a01 100644
--- a/drivers/media/video/sh_mobile_csi2.c
+++ b/drivers/media/video/sh_mobile_csi2.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/videodev2.h>
 
+#include <media/sh_mobile_ceu.h>
 #include <media/sh_mobile_csi2.h>
 #include <media/soc_camera.h>
 #include <media/v4l2-common.h>
@@ -33,7 +34,6 @@
 struct sh_csi2 {
 	struct v4l2_subdev		subdev;
 	struct list_head		list;
-	struct notifier_block		notifier;
 	unsigned int			irq;
 	void __iomem			*base;
 	struct platform_device		*pdev;
@@ -132,13 +132,6 @@ static struct v4l2_subdev_video_ops sh_csi2_subdev_video_ops = {
 	.try_mbus_fmt	= sh_csi2_try_fmt,
 };
 
-static struct v4l2_subdev_core_ops sh_csi2_subdev_core_ops;
-
-static struct v4l2_subdev_ops sh_csi2_subdev_ops = {
-	.core	= &sh_csi2_subdev_core_ops,
-	.video	= &sh_csi2_subdev_video_ops,
-};
-
 static void sh_csi2_hwinit(struct sh_csi2 *priv)
 {
 	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
@@ -186,65 +179,84 @@ static unsigned long sh_csi2_query_bus_param(struct soc_camera_device *icd)
 	return soc_camera_apply_sensor_flags(icl, flags);
 }
 
-static int sh_csi2_notify(struct notifier_block *nb,
-			  unsigned long action, void *data)
+static int sh_csi2_client_connect(struct sh_csi2 *priv)
 {
-	struct device *dev = data;
-	struct soc_camera_device *icd = to_soc_camera_dev(dev);
-	struct v4l2_device *v4l2_dev = dev_get_drvdata(dev->parent);
-	struct sh_csi2 *priv =
-		container_of(nb, struct sh_csi2, notifier);
 	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
-	int ret, i;
+	struct v4l2_subdev *sd, *csi2_sd = &priv->subdev;
+	struct soc_camera_device *icd = NULL;
+	struct device *dev = v4l2_get_subdevdata(&priv->subdev);
+	int i;
+
+	v4l2_device_for_each_subdev(sd, csi2_sd->v4l2_dev)
+		if (sd->grp_id) {
+			icd = (struct soc_camera_device *)sd->grp_id;
+			break;
+		}
+
+	if (!icd)
+		return -EINVAL;
 
 	for (i = 0; i < pdata->num_clients; i++)
 		if (&pdata->clients[i].pdev->dev == icd->pdev)
 			break;
 
-	dev_dbg(dev, "%s(%p): action = %lu, found #%d\n", __func__, dev, action, i);
+	dev_dbg(dev, "%s(%p): found #%d\n", __func__, dev, i);
 
 	if (i == pdata->num_clients)
-		return NOTIFY_DONE;
+		return -ENODEV;
 
-	switch (action) {
-	case BUS_NOTIFY_BOUND_DRIVER:
-		snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s%s",
-			 dev_name(v4l2_dev->dev), ".mipi-csi");
-		priv->subdev.grp_id = (long)icd;
-		ret = v4l2_device_register_subdev(v4l2_dev, &priv->subdev);
-		dev_dbg(dev, "%s(%p): ret(register_subdev) = %d\n", __func__, priv, ret);
-		if (ret < 0)
-			return NOTIFY_DONE;
+	priv->client = pdata->clients + i;
 
-		priv->client = pdata->clients + i;
+	priv->set_bus_param		= icd->ops->set_bus_param;
+	priv->query_bus_param		= icd->ops->query_bus_param;
+	icd->ops->set_bus_param		= sh_csi2_set_bus_param;
+	icd->ops->query_bus_param	= sh_csi2_query_bus_param;
 
-		priv->set_bus_param		= icd->ops->set_bus_param;
-		priv->query_bus_param		= icd->ops->query_bus_param;
-		icd->ops->set_bus_param		= sh_csi2_set_bus_param;
-		icd->ops->query_bus_param	= sh_csi2_query_bus_param;
+	csi2_sd->grp_id = (long)icd;
 
-		pm_runtime_get_sync(v4l2_get_subdevdata(&priv->subdev));
+	pm_runtime_get_sync(dev);
 
-		sh_csi2_hwinit(priv);
-		break;
-	case BUS_NOTIFY_UNBIND_DRIVER:
-		priv->client = NULL;
+	sh_csi2_hwinit(priv);
 
-		/* Driver is about to be unbound */
-		icd->ops->set_bus_param		= priv->set_bus_param;
-		icd->ops->query_bus_param	= priv->query_bus_param;
-		priv->set_bus_param		= NULL;
-		priv->query_bus_param		= NULL;
+	return 0;
+}
 
-		v4l2_device_unregister_subdev(&priv->subdev);
+static void sh_csi2_client_disconnect(struct sh_csi2 *priv)
+{
+	struct soc_camera_device *icd = (struct soc_camera_device *)priv->subdev.grp_id;
 
-		pm_runtime_put(v4l2_get_subdevdata(&priv->subdev));
-		break;
-	}
+	priv->client = NULL;
+	priv->subdev.grp_id = 0;
 
-	return NOTIFY_OK;
+	/* Driver is about to be unbound */
+	icd->ops->set_bus_param		= priv->set_bus_param;
+	icd->ops->query_bus_param	= priv->query_bus_param;
+	priv->set_bus_param		= NULL;
+	priv->query_bus_param		= NULL;
+
+	pm_runtime_put(v4l2_get_subdevdata(&priv->subdev));
 }
 
+static int sh_csi2_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
+
+	if (on)
+		return sh_csi2_client_connect(priv);
+
+	sh_csi2_client_disconnect(priv);
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops sh_csi2_subdev_core_ops = {
+	.s_power	= sh_csi2_s_power,
+};
+
+static struct v4l2_subdev_ops sh_csi2_subdev_ops = {
+	.core	= &sh_csi2_subdev_core_ops,
+	.video	= &sh_csi2_subdev_video_ops,
+};
+
 static __devinit int sh_csi2_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -274,14 +286,6 @@ static __devinit int sh_csi2_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->irq = irq;
-	priv->notifier.notifier_call = sh_csi2_notify;
-
-	/* We MUST attach after the MIPI sensor */
-	ret = bus_register_notifier(&soc_camera_bus_type, &priv->notifier);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "CSI2 cannot register notifier\n");
-		goto ernotify;
-	}
 
 	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
 		dev_err(&pdev->dev, "CSI2 register region already claimed\n");
@@ -297,11 +301,17 @@ static __devinit int sh_csi2_probe(struct platform_device *pdev)
 	}
 
 	priv->pdev = pdev;
+	platform_set_drvdata(pdev, priv);
 
 	v4l2_subdev_init(&priv->subdev, &sh_csi2_subdev_ops);
 	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
 
-	platform_set_drvdata(pdev, priv);
+	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s.mipi-csi",
+		 dev_name(pdata->v4l2_dev->dev));
+	ret = v4l2_device_register_subdev(pdata->v4l2_dev, &priv->subdev);
+	dev_dbg(&pdev->dev, "%s(%p): ret(register_subdev) = %d\n", __func__, priv, ret);
+	if (ret < 0)
+		goto esdreg;
 
 	pm_runtime_enable(&pdev->dev);
 
@@ -309,11 +319,11 @@ static __devinit int sh_csi2_probe(struct platform_device *pdev)
 
 	return 0;
 
+esdreg:
+	iounmap(priv->base);
 eremap:
 	release_mem_region(res->start, resource_size(res));
 ereqreg:
-	bus_unregister_notifier(&soc_camera_bus_type, &priv->notifier);
-ernotify:
 	kfree(priv);
 
 	return ret;
@@ -324,7 +334,7 @@ static __devexit int sh_csi2_remove(struct platform_device *pdev)
 	struct sh_csi2 *priv = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
-	bus_unregister_notifier(&soc_camera_bus_type, &priv->notifier);
+	v4l2_device_unregister_subdev(&priv->subdev);
 	pm_runtime_disable(&pdev->dev);
 	iounmap(priv->base);
 	release_mem_region(res->start, resource_size(res));
@@ -335,8 +345,9 @@ static __devexit int sh_csi2_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver __refdata sh_csi2_pdrv = {
-	.remove  = __devexit_p(sh_csi2_remove),
-	.driver  = {
+	.remove	= __devexit_p(sh_csi2_remove),
+	.probe	= sh_csi2_probe,
+	.driver	= {
 		.name	= "sh-mobile-csi2",
 		.owner	= THIS_MODULE,
 	},
@@ -344,7 +355,7 @@ static struct platform_driver __refdata sh_csi2_pdrv = {
 
 static int __init sh_csi2_init(void)
 {
-	return platform_driver_probe(&sh_csi2_pdrv, sh_csi2_probe);
+	return platform_driver_register(&sh_csi2_pdrv);
 }
 
 static void __exit sh_csi2_exit(void)
diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
index 80346a6..48413b4 100644
--- a/include/media/sh_mobile_ceu.h
+++ b/include/media/sh_mobile_ceu.h
@@ -7,10 +7,18 @@
 #define SH_CEU_FLAG_VSYNC_LOW		(1 << 3) /* default High if possible */
 
 struct device;
+struct resource;
+
+struct sh_mobile_ceu_companion {
+	u32		num_resources;
+	struct resource	*resource;
+	int		id;
+	void		*platform_data;
+};
 
 struct sh_mobile_ceu_info {
 	unsigned long flags;
-	struct device *csi2_dev;
+	struct sh_mobile_ceu_companion *csi2;
 };
 
 #endif /* __ASM_SH_MOBILE_CEU_H__ */
diff --git a/include/media/sh_mobile_csi2.h b/include/media/sh_mobile_csi2.h
index 4d26151..c586c4f 100644
--- a/include/media/sh_mobile_csi2.h
+++ b/include/media/sh_mobile_csi2.h
@@ -11,6 +11,8 @@
 #ifndef SH_MIPI_CSI
 #define SH_MIPI_CSI
 
+#include <linux/list.h>
+
 enum sh_csi2_phy {
 	SH_CSI2_PHY_MAIN,
 	SH_CSI2_PHY_SUB,
@@ -33,14 +35,14 @@ struct sh_csi2_client_config {
 	struct platform_device *pdev;	/* client platform device */
 };
 
+struct v4l2_device;
+
 struct sh_csi2_pdata {
 	enum sh_csi2_type type;
 	unsigned int flags;
 	struct sh_csi2_client_config *clients;
 	int num_clients;
+	struct v4l2_device *v4l2_dev;
 };
 
-struct device;
-struct v4l2_device;
-
 #endif
-- 
1.7.2.5

