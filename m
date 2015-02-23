Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52572 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbbBWKya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 05:54:30 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
	Benoit Parrot <bparrot@ti.com>
Cc: Darren Etheridge <detheridge@ti.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v8 1/3] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
Date: Mon, 23 Feb 2015 11:54:04 +0100
Message-Id: <1424688846-10909-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1424688846-10909-1-git-send-email-p.zabel@pengutronix.de>
References: <1424688846-10909-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Decrementing the reference count of the previous endpoint node allows to
use the of_graph_get_next_endpoint function in a for_each_... style macro.
All current users of this function that pass a non-NULL prev parameter
(that is, soc_camera and imx-drm) are changed to not decrement the passed
prev argument's refcount themselves.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
---
Changes since v7:
 - Rebased onto v4.0-rc1
 - Added fix for am437x-vpfe
---
 drivers/coresight/of_coresight.c                  | 13 ++-----------
 drivers/gpu/drm/imx/imx-drm-core.c                | 11 +----------
 drivers/gpu/drm/rcar-du/rcar_du_kms.c             | 15 ++++-----------
 drivers/media/platform/am437x/am437x-vpfe.c       |  1 -
 drivers/media/platform/soc_camera/soc_camera.c    |  3 ++-
 drivers/of/base.c                                 |  9 +--------
 drivers/video/fbdev/omap2/dss/omapdss-boot-init.c |  7 +------
 7 files changed, 11 insertions(+), 48 deletions(-)

diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
index c3efa41..6f75e9d 100644
--- a/drivers/coresight/of_coresight.c
+++ b/drivers/coresight/of_coresight.c
@@ -52,15 +52,6 @@ of_coresight_get_endpoint_device(struct device_node *endpoint)
 			       endpoint, of_dev_node_match);
 }
 
