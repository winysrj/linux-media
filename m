Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:60101 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbbHZPZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Aug 2015 11:25:46 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 1/2] [media] media: don't try to empty links list in media_entity_cleanup()
Date: Wed, 26 Aug 2015 17:25:18 +0200
Message-Id: <1440602719-12500-2-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1440602719-12500-1-git-send-email-javier@osg.samsung.com>
References: <1440602719-12500-1-git-send-email-javier@osg.samsung.com>
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

Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/media-entity.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 7e6fb5a86b21..27eeb691765d 100644
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

