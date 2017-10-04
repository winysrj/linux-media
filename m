Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40278 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751384AbdJDVvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 17:51:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v15 13/32] v4l: async: Move async subdev notifier operations to a separate structure
Date: Thu,  5 Oct 2017 00:50:32 +0300
Message-Id: <20171004215051.13385-14-sakari.ailus@linux.intel.com>
In-Reply-To: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
References: <20171004215051.13385-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

The async subdev notifier .bound(), .unbind() and .complete() operations
are function pointers stored directly in the v4l2_async_subdev
structure. As the structure isn't immutable, this creates a potential
security risk as the function pointers are mutable.

To fix this, move the function pointers to a new
v4l2_async_subdev_operations structure that can be made const in
drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c    |  8 +++++--
 drivers/media/platform/atmel/atmel-isc.c       | 10 ++++++---
 drivers/media/platform/atmel/atmel-isi.c       | 10 ++++++---
 drivers/media/platform/davinci/vpif_capture.c  |  8 +++++--
 drivers/media/platform/davinci/vpif_display.c  |  8 +++++--
 drivers/media/platform/exynos4-is/media-dev.c  |  8 +++++--
 drivers/media/platform/omap3isp/isp.c          |  6 +++++-
 drivers/media/platform/pxa_camera.c            |  8 +++++--
 drivers/media/platform/qcom/camss-8x16/camss.c |  8 +++++--
 drivers/media/platform/rcar-vin/rcar-core.c    | 10 ++++++---
 drivers/media/platform/rcar_drif.c             | 10 ++++++---
 drivers/media/platform/soc_camera/soc_camera.c | 14 ++++++------
 drivers/media/platform/stm32/stm32-dcmi.c      | 10 ++++++---
 drivers/media/platform/ti-vpe/cal.c            |  8 +++++--
 drivers/media/platform/xilinx/xilinx-vipp.c    |  8 +++++--
 drivers/media/v4l2-core/v4l2-async.c           | 30 ++++++++++++--------------
 drivers/staging/media/imx/imx-media-dev.c      |  8 +++++--
 include/media/v4l2-async.h                     | 29 ++++++++++++++++---------
 18 files changed, 135 insertions(+), 66 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index dfcc484cab89..0997c640191d 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2417,6 +2417,11 @@ static int vpfe_async_complete(struct v4l2_async_notifier *notifier)
 	return vpfe_probe_complete(vpfe);
 }
 
