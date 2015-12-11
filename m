Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51745 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbLKNe3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 08:34:29 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 06/10] media-entity.h: convert media_entity_cleanup to inline
Date: Fri, 11 Dec 2015 11:34:11 -0200
Message-Id: <2909da09783421c06d80064fd828edfde65c1224.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1449840443.git.mchehab@osg.samsung.com>
References: <cover.1449840443.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function was used in the past to free the links
that were allocated by the media controller core.

However, this is not needed anymore. We should likely
get rid of the funcion on some function, but, for now,
let's just convert into an inlined function and let the
compiler to get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-entity.c | 6 ------
 include/media/media-entity.h | 3 ++-
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index ef2102ac0c66..849db4f6f1f3 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -246,12 +246,6 @@ media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 }
 EXPORT_SYMBOL_GPL(media_entity_pads_init);
 
-void
-media_entity_cleanup(struct media_entity *entity)
-{
-}
-EXPORT_SYMBOL_GPL(media_entity_cleanup);
-
 /* -----------------------------------------------------------------------------
  * Graph traversal
  */
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 031536723d8c..e9bc5857899c 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -345,7 +345,8 @@ void media_gobj_remove(struct media_gobj *gobj);
 
 int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 		      struct media_pad *pads);
-void media_entity_cleanup(struct media_entity *entity);
+
+static inline void media_entity_cleanup(struct media_entity *entity) {};
 
 __must_check int media_create_pad_link(struct media_entity *source,
 			u16 source_pad, struct media_entity *sink,
-- 
2.5.0


