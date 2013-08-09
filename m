Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54863 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031473Ab3HIXCd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 19:02:33 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: [PATCH/RFC v3 19/19] drm/rcar-du: Port to the Common Display Framework
Date: Sat, 10 Aug 2013 01:03:18 +0200
Message-Id: <1376089398-13322-20-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1376089398-13322-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/gpu/drm/rcar-du/Kconfig             |   3 +-
 drivers/gpu/drm/rcar-du/Makefile            |   7 +-
 drivers/gpu/drm/rcar-du/rcar_du_connector.c | 164 ++++++++++++++++
 drivers/gpu/drm/rcar-du/rcar_du_connector.h |  36 ++++
 drivers/gpu/drm/rcar-du/rcar_du_crtc.h      |   2 +-
 drivers/gpu/drm/rcar-du/rcar_du_drv.c       | 279 ++++++++++++++++++++++++----
 drivers/gpu/drm/rcar-du/rcar_du_drv.h       |  28 ++-
 drivers/gpu/drm/rcar-du/rcar_du_encoder.c   |  87 ++++-----
 drivers/gpu/drm/rcar-du/rcar_du_encoder.h   |  22 +--
 drivers/gpu/drm/rcar-du/rcar_du_kms.c       | 116 ++++++++++--
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c   | 131 -------------
 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h   |  25 ---
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.c    |  96 ----------
 drivers/gpu/drm/rcar-du/rcar_du_vgacon.h    |  23 ---
 include/linux/platform_data/rcar-du.h       |  55 +-----
 15 files changed, 611 insertions(+), 463 deletions(-)
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_connector.c
 create mode 100644 drivers/gpu/drm/rcar-du/rcar_du_connector.h
 delete mode 100644 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c
 delete mode 100644 drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h
 delete mode 100644 drivers/gpu/drm/rcar-du/rcar_du_vgacon.c
 delete mode 100644 drivers/gpu/drm/rcar-du/rcar_du_vgacon.h

diff --git a/drivers/gpu/drm/rcar-du/Kconfig b/drivers/gpu/drm/rcar-du/Kconfig
index c590cd9..a54eeba 100644
--- a/drivers/gpu/drm/rcar-du/Kconfig
+++ b/drivers/gpu/drm/rcar-du/Kconfig
@@ -1,9 +1,10 @@
 config DRM_RCAR_DU
 	tristate "DRM Support for R-Car Display Unit"
-	depends on DRM && ARM
+	depends on DRM && ARM && OF
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
 	select DRM_GEM_CMA_HELPER
+	select VIDEOMODE_HELPERS
 	help
 	  Choose this option if you have an R-Car chipset.
 	  If M is selected the module will be called rcar-du-drm.
diff --git a/drivers/gpu/drm/rcar-du/Makefile b/drivers/gpu/drm/rcar-du/Makefile
index 12b8d44..3ac8566 100644
--- a/drivers/gpu/drm/rcar-du/Makefile
+++ b/drivers/gpu/drm/rcar-du/Makefile
@@ -1,11 +1,10 @@
-rcar-du-drm-y := rcar_du_crtc.o \
+rcar-du-drm-y := rcar_du_connector.o \
+		 rcar_du_crtc.o \
 		 rcar_du_drv.o \
 		 rcar_du_encoder.o \
 		 rcar_du_group.o \
 		 rcar_du_kms.o \
