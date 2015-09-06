Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54582 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbbIFMDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 20/55] [media] media: make add link more generic
Date: Sun,  6 Sep 2015 09:02:49 -0300
Message-Id: <1d94e71434a16c7dcb24d9df592ad6b2d72a4895.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <81b61cdb4bb2192b2810675f80cc12b06b4d242b.1440902901.git.mchehab@osg.samsung.com>
References: <81b61cdb4bb2192b2810675f80cc12b06b4d242b.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media_entity_add_link() function takes an entity
as an argument just to get the list head.

Make it more generic by changing the function argument
to list_head.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d5efa0e2c88c..625b505e8496 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -580,7 +580,7 @@ EXPORT_SYMBOL_GPL(media_entity_put);
  * Links management
  */
 
-static struct media_link *media_entity_add_link(struct media_entity *entity)
+static struct media_link *media_add_link(struct list_head *head)
 {
 	struct media_link *link;
 
@@ -588,7 +588,7 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 	if (link == NULL)
 		return NULL;
 
-	list_add_tail(&link->list, &entity->links);
+	list_add_tail(&link->list, head);
 
 	return link;
 }
@@ -607,7 +607,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	BUG_ON(source_pad >= source->num_pads);
 	BUG_ON(sink_pad >= sink->num_pads);
 
-	link = media_entity_add_link(source);
+	link = media_add_link(&source->links);
 	if (link == NULL)
 		return -ENOMEM;
 
@@ -622,7 +622,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	/* Create the backlink. Backlinks are used to help graph traversal and
 	 * are not reported to userspace.
 	 */
-	backlink = media_entity_add_link(sink);
+	backlink = media_add_link(&sink->links);
 	if (backlink == NULL) {
 		__media_entity_remove_link(source, link);
 		return -ENOMEM;
-- 
2.4.3


