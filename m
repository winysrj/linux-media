Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:43867 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933677AbcJLOqg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:46:36 -0400
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEX023V7V77YQ70@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2016 23:35:34 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v4l-utils v7 1/7] mediactl: Add support for v4l2-ctrl-binding
 config
Date: Wed, 12 Oct 2016 16:35:16 +0200
Message-id: <1476282922-11544-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make struct v4l2_subdev capable of aggregating v4l2-ctrl-bindings -
media device configuration entries. Added are also functions for
validating support for the control on given media entity and checking
whether a v4l2-ctrl-binding has been defined for a media entity.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libv4l2subdev.c | 32 ++++++++++++++++++++++++++++++++
 utils/media-ctl/v4l2subdev.h    | 19 +++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index c3439d7..4f8ee7f 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -50,7 +50,15 @@ int v4l2_subdev_create(struct media_entity *entity)
 
 	entity->sd->fd = -1;
 
+	entity->sd->v4l2_ctrl_bindings = malloc(sizeof(__u32));
+	if (entity->sd->v4l2_ctrl_bindings == NULL)
+		goto err_v4l2_ctrl_bindings_alloc;
+
 	return 0;
+
+err_v4l2_ctrl_bindings_alloc:
+	free(entity->sd);
+	return -ENOMEM;
 }
 
 int v4l2_subdev_create_opened(struct media_entity *entity, int fd)
@@ -102,6 +110,7 @@ void v4l2_subdev_close(struct media_entity *entity)
 	if (entity->sd->fd_owner)
 		close(entity->sd->fd);
 
+	free(entity->sd->v4l2_ctrl_bindings);
 	free(entity->sd);
 }
 
@@ -884,3 +893,26 @@ const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(unsigned int *length)
 
 	return mbus_codes;
 }
+
+int v4l2_subdev_supports_v4l2_ctrl(struct media_device *media,
+				   struct media_entity *entity,
+				   __u32 ctrl_id)
+{
+	struct v4l2_queryctrl queryctrl = {};
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	queryctrl.id = ctrl_id;
+
+	ret = ioctl(entity->sd->fd, VIDIOC_QUERYCTRL, &queryctrl);
+	if (ret < 0)
+		return ret;
+
+	media_dbg(media, "Validated control \"%s\" (0x%8.8x) on entity %s\n",
+		  queryctrl.name, queryctrl.id, entity->info.name);
+
+	return 0;
+}
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 011fab1..4dee6b1 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -26,10 +26,14 @@
 
 struct media_device;
 struct media_entity;
+struct media_device;
 
 struct v4l2_subdev {
 	int fd;
 	unsigned int fd_owner:1;
+
+	__u32 *v4l2_ctrl_bindings;
+	unsigned int num_v4l2_ctrl_bindings;
 };
 
 /**
@@ -314,4 +318,19 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string);
 const enum v4l2_mbus_pixelcode *v4l2_subdev_pixelcode_list(
 	unsigned int *length);
 
+/**
+ * @brief Check if sub-device supports given v4l2 control
+ * @param media - media device.
+ * @param entity - media entity.
+ * @param ctrl_id - id of the v4l2 control to check.
+ *
+ * Verify if the sub-device associated with given media entity
+ * supports v4l2-control with given ctrl_id.
+ *
+ * @return 1 if the control is supported, 0 otherwise.
+ */
+int v4l2_subdev_supports_v4l2_ctrl(struct media_device *device,
+				   struct media_entity *entity,
+				   __u32 ctrl_id);
+
 #endif
-- 
1.9.1