-static struct device_node *of_get_coresight_endpoint(
-		const struct device_node *parent, struct device_node *prev)
-{
-	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
-
-	of_node_put(prev);
-	return node;
-}
-
 static void of_coresight_get_ports(struct device_node *node,
 				   int *nr_inport, int *nr_outport)
 {
@@ -68,7 +59,7 @@ static void of_coresight_get_ports(struct device_node *node,
 	int in = 0, out = 0;
 
 	do {
-		ep = of_get_coresight_endpoint(node, ep);
+		ep = of_graph_get_next_endpoint(node, ep);
 		if (!ep)
 			break;
 
@@ -140,7 +131,7 @@ struct coresight_platform_data *of_get_coresight_platform_data(
 		/* Iterate through each port to discover topology */
 		do {
 			/* Get a handle on a port */
-			ep = of_get_coresight_endpoint(node, ep);
+			ep = of_graph_get_next_endpoint(node, ep);
 			if (!ep)
 				break;
 
diff --git a/drivers/gpu/drm/imx/imx-drm-core.c b/drivers/gpu/drm/imx/imx-drm-core.c
index a002f53..84cf99f 100644
--- a/drivers/gpu/drm/imx/imx-drm-core.c
+++ b/drivers/gpu/drm/imx/imx-drm-core.c
@@ -431,15 +431,6 @@ int imx_drm_encoder_parse_of(struct drm_device *drm,
 }
 EXPORT_SYMBOL_GPL(imx_drm_encoder_parse_of);
 
-static struct device_node *imx_drm_of_get_next_endpoint(
-		const struct device_node *parent, struct device_node *prev)
-{
-	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
-
-	of_node_put(prev);
-	return node;
-}
-
 /*
  * @node: device tree node containing encoder input ports
  * @encoder: drm_encoder
@@ -457,7 +448,7 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
 		return -EINVAL;
 
 	do {
-		ep = imx_drm_of_get_next_endpoint(node, ep);
+		ep = of_graph_get_next_endpoint(node, ep);
 		if (!ep)
 			break;
 
diff --git a/drivers/gpu/drm/rcar-du/rcar_du_kms.c b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
index cc9136e..68dab26 100644
--- a/drivers/gpu/drm/rcar-du/rcar_du_kms.c
+++ b/drivers/gpu/drm/rcar-du/rcar_du_kms.c
@@ -206,7 +206,7 @@ static int rcar_du_encoders_init_one(struct rcar_du_device *rcdu,
 	enum rcar_du_encoder_type enc_type = RCAR_DU_ENCODER_NONE;
 	struct device_node *connector = NULL;
 	struct device_node *encoder = NULL;
-	struct device_node *prev = NULL;
+	struct device_node *ep_node = NULL;
 	struct device_node *entity_ep_node;
 	struct device_node *entity;
 	int ret;
@@ -225,11 +225,7 @@ static int rcar_du_encoders_init_one(struct rcar_du_device *rcdu,
 	entity_ep_node = of_parse_phandle(ep->local_node, "remote-endpoint", 0);
 
 	while (1) {
-		struct device_node *ep_node;
-
-		ep_node = of_graph_get_next_endpoint(entity, prev);
-		of_node_put(prev);
-		prev = ep_node;
+		ep_node = of_graph_get_next_endpoint(entity, ep_node);
 
 		if (!ep_node)
 			break;
@@ -300,7 +296,7 @@ static int rcar_du_encoders_init_one(struct rcar_du_device *rcdu,
 static int rcar_du_encoders_init(struct rcar_du_device *rcdu)
 {
 	struct device_node *np = rcdu->dev->of_node;
-	struct device_node *prev = NULL;
+	struct device_node *ep_node = NULL;
 	unsigned int num_encoders = 0;
 
 	/*
@@ -308,15 +304,12 @@ static int rcar_du_encoders_init(struct rcar_du_device *rcdu)
 	 * pipeline.
 	 */
 	while (1) {
-		struct device_node *ep_node;
 		enum rcar_du_output output;
 		struct of_endpoint ep;
 		unsigned int i;
 		int ret;
 
-		ep_node = of_graph_get_next_endpoint(np, prev);
-		of_node_put(prev);
-		prev = ep_node;
+		ep_node = of_graph_get_next_endpoint(np, ep_node);
 
 		if (ep_node == NULL)
 			break;
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 56a5cb0..0d07fca 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2504,7 +2504,6 @@ vpfe_get_pdata(struct platform_device *pdev)
 					     GFP_KERNEL);
 		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_OF;
 		pdata->asd[i]->match.of.node = rem;
-		of_node_put(endpoint);
 		of_node_put(rem);
 	}
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index cee7b56..f2a3d96 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1694,7 +1694,6 @@ static void scan_of_host(struct soc_camera_host *ici)
 		if (!i)
 			soc_of_bind(ici, epn, ren->parent);
 
-		of_node_put(epn);
 		of_node_put(ren);
 
 		if (i) {
@@ -1702,6 +1701,8 @@ static void scan_of_host(struct soc_camera_host *ici)
 			break;
 		}
 	}
+
+	of_node_put(epn);
 }
 
 #else
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 0a8aeb8..05b20f1 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -2086,8 +2086,7 @@ EXPORT_SYMBOL(of_graph_parse_endpoint);
  * @prev: previous endpoint node, or NULL to get first
  *
  * Return: An 'endpoint' node pointer with refcount incremented. Refcount
- * of the passed @prev node is not decremented, the caller have to use
- * of_node_put() on it when done.
+ * of the passed @prev node is decremented.
  */
 struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 					struct device_node *prev)
@@ -2123,12 +2122,6 @@ struct device_node *of_graph_get_next_endpoint(const struct device_node *parent,
 		if (WARN_ONCE(!port, "%s(): endpoint %s has no parent node\n",
 			      __func__, prev->full_name))
 			return NULL;
-
-		/*
-		 * Avoid dropping prev node refcount to 0 when getting the next
-		 * child below.
-		 */
-		of_node_get(prev);
 	}
 
 	while (1) {
diff --git a/drivers/video/fbdev/omap2/dss/omapdss-boot-init.c b/drivers/video/fbdev/omap2/dss/omapdss-boot-init.c
index 42b87f9..8b6f6d5 100644
--- a/drivers/video/fbdev/omap2/dss/omapdss-boot-init.c
+++ b/drivers/video/fbdev/omap2/dss/omapdss-boot-init.c
@@ -164,20 +164,15 @@ static void __init omapdss_walk_device(struct device_node *node, bool root)
 
 		pn = of_graph_get_remote_port_parent(n);
 
-		if (!pn) {
-			of_node_put(n);
+		if (!pn)
 			continue;
-		}
 
 		if (!of_device_is_available(pn) || omapdss_list_contains(pn)) {
 			of_node_put(pn);
-			of_node_put(n);
 			continue;
 		}
 
 		omapdss_walk_device(pn, false);
-
-		of_node_put(n);
 	}
 }
 
-- 
2.1.4

