Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57740 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753185AbcLIOxy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 09:53:54 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se
Subject: [PATCH v2 2/9] media: entity: Be vocal about failing sanity checks
Date: Fri,  9 Dec 2016 16:53:35 +0200
Message-Id: <1481295222-14743-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1481295222-14743-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 3801bc7d1b8d ("[media] media: Media Controller fix to not let
stream_count go negative") added a sanity check for negative stream_count,
but a failure of the check remained silent. Make sure the failure is
noticed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-entity.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e3b7ecd..3809257 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -473,8 +473,8 @@ __must_check int __media_entity_pipeline_start(struct media_entity *entity,
 	media_entity_graph_walk_start(graph, entity_err);
 
 	while ((entity_err = media_entity_graph_walk_next(graph))) {
-		/* don't let the stream_count go negative */
-		if (entity_err->stream_count > 0) {
+		/* Sanity check for negative stream_count */
+		if (!WARN_ON_ONCE(entity_err->stream_count <= 0)) {
 			entity_err->stream_count--;
 			if (entity_err->stream_count == 0)
 				entity_err->pipe = NULL;
@@ -519,8 +519,8 @@ void __media_entity_pipeline_stop(struct media_entity *entity)
 	media_entity_graph_walk_start(graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(graph))) {
-		/* don't let the stream_count go negative */
-		if (entity->stream_count > 0) {
+		/* Sanity check for negative stream_count */
+		if (!WARN_ON_ONCE(entity->stream_count <= 0)) {
 			entity->stream_count--;
 			if (entity->stream_count == 0)
 				entity->pipe = NULL;
-- 
2.1.4

