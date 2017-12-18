Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:60947 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758850AbdLRTyY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 14:54:24 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Benoit Parrot <bparrot@ti.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Petr Cvek <petr.cvek@tul.cz>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pravin Shedge <pravin.shedge4linux@gmail.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sebastian Reichel <sre@kernel.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 3/8] media: v4l2-async: simplify v4l2_async_subdev structure
Date: Mon, 18 Dec 2017 17:53:57 -0200
Message-Id: <014b64d13c8b9d516afc3319a9de1a97b2a845de.1513625884.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513625884.git.mchehab@s-opensource.com>
References: <cover.1513625884.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1513625884.git.mchehab@s-opensource.com>
References: <cover.1513625884.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The V4L2_ASYNC_MATCH_FWNODE match criteria requires just one
struct to be filled (struct fwnode_handle). The V4L2_ASYNC_MATCH_DEVNAME
match criteria requires just a device name.

So, it doesn't make sense to enclose those into structs,
as the criteria can go directly into the union.

That makes easier to document it, as we don't need to document
weird senseless structs.

At drivers, this makes even clearer about the match criteria.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c    |  6 +++---
 drivers/media/platform/atmel/atmel-isc.c       |  2 +-
 drivers/media/platform/atmel/atmel-isi.c       |  2 +-
 drivers/media/platform/davinci/vpif_capture.c  |  4 ++--
 drivers/media/platform/exynos4-is/media-dev.c  |  4 ++--
 drivers/media/platform/pxa_camera.c            |  2 +-
 drivers/media/platform/qcom/camss-8x16/camss.c |  2 +-
 drivers/media/platform/rcar-vin/rcar-core.c    |  2 +-
 drivers/media/platform/rcar_drif.c             |  4 ++--
 drivers/media/platform/soc_camera/soc_camera.c |  2 +-
 drivers/media/platform/stm32/stm32-dcmi.c      |  2 +-
 drivers/media/platform/ti-vpe/cal.c            |  2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c    |  2 +-
 drivers/media/v4l2-core/v4l2-async.c           | 16 ++++++++--------
 drivers/media/v4l2-core/v4l2-fwnode.c          | 10 +++++-----
 drivers/staging/media/imx/imx-media-dev.c      |  4 ++--
 include/media/v4l2-async.h                     |  8 ++------
 17 files changed, 35 insertions(+), 39 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 0997c640191d..601ae6487617 100644
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
@@ -2510,7 +2510,7 @@ vpfe_get_pdata(struct platform_device *pdev)
 		}
 
 		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
+		pdata->asd[i]->match.fwnode = of_fwnode_handle(rem);
 		of_node_put(rem);
 	}
 
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 0c2635647f69..34676409ca08 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -2088,7 +2088,7 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 			subdev_entity->pfe_cfg0 |= ISC_PFE_CFG0_PPOL_LOW;
 
 		subdev_entity->asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		subdev_entity->asd->match.fwnode.fwnode =
