Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:45870 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033AbbLPRUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:20:17 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH] [media] media-entity: increase max number of PADs
Date: Wed, 16 Dec 2015 15:19:56 -0200
Message-Id: <2ff65bcea15d9cec88369d2e003c812967a28c40.1450286393.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The DVB drivers may have 257 PADs. Get the next power of two
that would accomodate that amount.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d3160224db33..ae70b6f54b18 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -261,7 +261,7 @@ static struct media_entity *stack_pop(struct media_entity_graph *graph)
 /*
  * TODO: Get rid of this.
  */
-#define MEDIA_ENTITY_MAX_PADS		63
+#define MEDIA_ENTITY_MAX_PADS		512
 
 /**
  * media_entity_graph_walk_init - Allocate resources for graph walk
-- 
2.5.0

