Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52738 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752460AbdH2Nqm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 09:46:42 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 1/1] media: Check for active and has_no_links overrun
Date: Tue, 29 Aug 2017 16:46:40 +0300
Message-Id: <20170829134640.7054-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

The active and has_no_links arrays will overrun in
media_entity_pipeline_start() if there's an entity which has more than
MEDIA_ENTITY_MAX_PAD pads. Ensure in media_entity_init() that there are
fewer pads than that.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-entity.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 2ace0410d277..f7c6d64e6031 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -214,12 +214,20 @@ void media_gobj_destroy(struct media_gobj *gobj)
 	gobj->mdev = NULL;
 }
 
+/*
+ * TODO: Get rid of this.
+ */
+#define MEDIA_ENTITY_MAX_PADS		512
+
 int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 			   struct media_pad *pads)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
 	unsigned int i;
 
+	if (num_pads >= MEDIA_ENTITY_MAX_PADS)
+		return -E2BIG;
+
 	entity->num_pads = num_pads;
 	entity->pads = pads;
 
@@ -280,11 +288,6 @@ static struct media_entity *stack_pop(struct media_graph *graph)
 #define link_top(en)	((en)->stack[(en)->top].link)
 #define stack_top(en)	((en)->stack[(en)->top].entity)
 
-/*
- * TODO: Get rid of this.
- */
-#define MEDIA_ENTITY_MAX_PADS		512
-
 /**
  * media_graph_walk_init - Allocate resources for graph walk
  * @graph: Media graph structure that will be used to walk the graph
-- 
2.11.0
