Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbbH3DHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v8 20/55] [media] media: make add link more generic
Date: Sun, 30 Aug 2015 00:06:31 -0300
Message-Id: <81b61cdb4bb2192b2810675f80cc12b06b4d242b.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media_entity_add_link() function takes an entity
as an argument just to get the list head.

Make it more generic by changing the function argument
to list_head.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index ff63201443d7..6d06be6c9ef3 100644
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

