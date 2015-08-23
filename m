Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbbHWUSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Aug 2015 16:18:08 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v7 19/44] [media] media: make link debug printk more generic
Date: Sun, 23 Aug 2015 17:17:36 -0300
Message-Id: <e5b7afddd3087eda9267245fcbfc1d24d059b3a9.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440359643.git.mchehab@osg.samsung.com>
References: <cover.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove entity name from the link as this exists only if the object
type is PAD on both link ends.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 9ec9c503caca..5788297cd500 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -106,14 +106,12 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_link *link = gobj_to_link(gobj);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s: id 0x%08x link#%d: '%s' %s#%d ==> '%s' %s#%d\n",
+			"%s: id 0x%08x link#%d: %s#%d ==> %s#%d\n",
 			event_name, gobj->id, media_localid(gobj),
 
-			link->source->entity->name,
 			gobj_type(media_type(&link->source->graph_obj)),
 			media_localid(&link->source->graph_obj),
 
-			link->sink->entity->name,
 			gobj_type(media_type(&link->sink->graph_obj)),
 			media_localid(&link->sink->graph_obj));
 		break;
-- 
2.4.3

