Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46470 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752293AbdGMPXy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:23:54 -0400
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9FBCE600CB
        for <linux-media@vger.kernel.org>; Thu, 13 Jul 2017 18:23:49 +0300 (EEST)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 5/6] media: Remove useless curly braces and parentheses
Date: Thu, 13 Jul 2017 18:23:48 +0300
Message-Id: <20170713152349.14480-6-sakari.ailus@linux.intel.com>
In-Reply-To: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
References: <20170713152349.14480-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/media-device.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 760e3e424e23..c51e2e5636f3 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -591,9 +591,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
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
2.11.0
