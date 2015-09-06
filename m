Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54589 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbbIFMDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 22/55] [media] media: make link debug printk more generic
Date: Sun,  6 Sep 2015 09:02:51 -0300
Message-Id: <5a3e9d8df39c3c8baddbe40f0cbeae4640454de0.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <33ebce0d6df107c0cc0f8e68fe84f83fae199d93.1440902901.git.mchehab@osg.samsung.com>
References: <33ebce0d6df107c0cc0f8e68fe84f83fae199d93.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove entity name from the link as this exists only if the object
type is PAD on both link ends.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 625b505e8496..f9c6c2a81903 100644
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


