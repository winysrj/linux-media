Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58557 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943AbbHSPhD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 11:37:03 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 4/4] [media] media: remove media entity .parent field
Date: Wed, 19 Aug 2015 17:35:22 +0200
Message-Id: <1439998526-12832-5-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1439998526-12832-1-git-send-email-javier@osg.samsung.com>
References: <1439998526-12832-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the struct media_entity .parent field is unused, it can be
safely removed. Since all the previous users were converted to use
the .mdev field from the embedded struct media_gobj instead.

Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 include/media/media-entity.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 3b653e9321f2..d7e007f624a5 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -103,7 +103,6 @@ struct media_entity_operations {
 struct media_entity {
 	struct media_gobj graph_obj;
 	struct list_head list;
-	struct media_device *parent;	/* Media device this entity belongs to*/
 	const char *name;		/* Entity name */
 	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
 	u32 revision;			/* Entity revision, driver specific */
-- 
2.4.3

