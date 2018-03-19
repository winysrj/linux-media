Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:38816 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755826AbeCSPn3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 11:43:29 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 2/8] media: add function field to struct media_entity_desc
Date: Mon, 19 Mar 2018 16:43:18 +0100
Message-Id: <20180319154324.37799-3-hverkuil@xs4all.nl>
In-Reply-To: <20180319154324.37799-1-hverkuil@xs4all.nl>
References: <20180319154324.37799-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

This adds support for 'proper' functions to the existing API.
This information was before only available through the new v2
API, with this change it's available to both.

Yes, the plan is to allow entities to expose multiple functions for
multi-function devices, but we do not support it anywhere so this
is still vaporware.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/media-device.c | 1 +
 include/uapi/linux/media.h   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7c3ab37c258a..dca1e5a3e0f9 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -115,6 +115,7 @@ static long media_device_enum_entities(struct media_device *mdev,
 	if (ent->name)
 		strlcpy(entd->name, ent->name, sizeof(entd->name));
 	entd->type = ent->function;
+	entd->function = ent->function;
 	entd->revision = 0;		/* Unused */
 	entd->flags = ent->flags;
 	entd->group_id = 0;		/* Unused */
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 86c7dcc9cba3..8fb50c122536 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -146,6 +146,10 @@ struct media_device_info {
 /* OR with the entity id value to find the next entity */
 #define MEDIA_ENT_ID_FLAG_NEXT			(1 << 31)
 
+/* Appeared in 4.17.0 */
+#define MEDIA_ENTITY_DESC_HAS_FUNCTION(media_version) \
+	((media_version) >= 0x00041100)
+
 struct media_entity_desc {
 	__u32 id;
 	char name[32];
@@ -155,8 +159,9 @@ struct media_entity_desc {
 	__u32 group_id;
 	__u16 pads;
 	__u16 links;
+	__u32 function;
 
-	__u32 reserved[4];
+	__u32 reserved[3];
 
 	union {
 		/* Node specifications */
-- 
2.15.1
