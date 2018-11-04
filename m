Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33208 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729496AbeKDW0X (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Nov 2018 17:26:23 -0500
Received: by mail-pl1-f196.google.com with SMTP id x6-v6so3138270pln.0
        for <linux-media@vger.kernel.org>; Sun, 04 Nov 2018 05:11:26 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: xilinx-video: fix bad of_node_put() on endpoint error
Date: Sun,  4 Nov 2018 22:11:10 +0900
Message-Id: <1541337070-4917-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fwnode_graph_get_next_endpoint() returns an 'endpoint' node pointer
with refcount incremented, and refcount of the passed as a previous
'endpoint' node is decremented.

So when iterating over all nodes using fwnode_graph_get_next_endpoint(),
we don't need to call fwnode_handle_put() for each node except for error
exit paths.  Otherwise we get "OF: ERROR: Bad of_node_put() on ..."
messages.

Fixes: d079f94c9046 ("media: platform: Switch to v4l2_async_notifier_add_subdev")
Cc: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 drivers/media/platform/xilinx/xilinx-vipp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index 574614d..26b13fd 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -377,8 +377,6 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
 			goto err_notifier_cleanup;
 		}
 
-		fwnode_handle_put(ep);
-
 		/* Skip entities that we have already processed. */
 		if (remote == of_fwnode_handle(xdev->dev->of_node) ||
 		    xvip_graph_find_entity(xdev, remote)) {
-- 
2.7.4
