Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55010 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752963AbdI1MxU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Sep 2017 08:53:20 -0400
Date: Thu, 28 Sep 2017 15:53:17 +0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [RESEND PATCH v2 13/17] media: v4l2-async: simplify
 v4l2_async_subdev structure
Message-ID: <20170928125316.texy2qrzpvzekp7a@valkosipuli.retiisi.org.uk>
References: <cover.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1506548682.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Resending for Mauro, while dropping the non-list recipients. The original
likely had too many recipients.)

The V4L2_ASYNC_MATCH_FWNODE match criteria requires just one
struct to be filled (struct fwnode_handle). The V4L2_ASYNC_MATCH_DEVNAME
match criteria requires just a device name.

So, it doesn't make sense to enclose those into structs,
as the criteria can go directly into the union.

That makes easier to document it, as we don't need to document
weird senseless structs.

At drivers, this makes even clearer about the match criteria.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c    | 6 +++---
 drivers/media/platform/atmel/atmel-isc.c       | 2 +-
 drivers/media/platform/atmel/atmel-isi.c       | 2 +-
 drivers/media/platform/davinci/vpif_capture.c  | 4 ++--
 drivers/media/platform/exynos4-is/media-dev.c  | 4 ++--
 drivers/media/platform/omap3isp/isp.c          | 4 ++--
 drivers/media/platform/pxa_camera.c            | 2 +-
 drivers/media/platform/qcom/camss-8x16/camss.c | 2 +-
 drivers/media/platform/rcar-vin/rcar-core.c    | 8 ++++----
 drivers/media/platform/rcar_drif.c             | 4 ++--
 drivers/media/platform/soc_camera/soc_camera.c | 2 +-
 drivers/media/platform/stm32/stm32-dcmi.c      | 2 +-
 drivers/media/platform/ti-vpe/cal.c            | 2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c    | 2 +-
 drivers/media/v4l2-core/v4l2-async.c           | 4 ++--
 drivers/staging/media/imx/imx-media-dev.c      | 8 ++++----
 include/media/v4l2-async.h                     | 8 ++------
 17 files changed, 31 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index dfcc484cab89..f87e8f9467e9 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2304,8 +2304,8 @@ vpfe_async_bound(struct v4l2_async_notifier *notifier,
 	vpfe_dbg(1, vpfe, "vpfe_async_bound\n");
 
 	for (i = 0; i < ARRAY_SIZE(vpfe->cfg->asd); i++) {
-		if (vpfe->cfg->asd[i]->match.fwnode.fwnode ==
-		    asd[i].match.fwnode.fwnode) {
+		if (vpfe->cfg->asd[i]->match.fwnode ==
+		    asd[i].match.fwnode) {
 			sdinfo = &vpfe->cfg->sub_devs[i];
 			vpfe->sd[i] = subdev;
 			vpfe->sd[i]->grp_id = sdinfo->grp_id;
@@ -2505,7 +2505,7 @@ vpfe_get_pdata(struct platform_device *pdev)
 		}
 
 		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
+		pdata->asd[i]->match.fwnode = of_fwnode_handle(rem);
 		of_node_put(rem);
 	}
 
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d7103c5f92c3..c04d9a4dbfac 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1742,7 +1742,7 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 			subdev_entity->pfe_cfg0 |= ISC_PFE_CFG0_PPOL_LOW;
 
 		subdev_entity->asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		subdev_entity->asd->match.fwnode.fwnode =
+		subdev_entity->asd->match.fwnode =
 			of_fwnode_handle(rem);
 		list_add_tail(&subdev_entity->list, &isc->subdev_entities);
 	}
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 891fa2505efa..8c52f9f5f2db 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1124,7 +1124,7 @@ static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
 		/* Remote node to connect */
 		isi->entity.node = remote;
 		isi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		isi->entity.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+		isi->entity.asd.match.fwnode = of_fwnode_handle(remote);
 		return 0;
 	}
 }
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 0ef36cec21d1..0cf141635cbc 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1390,7 +1390,7 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 
 	for (i = 0; i < vpif_obj.config->asd_sizes[0]; i++) {
 		struct v4l2_async_subdev *_asd = vpif_obj.config->asd[i];
-		const struct fwnode_handle *fwnode = _asd->match.fwnode.fwnode;
+		const struct fwnode_handle *fwnode = _asd->match.fwnode;
 
 		if (fwnode == subdev->fwnode) {
 			vpif_obj.sd[i] = subdev;
@@ -1588,7 +1588,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 		}
 
 		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
+		pdata->asd[i]->match.fwnode = of_fwnode_handle(rem);
 		of_node_put(rem);
 	}
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index d4656d5175d7..d4d97d7e9684 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -454,7 +454,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	}
 
 	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-	fmd->sensor[index].asd.match.fwnode.fwnode = of_fwnode_handle(rem);
