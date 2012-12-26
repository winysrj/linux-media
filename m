Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:62840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab2LZRt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:49:29 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 4/6] sh_mobile_ceu_camera: add asynchronous subdevice probing support
Date: Wed, 26 Dec 2012 18:49:09 +0100
Message-Id: <1356544151-6313-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the v4l2-async API to support asynchronous subdevice probing,
including the CSI2 subdevice. Synchronous probing is still supported too.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  135 ++++++++++++----
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  164 +++++++++++--------
 include/media/sh_mobile_ceu.h                      |    2 +
 include/media/sh_mobile_csi2.h                     |    2 +-
 4 files changed, 198 insertions(+), 105 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index ba36257..a89f05e 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -35,6 +35,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/sched.h>
 
+#include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/soc_camera.h>
@@ -96,6 +97,10 @@ struct sh_mobile_ceu_buffer {
 struct sh_mobile_ceu_dev {
 	struct soc_camera_host ici;
 	struct soc_camera_device *icd;
+	/* Asynchronous CSI2 linking */
+	struct v4l2_async_subdev *csi2_asd;
+	struct v4l2_subdev *csi2_sd;
+	/* Synchronous probing compatibility */
 	struct platform_device *csi2_pdev;
 
 	unsigned int irq;
@@ -535,16 +540,29 @@ static struct v4l2_subdev *find_csi2(struct sh_mobile_ceu_dev *pcdev)
 {
 	struct v4l2_subdev *sd;
 
-	if (!pcdev->csi2_pdev)
-		return NULL;
+	if (pcdev->csi2_sd)
+		return pcdev->csi2_sd;
 
-	v4l2_device_for_each_subdev(sd, &pcdev->ici.v4l2_dev)
-		if (&pcdev->csi2_pdev->dev == v4l2_get_subdevdata(sd))
-			return sd;
+	if (pcdev->csi2_asd) {
+		char name[] = "sh-mobile-csi2";
+		v4l2_device_for_each_subdev(sd, &pcdev->ici.v4l2_dev)
+			if (!strncmp(name, sd->name, sizeof(name) - 1)) {
+				pcdev->csi2_sd = sd;
+				return sd;
+			}
+	}
 
 	return NULL;
 }
 
+static struct v4l2_subdev *csi2_subdev(struct sh_mobile_ceu_dev *pcdev,
+				       struct soc_camera_device *icd)
+{
+	struct v4l2_subdev *sd = pcdev->csi2_sd;
+
+	return sd && sd->grp_id == soc_camera_grp_id(icd) ? sd : NULL;
+}
+
 /* Called with .host_lock held */
 static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
@@ -582,8 +600,13 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	 * -ENODEV is special: either csi2_sd == NULL or the CSI-2 driver
 	 * has not found this soc-camera device among its clients
 	 */
-	if (ret == -ENODEV && csi2_sd)
-		csi2_sd->grp_id = 0;
+	if (csi2_sd) {
+		if (ret == -ENODEV)
+			csi2_sd->grp_id = 0;
+		else
+			dev_info(icd->parent, "Using CSI-2 interface\n");
+	}
+
 	pcdev->icd = icd;
 
 	return 0;
@@ -599,8 +622,7 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	BUG_ON(icd != pcdev->icd);
 
 	v4l2_subdev_call(csi2_sd, core, s_power, 0);
-	if (csi2_sd)
-		csi2_sd->grp_id = 0;
+
 	/* disable capture, disable interrupts */
 	ceu_write(pcdev, CEIER, 0);
 	sh_mobile_ceu_soft_reset(pcdev);
@@ -706,7 +728,7 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd)
 	}
 
 	/* CSI2 special configuration */
-	if (pcdev->csi2_pdev) {
+	if (csi2_subdev(pcdev, icd)) {
 		in_width = ((in_width - 2) * 2);
 		left_offset *= 2;
 	}
@@ -763,13 +785,7 @@ static void capture_restore(struct sh_mobile_ceu_dev *pcdev, u32 capsr)
 static struct v4l2_subdev *find_bus_subdev(struct sh_mobile_ceu_dev *pcdev,
 					   struct soc_camera_device *icd)
 {
-	if (pcdev->csi2_pdev) {
-		struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
-		if (csi2_sd && csi2_sd->grp_id == soc_camera_grp_id(icd))
-			return csi2_sd;
-	}
-
-	return soc_camera_to_subdev(icd);
+	return csi2_subdev(pcdev, icd) ? : soc_camera_to_subdev(icd);
 }
 
 #define CEU_BUS_FLAGS (V4L2_MBUS_MASTER |	\
@@ -873,7 +889,7 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd)
 	value |= common_flags & V4L2_MBUS_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
 	value |= common_flags & V4L2_MBUS_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
 
