Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15153 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbbIKKLa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 8/9] vsp1: Use media entity enumeration API
Date: Fri, 11 Sep 2015 13:09:11 +0300
Message-Id: <1441966152-28444-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index f741582..026d6462 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -311,7 +311,7 @@ static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 					 struct vsp1_rwpf *output)
 {
 	struct vsp1_entity *entity;
-	unsigned int entities = 0;
+	DECLARE_MEDIA_ENTITY_ENUM(entities);
 	struct media_pad *pad;
 	bool bru_found = false;
 
@@ -351,11 +351,10 @@ static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
 			break;
 
 		/* Ensure the branch has no loop. */
-		if (entities & (1 << media_entity_id(&entity->subdev.entity)))
+		if (media_entity_enum_test_and_set(entities,
+						   &entity->subdev.entity))
 			return -EPIPE;
 
-		entities |= 1 << media_entity_id(&entity->subdev.entity);
-
 		/* UDS can't be chained. */
 		if (entity->type == VSP1_ENTITY_UDS) {
 			if (pipe->uds)
-- 
2.1.0.231.g7484e3b

