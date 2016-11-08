Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35222 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751583AbcKHNze (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:34 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 04/21] media: Remove useless curly braces and parentheses
Date: Tue,  8 Nov 2016 15:55:13 +0200
Message-Id: <1478613330-24691-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 0e07300..bb19c04 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -594,9 +594,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
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

