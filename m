Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58772 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaIJK6f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Sep 2014 06:58:35 -0400
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
Subject: [PATCH v2 6/8] drm: use for_each_endpoint_of_node macro in drm_of_find_possible_crtcs
Date: Wed, 10 Sep 2014 12:58:26 +0200
Message-Id: <1410346708-5125-7-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de>
References: <1410346708-5125-1-git-send-email-p.zabel@pengutronix.de>
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

