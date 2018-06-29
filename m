Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34839 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965133AbeF2SxZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 14:53:25 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 15/17] media: platform: Switch to v4l2_async_notifier_add_subdev
Date: Fri, 29 Jun 2018 11:49:59 -0700
Message-Id: <1530298220-5097-16-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
References: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch all media platform drivers to call v4l2_async_notifier_add_subdev()
to add asd's to a notifier, in place of referencing the notifier->subdevs[]
array.

There may still be cases where a platform driver maintains a list of
asd's that is a duplicate of the notifier asd_list, in which case its
possible the platform driver list can be removed, and can reference the
notifier asd_list instead. One example of where a duplicate list has
been removed in this patch is xilinx-vipp.c. If there are such cases
remaining, those drivers should be optimized to remove the duplicate
platform driver asd lists.

None of the changes to the platform drivers in this patch have been
tested. Verify that the async subdevices needed by the platform are
bound at load time, and that the driver unloads and reloads correctly
with no memory leaking of asd objects.

Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c    |  80 ++++++-------
 drivers/media/platform/atmel/atmel-isc.c       |  13 ++-
 drivers/media/platform/atmel/atmel-isi.c       |  15 +--
 drivers/media/platform/cadence/cdns-csi2rx.c   |  26 +++--
 drivers/media/platform/davinci/vpif_capture.c  |  47 ++++----
 drivers/media/platform/davinci/vpif_display.c  |  23 ++--
 drivers/media/platform/exynos4-is/media-dev.c  |  30 +++--
 drivers/media/platform/exynos4-is/media-dev.h  |   1 -
 drivers/media/platform/pxa_camera.c            |  23 ++--
 drivers/media/platform/qcom/camss-8x16/camss.c |  74 ++++++------
 drivers/media/platform/qcom/camss-8x16/camss.h |   2 +-
 drivers/media/platform/rcar-vin/rcar-csi2.c    |  20 ++--
 drivers/media/platform/rcar_drif.c             |  18 +--
 drivers/media/platform/renesas-ceu.c           |  51 ++++----
 drivers/media/platform/soc_camera/soc_camera.c |  31 +++--
 drivers/media/platform/stm32/stm32-dcmi.c      |  22 ++--
 drivers/media/platform/ti-vpe/cal.c            |  34 ++++--
 drivers/media/platform/xilinx/xilinx-vipp.c    | 154 +++++++++++--------------
 drivers/media/platform/xilinx/xilinx-vipp.h    |   4 -
 19 files changed, 349 insertions(+), 319 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index b05738a..1b9af688 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2423,30 +2423,30 @@ static const struct v4l2_async_notifier_operations vpfe_async_ops = {
 };
 
 static struct vpfe_config *
-vpfe_get_pdata(struct platform_device *pdev)
+vpfe_get_pdata(struct vpfe_device *vpfe)
 {
 	struct device_node *endpoint = NULL;
 	struct v4l2_fwnode_endpoint bus_cfg;
+	struct device *dev = vpfe->pdev;
 	struct vpfe_subdev_info *sdinfo;
 	struct vpfe_config *pdata;
 	unsigned int flags;
 	unsigned int i;
 	int err;
 
-	dev_dbg(&pdev->dev, "vpfe_get_pdata\n");
+	dev_dbg(dev, "vpfe_get_pdata\n");
 
-	if (!IS_ENABLED(CONFIG_OF) || !pdev->dev.of_node)
-		return pdev->dev.platform_data;
+	if (!IS_ENABLED(CONFIG_OF) || !dev->of_node)
+		return dev->platform_data;
 
-	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return NULL;
 
 	for (i = 0; ; i++) {
 		struct device_node *rem;
 
-		endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
-						      endpoint);
+		endpoint = of_graph_get_next_endpoint(dev->of_node, endpoint);
 		if (!endpoint)
 			break;
 
@@ -2473,16 +2473,16 @@ vpfe_get_pdata(struct platform_device *pdev)
 		err = v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoint),
 						 &bus_cfg);
 		if (err) {
-			dev_err(&pdev->dev, "Could not parse the endpoint\n");
-			goto done;
+			dev_err(dev, "Could not parse the endpoint\n");
+			goto cleanup;
 		}
 
 		sdinfo->vpfe_param.bus_width = bus_cfg.bus.parallel.bus_width;
 
 		if (sdinfo->vpfe_param.bus_width < 8 ||
 			sdinfo->vpfe_param.bus_width > 16) {
-			dev_err(&pdev->dev, "Invalid bus width.\n");
-			goto done;
+			dev_err(dev, "Invalid bus width.\n");
+			goto cleanup;
 		}
 
 		flags = bus_cfg.bus.parallel.flags;
@@ -2495,29 +2495,25 @@ vpfe_get_pdata(struct platform_device *pdev)
 
 		rem = of_graph_get_remote_port_parent(endpoint);
 		if (!rem) {
-			dev_err(&pdev->dev, "Remote device at %pOF not found\n",
+			dev_err(dev, "Remote device at %pOF not found\n",
 				endpoint);
-			goto done;
+			goto cleanup;
 		}
 
-		pdata->asd[i] = devm_kzalloc(&pdev->dev,
-					     sizeof(struct v4l2_async_subdev),
-					     GFP_KERNEL);
-		if (!pdata->asd[i]) {
+		pdata->asd[i] = v4l2_async_notifier_add_fwnode_subdev(
+			&vpfe->notifier, of_fwnode_handle(rem),
+			sizeof(struct v4l2_async_subdev));
+		if (IS_ERR(pdata->asd[i])) {
 			of_node_put(rem);
-			pdata = NULL;
-			goto done;
+			goto cleanup;
 		}
-
-		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		pdata->asd[i]->match.fwnode = of_fwnode_handle(rem);
-		of_node_put(rem);
 	}
 
 	of_node_put(endpoint);
 	return pdata;
 
-done:
+cleanup:
+	v4l2_async_notifier_cleanup(&vpfe->notifier);
 	of_node_put(endpoint);
 	return NULL;
 }
