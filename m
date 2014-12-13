Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:37715 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030568AbaLMLxv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Dec 2014 06:53:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH 05/10] media-entity: fix sparse warnings
Date: Sat, 13 Dec 2014 12:52:55 +0100
Message-Id: <1418471580-26510-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
References: <1418471580-26510-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

drivers/media/media-entity.c:238:17: warning: Variable length array is used.
drivers/media/media-entity.c:239:17: warning: Variable length array is used.

Replace variable length by MEDIA_ENTITY_ENUM_MAX_ID.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-entity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 4d8e01c..dcf322b 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -235,8 +235,8 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
 	media_entity_graph_walk_start(&graph, entity);
 
 	while ((entity = media_entity_graph_walk_next(&graph))) {
-		DECLARE_BITMAP(active, entity->num_pads);
-		DECLARE_BITMAP(has_no_links, entity->num_pads);
+		DECLARE_BITMAP(active, MEDIA_ENTITY_ENUM_MAX_ID);
+		DECLARE_BITMAP(has_no_links, MEDIA_ENTITY_ENUM_MAX_ID);
 		unsigned int i;
 
 		entity->stream_count++;
-- 
2.1.3

