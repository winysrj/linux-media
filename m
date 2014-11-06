Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:19746 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaKFKMU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:20 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00CQW4BULR90@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:11:55 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils RFC v3 01/11] mediactl: Introduce ctrl_to_subdev
 configuration
Date: Thu, 06 Nov 2014 11:11:32 +0100
Message-id: <1415268702-23685-2-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an infrastructure for a ctrl_to_subdev configuration
data. The ctrl_to_subdev config entry is designed for
conveying information about the target sub-device
in the media device pipeline for a v4l2 control related
ioctl calls.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c   |   26 ++++++++++++++++++++++++++
 utils/media-ctl/libv4l2subdev.c |   31 +++++++++++++++++++++++++++++++
 utils/media-ctl/mediactl-priv.h |    8 ++++++++
 utils/media-ctl/mediactl.h      |   16 ++++++++++++++++
 utils/media-ctl/v4l2subdev.h    |   15 +++++++++++++++
 5 files changed, 96 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index ec360bd..795aaad 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -647,12 +647,20 @@ static struct media_device *__media_device_new(void)
 	if (media == NULL)
 		return NULL;
 
+	media->ctrl_to_subdev = malloc(sizeof(*media->ctrl_to_subdev));
+	if (!media->ctrl_to_subdev)
+		goto err_cts_alloc;
+
 	media->fd = -1;
 	media->refcount = 1;
 
 	media_debug_set_handler(media, NULL, NULL);
 
 	return media;
+
+err_cts_alloc:
+	free(media);
+	return NULL;
 }
 
 struct media_device *media_device_new(const char *devnode)
@@ -710,6 +718,7 @@ void media_device_unref(struct media_device *media)
 
 	free(media->entities);
 	free(media->devnode);
+	free(media->ctrl_to_subdev);
 	free(media);
 }
 
@@ -955,3 +964,20 @@ int media_parse_setup_links(struct media_device *media, const char *p)
 
 	return *end ? -EINVAL : 0;
 }
+
+/* -----------------------------------------------------------------------------
+ * Configuration access
+ */
+
+struct media_entity *media_config_get_entity_by_cid(struct media_device *media,
+						    int cid)
+{
+	int i;
+
+	for (i = 0; i < media->ctrl_to_subdev_count; ++i) {
+		if (media->ctrl_to_subdev[i].ctrl_id == cid)
+			return media->ctrl_to_subdev[i].entity;
+	}
+
+        return NULL;
+}
diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
index 8015330..99ac6b2 100644
--- a/utils/media-ctl/libv4l2subdev.c
+++ b/utils/media-ctl/libv4l2subdev.c
@@ -755,3 +755,34 @@ enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
 
 	return mbus_formats[i].code;
 }
+
+int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
+				   struct media_entity *entity,
+				   __u32 ctrl_id)
+{
+	struct v4l2_query_ext_ctrl queryctrl;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	/* Iterate through control ids */
+
+	queryctrl.id = ctrl_id;
+
+	ret = ioctl(entity->fd, VIDIOC_QUERY_EXT_CTRL, &queryctrl);
+	if (!ret) {
+		media_dbg(media, "Validated control \"%s\" (0x%8.8x) on entity %s\n",
+								queryctrl.name,
+								ctrl_id,
+								entity->info.name);
+		return 1;
+	}
+
+	media_dbg(media, "Control (0x%8.8x) not supported on entity %s\n",
+							queryctrl.name,
+							ctrl_id,
+							entity->info.name);
+	return 0;
+}
diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
index a0d3a55..b9e9b20 100644
--- a/utils/media-ctl/mediactl-priv.h
+++ b/utils/media-ctl/mediactl-priv.h
@@ -47,6 +47,9 @@ struct media_device {
 	struct media_entity *entities;
 	unsigned int entities_count;
 
+	struct media_v4l2_ctrl_to_subdev *ctrl_to_subdev;
+	unsigned int ctrl_to_subdev_count;
+
 	void (*debug_handler)(void *, ...);
 	void *debug_priv;
 
@@ -58,6 +61,11 @@ struct media_device {
 	} def;
 };
 
+struct media_v4l2_ctrl_to_subdev {
+	__u32 ctrl_id;
+	struct media_entity *entity;
+};
+
 #define media_dbg(media, ...) \
 	(media)->debug_handler((media)->debug_priv, __VA_ARGS__)
 
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 77ac182..e358242 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -420,4 +420,20 @@ int media_parse_setup_link(struct media_device *media,
  */
 int media_parse_setup_links(struct media_device *media, const char *p);
 
+/**
+ * @brief Find target sub-device for the control
+ * @param media - media device.
+ * @param cid - v4l2 control identifier
+ *
+ * Check if there was a target sub-device defined
+ * for the control through a ctrl-to-subdev-conf config
+ * directive.
+ *
+ * @return associated entity if defined, or NULL when no
+ *	   config entry for the control was found
+ */
+struct media_entity *media_config_get_entity_by_cid(
+	struct media_device *media,
+	int cid);
+
 #endif
diff --git a/utils/media-ctl/v4l2subdev.h b/utils/media-ctl/v4l2subdev.h
index 1cb53ff..3bc0412 100644
--- a/utils/media-ctl/v4l2subdev.h
+++ b/utils/media-ctl/v4l2subdev.h
@@ -255,4 +255,19 @@ const char *v4l2_subdev_pixelcode_to_string(enum v4l2_mbus_pixelcode code);
  */
 enum v4l2_mbus_pixelcode v4l2_subdev_string_to_pixelcode(const char *string,
 							 unsigned int length);
+
+/**
+ * @brief Validate v4l2 control for a sub-device
+ * @param media - media device.
+ * @param entity - subdev-device media entity.
+ * @param ctrl_id - v4l2 control identifier
+ *
+ * Verify if the entity supports v4l2-control with ctrl_id.
+ *
+ * @return 1 if the control is supported, 0 otherwise.
+ */
+int v4l2_subdev_validate_v4l2_ctrl(struct media_device *media,
+	struct media_entity *entity,
+	__u32 ctrl_id);
+
 #endif
-- 
1.7.9.5

