Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6481 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbcD2Irf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 04:47:35 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl
Subject: [PATCH 2/3] media: Refactor copying IOCTL arguments from and to user space
Date: Fri, 29 Apr 2016 11:43:19 +0300
Message-Id: <1461919400-2658-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1461919400-2658-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1461919400-2658-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor copying the IOCTL argument structs from the user space and back,
in order to reduce code copied around and make the implementation more
robust.

As a result, the copying is done while not holding the graph mutex.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 167 +++++++++++++++++--------------------------
 1 file changed, 66 insertions(+), 101 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6d3ee5c..4a66a2d5 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -59,27 +59,24 @@ static int media_device_close(struct file *filp)
 }
 
 static int media_device_get_info(struct media_device *dev,
-				 struct media_device_info __user *__info)
+				 struct media_device_info *info)
 {
-	struct media_device_info info;
-
-	memset(&info, 0, sizeof(info));
+	memset(info, 0, sizeof(*info));
 
 	if (dev->driver_name[0])
-		strlcpy(info.driver, dev->driver_name, sizeof(info.driver));
+		strlcpy(info->driver, dev->driver_name, sizeof(info->driver));
 	else
-		strlcpy(info.driver, dev->dev->driver->name, sizeof(info.driver));
+		strlcpy(info->driver, dev->dev->driver->name,
+			sizeof(info->driver));
 
-	strlcpy(info.model, dev->model, sizeof(info.model));
-	strlcpy(info.serial, dev->serial, sizeof(info.serial));
-	strlcpy(info.bus_info, dev->bus_info, sizeof(info.bus_info));
+	strlcpy(info->model, dev->model, sizeof(info->model));
+	strlcpy(info->serial, dev->serial, sizeof(info->serial));
+	strlcpy(info->bus_info, dev->bus_info, sizeof(info->bus_info));
 
-	info.media_version = MEDIA_API_VERSION;
-	info.hw_revision = dev->hw_revision;
-	info.driver_version = dev->driver_version;
+	info->media_version = MEDIA_API_VERSION;
+	info->hw_revision = dev->hw_revision;
+	info->driver_version = dev->driver_version;
 
-	if (copy_to_user(__info, &info, sizeof(*__info)))
-		return -EFAULT;
 	return 0;
 }
 
