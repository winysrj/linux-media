Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60614 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754462AbbLPNeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 08:34:50 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, javier@osg.samsung.com,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH v3 11/23] v4l: xilinx: Use the new media graph walk interface
Date: Wed, 16 Dec 2015 15:32:26 +0200
Message-Id: <1450272758-29446-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
References: <1450272758-29446-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media graph walk requires initialisation and cleanup soon. Update the
users to perform the soon necessary API calls.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index bc244a0..0a19824 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -182,10 +182,17 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 	struct media_device *mdev = entity->graph_obj.mdev;
 	unsigned int num_inputs = 0;
 	unsigned int num_outputs = 0;
+	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
 
 	/* Walk the graph to locate the video nodes. */
+	ret = media_entity_graph_walk_init(&graph, entity->graph_obj.mdev);
+	if (ret) {
+		mutex_unlock(&mdev->graph_mutex);
+		return ret;
+	}
+
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -206,6 +213,8 @@ static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
 
 	mutex_unlock(&mdev->graph_mutex);
 
+	media_entity_graph_walk_cleanup(&graph);
+
 	/* We need exactly one output and zero or one input. */
 	if (num_outputs != 1 || num_inputs > 1)
 		return -EPIPE;
-- 
2.1.4

