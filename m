Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbbIFMD5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 08:03:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH v8 43/55] [media] media: report if a pad is sink or source at debug msg
Date: Sun,  6 Sep 2015 09:03:03 -0300
Message-Id: <a5724b2c7cac1192cbd5033d90745daa586883aa.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <e1e261997cc156eb6f6839944431fb6dba0c814a.1440902901.git.mchehab@osg.samsung.com>
References: <e1e261997cc156eb6f6839944431fb6dba0c814a.1440902901.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sometimes, it is important to see if the created pad is
sink or source. Add info to track that.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index d8038a53f945..6ed5eef88593 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -121,8 +121,11 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_pad *pad = gobj_to_pad(gobj);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s: id 0x%08x pad#%d: '%s':%d\n",
-			event_name, gobj->id, media_localid(gobj),
+			"%s: id 0x%08x %s%spad#%d: '%s':%d\n",
+			event_name, gobj->id,
+			pad->flags & MEDIA_PAD_FL_SINK   ? "  sink " : "",
+			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",
+			media_localid(gobj),
 			pad->entity->name, pad->index);
 		break;
 	}
-- 
2.4.3


