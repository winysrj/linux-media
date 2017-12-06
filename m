Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751680AbdLFO6n (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Dec 2017 09:58:43 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: jacopo@jmondi.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v5] v4l2-async: Match parent devices
Date: Wed,  6 Dec 2017 14:58:39 +0000
Message-Id: <1512572319-20179-1-git-send-email-kbingham@kernel.org>
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
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

---

Hi Sakari,

Since you signed-off on this patch - it has had to be reworked due to the
changes on the of_node_full_name() functionality.

I believe it is correct now to *just* do the pointer matching, as that matches
the current implementation, and converting to device_nodes will be just as
equal as the fwnodes, as they are simply containers.

Let me know if you are happy to maintain your SOB on this patch - and if we need
to work towards getting this integrated upstream, especially in light of your new
endpoint matching work.

--
Regards

Kieran


v2:
 - Added documentation comments
 - simplified the OF match by adding match_fwnode_of()

v3:
 - Fix comments
 - Fix sd_parent, and asd_parent usage

v4:
 - Clean up and simplify match_fwnode and comparisons

v5:
 - Updated for v4.15-rc1:
   of_node no longer specifies a full path, and only returns the
   basename with of_node_full_name(), thus this ends up matching
   "endpoint" for all endpoints. Fall back to pointer matching,
   whilst maintaining the parent comparisons.
---
 drivers/media/v4l2-core/v4l2-async.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index fcadad305336..780bda70d8b3 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -71,9 +71,24 @@ static bool match_devname(struct v4l2_subdev *sd,
 	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
 }
 
+/*
+ * As a measure to support drivers which have not been converted to use
+ * endpoint matching, we also find the parent devices for cross-matching.
+ *
+ * This also allows continued support for matching subdevices which will not
+ * have an endpoint themselves.
+ */
 static bool match_fwnode(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return sd->fwnode == asd->match.fwnode.fwnode;
+	struct fwnode_handle *asd_fwnode = asd->match.fwnode.fwnode;
+	struct fwnode_handle *sd_parent, *asd_parent;
+
+	sd_parent = fwnode_graph_get_port_parent(sd->fwnode);
+	asd_parent = fwnode_graph_get_port_parent(asd_fwnode);
+
+	return sd->fwnode == asd_fwnode ||
+	       sd->fwnode == asd_parent ||
+	       sd_parent == asd_fwnode;
 }
 
 static bool match_custom(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
-- 
2.7.4
