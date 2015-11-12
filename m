Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:48663 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbbKLOlv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Nov 2015 09:41:51 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix kernel hang in media_device_unregister() during device removal
Date: Thu, 12 Nov 2015 07:41:47 -0700
Message-Id: <1447339307-2838-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media core drivers (dvb, v4l2, bridge driver) unregister
their entities calling media_device_unregister_entity()
during device removal from their unregister paths. In
addition media_device_unregister() tries to unregister
entity calling media_device_unregister_entity() for each
one of them. This adds lot of contention on mdev->lock in
device removal sequence. Fix to not unregister entities
from media_device_unregister(), and let drivers take care
of it. Drivers need to unregister to cover the case of
module removal. This patch fixes the problem by deleting
the entity list walk to call media_device_unregister_entity()
for each entity. With this fix there is no kernel hang after
a sequence of device insertions followed by removal.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1312e93..c7ab7c9 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -577,8 +577,6 @@ EXPORT_SYMBOL_GPL(__media_device_register);
  */
 void media_device_unregister(struct media_device *mdev)
 {
-	struct media_entity *entity;
-	struct media_entity *next;
 	struct media_link *link, *tmp_link;
 	struct media_interface *intf, *tmp_intf;
 
@@ -596,9 +594,6 @@ void media_device_unregister(struct media_device *mdev)
 		kfree(intf);
 	}
 
-	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
-		media_device_unregister_entity(entity);
-
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
 
-- 
2.5.0

