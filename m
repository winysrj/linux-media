Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:37003 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755846AbeCSPna (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 11:43:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 4/8] media: add 'index' to struct media_v2_pad
Date: Mon, 19 Mar 2018 16:43:20 +0100
Message-Id: <20180319154324.37799-5-hverkuil@xs4all.nl>
In-Reply-To: <20180319154324.37799-1-hverkuil@xs4all.nl>
References: <20180319154324.37799-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

The v2 pad structure never exposed the pad index, which made it impossible
to call the MEDIA_IOC_SETUP_LINK ioctl, which needs that information.

It is really trivial to just expose this information, so implement this.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/media-device.c | 1 +
 include/uapi/linux/media.h   | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index dca1e5a3e0f9..73ffea3e81c9 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -331,6 +331,7 @@ static long media_device_get_topology(struct media_device *mdev,
 		kpad.id = pad->graph_obj.id;
 		kpad.entity_id = pad->entity->graph_obj.id;
 		kpad.flags = pad->flags;
+		kpad.index = pad->index;
 
 		if (copy_to_user(upad, &kpad, sizeof(kpad)))
 			ret = -EFAULT;
diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
index 8fb50c122536..d4bad16d9431 100644
--- a/include/uapi/linux/media.h
+++ b/include/uapi/linux/media.h
@@ -310,11 +310,16 @@ struct media_v2_interface {
 	};
 } __attribute__ ((packed));
 
+/* Appeared in 4.17.0 */
+#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
+	((media_version) >= 0x00041100)
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
2.15.1
