Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41537 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3I0SvG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Sep 2013 14:51:06 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj1so3161565pad.14
        for <linux-media@vger.kernel.org>; Fri, 27 Sep 2013 11:51:06 -0700 (PDT)
From: Show Liu <show.liu@linaro.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-media@vger.kernel.org, tom.gall@linaro.org,
	t.katayama@jp.fujitsu.com, vikas.sajjan@linaro.org,
	linaro-kernel@lists.linaro.org, tom.cooksey@arm.com,
	Show Liu <show.liu@linaro.org>
Subject: [PATCH/RFC v3 1/3] Add display entities and pipe link for pl111
Date: Sat, 28 Sep 2013 02:50:44 +0800
Message-Id: <1380307846-27479-2-git-send-email-show.liu@linaro.org>
In-Reply-To: <1380307846-27479-1-git-send-email-show.liu@linaro.org>
References: <1380307846-27479-1-git-send-email-show.liu@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---
 drivers/gpu/drm/pl111/pl111_drm.h        |   23 +-
 drivers/gpu/drm/pl111/pl111_drm_device.c |  374 ++++++++++++++++++++++++++++--
 2 files changed, 370 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/pl111/pl111_drm.h b/drivers/gpu/drm/pl111/pl111_drm.h
index faf88cb..f81f79e 100644
--- a/drivers/gpu/drm/pl111/pl111_drm.h
+++ b/drivers/gpu/drm/pl111/pl111_drm.h
@@ -19,6 +19,9 @@
 #ifndef _PL111_DRM_H_
 #define _PL111_DRM_H_
 
+#include <media/media-device.h>
+#include <video/display.h>
+
 /* Defines for drm_mode_create_dumb flags settings */
 #define PL111_BO_SCANOUT  0x00000001 /* scanout compatible buffer requested */
 
@@ -149,13 +152,17 @@ struct pl111_drm_crtc {
 				struct drm_framebuffer *fb);
 };
 
+struct pl111_drm_encoder {
+	struct drm_encoder encoder;
+	unsigned int port;
+};
+
 struct pl111_drm_connector {
 	struct drm_connector connector;
+	struct pl111_drm_encoder *encoder;
+	struct media_pad *pad;
 };
 
