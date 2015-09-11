Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28146 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbbIKKL1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:27 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 6/9] media: entity: Remove useless WARN_ON()'s
Date: Fri, 11 Sep 2015 13:09:09 +0300
Message-Id: <1441966152-28444-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The checks for entity ID not reaching too high value the framework could
not handle are now present in the entity registration. It's quite
far-fetched this condition could happen inside the framework, so remove
the WARN_ON()'s.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index a4d6e1b..e4f0f4a 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -334,9 +334,6 @@ void media_entity_graph_walk_start(struct media_entity_graph *graph,
 	graph->stack[graph->top].entity = NULL;
 	media_entity_enum_init(graph->entities);
 
-	if (WARN_ON(entity->low_id >= MEDIA_ENTITY_MAX_LOW_ID))
-		return;
-
 	media_entity_enum_set(graph->entities, entity);
 	stack_push(graph, entity);
 }
@@ -381,8 +378,6 @@ media_entity_graph_walk_next(struct media_entity_graph *graph)
 
 		/* Get the entity in the other end of the link . */
 		next = media_entity_other(entity, link);
-		if (WARN_ON(entity->low_id >= MEDIA_ENTITY_MAX_LOW_ID))
-			return NULL;
 
 		/* Has the entity already been visited? */
 		if (media_entity_enum_test_and_set(graph->entities, next)) {
-- 
2.1.0.231.g7484e3b