@@ -101,29 +98,25 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 }
 
 static long media_device_enum_entities(struct media_device *mdev,
-				       struct media_entity_desc __user *uent)
+				       struct media_entity_desc *entd)
 {
 	struct media_entity *ent;
-	struct media_entity_desc u_ent;
-
-	memset(&u_ent, 0, sizeof(u_ent));
-	if (copy_from_user(&u_ent.id, &uent->id, sizeof(u_ent.id)))
-		return -EFAULT;
-
-	ent = find_entity(mdev, u_ent.id);
 
+	ent = find_entity(mdev, entd->id);
 	if (ent == NULL)
 		return -EINVAL;
 
-	u_ent.id = media_entity_id(ent);
+	memset(entd, 0, sizeof(*entd));
+
+	entd->id = media_entity_id(ent);
 	if (ent->name)
-		strlcpy(u_ent.name, ent->name, sizeof(u_ent.name));
-	u_ent.type = ent->function;
-	u_ent.revision = 0;		/* Unused */
-	u_ent.flags = ent->flags;
-	u_ent.group_id = 0;		/* Unused */
-	u_ent.pads = ent->num_pads;
-	u_ent.links = ent->num_links - ent->num_backlinks;
+		strlcpy(entd->name, ent->name, sizeof(entd->name));
+	entd->type = ent->function;
+	entd->revision = 0;		/* Unused */
+	entd->flags = ent->flags;
+	entd->group_id = 0;		/* Unused */
+	entd->pads = ent->num_pads;
+	entd->links = ent->num_links - ent->num_backlinks;
 
 	/*
 	 * Workaround for a bug at media-ctl <= v1.10 that makes it to
@@ -139,14 +132,13 @@ static long media_device_enum_entities(struct media_device *mdev,
 	if (ent->function < MEDIA_ENT_F_OLD_BASE ||
 	    ent->function > MEDIA_ENT_T_DEVNODE_UNKNOWN) {
 		if (is_media_entity_v4l2_subdev(ent))
-			u_ent.type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
+			entd->type = MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN;
 		else if (ent->function != MEDIA_ENT_F_IO_V4L)
-			u_ent.type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
+			entd->type = MEDIA_ENT_T_DEVNODE_UNKNOWN;
 	}
 
-	memcpy(&u_ent.raw, &ent->info, sizeof(ent->info));
-	if (copy_to_user(uent, &u_ent, sizeof(u_ent)))
-		return -EFAULT;
+	memcpy(&entd->raw, &ent->info, sizeof(ent->info));
+
 	return 0;
 }
 
@@ -158,8 +150,8 @@ static void media_device_kpad_to_upad(const struct media_pad *kpad,
 	upad->flags = kpad->flags;
 }
 
-static long __media_device_enum_links(struct media_device *mdev,
-				      struct media_links_enum *links)
+static long media_device_enum_links(struct media_device *mdev,
+				    struct media_links_enum *links)
 {
 	struct media_entity *entity;
 
@@ -206,64 +198,35 @@ static long __media_device_enum_links(struct media_device *mdev,
 	return 0;
 }
 
-static long media_device_enum_links(struct media_device *mdev,
-				    struct media_links_enum __user *ulinks)
-{
-	struct media_links_enum links;
-	int rval;
-
-	if (copy_from_user(&links, ulinks, sizeof(links)))
-		return -EFAULT;
-
-	rval = __media_device_enum_links(mdev, &links);
-	if (rval < 0)
-		return rval;
-
-	if (copy_to_user(ulinks, &links, sizeof(*ulinks)))
-		return -EFAULT;
-
-	return 0;
-}
-
 static long media_device_setup_link(struct media_device *mdev,
-				    struct media_link_desc __user *_ulink)
+				    struct media_link_desc *linkd)
 {
 	struct media_link *link = NULL;
-	struct media_link_desc ulink;
 	struct media_entity *source;
 	struct media_entity *sink;
-	int ret;
-
-	if (copy_from_user(&ulink, _ulink, sizeof(ulink)))
-		return -EFAULT;
 
 	/* Find the source and sink entities and link.
 	 */
-	source = find_entity(mdev, ulink.source.entity);
-	sink = find_entity(mdev, ulink.sink.entity);
+	source = find_entity(mdev, linkd->source.entity);
+	sink = find_entity(mdev, linkd->sink.entity);
 
 	if (source == NULL || sink == NULL)
 		return -EINVAL;
 
-	if (ulink.source.index >= source->num_pads ||
-	    ulink.sink.index >= sink->num_pads)
+	if (linkd->source.index >= source->num_pads ||
+	    linkd->sink.index >= sink->num_pads)
 		return -EINVAL;
 
-	link = media_entity_find_link(&source->pads[ulink.source.index],
-				      &sink->pads[ulink.sink.index]);
+	link = media_entity_find_link(&source->pads[linkd->source.index],
+				      &sink->pads[linkd->sink.index]);
 	if (link == NULL)
 		return -EINVAL;
 
 	/* Setup the link on both entities. */
-	ret = __media_entity_setup_link(link, ulink.flags);
-
-	if (copy_to_user(_ulink, &ulink, sizeof(ulink)))
-		return -EFAULT;
-
-	return ret;
+	return __media_entity_setup_link(link, linkd->flags);
 }
 