+		subdev_entity->asd->match.fwnode =
 			of_fwnode_handle(rem);
 		list_add_tail(&subdev_entity->list, &isc->subdev_entities);
 	}
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index e900995143a3..9958918e2449 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -1128,7 +1128,7 @@ static int isi_graph_parse(struct atmel_isi *isi, struct device_node *node)
 		/* Remote node to connect */
 		isi->entity.node = remote;
 		isi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		isi->entity.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+		isi->entity.asd.match.fwnode = of_fwnode_handle(remote);
 		return 0;
 	}
 }
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index e45916f69def..e1c273c8b9a6 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1390,7 +1390,7 @@ static int vpif_async_bound(struct v4l2_async_notifier *notifier,
 
 	for (i = 0; i < vpif_obj.config->asd_sizes[0]; i++) {
 		struct v4l2_async_subdev *_asd = vpif_obj.config->asd[i];
-		const struct fwnode_handle *fwnode = _asd->match.fwnode.fwnode;
+		const struct fwnode_handle *fwnode = _asd->match.fwnode;
 
 		if (fwnode == subdev->fwnode) {
 			vpif_obj.sd[i] = subdev;
@@ -1595,7 +1595,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
 		}
 
 		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		pdata->asd[i]->match.fwnode.fwnode = of_fwnode_handle(rem);
+		pdata->asd[i]->match.fwnode = of_fwnode_handle(rem);
 		of_node_put(rem);
 	}
 
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index 0ef583cfc424..78b48a1fa26c 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -456,7 +456,7 @@ static int fimc_md_parse_port_node(struct fimc_md *fmd,
 	}
 
 	fmd->sensor[index].asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-	fmd->sensor[index].asd.match.fwnode.fwnode = of_fwnode_handle(rem);
+	fmd->sensor[index].asd.match.fwnode = of_fwnode_handle(rem);
 	fmd->async_subdevs[index] = &fmd->sensor[index].asd;
 
 	fmd->num_sensors++;
@@ -1364,7 +1364,7 @@ static int subdev_notifier_bound(struct v4l2_async_notifier *notifier,
 
 	/* Find platform data for this sensor subdev */
 	for (i = 0; i < ARRAY_SIZE(fmd->sensor); i++)
-		if (fmd->sensor[i].asd.match.fwnode.fwnode ==
+		if (fmd->sensor[i].asd.match.fwnode ==
 		    of_fwnode_handle(subdev->dev->of_node))
 			si = &fmd->sensor[i];
 
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index 305cf1cac210..f028084f0775 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -2335,7 +2335,7 @@ static int pxa_camera_pdata_from_dt(struct device *dev,
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	remote = of_graph_get_remote_port(np);
 	if (remote) {
-		asd->match.fwnode.fwnode = of_fwnode_handle(remote);
+		asd->match.fwnode = of_fwnode_handle(remote);
 		of_node_put(remote);
 	} else {
 		dev_notice(dev, "no remote for %pOF\n", np);
diff --git a/drivers/media/platform/qcom/camss-8x16/camss.c b/drivers/media/platform/qcom/camss-8x16/camss.c
index 390a42c17b66..05f06c98aa64 100644
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
index 108d776f3265..f1fc7978d6d1 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -187,7 +187,7 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
 		return -ENODEV;
 
 	vin_dbg(vin, "Found digital subdevice %pOF\n",
-		to_of_node(vin->digital->asd.match.fwnode.fwnode));
+		to_of_node(vin->digital->asd.match.fwnode));
 
 	vin->notifier.ops = &rvin_digital_notify_ops;
 	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 63c94f4028a7..b2e080ef5391 100644
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
@@ -1235,7 +1235,7 @@ static int rcar_drif_parse_subdevs(struct rcar_drif_sdr *sdr)
 		return -EINVAL;
 	}
 
-	sdr->ep.asd.match.fwnode.fwnode = fwnode;
+	sdr->ep.asd.match.fwnode = fwnode;
 	sdr->ep.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	notifier->num_subdevs++;
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 916ff68b73d4..d13e2c5fb06f 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1517,7 +1517,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
 	if (!info)
 		return -ENOMEM;
 
-	info->sasd.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+	info->sasd.asd.match.fwnode = of_fwnode_handle(remote);
 	info->sasd.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 	info->subdev = &info->sasd.asd;
 
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index ac4c450a6c7d..9460b3080dca 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1520,7 +1520,7 @@ static int dcmi_graph_parse(struct stm32_dcmi *dcmi, struct device_node *node)
 		/* Remote node to connect */
 		dcmi->entity.node = remote;
 		dcmi->entity.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		dcmi->entity.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+		dcmi->entity.asd.match.fwnode = of_fwnode_handle(remote);
 		return 0;
 	}
 }
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 719ed1d79957..d1febe5baa6d 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -1702,7 +1702,7 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
 		goto cleanup_exit;
 	}
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	asd->match.fwnode.fwnode = of_fwnode_handle(sensor_node);
+	asd->match.fwnode = of_fwnode_handle(sensor_node);
 
 	remote_ep = of_graph_get_remote_endpoint(ep_node);
 	if (!remote_ep) {
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index f4c3e48ed2c0..6bb28cd49dae 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -387,7 +387,7 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
 
 		entity->node = remote;
 		entity->asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
-		entity->asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+		entity->asd.match.fwnode = of_fwnode_handle(remote);
 		list_add_tail(&entity->list, &xdev->entities);
 		xdev->num_subdevs++;
 	}
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index e5acfab470a5..2b08d03b251d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -68,12 +68,12 @@ static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
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
@@ -319,7 +319,7 @@ static bool __v4l2_async_notifier_fwnode_has_async_subdev(
 		if (asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
 			continue;
 
-		if (asd->match.fwnode.fwnode == fwnode)
+		if (asd->match.fwnode == fwnode)
 			return true;
 	}
 
@@ -330,7 +330,7 @@ static bool __v4l2_async_notifier_fwnode_has_async_subdev(
 		if (sd->asd->match_type != V4L2_ASYNC_MATCH_FWNODE)
 			continue;
 
-		if (sd->asd->match.fwnode.fwnode == fwnode)
+		if (sd->asd->match.fwnode == fwnode)
 			return true;
 	}
 
@@ -355,8 +355,8 @@ static bool v4l2_async_notifier_fwnode_has_async_subdev(
 		struct v4l2_async_subdev *other_asd = notifier->subdevs[j];
 
 		if (other_asd->match_type == V4L2_ASYNC_MATCH_FWNODE &&
-		    asd->match.fwnode.fwnode ==
-		    other_asd->match.fwnode.fwnode)
+		    asd->match.fwnode ==
+		    other_asd->match.fwnode)
 			return true;
 	}
 
