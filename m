Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:40679 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbcCNIVx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 04:21:53 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] media-entity: fix sparse warning in media_entity_pads_init()
Message-ID: <56E6749A.405@xs4all.nl>
Date: Mon, 14 Mar 2016 09:21:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this sparse warning:

drivers/media/media-entity.c:212:5: warning: context imbalance in 'media_entity_pads_init' - different lock contexts for basic block

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e95070b..be29d62 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -217,20 +217,19 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,

 	entity->num_pads = num_pads;
 	entity->pads = pads;
-
-	if (mdev)
-		spin_lock(&mdev->lock);
-
 	for (i = 0; i < num_pads; i++) {
 		pads[i].entity = entity;
 		pads[i].index = i;
-		if (mdev)
-			media_gobj_create(mdev, MEDIA_GRAPH_PAD,
-					&entity->pads[i].graph_obj);
 	}

-	if (mdev)
-		spin_unlock(&mdev->lock);
+	if (mdev == NULL)
+		return 0;
+
+	spin_lock(&mdev->lock);
+	for (i = 0; i < num_pads; i++)
+		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
+				  &entity->pads[i].graph_obj);
+	spin_unlock(&mdev->lock);

 	return 0;
 }
