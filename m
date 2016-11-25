Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53888 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753631AbcKYN4X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 08:56:23 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 1/5] media: entity: Fix stream count check
Date: Fri, 25 Nov 2016 15:55:42 +0200
Message-Id: <1480082146-25991-2-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a sanity check for the stream count remaining positive or zero on
error path, but instead of performing the check on the traversed entity it
is performed on the entity where traversal ends. Fix this.

Fixes: commit 3801bc7d1b8d ("[media] media: Media Controller fix to not let stream_count go negative")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 58d9fa6..da46706 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -484,7 +484,7 @@ __must_check int __media_entity_pipeline_start(struct media_entity *entity,
 
 	while ((entity_err = media_entity_graph_walk_next(graph))) {
 		/* don't let the stream_count go negative */
-		if (entity->stream_count > 0) {
+		if (entity_err->stream_count > 0) {
 			entity_err->stream_count--;
 			if (entity_err->stream_count == 0)
 				entity_err->pipe = NULL;
-- 
2.1.4

