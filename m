Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164092AbdD0S0R (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 14:26:17 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 2/5] rcar-vin: Match sources against ports if specified.
Date: Thu, 27 Apr 2017 19:26:01 +0100
Message-Id: <1493317564-18026-3-git-send-email-kbingham@kernel.org>
In-Reply-To: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
References: <1493317564-18026-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

If an endpoint source specifies a port number, then it may have
multiple entities provided by one DT node. In this event, match
against both the DT node and it's relevant port.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/rcar-vin/rcar-core.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index a530dc388b95..afe382c9a55d 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -782,7 +782,8 @@ static int rvin_group_notify_bound(struct v4l2_async_notifier *notifier,
 			return 0;
 		}
 
-		if (vin->group->source[i].asd.match.of.node == new) {
+		if (vin->group->source[i].asd.match.of.node == new &&
+		    subdev->port == vin->group->source[i].asd.match.of.port) {
 			vin_dbg(vin, "Bound source %s\n", subdev->name);
 			vin->group->source[i].subdev = subdev;
 			mutex_unlock(&vin->group->lock);
@@ -820,7 +821,7 @@ static struct device_node *rvin_group_get_bridge(struct rvin_dev *vin,
 static struct device_node *
 rvin_group_get_source(struct rvin_dev *vin,
 		      struct device_node *bridge,
-		      unsigned int *remote_pad)
+		      unsigned int *remote_port)
 {
 	struct device_node *source, *ep, *rp;
 	struct v4l2_mbus_config mbus_cfg;
@@ -844,7 +845,7 @@ rvin_group_get_source(struct rvin_dev *vin,
 	rp = of_graph_get_remote_port(ep);
 	of_graph_parse_endpoint(rp, &endpoint);
 	of_node_put(rp);
-	*remote_pad = endpoint.id;
+	*remote_port = endpoint.id;
 
 	source = of_graph_get_remote_port_parent(ep);
 	of_node_put(ep);
@@ -861,7 +862,7 @@ rvin_group_get_source(struct rvin_dev *vin,
 static int rvin_group_graph_parse(struct rvin_dev *vin, unsigned long *bitmap)
 {
 	struct device_node *ep, *bridge, *source;
-	unsigned int i, remote_pad = 0;
+	unsigned int i, remote_port = 0;
 	u32 val;
 	int ret;
 
@@ -910,7 +911,7 @@ static int rvin_group_graph_parse(struct rvin_dev *vin, unsigned long *bitmap)
 		if (bridge == NULL)
 			continue;
 
-		source = rvin_group_get_source(vin, bridge, &remote_pad);
+		source = rvin_group_get_source(vin, bridge, &remote_port);
 		of_node_put(bridge);
 		if (IS_ERR(source))
 			return PTR_ERR(source);
@@ -922,14 +923,14 @@ static int rvin_group_graph_parse(struct rvin_dev *vin, unsigned long *bitmap)
 		vin->group->bridge[i].asd.match.of.node = bridge;
 		vin->group->bridge[i].asd.match_type = V4L2_ASYNC_MATCH_OF;
 		vin->group->source[i].asd.match.of.node = source;
+		vin->group->source[i].asd.match.of.port = remote_port;
 		vin->group->source[i].asd.match_type = V4L2_ASYNC_MATCH_OF;
-		vin->group->source[i].source_pad = remote_pad;
 
 		*bitmap |= BIT(i);
 
 		vin_dbg(vin, "Handle bridge %s and source %s pad %d\n",
 			of_node_full_name(bridge), of_node_full_name(source),
-			remote_pad);
+			remote_port);
 	}
 
 	/* All our sources are CSI-2 */
-- 
2.7.4
