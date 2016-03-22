Return-path: <linux-media-owner@vger.kernel.org>
Received: from 6.mo69.mail-out.ovh.net ([46.105.50.107]:35360 "EHLO
	6.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758798AbcCVNNS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2016 09:13:18 -0400
Received: from mail401.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo69.mail-out.ovh.net (Postfix) with SMTP id B68E8FFA20E
	for <linux-media@vger.kernel.org>; Tue, 22 Mar 2016 11:44:10 +0100 (CET)
From: Franck Jullien <franck.jullien@odyssee-systemes.fr>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hyun.kwon@xilinx.com,
	Franck Jullien <franck.jullien@odyssee-systemes.fr>
Subject: [PATCH] [media] xilinx-vipp: remove unnecessary of_node_put
Date: Tue, 22 Mar 2016 11:43:58 +0100
Message-Id: <1458643438-3486-1-git-send-email-franck.jullien@odyssee-systemes.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

of_graph_get_next_endpoint(node, ep) decrements refcount on
ep. When next==NULL we break and refcount on ep is decremented
again.

Signed-off-by: Franck Jullien <franck.jullien@odyssee-systemes.fr>
---
 drivers/media/platform/xilinx/xilinx-vipp.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index e795a45..feb3b2f 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -351,19 +351,15 @@ static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
 	struct xvip_graph_entity *entity;
 	struct device_node *remote;
 	struct device_node *ep = NULL;
-	struct device_node *next;
 	int ret = 0;
 
 	dev_dbg(xdev->dev, "parsing node %s\n", node->full_name);
 
 	while (1) {
-		next = of_graph_get_next_endpoint(node, ep);
-		if (next == NULL)
+		ep = of_graph_get_next_endpoint(node, ep);
+		if (ep == NULL)
 			break;
 
-		of_node_put(ep);
-		ep = next;
-
 		dev_dbg(xdev->dev, "handling endpoint %s\n", ep->full_name);
 
 		remote = of_graph_get_remote_port_parent(ep);
-- 
1.7.1

