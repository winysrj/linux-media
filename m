Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:37238 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751248AbeGJIpO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jul 2018 04:45:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCHv6 01/12] media: add 'index' to struct media_v2_pad
Date: Tue, 10 Jul 2018 10:45:01 +0200
Message-Id: <20180710084512.99238-2-hverkuil@xs4all.nl>
In-Reply-To: <20180710084512.99238-1-hverkuil@xs4all.nl>
References: <20180710084512.99238-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The v2 pad structure never exposed the pad index, which made it impossible
to call the MEDIA_IOC_SETUP_LINK ioctl, which needs that information.

It is really trivial to just expose this information, so implement this.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c |  1 +
 include/uapi/linux/media.h   | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 47bb2254fbfd..047d38372a27 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -331,6 +331,7 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
 		kpad.id = pad->graph_obj.id;
 		kpad.entity_id = pad->entity->graph_obj.id;
 		kpad.flags = pad->flags;
+		kpad.index = pad->index;
 
 		if (copy_to_user(upad, &kpad, sizeof(kpad)))
 			ret = -EFAULT;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 86c7dcc9cba3..f6338bd57929 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -305,11 +305,21 @@ struct media_v2_interface {
 	};
 } __attribute__ ((packed));
 
+/*
+ * Appeared in 4.19.0.
+ *
+ * The media_version argument comes from the media_version field in
+ * struct media_device_info.
+ */
+#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
+	((media_version) >= ((4 << 16) | (19 << 8) | 0))
+
 struct media_v2_pad {
 	__u32 id;
 	__u32 entity_id;
 	__u32 flags;
-	__u32 reserved[5];
+	__u32 index;
+	__u32 reserved[4];
 } __attribute__ ((packed));
 
 struct media_v2_link {
-- 
2.18.0
