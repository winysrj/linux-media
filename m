Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57784 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753982AbcLIOx4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 09:53:56 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: [PATCH v2 9/9] davinci: Use a local media device pointer instead
Date: Fri,  9 Dec 2016 16:53:42 +0200
Message-Id: <1481295222-14743-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function has a local variable that points to the media device; use
that instead of finding the media device under the entity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 03269d3..8b2117e 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -145,7 +145,7 @@ static int vpfe_prepare_pipeline(struct vpfe_video_device *video)
 		pipe->outputs[pipe->output_num++] = video;
 
 	mutex_lock(&mdev->graph_mutex);
-	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&graph, mdev);
 	if (ret) {
 		mutex_unlock(&mdev->graph_mutex);
 		return -ENOMEM;
@@ -300,7 +300,7 @@ static int vpfe_pipeline_enable(struct vpfe_pipeline *pipe)
 
 	mdev = entity->graph_obj.mdev;
 	mutex_lock(&mdev->graph_mutex);
-	ret = media_graph_walk_init(&pipe->graph, entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&pipe->graph, mdev);
 	if (ret)
 		goto out;
 	media_graph_walk_start(&pipe->graph, entity);
-- 
2.1.4