-struct pl111_drm_encoder {
-	struct drm_encoder encoder;
-};
 
 struct pl111_drm_dev_private {
 	struct pl111_drm_crtc *pl111_crtc;
@@ -186,6 +193,16 @@ struct pl111_drm_dev_private {
 
 	/* Cache for flip resources used to avoid kmalloc on each page flip */
 	struct kmem_cache *page_flip_slab;
+
+	struct drm_device *ddev;
+
+	/*
+	 *Display entities and notifier
+	 */
+	struct media_device mdev;
+	struct display_entity entity;
+	struct display_entity_notifier notifier;
+
 };
 
 enum pl111_cursor_size {
diff --git a/drivers/gpu/drm/pl111/pl111_drm_device.c b/drivers/gpu/drm/pl111/pl111_drm_device.c
index cf22ead..838506f 100644
--- a/drivers/gpu/drm/pl111/pl111_drm_device.c
+++ b/drivers/gpu/drm/pl111/pl111_drm_device.c
@@ -35,6 +35,25 @@
 
 struct pl111_drm_dev_private priv;
 
+/* -----------------------------------------------------------------------------
+ * Display Entities
+ */
+static int pl111_entity_set_stream(struct display_entity *ent,
+					unsigned int port,
+					enum display_entity_stream_state state)
+{
+	pr_info("DRM %s\n", __func__);
+	return 0;
+}
+
+static const struct display_entity_video_ops pl111_entity_video_ops = {
+		.set_stream = pl111_entity_set_stream,
+};
+
+static const struct display_entity_ops pl111_entity_ops = {
+		.video = &pl111_entity_video_ops,
+};
+
 #ifdef CONFIG_DMA_SHARED_BUFFER_USES_KDS
 static void initial_kds_obtained(void *cb1, void *cb2)
 {
@@ -94,13 +113,217 @@ struct drm_mode_config_funcs mode_config_funcs = {
 	.fb_create = pl111_fb_create,
 };
 
+struct pl111_drm_encoder *
+pl111_pad_encoder_create(struct pl111_drm_dev_private *priv,
+						 unsigned int port,
+						 struct media_pad *pad)
+{
+	struct pl111_drm_encoder *pl111_encoder;
+	struct device *dev = &priv->amba_dev->dev;
+	unsigned int encoder_type;
+	int ret;
+
+	pl111_encoder = devm_kzalloc(dev, sizeof(*pl111_encoder), GFP_KERNEL);
+	if (pl111_encoder == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	pl111_encoder->port = port;
+
+	/* Find the encoder type. */
+	if (pad) {
+		struct display_entity *entity = to_display_entity(pad->entity);
+		struct display_entity_interface_params params;
+
+		ret = display_entity_get_params(entity, pad->index, &params);
+		if (ret < 0) {
+			pr_err("DRM %s: failed to retrieve display entity %s parameters\n",
+					__func__,
+					entity->name);
+			return ERR_PTR(ret);
+		}
+
+		switch (params.type) {
+		case DISPLAY_ENTITY_INTERFACE_LVDS:
+			encoder_type = DRM_MODE_ENCODER_DAC;
+			break;
+		case DISPLAY_ENTITY_INTERFACE_VGA:
+			encoder_type = DRM_MODE_ENCODER_DAC;
+			break;
+		case DISPLAY_ENTITY_INTERFACE_DPI:
+		case DISPLAY_ENTITY_INTERFACE_DBI:
+		default:
+			encoder_type = DRM_MODE_ENCODER_NONE;
+			break;
+		}
+
+	} else {
+		/* No external encoder, use the internal encoder type. */
+		pr_err("DRM %s: No external encoder, use the internal encoder type.\n",
+				__func__);
+		encoder_type = DRM_MODE_ENCODER_DAC;
+	}
+
+	pl111_encoder = pl111_encoder_create(priv->ddev, 1);
+
+	return pl111_encoder;
+}
+
+struct pl111_drm_connector *
+pl111_pad_connector_create(struct pl111_drm_dev_private *priv,
+				struct pl111_drm_encoder *pl111_encoder,
+				struct media_pad *pad)
+{
+	struct display_entity *entity = to_display_entity(pad->entity);
+	struct display_entity_interface_params params;
+	struct pl111_drm_connector *pl111_connector;
+	struct drm_connector *connector;
+	struct device *dev = &priv->amba_dev->dev;
+	int connector_type;
+	unsigned int width;
+	unsigned int height;
+	int ret;
+
+	pl111_connector = devm_kzalloc(dev,
+					sizeof(*pl111_connector),
+					GFP_KERNEL);
+	if (pl111_connector == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	pl111_connector->encoder = pl111_encoder;
+	pl111_connector->pad = pad;
+	connector = &pl111_connector->connector;
+
+	ret = display_entity_get_size(entity, &width, &height);
+
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
+		pr_err("failed to retrieve connector %s parameters\n",
+				entity->name);
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
+	pl111_connector = pl111_connector_create(priv->ddev);
+	if (pl111_connector == NULL) {
+		pr_err("Failed to create pl111_drm_connector\n");
+		ret = -ENOMEM;
+	}
+
+	return pl111_connector;
+}
+
+static int pl111_pipe_init(struct pl111_drm_dev_private *priv,
+					unsigned int port,
+					struct media_pad *remote)
+{
+	struct media_pad *pad_encoder = NULL;
+	struct media_pad *pad_connector = remote;
+	struct pl111_drm_encoder *pl111_encoder;
+	struct pl111_drm_connector *pl111_connector;
+	struct media_entity *entity;
+	int ret;
+	/* Start at the entity connected to the pl111 output. */
+	entity = remote->entity;
+
+	pr_info("DRM %s: starting at entity %s pad %u\n", __func__,
+			entity->name, remote->index);
+
+	while (1) {
+		struct media_link *next = NULL;
+		unsigned int i;
+
+		pr_info("DRM %s: searching for an output link on entity %s\n",
+				__func__, entity->name);
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
+			pr_err(" DRM %s: not output link found\n", __func__);
+			break;
+		}
+
+		pr_info(" DRM %s: output link %s:%u -> %s:%u found\n", __func__,
+				next->source->entity->name, next->source->index,
+				next->sink->entity->name, next->sink->index);
+
+		pad_encoder = next->source;
+		pad_connector = next->sink;
+		entity = pad_connector->entity;
+	}
+
+	pr_info(" DRM %s: encoder pad %s/%u connector pad %s/%u\n", __func__,
+			pad_encoder ? pad_encoder->entity->name : NULL,
+			pad_encoder ? pad_encoder->index : 0,
+			pad_connector->entity->name, pad_connector->index);
+
+	/* Create the encoder and connector. */
+	pl111_encoder = pl111_pad_encoder_create(priv, port, pad_encoder);
+	if (IS_ERR(pl111_encoder))
+		return PTR_ERR(pl111_encoder);
+
+	pl111_connector = pl111_pad_connector_create(priv,
+						pl111_encoder,
+						pad_connector);
+
+	if (IS_ERR(pl111_connector))
+		return PTR_ERR(pl111_connector);
+
+	ret = drm_mode_connector_attach_encoder(&pl111_connector->connector,
+						&pl111_encoder->encoder);
+	if (ret != 0) {
+		pr_err("Failed to attach encoder\n");
+		goto out_config;
+	}
+
+	pl111_connector->connector.encoder = &pl111_encoder->encoder;
+
+	goto finish;
+
+out_config:
+	drm_mode_config_cleanup(priv->ddev);
+
+finish:
+	DRM_DEBUG("%s returned %d\n", __func__, ret);
+	return ret;
+}
+
 static int pl111_modeset_init(struct drm_device *dev)
 {
 	struct drm_mode_config *mode_config;
 	struct pl111_drm_dev_private *priv = dev->dev_private;
-	struct pl111_drm_connector *pl111_connector;
-	struct pl111_drm_encoder *pl111_encoder;
+
 	int ret = 0;
+	unsigned int num_encoders = 0;
+	unsigned int i;
 
 	if (priv == NULL)
 		return -EINVAL;
@@ -122,28 +345,22 @@ static int pl111_modeset_init(struct drm_device *dev)
 
 	priv->number_crtcs = 1;
 
-	pl111_connector = pl111_connector_create(dev);
-	if (pl111_connector == NULL) {
-		pr_err("Failed to create pl111_drm_connector\n");
-		ret = -ENOMEM;
-		goto out_config;
-	}
+	/* Create an encoder and a connector for each output connected to
+	 * external entities.
+	 */
+	 for (i = 0; i < priv->entity.entity.num_pads; ++i) {
+		struct media_pad *pad;
 
-	pl111_encoder = pl111_encoder_create(dev, 1);
-	if (pl111_encoder == NULL) {
-		pr_err("Failed to create pl111_drm_encoder\n");
-		ret = -ENOMEM;
-		goto out_config;
-	}
+		pad = media_entity_remote_pad(&priv->entity.entity.pads[i]);
+		if (pad == NULL)
+			continue;
 
-	ret = drm_mode_connector_attach_encoder(&pl111_connector->connector,
-						&pl111_encoder->encoder);
-	if (ret != 0) {
-		DRM_ERROR("Failed to attach encoder\n");
-		goto out_config;
-	}
+		ret = pl111_pipe_init(priv, i, pad);
+		if (ret < 0)
+			return ret;
 
-	pl111_connector->connector.encoder = &pl111_encoder->encoder;
+		num_encoders++;
+	 }
 
 	ret = pl111_cursor_plane_init(dev, &priv->pl111_crtc->cursor, 1);
 	if (ret != 0) {
@@ -165,6 +382,74 @@ static void pl111_modeset_fini(struct drm_device *dev)
 	drm_mode_config_cleanup(dev);
 }
 
+static int pl111_graph_link_generate(struct pl111_drm_dev_private *priv)
+{
+	struct display_entity *entity;
+	unsigned int num_pads;
+	int ret;
+	struct device *dev = &priv->amba_dev->dev;
+
+	/*
+	 * for CLCD default num_pads = 1 (ports = 1)
+	 */
+	num_pads = 1;
+
+	priv->entity.dev = &priv->amba_dev->dev;
+	priv->entity.ops = &pl111_entity_ops;
+	strcpy(priv->entity.name, "CLCD(PL111)");
+
+	ret = display_entity_init(&priv->entity, 0, num_pads);
+	if (ret < 0)
+		return ret;
+
+	if (dev->of_node) {
+		ret = display_of_entity_link_graph(dev,
+						&priv->notifier.done,
+						&priv->entity);
+		if (ret < 0) {
+			pr_err("unable to link entity graph.\n");
+			return ret;
+		}
+	} else {
+		pr_err("Cannot find DT info.\n");
+		return ret;
+	}
+
+	/* Register the media device */
+	priv->mdev.dev = dev;
+	strlcpy(priv->mdev.model, dev_name(dev),
+			sizeof(priv->mdev.model));
+
+	ret = media_device_register(&priv->mdev);
+	if (ret < 0)
+		return ret;
+
+		list_for_each_entry(entity, &priv->notifier.done, list) {
+		ret = display_entity_register(&priv->mdev, entity);
+		if (ret < 0)
+			return ret;
+	}
+
+	ret = display_entity_register(&priv->mdev, &priv->entity);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static void pl111_graph_link_cleanup(struct pl111_drm_dev_private *priv)
+{
+	struct display_entity *entity;
+
+	 list_for_each_entry(entity, &priv->notifier.done, list)
+			 display_entity_unregister(entity);
+
+	display_entity_unregister(&priv->entity);
+	display_entity_cleanup(&priv->entity);
+
+	 media_device_unregister(&priv->mdev);
+}
+
 static int pl111_drm_load(struct drm_device *dev, unsigned long chipset)
 {
 	int ret = 0;
@@ -201,6 +486,15 @@ static int pl111_drm_load(struct drm_device *dev, unsigned long chipset)
 
 	dev->dev_private = &priv;
 
+	priv.ddev = dev;
+
+	/* Generating the display entities graph link */
+	ret = pl111_graph_link_generate(&priv);
+	if (ret < 0) {
+		pr_err("failed to initialize display entities\n");
+		goto out_graph_callbacks;
+	}
+
 	ret = pl111_modeset_init(dev);
 	if (ret != 0) {
 		pr_err("Failed to init modeset\n");
@@ -227,6 +521,8 @@ out_modeset:
 	pl111_modeset_fini(dev);
 out_slab:
 	kmem_cache_destroy(priv.page_flip_slab);
+out_graph_callbacks:
+	pl111_graph_link_cleanup(&priv);
 out_kds_callbacks:
 #ifdef CONFIG_DMA_SHARED_BUFFER_USES_KDS
 	kds_callback_term(&priv.kds_obtain_current_cb);
@@ -301,16 +597,46 @@ static struct drm_driver driver = {
 	.gem_prime_export = &pl111_gem_prime_export,
 };
 
-int pl111_drm_init(struct platform_device *dev)
+
+static int pl111_notifier_complete(struct display_entity_notifier *notifier)
+{
+	struct platform_device *pdev = to_platform_device(notifier->dev);
+	pr_info("DRM %s\n", __func__);
+	return drm_platform_init(&driver, pdev);
+}
+
+int pl111_drm_init(struct platform_device *pdev)
 {
 	int ret;
+	struct device_node *np = priv.amba_dev->dev.of_node;
+
 	pr_info("DRM %s\n", __func__);
 	pr_info("PL111 DRM initialize, driver name: %s, version %d.%d\n",
 		DRIVER_NAME, DRIVER_MAJOR, DRIVER_MINOR);
 	driver.num_ioctls = 0;
 	ret = 0;
-	driver.kdriver.platform_device = dev;
-	return drm_platform_init(&driver, dev);
+	driver.kdriver.platform_device = pdev;
+
+	/* add display entity notifier function */
+
+	priv.notifier.dev = &pdev->dev;
+	priv.notifier.complete = pl111_notifier_complete;
+
+	if (np) {
+		/* notify display entity */
+		pr_info("DRM %s: build display entity notifier\n", __func__);
+		ret = display_of_entity_build_notifier(&priv.notifier, np);
+	} else {
+		pr_err("DRM %s: no Device tree info\n", __func__);
+		ret = -ENXIO;
+	}
+
+	if (ret < 0) {
+		pr_err("DRM %s: initial failed\n", __func__);
+		return ret;
+	}
+
+	return display_entity_register_notifier(&priv.notifier);
 
 }
 
-- 
1.7.9.5