+static const struct v4l2_async_notifier_operations vpfe_async_ops = {
+	.bound = vpfe_async_bound,
+	.complete = vpfe_async_complete,
+};
+
 static struct vpfe_config *
 vpfe_get_pdata(struct platform_device *pdev)
 {
@@ -2590,8 +2595,7 @@ static int vpfe_probe(struct platform_device *pdev)
 
 	vpfe->notifier.subdevs = vpfe->cfg->asd;
 	vpfe->notifier.num_subdevs = ARRAY_SIZE(vpfe->cfg->asd);
-	vpfe->notifier.bound = vpfe_async_bound;
-	vpfe->notifier.complete = vpfe_async_complete;
+	vpfe->notifier.ops = &vpfe_async_ops;
 	ret = v4l2_async_notifier_register(&vpfe->v4l2_dev,
 						&vpfe->notifier);
 	if (ret) {
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 2f8e345d297e..382fe355e616 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1637,6 +1637,12 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	return 0;
 }
 
+static const struct v4l2_async_notifier_operations isc_async_ops = {
+	.bound = isc_async_bound,
+	.unbind = isc_async_unbind,
+	.complete = isc_async_complete,
+};
+
 static void isc_subdev_cleanup(struct isc_device *isc)
 {
 	struct isc_subdev_entity *subdev_entity;
@@ -1849,9 +1855,7 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	list_for_each_entry(subdev_entity, &isc->subdev_entities, list) {
 		subdev_entity->notifier.subdevs = &subdev_entity->asd;
 		subdev_entity->notifier.num_subdevs = 1;
-		subdev_entity->notifier.bound = isc_async_bound;
-		subdev_entity->notifier.unbind = isc_async_unbind;
-		subdev_entity->notifier.complete = isc_async_complete;
+		subdev_entity->notifier.ops = &isc_async_ops;
 
 		ret = v4l2_async_notifier_register(&isc->v4l2_dev,
 						   &subdev_entity->notifier);
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 463c0146915e..e900995143a3 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1103,6 +1103,12 @@ static int isi_graph_notify_bound(struct v4l2_async_notifier *notifier,
 	return 0;
 }
 
+static const struct v4l2_async_notifier_operations isi_graph_notify_ops = {
+	.bound = isi_graph_notify_bound,
+	.unbind = isi_graph_notify_unbind,
+	.complete = isi_graph_notify_complete,
+};
+
 static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
 {
 	struct device_node *ep = NULL;
@@ -1150,9 +1156,7 @@ static int isi_graph_init(struct atmel_isi *isi)
 
 	isi->notifier.subdevs = subdevs;
 	isi->notifier.num_subdevs = 1;
-	isi->notifier.bound = isi_graph_notify_bound;
-	isi->notifier.unbind = isi_graph_notify_unbind;
-	isi->notifier.complete = isi_graph_notify_complete;
+	isi->notifier.ops = &isi_graph_notify_ops;
 
 	ret = v4l2_async_notifier_register(&isi->v4l2_dev, &isi->notifier);
 	if (ret < 0) {
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 0ef36cec21d1..a89367ab1e06 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1500,6 +1500,11 @@ static int vpif_async_complete(struct v4l2_async_notifier *notifier)
 	return vpif_probe_complete();
 }
 
+static const struct v4l2_async_notifier_operations vpif_async_ops = {
+	.bound = vpif_async_bound,
+	.complete = vpif_async_complete,
+};
+
 static struct vpif_capture_config *
 vpif_capture_get_pdata(struct platform_device *pdev)
 {
@@ -1691,8 +1696,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	} else {
 		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
 		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
-		vpif_obj.notifier.bound = vpif_async_bound;
-		vpif_obj.notifier.complete = vpif_async_complete;
+		vpif_obj.notifier.ops = &vpif_async_ops;
 		err = v4l2_async_notifier_register(&vpif_obj.v4l2_dev,
 						   &vpif_obj.notifier);
 		if (err) {
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 56fe4e5b396e..ff2f75a328c9 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1232,6 +1232,11 @@ static int vpif_async_complete(struct v4l2_async_notifier *notifier)
 	return vpif_probe_complete();
 }
 
+static const struct v4l2_async_notifier_operations vpif_async_ops = {
+	.bound = vpif_async_bound,
+	.complete = vpif_async_complete,
+};
+
 /*
  * vpif_probe: This function creates device entries by register itself to the
  * V4L2 driver and initializes fields of each channel objects
@@ -1313,8 +1318,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 	} else {
 		vpif_obj.notifier.subdevs = vpif_obj.config->asd;
 		vpif_obj.notifier.num_subdevs = vpif_obj.config->asd_sizes[0];
-		vpif_obj.notifier.bound = vpif_async_bound;
-		vpif_obj.notifier.complete = vpif_async_complete;
+		vpif_obj.notifier.ops = &vpif_async_ops;
 		err = v4l2_async_notifier_register(&vpif_obj.v4l2_dev,
 						   &vpif_obj.notifier);
 		if (err) {
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index d4656d5175d7..c15596b56dc9 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1405,6 +1405,11 @@ static int subdev_notifier_complete(struct v4l2_async_notifier *notifier)
 	return media_device_register(&fmd->media_dev);
 }
 
+static const struct v4l2_async_notifier_operations subdev_notifier_ops = {
+	.bound = subdev_notifier_bound,
+	.complete = subdev_notifier_complete,
+};
+
 static int fimc_md_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1479,8 +1484,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	if (fmd->num_sensors > 0) {
 		fmd->subdev_notifier.subdevs = fmd->async_subdevs;
 		fmd->subdev_notifier.num_subdevs = fmd->num_sensors;
-		fmd->subdev_notifier.bound = subdev_notifier_bound;
-		fmd->subdev_notifier.complete = subdev_notifier_complete;
+		fmd->subdev_notifier.ops = &subdev_notifier_ops;
 		fmd->num_sensors = 0;
 
 		ret = v4l2_async_notifier_register(&fmd->v4l2_dev,
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 35687c9707e0..b7ff3842afc0 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2171,6 +2171,10 @@ static int isp_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	return media_device_register(&isp->media_dev);
 }
 
+static const struct v4l2_async_notifier_operations isp_subdev_notifier_ops = {
+	.complete = isp_subdev_notifier_complete,
+};
+
 /*
  * isp_probe - Probe ISP platform device
  * @pdev: Pointer to ISP platform device
@@ -2341,7 +2345,7 @@ static int isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error_register_entities;
 
-	isp->notifier.complete = isp_subdev_notifier_complete;
+	isp->notifier.ops = &isp_subdev_notifier_ops;
 
 	ret = v4l2_async_notifier_register(&isp->v4l2_dev, &isp->notifier);
 	if (ret)
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index edca993c2b1f..9d3f0cb1d95a 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2221,6 +2221,11 @@ static void pxa_camera_sensor_unbind(struct v4l2_async_notifier *notifier,
 	mutex_unlock(&pcdev->mlock);
 }
 
+static const struct v4l2_async_notifier_operations pxa_camera_sensor_ops = {
+	.bound = pxa_camera_sensor_bound,
+	.unbind = pxa_camera_sensor_unbind,
+};
+
 /*
  * Driver probe, remove, suspend and resume operations
  */
@@ -2489,8 +2494,7 @@ static int pxa_camera_probe(struct platform_device *pdev)
 	pcdev->asds[0] = &pcdev->asd;
 	pcdev->notifier.subdevs = pcdev->asds;
 	pcdev->notifier.num_subdevs = 1;
-	pcdev->notifier.bound = pxa_camera_sensor_bound;
-	pcdev->notifier.unbind = pxa_camera_sensor_unbind;
+	pcdev->notifier.ops = &pxa_camera_sensor_ops;
 
 	if (!of_have_populated_dt())
 		pcdev->asd.match_type = V4L2_ASYNC_MATCH_I2C;
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
index a3760b5dd1d1..390a42c17b66 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss.c
@@ -601,6 +601,11 @@ static int camss_subdev_notifier_complete(struct v4l2_async_notifier *async)
 	return media_device_register(&camss->media_dev);
 }
 
+static const struct v4l2_async_notifier_operations camss_subdev_notifier_ops = {
+	.bound = camss_subdev_notifier_bound,
+	.complete = camss_subdev_notifier_complete,
+};
+
 static const struct media_device_ops camss_media_ops = {
 	.link_notify = v4l2_pipeline_link_notify,
 };
@@ -655,8 +660,7 @@ static int camss_probe(struct platform_device *pdev)
 		goto err_register_entities;
 
 	if (camss->notifier.num_subdevs) {
-		camss->notifier.bound = camss_subdev_notifier_bound;
-		camss->notifier.complete = camss_subdev_notifier_complete;
+		camss->notifier.ops = &camss_subdev_notifier_ops;
 
 		ret = v4l2_async_notifier_register(&camss->v4l2_dev,
 						   &camss->notifier);
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 380288658601..108d776f3265 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -134,6 +134,12 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
 
 	return 0;
 }
+static const struct v4l2_async_notifier_operations rvin_digital_notify_ops = {
+	.bound = rvin_digital_notify_bound,
+	.unbind = rvin_digital_notify_unbind,
+	.complete = rvin_digital_notify_complete,
+};
+
 
 static int rvin_digital_parse_v4l2(struct device *dev,
 				   struct v4l2_fwnode_endpoint *vep,
@@ -183,9 +189,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	vin_dbg(vin, "Found digital subdevice %pOF\n",
 		to_of_node(vin->digital->asd.match.fwnode.fwnode));
 
-	vin->notifier.bound = rvin_digital_notify_bound;
-	vin->notifier.unbind = rvin_digital_notify_unbind;
-	vin->notifier.complete = rvin_digital_notify_complete;
+	vin->notifier.ops = &rvin_digital_notify_ops;
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
 	if (ret < 0) {
 		vin_err(vin, "Notifier registration failed\n");
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 522364ff0d5d..0b2214d6d621 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1185,6 +1185,12 @@ static int rcar_drif_notify_complete(struct v4l2_async_notifier *notifier)
 	return ret;
 }
 
+static const struct v4l2_async_notifier_operations rcar_drif_notify_ops = {
+	.bound = rcar_drif_notify_bound,
+	.unbind = rcar_drif_notify_unbind,
+	.complete = rcar_drif_notify_complete,
+};
+
 /* Read endpoint properties */
 static void rcar_drif_get_ep_properties(struct rcar_drif_sdr *sdr,
 					struct fwnode_handle *fwnode)
@@ -1347,9 +1353,7 @@ static int rcar_drif_sdr_probe(struct rcar_drif_sdr *sdr)
 	if (ret)
 		goto error;
 
-	sdr->notifier.bound = rcar_drif_notify_bound;
-	sdr->notifier.unbind = rcar_drif_notify_unbind;
-	sdr->notifier.complete = rcar_drif_notify_complete;
+	sdr->notifier.ops = &rcar_drif_notify_ops;
 
 	/* Register notifier */
 	ret = v4l2_async_notifier_register(&sdr->v4l2_dev, &sdr->notifier);
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 1f3c450c7a69..916ff68b73d4 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1391,6 +1391,12 @@ static int soc_camera_async_complete(struct v4l2_async_notifier *notifier)
 	return 0;
 }
 
+static const struct v4l2_async_notifier_operations soc_camera_async_ops = {
+	.bound = soc_camera_async_bound,
+	.unbind = soc_camera_async_unbind,
+	.complete = soc_camera_async_complete,
+};
+
 static int scan_async_group(struct soc_camera_host *ici,
 			    struct v4l2_async_subdev **asd, unsigned int size)
 {
@@ -1437,9 +1443,7 @@ static int scan_async_group(struct soc_camera_host *ici,
 
 	sasc->notifier.subdevs = asd;
 	sasc->notifier.num_subdevs = size;
-	sasc->notifier.bound = soc_camera_async_bound;
-	sasc->notifier.unbind = soc_camera_async_unbind;
-	sasc->notifier.complete = soc_camera_async_complete;
+	sasc->notifier.ops = &soc_camera_async_ops;
 
 	icd->sasc = sasc;
 	icd->parent = ici->v4l2_dev.dev;
@@ -1537,9 +1541,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
 
 	sasc->notifier.subdevs = &info->subdev;
 	sasc->notifier.num_subdevs = 1;
-	sasc->notifier.bound = soc_camera_async_bound;
-	sasc->notifier.unbind = soc_camera_async_unbind;
-	sasc->notifier.complete = soc_camera_async_complete;
+	sasc->notifier.ops = &soc_camera_async_ops;
 
 	icd->sasc = sasc;
 	icd->parent = ici->v4l2_dev.dev;
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 35ba6f211b79..ac4c450a6c7d 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1495,6 +1495,12 @@ static int dcmi_graph_notify_bound(struct v4l2_async_notifier *notifier,
 	return 0;
 }
 
+static const struct v4l2_async_notifier_operations dcmi_graph_notify_ops = {
+	.bound = dcmi_graph_notify_bound,
+	.unbind = dcmi_graph_notify_unbind,
+	.complete = dcmi_graph_notify_complete,
+};
+
 static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
 {
 	struct device_node *ep = NULL;
@@ -1542,9 +1548,7 @@ static int dcmi_graph_init(struct stm32_dcmi *dcmi)
 
 	dcmi->notifier.subdevs = subdevs;
 	dcmi->notifier.num_subdevs = 1;
-	dcmi->notifier.bound = dcmi_graph_notify_bound;
-	dcmi->notifier.unbind = dcmi_graph_notify_unbind;
-	dcmi->notifier.complete = dcmi_graph_notify_complete;
+	dcmi->notifier.ops = &dcmi_graph_notify_ops;
 
 	ret = v4l2_async_notifier_register(&dcmi->v4l2_dev, &dcmi->notifier);
 	if (ret < 0) {
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 42e383a48ffe..8b586c864524 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1522,6 +1522,11 @@ static int cal_async_complete(struct v4l2_async_notifier *notifier)
 	return 0;
 }
 
+static const struct v4l2_async_notifier_operations cal_async_ops = {
+	.bound = cal_async_bound,
+	.complete = cal_async_complete,
+};
+
 static int cal_complete_ctx(struct cal_ctx *ctx)
 {
 	struct video_device *vfd;
@@ -1736,8 +1741,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 	ctx->asd_list[0] = asd;
 	ctx->notifier.subdevs = ctx->asd_list;
 	ctx->notifier.num_subdevs = 1;
-	ctx->notifier.bound = cal_async_bound;
-	ctx->notifier.complete = cal_async_complete;
+	ctx->notifier.ops = &cal_async_ops;
 	ret = v4l2_async_notifier_register(&ctx->v4l2_dev,
 					   &ctx->notifier);
 	if (ret) {
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index ebfdf334d99c..d881cf09876d 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -351,6 +351,11 @@ static int xvip_graph_notify_bound(struct v4l2_async_notifier *notifier,
 	return -EINVAL;
 }
 
+static const struct v4l2_async_notifier_operations xvip_graph_notify_ops = {
+	.bound = xvip_graph_notify_bound,
+	.complete = xvip_graph_notify_complete,
+};
+
 static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
 				struct device_node *node)
 {
@@ -548,8 +553,7 @@ static int xvip_graph_init(struct xvip_composite_device *xdev)
 
 	xdev->notifier.subdevs = subdevs;
 	xdev->notifier.num_subdevs = num_subdevs;
-	xdev->notifier.bound = xvip_graph_notify_bound;
-	xdev->notifier.complete = xvip_graph_notify_complete;
+	xdev->notifier.ops = &xvip_graph_notify_ops;
 
 	ret = v4l2_async_notifier_register(&xdev->v4l2_dev, &xdev->notifier);
 	if (ret < 0) {
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 46aebfc75e43..9d6fc5f25619 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -102,16 +102,16 @@ static int v4l2_async_match_notify(struct v4l2_async_notifier *notifier,
 {
 	int ret;
 
-	if (notifier->bound) {
-		ret = notifier->bound(notifier, sd, asd);
+	if (notifier->ops->bound) {
+		ret = notifier->ops->bound(notifier, sd, asd);
 		if (ret < 0)
 			return ret;
 	}
 
 	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
 	if (ret < 0) {
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, asd);
+		if (notifier->ops->unbind)
+			notifier->ops->unbind(notifier, sd, asd);
 		return ret;
 	}
 
@@ -140,9 +140,8 @@ static void v4l2_async_notifier_unbind_all_subdevs(
 	struct v4l2_subdev *sd, *tmp;
 
 	list_for_each_entry_safe(sd, tmp, &notifier->done, async_list) {
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, sd->asd);
-
+		if (notifier->ops->unbind)
+			notifier->ops->unbind(notifier, sd, sd->asd);
 		v4l2_async_cleanup(sd);
 
 		list_move(&sd->async_list, &subdev_list);
@@ -199,8 +198,8 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
 		}
 	}
 
-	if (list_empty(&notifier->waiting) && notifier->complete) {
-		ret = notifier->complete(notifier);
+	if (list_empty(&notifier->waiting) && notifier->ops->complete) {
+		ret = notifier->ops->complete(notifier);
 		if (ret)
 			goto err_complete;
 	}
@@ -297,10 +296,10 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 		if (ret)
 			goto err_unlock;
 
-		if (!list_empty(&notifier->waiting) || !notifier->complete)
+		if (!list_empty(&notifier->waiting) || !notifier->ops->complete)
 			goto out_unlock;
 
-		ret = notifier->complete(notifier);
+		ret = notifier->ops->complete(notifier);
 		if (ret)
 			goto err_cleanup;
 
@@ -316,9 +315,8 @@ int v4l2_async_register_subdev(struct v4l2_subdev *sd)
 	return 0;
 
 err_cleanup:
-	if (notifier->unbind)
-		notifier->unbind(notifier, sd, sd->asd);
-
+	if (notifier->ops->unbind)
+		notifier->ops->unbind(notifier, sd, sd->asd);
 	v4l2_async_cleanup(sd);
 
 err_unlock:
@@ -337,8 +335,8 @@ void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
 
 		list_add(&sd->asd->list, &notifier->waiting);
 
-		if (notifier->unbind)
-			notifier->unbind(notifier, sd, sd->asd);
+		if (notifier->ops->unbind)
+			notifier->ops->unbind(notifier, sd, sd->asd);
 	}
 
 	v4l2_async_cleanup(sd);
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index b55e5ebba8b4..47c4c954fed5 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -440,6 +440,11 @@ static int imx_media_probe_complete(struct v4l2_async_notifier *notifier)
 	return media_device_register(&imxmd->md);
 }
 
+static const struct v4l2_async_notifier_operations imx_media_subdev_ops = {
+	.bound = imx_media_subdev_bound,
+	.complete = imx_media_probe_complete,
+};
+
 /*
  * adds controls to a video device from an entity subdevice.
  * Continues upstream from the entity's sink pads.
@@ -608,8 +613,7 @@ static int imx_media_probe(struct platform_device *pdev)
 
 	/* prepare the async subdev notifier and register it */
 	imxmd->subdev_notifier.subdevs = imxmd->async_ptrs;
-	imxmd->subdev_notifier.bound = imx_media_subdev_bound;
-	imxmd->subdev_notifier.complete = imx_media_probe_complete;
+	imxmd->subdev_notifier.ops = &imx_media_subdev_ops;
 	ret = v4l2_async_notifier_register(&imxmd->v4l2_dev,
 					   &imxmd->subdev_notifier);
 	if (ret) {
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 329aeebd1a80..68606afb5ef9 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -18,6 +18,7 @@ struct device;
 struct device_node;
 struct v4l2_device;
 struct v4l2_subdev;
+struct v4l2_async_notifier;
 
 /* A random max subdevice number, used to allocate an array on stack */
 #define V4L2_MAX_SUBDEVS 128U
@@ -79,8 +80,25 @@ struct v4l2_async_subdev {
 };
 
 /**
+ * struct v4l2_async_notifier_operations - Asynchronous V4L2 notifier operations
+ * @bound:	a subdevice driver has successfully probed one of the subdevices
+ * @complete:	all subdevices have been probed successfully
+ * @unbind:	a subdevice is leaving
+ */
+struct v4l2_async_notifier_operations {
+	int (*bound)(struct v4l2_async_notifier *notifier,
+		     struct v4l2_subdev *subdev,
+		     struct v4l2_async_subdev *asd);
+	int (*complete)(struct v4l2_async_notifier *notifier);
+	void (*unbind)(struct v4l2_async_notifier *notifier,
+		       struct v4l2_subdev *subdev,
+		       struct v4l2_async_subdev *asd);
+};
+
+/**
  * struct v4l2_async_notifier - v4l2_device notifier data
  *
+ * @ops:	notifier operations
  * @num_subdevs: number of subdevices used in the subdevs array
  * @max_subdevs: number of subdevices allocated in the subdevs array
  * @subdevs:	array of pointers to subdevice descriptors
@@ -88,11 +106,9 @@ struct v4l2_async_subdev {
  * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
  * @done:	list of struct v4l2_subdev, already probed
  * @list:	member in a global list of notifiers
- * @bound:	a subdevice driver has successfully probed one of subdevices
- * @complete:	all subdevices have been probed successfully
- * @unbind:	a subdevice is leaving
  */
 struct v4l2_async_notifier {
+	const struct v4l2_async_notifier_operations *ops;
 	unsigned int num_subdevs;
 	unsigned int max_subdevs;
 	struct v4l2_async_subdev **subdevs;
@@ -100,13 +116,6 @@ struct v4l2_async_notifier {
 	struct list_head waiting;
 	struct list_head done;
 	struct list_head list;
-	int (*bound)(struct v4l2_async_notifier *notifier,
-		     struct v4l2_subdev *subdev,
-		     struct v4l2_async_subdev *asd);
-	int (*complete)(struct v4l2_async_notifier *notifier);
-	void (*unbind)(struct v4l2_async_notifier *notifier,
-		       struct v4l2_subdev *subdev,
-		       struct v4l2_async_subdev *asd);
 };
 
 /**
-- 
2.11.0
