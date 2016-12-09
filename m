Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57782 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753631AbcLIOx4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 09:53:56 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: [PATCH v2 7/9] omap3isp: Use a local media device pointer instead
Date: Fri,  9 Dec 2016 16:53:40 +0200
Message-Id: <1481295222-14743-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function has a local variable that points to the media device; use
that instead of finding the media device under the entity.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/omap3isp/ispvideo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 5b0d16e..25a8210 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -232,7 +232,7 @@ static int isp_video_get_graph_data(struct isp_video *video,
 	int ret;
 
 	mutex_lock(&mdev->graph_mutex);
-	ret = media_graph_walk_init(&graph, entity->graph_obj.mdev);
+	ret = media_graph_walk_init(&graph, mdev);
 	if (ret) {
 		mutex_unlock(&mdev->graph_mutex);
 		return ret;
-- 
2.1.4

