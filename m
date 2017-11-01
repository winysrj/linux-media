Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45223 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933387AbdKAVGL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:11 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hyun Kwon <hyun.kwon@xilinx.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 14/26] media: xilinx: fix a debug printk
Date: Wed,  1 Nov 2017 17:05:51 -0400
Message-Id: <be86653c5e5641582f65f43780b1fe255e92cdc0.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two orthogonal changesets caused a breakage at several printk
messages inside xilinx. Changeset 859969b38e2e
("[media] v4l: Switch from V4L2 OF not V4L2 fwnode API")
made davinci to use struct fwnode_handle instead of
struct device_node. Changeset 68d9c47b1679
("media: Convert to using %pOF instead of full_name")
changed the printk to not use ->full_name, but, instead,
to rely on %pOF.

With both patches applied, the Kernel will do the wrong
thing, as warned by smatch:
	drivers/media/platform/xilinx/xilinx-vipp.c:108 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'void*'
	drivers/media/platform/xilinx/xilinx-vipp.c:117 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'void*'
	drivers/media/platform/xilinx/xilinx-vipp.c:126 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'void*'
	drivers/media/platform/xilinx/xilinx-vipp.c:138 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 3 has type 'void*'
	drivers/media/platform/xilinx/xilinx-vipp.c:148 xvip_graph_build_one() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'void*'
	drivers/media/platform/xilinx/xilinx-vipp.c:245 xvip_graph_build_dma() error: '%pOF' expects argument of type 'struct device_node*', argument 3 has type 'void*'
	drivers/media/platform/xilinx/xilinx-vipp.c:254 xvip_graph_build_dma() error: '%pOF' expects argument of type 'struct device_node*', argument 4 has type 'void*'

So, change the logic to actually print the device name
that was obtained before the print logic.

Fixes: 68d9c47b1679 ("media: Convert to using %pOF instead of full_name")
Fixes: 859969b38e2e ("[media] v4l: Switch from V4L2 OF not V4L2 fwnode API")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/xilinx/xilinx-vipp.c | 31 ++++++++++++++++-------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index d881cf09876d..dd777c834c43 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -65,6 +65,9 @@ xvip_graph_find_entity(struct xvip_composite_device *xdev,
 	return NULL;
 }
 
+#define LOCAL_NAME(link)	to_of_node(link.local_node)->full_name
+#define REMOTE_NAME(link)	to_of_node(link.remote_node)->full_name
+
 static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 				struct xvip_graph_entity *entity)
 {
@@ -103,9 +106,9 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		 * the link.
 		 */
 		if (link.local_port >= local->num_pads) {
-			dev_err(xdev->dev, "invalid port number %u for %pOF\n",
+			dev_err(xdev->dev, "invalid port number %u for %s\n",
 				link.local_port,
-				to_of_node(link.local_node));
+				LOCAL_NAME(link));
 			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
@@ -114,8 +117,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		local_pad = &local->pads[link.local_port];
 
 		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
-			dev_dbg(xdev->dev, "skipping sink port %pOF:%u\n",
-				to_of_node(link.local_node),
+			dev_dbg(xdev->dev, "skipping sink port %s:%u\n",
+				LOCAL_NAME(link),
 				link.local_port);
 			v4l2_fwnode_put_link(&link);
 			continue;
@@ -123,8 +126,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 
 		/* Skip DMA engines, they will be processed separately. */
 		if (link.remote_node == of_fwnode_handle(xdev->dev->of_node)) {
-			dev_dbg(xdev->dev, "skipping DMA port %pOF:%u\n",
-				to_of_node(link.local_node),
+			dev_dbg(xdev->dev, "skipping DMA port %s:%u\n",
+				REMOTE_NAME(link),
 				link.local_port);
 			v4l2_fwnode_put_link(&link);
 			continue;
@@ -134,8 +137,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		ent = xvip_graph_find_entity(xdev,
 					     to_of_node(link.remote_node));
 		if (ent == NULL) {
-			dev_err(xdev->dev, "no entity found for %pOF\n",
-				to_of_node(link.remote_node));
+			dev_err(xdev->dev, "no entity found for %s\n",
+				REMOTE_NAME(link));
 			v4l2_fwnode_put_link(&link);
 			ret = -ENODEV;
 			break;
@@ -144,8 +147,8 @@ static int xvip_graph_build_one(struct xvip_composite_device *xdev,
 		remote = ent->entity;
 
 		if (link.remote_port >= remote->num_pads) {
-			dev_err(xdev->dev, "invalid port number %u on %pOF\n",
-				link.remote_port, to_of_node(link.remote_node));
+			dev_err(xdev->dev, "invalid port number %u on %s\n",
+				link.remote_port, REMOTE_NAME(link));
 			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
@@ -241,17 +244,17 @@ static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
 		ent = xvip_graph_find_entity(xdev,
 					     to_of_node(link.remote_node));
 		if (ent == NULL) {
-			dev_err(xdev->dev, "no entity found for %pOF\n",
-				to_of_node(link.remote_node));
+			dev_err(xdev->dev, "no entity found for %s\n",
+				REMOTE_NAME(link));
 			v4l2_fwnode_put_link(&link);
 			ret = -ENODEV;
 			break;
 		}
 
 		if (link.remote_port >= ent->entity->num_pads) {
-			dev_err(xdev->dev, "invalid port number %u on %pOF\n",
+			dev_err(xdev->dev, "invalid port number %u on %s\n",
 				link.remote_port,
-				to_of_node(link.remote_node));
+				REMOTE_NAME(link));
 			v4l2_fwnode_put_link(&link);
 			ret = -EINVAL;
 			break;
-- 
2.13.6
