Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40850 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727711AbeIMCgI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Sep 2018 22:36:08 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        p.zabel@pengutronix.de, dri-devel@lists.freedesktop.org
Subject: [PATCH v3 02/23] v4l: fwnode: Use fwnode_graph_for_each_endpoint
Date: Thu, 13 Sep 2018 00:29:21 +0300
Message-Id: <20180912212942.19641-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
References: <20180912212942.19641-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use fwnode_graph_for_each_endpoint iterator for better readability.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Tested-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index fc8c63eba10b..ab457cf36ba5 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -456,8 +456,7 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 	if (WARN_ON(asd_struct_size < sizeof(struct v4l2_async_subdev)))
 		return -EINVAL;
 
-	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
-				     dev_fwnode(dev), fwnode)); ) {
+	fwnode_graph_for_each_endpoint(dev_fwnode(dev), fwnode) {
 		struct fwnode_handle *dev_fwnode;
 		bool is_available;
 
-- 
2.11.0
