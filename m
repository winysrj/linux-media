Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:60222 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785AbbJYOIZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Oct 2015 10:08:25 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: kernel-janitors@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 5/8] [media] v4l: xilinx-vipp: add missing of_node_put
Date: Sun, 25 Oct 2015 14:57:04 +0100
Message-Id: <1445781427-7110-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1445781427-7110-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1445781427-7110-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

for_each_child_of_node performs an of_node_get on each iteration, so
a break out of the loop requires an of_node_put.

A simplified version of the semantic patch that fixes this problem is as
follows (http://coccinelle.lip6.fr):

// <smpl>
@@
expression root,e;
local idexpression child;
@@

 for_each_child_of_node(root, child) {
   ... when != of_node_put(child)
       when != e = child
(
   return child;
|
+  of_node_put(child);
?  return ...;
)
   ...
 }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/media/platform/xilinx/xilinx-vipp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index 7b7cb9c..b9bf24f 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -476,8 +476,10 @@ static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
 
 	for_each_child_of_node(ports, port) {
 		ret = xvip_graph_dma_init_one(xdev, port);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(port);
 			return ret;
+		}
 	}
 
 	return 0;

