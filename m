Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55917 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbaIKPdS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Sep 2014 11:33:18 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 7/8] imx-drm: use for_each_endpoint_of_node macro in imx_drm_encoder_get_mux_id
Date: Thu, 11 Sep 2014 17:33:06 +0200
Message-Id: <1410449587-1677-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
References: <1410449587-1677-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the for_each_... macro should make the code bit shorter and
easier to read. This patch also properly decrements the endpoint node
reference count before returning out of the loop.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/imx-drm/imx-drm-core.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index 12303b3..9b5222c 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -493,18 +493,15 @@ int imx_drm_encoder_get_mux_id(struct device_node *node,
 	if (!node || !imx_crtc)
 		return -EINVAL;
 
-	do {
-		ep = of_graph_get_next_endpoint(node, ep);
-		if (!ep)
-			break;
-
+	for_each_endpoint_of_node(node, ep) {
 		port = of_graph_get_remote_port(ep);
 		of_node_put(port);
 		if (port == imx_crtc->port) {
 			ret = of_graph_parse_endpoint(ep, &endpoint);
+			of_node_put(ep);
 			return ret ? ret : endpoint.port;
 		}
-	} while (ep);
+	}
 
 	return -EINVAL;
 }
-- 
2.1.0

