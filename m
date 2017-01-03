Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45048 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755515AbdACH0t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 3 Jan 2017 02:26:49 -0500
Received: from lanttu.localdomain (unknown [192.168.15.166])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 0AAA960097
        for <linux-media@vger.kernel.org>; Tue,  3 Jan 2017 09:26:44 +0200 (EET)
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/1] media: Properly pass through media entity types in entity enumeration
Date: Tue,  3 Jan 2017 09:26:45 +0200
Message-Id: <1483428405-24555-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the functions replaced media entity types, the range which was
allowed for the types was incorrect. This meant that media entity types
for specific devices were not passed correctly to the userspace through
MEDIA_IOC_ENUM_ENTITIES. Fix it.

Fixes: commit b2cd27448b33 ("[media] media-device: map new functions into old types for legacy API")
Reported-and-tested-by: Antti Laakso <antti.laakso@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Should go to stable as well. I'll add cc stable to the pull request later
on.

 drivers/media/media-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 8756275..8927456 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -130,7 +130,7 @@ static long media_device_enum_entities(struct media_device *mdev,
 	 * old range.
 	 */
 	if (ent->function < MEDIA_ENT_F_OLD_BASE ||
-	    ent->function > MEDIA_ENT_T_DEVNODE_UNKNOWN) {
+	    ent->function > MEDIA_ENT_F_TUNER) {
 		if (is_media_entity_v4l2_subdev(ent))
 			entd->type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
 		else if (ent->function != MEDIA_ENT_F_IO_V4L)
-- 
2.1.4

