Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbbH3DHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Aug 2015 23:07:51 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v8 22/55] [media] media: make link debug printk more generic
Date: Sun, 30 Aug 2015 00:06:33 -0300
Message-Id: <33ebce0d6df107c0cc0f8e68fe84f83fae199d93.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1440902901.git.mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove entity name from the link as this exists only if the object
type is PAD on both link ends.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 6d06be6c9ef3..973d1be427c5 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -106,16 +106,14 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_link *link = gobj_to_link(gobj);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s: id 0x%08x link#%d: '%s' %s#%d ==> '%s' %s#%d\n",
+			"%s: id 0x%08x link#%d: %s#%d ==> %s#%d\n",
 			event_name, gobj->id, media_localid(gobj),
 
-			link->source->entity->name,
-			gobj_type(media_type(&link->source->graph_obj)),
-			media_localid(&link->source->graph_obj),
+			gobj_type(media_type(link->gobj0)),
+			media_localid(link->gobj0),
 
-			link->sink->entity->name,
-			gobj_type(media_type(&link->sink->graph_obj)),
-			media_localid(&link->sink->graph_obj));
+			gobj_type(media_type(link->gobj1)),
+			media_localid(link->gobj1));
 		break;
 	}
 	case MEDIA_GRAPH_PAD:
-- 
2.4.3

