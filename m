Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39979 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbbLKUSH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 15:18:07 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] [media] media: move MEDIA_LNK_FL_INTERFACE_LINK logic to link creation
Date: Fri, 11 Dec 2015 18:17:53 -0200
Message-Id: <8b0b503ba0b1246fab5519df7fe675c78989e4e9.1449865071.git.mchehab@osg.samsung.com>
In-Reply-To: <1cb01ccf2694e93040738f4dd12a86bcf8ce4994.1449865071.git.mchehab@osg.samsung.com>
References: <1cb01ccf2694e93040738f4dd12a86bcf8ce4994.1449865071.git.mchehab@osg.samsung.com>
In-Reply-To: <1cb01ccf2694e93040738f4dd12a86bcf8ce4994.1449865071.git.mchehab@osg.samsung.com>
References: <1cb01ccf2694e93040738f4dd12a86bcf8ce4994.1449865071.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of flagging an interface link as MEDIA_LNK_FL_INTERFACE_LINK
only when returning to userspace, do it at link creation time.

That would allow using such flag internally, and cleans up a
little bit the code for G_TOPOLOGY ioctl.

Suggested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 3 ---
 drivers/media/media-entity.c | 4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6406914a9bf5..c12481c753a0 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -361,9 +361,6 @@ static long __media_device_get_topology(struct media_device *mdev,
 		klink.sink_id = link->gobj1->id;
 		klink.flags = link->flags;
 
-		if (media_type(link->gobj0) != MEDIA_GRAPH_PAD)
-			klink.flags |= MEDIA_LNK_FL_INTERFACE_LINK;
-
 		if (copy_to_user(ulink, &klink, sizeof(klink)))
 			ret = -EFAULT;
 		ulink++;
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 181ca0de6e52..7895e17aeee9 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -526,7 +526,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 
 	link->source = &source->pads[source_pad];
 	link->sink = &sink->pads[sink_pad];
-	link->flags = flags;
+	link->flags = flags && ~MEDIA_LNK_FL_INTERFACE_LINK;
 
 	/* Initialize graph object embedded at the new link */
 	media_gobj_create(source->graph_obj.mdev, MEDIA_GRAPH_LINK,
@@ -756,7 +756,7 @@ struct media_link *media_create_intf_link(struct media_entity *entity,
 
 	link->intf = intf;
 	link->entity = entity;
-	link->flags = flags;
+	link->flags = flags | MEDIA_LNK_FL_INTERFACE_LINK;
 
 	/* Initialize graph object embedded at the new link */
 	media_gobj_create(intf->graph_obj.mdev, MEDIA_GRAPH_LINK,
-- 
2.5.0

