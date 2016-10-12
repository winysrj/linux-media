Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35138 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933274AbcJLOrL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:47:11 -0400
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OEX01FZBV7FY8A0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 12 Oct 2016 23:35:42 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, hverkuil@xs4all.nl,
        mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v4l-utils v7 4/7] mediactl: Add media_device creation helpers
Date: Wed, 12 Oct 2016 16:35:19 +0200
Message-id: <1476282922-11544-5-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helper functions that allow for easy instantiation of media_device
object basing on whether the media device contains v4l2 subdev with
given file descriptor.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c | 131 +++++++++++++++++++++++++++++++++++++++++-
 utils/media-ctl/mediactl.h    |  27 +++++++++
 2 files changed, 156 insertions(+), 2 deletions(-)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index 155b65f..d347a40 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -27,6 +27,7 @@
 #include <sys/sysmacros.h>
 
 #include <ctype.h>
+#include <dirent.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <stdbool.h>
@@ -440,8 +441,9 @@ static int media_get_devname_udev(struct udev *udev,
 		return -EINVAL;
 
 	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
-	media_dbg(entity->media, "looking up device: %u:%u\n",
-		  major(devnum), minor(devnum));
+	if (entity->media)
+		media_dbg(entity->media, "looking up device: %u:%u\n",
+			  major(devnum), minor(devnum));
 	device = udev_device_new_from_devnum(udev, 'c', devnum);
 	if (device) {
 		p = udev_device_get_devnode(device);
@@ -523,6 +525,7 @@ static int media_get_devname_sysfs(struct media_entity *entity)
 	return 0;
 }
 
+
 static int media_enum_entities(struct media_device *media)
 {
 	struct media_entity *entity;
@@ -707,6 +710,92 @@ struct media_device *media_device_new(const char *devnode)
 	return media;
 }
 
+struct media_device *media_device_new_by_subdev_fd(int fd, struct media_entity **fd_entity)
+{
+	char video_devname[32], device_dir_path[256], media_dev_path[256], media_major_minor[10];
+	struct media_device *media = NULL;
+	struct dirent *entry;
+	struct media_entity tmp_entity;
+	DIR *device_dir;
+	struct udev *udev;
+	char *p;
+	int ret, i;
+
+	if (fd_entity == NULL)
+		return NULL;
+
+	ret = media_get_devname_by_fd(fd, video_devname);
+	if (ret < 0)
+		return NULL;
+
+	p = strrchr(video_devname, '/');
+	if (p == NULL)
+		return NULL;
+
+	ret = media_udev_open(&udev);
+	if (ret < 0)
+		return NULL;
+
+	sprintf(device_dir_path, "/sys/class/video4linux/%s/device/", p + 1);
+
+	device_dir = opendir(device_dir_path);
+	if (device_dir == NULL)
+		return NULL;
+
+	while ((entry = readdir(device_dir))) {
+		if (strncmp(entry->d_name, "media", 4))
+			continue;
+
+		sprintf(media_dev_path, "%s%s/dev", device_dir_path, entry->d_name);
+
+		fd = open(media_dev_path, O_RDONLY);
+		if (fd < 0)
+			continue;
+
+		ret = read(fd, media_major_minor, sizeof(media_major_minor));
+		if (ret < 0)
+			continue;
+
+		sscanf(media_major_minor, "%d:%d", &tmp_entity.info.dev.major, &tmp_entity.info.dev.minor);
+
+		/* Try to get the device name via udev */
+		if (media_get_devname_udev(udev, &tmp_entity)) {
+			/* Fall back to get the device name via sysfs */
+			if (media_get_devname_sysfs(&tmp_entity))
+				continue;
+		}
+
+		media = media_device_new(tmp_entity.devname);
+		if (media == NULL)
+			continue;
+
+		ret = media_device_enumerate(media);
+		if (ret < 0) {
+			media_dbg(media, "Failed to enumerate %s (%d)\n",
+				  tmp_entity.devname, ret);
+			media_device_unref(media);
+			media = NULL;
+			continue;
+		}
+
+		/* Get the entity associated with given fd */
+		for (i = 0; i < media->entities_count; i++) {
+			struct media_entity *entity = &media->entities[i];
+
+			if (!strcmp(entity->devname, video_devname)) {
+				*fd_entity = &media->entities[i];
+				break;
+			}
+		}
+
+		break;
+	}
+
+	media_udev_close(udev);
+
+	return media;
+}
+
 struct media_device *media_device_new_emulated(struct media_device_info *info)
 {
 	struct media_device *media;
@@ -748,6 +837,44 @@ void media_device_unref(struct media_device *media)
 	free(media);
 }
 
+int media_get_devname_by_fd(int fd, char *node_name)
+{
+	struct udev *udev;
+	struct media_entity tmp_entity;
+	struct stat stat;
+	int ret, ret_udev;
+
+	if (node_name == NULL)
+		return -EINVAL;
+
+	ret = fstat(fd, &stat);
+	if (ret < 0)
+		return -errno;
+
+	tmp_entity.info.v4l.major = MAJOR(stat.st_rdev);
+	tmp_entity.info.v4l.minor = MINOR(stat.st_rdev);
+
+	ret_udev = media_udev_open(&udev);
+	if (ret_udev < 0)
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
+	strncpy(node_name, tmp_entity.devname, sizeof(tmp_entity.devname));
+err_get_devname:
+	if (!ret_udev)
+		media_udev_close(udev);
+	return ret;
+}
+
 int media_device_add_entity(struct media_device *media,
 			    const struct media_entity_desc *desc,
 			    const char *devnode)
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index b1f33cd..580a25a 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -76,6 +76,21 @@ struct media_device *media_device_new(const char *devnode);
 struct media_device *media_device_new_emulated(struct media_device_info *info);
 
 /**
+ * @brief Create a new media device contatning entity associated with v4l2 subdev fd.
+ * @param fd - file descriptor of a v4l2 subdev.
+ * @param fd_entity - media entity associated with the v4l2 subdev.
+ *
+ * Create a representation of the media device referenced by the v4l2-subdev.
+ * The media device instance is initialized with enumerated entities and links.
+ *
+ * Media devices are reference-counted, see media_device_ref() and
+ * media_device_unref() for more information.
+ *
+ * @return A pointer to the new media device or NULL if error occurred.
+ */
+struct media_device *media_device_new_by_subdev_fd(int fd, struct media_entity **fd_entity);
+
+/**
  * @brief Take a reference to the device.
  * @param media - device instance.
  *
@@ -231,6 +246,18 @@ const struct media_link *media_entity_get_link(struct media_entity *entity,
 const char *media_entity_get_devname(struct media_entity *entity);
 
 /**
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
1.9.1

