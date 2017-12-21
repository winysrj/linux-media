Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37654 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752691AbdLUMpt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Dec 2017 07:45:49 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl
Subject: [PATCH 1/1] v4l: fwnode: Use fwnode_graph_for_each_endpoint
Date: Thu, 21 Dec 2017 14:45:46 +0200
Message-Id: <20171221124546.31028-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use fwnode_graph_for_each_endpoint iterator for better readability.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/v4l2-fwnode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-fwnode.c b/drivers/media/v4l2-core/v4l2-fwnode.c
index 3cc8b6b69b41..c33d519281a2 100644
--- a/drivers/media/v4l2-core/v4l2-fwnode.c
+++ b/drivers/media/v4l2-core/v4l2-fwnode.c
@@ -472,8 +472,7 @@ static int __v4l2_async_notifier_parse_fwnode_endpoints(
 	if (WARN_ON(asd_struct_size < sizeof(struct v4l2_async_subdev)))
 		return -EINVAL;
 
-	for (fwnode = NULL; (fwnode = fwnode_graph_get_next_endpoint(
-				     dev_fwnode(dev), fwnode)); ) {
+	fwnode_graph_for_each_endpoint(dev_fwnode(dev), fwnode) {
 		struct fwnode_handle *dev_fwnode;
 		bool is_available;
 
-- 
2.11.0
