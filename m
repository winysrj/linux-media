Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49336 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbJAWRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 18:17:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 1/7] [media] media-entity.c: get rid of var length arrays
Date: Thu,  1 Oct 2015 19:17:23 -0300
Message-Id: <ef69ee1bc2c10fd1c5b389258d8156f3c38bdb33.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1443737682.git.mchehab@osg.samsung.com>
References: <cover.1443737682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix those sparse warnings:
	drivers/media/media-entity.c:238:17: warning: Variable length array is used.
	drivers/media/media-entity.c:239:17: warning: Variable length array is used.

That allows sparse and other code check tools to verify if the
function is using more stack than allowed.

It also solves a bad Kernel pratice of using var length arrays
at the stack.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 153a46469814..767fe55ba08e 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -235,8 +235,8 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
-		DECLARE_BITMAP(active, entity->num_pads);
-		DECLARE_BITMAP(has_no_links, entity->num_pads);
+		DECLARE_BITMAP(active, MEDIA_ENTITY_MAX_PADS);
+		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_MAX_PADS);
 		unsigned int i;
 
 		entity->stream_count++;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 0c003d817493..197f93799753 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -116,6 +116,13 @@ static inline u32 media_entity_subtype(struct media_entity *entity)
 #define MEDIA_ENTITY_ENUM_MAX_DEPTH	16
 #define MEDIA_ENTITY_ENUM_MAX_ID	64
 
+/*
+ * The number of pads can't be bigger than the number of entities,
+ * as the worse-case scenario is to have one entity linked up to
+ * MEDIA_ENTITY_ENUM_MAX_ID - 1 entities.
+ */
+#define MEDIA_ENTITY_MAX_PADS		(MEDIA_ENTITY_ENUM_MAX_ID - 1)
+
 struct media_entity_graph {
 	struct {
 		struct media_entity *entity;
-- 
2.4.3


