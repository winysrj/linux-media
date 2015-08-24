Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59497 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbbHXR6J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 13:58:09 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-media@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: don't try to empty links list in media_entity_cleanup()
Date: Mon, 24 Aug 2015 19:57:53 +0200
Message-Id: <1440439073-4082-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media_entity_cleanup() function only cleans up the entity links list
but this operation is already made in media_device_unregister_entity().

In most cases this should be harmless (besides having duplicated code)
since the links list would be empty so the iteration would not happen
but the links list is initialized in media_device_register_entity() so
if a driver fails to register an entity with a media device and clean up
the entity in the error path, a NULL deference pointer error will happen.

So don't try to empty the links list in media_entity_cleanup() since
is either done already or haven't been initialized yet.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/media-entity.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index fc6bb48027ab..acb65f734508 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -252,13 +252,6 @@ EXPORT_SYMBOL_GPL(media_entity_init);
 void
 media_entity_cleanup(struct media_entity *entity)
 {
-	struct media_link *link, *tmp;
-
-	list_for_each_entry_safe(link, tmp, &entity->links, list) {
-		media_gobj_remove(&link->graph_obj);
-		list_del(&link->list);
-		kfree(link);
-	}
 }
 EXPORT_SYMBOL_GPL(media_entity_cleanup);
 
-- 
2.4.3