-		 rcar_du_lvdscon.o \
-		 rcar_du_plane.o \
-		 rcar_du_vgacon.o
+		 rcar_du_plane.o
 
 rcar-du-drm-$(CONFIG_DRM_RCAR_LVDS)	+= rcar_du_lvdsenc.o
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_connector.c b/drivers/gpu/drm/rcar-du/rcar_du_connector.c
new file mode 100644
index 0000000..a09aada
--- /dev/null
+++ b/drivers/gpu/drm/rcar-du/rcar_du_connector.c
@@ -0,0 +1,164 @@
+/*
+ * rcar_du_connector.c  --  R-Car Display Unit Connector
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/export.h>
+#include <video/videomode.h>
+
+#include <drm/drmP.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+
+#include "rcar_du_drv.h"
+#include "rcar_du_connector.h"
+#include "rcar_du_encoder.h"
+#include "rcar_du_kms.h"
+
+static int rcar_du_connector_get_modes(struct drm_connector *connector)
+{
+	struct rcar_du_connector *rcon = to_rcar_connector(connector);
+	struct display_entity *entity = to_display_entity(rcon->pad->entity);
+	const struct videomode *modes;
+	int ret;
+	int i;
+
+	ret = display_entity_get_modes(entity, rcon->pad->index, &modes);
+	if (ret <= 0)
+		return drm_add_modes_noedid(connector, 1280, 768);
+
+	for (i = 0; i < ret; ++i) {
+		struct drm_display_mode *mode;
+
+		mode = drm_mode_create(connector->dev);
+		if (mode == NULL)
+			break;
+
+		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
+		drm_display_mode_from_videomode(&modes[i], mode);
+		drm_mode_probed_add(connector, mode);
+	}
+
+	return i;
+}
+
+static int rcar_du_connector_mode_valid(struct drm_connector *connector,
+					struct drm_display_mode *mode)
+{
+	return MODE_OK;
+}
+
+static struct drm_encoder *
+rcar_du_connector_best_encoder(struct drm_connector *connector)
+{
+	struct rcar_du_connector *rcon = to_rcar_connector(connector);
+
+	return &rcon->encoder->encoder;
+}
+
+static const struct drm_connector_helper_funcs connector_helper_funcs = {
+	.get_modes = rcar_du_connector_get_modes,
+	.mode_valid = rcar_du_connector_mode_valid,
+	.best_encoder = rcar_du_connector_best_encoder,
+};
+
+static void rcar_du_connector_destroy(struct drm_connector *connector)
+{
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+}
+
+static enum drm_connector_status
+rcar_du_connector_detect(struct drm_connector *connector, bool force)
+{
+	return connector_status_connected;
+}
+
+static const struct drm_connector_funcs connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = rcar_du_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = rcar_du_connector_destroy,
+};
+
+struct rcar_du_connector *
+rcar_du_connector_create(struct rcar_du_device *rcdu,
+			 struct rcar_du_encoder *renc, struct media_pad *pad)
+{
+	struct display_entity *entity = to_display_entity(pad->entity);
+	struct display_entity_interface_params params;
+	struct rcar_du_connector *rcon;
+	struct drm_connector *connector;
+	int connector_type;
+	unsigned int width;
+	unsigned int height;
+	int ret;
+
+	rcon = devm_kzalloc(rcdu->dev, sizeof(*rcon), GFP_KERNEL);
+	if (rcon == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	rcon->encoder = renc;
+	rcon->pad = pad;
+
+	connector = &rcon->connector;
+
+	ret = display_entity_get_size(entity, &width, &height);
+	if (ret < 0) {
+		connector->display_info.width_mm = 0;
+		connector->display_info.height_mm = 0;
+	} else {
+		connector->display_info.width_mm = width;
+		connector->display_info.height_mm = height;
+	}
+
+	ret = display_entity_get_params(entity, pad->index, &params);
+	if (ret < 0) {
+		dev_dbg(rcdu->dev,
+			"failed to retrieve connector %s parameters\n",
+			entity->name);
+		return ERR_PTR(ret);
+	}
+
+	switch (params.type) {
+	case DISPLAY_ENTITY_INTERFACE_VGA:
+		connector_type = DRM_MODE_CONNECTOR_VGA;
+		break;
+	case DISPLAY_ENTITY_INTERFACE_LVDS:
+		connector_type = DRM_MODE_CONNECTOR_LVDS;
+		break;
+	default:
+		connector_type = DRM_MODE_CONNECTOR_Unknown;
+		break;
+	}
+
+	ret = drm_connector_init(rcdu->ddev, connector, &connector_funcs,
+				 connector_type);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	drm_connector_helper_add(connector, &connector_helper_funcs);
+	ret = drm_sysfs_connector_add(connector);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
+	drm_object_property_set_value(&connector->base,
+		rcdu->ddev->mode_config.dpms_property, DRM_MODE_DPMS_OFF);
+
+	ret = drm_mode_connector_attach_encoder(connector, &renc->encoder);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	connector->encoder = &renc->encoder;
+
+	return rcon;
+}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_connector.h b/drivers/gpu/drm/rcar-du/rcar_du_connector.h
new file mode 100644
index 0000000..b9a0833
--- /dev/null
+++ b/drivers/gpu/drm/rcar-du/rcar_du_connector.h
@@ -0,0 +1,36 @@
+/*
+ * rcar_du_connector.h  --  R-Car Display Unit Connector
+ *
+ * Copyright (C) 2013 Renesas Corporation
+ *
+ * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __RCAR_DU_CONNECTOR_H__
+#define __RCAR_DU_CONNECTOR_H__
+
+#include <drm/drm_crtc.h>
+
+struct media_pad;
+struct rcar_du_device;
+struct rcar_du_encoder;
+
+struct rcar_du_connector {
+	struct drm_connector connector;
+	struct rcar_du_encoder *encoder;
+	struct media_pad *pad;
+};
+
+#define to_rcar_connector(c) \
+	container_of(c, struct rcar_du_connector, connector)
+
+struct rcar_du_connector *
+rcar_du_connector_create(struct rcar_du_device *rcdu,
+			 struct rcar_du_encoder *renc, struct media_pad *pad);
+
+#endif /* __RCAR_DU_CONNECTOR_H__ */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
index 43e7575..4e8bfff 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_crtc.h
@@ -15,11 +15,11 @@
 #define __RCAR_DU_CRTC_H__
 
 #include <linux/mutex.h>
-#include <linux/platform_data/rcar-du.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
 
