Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:48036 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdJLQE5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 12:04:57 -0400
Received: by mail-pf0-f194.google.com with SMTP id z11so5479703pfk.4
        for <linux-media@vger.kernel.org>; Thu, 12 Oct 2017 09:04:57 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] media: xilinx-video: fix bad of_node_put() on endpoint error
Date: Fri, 13 Oct 2017 01:04:44 +0900
Message-Id: <1507824284-17809-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When iterating through all endpoints using of_graph_get_next_endpoint(),
the refcount of the returned endpoint node is incremented and the refcount
of the node which is passed as previous endpoint is decremented.

So the caller doesn't need to call of_node_put() for each iterated node
except for error exit paths.  Otherwise we get "OF: ERROR: Bad
of_node_put() on ..." messages.

Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/platform/xilinx/xilinx-vipp.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index ebfdf33..e5c80c9 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -76,20 +76,16 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 	struct xvip_graph_entity *ent;
 	struct v4l2_fwnode_link link;
 	struct device_node *ep = NULL;
-	struct device_node *next;
 	int ret = 0;
 
 	dev_dbg(xdev->dev, "creating links for entity %s\n", local->name);
 
 	while (1) {
 		/* Get the next endpoint and parse its link. */
-		next = of_graph_get_next_endpoint(entity->node, ep);
-		if (next == NULL)
+		ep = of_graph_get_next_endpoint(entity->node, ep);
+		if (ep == NULL)
 			break;
 
-		of_node_put(ep);
-		ep = next;
-
 		dev_dbg(xdev->dev, "processing endpoint %pOF\n", ep);
 
 		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
@@ -200,7 +196,6 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 	struct xvip_graph_entity *ent;
 	struct v4l2_fwnode_link link;
 	struct device_node *ep = NULL;
-	struct device_node *next;
 	struct xvip_dma *dma;
 	int ret = 0;
 
@@ -208,13 +203,10 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 
 	while (1) {
 		/* Get the next endpoint and parse its link. */
-		next = of_graph_get_next_endpoint(node, ep);
-		if (next == NULL)
+		ep = of_graph_get_next_endpoint(node, ep);
+		if (ep == NULL)
 			break;
 
-		of_node_put(ep);
-		ep = next;
-
 		dev_dbg(xdev->dev, "processing endpoint %pOF\n", ep);
 
 		ret = v4l2_fwnode_parse_link(of_fwnode_handle(ep), &link);
-- 
2.7.4