@@ -2529,34 +2525,39 @@ vpfe_get_pdata(struct platform_device *pdev)
  */
 static int vpfe_probe(struct platform_device *pdev)
 {
-	struct vpfe_config *vpfe_cfg = vpfe_get_pdata(pdev);
+	struct vpfe_config *vpfe_cfg;
 	struct vpfe_device *vpfe;
 	struct vpfe_ccdc *ccdc;
 	struct resource	*res;
 	int ret;
 
-	if (!vpfe_cfg) {
-		dev_err(&pdev->dev, "No platform data\n");
-		return -EINVAL;
-	}
-
 	vpfe = devm_kzalloc(&pdev->dev, sizeof(*vpfe), GFP_KERNEL);
 	if (!vpfe)
 		return -ENOMEM;
 
 	vpfe->pdev = &pdev->dev;
+
+	vpfe_cfg = vpfe_get_pdata(vpfe);
+	if (!vpfe_cfg) {
+		dev_err(&pdev->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
 	vpfe->cfg = vpfe_cfg;
 	ccdc = &vpfe->ccdc;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	ccdc->ccdc_cfg.base_addr = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(ccdc->ccdc_cfg.base_addr))
-		return PTR_ERR(ccdc->ccdc_cfg.base_addr);
+	if (IS_ERR(ccdc->ccdc_cfg.base_addr)) {
+		ret = PTR_ERR(ccdc->ccdc_cfg.base_addr);
+		goto probe_out_cleanup;
+	}
 
 	ret = platform_get_irq(pdev, 0);
 	if (ret <= 0) {
 		dev_err(&pdev->dev, "No IRQ resource\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto probe_out_cleanup;
 	}
 	vpfe->irq = ret;
 
@@ -2564,14 +2565,15 @@ static int vpfe_probe(struct platform_device *pdev)
 			       "vpfe_capture0", vpfe);
 	if (ret) {
 		dev_err(&pdev->dev, "Unable to request interrupt\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto probe_out_cleanup;
 	}
 
 	ret = v4l2_device_register(&pdev->dev, &vpfe->v4l2_dev);
 	if (ret) {
 		vpfe_err(vpfe,
 			"Unable to register v4l2 device.\n");
-		return ret;
+		goto probe_out_cleanup;
 	}
 
 	/* set the driver data in platform device */
@@ -2595,11 +2597,8 @@ static int vpfe_probe(struct platform_device *pdev)
 		goto probe_out_v4l2_unregister;
 	}
 
-	vpfe->notifier.subdevs = vpfe->cfg->asd;
-	vpfe->notifier.num_subdevs = ARRAY_SIZE(vpfe->cfg->asd);
 	vpfe->notifier.ops = &vpfe_async_ops;
-	ret = v4l2_async_notifier_register(&vpfe->v4l2_dev,
-						&vpfe->notifier);
+	ret = v4l2_async_notifier_register(&vpfe->v4l2_dev, &vpfe->notifier);
 	if (ret) {
 		vpfe_err(vpfe, "Error registering async notifier\n");
 		ret = -EINVAL;
@@ -2610,6 +2609,8 @@ static int vpfe_probe(struct platform_device *pdev)
 
 probe_out_v4l2_unregister:
 	v4l2_device_unregister(&vpfe->v4l2_dev);
+probe_out_cleanup:
+	v4l2_async_notifier_cleanup(&vpfe->notifier);
 	return ret;
 }
 
@@ -2625,6 +2626,7 @@ static int vpfe_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 
 	v4l2_async_notifier_unregister(&vpfe->notifier);
+	v4l2_async_notifier_cleanup(&vpfe->notifier);
 	v4l2_device_unregister(&vpfe->v4l2_dev);
 	video_unregister_device(&vpfe->video_dev);
 
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d89e145..ec1a8df 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1983,8 +1983,10 @@ static void isc_subdev_cleanup(struct isc_device *isc)
 {
 	struct isc_subdev_entity *subdev_entity;
 
-	list_for_each_entry(subdev_entity, &isc->subdev_entities, list)
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list) {
 		v4l2_async_notifier_unregister(&subdev_entity->notifier);
+		v4l2_async_notifier_cleanup(&subdev_entity->notifier);
+	}
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
 }
@@ -2201,8 +2203,13 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	}
 
 	list_for_each_entry(subdev_entity, &isc->subdev_entities, list) {
-		subdev_entity->notifier.subdevs = &subdev_entity->asd;
-		subdev_entity->notifier.num_subdevs = 1;
+		ret = v4l2_async_notifier_add_subdev(&subdev_entity->notifier,
+						     subdev_entity->asd);
+		if (ret) {
+			fwnode_handle_put(subdev_entity->asd->match.fwnode);
+			goto cleanup_subdev;
+		}
+
 		subdev_entity->notifier.ops = &isc_async_ops;
 
 		ret = v4l2_async_notifier_register(&isc->v4l2_dev,
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index e8db4df..f58d75c 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1124,7 +1124,6 @@ static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
 
 static int isi_graph_init(struct atmel_isi *isi)
 {
-	struct v4l2_async_subdev **subdevs = NULL;
 	int ret;
 
 	/* Parse the graph to extract a list of subdevice DT nodes. */
@@ -1134,23 +1133,18 @@ static int isi_graph_init(struct atmel_isi *isi)
 		return ret;
 	}
 
-	/* Register the subdevices notifier. */
-	subdevs = devm_kzalloc(isi->dev, sizeof(*subdevs), GFP_KERNEL);
-	if (!subdevs) {
+	ret = v4l2_async_notifier_add_subdev(&isi->notifier, &isi->entity.asd);
+	if (ret) {
 		of_node_put(isi->entity.node);
-		return -ENOMEM;
+		return ret;
 	}
 
-	subdevs[0] = &isi->entity.asd;
-
-	isi->notifier.subdevs = subdevs;
-	isi->notifier.num_subdevs = 1;
 	isi->notifier.ops = &isi_graph_notify_ops;
 
 	ret = v4l2_async_notifier_register(&isi->v4l2_dev, &isi->notifier);
 	if (ret < 0) {
 		dev_err(isi->dev, "Notifier registration failed\n");
-		of_node_put(isi->entity.node);
+		v4l2_async_notifier_cleanup(&isi->notifier);
 		return ret;
 	}
 
@@ -1303,6 +1297,7 @@ static int atmel_isi_remove(struct platform_device *pdev)
 			isi->fb_descriptors_phys);
 	pm_runtime_disable(&pdev->dev);
 	v4l2_async_notifier_unregister(&isi->notifier);
+	v4l2_async_notifier_cleanup(&isi->notifier);
 	v4l2_device_unregister(&isi->v4l2_dev);
 
 	return 0;
diff --git a/drivers/media/platform/cadence/cdns-csi2rx.c b/drivers/media/platform/cadence/cdns-csi2rx.c
index 43e43c7..8df32e6 100644
--- a/drivers/media/platform/cadence/cdns-csi2rx.c
+++ b/drivers/media/platform/cadence/cdns-csi2rx.c
@@ -399,18 +399,20 @@ static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
 	csi2rx->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	of_node_put(ep);
 
-	csi2rx->notifier.subdevs = devm_kzalloc(csi2rx->dev,
-						sizeof(*csi2rx->notifier.subdevs),
-						GFP_KERNEL);
-	if (!csi2rx->notifier.subdevs)
-		return -ENOMEM;
+	ret = v4l2_async_notifier_add_subdev(&csi2rx->notifier, &csi2rx->asd);
+	if (ret) {
+		fwnode_handle_put(csi2rx->asd.match.fwnode);
+		return ret;
+	}
 
-	csi2rx->notifier.subdevs[0] = &csi2rx->asd;
-	csi2rx->notifier.num_subdevs = 1;
 	csi2rx->notifier.ops = &csi2rx_notifier_ops;
 
-	return v4l2_async_subdev_notifier_register(&csi2rx->subdev,
-						   &csi2rx->notifier);
+	ret = v4l2_async_subdev_notifier_register(&csi2rx->subdev,
+						  &csi2rx->notifier);
+	if (ret)
+		v4l2_async_notifier_cleanup(&csi2rx->notifier);
+
+	return ret;
 }
 
 static int csi2rx_probe(struct platform_device *pdev)
@@ -450,11 +452,11 @@ static int csi2rx_probe(struct platform_device *pdev)
 	ret = media_entity_pads_init(&csi2rx->subdev.entity, CSI2RX_PAD_MAX,
 				     csi2rx->pads);
 	if (ret)
-		goto err_free_priv;
+		goto err_cleanup;
 
 	ret = v4l2_async_register_subdev(&csi2rx->subdev);
 	if (ret < 0)
-		goto err_free_priv;
+		goto err_cleanup;
 
 	dev_info(&pdev->dev,
 		 "Probed CSI2RX with %u/%u lanes, %u streams, %s D-PHY\n",
@@ -463,6 +465,8 @@ static int csi2rx_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_cleanup:
+	v4l2_async_notifier_cleanup(&csi2rx->notifier);
 err_free_priv:
 	kfree(csi2rx);
 	return ret;
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a96f53c..8464ceb 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1553,7 +1553,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 					    sizeof(*chan->inputs),
 					    GFP_KERNEL);
 		if (!chan->inputs)
-			return NULL;
+			goto err_cleanup;
 
 		chan->input_count++;
 		chan->inputs[i].input.type = V4L2_INPUT_TYPE_CAMERA;
@@ -1587,28 +1587,30 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 			rem->name, rem);
 		sdinfo->name = rem->full_name;
 
-		pdata->asd[i] = devm_kzalloc(&pdev->dev,
-					     sizeof(struct v4l2_async_subdev),
-					     GFP_KERNEL);
-		if (!pdata->asd[i]) {
+		pdata->asd[i] = v4l2_async_notifier_add_fwnode_subdev(
+			&vpif_obj.notifier, of_fwnode_handle(rem),
+			sizeof(struct v4l2_async_subdev));
+		if (IS_ERR(pdata->asd[i])) {
 			of_node_put(rem);
-			pdata = NULL;
-			goto done;
+			goto err_cleanup;
 		}
 
-		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		pdata->asd[i]->match.fwnode = of_fwnode_handle(rem);
-		of_node_put(rem);
+		of_node_put(endpoint);
 	}
 
 done:
