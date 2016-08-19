Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46748 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752338AbcHSKYD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 06:24:03 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v2 04/17] media: Remove useless curly braces and parentheses
Date: Fri, 19 Aug 2016 13:23:35 +0300
Message-Id: <1471602228-30722-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a1cd50f..8bdc316 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -596,9 +596,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 			       &entity->pads[i].graph_obj);
 
 	/* invoke entity_notify callbacks */
-	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list) {
-		(notify)->notify(entity, notify->notify_data);
-	}
+	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list)
+		notify->notify(entity, notify->notify_data);
 
 	if (mdev->entity_internal_idx_max
 	    >= mdev->pm_count_walk.ent_enum.idx_max) {
-- 
2.1.4

