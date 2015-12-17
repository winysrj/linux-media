Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44391 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbbLQGUT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 01:20:19 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [RFC/PATCH] v4l: vsp1: Configure device based on IP version
Date: Thu, 17 Dec 2015 08:20:11 +0200
Message-Id: <1450333211-31848-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The IP version number carries enough information to identify the exact
device instance features. Drop the related DT properties and use the IP
version instead.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/renesas,vsp1.txt     |  21 ---
 drivers/media/platform/vsp1/vsp1.h                 |   5 +-
 drivers/media/platform/vsp1/vsp1_bru.c             |   2 +-
 drivers/media/platform/vsp1/vsp1_drm.c             |   6 +-
 drivers/media/platform/vsp1/vsp1_drv.c             | 173 ++++++++++++---------
 drivers/media/platform/vsp1/vsp1_entity.c          |   2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c            |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_sru.c             |   4 +-
 drivers/media/platform/vsp1/vsp1_video.c           |   4 +-
 drivers/media/platform/vsp1/vsp1_wpf.c             |   6 +-
 11 files changed, 116 insertions(+), 117 deletions(-)

This patch applies on top of the "[GIT PULL FOR v4.5] Renesas VSP1
improvements and fixes" pull request.

diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
index fe74fb38e4d5..627405abd144 100644
--- a/Documentation/devicetree/bindings/media/renesas,vsp1.txt
+++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
@@ -14,21 +14,6 @@ Required properties:
   - interrupts: VSP interrupt specifier.
   - clocks: A phandle + clock-specifier pair for the VSP functional clock.
 
-  - renesas,#rpf: Number of Read Pixel Formatter (RPF) modules in the VSP.
-  - renesas,#wpf: Number of Write Pixel Formatter (WPF) modules in the VSP.
-
-
-Optional properties:
-
-  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the VSP. Defaults
-    to 0 if not present.
-  - renesas,has-lif: Boolean, indicates that the LCD Interface (LIF) module is
-    available.
-  - renesas,has-lut: Boolean, indicates that the Look Up Table (LUT) module is
-    available.
-  - renesas,has-sru: Boolean, indicates that the Super Resolution Unit (SRU)
-    module is available.
-
 
 Example: R8A7790 (R-Car H2) VSP1-S node
 
@@ -37,10 +22,4 @@ Example: R8A7790 (R-Car H2) VSP1-S node
 		reg = <0 0xfe928000 0 0x8000>;
 		interrupts = <0 267 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&mstp1_clks R8A7790_CLK_VSP1_S>;
-
-		renesas,has-lut;
-		renesas,has-sru;
-		renesas,#rpf = <5>;
-		renesas,#uds = <3>;
-		renesas,#wpf = <4>;
 	};
diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index 5b210b69f09c..910d6b8e8b50 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -47,7 +47,8 @@ struct vsp1_uds;
 #define VSP1_HAS_SRU		(1 << 2)
 #define VSP1_HAS_BRU		(1 << 3)
 
