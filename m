Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbbHGOUV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 10:20:21 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC v2 12/16] media: move __media_entity_remove_link to avoid prototype
Date: Fri,  7 Aug 2015 11:20:10 -0300
Message-Id: <660ef0c0506ebe9313a0e1e83a6e8b5a2c6e15d2.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1438954897.git.mchehab@osg.samsung.com>
References: <cover.1438954897.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we need __media_entity_remove_link() earlier, move it to
happen earlier, to avoid needing to have a function prototype.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 43fa8ac59055..96d48aec8381 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -481,7 +481,36 @@ static struct media_link *media_entity_add_link(struct media_entity *entity)
 }
 
 static void __media_entity_remove_link(struct media_entity *entity,
-				       struct media_link *link);
+				       struct media_link *link)
+{
+	struct media_link *rlink, *tmp;
+	struct media_entity *remote;
+	unsigned int r = 0;
+
+	if (gobj_to_pad(link->source)->entity == entity)
+		remote = gobj_to_pad(link->sink)->entity;
+	else
+		remote = gobj_to_pad(link->source)->entity;
+
+	list_for_each_entry_safe(rlink, tmp, &remote->links, list) {
+		if (rlink != link->reverse) {
+			r++;
+			continue;
+		}
+
+		if (gobj_to_pad(link->source)->entity == entity)
+			remote->num_backlinks--;
+
+		if (--remote->num_links == 0)
+			break;
+
+		/* Remove the remote link */
+		list_del(&rlink->list);
+		kfree(rlink);
+	}
+	list_del(&link->list);
+	kfree(link);
+}
 
 int
 media_create_pad_link(struct media_entity *source, u16 source_pad,
@@ -524,38 +553,6 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 }
 EXPORT_SYMBOL_GPL(media_create_pad_link);
 
-static void __media_entity_remove_link(struct media_entity *entity,
-				       struct media_link *link)
-{
-	struct media_link *rlink, *tmp;
-	struct media_entity *remote;
-	unsigned int r = 0;
-
-	if (gobj_to_pad(link->source)->entity == entity)
-		remote = gobj_to_pad(link->sink)->entity;
-	else
-		remote = gobj_to_pad(link->source)->entity;
-
-	list_for_each_entry_safe(rlink, tmp, &remote->links, list) {
-		if (rlink != link->reverse) {
-			r++;
-			continue;
-		}
-
-		if (gobj_to_pad(link->source)->entity == entity)
-			remote->num_backlinks--;
-
-		if (--remote->num_links == 0)
-			break;
-
-		/* Remove the remote link */
-		list_del(&rlink->list);
-		kfree(rlink);
-	}
-	list_del(&link->list);
-	kfree(link);
-}
-
 void __media_entity_remove_links(struct media_entity *entity)
 {
 	struct media_link *link, *tmp;
-- 
2.4.3