@@ -395,7 +395,7 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
 			break;
 		case V4L2_ASYNC_MATCH_FWNODE:
 			if (v4l2_async_notifier_fwnode_has_async_subdev(
-				    notifier, asd->match.fwnode.fwnode, i)) {
+				    notifier, asd->match.fwnode, i)) {
 				dev_err(dev,
 					"fwnode has already been registered or in notifier's subdev list\n");
 				ret = -EEXIST;
@@ -510,7 +510,7 @@ void v4l2_async_notifier_cleanup(struct v4l2_async_notifier *notifier)
 
 		switch (asd->match_type) {
 		case V4L2_ASYNC_MATCH_FWNODE:
-			fwnode_handle_put(asd->match.fwnode.fwnode);
+			fwnode_handle_put(asd->match.fwnode);
 			break;
 		default:
 			WARN_ON_ONCE(true);
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index fb72c7ac04d4..d630640642ee 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -359,9 +359,9 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 		return -ENOMEM;
 
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-	asd->match.fwnode.fwnode =
+	asd->match.fwnode =
 		fwnode_graph_get_remote_port_parent(endpoint);
-	if (!asd->match.fwnode.fwnode) {
+	if (!asd->match.fwnode) {
 		dev_warn(dev, "bad remote port parent\n");
 		ret = -EINVAL;
 		goto out_err;
@@ -393,7 +393,7 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 	return 0;
 
 out_err:
-	fwnode_handle_put(asd->match.fwnode.fwnode);
+	fwnode_handle_put(asd->match.fwnode);
 	kfree(asd);
 
 	return ret == -ENOTCONN ? 0 : ret;
@@ -566,7 +566,7 @@ static int v4l2_fwnode_reference_parse(
 		}
 
 		notifier->subdevs[notifier->num_subdevs] = asd;
-		asd->match.fwnode.fwnode = args.fwnode;
+		asd->match.fwnode = args.fwnode;
 		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 		notifier->num_subdevs++;
 	}
@@ -853,7 +853,7 @@ static int v4l2_fwnode_reference_parse_int_props(
 		}
 
 		notifier->subdevs[notifier->num_subdevs] = asd;
-		asd->match.fwnode.fwnode = fwnode;
+		asd->match.fwnode = fwnode;
 		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 		notifier->num_subdevs++;
 	}
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index 2800700482d6..f7ed5f506fa9 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -48,7 +48,7 @@ find_async_subdev(struct imx_media_dev *imxmd,
 		asd = &imxasd->asd;
 		switch (asd->match_type) {
 		case V4L2_ASYNC_MATCH_FWNODE:
-			if (fwnode && asd->match.fwnode.fwnode == fwnode)
+			if (fwnode && asd->match.fwnode == fwnode)
 				return asd;
 			break;
 		case V4L2_ASYNC_MATCH_DEVNAME:
@@ -104,7 +104,7 @@ int imx_media_add_async_subdev(struct imx_media_dev *imxmd,
 
 	if (fwnode) {
 		asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
-		asd->match.fwnode.fwnode = fwnode;
+		asd->match.fwnode = fwnode;
 	} else {
 		asd->match_type = V4L2_ASYNC_MATCH_DEVNAME;
 		asd->match.device_name.name = devname;
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 6152434cbe82..a010af5134b2 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -58,12 +58,8 @@ enum v4l2_async_match_type {
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
2.14.3
