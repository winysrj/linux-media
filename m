Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44174 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751416AbdGQWBU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 18:01:20 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: pavel@ucw.cz, linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [PATCH 6/7] omap3isp: Correctly put the last iterated endpoint fwnode always
Date: Tue, 18 Jul 2017 01:01:15 +0300
Message-Id: <20170717220116.17886-7-sakari.ailus@linux.intel.com>
In-Reply-To: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Put the last endpoint fwnode if there are too many endpoints to handle.
Also tell the user about about the condition.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/isp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 4e6ba7f90e35..13a8ce4de18b 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2154,11 +2154,16 @@ static int isp_fwnodes_parse(struct device *dev,
 	if (!notifier->subdevs)
 		return -ENOMEM;
 
-	while (notifier->num_subdevs < ISP_MAX_SUBDEVS &&
-	       (fwnode = fwnode_graph_get_next_endpoint(
-			of_fwnode_handle(dev->of_node), fwnode))) {
+	while ((fwnode = fwnode_graph_get_next_endpoint(dev_fwnode(dev),
+							fwnode))) {
 		struct isp_async_subdev *isd;
 
+		if (notifier->num_subdevs >= ISP_MAX_SUBDEVS) {
+			dev_warn(dev, "too many endpoints, ignoring\n");
+			fwnode_handle_put(fwnode);
+			break;
+		}
+
 		isd = devm_kzalloc(dev, sizeof(*isd), GFP_KERNEL);
 		if (!isd)
 			goto error;
-- 
2.11.0