-	if (pdata) {
-		pdata->asd_sizes[0] = i;
-		pdata->subdev_count = i;
-		pdata->card_name = "DA850/OMAP-L138 Video Capture";
-	}
+	of_node_put(endpoint);
+	pdata->asd_sizes[0] = i;
+	pdata->subdev_count = i;
+	pdata->card_name = "DA850/OMAP-L138 Video Capture";
 
 	return pdata;
+
+err_cleanup:
+	v4l2_async_notifier_cleanup(&vpif_obj.notifier);
+	of_node_put(endpoint);
+
+	return NULL;
 }
 
 /**
@@ -1633,23 +1635,18 @@ static __init int vpif_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!pdev->dev.platform_data) {
-		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
-		return -EINVAL;
-	}
-
 	vpif_dev = &pdev->dev;
 
 	err = initialize_vpif();
 	if (err) {
 		v4l2_err(vpif_dev->driver, "Error initializing vpif\n");
-		return err;
+		goto cleanup;
 	}
 
 	err = v4l2_device_register(vpif_dev, &vpif_obj.v4l2_dev);
 	if (err) {
 		v4l2_err(vpif_dev->driver, "Error registering v4l2 device\n");
-		return err;
+		goto cleanup;
 	}
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
@@ -1698,8 +1695,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 		vpif_probe_complete();
 	} else {
-		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
-		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
 		vpif_obj.notifier.ops = &vpif_async_ops;
 		err = v4l2_async_notifier_register(&vpif_obj.v4l2_dev,
 						   &vpif_obj.notifier);
@@ -1717,6 +1712,8 @@ static __init int vpif_probe(struct platform_device *pdev)
 	kfree(vpif_obj.sd);
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
+cleanup:
+	v4l2_async_notifier_cleanup(&vpif_obj.notifier);
 
 	return err;
 }
@@ -1732,6 +1729,8 @@ static int vpif_remove(struct platform_device *device)
 	struct channel_obj *ch;
 	int i;
 
+	v4l2_async_notifier_unregister(&vpif_obj.notifier);
+	v4l2_async_notifier_cleanup(&vpif_obj.notifier);
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
 	kfree(vpif_obj.sd);
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 7be6362..2166a18 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1255,11 +1255,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	if (!pdev->dev.platform_data) {
-		dev_warn(&pdev->dev, "Missing platform data.  Giving up.\n");
-		return -EINVAL;
-	}
-
 	vpif_dev = &pdev->dev;
 	err = initialize_vpif();
 
@@ -1316,20 +1311,27 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 		vpif_probe_complete();
 	} else {
-		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
-		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
+		for (i = 0; i < vpif_obj.config->asd_sizes[0]; i++) {
+			err = v4l2_async_notifier_add_subdev(
+				&vpif_obj.notifier, vpif_obj.config->asd[i]);
+			if (err)
+				goto probe_cleanup;
+		}
+
 		vpif_obj.notifier.ops = &vpif_async_ops;
 		err = v4l2_async_notifier_register(&vpif_obj.v4l2_dev,
 						   &vpif_obj.notifier);
 		if (err) {
 			vpif_err("Error registering async notifier\n");
 			err = -EINVAL;
-			goto probe_subdev_out;
+			goto probe_cleanup;
 		}
 	}
 
 	return 0;
 
+probe_cleanup:
+	v4l2_async_notifier_cleanup(&vpif_obj.notifier);
 probe_subdev_out:
 	kfree(vpif_obj.sd);
 vpif_unregister:
@@ -1346,6 +1348,11 @@ static int vpif_remove(struct platform_device *device)
 	struct channel_obj *ch;
 	int i;
 
+	if (vpif_obj.config->asd_sizes) {
+		v4l2_async_notifier_unregister(&vpif_obj.notifier);
+		v4l2_async_notifier_cleanup(&vpif_obj.notifier);
+	}
+
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
 
 	kfree(vpif_obj.sd);
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 78b48a1..fff3a37 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -457,11 +457,16 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 
 	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	fmd->sensor[index].asd.match.fwnode = of_fwnode_handle(rem);
-	fmd->async_subdevs[index] = &fmd->sensor[index].asd;
+
+	ret = v4l2_async_notifier_add_subdev(&fmd->subdev_notifier,
+					     &fmd->sensor[index].asd);
+	if (ret) {
+		of_node_put(rem);
+		return ret;
+	}
 
 	fmd->num_sensors++;
 
-	of_node_put(rem);
 	return 0;
 }
 
@@ -500,7 +505,7 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 		ret = fimc_md_parse_port_node(fmd, port, index);
 		if (ret < 0) {
 			of_node_put(node);
-			goto rpm_put;
+			goto cleanup;
 		}
 		index++;
 	}
@@ -514,12 +519,18 @@ static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
 		ret = fimc_md_parse_port_node(fmd, node, index);
 		if (ret < 0) {
 			of_node_put(node);
-			break;
+			goto cleanup;
 		}
 		index++;
 	}
+
 rpm_put:
 	pm_runtime_put(fmd->pmf);
+	return 0;
+
+cleanup:
+	v4l2_async_notifier_cleanup(&fmd->subdev_notifier);
+	pm_runtime_put(fmd->pmf);
 	return ret;
 }
 
@@ -1472,7 +1483,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 
 	ret = device_create_file(&pdev->dev, &dev_attr_subdev_conf_mode);
 	if (ret)
-		goto err_m_ent;
+		goto err_cleanup;
 	/*
 	 * FIMC platform devices need to be registered before the sclk_cam
 	 * clocks provider, as one of these devices needs to be activated
@@ -1485,8 +1496,6 @@ static int fimc_md_probe(struct platform_device *pdev)
 	}
 
 	if (fmd->num_sensors > 0) {
-		fmd->subdev_notifier.subdevs = fmd->async_subdevs;
-		fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
 		fmd->subdev_notifier.ops = &subdev_notifier_ops;
 		fmd->num_sensors = 0;
 
@@ -1502,10 +1511,12 @@ static int fimc_md_probe(struct platform_device *pdev)
 	fimc_md_unregister_clk_provider(fmd);
 err_attr:
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
-err_clk:
-	fimc_md_put_clocks(fmd);
+err_cleanup:
+	v4l2_async_notifier_cleanup(&fmd->subdev_notifier);
 err_m_ent:
 	fimc_md_unregister_entities(fmd);
+err_clk:
+	fimc_md_put_clocks(fmd);
 err_md:
 	media_device_cleanup(&fmd->media_dev);
 	v4l2_device_unregister(&fmd->v4l2_dev);
@@ -1521,6 +1532,7 @@ static int fimc_md_remove(struct platform_device *pdev)
 
 	fimc_md_unregister_clk_provider(fmd);
 	v4l2_async_notifier_unregister(&fmd->subdev_notifier);
+	v4l2_async_notifier_cleanup(&fmd->subdev_notifier);
 
 	v4l2_device_unregister(&fmd->v4l2_dev);
 	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
index 957787a..9f52767 100644
--- a/drivers/media/platform/exynos4-is/media-dev.h
+++ b/drivers/media/platform/exynos4-is/media-dev.h
@@ -149,7 +149,6 @@ struct fimc_md {
 	} clk_provider;
 
 	struct v4l2_async_notifier subdev_notifier;
-	struct v4l2_async_subdev *async_subdevs[FIMC_MAX_SENSORS];
 
 	bool user_subdev_api;
 	spinlock_t slock;
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index d85ffbf..8fc3072 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -697,7 +697,6 @@ struct pxa_camera_dev {
 	struct v4l2_pix_format	current_pix;
 
 	struct v4l2_async_subdev asd;
-	struct v4l2_async_subdev *asds[1];
 
 	/*
 	 * PXA27x is only supposed to handle one camera on its Quick Capture
@@ -2352,12 +2351,10 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	remote = of_graph_get_remote_port(np);
-	if (remote) {
+	if (remote)
 		asd->match.fwnode = of_fwnode_handle(remote);
-		of_node_put(remote);
-	} else {
+	else
 		dev_notice(dev, "no remote for %pOF\n", np);
-	}
 
 out:
 	of_node_put(np);
@@ -2511,9 +2508,12 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	if (err)
 		goto exit_deactivate;
 
-	pcdev->asds[0] = &pcdev->asd;
-	pcdev->notifier.subdevs = pcdev->asds;
-	pcdev->notifier.num_subdevs = 1;
+	err = v4l2_async_notifier_add_subdev(&pcdev->notifier, &pcdev->asd);
+	if (err) {
+		fwnode_handle_put(pcdev->asd.match.fwnode);
+		goto exit_free_v4l2dev;
+	}
+
 	pcdev->notifier.ops = &pxa_camera_sensor_ops;
 
 	if (!of_have_populated_dt())
@@ -2521,7 +2521,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	err = pxa_camera_init_videobuf2(pcdev);
 	if (err)
-		goto exit_free_v4l2dev;
+		goto exit_notifier_cleanup;
 
 	if (pcdev->mclk) {
 		v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
@@ -2532,7 +2532,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 						    clk_name, NULL);
 		if (IS_ERR(pcdev->mclk_clk)) {
 			err = PTR_ERR(pcdev->mclk_clk);
-			goto exit_free_v4l2dev;
+			goto exit_notifier_cleanup;
 		}
 	}
 
@@ -2543,6 +2543,8 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	return 0;
 exit_free_clk:
 	v4l2_clk_unregister(pcdev->mclk_clk);
+exit_notifier_cleanup:
+	v4l2_async_notifier_cleanup(&pcdev->notifier);
 exit_free_v4l2dev:
 	v4l2_device_unregister(&pcdev->v4l2_dev);
 exit_deactivate:
@@ -2566,6 +2568,7 @@ static int pxa_camera_remove(struct platform_device *pdev)
 	dma_release_channel(pcdev->dma_chans[2]);
 
 	v4l2_async_notifier_unregister(&pcdev->notifier);
+	v4l2_async_notifier_cleanup(&pcdev->notifier);
 
 	if (pcdev->mclk_clk) {
 		v4l2_clk_unregister(pcdev->mclk_clk);
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
index 23fda62..35581e7 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss.c
@@ -292,60 +292,49 @@ static int camss_of_parse_endpoint_node(struct device *dev,
  *
  * Return number of "port" nodes found in "ports" node
  */
