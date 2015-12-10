Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34785 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbbLJReK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 12:34:10 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] media-entity: fix backlink removal on __media_entity_remove_link()
Date: Thu, 10 Dec 2015 15:33:56 -0200
Message-Id: <e3fd58297fe77a76e3b6ba9019f64f0c1c0ceb87.1449768833.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic is testing if num_links==0 at the wrong place. Due to
that, a backlink may be kept without removal, causing KASAN
to complain about usage after free during either entity or
link removal.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d7243cb56c79..d9d42fab22ad 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -662,13 +662,13 @@ static void __media_entity_remove_link(struct media_entity *entity,
 		if (link->source->entity == entity)
 			remote->num_backlinks--;
 
-		if (--remote->num_links == 0)
-			break;
-
 		/* Remove the remote link */
 		list_del(&rlink->list);
 		media_gobj_remove(&rlink->graph_obj);
 		kfree(rlink);
+
+		if (--remote->num_links == 0)
+			break;
 	}
 	list_del(&link->list);
 	media_gobj_remove(&link->graph_obj);
-- 
2.5.0

