Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45787 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbaI2SE3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Sep 2014 14:04:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 4/6] drm: use for_each_endpoint_of_node macro in drm_of_find_possible_crtcs
Date: Mon, 29 Sep 2014 20:03:37 +0200
Message-Id: <1412013819-29181-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using the for_each_... macro should make the code a bit shorter and
easier to read.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/gpu/drm/drm_of.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_of.c b/drivers/gpu/drm/drm_of.c
index 16150a0..024fa77 100644
--- a/drivers/gpu/drm/drm_of.c
+++ b/drivers/gpu/drm/drm_of.c
@@ -46,11 +46,7 @@ uint32_t drm_of_find_possible_crtcs(struct drm_device *dev,
 	struct device_node *remote_port, *ep = NULL;
 	uint32_t possible_crtcs = 0;
 
-	do {
-		ep = of_graph_get_next_endpoint(port, ep);
-		if (!ep)
-			break;
-
+	for_each_endpoint_of_node(port, ep) {
 		remote_port = of_graph_get_remote_port(ep);
 		if (!remote_port) {
 			of_node_put(ep);
@@ -60,7 +56,7 @@ uint32_t drm_of_find_possible_crtcs(struct drm_device *dev,
 		possible_crtcs |= drm_crtc_port_mask(dev, remote_port);
 
 		of_node_put(remote_port);
-	} while (1);
+	}
 
 	return possible_crtcs;
 }
-- 
2.1.0