-static int camss_of_parse_ports(struct device *dev,
-				struct v4l2_async_notifier *notifier)
+static int camss_of_parse_ports(struct camss *camss)
 {
+	struct device *dev = camss->dev;
 	struct device_node *node = NULL;
 	struct device_node *remote = NULL;
-	unsigned int size, i;
 	int ret;
 
-	while ((node = of_graph_get_next_endpoint(dev->of_node, node)))
-		if (of_device_is_available(node))
-			notifier->num_subdevs++;
-
-	size = sizeof(*notifier->subdevs) * notifier->num_subdevs;
-	notifier->subdevs = devm_kzalloc(dev, size, GFP_KERNEL);
-	if (!notifier->subdevs) {
-		dev_err(dev, "Failed to allocate memory\n");
-		return -ENOMEM;
-	}
-
-	i = 0;
-	while ((node = of_graph_get_next_endpoint(dev->of_node, node))) {
+	for_each_endpoint_of_node(dev->of_node, node) {
 		struct camss_async_subdev *csd;
+		struct v4l2_async_subdev *asd;
 
 		if (!of_device_is_available(node))
 			continue;
 
-		csd = devm_kzalloc(dev, sizeof(*csd), GFP_KERNEL);
-		if (!csd) {
-			of_node_put(node);
-			dev_err(dev, "Failed to allocate memory\n");
-			return -ENOMEM;
-		}
-
-		notifier->subdevs[i++] = &csd->asd;
-
-		ret = camss_of_parse_endpoint_node(dev, node, csd);
-		if (ret < 0) {
-			of_node_put(node);
-			return ret;
-		}
-
 		remote = of_graph_get_remote_port_parent(node);
-		of_node_put(node);
-
 		if (!remote) {
 			dev_err(dev, "Cannot get remote parent\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_cleanup;
+		}
+
+		asd = v4l2_async_notifier_add_fwnode_subdev(
+			&camss->notifier, of_fwnode_handle(remote),
+			sizeof(*csd));
+		if (IS_ERR(asd)) {
+			ret = PTR_ERR(asd);
+			of_node_put(remote);
+			goto err_cleanup;
 		}
 
-		csd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		csd->asd.match.fwnode = of_fwnode_handle(remote);
+		csd = container_of(asd, struct camss_async_subdev, asd);
+
+		ret = camss_of_parse_endpoint_node(dev, node, csd);
+		if (ret < 0)
+			goto err_cleanup;
 	}
 
-	return notifier->num_subdevs;
+	return camss->notifier.num_subdevs;
+
+err_cleanup:
+	v4l2_async_notifier_cleanup(&camss->notifier);
+	of_node_put(node);
+	return ret;
 }
 
 /*
@@ -631,17 +620,17 @@ static int camss_probe(struct platform_device *pdev)
 	camss->dev = dev;
 	platform_set_drvdata(pdev, camss);
 
-	ret = camss_of_parse_ports(dev, &camss->notifier);
+	ret = camss_of_parse_ports(camss);
 	if (ret < 0)
 		return ret;
 
 	ret = camss_init_subdevices(camss);
 	if (ret < 0)
-		return ret;
+		goto err_cleanup;
 
 	ret = dma_set_mask_and_coherent(dev, 0xffffffff);
 	if (ret)
-		return ret;
+		goto err_cleanup;
 
 	camss->media_dev.dev = camss->dev;
 	strlcpy(camss->media_dev.model, "Qualcomm Camera Subsystem",
@@ -653,7 +642,7 @@ static int camss_probe(struct platform_device *pdev)
 	ret = v4l2_device_register(camss->dev, &camss->v4l2_dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to register V4L2 device: %d\n", ret);
-		return ret;
+		goto err_cleanup;
 	}
 
 	ret = camss_register_entities(camss);
@@ -693,6 +682,8 @@ static int camss_probe(struct platform_device *pdev)
 	camss_unregister_entities(camss);
 err_register_entities:
 	v4l2_device_unregister(&camss->v4l2_dev);
+err_cleanup:
+	v4l2_async_notifier_cleanup(&camss->notifier);
 
 	return ret;
 }
@@ -719,6 +710,7 @@ static int camss_remove(struct platform_device *pdev)
 	msm_vfe_stop_streaming(&camss->vfe);
 
 	v4l2_async_notifier_unregister(&camss->notifier);
+	v4l2_async_notifier_cleanup(&camss->notifier);
 	camss_unregister_entities(camss);
 
 	if (atomic_read(&camss->ref_count) == 0)
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.h b/drivers/media/platform/qcom/camss-8x16/camss.h
index 4ad2234..eab89b0 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss.h
@@ -85,8 +85,8 @@ struct camss_camera_interface {
 };
 
 struct camss_async_subdev {
+	struct v4l2_async_subdev asd; /* must be first */
 	struct camss_camera_interface interface;
-	struct v4l2_async_subdev asd;
 };
 
 struct camss_clock {
diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index daef72d..762a8a1 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -763,21 +763,23 @@ static int rcsi2_parse_dt(struct rcar_csi2 *priv)
 
 	of_node_put(ep);
 
-	priv->notifier.subdevs = devm_kzalloc(priv->dev,
-					      sizeof(*priv->notifier.subdevs),
-					      GFP_KERNEL);
-	if (!priv->notifier.subdevs)
-		return -ENOMEM;
+	ret = v4l2_async_notifier_add_subdev(&priv->notifier, &priv->asd);
+	if (ret) {
+		fwnode_handle_put(priv->asd.match.fwnode);
+		return ret;
+	}
 
-	priv->notifier.num_subdevs = 1;
-	priv->notifier.subdevs[0] = &priv->asd;
 	priv->notifier.ops = &rcar_csi2_notify_ops;
 
 	dev_dbg(priv->dev, "Found '%pOF'\n",
 		to_of_node(priv->asd.match.fwnode));
 
-	return v4l2_async_subdev_notifier_register(&priv->subdev,
-						   &priv->notifier);
+	ret = v4l2_async_subdev_notifier_register(&priv->subdev,
+						  &priv->notifier);
+	if (ret)
+		v4l2_async_notifier_cleanup(&priv->notifier);
+
+	return ret;
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index dc7e280..7338c52 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1217,18 +1217,13 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
 {
 	struct v4l2_async_notifier *notifier = &sdr->notifier;
 	struct fwnode_handle *fwnode, *ep;
-
-	notifier->subdevs = devm_kzalloc(sdr->dev, sizeof(*notifier->subdevs),
-					 GFP_KERNEL);
-	if (!notifier->subdevs)
-		return -ENOMEM;
+	int ret;
 
 	ep = fwnode_graph_get_next_endpoint(of_fwnode_handle(sdr->dev->of_node),
 					    NULL);
 	if (!ep)
 		return 0;
 
-	notifier->subdevs[notifier->num_subdevs] = &sdr->ep.asd;
 	fwnode = fwnode_graph_get_remote_port_parent(ep);
 	if (!fwnode) {
 		dev_warn(sdr->dev, "bad remote port parent\n");
@@ -1238,7 +1233,11 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
 
 	sdr->ep.asd.match.fwnode = fwnode;
 	sdr->ep.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-	notifier->num_subdevs++;
+	ret = v4l2_async_notifier_add_subdev(notifier, &sdr->ep.asd);
+	if (ret) {
+		fwnode_handle_put(fwnode);
+		return ret;
+	}
 
 	/* Get the endpoint properties */
 	rcar_drif_get_ep_properties(sdr, ep);
@@ -1360,11 +1359,13 @@ static int rcar_drif_sdr_probe(struct rcar_drif_sdr *sdr)
 	ret = v4l2_async_notifier_register(&sdr->v4l2_dev, &sdr->notifier);
 	if (ret < 0) {
 		dev_err(sdr->dev, "failed: notifier register ret %d\n", ret);
-		goto error;
+		goto cleanup;
 	}
 
 	return ret;
 
+cleanup:
+	v4l2_async_notifier_cleanup(&sdr->notifier);
 error:
 	v4l2_device_unregister(&sdr->v4l2_dev);
 
@@ -1375,6 +1376,7 @@ static int rcar_drif_sdr_probe(struct rcar_drif_sdr *sdr)
 static void rcar_drif_sdr_remove(struct rcar_drif_sdr *sdr)
 {
 	v4l2_async_notifier_unregister(&sdr->notifier);
+	v4l2_async_notifier_cleanup(&sdr->notifier);
 	v4l2_device_unregister(&sdr->v4l2_dev);
 }
 
diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index ad78290..b4c06cb 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -189,8 +189,6 @@ struct ceu_device {
 
 	/* async subdev notification helpers */
 	struct v4l2_async_notifier notifier;
-	/* pointers to "struct ceu_subdevice -> asd" */
-	struct v4l2_async_subdev **asds;
 
 	/* vb2 queue, capture buffer list and active buffer pointer */
 	struct vb2_queue	vb2_vq;
@@ -1482,15 +1480,6 @@ static int ceu_init_async_subdevs(struct ceu_device *ceudev, unsigned int n_sd)
 	if (!ceudev->subdevs)
 		return -ENOMEM;
 
-	/*
-	 * Reserve memory for 'n_sd' pointers to async_subdevices.
-	 * ceudev->asds members will point to &ceu_subdev.asd
-	 */
-	ceudev->asds = devm_kcalloc(ceudev->dev, n_sd,
-				    sizeof(*ceudev->asds), GFP_KERNEL);
-	if (!ceudev->asds)
-		return -ENOMEM;
-
 	ceudev->sd = NULL;
 	ceudev->sd_index = 0;
 	ceudev->num_sd = 0;
@@ -1518,6 +1507,7 @@ static int ceu_parse_platform_data(struct ceu_device *ceudev,
 		return ret;
 
 	for (i = 0; i < pdata->num_subdevs; i++) {
+
 		/* Setup the ceu subdevice and the async subdevice. */
 		async_sd = &pdata->subdevs[i];
 		ceu_sd = &ceudev->subdevs[i];
@@ -1529,7 +1519,12 @@ static int ceu_parse_platform_data(struct ceu_device *ceudev,
 		ceu_sd->asd.match.i2c.adapter_id = async_sd->i2c_adapter_id;
 		ceu_sd->asd.match.i2c.address = async_sd->i2c_address;
 
-		ceudev->asds[i] = &ceu_sd->asd;
+		ret = v4l2_async_notifier_add_subdev(&ceudev->notifier,
+						     &ceu_sd->asd);
+		if (ret) {
+			v4l2_async_notifier_cleanup(&ceudev->notifier);
+			return ret;
+		}
 	}
 
 	return pdata->num_subdevs;
@@ -1542,8 +1537,8 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
 {
 	struct device_node *of = ceudev->dev->of_node;
 	struct v4l2_fwnode_endpoint fw_ep;
+	struct device_node *ep, *remote;
 	struct ceu_subdev *ceu_sd;
-	struct device_node *ep;
 	unsigned int i;
 	int num_ep;
 	int ret;
@@ -1562,40 +1557,46 @@ static int ceu_parse_dt(struct ceu_device *ceudev)
 			dev_err(ceudev->dev,
 				"No subdevice connected on endpoint %u.\n", i);
 			ret = -ENODEV;
-			goto error_put_node;
+			goto error_cleanup;
 		}
 
 		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &fw_ep);
 		if (ret) {
 			dev_err(ceudev->dev,
 				"Unable to parse endpoint #%u.\n", i);
-			goto error_put_node;
+			goto error_cleanup;
 		}
 
 		if (fw_ep.bus_type != V4L2_MBUS_PARALLEL) {
 			dev_err(ceudev->dev,
 				"Only parallel input supported.\n");
 			ret = -EINVAL;
-			goto error_put_node;
+			goto error_cleanup;
 		}
 
 		/* Setup the ceu subdevice and the async subdevice. */
 		ceu_sd = &ceudev->subdevs[i];
 		INIT_LIST_HEAD(&ceu_sd->asd.list);
 
+		remote = of_graph_get_remote_port_parent(ep);
 		ceu_sd->mbus_flags = fw_ep.bus.parallel.flags;
 		ceu_sd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		ceu_sd->asd.match.fwnode =
-			fwnode_graph_get_remote_port_parent(
-					of_fwnode_handle(ep));
+		ceu_sd->asd.match.fwnode = of_fwnode_handle(remote);
+
+		ret = v4l2_async_notifier_add_subdev(&ceudev->notifier,
+						     &ceu_sd->asd);
+		if (ret) {
+			of_node_put(remote);
+			goto error_cleanup;
+		}
 
-		ceudev->asds[i] = &ceu_sd->asd;
 		of_node_put(ep);
 	}
 
 	return num_ep;
 
-error_put_node:
+error_cleanup:
+	v4l2_async_notifier_cleanup(&ceudev->notifier);
 	of_node_put(ep);
 	return ret;
 }
@@ -1693,18 +1694,18 @@ static int ceu_probe(struct platform_device *pdev)
 	ceudev->irq_mask = ceu_data->irq_mask;
 
 	ceudev->notifier.v4l2_dev	= &ceudev->v4l2_dev;
-	ceudev->notifier.subdevs	= ceudev->asds;
-	ceudev->notifier.num_subdevs	= num_subdevs;
 	ceudev->notifier.ops		= &ceu_notify_ops;
 	ret = v4l2_async_notifier_register(&ceudev->v4l2_dev,
 					   &ceudev->notifier);
 	if (ret)
-		goto error_v4l2_unregister;
+		goto error_cleanup;
 
 	dev_info(dev, "Renesas Capture Engine Unit %s\n", dev_name(dev));
 
 	return 0;
 
+error_cleanup:
+	v4l2_async_notifier_cleanup(&ceudev->notifier);
 error_v4l2_unregister:
 	v4l2_device_unregister(&ceudev->v4l2_dev);
 error_pm_disable:
@@ -1723,6 +1724,8 @@ static int ceu_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&ceudev->notifier);
 
+	v4l2_async_notifier_cleanup(&ceudev->notifier);
+
 	v4l2_device_unregister(&ceudev->v4l2_dev);
 
 	video_unregister_device(&ceudev->vdev);
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 66d6136..1847958 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1442,8 +1442,12 @@ static int scan_async_group(struct soc_camera_host *ici,
 		goto eaddpdev;
 	}
 
-	sasc->notifier.subdevs = asd;
-	sasc->notifier.num_subdevs = size;
+	for (i = 0; i < size; i++) {
+		ret = v4l2_async_notifier_add_subdev(&sasc->notifier, asd[i]);
+		if (ret)
+			goto eaddasd;
+	}
+
 	sasc->notifier.ops = &soc_camera_async_ops;
 
 	icd->sasc = sasc;
@@ -1466,6 +1470,8 @@ static int scan_async_group(struct soc_camera_host *ici,
 	v4l2_clk_unregister(icd->clk);
 eclkreg:
 	icd->clk = NULL;
+eaddasd:
+	v4l2_async_notifier_cleanup(&sasc->notifier);
 	platform_device_del(sasc->pdev);
 eaddpdev:
 	platform_device_put(sasc->pdev);
@@ -1540,8 +1546,12 @@ static int soc_of_bind(struct soc_camera_host *ici,
 		goto eaddpdev;
 	}
 
-	sasc->notifier.subdevs = &info->subdev;
-	sasc->notifier.num_subdevs = 1;
+	ret = v4l2_async_notifier_add_subdev(&sasc->notifier, info->subdev);
+	if (ret) {
+		of_node_put(remote);
+		goto eaddasd;
+	}
+
 	sasc->notifier.ops = &soc_camera_async_ops;
 
 	icd->sasc = sasc;
@@ -1568,6 +1578,8 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	v4l2_clk_unregister(icd->clk);
 eclkreg:
 	icd->clk = NULL;
+eaddasd:
+	v4l2_async_notifier_cleanup(&sasc->notifier);
 	platform_device_del(sasc->pdev);
 eaddpdev:
 	platform_device_put(sasc->pdev);
@@ -1582,7 +1594,7 @@ static void scan_of_host(struct soc_camera_host *ici)
 {
 	struct device *dev = ici->v4l2_dev.dev;
 	struct device_node *np = dev->of_node;
-	struct device_node *epn = NULL, *ren;
+	struct device_node *epn = NULL, *rem;
 	unsigned int i;
 
 	for (i = 0; ; i++) {
@@ -1590,17 +1602,15 @@ static void scan_of_host(struct soc_camera_host *ici)
 		if (!epn)
 			break;
 
-		ren = of_graph_get_remote_port(epn);
-		if (!ren) {
+		rem = of_graph_get_remote_port_parent(epn);
+		if (!rem) {
 			dev_notice(dev, "no remote for %pOF\n", epn);
 			continue;
 		}
 
 		/* so we now have a remote node to connect */
 		if (!i)
-			soc_of_bind(ici, epn, ren->parent);
-
-		of_node_put(ren);
+			soc_of_bind(ici, epn, rem);
 
 		if (i) {
 			dev_err(dev, "multiple subdevices aren't supported yet!\n");
@@ -1926,6 +1936,7 @@ void soc_camera_host_unregister(struct soc_camera_host *ici)
 	list_for_each_entry(sasc, &notifiers, list) {
 		/* Must call unlocked to avoid AB-BA dead-lock */
 		v4l2_async_notifier_unregister(&sasc->notifier);
+		v4l2_async_notifier_cleanup(&sasc->notifier);
 		put_device(&sasc->pdev->dev);
 	}
 
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 7215641..b12e5ee 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1587,7 +1587,6 @@ static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
 
 static int dcmi_graph_init(struct stm32_dcmi *dcmi)
 {
-	struct v4l2_async_subdev **subdevs = NULL;
 	int ret;
 
 	/* Parse the graph to extract a list of subdevice DT nodes. */
@@ -1597,23 +1596,19 @@ static int dcmi_graph_init(struct stm32_dcmi *dcmi)
 		return ret;
 	}
 
-	/* Register the subdevices notifier. */
-	subdevs = devm_kzalloc(dcmi->dev, sizeof(*subdevs), GFP_KERNEL);
-	if (!subdevs) {
+	ret = v4l2_async_notifier_add_subdev(&dcmi->notifier,
+					     &dcmi->entity.asd);
+	if (ret) {
 		of_node_put(dcmi->entity.node);
-		return -ENOMEM;
+		return ret;
 	}
 
-	subdevs[0] = &dcmi->entity.asd;
-
-	dcmi->notifier.subdevs = subdevs;
-	dcmi->notifier.num_subdevs = 1;
 	dcmi->notifier.ops = &dcmi_graph_notify_ops;
 
 	ret = v4l2_async_notifier_register(&dcmi->v4l2_dev, &dcmi->notifier);
 	if (ret < 0) {
 		dev_err(dcmi->dev, "Notifier registration failed\n");
-		of_node_put(dcmi->entity.node);
+		v4l2_async_notifier_cleanup(&dcmi->notifier);
 		return ret;
 	}
 
@@ -1770,7 +1765,7 @@ static int dcmi_probe(struct platform_device *pdev)
 	ret = reset_control_assert(dcmi->rstc);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to assert the reset line\n");
-		goto err_device_release;
+		goto err_cleanup;
 	}
 
 	usleep_range(3000, 5000);
@@ -1778,7 +1773,7 @@ static int dcmi_probe(struct platform_device *pdev)
 	ret = reset_control_deassert(dcmi->rstc);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to deassert the reset line\n");
-		goto err_device_release;
+		goto err_cleanup;
 	}
 
 	dev_info(&pdev->dev, "Probe done\n");
@@ -1789,6 +1784,8 @@ static int dcmi_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_cleanup:
+	v4l2_async_notifier_cleanup(&dcmi->notifier);
 err_device_release:
 	video_device_release(dcmi->vdev);
 err_device_unregister:
@@ -1806,6 +1803,7 @@ static int dcmi_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 
 	v4l2_async_notifier_unregister(&dcmi->notifier);
+	v4l2_async_notifier_cleanup(&dcmi->notifier);
 	v4l2_device_unregister(&dcmi->v4l2_dev);
 
 	dma_release_channel(dcmi->dma_chan);
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index d1febe5..2ad4b4d 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -270,7 +270,6 @@ struct cal_ctx {
 	struct v4l2_fwnode_endpoint	endpoint;
 
 	struct v4l2_async_subdev asd;
-	struct v4l2_async_subdev *asd_list[1];
 
 	struct v4l2_fh		fh;
 	struct cal_dev		*dev;
@@ -1668,7 +1667,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 		if (!port) {
 			ctx_dbg(1, ctx, "No port node found for csi2 port:%d\n",
 				index);
-			goto cleanup_exit;
+			return -EINVAL;
 		}
 
 		/* Match the slice number with <REG> */
@@ -1684,7 +1683,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	if (!found_port) {
 		ctx_dbg(1, ctx, "No port node matches csi2 port:%d\n",
 			inst);
-		goto cleanup_exit;
+		goto err_put_port;
 	}
 
 	ctx_dbg(3, ctx, "Scanning sub-device for csi2 port: %d\n",
@@ -1693,13 +1692,13 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	ep_node = of_get_next_endpoint(port, ep_node);
 	if (!ep_node) {
 		ctx_dbg(3, ctx, "can't get next endpoint\n");
-		goto cleanup_exit;
+		goto err_put_port;
 	}
 
 	sensor_node = of_graph_get_remote_port_parent(ep_node);
 	if (!sensor_node) {
 		ctx_dbg(3, ctx, "can't get remote parent\n");
-		goto cleanup_exit;
+		goto err_put_ep_node;
 	}
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	asd->match.fwnode = of_fwnode_handle(sensor_node);
@@ -1707,14 +1706,14 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	remote_ep = of_graph_get_remote_endpoint(ep_node);
 	if (!remote_ep) {
 		ctx_dbg(3, ctx, "can't get remote-endpoint\n");
-		goto cleanup_exit;
+		goto err_put_sensor_node;
 	}
 	v4l2_fwnode_endpoint_parse(of_fwnode_handle(remote_ep), endpoint);
 
 	if (endpoint->bus_type != V4L2_MBUS_CSI2) {
 		ctx_err(ctx, "Port:%d sub-device %s is not a CSI2 device\n",
 			inst, sensor_node->name);
-		goto cleanup_exit;
+		goto err_put_remote_ep;
 	}
 
 	/* Store Virtual Channel number */
@@ -1735,24 +1734,36 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	ctx_dbg(1, ctx, "Port: %d found sub-device %s\n",
 		inst, sensor_node->name);
 
-	ctx->asd_list[0] = asd;
-	ctx->notifier.subdevs = ctx->asd_list;
-	ctx->notifier.num_subdevs = 1;
+	ret = v4l2_async_notifier_add_subdev(&ctx->notifier, asd);
+	if (ret) {
+		ctx_err(ctx, "Error adding asd\n");
+		goto err_put_remote_ep;
+	}
+
 	ctx->notifier.ops = &cal_async_ops;
 	ret = v4l2_async_notifier_register(&ctx->v4l2_dev,
 					   &ctx->notifier);
 	if (ret) {
 		ctx_err(ctx, "Error registering async notifier\n");
 		ret = -EINVAL;
+		goto err_notifier_cleanup;
 	}
 
-cleanup_exit:
+	return 0;
+
+err_notifier_cleanup:
+	v4l2_async_notifier_cleanup(&ctx->notifier);
+	sensor_node = NULL;
+err_put_remote_ep:
 	if (remote_ep)
 		of_node_put(remote_ep);
+err_put_sensor_node:
 	if (sensor_node)
 		of_node_put(sensor_node);
+err_put_ep_node:
 	if (ep_node)
 		of_node_put(ep_node);
+err_put_port:
 	if (port)
 		of_node_put(port);
 
@@ -1900,6 +1911,7 @@ static int cal_remove(struct platform_device *pdev)
 				video_device_node_name(&ctx->vdev));
 			camerarx_phy_disable(ctx);
 			v4l2_async_notifier_unregister(&ctx->notifier);
+			v4l2_async_notifier_cleanup(&ctx->notifier);
 			v4l2_ctrl_handler_free(&ctx->ctrl_handler);
 			v4l2_device_unregister(&ctx->v4l2_dev);
 			video_unregister_device(&ctx->vdev);
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index 6d95ec1..da33f01 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -32,33 +32,36 @@
 
 /**
  * struct xvip_graph_entity - Entity in the video graph
- * @list: list entry in a graph entities list
- * @node: the entity's DT node
- * @entity: media entity, from the corresponding V4L2 subdev
  * @asd: subdev asynchronous registration information
+ * @entity: media entity, from the corresponding V4L2 subdev
  * @subdev: V4L2 subdev
  */
 struct xvip_graph_entity {
-	struct list_head list;
-	struct device_node *node;
+	struct v4l2_async_subdev asd; /* must be first */
 	struct media_entity *entity;
-
-	struct v4l2_async_subdev asd;
 	struct v4l2_subdev *subdev;
 };
 
+static inline struct xvip_graph_entity *
+to_xvip_entity(struct v4l2_async_subdev *asd)
+{
+	return container_of(asd, struct xvip_graph_entity, asd);
+}
+
 /* -----------------------------------------------------------------------------
  * Graph Management
  */
 
 static struct xvip_graph_entity *
 xvip_graph_find_entity(struct xvip_composite_device *xdev,
-		       const struct device_node *node)
+		       const struct fwnode_handle *fwnode)
 {
 	struct xvip_graph_entity *entity;
+	struct v4l2_async_subdev *asd;
 
-	list_for_each_entry(entity, &xdev->entities, list) {
-		if (entity->node == node)
+	list_for_each_entry(asd, &xdev->notifier.asd_list, asd_list) {
+		entity = to_xvip_entity(asd);
+		if (entity->asd.match.fwnode == fwnode)
 			return entity;
 	}
 
@@ -75,20 +78,21 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 	struct media_pad *remote_pad;
 	struct xvip_graph_entity *ent;
 	struct v4l2_fwnode_link link;
-	struct device_node *ep = NULL;
+	struct fwnode_handle *ep = NULL;
 	int ret = 0;
 
 	dev_dbg(xdev->dev, "creating links for entity %s\n", local->name);
 
 	while (1) {
 		/* Get the next endpoint and parse its link. */
-		ep = of_graph_get_next_endpoint(entity->node, ep);
+		ep = fwnode_graph_get_next_endpoint(entity->asd.match.fwnode,
+						    ep);
 		if (ep == NULL)
 			break;
 
 		dev_dbg(xdev->dev, "processing endpoint %pOF\n", ep);
 
-		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
+		ret = v4l2_fwnode_parse_link(ep, &link);
 		if (ret < 0) {
 			dev_err(xdev->dev, "failed to parse link for %pOF\n",
 				ep);
@@ -100,8 +104,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		 */
 		if (link.local_port >= local->num_pads) {
 			dev_err(xdev->dev, "invalid port number %u for %pOF\n",
-				link.local_port,
-				to_of_node(link.local_node));
+				link.local_port, link.local_node);
 			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
@@ -111,8 +114,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 
 		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
 			dev_dbg(xdev->dev, "skipping sink port %pOF:%u\n",
-				to_of_node(link.local_node),
-				link.local_port);
+				link.local_node, link.local_port);
 			v4l2_fwnode_put_link(&link);
 			continue;
 		}
@@ -120,18 +122,16 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		/* Skip DMA engines, they will be processed separately. */
 		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
 			dev_dbg(xdev->dev, "skipping DMA port %pOF:%u\n",
-				to_of_node(link.local_node),
-				link.local_port);
+				link.local_node, link.local_port);
 			v4l2_fwnode_put_link(&link);
 			continue;
 		}
 
 		/* Find the remote entity. */
-		ent = xvip_graph_find_entity(xdev,
-					     to_of_node(link.remote_node));
+		ent = xvip_graph_find_entity(xdev, link.remote_node);
 		if (ent == NULL) {
 			dev_err(xdev->dev, "no entity found for %pOF\n",
-				to_of_node(link.remote_node));
+				link.remote_node);
 			v4l2_fwnode_put_link(&link);
 			ret = -ENODEV;
 			break;
@@ -141,7 +141,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 
 		if (link.remote_port >= remote->num_pads) {
 			dev_err(xdev->dev, "invalid port number %u on %pOF\n",
-				link.remote_port, to_of_node(link.remote_node));
+				link.remote_port, link.remote_node);
 			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
@@ -168,7 +168,7 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		}
 	}
 
-	of_node_put(ep);
+	fwnode_handle_put(ep);
 	return ret;
 }
 
@@ -230,8 +230,7 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 			dma->video.name);
 
 		/* Find the remote entity. */
-		ent = xvip_graph_find_entity(xdev,
-					     to_of_node(link.remote_node));
+		ent = xvip_graph_find_entity(xdev, link.remote_node);
 		if (ent == NULL) {
 			dev_err(xdev->dev, "no entity found for %pOF\n",
 				to_of_node(link.remote_node));
@@ -289,12 +288,14 @@ static int xvip_graph_notify_complete(struct v4l2_async_notifier *notifier)
 	struct xvip_composite_device *xdev =
 		container_of(notifier, struct xvip_composite_device, notifier);
 	struct xvip_graph_entity *entity;
+	struct v4l2_async_subdev *asd;
 	int ret;
 
 	dev_dbg(xdev->dev, "notify complete, all subdevs registered\n");
 
 	/* Create links for every entity. */
-	list_for_each_entry(entity, &xdev->entities, list) {
+	list_for_each_entry(asd, &xdev->notifier.asd_list, asd_list) {
+		entity = to_xvip_entity(asd);
 		ret = xvip_graph_build_one(xdev, entity);
 		if (ret < 0)
 			return ret;
@@ -314,22 +315,25 @@ static int xvip_graph_notify_complete(struct v4l2_async_notifier *notifier)
 
 static int xvip_graph_notify_bound(struct v4l2_async_notifier *notifier,
 				   struct v4l2_subdev *subdev,
-				   struct v4l2_async_subdev *asd)
+				   struct v4l2_async_subdev *unused)
 {
 	struct xvip_composite_device *xdev =
 		container_of(notifier, struct xvip_composite_device, notifier);
 	struct xvip_graph_entity *entity;
+	struct v4l2_async_subdev *asd;
 
 	/* Locate the entity corresponding to the bound subdev and store the
 	 * subdev pointer.
 	 */
-	list_for_each_entry(entity, &xdev->entities, list) {
-		if (entity->node != subdev->dev->of_node)
+	list_for_each_entry(asd, &xdev->notifier.asd_list, asd_list) {
+		entity = to_xvip_entity(asd);
+
+		if (entity->asd.match.fwnode != subdev->fwnode)
 			continue;
 
 		if (entity->subdev) {
 			dev_err(xdev->dev, "duplicate subdev for node %pOF\n",
-				entity->node);
+				entity->asd.match.fwnode);
 			return -EINVAL;
 		}
 
@@ -349,56 +353,60 @@ static const struct v4l2_async_notifier_operations xvip_graph_notify_ops = {
 };
 
 static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
-				struct device_node *node)
+				struct fwnode_handle *fwnode)
 {
-	struct xvip_graph_entity *entity;
-	struct device_node *remote;
-	struct device_node *ep = NULL;
+	struct fwnode_handle *remote;
+	struct fwnode_handle *ep = NULL;
 	int ret = 0;
 
-	dev_dbg(xdev->dev, "parsing node %pOF\n", node);
+	dev_dbg(xdev->dev, "parsing node %pOF\n", fwnode);
 
 	while (1) {
-		ep = of_graph_get_next_endpoint(node, ep);
+		struct v4l2_async_subdev *asd;
+
+		ep = fwnode_graph_get_next_endpoint(fwnode, ep);
 		if (ep == NULL)
 			break;
 
 		dev_dbg(xdev->dev, "handling endpoint %pOF\n", ep);
 
-		remote = of_graph_get_remote_port_parent(ep);
+		remote = fwnode_graph_get_remote_port_parent(ep);
 		if (remote == NULL) {
 			ret = -EINVAL;
-			break;
+			goto err_notifier_cleanup;
 		}
 
+		fwnode_handle_put(ep);
+
 		/* Skip entities that we have already processed. */
-		if (remote == xdev->dev->of_node ||
+		if (remote == of_fwnode_handle(xdev->dev->of_node) ||
 		    xvip_graph_find_entity(xdev, remote)) {
-			of_node_put(remote);
+			fwnode_handle_put(remote);
 			continue;
 		}
 
-		entity = devm_kzalloc(xdev->dev, sizeof(*entity), GFP_KERNEL);
-		if (entity == NULL) {
-			of_node_put(remote);
-			ret = -ENOMEM;
-			break;
+		asd = v4l2_async_notifier_add_fwnode_subdev(
+			&xdev->notifier, remote,
+			sizeof(struct xvip_graph_entity));
+		if (IS_ERR(asd)) {
+			ret = PTR_ERR(asd);
+			fwnode_handle_put(remote);
+			goto err_notifier_cleanup;
 		}
-
-		entity->node = remote;
-		entity->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		entity->asd.match.fwnode = of_fwnode_handle(remote);
-		list_add_tail(&entity->list, &xdev->entities);
-		xdev->num_subdevs++;
 	}
 
-	of_node_put(ep);
+	return 0;
+
+err_notifier_cleanup:
+	v4l2_async_notifier_cleanup(&xdev->notifier);
+	fwnode_handle_put(ep);
 	return ret;
 }
 
 static int xvip_graph_parse(struct xvip_composite_device *xdev)
 {
 	struct xvip_graph_entity *entity;
+	struct v4l2_async_subdev *asd;
 	int ret;
 
 	/*
@@ -407,14 +415,17 @@ static int xvip_graph_parse(struct xvip_composite_device *xdev)
 	 * loop will handle entities added at the end of the list while walking
 	 * the links.
 	 */
-	ret = xvip_graph_parse_one(xdev, xdev->dev->of_node);
+	ret = xvip_graph_parse_one(xdev, of_fwnode_handle(xdev->dev->of_node));
 	if (ret < 0)
 		return 0;
 
-	list_for_each_entry(entity, &xdev->entities, list) {
-		ret = xvip_graph_parse_one(xdev, entity->node);
-		if (ret < 0)
+	list_for_each_entry(asd, &xdev->notifier.asd_list, asd_list) {
+		entity = to_xvip_entity(asd);
+		ret = xvip_graph_parse_one(xdev, entity->asd.match.fwnode);
+		if (ret < 0) {
+			v4l2_async_notifier_cleanup(&xdev->notifier);
 			break;
+		}
 	}
 
 	return ret;
@@ -485,17 +496,11 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 
 static void xvip_graph_cleanup(struct xvip_composite_device *xdev)
 {
-	struct xvip_graph_entity *entityp;
-	struct xvip_graph_entity *entity;
 	struct xvip_dma *dmap;
 	struct xvip_dma *dma;
 
 	v4l2_async_notifier_unregister(&xdev->notifier);
-
-	list_for_each_entry_safe(entity, entityp, &xdev->entities, list) {
-		of_node_put(entity->node);
-		list_del(&entity->list);
-	}
+	v4l2_async_notifier_cleanup(&xdev->notifier);
 
 	list_for_each_entry_safe(dma, dmap, &xdev->dmas, list) {
 		xvip_dma_cleanup(dma);
@@ -505,10 +510,6 @@ static void xvip_graph_cleanup(struct xvip_composite_device *xdev)
 
 static int xvip_graph_init(struct xvip_composite_device *xdev)
 {
-	struct xvip_graph_entity *entity;
-	struct v4l2_async_subdev **subdevs = NULL;
-	unsigned int num_subdevs;
-	unsigned int i;
 	int ret;
 
 	/* Init the DMA channels. */
@@ -525,26 +526,12 @@ static int xvip_graph_init(struct xvip_composite_device *xdev)
 		goto done;
 	}
 
-	if (!xdev->num_subdevs) {
+	if (!xdev->notifier.num_subdevs) {
 		dev_err(xdev->dev, "no subdev found in graph\n");
 		goto done;
 	}
 
 	/* Register the subdevices notifier. */
-	num_subdevs = xdev->num_subdevs;
-	subdevs = devm_kcalloc(xdev->dev, num_subdevs, sizeof(*subdevs),
-			       GFP_KERNEL);
-	if (subdevs == NULL) {
-		ret = -ENOMEM;
-		goto done;
-	}
-
-	i = 0;
-	list_for_each_entry(entity, &xdev->entities, list)
-		subdevs[i++] = &entity->asd;
-
-	xdev->notifier.subdevs = subdevs;
-	xdev->notifier.num_subdevs = num_subdevs;
 	xdev->notifier.ops = &xvip_graph_notify_ops;
 
 	ret = v4l2_async_notifier_register(&xdev->v4l2_dev, &xdev->notifier);
@@ -610,7 +597,6 @@ static int xvip_composite_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	xdev->dev = &pdev->dev;
-	INIT_LIST_HEAD(&xdev->entities);
 	INIT_LIST_HEAD(&xdev->dmas);
 
 	ret = xvip_composite_v4l2_init(xdev);
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.h b/drivers/media/platform/xilinx/xilinx-vipp.h
index faf6b6e..7e9c4cf 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.h
+++ b/drivers/media/platform/xilinx/xilinx-vipp.h
@@ -28,8 +28,6 @@
  * @media_dev: media device
  * @dev: (OF) device
  * @notifier: V4L2 asynchronous subdevs notifier
- * @entities: entities in the graph as a list of xvip_graph_entity
- * @num_subdevs: number of subdevs in the pipeline
  * @dmas: list of DMA channels at the pipeline output and input
  * @v4l2_caps: V4L2 capabilities of the whole device (see VIDIOC_QUERYCAP)
  */
@@ -39,8 +37,6 @@ struct xvip_composite_device {
 	struct device *dev;
 
 	struct v4l2_async_notifier notifier;
-	struct list_head entities;
-	unsigned int num_subdevs;
 
 	struct list_head dmas;
 	u32 v4l2_caps;
-- 
2.7.4