+enum rcar_du_output;
 struct rcar_du_group;
 struct rcar_du_plane;
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.c b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
index 0a9f1bb..eda9ca9 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.c
@@ -15,6 +15,8 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/platform_data/rcar-du.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
@@ -30,6 +32,153 @@
 #include "rcar_du_regs.h"
 
 /* -----------------------------------------------------------------------------
+ * Display Entities
+ */
+
+static int rcdu_entity_set_stream(struct display_entity *ent, unsigned int port,
+				  enum display_entity_stream_state state)
+{
+	return 0;
+}
+
+static const struct display_entity_video_ops rcdu_entity_video_ops = {
+	.set_stream = rcdu_entity_set_stream,
+};
+
+static const struct display_entity_ops rcdu_entity_ops = {
+	.video = &rcdu_entity_video_ops,
+};
+
+static struct media_pad *rcar_du_find_remote_pad(struct rcar_du_device *rcdu,
+						 unsigned int local_pad)
+{
+	struct display_entity *entity;
+	unsigned int i;
+
+	list_for_each_entry(entity, &rcdu->notifier.done, list) {
+		const struct display_entity_graph_data *graph =
+			entity->match->data;
+		const struct display_entity_source_data *source =
+			graph->sources;
+
+		for (i = 0; i < entity->entity.num_pads; ++i) {
+			struct media_pad *pad = &entity->entity.pads[i];
+
+			if (pad->flags & MEDIA_PAD_FL_SOURCE)
+				continue;
+
+			if (!strcmp(source->name, "rcar-du") &&
+			   source->port == local_pad)
+				return pad;
+		}
+	}
+
+	return NULL;
+}
+
+static int rcar_du_create_local_links(struct rcar_du_device *rcdu)
+{
+	u32 link_flags = MEDIA_LNK_FL_IMMUTABLE | MEDIA_LNK_FL_ENABLED;
+	unsigned int i;
+
+	for (i = 0; i < rcdu->entity.entity.num_pads; ++i) {
+		struct media_pad *pad;
+		int ret;
+
+		pad = rcar_du_find_remote_pad(rcdu, i);
+		if (pad == NULL)
+			continue;
+
+		ret = media_entity_create_link(&rcdu->entity.entity, i,
+					       pad->entity, pad->index,
+					       link_flags);
+		if (ret < 0) {
+			dev_err(rcdu->dev,
+				"failed to create %s:%u -> %s:%u link\n",
+				rcdu->entity.entity.name, i,
+				pad->entity->name, pad->index);
+			return ret;
+		}
+	}
+
+	return 0;
+};
+
+static int rcar_du_graph_init(struct rcar_du_device *rcdu)
+{
+	struct display_entity *entity;
+	unsigned int num_pads;
+	unsigned int i;
+	int ret;
+
+	/* Count the number of output pads and initialize the DU entity. */
+	for (i = 0, num_pads = 0; rcdu->info->routes[i].output; ++i)
+		num_pads++;
+
+	rcdu->entity.dev = rcdu->dev;
+	rcdu->entity.ops = &rcdu_entity_ops;
+	strcpy(rcdu->entity.name, "R-Car DU");
+
+	ret = display_entity_init(&rcdu->entity, 0, num_pads);
+	if (ret < 0)
+		return ret;
+
+	/* Create links between all entities. In the non-DT case, this is a two
+	 * steps process, we first create links between all external entities,
+	 * and then between the DU entity and the external entities.
+	 */
+	if (rcdu->dev->of_node) {
+		ret = display_of_entity_link_graph(rcdu->dev,
+						   &rcdu->notifier.done,
+						   &rcdu->entity);
+	} else {
+		ret = display_entity_link_graph(rcdu->dev,
+						&rcdu->notifier.done);
+		if (!ret)
+			ret = rcar_du_create_local_links(rcdu);
+	}
+
+	if (ret < 0) {
+		dev_err(rcdu->dev, "unable to link graph\n");
+		return ret;
+	}
+
+	/* Register the media device and all entities. */
+	rcdu->mdev.dev = rcdu->dev;
+	strlcpy(rcdu->mdev.model, dev_name(rcdu->dev),
+		sizeof(rcdu->mdev.model));
+
+	ret = media_device_register(&rcdu->mdev);
+	if (ret < 0)
+		return ret;
+
+	list_for_each_entry(entity, &rcdu->notifier.done, list) {
+		ret = display_entity_register(&rcdu->mdev, entity);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = display_entity_register(&rcdu->mdev, &rcdu->entity);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void rcar_du_graph_cleanup(struct rcar_du_device *rcdu)
+{
+	struct display_entity *entity;
+
+	list_for_each_entry(entity, &rcdu->notifier.done, list)
+		display_entity_unregister(entity);
+
+	display_entity_unregister(&rcdu->entity);
+	display_entity_cleanup(&rcdu->entity);
+
+	media_device_unregister(&rcdu->mdev);
+}
+
+/* -----------------------------------------------------------------------------
  * DRM operations
  */
 
@@ -44,6 +193,8 @@ static int rcar_du_unload(struct drm_device *dev)
 	drm_mode_config_cleanup(dev);
 	drm_vblank_cleanup(dev);
 
+	rcar_du_graph_cleanup(rcdu);
+
 	dev->irq_enabled = 0;
 	dev->dev_private = NULL;
 
@@ -53,25 +204,10 @@ static int rcar_du_unload(struct drm_device *dev)
 static int rcar_du_load(struct drm_device *dev, unsigned long flags)
 {
 	struct platform_device *pdev = dev->platformdev;
-	struct rcar_du_platform_data *pdata = pdev->dev.platform_data;
-	struct rcar_du_device *rcdu;
+	struct rcar_du_device *rcdu = platform_get_drvdata(pdev);
 	struct resource *mem;
 	int ret;
 
-	if (pdata == NULL) {
-		dev_err(dev->dev, "no platform data\n");
-		return -ENODEV;
-	}
-
-	rcdu = devm_kzalloc(&pdev->dev, sizeof(*rcdu), GFP_KERNEL);
-	if (rcdu == NULL) {
-		dev_err(dev->dev, "failed to allocate private data\n");
-		return -ENOMEM;
-	}
-
-	rcdu->dev = &pdev->dev;
-	rcdu->pdata = pdata;
-	rcdu->info = (struct rcar_du_device_info *)pdev->id_entry->driver_data;
 	rcdu->ddev = dev;
 	dev->dev_private = rcdu;
 
@@ -81,6 +217,13 @@ static int rcar_du_load(struct drm_device *dev, unsigned long flags)
 	if (IS_ERR(rcdu->mmio))
 		return PTR_ERR(rcdu->mmio);
 
+	/* Display Entities */
+	ret = rcar_du_graph_init(rcdu);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "failed to initialize display entities\n");
+		goto done;
+	}
+
 	/* DRM/KMS objects */
 	ret = rcar_du_modeset_init(rcdu);
 	if (ret < 0) {
@@ -97,8 +240,6 @@ static int rcar_du_load(struct drm_device *dev, unsigned long flags)
 
 	dev->irq_enabled = 1;
 
-	platform_set_drvdata(pdev, rcdu);
-
 done:
 	if (ret)
 		rcar_du_unload(dev);
@@ -218,33 +359,23 @@ static const struct dev_pm_ops rcar_du_pm_ops = {
  * Platform driver
  */
 
-static int rcar_du_probe(struct platform_device *pdev)
-{
-	return drm_platform_init(&rcar_du_driver, pdev);
-}
-
-static int rcar_du_remove(struct platform_device *pdev)
-{
-	drm_platform_exit(&rcar_du_driver, pdev);
-
-	return 0;
-}
-
 static const struct rcar_du_device_info rcar_du_r8a7779_info = {
 	.features = 0,
 	.num_crtcs = 2,
-	.routes = {
+	.routes = (const struct rcar_du_output_routing[]) {
 		/* R8A7779 has two RGB outputs and one (currently unsupported)
 		 * TCON output.
 		 */
-		[RCAR_DU_OUTPUT_DPAD0] = {
+		{
+			.output = RCAR_DU_OUTPUT_DPAD0,
 			.possible_crtcs = BIT(0),
 			.encoder_type = DRM_MODE_ENCODER_NONE,
-		},
-		[RCAR_DU_OUTPUT_DPAD1] = {
+		}, {
+			.output = RCAR_DU_OUTPUT_DPAD1,
 			.possible_crtcs = BIT(1) | BIT(0),
 			.encoder_type = DRM_MODE_ENCODER_NONE,
 		},
+		{ },
 	},
 	.num_lvds = 0,
 };
@@ -253,22 +384,24 @@ static const struct rcar_du_device_info rcar_du_r8a7790_info = {
 	.features = RCAR_DU_FEATURE_CRTC_IRQ_CLOCK | RCAR_DU_FEATURE_ALIGN_128B
 		  | RCAR_DU_FEATURE_DEFR8,
 	.num_crtcs = 3,
-	.routes = {
+	.routes = (const struct rcar_du_output_routing[]) {
 		/* R8A7790 has one RGB output, two LVDS outputs and one
 		 * (currently unsupported) TCON output.
 		 */
-		[RCAR_DU_OUTPUT_DPAD0] = {
+		{
+			.output = RCAR_DU_OUTPUT_DPAD0,
 			.possible_crtcs = BIT(2) | BIT(1) | BIT(0),
 			.encoder_type = DRM_MODE_ENCODER_NONE,
-		},
-		[RCAR_DU_OUTPUT_LVDS0] = {
+		}, {
+			.output = RCAR_DU_OUTPUT_LVDS0,
 			.possible_crtcs = BIT(0),
 			.encoder_type = DRM_MODE_ENCODER_LVDS,
-		},
-		[RCAR_DU_OUTPUT_LVDS1] = {
+		}, {
+			.output = RCAR_DU_OUTPUT_LVDS1,
 			.possible_crtcs = BIT(2) | BIT(1),
 			.encoder_type = DRM_MODE_ENCODER_LVDS,
 		},
+		{ },
 	},
 	.num_lvds = 2,
 };
@@ -278,9 +411,72 @@ static const struct platform_device_id rcar_du_id_table[] = {
 	{ "rcar-du-r8a7790", (kernel_ulong_t)&rcar_du_r8a7790_info },
 	{ }
 };
-
 MODULE_DEVICE_TABLE(platform, rcar_du_id_table);
 
+static const struct of_device_id rcar_du_of_table[] = {
+	{ .compatible = "renesas,du-r8a7779", .data = &rcar_du_r8a7779_info },
+	{ .compatible = "renesas,du-r8a7790", .data = &rcar_du_r8a7790_info },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, rcar_du_of_table);
+
+static int rcar_du_notifier_complete(struct display_entity_notifier *notifier)
+{
+	struct platform_device *pdev = to_platform_device(notifier->dev);
+
+	return drm_platform_init(&rcar_du_driver, pdev);
+}
+
+static int rcar_du_probe(struct platform_device *pdev)
+{
+	struct rcar_du_platform_data *pdata = pdev->dev.platform_data;
+	struct device_node *np = pdev->dev.of_node;
+	struct rcar_du_device *rcdu;
+	int ret;
+
+	rcdu = devm_kzalloc(&pdev->dev, sizeof(*rcdu), GFP_KERNEL);
+	if (rcdu == NULL)
+		return -ENOMEM;
+
+	rcdu->dev = &pdev->dev;
+
+	if (np)
+		rcdu->info = of_match_device(rcar_du_of_table, rcdu->dev)->data;
+	else
+		rcdu->info = (void *)platform_get_device_id(pdev)->driver_data;
+
+	platform_set_drvdata(pdev, rcdu);
+
+	rcdu->notifier.dev = rcdu->dev;
+	rcdu->notifier.complete = rcar_du_notifier_complete;
+
+	if (np) {
+		ret = display_of_entity_build_notifier(&rcdu->notifier, np);
+	} else if (pdata) {
+		ret = display_entity_build_notifier(&rcdu->notifier,
+						    pdata->graph);
+	} else {
+		dev_err(&pdev->dev, "no platform data");
+		ret = -ENXIO;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	return display_entity_register_notifier(&rcdu->notifier);
+}
+
+static int rcar_du_remove(struct platform_device *pdev)
+{
+	struct rcar_du_device *rcdu = platform_get_drvdata(pdev);
+
+	display_entity_unregister_notifier(&rcdu->notifier);
+
+	drm_platform_exit(&rcar_du_driver, pdev);
+
+	return 0;
+}
+
 static struct platform_driver rcar_du_platform_driver = {
 	.probe		= rcar_du_probe,
 	.remove		= rcar_du_remove,
@@ -288,6 +484,7 @@ static struct platform_driver rcar_du_platform_driver = {
 		.owner	= THIS_MODULE,
 		.name	= "rcar-du",
 		.pm	= &rcar_du_pm_ops,
+		.of_match_table = of_match_ptr(rcar_du_of_table),
 	},
 	.id_table	= rcar_du_id_table,
 };
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_drv.h b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
index 65d2d63..49338e1 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_drv.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_drv.h
@@ -15,7 +15,8 @@
 #define __RCAR_DU_DRV_H__
 
 #include <linux/kernel.h>
-#include <linux/platform_data/rcar-du.h>
+#include <media/media-device.h>
+#include <video/display.h>
 
 #include "rcar_du_crtc.h"
 #include "rcar_du_group.h"
@@ -31,16 +32,28 @@ struct rcar_du_lvdsenc;
 #define RCAR_DU_FEATURE_ALIGN_128B	(1 << 1)	/* Align pitches to 128 bytes */
 #define RCAR_DU_FEATURE_DEFR8		(1 << 2)	/* Has DEFR8 register */
 
+enum rcar_du_output {
+	RCAR_DU_OUTPUT_NONE,
+	RCAR_DU_OUTPUT_DPAD0,
+	RCAR_DU_OUTPUT_DPAD1,
+	RCAR_DU_OUTPUT_LVDS0,
+	RCAR_DU_OUTPUT_LVDS1,
+	RCAR_DU_OUTPUT_TCON,
+	RCAR_DU_OUTPUT_MAX,
+};
+
 /*
  * struct rcar_du_output_routing - Output routing specification
+ * @output: DU output
  * @possible_crtcs: bitmask of possible CRTCs for the output
  * @encoder_type: DRM type of the internal encoder associated with the output
  *
  * The DU has 5 possible outputs (DPAD0/1, LVDS0/1, TCON). Output routing data
- * specify the valid SoC outputs, which CRTCs can drive the output, and the type
- * of in-SoC encoder for the output.
+ * specify an SoC output, which CRTCs can drive it, and the type of in-SoC
+ * encoder for the output.
  */
 struct rcar_du_output_routing {
+	enum rcar_du_output output;
 	unsigned int possible_crtcs;
 	unsigned int encoder_type;
 };
@@ -49,23 +62,26 @@ struct rcar_du_output_routing {
  * struct rcar_du_device_info - DU model-specific information
  * @features: device features (RCAR_DU_FEATURE_*)
  * @num_crtcs: total number of CRTCs
- * @routes: array of CRTC to output routes, indexed by output (RCAR_DU_OUTPUT_*)
+ * @routes: array of CRTC to output routes, indexed by port number
  * @num_lvds: number of internal LVDS encoders
  */
 struct rcar_du_device_info {
 	unsigned int features;
 	unsigned int num_crtcs;
-	struct rcar_du_output_routing routes[RCAR_DU_OUTPUT_MAX];
+	const struct rcar_du_output_routing *routes;
 	unsigned int num_lvds;
 };
 
 struct rcar_du_device {
 	struct device *dev;
-	const struct rcar_du_platform_data *pdata;
 	const struct rcar_du_device_info *info;
 
 	void __iomem *mmio;
 
+	struct media_device mdev;
+	struct display_entity entity;
+	struct display_entity_notifier notifier;
+
 	struct drm_device *ddev;
 	struct drm_fbdev_cma *fbdev;
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_encoder.c b/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
index 3daa7a1..9991fb0 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_encoder.c
@@ -20,25 +20,7 @@
 #include "rcar_du_drv.h"
 #include "rcar_du_encoder.h"
 #include "rcar_du_kms.h"
-#include "rcar_du_lvdscon.h"
 #include "rcar_du_lvdsenc.h"
-#include "rcar_du_vgacon.h"
-
-/* -----------------------------------------------------------------------------
- * Common connector functions
- */
-
-struct drm_encoder *
-rcar_du_connector_best_encoder(struct drm_connector *connector)
-{
-	struct rcar_du_connector *rcon = to_rcar_connector(connector);
-
-	return &rcon->encoder->encoder;
-}
-
-/* -----------------------------------------------------------------------------
- * Encoder
- */
 
 static void rcar_du_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
@@ -139,10 +121,9 @@ static const struct drm_encoder_funcs encoder_funcs = {
 	.destroy = drm_encoder_cleanup,
 };
 
-int rcar_du_encoder_init(struct rcar_du_device *rcdu,
-			 enum rcar_du_encoder_type type,
-			 enum rcar_du_output output,
-			 const struct rcar_du_encoder_data *data)
+struct rcar_du_encoder *
+rcar_du_encoder_create(struct rcar_du_device *rcdu, unsigned int port,
+		       struct media_pad *pad)
 {
 	struct rcar_du_encoder *renc;
 	unsigned int encoder_type;
@@ -150,11 +131,13 @@ int rcar_du_encoder_init(struct rcar_du_device *rcdu,
 
 	renc = devm_kzalloc(rcdu->dev, sizeof(*renc), GFP_KERNEL);
 	if (renc == NULL)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
-	renc->output = output;
+	renc->port = port;
+	renc->output = rcdu->info->routes[port].output;
 
-	switch (output) {
+	/* Do we have an internal LVDS encoder? */
+	switch (renc->output) {
 	case RCAR_DU_OUTPUT_LVDS0:
 		renc->lvds = rcdu->lvds[0];
 		break;
@@ -167,36 +150,44 @@ int rcar_du_encoder_init(struct rcar_du_device *rcdu,
 		break;
 	}
 
-	switch (type) {
-	case RCAR_DU_ENCODER_VGA:
-		encoder_type = DRM_MODE_ENCODER_DAC;
-		break;
-	case RCAR_DU_ENCODER_LVDS:
-		encoder_type = DRM_MODE_ENCODER_LVDS;
-		break;
-	case RCAR_DU_ENCODER_NONE:
-	default:
+	/* Find the encoder type. */
+	if (pad) {
+		struct display_entity *entity = to_display_entity(pad->entity);
+		struct display_entity_interface_params params;
+
+		ret = display_entity_get_params(entity, pad->index, &params);
+		if (ret < 0) {
+			dev_dbg(rcdu->dev,
+				"failed to retrieve encoder %s parameters\n",
+				entity->name);
+			return ERR_PTR(ret);
+		}
+
+		switch (params.type) {
+		case DISPLAY_ENTITY_INTERFACE_DPI:
+		case DISPLAY_ENTITY_INTERFACE_DBI:
+		default:
+			encoder_type = DRM_MODE_ENCODER_NONE;
+			break;
+		case DISPLAY_ENTITY_INTERFACE_LVDS:
+			encoder_type = DRM_MODE_ENCODER_DAC;
+			break;
+		case DISPLAY_ENTITY_INTERFACE_VGA:
+			encoder_type = DRM_MODE_ENCODER_DAC;
+			break;
+		}
+	} else {
 		/* No external encoder, use the internal encoder type. */
-		encoder_type = rcdu->info->routes[output].encoder_type;
-		break;
+		encoder_type = rcdu->info->routes[port].encoder_type;
 	}
 
+	/* Initialize the encoder. */
 	ret = drm_encoder_init(rcdu->ddev, &renc->encoder, &encoder_funcs,
 			       encoder_type);
 	if (ret < 0)
-		return ret;
+		return ERR_PTR(ret);
 
 	drm_encoder_helper_add(&renc->encoder, &encoder_helper_funcs);
 
-	switch (encoder_type) {
-	case DRM_MODE_ENCODER_LVDS:
-		return rcar_du_lvds_connector_init(rcdu, renc,
-						   &data->connector.lvds.panel);
-
-	case DRM_MODE_ENCODER_DAC:
-		return rcar_du_vga_connector_init(rcdu, renc);
-
-	default:
-		return -EINVAL;
-	}
+	return renc;
 }
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_encoder.h b/drivers/gpu/drm/rcar-du/rcar_du_encoder.h
index 0e5a65e..7a19d5b 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_encoder.h
+++ b/drivers/gpu/drm/rcar-du/rcar_du_encoder.h
@@ -14,15 +14,15 @@
 #ifndef __RCAR_DU_ENCODER_H__
 #define __RCAR_DU_ENCODER_H__
 
-#include <linux/platform_data/rcar-du.h>
-
 #include <drm/drm_crtc.h>
 
+struct media_pad;
 struct rcar_du_device;
 struct rcar_du_lvdsenc;
 
 struct rcar_du_encoder {
 	struct drm_encoder encoder;
+	unsigned int port;
 	enum rcar_du_output output;
 	struct rcar_du_lvdsenc *lvds;
 };
@@ -30,20 +30,8 @@ struct rcar_du_encoder {
 #define to_rcar_encoder(e) \
 	container_of(e, struct rcar_du_encoder, encoder)
 
-struct rcar_du_connector {
-	struct drm_connector connector;
-	struct rcar_du_encoder *encoder;
-};
-
-#define to_rcar_connector(c) \
-	container_of(c, struct rcar_du_connector, connector)
-
-struct drm_encoder *
-rcar_du_connector_best_encoder(struct drm_connector *connector);
-
-int rcar_du_encoder_init(struct rcar_du_device *rcdu,
-			 enum rcar_du_encoder_type type,
-			 enum rcar_du_output output,
-			 const struct rcar_du_encoder_data *data);
+struct rcar_du_encoder *
+rcar_du_encoder_create(struct rcar_du_device *rcdu, unsigned int port,
+		       struct media_pad *pad);
 
 #endif /* __RCAR_DU_ENCODER_H__ */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index b31ac08..2dc9e80 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -17,6 +17,7 @@
 #include <drm/drm_fb_cma_helper.h>
 #include <drm/drm_gem_cma_helper.h>
 
+#include "rcar_du_connector.h"
 #include "rcar_du_crtc.h"
 #include "rcar_du_drv.h"
 #include "rcar_du_encoder.h"
@@ -179,6 +180,89 @@ static const struct drm_mode_config_funcs rcar_du_mode_config_funcs = {
 	.output_poll_changed = rcar_du_output_poll_changed,
 };
 
+/* -----------------------------------------------------------------------------
+ * Pipeline and Mode Setting Initialization
+ */
+
+static int rcar_du_pipe_init(struct rcar_du_device *rcdu, unsigned int port,
+			     struct media_pad *remote)
+{
+	struct media_pad *pad_encoder = NULL;
+	struct media_pad *pad_connector = remote;
+	struct rcar_du_encoder *renc;
+	struct rcar_du_connector *rcon;
+	struct media_entity *entity;
+
+	/* We need to expose one KMS encoder and one KMS connector for an
+	 * arbitrarily long chain of external entities. Walk the chain and map
+	 * the last entity to the connector, and the next-to-last entity to the
+	 * encoder.
+	 */
+
+	/* Start at the entity connected to the DU output. */
+	entity = remote->entity;
+
+	dev_dbg(rcdu->dev, "%s: starting at entity %s pad %u\n", __func__,
+		entity->name, remote->index);
+
+	while (1) {
+		struct media_link *next = NULL;
+		unsigned int i;
+
+		/* Search the entity for an output link. As we only support
+		 * linear pipelines, return an error if multiple output links
+		 * are found.
+		 */
+		dev_dbg(rcdu->dev,
+			"%s: searching for an output link on entity %s\n",
+			__func__, entity->name);
+
+		for (i = 0; i < entity->num_links; ++i) {
+			struct media_link *link = &entity->links[i];
+
+			if (link->source->entity != entity)
+				continue;
+
+			if (next)
+				return -EPIPE;
+
+			next = link;
+		}
+
+		if (next == NULL) {
+			dev_dbg(rcdu->dev, "%s: not output link found\n",
+				__func__);
+			break;
+		}
+
+		dev_dbg(rcdu->dev,
+			"%s: output link %s:%u -> %s:%u found\n", __func__,
+			next->source->entity->name, next->source->index,
+			next->sink->entity->name, next->sink->index);
+
+		pad_encoder = next->source;
+		pad_connector = next->sink;
+		entity = pad_connector->entity;
+	}
+
+	dev_dbg(rcdu->dev,
+		"%s: encoder pad %s/%u connector pad %s/%u\n", __func__,
+		pad_encoder ? pad_encoder->entity->name : NULL,
+		pad_encoder ? pad_encoder->index : 0,
+		pad_connector->entity->name, pad_connector->index);
+
+	/* Create the encoder and connector. */
+	renc = rcar_du_encoder_create(rcdu, port, pad_encoder);
+	if (IS_ERR(renc))
+		return PTR_ERR(renc);
+
+	rcon = rcar_du_connector_create(rcdu, renc, pad_connector);
+	if (IS_ERR(rcon))
+		return PTR_ERR(rcon);
+
+	return 0;
+}
+
 int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 {
 	static const unsigned int mmio_offsets[] = {
@@ -188,6 +272,7 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 	struct drm_device *dev = rcdu->ddev;
 	struct drm_encoder *encoder;
 	struct drm_fbdev_cma *fbdev;
+	unsigned int num_encoders = 0;
 	unsigned int num_groups;
 	unsigned int i;
 	int ret;
@@ -226,29 +311,26 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 			return ret;
 	}
 
-	/* Initialize the encoders. */
+	/* Initialize the internal encoders. */
 	ret = rcar_du_lvdsenc_init(rcdu);
 	if (ret < 0)
 		return ret;
 
-	for (i = 0; i < rcdu->pdata->num_encoders; ++i) {
-		const struct rcar_du_encoder_data *pdata =
-			&rcdu->pdata->encoders[i];
-		const struct rcar_du_output_routing *route =
-			&rcdu->info->routes[pdata->output];
+	/* Create an encoder and a connector for each output connected to
+	 * external entities.
+	 */
+	for (i = 0; i < rcdu->entity.entity.num_pads; ++i) {
+		struct media_pad *pad;
 
-		if (pdata->type == RCAR_DU_ENCODER_UNUSED)
+		pad = media_entity_remote_pad(&rcdu->entity.entity.pads[i]);
+		if (pad == NULL)
 			continue;
 
-		if (pdata->output >= RCAR_DU_OUTPUT_MAX ||
-		    route->possible_crtcs == 0) {
-			dev_warn(rcdu->dev,
-				 "encoder %u references unexisting output %u, skipping\n",
-				 i, pdata->output);
-			continue;
-		}
+		ret = rcar_du_pipe_init(rcdu, i, pad);
+		if (ret < 0)
+			return ret;
 
-		rcar_du_encoder_init(rcdu, pdata->type, pdata->output, pdata);
+		num_encoders++;
 	}
 
 	/* Set the possible CRTCs and possible clones. There's always at least
@@ -258,10 +340,10 @@ int rcar_du_modeset_init(struct rcar_du_device *rcdu)
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
 		struct rcar_du_encoder *renc = to_rcar_encoder(encoder);
 		const struct rcar_du_output_routing *route =
-			&rcdu->info->routes[renc->output];
+			&rcdu->info->routes[renc->port];
 
 		encoder->possible_crtcs = route->possible_crtcs;
-		encoder->possible_clones = (1 << rcdu->pdata->num_encoders) - 1;
+		encoder->possible_clones = (1 << num_encoders) - 1;
 	}
 
 	/* Now that the CRTCs have been initialized register the planes. */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c b/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c
deleted file mode 100644
index 4f3ba93..0000000
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.c
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * rcar_du_lvdscon.c  --  R-Car Display Unit LVDS Connector
- *
- * Copyright (C) 2013 Renesas Corporation
- *
- * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <drm/drmP.h>
-#include <drm/drm_crtc.h>
-#include <drm/drm_crtc_helper.h>
-
-#include "rcar_du_drv.h"
-#include "rcar_du_encoder.h"
-#include "rcar_du_kms.h"
-#include "rcar_du_lvdscon.h"
-
-struct rcar_du_lvds_connector {
-	struct rcar_du_connector connector;
-
-	const struct rcar_du_panel_data *panel;
-};
-
-#define to_rcar_lvds_connector(c) \
-	container_of(c, struct rcar_du_lvds_connector, connector.connector)
-
-static int rcar_du_lvds_connector_get_modes(struct drm_connector *connector)
-{
-	struct rcar_du_lvds_connector *lvdscon =
-		to_rcar_lvds_connector(connector);
-	struct drm_display_mode *mode;
-
-	mode = drm_mode_create(connector->dev);
-	if (mode == NULL)
-		return 0;
-
-	mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
-	mode->clock = lvdscon->panel->mode.clock;
-	mode->hdisplay = lvdscon->panel->mode.hdisplay;
-	mode->hsync_start = lvdscon->panel->mode.hsync_start;
-	mode->hsync_end = lvdscon->panel->mode.hsync_end;
-	mode->htotal = lvdscon->panel->mode.htotal;
-	mode->vdisplay = lvdscon->panel->mode.vdisplay;
-	mode->vsync_start = lvdscon->panel->mode.vsync_start;
-	mode->vsync_end = lvdscon->panel->mode.vsync_end;
-	mode->vtotal = lvdscon->panel->mode.vtotal;
-	mode->flags = lvdscon->panel->mode.flags;
-
-	drm_mode_set_name(mode);
-	drm_mode_probed_add(connector, mode);
-
-	return 1;
-}
-
-static int rcar_du_lvds_connector_mode_valid(struct drm_connector *connector,
-					    struct drm_display_mode *mode)
-{
-	return MODE_OK;
-}
-
-static const struct drm_connector_helper_funcs connector_helper_funcs = {
-	.get_modes = rcar_du_lvds_connector_get_modes,
-	.mode_valid = rcar_du_lvds_connector_mode_valid,
-	.best_encoder = rcar_du_connector_best_encoder,
-};
-
-static void rcar_du_lvds_connector_destroy(struct drm_connector *connector)
-{
-	drm_sysfs_connector_remove(connector);
-	drm_connector_cleanup(connector);
-}
-
-static enum drm_connector_status
-rcar_du_lvds_connector_detect(struct drm_connector *connector, bool force)
-{
-	return connector_status_connected;
-}
-
-static const struct drm_connector_funcs connector_funcs = {
-	.dpms = drm_helper_connector_dpms,
-	.detect = rcar_du_lvds_connector_detect,
-	.fill_modes = drm_helper_probe_single_connector_modes,
-	.destroy = rcar_du_lvds_connector_destroy,
-};
-
-int rcar_du_lvds_connector_init(struct rcar_du_device *rcdu,
-				struct rcar_du_encoder *renc,
-				const struct rcar_du_panel_data *panel)
-{
-	struct rcar_du_lvds_connector *lvdscon;
-	struct drm_connector *connector;
-	int ret;
-
-	lvdscon = devm_kzalloc(rcdu->dev, sizeof(*lvdscon), GFP_KERNEL);
-	if (lvdscon == NULL)
-		return -ENOMEM;
-
-	lvdscon->panel = panel;
-
-	connector = &lvdscon->connector.connector;
-	connector->display_info.width_mm = panel->width_mm;
-	connector->display_info.height_mm = panel->height_mm;
-
-	ret = drm_connector_init(rcdu->ddev, connector, &connector_funcs,
-				 DRM_MODE_CONNECTOR_LVDS);
-	if (ret < 0)
-		return ret;
-
-	drm_connector_helper_add(connector, &connector_helper_funcs);
-	ret = drm_sysfs_connector_add(connector);
-	if (ret < 0)
-		return ret;
-
-	drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
-	drm_object_property_set_value(&connector->base,
-		rcdu->ddev->mode_config.dpms_property, DRM_MODE_DPMS_OFF);
-
-	ret = drm_mode_connector_attach_encoder(connector, &renc->encoder);
-	if (ret < 0)
-		return ret;
-
-	connector->encoder = &renc->encoder;
-	lvdscon->connector.encoder = renc;
-
-	return 0;
-}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h b/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h
deleted file mode 100644
index bff8683..0000000
--- a/drivers/gpu/drm/rcar-du/rcar_du_lvdscon.h
+++ /dev/null
@@ -1,25 +0,0 @@
-/*
- * rcar_du_lvdscon.h  --  R-Car Display Unit LVDS Connector
- *
- * Copyright (C) 2013 Renesas Corporation
- *
- * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __RCAR_DU_LVDSCON_H__
-#define __RCAR_DU_LVDSCON_H__
-
-struct rcar_du_device;
-struct rcar_du_encoder;
-struct rcar_du_panel_data;
-
-int rcar_du_lvds_connector_init(struct rcar_du_device *rcdu,
-				struct rcar_du_encoder *renc,
-				const struct rcar_du_panel_data *panel);
-
-#endif /* __RCAR_DU_LVDSCON_H__ */
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vgacon.c b/drivers/gpu/drm/rcar-du/rcar_du_vgacon.c
deleted file mode 100644
index 72312f7..0000000
--- a/drivers/gpu/drm/rcar-du/rcar_du_vgacon.c
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- * rcar_du_vgacon.c  --  R-Car Display Unit VGA Connector
- *
- * Copyright (C) 2013 Renesas Corporation
- *
- * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <drm/drmP.h>
-#include <drm/drm_crtc.h>
-#include <drm/drm_crtc_helper.h>
-
-#include "rcar_du_drv.h"
-#include "rcar_du_encoder.h"
-#include "rcar_du_kms.h"
-#include "rcar_du_vgacon.h"
-
-static int rcar_du_vga_connector_get_modes(struct drm_connector *connector)
-{
-	return drm_add_modes_noedid(connector, 1280, 768);
-}
-
-static int rcar_du_vga_connector_mode_valid(struct drm_connector *connector,
-					    struct drm_display_mode *mode)
-{
-	return MODE_OK;
-}
-
-static const struct drm_connector_helper_funcs connector_helper_funcs = {
-	.get_modes = rcar_du_vga_connector_get_modes,
-	.mode_valid = rcar_du_vga_connector_mode_valid,
-	.best_encoder = rcar_du_connector_best_encoder,
-};
-
-static void rcar_du_vga_connector_destroy(struct drm_connector *connector)
-{
-	drm_sysfs_connector_remove(connector);
-	drm_connector_cleanup(connector);
-}
-
-static enum drm_connector_status
-rcar_du_vga_connector_detect(struct drm_connector *connector, bool force)
-{
-	return connector_status_connected;
-}
-
-static const struct drm_connector_funcs connector_funcs = {
-	.dpms = drm_helper_connector_dpms,
-	.detect = rcar_du_vga_connector_detect,
-	.fill_modes = drm_helper_probe_single_connector_modes,
-	.destroy = rcar_du_vga_connector_destroy,
-};
-
-int rcar_du_vga_connector_init(struct rcar_du_device *rcdu,
-			       struct rcar_du_encoder *renc)
-{
-	struct rcar_du_connector *rcon;
-	struct drm_connector *connector;
-	int ret;
-
-	rcon = devm_kzalloc(rcdu->dev, sizeof(*rcon), GFP_KERNEL);
-	if (rcon == NULL)
-		return -ENOMEM;
-
-	connector = &rcon->connector;
-	connector->display_info.width_mm = 0;
-	connector->display_info.height_mm = 0;
-
-	ret = drm_connector_init(rcdu->ddev, connector, &connector_funcs,
-				 DRM_MODE_CONNECTOR_VGA);
-	if (ret < 0)
-		return ret;
-
-	drm_connector_helper_add(connector, &connector_helper_funcs);
-	ret = drm_sysfs_connector_add(connector);
-	if (ret < 0)
-		return ret;
-
-	drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
-	drm_object_property_set_value(&connector->base,
-		rcdu->ddev->mode_config.dpms_property, DRM_MODE_DPMS_OFF);
-
-	ret = drm_mode_connector_attach_encoder(connector, &renc->encoder);
-	if (ret < 0)
-		return ret;
-
-	connector->encoder = &renc->encoder;
-	rcon->encoder = renc;
-
-	return 0;
-}
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_vgacon.h b/drivers/gpu/drm/rcar-du/rcar_du_vgacon.h
deleted file mode 100644
index b12b0cf..0000000
--- a/drivers/gpu/drm/rcar-du/rcar_du_vgacon.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * rcar_du_vgacon.h  --  R-Car Display Unit VGA Connector
- *
- * Copyright (C) 2013 Renesas Corporation
- *
- * Contact: Laurent Pinchart (laurent.pinchart@ideasonboard.com)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __RCAR_DU_VGACON_H__
-#define __RCAR_DU_VGACON_H__
-
-struct rcar_du_device;
-struct rcar_du_encoder;
-
-int rcar_du_vga_connector_init(struct rcar_du_device *rcdu,
-			       struct rcar_du_encoder *renc);
-
-#endif /* __RCAR_DU_VGACON_H__ */
diff --git a/include/linux/platform_data/rcar-du.h b/include/linux/platform_data/rcar-du.h
index 1a2e990..b424b75 100644
--- a/include/linux/platform_data/rcar-du.h
+++ b/include/linux/platform_data/rcar-du.h
@@ -14,61 +14,10 @@
 #ifndef __RCAR_DU_H__
 #define __RCAR_DU_H__
 
-#include <drm/drm_mode.h>
-
-enum rcar_du_output {
-	RCAR_DU_OUTPUT_DPAD0,
-	RCAR_DU_OUTPUT_DPAD1,
-	RCAR_DU_OUTPUT_LVDS0,
-	RCAR_DU_OUTPUT_LVDS1,
-	RCAR_DU_OUTPUT_TCON,
-	RCAR_DU_OUTPUT_MAX,
-};
-
-enum rcar_du_encoder_type {
-	RCAR_DU_ENCODER_UNUSED = 0,
-	RCAR_DU_ENCODER_NONE,
-	RCAR_DU_ENCODER_VGA,
-	RCAR_DU_ENCODER_LVDS,
-};
-
-struct rcar_du_panel_data {
-	unsigned int width_mm;		/* Panel width in mm */
-	unsigned int height_mm;		/* Panel height in mm */
-	struct drm_mode_modeinfo mode;
-};
-
-struct rcar_du_connector_lvds_data {
-	struct rcar_du_panel_data panel;
-};
-
-struct rcar_du_connector_vga_data {
-	/* TODO: Add DDC information for EDID retrieval */
-};
-
-/*
- * struct rcar_du_encoder_data - Encoder platform data
- * @type: the encoder type (RCAR_DU_ENCODER_*)
- * @output: the DU output the connector is connected to (RCAR_DU_OUTPUT_*)
- * @connector.lvds: platform data for LVDS connectors
- * @connector.vga: platform data for VGA connectors
- *
- * Encoder platform data describes an on-board encoder, its associated DU SoC
- * output, and the connector.
- */
-struct rcar_du_encoder_data {
-	enum rcar_du_encoder_type type;
-	enum rcar_du_output output;
-
-	union {
-		struct rcar_du_connector_lvds_data lvds;
-		struct rcar_du_connector_vga_data vga;
-	} connector;
-};
+#include <video/display.h>
 
 struct rcar_du_platform_data {
-	struct rcar_du_encoder_data *encoders;
-	unsigned int num_encoders;
+	const struct display_entity_graph_data *graph;
 };
 
 #endif /* __RCAR_DU_H__ */
-- 
1.8.1.5

