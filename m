Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:38818 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569AbcARQS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:18:28 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1500V0PPAQUN20@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:18:26 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 06/15] mediactl: Add media_device creation helpers
Date: Mon, 18 Jan 2016 17:17:31 +0100
Message-id: <1453133860-21571-7-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper functions that allow for easy instantiation of media_device
object basing on whether the media device contains video device with
given node name.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c |   75 +++++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediactl.h    |   30 +++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 0be1845..3a45ecc 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -734,6 +734,44 @@ struct media_device *media_device_new(const char *devnode)
 	return media;
 }
 
+struct media_device *media_device_new_by_entity_devname(char *entity_devname)
+{
+	struct media_device *media;
+	char media_devname[32];
+	struct media_entity *entity;
+	int i, ret;
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
+			media_dbg(media, "Failed to enumerate %s (%d)\n",
+				  media_devname, ret);
+			goto err_dev_enum;
+		}
+
+		/* Check if the media device contains entity with entity_devname */
+		entity = media_get_entity_by_devname(media, entity_devname,
+							strlen(entity_devname));
+		if (entity)
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
@@ -773,6 +811,43 @@ void media_device_unref(struct media_device *media)
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
 int media_device_add_entity(struct media_device *media,
 			    const struct media_entity_desc *desc,
 			    const char *devnode)
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 9db40a8..1d62191 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -76,6 +76,23 @@ struct media_device *media_device_new(const char *devnode);
 struct media_device *media_device_new_emulated(struct media_device_info *info);
 
 /**
+ * @brief Create a new media device if it comprises entity with given devname
+ * @param entity_devname - device node name of the entity to be matched.
+ *
+ * Query all media devices available in the system to find the one comprising
+ * the entity with given devname. If the media device is matched then its
+ * instance is created and initialized with enumerated entities and links.
+ * The returned device can be accessed.
+ *
+ * Media devices are reference-counted, see media_device_ref() and
+ * media_device_unref() for more information.
+ *
+ * @return A pointer to the new media device or NULL if video_devname cannot
+ * be matched or memory cannot be allocated.
+ */
+struct media_device *media_device_new_by_entity_devname(char *entity_devname);
+
+/**
  * @brief Take a reference to the device.
  * @param media - device instance.
  *
@@ -240,6 +257,19 @@ const char *media_entity_get_devname(struct media_entity *entity);
  */
 const char *media_entity_get_name(struct media_entity *entity);
 
+/**
+ * @brief Get the device node name by its file descriptor
+ * @param fd - file descriptor of a device.
+ * @param node_name - output device node name string.
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

