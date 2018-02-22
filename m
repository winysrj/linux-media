Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:43679 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751639AbeBVBkD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 20:40:03 -0500
Received: by mail-pg0-f68.google.com with SMTP id f6so1404344pgs.10
        for <linux-media@vger.kernel.org>; Wed, 21 Feb 2018 17:40:02 -0800 (PST)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Yong Zhi <yong.zhi@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH 01/13] media: v4l2-fwnode: Let parse_endpoint callback decide if no remote is error
Date: Wed, 21 Feb 2018 17:39:37 -0800
Message-Id: <1519263589-19647-2-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
References: <1519263589-19647-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For some subdevices, a fwnode endpoint that has no connection to a remote
endpoint may not be an error. Let the parse_endpoint callback make that
decision in v4l2_async_notifier_fwnode_parse_endpoint(). If the callback
indicates that is not an error, skip adding the asd to the notifier and
return 0.

For the current users of v4l2_async_notifier_parse_fwnode_endpoints()
(omap3isp, rcar-vin, intel-ipu3), return -EINVAL in the callback for
unavailable remote fwnodes to maintain the previous behavior.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/pci/intel/ipu3/ipu3-cio2.c    | 3 +++
 drivers/media/platform/omap3isp/isp.c       | 3 +++
 drivers/media/platform/rcar-vin/rcar-core.c | 3 +++
 drivers/media/v4l2-core/v4l2-fwnode.c       | 4 ++--
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 6c4444b..2323151 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1477,6 +1477,9 @@ static int cio2_fwnode_parse(struct device *dev,
 	struct sensor_async_subdev *s_asd =
 			container_of(asd, struct sensor_async_subdev, asd);
 
+	if (!fwnode_device_is_available(asd->match.fwnode))
+		return -EINVAL;
+
 	if (vep->bus_type != V4L2_MBUS_CSI2) {
 		dev_err(dev, "Only CSI2 bus type is currently supported\n");
 		return -EINVAL;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 8eb000e..4a302f2 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2025,6 +2025,9 @@ static int isp_fwnode_parse(struct device *dev,
 	dev_dbg(dev, "parsing endpoint %pOF, interface %u\n",
 		to_of_node(vep->base.local_fwnode), vep->base.port);
 
+	if (!fwnode_device_is_available(asd->match.fwnode))
+		return -EINVAL;
+
 	switch (vep->base.port) {
 	case ISP_OF_PHY_PARALLEL:
 		buscfg->interface = ISP_INTERFACE_PARALLEL;
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index f1fc797..51bb8f1 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -149,6 +149,9 @@ static int rvin_digital_parse_v4l2(struct device *dev,
 	struct rvin_graph_entity *rvge =
 		container_of(asd, struct rvin_graph_entity, asd);
 
+	if (!fwnode_device_is_available(asd->match.fwnode))
+		return -EINVAL;
+
 	if (vep->base.port || vep->base.id)
 		return -ENOTCONN;
 
diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index d630640..446646b 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -361,7 +361,7 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 	asd->match_type = V4L2_ASYNC_MATCH_FWNODE;
 	asd->match.fwnode =
 		fwnode_graph_get_remote_port_parent(endpoint);
-	if (!asd->match.fwnode) {
+	if (!asd->match.fwnode && !parse_endpoint) {
 		dev_warn(dev, "bad remote port parent\n");
 		ret = -EINVAL;
 		goto out_err;
@@ -384,7 +384,7 @@ static int v4l2_async_notifier_fwnode_parse_endpoint(
 			 "driver could not parse port@%u/endpoint@%u (%d)\n",
 			 vep->base.port, vep->base.id, ret);
 	v4l2_fwnode_endpoint_free(vep);
-	if (ret < 0)
+	if (ret < 0 || !asd->match.fwnode)
 		goto out_err;
 
 	notifier->subdevs[notifier->num_subdevs] = asd;
-- 
2.7.4
