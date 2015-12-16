Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965804AbbLPRRH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 12:17:07 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] media-entity.h: document the remaining functions
Date: Wed, 16 Dec 2015 15:16:46 -0200
Message-Id: <55b894723556a7e45891ed0800e835af32f71d16.1450286204.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are two ancillary functions that are missing comments.

While those are used only internally at media-entity.c,
document them, for completeness.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 include/media/media-entity.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 73ab2bc6a1c9..db874439dcd6 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -301,11 +301,22 @@ static inline enum media_gobj_type media_type(struct media_gobj *gobj)
 	return gobj->id >> MEDIA_BITS_PER_ID;
 }
 
+/**
+ * media_id() - return the media object ID
+ *
+ * @gobj:	pointer to the media graph object
+ */
 static inline u64 media_id(struct media_gobj *gobj)
 {
 	return gobj->id & MEDIA_ID_MASK;
 }
 
+/**
+ * media_gobj_gen_id() - encapsulates type and ID on at the object ID
+ *
+ * @type:	object type as define at enum &media_gobj_type.
+ * @local_id:	next ID, from struct &media_device.@id.
+ */
 static inline u64 media_gobj_gen_id(enum media_gobj_type type, u64 local_id)
 {
 	u64 id;
-- 
2.5.0

