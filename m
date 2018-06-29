Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:38512 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936098AbeF2Lng (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 29 Jun 2018 07:43:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv5 03/12] media: add flags field to struct media_v2_entity
Date: Fri, 29 Jun 2018 13:43:22 +0200
Message-Id: <20180629114331.7617-4-hverkuil@xs4all.nl>
In-Reply-To: <20180629114331.7617-1-hverkuil@xs4all.nl>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The v2 entity structure never exposed the entity flags, which made it
impossible to detect connector or default entities.

It is really trivial to just expose this information, so implement this.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c |  1 +
 include/uapi/linux/media.h   | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 047d38372a27..14959b19a342 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -266,6 +266,7 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
 		memset(&kentity, 0, sizeof(kentity));
 		kentity.id = entity->graph_obj.id;
 		kentity.function = entity->function;
+		kentity.flags = entity->flags;
 		strlcpy(kentity.name, entity->name,
 			sizeof(kentity.name));
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index f6338bd57929..ebd2cda67833 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -280,11 +280,21 @@ struct media_links_enum {
  * MC next gen API definitions
  */
 
+/*
+ * Appeared in 4.19.0.
+ *
+ * The media_version argument comes from the media_version field in
+ * struct media_device_info.
+ */
+#define MEDIA_V2_ENTITY_HAS_FLAGS(media_version) \
+	((media_version) >= ((4 << 16) | (19 << 8) | 0))
+
 struct media_v2_entity {
 	__u32 id;
 	char name[64];
 	__u32 function;		/* Main function of the entity */
-	__u32 reserved[6];
+	__u32 flags;
+	__u32 reserved[5];
 } __attribute__ ((packed));
 
 /* Should match the specific fields at media_intf_devnode */
-- 
2.17.0
