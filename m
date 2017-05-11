Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932712AbdEKR1U (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 13:27:20 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v2 4/4] rcar-csi2: Map to fwnode endpoints rather than port parents
Date: Thu, 11 May 2017 18:21:23 +0100
Message-Id: <186d73c1b32bd8648dfc22f42154c083f6a4dd83.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

To support multiple async subdevices on a single device, we need to
identify which subdevice maps directly for each connection.

Instead of mapping the port parent to the async notifier, use the fwnode
of the direct endpoint node. This will use a DT path which includes the
port, and allow correct matching of the correct subdevice.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-csi2.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
index 3400c0783c8e..0ddb25cb661b 100644
--- a/drivers/media/platform/rcar-vin/rcar-csi2.c
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -648,7 +648,7 @@ static const struct v4l2_subdev_internal_ops rcar_csi2_internal_ops = {
 
 static int rcar_csi2_parse_dt_subdevice(struct rcar_csi2 *priv)
 {
-	struct device_node *remote, *ep, *rp;
+	struct device_node *ep, *rp;
 	struct v4l2_fwnode_endpoint v4l2_ep;
 	int ret;
 
@@ -675,18 +675,10 @@ static int rcar_csi2_parse_dt_subdevice(struct rcar_csi2 *priv)
 	rp = of_parse_phandle(ep, "remote-endpoint", 0);
 	of_graph_parse_endpoint(rp, &priv->remote.endpoint);
 
-	remote = of_graph_get_remote_port_parent(ep);
-	of_node_put(ep);
-	if (!remote) {
-		dev_err(priv->dev, "No subdevice found for endpoint '%s'\n",
-			of_node_full_name(ep));
-		return -EINVAL;
-	}
-
-	priv->remote.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+	priv->remote.asd.match.fwnode.fwnode = of_fwnode_handle(rp);
 	priv->remote.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
 
-	dev_dbg(priv->dev, "Found '%s'\n", of_node_full_name(remote));
+	dev_dbg(priv->dev, "Found '%s'\n", of_node_full_name(rp));
 
 	return 0;
 }
-- 
git-series 0.9.1