+	fmd->sensor[index].asd.match.fwnode = of_fwnode_handle(rem);
 	fmd->async_subdevs[index] = &fmd->sensor[index].asd;
 
 	fmd->num_sensors++;
@@ -1361,7 +1361,7 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
-		if (fmd->sensor[i].asd.match.fwnode.fwnode ==
+		if (fmd->sensor[i].asd.match.fwnode ==
 		    of_fwnode_handle(subdev->dev->of_node))
 			si = &fmd->sensor[i];
 
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1a428fe9f070..bbb402a5fcf0 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2170,9 +2170,9 @@ static int isp_fwnodes_parse(struct device *dev,
 
 		notifier->subdevs[notifier->num_subdevs] = &isd->asd;
 
-		isd->asd.match.fwnode.fwnode =
+		isd->asd.match.fwnode =
 			fwnode_graph_get_remote_port_parent(fwnode);
-		if (!isd->asd.match.fwnode.fwnode) {
+		if (!isd->asd.match.fwnode) {
 			dev_warn(dev, "bad remote port parent\n");
 			goto error;
 		}
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index edca993c2b1f..4a23a60f3418 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2328,7 +2328,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	remote = of_graph_get_remote_port(np);
 	if (remote) {
-		asd->match.fwnode.fwnode = of_fwnode_handle(remote);
+		asd->match.fwnode = of_fwnode_handle(remote);
 		of_node_put(remote);
 	} else {
 		dev_notice(dev, "no remote for %pOF\n", np);
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
index a3760b5dd1d1..7d7bca09473a 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss.c
@@ -341,7 +341,7 @@ static int camss_of_parse_ports(struct device *dev,
 		}
 
 		csd->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		csd->asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+		csd->asd.match.fwnode = of_fwnode_handle(remote);
 	}
 
 	return notifier->num_subdevs;
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index 142de447aaaa..3835a2fa0cb7 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -171,7 +171,7 @@ static int rvin_digital_graph_parse(struct rvin_dev *vin)
 	struct device_node *ep, *np;
 	int ret;
 
-	vin->digital.asd.match.fwnode.fwnode = NULL;
+	vin->digital.asd.match.fwnode = NULL;
 	vin->digital.subdev = NULL;
 
 	/*
@@ -195,7 +195,7 @@ static int rvin_digital_graph_parse(struct rvin_dev *vin)
 	if (ret)
 		return ret;
 
-	vin->digital.asd.match.fwnode.fwnode = of_fwnode_handle(np);
+	vin->digital.asd.match.fwnode = of_fwnode_handle(np);
 	vin->digital.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 
 	return 0;
@@ -210,7 +210,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	if (ret)
 		return ret;
 
-	if (!vin->digital.asd.match.fwnode.fwnode) {
+	if (!vin->digital.asd.match.fwnode) {
 		vin_dbg(vin, "No digital subdevice found\n");
 		return -ENODEV;
 	}
@@ -223,7 +223,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 	subdevs[0] = &vin->digital.asd;
 
 	vin_dbg(vin, "Found digital subdevice %pOF\n",
-		to_of_node(subdevs[0]->match.fwnode.fwnode));
+		to_of_node(subdevs[0]->match.fwnode));
 
 	vin->notifier.num_subdevs = 1;
 	vin->notifier.subdevs = subdevs;
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 522364ff0d5d..ae7927305231 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -1107,7 +1107,7 @@ static int rcar_drif_notify_bound(struct v4l2_async_notifier *notifier,
 	struct rcar_drif_sdr *sdr =
 		container_of(notifier, struct rcar_drif_sdr, notifier);
 
-	if (sdr->ep.asd.match.fwnode.fwnode !=
+	if (sdr->ep.asd.match.fwnode !=
 	    of_fwnode_handle(subdev->dev->of_node)) {
 		rdrif_err(sdr, "subdev %s cannot bind\n", subdev->name);
 		return -EINVAL;
@@ -1229,7 +1229,7 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
 		return -EINVAL;
 	}
 
-	sdr->ep.asd.match.fwnode.fwnode = fwnode;
+	sdr->ep.asd.match.fwnode = fwnode;
 	sdr->ep.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	notifier->num_subdevs++;
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 1f3c450c7a69..1bef3ebb49ee 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1513,7 +1513,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	if (!info)
 		return -ENOMEM;
 
-	info->sasd.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+	info->sasd.asd.match.fwnode = of_fwnode_handle(remote);
 	info->sasd.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	info->subdev = &info->sasd.asd;
 
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 35ba6f211b79..4c8bd77842f6 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1514,7 +1514,7 @@ static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
 		/* Remote node to connect */
 		dcmi->entity.node = remote;
 		dcmi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		dcmi->entity.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+		dcmi->entity.asd.match.fwnode = of_fwnode_handle(remote);
 		return 0;
 	}
 }
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 42e383a48ffe..7491425eed77 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1700,7 +1700,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 		goto cleanup_exit;
 	}
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	asd->match.fwnode.fwnode = of_fwnode_handle(sensor_node);
+	asd->match.fwnode = of_fwnode_handle(sensor_node);
 
 	remote_ep = of_graph_get_remote_endpoint(ep_node);
 	if (!remote_ep) {
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index ebfdf334d99c..3fdb0f365538 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -390,7 +390,7 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
 
 		entity->node = remote;
 		entity->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		entity->asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+		entity->asd.match.fwnode = of_fwnode_handle(remote);
 		list_add_tail(&entity->list, &xdev->entities);
 		xdev->num_subdevs++;
 	}
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index d741a8e0fdac..e087857d02d6 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -39,12 +39,12 @@ static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 static bool match_devname(struct v4l2_subdev *sd,
 			  struct v4l2_async_subdev *asd)
 {
-	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
+	return !strcmp(asd->match.device_name, dev_name(sd->dev));
 }
 
 static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return sd->fwnode == asd->match.fwnode.fwnode;
