Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754479AbdEQPEA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 11:04:00 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi, niklas.soderlund@ragnatech.se,
        laurent.pinchart@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tuukka Toivonen <tuukka.toivonen@intel.com>,
        Javi Merino <javi.merino@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 3/3] v4l: async: Match parent devices
Date: Wed, 17 May 2017 16:03:39 +0100
Message-Id: <4db2a777a71b51a864caae16385b60b4b7e9f992.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.6800d0e1b9b578b82f68dec1b99b3a601d6e54ca.1495032810.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Devices supporting multiple endpoints on a single device node must set
their subdevice fwnode to the endpoint to allow distinct comparisons.

Adapt the match_fwnode call to compare against the provided fwnodes
first, but also to search for a comparison against the parent fwnode.

This allows notifiers to pass the endpoint for comparison and still
support existing subdevices which store their default parent device
node.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/v4l2-async.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index e1e181db90f7..65735a5c4350 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -41,14 +41,26 @@ static bool match_devname(struct v4l2_subdev *sd,
 	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
 }
 
+static bool match_of(struct device_node *a, struct device_node *b)
+{
+	return !of_node_cmp(of_node_full_name(a), of_node_full_name(b));
+}
+
 static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
+	struct device_node *sdnode;
+	struct fwnode_handle *async_device;
+
+	async_device = fwnode_graph_get_port_parent(asd->match.fwnode.fwnode);
+
 	if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
-		return sd->fwnode == asd->match.fwnode.fwnode;
+		return sd->fwnode == asd->match.fwnode.fwnode ||
+		       sd->fwnode == async_device;
+
+	sdnode = to_of_node(sd->fwnode);
 
-	return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
-			    of_node_full_name(
-				    to_of_node(asd->match.fwnode.fwnode)));
+	return match_of(sdnode, to_of_node(asd->match.fwnode.fwnode)) ||
+	       match_of(sdnode, to_of_node(async_device));
 }
 
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
-- 
git-series 0.9.1
