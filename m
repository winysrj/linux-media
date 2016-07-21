Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:4931 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbcGULPk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 07:15:40 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com
Subject: [PATCH v3 3/5] media: Refactor copying IOCTL arguments from and to user space
Date: Thu, 21 Jul 2016 14:14:42 +0300
Message-Id: <1469099686-10938-4-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1469099686-10938-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1469099686-10938-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Refactor copying the IOCTL argument structs from the user space and back,
in order to reduce code copied around and make the implementation more
robust.

As a result, the copying is done while not holding the graph mutex.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 190 ++++++++++++++++++++-----------------------
 1 file changed, 90 insertions(+), 100 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6fd9b77..87d17a0 100644
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
@@ -400,35 +363,41 @@ static long __media_device_get_topology(struct media_device *mdev,
 	return ret;
 }
 
-static long media_device_get_topology(struct media_device *mdev,
-				      struct media_v2_topology __user *utopo)
+static long copy_arg_from_user(void *karg, void __user *uarg, unsigned int cmd)
 {
-	struct media_v2_topology ktopo;
-	int ret;
-
-	if (copy_from_user(&ktopo, utopo, sizeof(ktopo)))
+	/* All media IOCTLs are _IOWR() */
+	if (copy_from_user(karg, uarg, _IOC_SIZE(cmd)))
 		return -EFAULT;
 
-	ret = __media_device_get_topology(mdev, &ktopo);
-	if (ret < 0)
-		return ret;
+	return 0;
+}
 
-	if (copy_to_user(utopo, &ktopo, sizeof(*utopo)))
+static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
+{
+	/* All media IOCTLs are _IOWR() */
+	if (copy_to_user(uarg, karg, _IOC_SIZE(cmd)))
 		return -EFAULT;
 
 	return 0;
 }
 
-#define MEDIA_IOC(__cmd, func)						\
-	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
-		.cmd = MEDIA_IOC_##__cmd,				\
-		.fn = (long (*)(struct media_device *, void __user *))func,    \
+#define MEDIA_IOC_ARG(__cmd, func, from_user, to_user)	\
+	[_IOC_NR(MEDIA_IOC_##__cmd)] = {		\
+		.cmd = MEDIA_IOC_##__cmd,		\
+		.fn = (long (*)(struct media_device *, void *))func,	\
+		.arg_from_user = from_user,		\
+		.arg_to_user = to_user,			\
 	}
 
+#define MEDIA_IOC(__cmd, func)						\
+	MEDIA_IOC_ARG(__cmd, func, copy_arg_from_user, copy_arg_to_user)
+
 /* the table is indexed by _IOC_NR(cmd) */
 struct media_ioctl_info {
 	unsigned int cmd;
-	long (*fn)(struct media_device *dev, void __user *arg);
+	long (*fn)(struct media_device *dev, void *arg);
+	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
+	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
 };
 
 static inline long is_valid_ioctl(const struct media_ioctl_info *info,
@@ -445,6 +414,7 @@ static long __media_device_ioctl(
 	struct media_devnode *devnode = media_devnode_data(filp);
 	struct media_device *dev = devnode->media_dev;
 	const struct media_ioctl_info *info;
+	char __karg[256], *karg = __karg;
 	long ret;
 
 	ret = is_valid_ioctl(info_array, info_array_len, cmd);
@@ -453,10 +423,29 @@ static long __media_device_ioctl(
 
 	info = &info_array[_IOC_NR(cmd)];
 
+	if (_IOC_SIZE(info->cmd) > sizeof(__karg)) {
+		karg = kmalloc(_IOC_SIZE(info->cmd), GFP_KERNEL);
+		if (!karg)
+			return -ENOMEM;
+	}
+
+	if (info->arg_from_user) {
+		ret = info->arg_from_user(karg, arg, cmd);
+		if (ret)
+			goto out_free;
+	}
+
 	mutex_lock(&dev->graph_mutex);
-	ret = info->fn(dev, arg);
+	ret = info->fn(dev, karg);
 	mutex_unlock(&dev->graph_mutex);
 
+	if (!ret && info->arg_to_user)
+		ret = info->arg_to_user(arg, karg, cmd);
+
+out_free:
+	if (karg != __karg)
+		kfree(karg);
+
 	return ret;
 }
 
@@ -485,23 +474,24 @@ struct media_links_enum32 {
 	__u32 reserved[4];
 };
 
-static long media_device_enum_links32(struct media_device *mdev,
-				      struct media_links_enum32 __user *ulinks)
+static long from_user_enum_links32(void *karg, void __user *uarg,
+				   unsigned int cmd)
 {
-	struct media_links_enum links;
+	struct media_links_enum *links = karg;
+	struct media_links_enum32 __user *ulinks = uarg;
 	compat_uptr_t pads_ptr, links_ptr;
 
-	memset(&links, 0, sizeof(links));
+	memset(links, 0, sizeof(*links));
 
-	if (get_user(links.entity, &ulinks->entity)
+	if (get_user(links->entity, &ulinks->entity)
 	    || get_user(pads_ptr, &ulinks->pads)
 	    || get_user(links_ptr, &ulinks->links))
 		return -EFAULT;
 
-	links.pads = compat_ptr(pads_ptr);
-	links.links = compat_ptr(links_ptr);
+	links->pads = compat_ptr(pads_ptr);
+	links->links = compat_ptr(links_ptr);
 
-	return __media_device_enum_links(mdev, &links);
+	return 0;
 }
 
 #define MEDIA_IOC_ENUM_LINKS32		_IOWR('|', 0x02, struct media_links_enum32)
@@ -509,7 +499,7 @@ static long media_device_enum_links32(struct media_device *mdev,
 static const struct media_ioctl_info compat_ioctl_info[] = {
 	MEDIA_IOC(DEVICE_INFO, media_device_get_info),
 	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities),
-	MEDIA_IOC(ENUM_LINKS32, media_device_enum_links32),
+	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, from_user_enum_links32, NULL),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link),
 	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology),
 };
-- 
2.7.4

