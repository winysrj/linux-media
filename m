Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:40314 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaKFKMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Nov 2014 05:12:10 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEM00GBE4C8R8C0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 06 Nov 2014 19:12:08 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	sakari.ailus@linux.intel.com, kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils RFC v3 05/11] mediactl: Add media_device creation helpers
Date: Thu, 06 Nov 2014 11:11:36 +0100
Message-id: <1415268702-23685-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
References: <1415268702-23685-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper functions that allow for easy instantiation
of media_device object basing on whether the media device
contains video device with given node name.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c |   75 +++++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediactl.h    |   29 ++++++++++++++++
 2 files changed, 104 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 5b43aff..10f0491 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -855,6 +855,43 @@ struct media_device *media_device_new(const char *devnode)
 	return media;
 }
 
+struct media_device *media_device_new_by_entity_devname(char *entity_devname)
+{
+	struct media_device *media;
+	char media_devname[32];
+	int i, ret;
+
+	if (entity_devname == NULL)
+		return NULL;
+
+	/* query all available media devices */
+	for (i = 0;; ++i) {
+		sprintf(media_devname, "/dev/media%d", i);
+
+		media = media_device_new(media_devname);
+		if (media == NULL)
+			return NULL;
+
+		ret = media_device_enumerate(media);
+		if (ret < 0) {
+			media_dbg(media, "Failed to enumerate %s (%d)\n", media_devname, ret);
+			goto err_dev_enum;
+		}
+
+		/* Check if the media device contains entity with entity_devname */
+		if (media_get_entity_by_devname(media, entity_devname, strlen(entity_devname)))
+			return media;
+
+		if (media)
+			media_device_unref(media);
+	}
+
+err_dev_enum:
+	if (media)
+		media_device_unref(media);
+	return NULL;
+}
+
 struct media_device *media_device_new_emulated(struct media_device_info *info)
 {
 	struct media_device *media;
@@ -897,6 +934,44 @@ void media_device_unref(struct media_device *media)
 	free(media);
 }
 
+int media_get_devname_by_fd(int fd, char *node_name)
+{
+	struct udev *udev;
+	struct media_entity tmp_entity;
+	struct stat stat;
+	int ret;
+
+	if (node_name == NULL)
+		return -EINVAL;
+
+	ret = fstat(fd, &stat);
+	if (ret < 0)
+		return -EINVAL;
+
+	tmp_entity.info.v4l.major = MAJOR(stat.st_rdev);
+	tmp_entity.info.v4l.minor = MINOR(stat.st_rdev);
+
+	ret = media_udev_open(&udev);
+	if (ret < 0)
+		printf("Can't get udev context\n");
+
+	/* Try to get the device name via udev */
+	ret = media_get_devname_udev(udev, &tmp_entity);
+	if (!ret)
+		goto out;
+
+	ret = media_get_devname_sysfs(&tmp_entity);
+	if (ret < 0)
+		goto err_get_devname;
+
+out:
+	strcpy(node_name, tmp_entity.devname);
+err_get_devname:
+	media_udev_close(udev);
+	return ret;
+}
+
+
 int media_device_add_entity(struct media_device *media,
 			    const struct media_entity_desc *desc,
 			    const char *devnode)
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 8341c50..0dc7f95 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -77,6 +77,23 @@ struct media_device *media_device_new(const char *devnode);
 struct media_device *media_device_new_emulated(struct media_device_info *info);
 
 /**
+ * @brief Create a new media device if it comprises entity with entity_devname
+ * @param entity_devname - device node name of the entity to be matched
+ *
+ * Query all media devices available in the system to find the one comprising
+ * the entity with device node name equal to entity_devname. If the media
+ * device is matched then its instance is created and initialized with
+ * enumerated entities and links. The returned device can be accessed.
+ *
+ * Media devices are reference-counted, see media_device_ref() and
+ * media_device_unref() for more information.
+ *
+ * @return A pointer to the new media device or NULL if video_devname cannot
+ * be matched or memory cannot be allocated.
+ */
+struct media_device *media_device_new_by_entity_devname(char *video_devname);
+
+/**
  * @brief Take a reference to the device.
  * @param media - device instance.
  *
@@ -242,6 +259,18 @@ const char *media_entity_get_devname(struct media_entity *entity);
 const char *media_entity_get_name(struct media_entity *entity);
 
 /**
+ * @brief Get the device node name by its file descriptor
+ * @param fd - file descriptor of a device
+ * @param node_name - output device node name string
+ *
+ * This function returns the full path and name to the device node corresponding
+ * to the given file descriptor.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_get_devname_by_fd(int fd, char *node_name);
+
+/**
  * @brief Get the type of an entity.
  * @param entity - the entity.
  *
-- 
1.7.9.5

