Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030848AbdEWXUC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 19:20:02 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: sakari.ailus@iki.fi, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v4] v4l: async: Match parent devices
Date: Wed, 24 May 2017 00:19:56 +0100
Message-Id: <1495581596-1097-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Devices supporting multiple endpoints on a single device node must set
their subdevice fwnode to the endpoint to allow distinct comparisons.

Adapt the match_fwnode call to compare against the provided fwnodes
first, but to also perform a cross reference comparison against the
parent fwnodes of each other.

This allows notifiers to pass the endpoint for comparison and still
support existing subdevices which store their default parent device
node.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
Hi Sakari,

I've respun, rebased, and retested this patch.
Hopefully it's good for moving forwards now.

If you have any concerns about the comments as I've changed them, feel free to
adjust as you see fit if you are planning to take this patch on one of your
existing series

v2:
 - Added documentation comments
 - simplified the OF match by adding match_fwnode_of()

v3:
 - Fix comments
 - Fix sd_parent, and asd_parent usage

v4:
 - Clean up and simplify match_fwnode and comparisons

 drivers/media/v4l2-core/v4l2-async.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index cbd919d4edd2..dbc6adb1347d 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -41,14 +41,34 @@ static bool match_devname(struct v4l2_subdev *sd,
 	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
 }
 
+/*
+ * As a measure to support drivers which have not been converted to use
+ * endpoint matching, we also find the parent devices for cross-matching.
+ *
+ * This also allows continued support for matching subdevices which will not
+ * have an endpoint themselves.
+ */
+
+static bool __match_fwnode(struct fwnode_handle *a, struct fwnode_handle *b)
+{
+	if (is_of_node(a) && is_of_node(b))
+		return !of_node_cmp(of_node_full_name(to_of_node(a)),
+				    of_node_full_name(to_of_node(b)));
+	else
+		return a == b;
+}
+
 static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	if (!is_of_node(sd->fwnode) || !is_of_node(asd->match.fwnode.fwnode))
-		return sd->fwnode == asd->match.fwnode.fwnode;
+	struct fwnode_handle *asd_fwnode = asd->match.fwnode.fwnode;
+	struct fwnode_handle *sd_parent, *asd_parent;
+
+	sd_parent = fwnode_graph_get_port_parent(sd->fwnode);
+	asd_parent = fwnode_graph_get_port_parent(asd_fwnode);
 
-	return !of_node_cmp(of_node_full_name(to_of_node(sd->fwnode)),
-			    of_node_full_name(
-				    to_of_node(asd->match.fwnode.fwnode)));
+	return __match_fwnode(sd->fwnode, asd_fwnode) ||
+	       __match_fwnode(sd->fwnode, asd_parent) ||
+	       __match_fwnode(sd_parent, asd_fwnode);
 }
 
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
-- 
2.7.4
