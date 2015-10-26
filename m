Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45021 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751993AbbJZXDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 19:03:51 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 11/19] v4l: vsp1: Use the new media_entity_graph_walk_start() interface
Date: Tue, 27 Oct 2015 01:01:42 +0200
Message-Id: <1445900510-1398-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index f741582..ce10d86 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -415,6 +415,12 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 	mutex_lock(&mdev->graph_mutex);
 
 	/* Walk the graph to locate the entities and video nodes. */
+	ret = media_entity_graph_walk_init(&graph, mdev);
+	if (ret) {
+		mutex_unlock(&mdev->graph_mutex);
+		return ret;
+	}
+
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
@@ -448,6 +454,8 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 
 	mutex_unlock(&mdev->graph_mutex);
 
+	media_entity_graph_walk_cleanup(&graph);
+
 	/* We need one output and at least one input. */
 	if (pipe->num_inputs == 0 || !pipe->output) {
 		ret = -EPIPE;
-- 
2.1.4

