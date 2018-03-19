Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:40354 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755859AbeCSPna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 11:43:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 6/8] media: add flags field to struct media_v2_entity
Date: Mon, 19 Mar 2018 16:43:22 +0100
Message-Id: <20180319154324.37799-7-hverkuil@xs4all.nl>
In-Reply-To: <20180319154324.37799-1-hverkuil@xs4all.nl>
References: <20180319154324.37799-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The v2 entity structure never exposed the entity flags, which made it
impossible to detect connector or default entities.

It is really trivial to just expose this information, so implement this.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/media-device.c | 1 +
 include/uapi/linux/media.h   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 73ffea3e81c9..00f7ce74e42a 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -266,6 +266,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		memset(&kentity, 0, sizeof(kentity));
 		kentity.id = entity->graph_obj.id;
 		kentity.function = entity->function;
+		kentity.flags = entity->flags;
 		strlcpy(kentity.name, entity->name,
 			sizeof(kentity.name));
 
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index d4bad16d9431..a1b072ec34a6 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -285,11 +285,16 @@ struct media_links_enum {
  * MC next gen API definitions
  */
 
+/* Appeared in 4.17.0 */
+#define MEDIA_V2_ENTITY_HAS_FLAGS(media_version) \
+	((media_version) >= 0x00041100)
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
2.15.1