-	if (pcdev->csi2_pdev) /* CSI2 mode */
+	if (csi2_subdev(pcdev, icd)) /* CSI2 mode */
 		value |= 3 << 12;
 	else if (pcdev->is_16bit)
 		value |= 1 << 12;
@@ -1052,7 +1068,7 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		return 0;
 	}
 
-	if (!pcdev->pdata || !pcdev->pdata->csi2) {
+	if (!csi2_subdev(pcdev, icd)) {
 		/* Are there any restrictions in the CSI-2 case? */
 		ret = sh_mobile_ceu_try_bus_param(icd, fmt->bits_per_sample);
 		if (ret < 0)
@@ -2079,7 +2095,7 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 	struct resource *res;
 	void __iomem *base;
 	unsigned int irq;
-	int err = 0;
+	int err, i;
 	struct bus_wait wait = {
 		.completion = COMPLETION_INITIALIZER_ONSTACK(wait.completion),
 		.notifier.notifier_call = bus_notify,
@@ -2185,31 +2201,60 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 		goto exit_free_clk;
 	}
 
-	err = soc_camera_host_register(&pcdev->ici);
-	if (err)
-		goto exit_free_ctx;
+	if (pcdev->pdata && pcdev->pdata->asd_sizes) {
+		struct v4l2_async_subdev **asd;
+		char name[] = "sh-mobile-csi2";
+		int j;
+
+		/*
+		 * CSI2 interfacing: several groups can use CSI2, pick up the
+		 * first one
+		 */
+		asd = pcdev->pdata->asd;
+		for (j = 0; pcdev->pdata->asd_sizes[j]; j++) {
+			for (i = 0; i < pcdev->pdata->asd_sizes[j]; i++, asd++) {
+				dev_info(&pdev->dev, "%s(): subdev #%d, type %u\n",
+					 __func__, i, (*asd)->hw.bus_type);
+				if ((*asd)->hw.bus_type == V4L2_ASYNC_BUS_PLATFORM &&
+				    !strncmp(name, (*asd)->hw.match.platform.name,
+					     sizeof(name) - 1)) {
+					pcdev->csi2_asd = *asd;
+					break;
+				}
+			}
+			if (pcdev->csi2_asd)
+				break;
+		}
 
-	/* CSI2 interfacing */
+		pcdev->ici.asd = pcdev->pdata->asd;
+		pcdev->ici.asd_sizes = pcdev->pdata->asd_sizes;
+	}
+
+	/* Legacy CSI2 interfacing */
 	csi2 = pcdev->pdata ? pcdev->pdata->csi2 : NULL;
 	if (csi2) {
+		/*
+		 * TODO: remove this once all users are converted to
+		 * asynchronous CSI2 probing. If it has to be kept, csi2
+		 * platform device resources have to be added, using
+		 * platform_device_add_resources()
+		 */
 		struct platform_device *csi2_pdev =
 			platform_device_alloc("sh-mobile-csi2", csi2->id);
 		struct sh_csi2_pdata *csi2_pdata = csi2->platform_data;
 
 		if (!csi2_pdev) {
 			err = -ENOMEM;
-			goto exit_host_unregister;
+			goto exit_free_ctx;
 		}
 
 		pcdev->csi2_pdev		= csi2_pdev;
 
-		err = platform_device_add_data(csi2_pdev, csi2_pdata, sizeof(*csi2_pdata));
+		err = platform_device_add_data(csi2_pdev, csi2_pdata,
+					       sizeof(*csi2_pdata));
 		if (err < 0)
 			goto exit_pdev_put;
 
-		csi2_pdata			= csi2_pdev->dev.platform_data;
-		csi2_pdata->v4l2_dev		= &pcdev->ici.v4l2_dev;
-
 		csi2_pdev->resource		= csi2->resource;
 		csi2_pdev->num_resources	= csi2->num_resources;
 
@@ -2251,17 +2296,36 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 			err = -ENODEV;
 			goto exit_pdev_unregister;
 		}
+
+		pcdev->csi2_sd = platform_get_drvdata(csi2_pdev);
+	}
+
+	err = soc_camera_host_register(&pcdev->ici);
+	if (err)
+		goto exit_csi2_unregister;
+
+	if (csi2) {
+		err = v4l2_device_register_subdev(&pcdev->ici.v4l2_dev,
+						  pcdev->csi2_sd);
+		dev_dbg(&pdev->dev, "%s(): ret(register_subdev) = %d\n",
+			__func__, err);
+		if (err < 0)
+			goto exit_host_unregister;
 	}
 
 	return 0;
 
-exit_pdev_unregister:
-	platform_device_del(pcdev->csi2_pdev);
-exit_pdev_put:
-	pcdev->csi2_pdev->resource = NULL;
-	platform_device_put(pcdev->csi2_pdev);
 exit_host_unregister:
 	soc_camera_host_unregister(&pcdev->ici);
+exit_csi2_unregister:
+	if (csi2) {
+		module_put(pcdev->csi2_pdev->dev.driver->owner);
+exit_pdev_unregister:
+		platform_device_del(pcdev->csi2_pdev);
+exit_pdev_put:
+		pcdev->csi2_pdev->resource = NULL;
+		platform_device_put(pcdev->csi2_pdev);
+	}
 exit_free_ctx:
 	vb2_dma_contig_cleanup_ctx(pcdev->alloc_ctx);
 exit_free_clk:
@@ -2321,6 +2385,7 @@ MODULE_DEVICE_TABLE(of, sh_mobile_ceu_of_match);
 static struct platform_driver sh_mobile_ceu_driver = {
 	.driver 	= {
 		.name	= "sh_mobile_ceu",
+		.owner	= THIS_MODULE,
 		.pm	= &sh_mobile_ceu_dev_pm_ops,
 		.of_match_table = sh_mobile_ceu_of_match,
 	},
@@ -2346,5 +2411,5 @@ module_exit(sh_mobile_ceu_exit);
 MODULE_DESCRIPTION("SuperH Mobile CEU driver");
 MODULE_AUTHOR("Magnus Damm");
 MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.6");
+MODULE_VERSION("0.1.0");
 MODULE_ALIAS("platform:sh_mobile_ceu");
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index c573be7..8472343 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -35,14 +35,16 @@
 
 struct sh_csi2 {
 	struct v4l2_subdev		subdev;
-	struct list_head		list;
 	unsigned int			irq;
 	unsigned long			mipi_flags;
 	void __iomem			*base;
 	struct platform_device		*pdev;
 	struct sh_csi2_client_config	*client;
+	struct v4l2_async_subdev_list	asdl;
 };
 
+static void sh_csi2_hwinit(struct sh_csi2 *priv);
+
 static int sh_csi2_try_fmt(struct v4l2_subdev *sd,
 			   struct v4l2_mbus_framefmt *mf)
 {
@@ -131,10 +133,58 @@ static int sh_csi2_s_fmt(struct v4l2_subdev *sd,
 static int sh_csi2_g_mbus_config(struct v4l2_subdev *sd,
 				 struct v4l2_mbus_config *cfg)
 {
-	cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING |
-		V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
-		V4L2_MBUS_MASTER | V4L2_MBUS_DATA_ACTIVE_HIGH;
-	cfg->type = V4L2_MBUS_PARALLEL;
+	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
+
+	if (!priv->mipi_flags) {
+		struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
+		struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
+		struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
+		unsigned long common_flags, csi2_flags;
+		struct v4l2_mbus_config client_cfg = {.type = V4L2_MBUS_CSI2,};
+		int ret;
+
+		/* Check if we can support this camera */
+		csi2_flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK |
+			V4L2_MBUS_CSI2_1_LANE;
+
+		switch (pdata->type) {
+		case SH_CSI2C:
+			if (priv->client->lanes != 1)
+				csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
+			break;
+		case SH_CSI2I:
+			switch (priv->client->lanes) {
+			default:
+				csi2_flags |= V4L2_MBUS_CSI2_4_LANE;
+			case 3:
+				csi2_flags |= V4L2_MBUS_CSI2_3_LANE;
+			case 2:
+				csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
+			}
+		}
+
+		ret = v4l2_subdev_call(client_sd, video, g_mbus_config, &client_cfg);
+		if (ret == -ENOIOCTLCMD)
+			common_flags = csi2_flags;
+		else if (!ret)
+			common_flags = soc_mbus_config_compatible(&client_cfg,
+								  csi2_flags);
+		else
+			common_flags = 0;
+
+		if (!common_flags)
+			return -EINVAL;
+
+		/* All good: camera MIPI configuration supported */
+		priv->mipi_flags = common_flags;
+	}
+
+	if (cfg) {
+		cfg->flags = V4L2_MBUS_PCLK_SAMPLE_RISING |
+			V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_VSYNC_ACTIVE_HIGH |
+			V4L2_MBUS_MASTER | V4L2_MBUS_DATA_ACTIVE_HIGH;
+		cfg->type = V4L2_MBUS_PARALLEL;
+	}
 
 	return 0;
 }
@@ -145,8 +195,17 @@ static int sh_csi2_s_mbus_config(struct v4l2_subdev *sd,
 	struct sh_csi2 *priv = container_of(sd, struct sh_csi2, subdev);
 	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(sd);
 	struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
-	struct v4l2_mbus_config client_cfg = {.type = V4L2_MBUS_CSI2,
-					      .flags = priv->mipi_flags};
+	struct v4l2_mbus_config client_cfg = {.type = V4L2_MBUS_CSI2,};
+	int ret = sh_csi2_g_mbus_config(sd, NULL);
+
+	if (ret < 0)
+		return ret;
+
+	pm_runtime_get_sync(&priv->pdev->dev);
+
+	sh_csi2_hwinit(priv);
+
+	client_cfg.flags = priv->mipi_flags;
 
 	return v4l2_subdev_call(client_sd, video, s_mbus_config, &client_cfg);
 }
@@ -201,19 +260,19 @@ static void sh_csi2_hwinit(struct sh_csi2 *priv)
 
 static int sh_csi2_client_connect(struct sh_csi2 *priv)
 {
-	struct sh_csi2_pdata *pdata = priv->pdev->dev.platform_data;
-	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(&priv->subdev);
-	struct v4l2_subdev *client_sd = soc_camera_to_subdev(icd);
 	struct device *dev = v4l2_get_subdevdata(&priv->subdev);
-	struct v4l2_mbus_config cfg;
-	unsigned long common_flags, csi2_flags;
-	int i, ret;
+	struct sh_csi2_pdata *pdata = dev->platform_data;
+	struct soc_camera_device *icd = v4l2_get_subdev_hostdata(&priv->subdev);
+	int i;
 
 	if (priv->client)
 		return -EBUSY;
 
 	for (i = 0; i < pdata->num_clients; i++)
-		if (&pdata->clients[i].pdev->dev == icd->pdev)
+		if ((pdata->clients[i].pdev &&
+		     &pdata->clients[i].pdev->dev == icd->pdev) ||
+		    (icd->control &&
+		     strcmp(pdata->clients[i].name, dev_name(icd->control))))
 			break;
 
 	dev_dbg(dev, "%s(%p): found #%d\n", __func__, dev, i);
@@ -221,46 +280,8 @@ static int sh_csi2_client_connect(struct sh_csi2 *priv)
 	if (i == pdata->num_clients)
 		return -ENODEV;
 
-	/* Check if we can support this camera */
-	csi2_flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK | V4L2_MBUS_CSI2_1_LANE;
-
-	switch (pdata->type) {
-	case SH_CSI2C:
-		if (pdata->clients[i].lanes != 1)
-			csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
-		break;
-	case SH_CSI2I:
-		switch (pdata->clients[i].lanes) {
-		default:
-			csi2_flags |= V4L2_MBUS_CSI2_4_LANE;
-		case 3:
-			csi2_flags |= V4L2_MBUS_CSI2_3_LANE;
-		case 2:
-			csi2_flags |= V4L2_MBUS_CSI2_2_LANE;
-		}
-	}
-
-	cfg.type = V4L2_MBUS_CSI2;
-	ret = v4l2_subdev_call(client_sd, video, g_mbus_config, &cfg);
-	if (ret == -ENOIOCTLCMD)
-		common_flags = csi2_flags;
-	else if (!ret)
-		common_flags = soc_mbus_config_compatible(&cfg,
-							  csi2_flags);
-	else
-		common_flags = 0;
-
-	if (!common_flags)
-		return -EINVAL;
-
-	/* All good: camera MIPI configuration supported */
-	priv->mipi_flags = common_flags;
 	priv->client = pdata->clients + i;
 
-	pm_runtime_get_sync(dev);
-
-	sh_csi2_hwinit(priv);
-
 	return 0;
 }
 
@@ -303,11 +324,25 @@ static __devinit int sh_csi2_probe(struct platform_device *pdev)
 	/* Platform data specify the PHY, lanes, ECC, CRC */
 	struct sh_csi2_pdata *pdata = pdev->dev.platform_data;
 
+	if (!pdata)
+		return -EINVAL;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct sh_csi2), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->asdl.subdev = &priv->subdev;
+	priv->asdl.dev = &pdev->dev;
+
+	ret = v4l2_async_subdev_bind(&priv->asdl);
+	if (ret < 0)
+		return ret;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	/* Interrupt unused so far */
 	irq = platform_get_irq(pdev, 0);
 
-	if (!res || (int)irq <= 0 || !pdata) {
+	if (!res || (int)irq <= 0) {
 		dev_err(&pdev->dev, "Not enough CSI2 platform resources.\n");
 		return -ENODEV;
 	}
@@ -318,10 +353,6 @@ static __devinit int sh_csi2_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	priv = devm_kzalloc(&pdev->dev, sizeof(struct sh_csi2), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
 	priv->irq = irq;
 
 	priv->base = devm_request_and_ioremap(&pdev->dev, res);
@@ -331,35 +362,30 @@ static __devinit int sh_csi2_probe(struct platform_device *pdev)
 	}
 
 	priv->pdev = pdev;
-	platform_set_drvdata(pdev, priv);
+	platform_set_drvdata(pdev, &priv->subdev);
 
 	v4l2_subdev_init(&priv->subdev, &sh_csi2_subdev_ops);
 	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
 
 	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s.mipi-csi",
-		 dev_name(pdata->v4l2_dev->dev));
-	ret = v4l2_device_register_subdev(pdata->v4l2_dev, &priv->subdev);
-	dev_dbg(&pdev->dev, "%s(%p): ret(register_subdev) = %d\n", __func__, priv, ret);
+		 dev_name(&pdev->dev));
+
+	ret = v4l2_async_subdev_bound(&priv->asdl);
 	if (ret < 0)
-		goto esdreg;
+		return ret;
 
 	pm_runtime_enable(&pdev->dev);
 
 	dev_dbg(&pdev->dev, "CSI2 probed.\n");
 
 	return 0;
-
-esdreg:
-	platform_set_drvdata(pdev, NULL);
-
-	return ret;
 }
 
 static __devexit int sh_csi2_remove(struct platform_device *pdev)
 {
-	struct sh_csi2 *priv = platform_get_drvdata(pdev);
+	struct v4l2_subdev *subdev = platform_get_drvdata(pdev);
 
-	v4l2_device_unregister_subdev(&priv->subdev);
+	v4l2_device_unregister_subdev(subdev);
 	pm_runtime_disable(&pdev->dev);
 	platform_set_drvdata(pdev, NULL);
 
diff --git a/include/media/sh_mobile_ceu.h b/include/media/sh_mobile_ceu.h
index 6fdb6ad..8937241 100644
--- a/include/media/sh_mobile_ceu.h
+++ b/include/media/sh_mobile_ceu.h
@@ -22,6 +22,8 @@ struct sh_mobile_ceu_info {
 	int max_width;
 	int max_height;
 	struct sh_mobile_ceu_companion *csi2;
+	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
+	int *asd_sizes;			/* 0-terminated array pf asd group sizes */
 };
 
 #endif /* __ASM_SH_MOBILE_CEU_H__ */
diff --git a/include/media/sh_mobile_csi2.h b/include/media/sh_mobile_csi2.h
index c586c4f..14030db 100644
--- a/include/media/sh_mobile_csi2.h
+++ b/include/media/sh_mobile_csi2.h
@@ -33,6 +33,7 @@ struct sh_csi2_client_config {
 	unsigned char lanes;		/* bitmask[3:0] */
 	unsigned char channel;		/* 0..3 */
 	struct platform_device *pdev;	/* client platform device */
+	const char *name;		/* async matching: client name */
 };
 
 struct v4l2_device;
@@ -42,7 +43,6 @@ struct sh_csi2_pdata {
 	unsigned int flags;
 	struct sh_csi2_client_config *clients;
 	int num_clients;
-	struct v4l2_device *v4l2_dev;
 };
 
 #endif
-- 
1.7.2.5