-static long __media_device_get_topology(struct media_device *mdev,
+static long media_device_get_topology(struct media_device *mdev,
 				      struct media_v2_topology *topo)
 {
 	struct media_entity *entity;
@@ -400,30 +363,11 @@ static long __media_device_get_topology(struct media_device *mdev,
 	return ret;
 }
 
-static long media_device_get_topology(struct media_device *mdev,
-				      struct media_v2_topology __user *utopo)
-{
-	struct media_v2_topology ktopo;
-	int ret;
-
-	if (copy_from_user(&ktopo, utopo, sizeof(ktopo)))
-		return -EFAULT;
-
-	ret = __media_device_get_topology(mdev, &ktopo);
-	if (ret < 0)
-		return ret;
-
-	if (copy_to_user(utopo, &ktopo, sizeof(*utopo)))
-		return -EFAULT;
-
-	return 0;
-}
-
 #define MEDIA_IOC(__cmd) \
 	[_IOC_NR(MEDIA_IOC_##__cmd)] = { .cmd = MEDIA_IOC_##__cmd }
 
 /* the table is indexed by _IOC_NR(cmd) */
-static struct {
+static const struct {
 	unsigned int cmd;
 } media_ioctl_info[] = {
 	MEDIA_IOC(DEVICE_INFO),
@@ -433,42 +377,60 @@ static struct {
 	MEDIA_IOC(G_TOPOLOGY),
 };
 
+static unsigned int media_ioctl_max_arg_size(void) {
+	static unsigned int max_size;
+	unsigned int i;
+
+	if (max_size)
+		return max_size;
+
+	for (i = 0; i < ARRAY_SIZE(media_ioctl_info); i++)
+		max_size = max(_IOC_SIZE(media_ioctl_info[i].cmd), max_size);
+
+	return max_size;
+}
+
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
 			       unsigned long arg)
 {
 	struct media_devnode *devnode = media_devnode_data(filp);
 	struct media_device *dev = to_media_device(devnode);
+	char karg[media_ioctl_max_arg_size()];
 	long ret;
 
 	if (_IOC_NR(cmd) >= ARRAY_SIZE(media_ioctl_info)
 	    || media_ioctl_info[_IOC_NR(cmd)].cmd != cmd)
 		return -ENOIOCTLCMD;
 
+	/* All media IOCTLs are _IOWR() */
+	if (copy_from_user(karg, (void *)arg, _IOC_SIZE(cmd)))
+		return -EFAULT;
+
 	mutex_lock(&dev->graph_mutex);
 	switch (cmd) {
 	case MEDIA_IOC_DEVICE_INFO:
 		ret = media_device_get_info(dev,
-				(struct media_device_info __user *)arg);
+				(struct media_device_info *)karg);
 		break;
 
 	case MEDIA_IOC_ENUM_ENTITIES:
 		ret = media_device_enum_entities(dev,
-				(struct media_entity_desc __user *)arg);
+				(struct media_entity_desc *)karg);
 		break;
 
 	case MEDIA_IOC_ENUM_LINKS:
 		ret = media_device_enum_links(dev,
-				(struct media_links_enum __user *)arg);
+				(struct media_links_enum *)karg);
 		break;
 
 	case MEDIA_IOC_SETUP_LINK:
 		ret = media_device_setup_link(dev,
-				(struct media_link_desc __user *)arg);
+				(struct media_link_desc *)karg);
 		break;
 
 	case MEDIA_IOC_G_TOPOLOGY:
 		ret = media_device_get_topology(dev,
-				(struct media_v2_topology __user *)arg);
+				(struct media_v2_topology *)karg);
 		break;
 
 	default:
@@ -476,6 +438,9 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	}
 	mutex_unlock(&dev->graph_mutex);
 
+	if (!ret && copy_to_user((void *)arg, karg, _IOC_SIZE(cmd)))
+		return -EFAULT;
+
 	return ret;
 }
 
@@ -504,7 +469,7 @@ static long media_device_enum_links32(struct media_device *mdev,
 	links.pads = compat_ptr(pads_ptr);
 	links.links = compat_ptr(links_ptr);
 
-	return __media_device_enum_links(mdev, &links);
+	return media_device_enum_links(mdev, &links);
 }
 
 #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
-- 
1.9.1

