Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51756 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbLKNe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/10] media-entity: get rid of forward __media_entity_remove_link() declaration
Date: Fri, 11 Dec 2015 11:34:14 -0200
Message-Id: <71b0cac4a89540f4f17b89a33624c9acdbd02631.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move this function to happen earlier, in order to avoid
a uneeded forward declaration.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 67 +++++++++++++++++++++-----------------------
 1 file changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 5a5432524c10..452af1d5a20d 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -588,7 +588,38 @@ static struct media_link *media_add_link(struct list_head *head)
 }
 
 static void __media_entity_remove_link(struct media_entity *entity,
-				       struct media_link *link);
+				       struct media_link *link)
+{
+	struct media_link *rlink, *tmp;
+	struct media_entity *remote;
+	unsigned int r = 0;
+
+	if (link->source->entity == entity)
+		remote = link->sink->entity;
+	else
+		remote = link->source->entity;
+
+	list_for_each_entry_safe(rlink, tmp, &remote->links, list) {
+		if (rlink != link->reverse) {
+			r++;
+			continue;
+		}
+
+		if (link->source->entity == entity)
+			remote->num_backlinks--;
+
+		/* Remove the remote link */
+		list_del(&rlink->list);
+		media_gobj_remove(&rlink->graph_obj);
+		kfree(rlink);
+
+		if (--remote->num_links == 0)
+			break;
+	}
+	list_del(&link->list);
+	media_gobj_remove(&link->graph_obj);
+	kfree(link);
+}
 
 int
 media_create_pad_link(struct media_entity *source, u16 source_pad,
@@ -642,40 +673,6 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 }
 EXPORT_SYMBOL_GPL(media_create_pad_link);
 
-static void __media_entity_remove_link(struct media_entity *entity,
-				       struct media_link *link)
-{
-	struct media_link *rlink, *tmp;
-	struct media_entity *remote;
-	unsigned int r = 0;
-
-	if (link->source->entity == entity)
-		remote = link->sink->entity;
-	else
-		remote = link->source->entity;
-
-	list_for_each_entry_safe(rlink, tmp, &remote->links, list) {
-		if (rlink != link->reverse) {
-			r++;
-			continue;
-		}
-
-		if (link->source->entity == entity)
-			remote->num_backlinks--;
-
-		/* Remove the remote link */
-		list_del(&rlink->list);
-		media_gobj_remove(&rlink->graph_obj);
-		kfree(rlink);
-
-		if (--remote->num_links == 0)
-			break;
-	}
-	list_del(&link->list);
-	media_gobj_remove(&link->graph_obj);
-	kfree(link);
-}
-
 void __media_entity_remove_links(struct media_entity *entity)
 {
 	struct media_link *link, *tmp;
-- 
2.5.0


