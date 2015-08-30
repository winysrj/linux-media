Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48549 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbbH3DHx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:53 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH v8 12/55] [media] media: remove media entity .parent field
Date: Sun, 30 Aug 2015 00:06:23 -0300
Message-Id: <b2f92828846255f57170c14b6e9291270deb0ffa.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Javier Martinez Canillas <javier@osg.samsung.com>

Now that the struct media_entity .parent field is unused, it can be
safely removed. Since all the previous users were converted to use
the .mdev field from the embedded struct media_gobj instead.

Suggested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index e0e4b014ce62..239c4ec30ef6 100644
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

