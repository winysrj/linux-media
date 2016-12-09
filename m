Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57742 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753668AbcLIOxy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 09:53:54 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: [PATCH v2 1/9] media: entity: Fix stream count check
Date: Fri,  9 Dec 2016 16:53:34 +0200
Message-Id: <1481295222-14743-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a sanity check for the stream count remaining positive or zero on
error path, but instead of performing the check on the traversed entity it
is performed on the entity where traversal ends. Fix this.

Fixes: commit 3801bc7d1b8d ("[media] media: Media Controller fix to not let stream_count go negative")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-entity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index f9f723f..e3b7ecd 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -474,7 +474,7 @@ __must_check int __media_entity_pipeline_start(struct media_entity *entity,
 
 	while ((entity_err = media_entity_graph_walk_next(graph))) {
 		/* don't let the stream_count go negative */
-		if (entity->stream_count > 0) {
+		if (entity_err->stream_count > 0) {
 			entity_err->stream_count--;
 			if (entity_err->stream_count == 0)
 				entity_err->pipe = NULL;
-- 
2.1.4

