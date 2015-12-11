Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37560 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbbLKRRS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Dec 2015 12:17:18 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 08/10] [media] uvcvideo: remove pads prefix from uvc_mc_create_pads_links()
Date: Fri, 11 Dec 2015 14:16:34 -0300
Message-Id: <1449854196-13296-9-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
References: <1449854196-13296-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function uvc_mc_create_pads_links() creates entities links but the
"pads" prefix is redundant since the driver doesn't handle any other
kind of link, so it can be removed.

Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

This patch addresses an issue Laurent pointed in patch [0]:

- You can call this uvc_mc_create_links(), there's no other type of links.

[0]: https://lkml.org/lkml/2015/12/5/253

 drivers/media/usb/uvc/uvc_entity.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 38e893a1408b..33119dcb7cec 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -32,7 +32,7 @@ static int uvc_mc_register_entity(struct uvc_video_chain *chain,
 	return v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
 }
 
-static int uvc_mc_create_pads_links(struct uvc_video_chain *chain,
+static int uvc_mc_create_links(struct uvc_video_chain *chain,
 				    struct uvc_entity *entity)
 {
 	const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE;
@@ -131,9 +131,9 @@ int uvc_mc_register_entities(struct uvc_video_chain *chain)
 	}
 
 	list_for_each_entry(entity, &chain->entities, chain) {
-		ret = uvc_mc_create_pads_links(chain, entity);
+		ret = uvc_mc_create_links(chain, entity);
 		if (ret < 0) {
-			uvc_printk(KERN_INFO, "Failed to create pads links for "
+			uvc_printk(KERN_INFO, "Failed to create links for "
 				   "entity %u\n", entity->id);
 			return ret;
 		}
-- 
2.4.3