+	return sd->fwnode == asd->match.fwnode;
 }
 
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index d96f4512224f..858088570684 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -48,12 +48,12 @@ imx_media_find_async_subdev(struct imx_media_dev *imxmd,
 		imxsd = &imxmd->subdev[i];
 		switch (imxsd->asd.match_type) {
 		case V4L2_ASYNC_MATCH_FWNODE:
-			if (fwnode && imxsd->asd.match.fwnode.fwnode == fwnode)
+			if (fwnode && imxsd->asd.match.fwnode == fwnode)
 				return imxsd;
 			break;
 		case V4L2_ASYNC_MATCH_DEVNAME:
 			if (devname &&
-			    !strcmp(imxsd->asd.match.device_name.name, devname))
+			    !strcmp(imxsd->asd.match.device_name, devname))
 				return imxsd;
 			break;
 		default:
@@ -108,11 +108,11 @@ imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 	asd = &imxsd->asd;
 	if (np) {
 		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		asd->match.fwnode.fwnode = of_fwnode_handle(np);
+		asd->match.fwnode = of_fwnode_handle(np);
 	} else {
 		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
 		strncpy(imxsd->devname, devname, sizeof(imxsd->devname));
-		asd->match.device_name.name = imxsd->devname;
+		asd->match.device_name = imxsd->devname;
 		imxsd->pdev = pdev;
 	}
 
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index c69d8c8a66d0..e66a3521596f 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -54,12 +54,8 @@ enum v4l2_async_match_type {
 struct v4l2_async_subdev {
 	enum v4l2_async_match_type match_type;
 	union {
-		struct {
-			struct fwnode_handle *fwnode;
-		} fwnode;
-		struct {
-			const char *name;
-		} device_name;
+		struct fwnode_handle *fwnode;
+		const char *device_name;
 		struct {
 			int adapter_id;
 			unsigned short address;
-- 
2.13.5
