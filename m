Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbbLKNeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:31 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 10/10] media_entity: get rid of an unused var
Date: Fri, 11 Dec 2015 11:34:15 -0200
Message-Id: <95de6a57c077feeca7187eab18fc8d4025a8f238.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > > +		if (rlink != link->reverse) {
> > > +			r++;
> >
> > The variable is incremented here but otherwise never used, you can remove it.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 452af1d5a20d..57de11281af1 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -592,7 +592,6 @@ static void __media_entity_remove_link(struct media_entity *entity,
 {
 	struct media_link *rlink, *tmp;
 	struct media_entity *remote;
-	unsigned int r = 0;
 
 	if (link->source->entity == entity)
 		remote = link->sink->entity;
@@ -600,10 +599,8 @@ static void __media_entity_remove_link(struct media_entity *entity,
 		remote = link->source->entity;
 
 	list_for_each_entry_safe(rlink, tmp, &remote->links, list) {
-		if (rlink != link->reverse) {
-			r++;
+		if (rlink != link->reverse)
 			continue;
-		}
 
 		if (link->source->entity == entity)
 			remote->num_backlinks--;
-- 
2.5.0


