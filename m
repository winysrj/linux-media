Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54460 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726802AbeH0NPy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 09:15:54 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, slongerbeam@gmail.com,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org
Subject: [PATCH v2 02/23] v4l: fwnode: Use fwnode_graph_for_each_endpoint
Date: Mon, 27 Aug 2018 12:29:39 +0300
Message-Id: <20180827093000.29165-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
References: <20180827093000.29165-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use fwnode_graph_for_each_endpoint iterator for better readability.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index dae01d5f570e..da13348b1f4a 100644
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
