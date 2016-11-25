Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53892 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753423AbcKYN4X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Nov 2016 08:56:23 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 2/5] media: entity: Be vocal about failing sanity checks
Date: Fri, 25 Nov 2016 15:55:43 +0200
Message-Id: <1480082146-25991-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1480082146-25991-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 3801bc7d1b8d ("[media] media: Media Controller fix to not let
stream_count go negative") added a sanity check for negative stream_count,
but a failure of the check remained silent. Make sure the failure is
noticed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index da46706..82dd0bc 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -483,8 +483,8 @@ __must_check int __media_entity_pipeline_start(struct media_entity *entity,
 	media_entity_graph_walk_start(graph, entity_err);
 
 	while ((entity_err = media_entity_graph_walk_next(graph))) {
-		/* don't let the stream_count go negative */
-		if (entity_err->stream_count > 0) {
+		/* Sanity check for negative stream_count */
+		if (!WARN_ON_ONCE(entity_err->stream_count <= 0)) {
 			entity_err->stream_count--;
 			if (entity_err->stream_count == 0)
 				entity_err->pipe = NULL;
@@ -529,8 +529,8 @@ void __media_entity_pipeline_stop(struct media_entity *entity)
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

