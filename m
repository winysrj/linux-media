Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965086AbbLOKJG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:09:06 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] [media] media-entity: use mutes for link setup
Date: Tue, 15 Dec 2015 08:08:38 -0200
Message-Id: <0a8b9468b9da5f5d4177446696a91ce4099354d0.1450174116.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset f8fd4c61b5ae ("[media] media-entity: protect object
creation/removal using spin lock") changed the object creation/removal
protection to spin lock, as this is what's used on media-device,
keeping the mutex reserved for graph traversal routines. However, it
also changed the link setup, by mistake.

This could cause troubles, as the link setup can affect the graph
traversal, and this is likely the reason for a mutex there.

So, revert media_entity_setup_link() to use mutex.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5d871b243e87..29810f9b86ce 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -662,9 +662,9 @@ int media_entity_setup_link(struct media_link *link, u32 flags)
 {
 	int ret;
 
-	spin_lock(&link->source->entity->graph_obj.mdev->lock);
+	mutex_lock(&link->graph_obj.mdev->graph_mutex);
 	ret = __media_entity_setup_link(link, flags);
-	spin_unlock(&link->source->entity->graph_obj.mdev->lock);
+	mutex_unlock(&link->graph_obj.mdev->graph_mutex);
 
 	return ret;
 }
-- 
2.5.0