-struct vsp1_platform_data {
+struct vsp1_device_info {
+	u32 version;
 	unsigned int features;
 	unsigned int rpf_count;
 	unsigned int uds_count;
@@ -58,7 +59,7 @@ struct vsp1_platform_data {
 
 struct vsp1_device {
 	struct device *dev;
-	struct vsp1_platform_data pdata;
+	const struct vsp1_device_info *info;
 
 	void __iomem *mmio;
 	struct clk *clock;
diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 32e2009c215a..cb0dbc15ddad 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -416,7 +416,7 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 	bru->entity.type = VSP1_ENTITY_BRU;
 
 	ret = vsp1_entity_init(vsp1, &bru->entity,
-			       vsp1->pdata.num_bru_inputs + 1);
+			       vsp1->info->num_bru_inputs + 1);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 21ad0bb6d936..302d02a5c1c0 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -285,7 +285,7 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 	unsigned long flags;
 	int ret;
 
-	if (rpf_index >= vsp1->pdata.rpf_count)
+	if (rpf_index >= vsp1->info->rpf_count)
 		return -EINVAL;
 
 	rpf = vsp1->rpf[rpf_index];
@@ -519,7 +519,7 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
 	if (!vsp1->bru || !vsp1->lif)
 		return -ENXIO;
 
-	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		struct vsp1_rwpf *rpf = vsp1->rpf[i];
 
 		ret = media_entity_create_link(&rpf->entity.subdev.entity,
@@ -572,7 +572,7 @@ int vsp1_drm_init(struct vsp1_device *vsp1)
 	pipe->frame_end = vsp1_drm_pipeline_frame_end;
 
 	/* The DRM pipeline is static, add entities manually. */
-	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		struct vsp1_rwpf *input = vsp1->rpf[i];
 
 		list_add_tail(&input->entity.list_pipe, &pipe->entities);
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 9c8fca6a8b35..7ecdaba99193 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -47,7 +47,7 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
 	unsigned int i;
 	u32 status;
 
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
 		struct vsp1_pipeline *pipe;
 
@@ -153,7 +153,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
-	if (vsp1->pdata.features & VSP1_HAS_LIF) {
+	if (vsp1->info->features & VSP1_HAS_LIF) {
 		ret = media_entity_create_link(
 			&vsp1->wpf[0]->entity.subdev.entity, RWPF_PAD_SOURCE,
 			&vsp1->lif->entity.subdev.entity, LIF_PAD_SINK, 0);
@@ -161,7 +161,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
-	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		struct vsp1_rwpf *rpf = vsp1->rpf[i];
 
 		ret = media_entity_create_link(&rpf->video->video.entity, 0,
@@ -173,7 +173,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 			return ret;
 	}
 
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		/* Connect the video device to the WPF. All connections are
 		 * immutable except for the WPF0 source link if a LIF is
 		 * present.
@@ -181,7 +181,7 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
 		unsigned int flags = MEDIA_LNK_FL_ENABLED;
 
-		if (!(vsp1->pdata.features & VSP1_HAS_LIF) || i != 0)
+		if (!(vsp1->info->features & VSP1_HAS_LIF) || i != 0)
 			flags |= MEDIA_LNK_FL_IMMUTABLE;
 
 		ret = media_entity_create_link(&wpf->entity.subdev.entity,
@@ -213,7 +213,7 @@ static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 	v4l2_device_unregister(&vsp1->v4l2_dev);
 	media_device_unregister(&vsp1->media_dev);
 
-	if (!vsp1->pdata.uapi)
+	if (!vsp1->info->uapi)
 		vsp1_drm_cleanup(vsp1);
 }
 
@@ -241,7 +241,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	 * the pipeline is configured internally by the driver in that case, and
 	 * its configuration can thus be trusted.
 	 */
-	if (vsp1->pdata.uapi)
+	if (vsp1->info->uapi)
 		vsp1->media_ops.link_validate = v4l2_subdev_link_validate;
 
 	vdev->mdev = mdev;
@@ -253,7 +253,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	/* Instantiate all the entities. */
-	if (vsp1->pdata.features & VSP1_HAS_BRU) {
+	if (vsp1->info->features & VSP1_HAS_BRU) {
 		vsp1->bru = vsp1_bru_create(vsp1);
 		if (IS_ERR(vsp1->bru)) {
 			ret = PTR_ERR(vsp1->bru);
@@ -279,7 +279,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
 
-	if (vsp1->pdata.features & VSP1_HAS_LIF) {
+	if (vsp1->info->features & VSP1_HAS_LIF) {
 		vsp1->lif = vsp1_lif_create(vsp1);
 		if (IS_ERR(vsp1->lif)) {
 			ret = PTR_ERR(vsp1->lif);
@@ -289,7 +289,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->lif->entity.list_dev, &vsp1->entities);
 	}
 
-	if (vsp1->pdata.features & VSP1_HAS_LUT) {
+	if (vsp1->info->features & VSP1_HAS_LUT) {
 		vsp1->lut = vsp1_lut_create(vsp1);
 		if (IS_ERR(vsp1->lut)) {
 			ret = PTR_ERR(vsp1->lut);
@@ -299,7 +299,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->lut->entity.list_dev, &vsp1->entities);
 	}
 
-	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		struct vsp1_rwpf *rpf;
 
 		rpf = vsp1_rpf_create(vsp1, i);
@@ -311,7 +311,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		vsp1->rpf[i] = rpf;
 		list_add_tail(&rpf->entity.list_dev, &vsp1->entities);
 
-		if (vsp1->pdata.uapi) {
+		if (vsp1->info->uapi) {
 			struct vsp1_video *video = vsp1_video_create(vsp1, rpf);
 
 			if (IS_ERR(video)) {
@@ -323,7 +323,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		}
 	}
 
-	if (vsp1->pdata.features & VSP1_HAS_SRU) {
+	if (vsp1->info->features & VSP1_HAS_SRU) {
 		vsp1->sru = vsp1_sru_create(vsp1);
 		if (IS_ERR(vsp1->sru)) {
 			ret = PTR_ERR(vsp1->sru);
@@ -333,7 +333,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&vsp1->sru->entity.list_dev, &vsp1->entities);
 	}
 
-	for (i = 0; i < vsp1->pdata.uds_count; ++i) {
+	for (i = 0; i < vsp1->info->uds_count; ++i) {
 		struct vsp1_uds *uds;
 
 		uds = vsp1_uds_create(vsp1, i);
@@ -346,7 +346,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		list_add_tail(&uds->entity.list_dev, &vsp1->entities);
 	}
 
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf;
 
 		wpf = vsp1_wpf_create(vsp1, i);
@@ -358,7 +358,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 		vsp1->wpf[i] = wpf;
 		list_add_tail(&wpf->entity.list_dev, &vsp1->entities);
 
-		if (vsp1->pdata.uapi) {
+		if (vsp1->info->uapi) {
 			struct vsp1_video *video = vsp1_video_create(vsp1, wpf);
 
 			if (IS_ERR(video)) {
@@ -372,7 +372,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	/* Create links. */
-	if (vsp1->pdata.uapi)
+	if (vsp1->info->uapi)
 		ret = vsp1_uapi_create_links(vsp1);
 	else
 		ret = vsp1_drm_create_links(vsp1);
@@ -387,7 +387,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 			goto done;
 	}
 
-	if (vsp1->pdata.uapi) {
+	if (vsp1->info->uapi) {
 		vsp1->use_dl = false;
 		ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
 	} else {
@@ -434,7 +434,7 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	int ret;
 
 	/* Reset any channel that might be running. */
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		ret = vsp1_reset_wpf(vsp1, i);
 		if (ret < 0)
 			return ret;
@@ -443,10 +443,10 @@ static int vsp1_device_init(struct vsp1_device *vsp1)
 	vsp1_write(vsp1, VI6_CLK_DCSWT, (8 << VI6_CLK_DCSWT_CSTPW_SHIFT) |
 		   (8 << VI6_CLK_DCSWT_CSTRW_SHIFT));
 
-	for (i = 0; i < vsp1->pdata.rpf_count; ++i)
+	for (i = 0; i < vsp1->info->rpf_count; ++i)
 		vsp1_write(vsp1, VI6_DPR_RPF_ROUTE(i), VI6_DPR_NODE_UNUSED);
 
-	for (i = 0; i < vsp1->pdata.uds_count; ++i)
+	for (i = 0; i < vsp1->info->uds_count; ++i)
 		vsp1_write(vsp1, VI6_DPR_UDS_ROUTE(i), VI6_DPR_NODE_UNUSED);
 
 	vsp1_write(vsp1, VI6_DPR_SRU_ROUTE, VI6_DPR_NODE_UNUSED);
@@ -563,52 +563,75 @@ static const struct dev_pm_ops vsp1_pm_ops = {
  * Platform Driver
  */
 
-static int vsp1_parse_dt(struct vsp1_device *vsp1)
-{
-	struct device_node *np = vsp1->dev->of_node;
-	struct vsp1_platform_data *pdata = &vsp1->pdata;
-
-	if (of_property_read_bool(np, "renesas,has-lif"))
-		pdata->features |= VSP1_HAS_LIF;
-	if (of_property_read_bool(np, "renesas,has-lut"))
-		pdata->features |= VSP1_HAS_LUT;
-	if (of_property_read_bool(np, "renesas,has-sru"))
-		pdata->features |= VSP1_HAS_SRU;
-
-	of_property_read_u32(np, "renesas,#rpf", &pdata->rpf_count);
-	of_property_read_u32(np, "renesas,#uds", &pdata->uds_count);
-	of_property_read_u32(np, "renesas,#wpf", &pdata->wpf_count);
-
-	if (pdata->rpf_count <= 0 || pdata->rpf_count > VSP1_MAX_RPF) {
-		dev_err(vsp1->dev, "invalid number of RPF (%u)\n",
-			pdata->rpf_count);
-		return -EINVAL;
-	}
-
-	if (pdata->uds_count > VSP1_MAX_UDS) {
-		dev_err(vsp1->dev, "invalid number of UDS (%u)\n",
-			pdata->uds_count);
-		return -EINVAL;
-	}
-
-	if (pdata->wpf_count <= 0 || pdata->wpf_count > VSP1_MAX_WPF) {
-		dev_err(vsp1->dev, "invalid number of WPF (%u)\n",
-			pdata->wpf_count);
-		return -EINVAL;
-	}
-
-	pdata->features |= VSP1_HAS_BRU;
-	pdata->num_bru_inputs = 4;
-	pdata->uapi = true;
-
-	return 0;
-}
+static const struct vsp1_device_info vsp1_device_infos[] = {
+	{
+		.version = VI6_IP_VERSION_MODEL_VSPS_H2,
+		.features = VSP1_HAS_BRU | VSP1_HAS_LUT | VSP1_HAS_SRU,
+		.rpf_count = 5,
+		.uds_count = 3,
+		.wpf_count = 4,
+		.num_bru_inputs = 4,
+		.uapi = true,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPR_H2,
+		.features = VSP1_HAS_BRU | VSP1_HAS_SRU,
+		.rpf_count = 5,
+		.uds_count = 1,
+		.wpf_count = 4,
+		.num_bru_inputs = 4,
+		.uapi = true,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPD_GEN2,
+		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_LUT,
+		.rpf_count = 4,
+		.uds_count = 1,
+		.wpf_count = 4,
+		.num_bru_inputs = 4,
+		.uapi = true,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
+		.features = VSP1_HAS_BRU | VSP1_HAS_LUT | VSP1_HAS_SRU,
+		.rpf_count = 5,
+		.uds_count = 3,
+		.wpf_count = 4,
+		.num_bru_inputs = 4,
+		.uapi = true,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
+		.features = VSP1_HAS_LUT | VSP1_HAS_SRU,
+		.rpf_count = 1,
+		.uds_count = 1,
+		.wpf_count = 1,
+		.uapi = true,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPBD_GEN3,
+		.features = VSP1_HAS_BRU,
+		.rpf_count = 5,
+		.wpf_count = 1,
+		.num_bru_inputs = 5,
+		.uapi = true,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPBC_GEN3,
+		.features = VSP1_HAS_BRU | VSP1_HAS_LUT,
+		.rpf_count = 5,
+		.wpf_count = 1,
+		.num_bru_inputs = 5,
+		.uapi = true,
+	}, {
+		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
+		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_LUT,
+		.rpf_count = 5,
+		.wpf_count = 2,
+		.num_bru_inputs = 5,
+	},
+};
 
 static int vsp1_probe(struct platform_device *pdev)
 {
 	struct vsp1_device *vsp1;
 	struct resource *irq;
 	struct resource *io;
+	unsigned int i;
 	u32 version;
 	int ret;
 
@@ -621,10 +644,6 @@ static int vsp1_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&vsp1->entities);
 	INIT_LIST_HEAD(&vsp1->videos);
 
-	ret = vsp1_parse_dt(vsp1);
-	if (ret < 0)
-		return ret;
-
 	/* I/O, IRQ and clock resources */
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
@@ -658,21 +677,21 @@ static int vsp1_probe(struct platform_device *pdev)
 	version = vsp1_read(vsp1, VI6_IP_VERSION);
 	clk_disable_unprepare(vsp1->clock);
 
-	dev_dbg(&pdev->dev, "IP version 0x%08x\n", version);
-
-	switch (version & VI6_IP_VERSION_MODEL_MASK) {
-	case VI6_IP_VERSION_MODEL_VSPD_GEN3:
-		vsp1->pdata.num_bru_inputs = 5;
-		vsp1->pdata.uapi = false;
-		break;
+	for (i = 0; i < ARRAY_SIZE(vsp1_device_infos); ++i) {
+		if ((version & VI6_IP_VERSION_MODEL_MASK) ==
+		    vsp1_device_infos[i].version) {
+			vsp1->info = &vsp1_device_infos[i];
+			break;
+		}
+	}
 
-	case VI6_IP_VERSION_MODEL_VSPI_GEN3:
-	case VI6_IP_VERSION_MODEL_VSPBD_GEN3:
-	case VI6_IP_VERSION_MODEL_VSPBC_GEN3:
-		vsp1->pdata.features &= ~VSP1_HAS_BRU;
-		break;
+	if (!vsp1->info) {
+		dev_err(&pdev->dev, "unsupported IP version 0x%08x\n", version);
+		return -ENXIO;
 	}
 
+	dev_dbg(&pdev->dev, "IP version 0x%08x\n", version);
+
 	/* Instanciate entities */
 	ret = vsp1_create_entities(vsp1);
 	if (ret < 0) {
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index da4e7b82d0ca..d65cf8035a92 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -45,7 +45,7 @@ int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
 	if (!streaming)
 		return 0;
 
-	if (!entity->vsp1->pdata.uapi || !entity->subdev.ctrl_handler)
+	if (!entity->vsp1->info->uapi || !entity->subdev.ctrl_handler)
 		return 0;
 
 	ret = v4l2_ctrl_handler_setup(entity->subdev.ctrl_handler);
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 2e4a31072100..96f0e7d4c400 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -347,7 +347,7 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 	 * pipelines twice, first to set them all to the stopping state, and
 	 * then to wait for the stop to complete.
 	 */
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
 		struct vsp1_pipeline *pipe;
 
@@ -364,7 +364,7 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 		spin_unlock_irqrestore(&pipe->irqlock, flags);
 	}
 
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
 		struct vsp1_pipeline *pipe;
 
@@ -388,7 +388,7 @@ void vsp1_pipelines_resume(struct vsp1_device *vsp1)
 	unsigned int i;
 
 	/* Resume pipeline all running pipelines. */
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+	for (i = 0; i < vsp1->info->wpf_count; ++i) {
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
 		struct vsp1_pipeline *pipe;
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 1eb9a3ef05c8..5bc1d1574a43 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -151,12 +151,12 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
 				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
 
-	if (vsp1->pdata.uapi)
+	if (vsp1->info->uapi)
 		mutex_lock(rpf->ctrls.lock);
 	vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
 		       rpf->alpha->cur.val << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
 	vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, rpf->alpha->cur.val);
-	if (vsp1->pdata.uapi)
+	if (vsp1->info->uapi)
 		mutex_unlock(rpf->ctrls.lock);
 
 	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 6dcf76a1ca57..cc09efbfb24f 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -151,12 +151,12 @@ static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 	/* Take the control handler lock to ensure that the CTRL0 value won't be
 	 * changed behind our back by a set control operation.
 	 */
-	if (sru->entity.vsp1->pdata.uapi)
+	if (sru->entity.vsp1->info->uapi)
 		mutex_lock(sru->ctrls.lock);
 	ctrl0 |= vsp1_sru_read(sru, VI6_SRU_CTRL0)
 	       & (VI6_SRU_CTRL0_PARAM0_MASK | VI6_SRU_CTRL0_PARAM1_MASK);
 	vsp1_sru_write(sru, VI6_SRU_CTRL0, ctrl0);
-	if (sru->entity.vsp1->pdata.uapi)
+	if (sru->entity.vsp1->info->uapi)
 		mutex_unlock(sru->ctrls.lock);
 
 	vsp1_sru_write(sru, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d3335eb24cce..682e5b6f787d 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -329,7 +329,7 @@ static int vsp1_video_pipeline_validate(struct vsp1_pipeline *pipe,
 	/* Follow links downstream for each input and make sure the graph
 	 * contains no loop and that all branches end at the output WPF.
 	 */
-	for (i = 0; i < video->vsp1->pdata.rpf_count; ++i) {
+	for (i = 0; i < video->vsp1->info->rpf_count; ++i) {
 		if (!pipe->inputs[i])
 			continue;
 
@@ -461,7 +461,7 @@ static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	unsigned int i;
 
 	/* Complete buffers on all video nodes. */
-	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		if (!pipe->inputs[i])
 			continue;
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 4a741a597878..c78d4af50fcf 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -98,7 +98,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	 * inputs as sub-layers and select the virtual RPF as the master
 	 * layer.
 	 */
-	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		struct vsp1_rwpf *input = pipe->inputs[i];
 
 		if (!input)
@@ -155,11 +155,11 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	/* Take the control handler lock to ensure that the PDV value won't be
 	 * changed behind our back by a set control operation.
 	 */
-	if (vsp1->pdata.uapi)
+	if (vsp1->info->uapi)
 		mutex_lock(wpf->ctrls.lock);
 	outfmt |= wpf->alpha->cur.val << VI6_WPF_OUTFMT_PDV_SHIFT;
 	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
-	if (vsp1->pdata.uapi)
+	if (vsp1->info->uapi)
 		mutex_unlock(wpf->ctrls.lock);
 
 	vsp1_mod_write(&wpf->entity, VI6_DPR_WPF_FPORCH(wpf->entity.index),
-- 
Regards,

Laurent Pinchart

