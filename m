Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:42638 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727198AbeHGMme (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Aug 2018 08:42:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 2/3] media: add support for properties
Date: Tue,  7 Aug 2018 12:28:46 +0200
Message-Id: <20180807102847.13200-3-hverkuil@xs4all.nl>
In-Reply-To: <20180807102847.13200-1-hverkuil@xs4all.nl>
References: <20180807102847.13200-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Initially support u64/s64 and string properties.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 162 ++++++++++++++++++++++++++++--
 drivers/media/media-entity.c |  79 ++++++++++++++-
 include/media/media-device.h |   6 ++
 include/media/media-entity.h | 186 +++++++++++++++++++++++++++++++++++
 4 files changed, 419 insertions(+), 14 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index fcdf3d5dc4b6..cdf80cfcf87e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -234,6 +234,63 @@ static long media_device_setup_link(struct media_device *mdev, void *arg)
 	return __media_entity_setup_link(link, linkd->flags);
 }
 
+static long copy_props_to_user(struct media_v2_topology *topo,
+			       int *prop_idx,
+			       unsigned int *payload_size,
+			       unsigned int *payload_offset,
+			       struct list_head *list,
+			       struct media_v2_prop __user *uprop_start)
+{
+	struct media_v2_prop __user *uprop;
+	struct media_v2_prop kprop;
+	struct media_prop *prop;
+	long ret = 0;
+
+	uprop = uprop_start + *prop_idx;
+
+	list_for_each_entry(prop, list, list) {
+		(*prop_idx)++;
+
+		if (ret)
+			continue;
+
+		if (*prop_idx > topo->num_props) {
+			ret = -ENOSPC;
+			continue;
+		}
+		memset(&kprop, 0, sizeof(kprop));
+
+		/* Copy prop fields to userspace struct */
+		kprop.id = prop->graph_obj.id;
+		kprop.owner_id = prop->owner->id;
+		kprop.type = prop->type;
+		kprop.flags = 0;
+		kprop.payload_size = prop->payload_size;
+		if (kprop.payload_size)
+			kprop.payload_offset = *payload_offset -
+				(*prop_idx - 1) * sizeof(*uprop);
+		else
+			kprop.payload_offset = 0;
+		memcpy(kprop.name, prop->name, sizeof(kprop.name));
+		kprop.uval = prop->uval;
+
+		if (copy_to_user(uprop, &kprop, sizeof(kprop))) {
+			ret = -EFAULT;
+			continue;
+		}
+		uprop++;
+		*payload_size += prop->payload_size;
+		if (topo->props_payload_size < *payload_size)
+			ret = -ENOSPC;
+		else if (copy_to_user((u8 __user *)uprop_start + *payload_offset,
+				      prop->string, prop->payload_size))
+			ret = -EFAULT;
+		*payload_offset += prop->payload_size;
+	}
+
+	return ret;
+}
+
 static long media_device_get_topology(struct media_device *mdev, void *arg)
 {
 	struct media_v2_topology *topo = arg;
@@ -241,10 +298,14 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
 	struct media_interface *intf;
 	struct media_pad *pad;
 	struct media_link *link;
+	struct media_prop *prop;
 	struct media_v2_entity kentity, __user *uentity;
 	struct media_v2_interface kintf, __user *uintf;
 	struct media_v2_pad kpad, __user *upad;
 	struct media_v2_link klink, __user *ulink;
+	struct media_v2_prop __user *uprop;
+	unsigned int payload_size = 0;
+	unsigned int payload_offset = 0;
 	unsigned int i;
 	int ret = 0;
 
@@ -374,6 +435,36 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
 	topo->num_links = i;
 	topo->reserved4 = 0;
 
+	/* Get properties and number of properties */
+	uprop = media_get_uptr(topo->ptr_props);
+	if (!uprop) {
+		topo->num_props = 0;
+		topo->props_payload_size = 0;
+		media_device_for_each_prop(prop, mdev) {
+			topo->props_payload_size += prop->payload_size;
+			topo->num_props++;
+		}
+		return ret;
+	}
+
+	payload_offset = topo->num_props * sizeof(*uprop);
+	i = 0;
+	media_device_for_each_entity(entity, mdev) {
+		long res = copy_props_to_user(topo, &i, &payload_size,
+					      &payload_offset,
+					      &entity->props, uprop);
+		if (!ret)
+			ret = res;
+	}
+	media_device_for_each_pad(pad, mdev) {
+		long res = copy_props_to_user(topo, &i, &payload_size,
+					      &payload_offset,
+					      &pad->props, uprop);
+		if (!ret)
+			ret = res;
+	}
+	topo->num_props = i;
+	topo->props_payload_size = payload_size;
 	return ret;
 }
 
@@ -398,9 +489,10 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
 /* Do acquire the graph mutex */
 #define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
 
-#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
+#define MEDIA_IOC_ARG(__cmd, alts, func, fl, from_user, to_user)	\
 	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
 		.cmd = MEDIA_IOC_##__cmd,				\
+		.alternatives = (alts),					\
 		.fn = (long (*)(struct media_device *, void *))func,	\
 		.flags = fl,						\
 		.arg_from_user = from_user,				\
@@ -408,23 +500,32 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
 	}
 
 #define MEDIA_IOC(__cmd, func, fl)					\
-	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
+	MEDIA_IOC_ARG(__cmd, NULL, func, fl, copy_arg_from_user, copy_arg_to_user)
+#define MEDIA_IOC_ALTS(__cmd, alts, func, fl)				\
+	MEDIA_IOC_ARG(__cmd, alts, func, fl, copy_arg_from_user, copy_arg_to_user)
 
 /* the table is indexed by _IOC_NR(cmd) */
 struct media_ioctl_info {
 	unsigned int cmd;
+	const unsigned int *alternatives;
 	unsigned short flags;
 	long (*fn)(struct media_device *dev, void *arg);
 	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
 	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
 };
 
+static const unsigned int topo_alts[] = {
+	/* Old MEDIA_IOC_G_TOPOLOGY without props support */
+	MEDIA_IOC_G_TOPOLOGY_OLD,
+	0
+};
+
 static const struct media_ioctl_info ioctl_info[] = {
 	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
 	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
-	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
+	MEDIA_IOC_ALTS(G_TOPOLOGY, topo_alts, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
 };
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
@@ -437,17 +538,29 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	char __karg[256], *karg = __karg;
 	long ret;
 
-	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info)
-	    || ioctl_info[_IOC_NR(cmd)].cmd != cmd)
+	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info))
 		return -ENOIOCTLCMD;
 
 	info = &ioctl_info[_IOC_NR(cmd)];
 
+	if (info->cmd != cmd) {
+		const unsigned int *p;
+
+		for (p = info->alternatives; p && *p; p++)
+			if (*p == cmd)
+				break;
+		if (!p || !*p)
+			return -ENOIOCTLCMD;
+	}
+
 	if (_IOC_SIZE(info->cmd) > sizeof(__karg)) {
 		karg = kmalloc(_IOC_SIZE(info->cmd), GFP_KERNEL);
 		if (!karg)
 			return -ENOMEM;
 	}
+	if (_IOC_SIZE(info->cmd) > _IOC_SIZE(cmd))
+		memset(karg + _IOC_SIZE(cmd), 0,
+		       _IOC_SIZE(info->cmd) - _IOC_SIZE(cmd));
 
 	if (info->arg_from_user) {
 		ret = info->arg_from_user(karg, arg, cmd);
@@ -569,6 +682,7 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
 	struct media_entity_notify *notify, *next;
+	struct media_prop *prop;
 	unsigned int i;
 	int ret;
 
@@ -581,9 +695,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	/* Warn if we apparently re-register an entity */
 	WARN_ON(entity->graph_obj.mdev != NULL);
 	entity->graph_obj.mdev = mdev;
-	INIT_LIST_HEAD(&entity->links);
-	entity->num_links = 0;
-	entity->num_backlinks = 0;
+	if (!entity->inited)
+		media_entity_init(entity);
 
 	if (!ida_pre_get(&mdev->entity_internal_idx, GFP_KERNEL))
 		return -ENOMEM;
@@ -603,11 +716,22 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	/* Initialize media_gobj embedded at the entity */
 	media_gobj_create(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 
+	/* Initialize objects at the props */
+	list_for_each_entry(prop, &entity->props, list)
+		media_gobj_create(mdev, MEDIA_GRAPH_PROP,
+			       &prop->graph_obj);
+
 	/* Initialize objects at the pads */
-	for (i = 0; i < entity->num_pads; i++)
+	for (i = 0; i < entity->num_pads; i++) {
 		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
 			       &entity->pads[i].graph_obj);
 
+		/* Initialize objects at the pad props */
+		list_for_each_entry(prop, &entity->pads[i].props, list)
+			media_gobj_create(mdev, MEDIA_GRAPH_PROP,
+					  &prop->graph_obj);
+	}
+
 	/* invoke entity_notify callbacks */
 	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list)
 		notify->notify(entity, notify->notify_data);
@@ -635,6 +759,18 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity);
 
+static void media_device_free_props(struct list_head *list)
+{
+	while (!list_empty(list)) {
+		struct media_prop *prop;
+
+		prop = list_first_entry(list, struct media_prop, list);
+		list_del(&prop->list);
+		media_gobj_destroy(&prop->graph_obj);
+		kfree(prop);
+	}
+}
+
 static void __media_device_unregister_entity(struct media_entity *entity)
 {
 	struct media_device *mdev = entity->graph_obj.mdev;
@@ -656,8 +792,13 @@ static void __media_device_unregister_entity(struct media_entity *entity)
 	__media_entity_remove_links(entity);
 
 	/* Remove all pads that belong to this entity */
-	for (i = 0; i < entity->num_pads; i++)
+	for (i = 0; i < entity->num_pads; i++) {
+		media_device_free_props(&entity->pads[i].props);
 		media_gobj_destroy(&entity->pads[i].graph_obj);
+	}
+
+	/* Remove all props that belong to this entity */
+	media_device_free_props(&entity->props);
 
 	/* Remove the entity */
 	media_gobj_destroy(&entity->graph_obj);
@@ -696,6 +837,7 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->interfaces);
 	INIT_LIST_HEAD(&mdev->pads);
 	INIT_LIST_HEAD(&mdev->links);
+	INIT_LIST_HEAD(&mdev->props);
 	INIT_LIST_HEAD(&mdev->entity_notify);
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index 3498551e618e..fec681a4dc5f 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -34,6 +34,8 @@ static inline const char *gobj_type(enum media_gobj_type type)
 		return "link";
 	case MEDIA_GRAPH_INTF_DEVNODE:
 		return "intf-devnode";
+	case MEDIA_GRAPH_PROP:
+		return "prop";
 	default:
 		return "unknown";
 	}
@@ -106,7 +108,7 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 	switch (media_type(gobj)) {
 	case MEDIA_GRAPH_ENTITY:
 		dev_dbg(gobj->mdev->dev,
-			"%s id %u: entity '%s'\n",
+			"%s id 0x%08x: entity '%s'\n",
 			event_name, media_id(gobj),
 			gobj_to_entity(gobj)->name);
 		break;
@@ -115,7 +117,7 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_link *link = gobj_to_link(gobj);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s id %u: %s link id %u ==> id %u\n",
+			"%s id 0x%08x: %s link id 0x%08x ==> id 0x%08x\n",
 			event_name, media_id(gobj),
 			media_type(link->gobj0) == MEDIA_GRAPH_PAD ?
 				"data" : "interface",
@@ -128,7 +130,7 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_pad *pad = gobj_to_pad(gobj);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s id %u: %s%spad '%s':%d\n",
+			"%s id 0x%08x: %s%spad '%s':%d\n",
 			event_name, media_id(gobj),
 			pad->flags & MEDIA_PAD_FL_SINK   ? "sink " : "",
 			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",
@@ -141,12 +143,22 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
 		struct media_intf_devnode *devnode = intf_to_devnode(intf);
 
 		dev_dbg(gobj->mdev->dev,
-			"%s id %u: intf_devnode %s - major: %d, minor: %d\n",
+			"%s id 0x%08x: intf_devnode %s - major: %d, minor: %d\n",
 			event_name, media_id(gobj),
 			intf_type(intf),
 			devnode->major, devnode->minor);
 		break;
 	}
+	case MEDIA_GRAPH_PROP:
+	{
+		struct media_prop *prop = gobj_to_prop(gobj);
+
+		dev_dbg(gobj->mdev->dev,
+			"%s id 0x%08x: prop '%s':0x%08x\n",
+			event_name, media_id(gobj),
+			prop->name, media_id(prop->owner));
+		break;
+	}
 	}
 #endif
 }
@@ -175,6 +187,9 @@ void media_gobj_create(struct media_device *mdev,
 	case MEDIA_GRAPH_INTF_DEVNODE:
 		list_add_tail(&gobj->list, &mdev->interfaces);
 		break;
+	case MEDIA_GRAPH_PROP:
+		list_add_tail(&gobj->list, &mdev->props);
+		break;
 	}
 
 	mdev->topology_version++;
@@ -212,6 +227,8 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 	if (num_pads >= MEDIA_ENTITY_MAX_PADS)
 		return -E2BIG;
 
+	if (!entity->inited)
+		media_entity_init(entity);
 	entity->num_pads = num_pads;
 	entity->pads = pads;
 
@@ -221,6 +238,7 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 	for (i = 0; i < num_pads; i++) {
 		pads[i].entity = entity;
 		pads[i].index = i;
+		INIT_LIST_HEAD(&pads[i].props);
 		if (mdev)
 			media_gobj_create(mdev, MEDIA_GRAPH_PAD,
 					&entity->pads[i].graph_obj);
@@ -233,6 +251,59 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 }
 EXPORT_SYMBOL_GPL(media_entity_pads_init);
 
+static struct media_prop *media_create_prop(struct media_gobj *owner, u32 type,
+		const char *name, u64 val, const void *ptr, u32 payload_size)
+{
+	struct media_prop *prop = kzalloc(sizeof(*prop) + payload_size,
+					  GFP_KERNEL);
+
+	if (!prop)
+		return NULL;
+	prop->type = type;
+	strlcpy(prop->name, name, sizeof(prop->name));
+	if (owner->mdev)
+		media_gobj_create(owner->mdev, MEDIA_GRAPH_PROP,
+				  &prop->graph_obj);
+	prop->owner = owner;
+	if (payload_size) {
+		prop->string = (char *)&prop[1];
+		memcpy(prop->string, ptr, payload_size);
+		prop->payload_size = payload_size;
+	} else {
+		prop->uval = val;
+	}
+	return prop;
+}
+
+int media_entity_add_prop(struct media_entity *ent, u32 type,
+		const char *name, u64 val, const void *ptr, u32 payload_size)
+{
+	struct media_prop *prop;
+
+	if (!ent->inited)
+		media_entity_init(ent);
+	prop = media_create_prop(&ent->graph_obj, type,
+				 name, val, ptr, payload_size);
+	if (!prop)
+		return -ENOMEM;
+	list_add_tail(&prop->list, &ent->props);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_entity_add_prop);
+
+int media_pad_add_prop(struct media_pad *pad, u32 type,
+		const char *name, u64 val, const void *ptr, u32 payload_size)
+{
+	struct media_prop *prop = media_create_prop(&pad->graph_obj, type,
+						name, val, ptr, payload_size);
+
+	if (!prop)
+		return -ENOMEM;
+	list_add_tail(&prop->list, &pad->props);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_pad_add_prop);
+
 /* -----------------------------------------------------------------------------
  * Graph traversal
  */
diff --git a/include/media/media-device.h b/include/media/media-device.h
index bcc6ec434f1f..a30a931df00b 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -78,6 +78,7 @@ struct media_device_ops {
  * @interfaces:	List of registered interfaces
  * @pads:	List of registered pads
  * @links:	List of registered links
+ * @props:	List of registered properties
  * @entity_notify: List of registered entity_notify callbacks
  * @graph_mutex: Protects access to struct media_device data
  * @pm_count_walk: Graph walk for power state walk. Access serialised using
@@ -144,6 +145,7 @@ struct media_device {
 	struct list_head interfaces;
 	struct list_head pads;
 	struct list_head links;
+	struct list_head props;
 
 	/* notify callback list invoked when a new entity is registered */
 	struct list_head entity_notify;
@@ -382,6 +384,10 @@ void media_device_unregister_entity_notify(struct media_device *mdev,
 #define media_device_for_each_link(link, mdev)			\
 	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
 
+/* Iterate over all props. */
+#define media_device_for_each_prop(prop, mdev)			\
+	list_for_each_entry(prop, &(mdev)->props, graph_obj.list)
+
 /**
  * media_device_pci_init() - create and initialize a
  *	struct &media_device from a PCI device.
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 3aa3d58d1d58..8bb4457b8b15 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -36,12 +36,14 @@
  * @MEDIA_GRAPH_LINK:		Identify a media link
  * @MEDIA_GRAPH_INTF_DEVNODE:	Identify a media Kernel API interface via
  *				a device node
+ * @MEDIA_GRAPH_PROP:		Identify a media property
  */
 enum media_gobj_type {
 	MEDIA_GRAPH_ENTITY,
 	MEDIA_GRAPH_PAD,
 	MEDIA_GRAPH_LINK,
 	MEDIA_GRAPH_INTF_DEVNODE,
+	MEDIA_GRAPH_PROP,
 };
 
 #define MEDIA_BITS_PER_TYPE		8
@@ -164,12 +166,44 @@ struct media_link {
  * @flags:	Pad flags, as defined in
  *		:ref:`include/uapi/linux/media.h <media_header>`
  *		(seek for ``MEDIA_PAD_FL_*``)
+ * @num_props:	Number of pad properties
+ * @props:	The list pad properties
  */
 struct media_pad {
 	struct media_gobj graph_obj;	/* must be first field in struct */
 	struct media_entity *entity;
 	u16 index;
 	unsigned long flags;
+	u16 num_props;
+	struct list_head props;
+};
+
+/**
+ * struct media_prop - A media property graph object.
+ *
+ * @graph_obj:	Embedded structure containing the media object common data
+ * @list:	Linked list associated with the object that owns the link.
+ * @owner:	Graph object this property belongs to
+ * @index:	Property index for the owner property array, numbered from 0 to n
+ * @type:	Property type
+ * @payload_size: Property payload size (i.e. additional bytes beyond this struct)
+ * @name:	Property name
+ * @uval:	Property value (unsigned)
+ * @sval:	Property value (signed)
+ * @string:	Property string value
+ */
+struct media_prop {
+	struct media_gobj graph_obj;	/* must be first field in struct */
+	struct list_head list;
+	struct media_gobj *owner;
+	u32 type;
+	u32 payload_size;
+	char name[32];
+	union {
+		u64 uval;
+		s64 sval;
+		char *string;
+	};
 };
 
 /**
@@ -236,6 +270,7 @@ enum media_entity_type {
  * @flags:	Entity flags, as defined in
  *		:ref:`include/uapi/linux/media.h <media_header>`
  *		(seek for ``MEDIA_ENT_FL_*``)
+ * @inited:	This struct was initialized.
  * @num_pads:	Number of sink and source pads.
  * @num_links:	Total number of links, forward and back, enabled and disabled.
  * @num_backlinks: Number of backlinks
@@ -243,6 +278,7 @@ enum media_entity_type {
  *		re-used if entities are unregistered or registered again.
  * @pads:	Pads array with the size defined by @num_pads.
  * @links:	List of data links.
+ * @props:	List of entity properties.
  * @ops:	Entity operations.
  * @stream_count: Stream count for the entity.
  * @use_count:	Use count for the entity.
@@ -270,6 +306,7 @@ struct media_entity {
 	enum media_entity_type obj_type;
 	u32 function;
 	unsigned long flags;
+	bool inited;
 
 	u16 num_pads;
 	u16 num_links;
@@ -278,6 +315,7 @@ struct media_entity {
 
 	struct media_pad *pads;
 	struct list_head links;
+	struct list_head props;
 
 	const struct media_entity_operations *ops;
 
@@ -332,6 +370,20 @@ struct media_intf_devnode {
 	u32				minor;
 };
 
+/**
+ * media_entity_init() - initialize the media entity struct
+ *
+ * @entity:	pointer to &media_entity
+ */
+static inline void media_entity_init(struct media_entity *entity)
+{
+	INIT_LIST_HEAD(&entity->links);
+	INIT_LIST_HEAD(&entity->props);
+	entity->num_links = 0;
+	entity->num_backlinks = 0;
+	entity->inited = true;
+}
+
 /**
  * media_entity_id() - return the media entity graph object id
  *
@@ -565,6 +617,15 @@ static inline bool media_entity_enum_intersects(
 #define gobj_to_intf(gobj) \
 		container_of(gobj, struct media_interface, graph_obj)
 
+/**
+ * gobj_to_prop - returns the struct &media_prop pointer from the
+ *	@gobj contained on it.
+ *
+ * @gobj: Pointer to the struct &media_gobj graph object
+ */
+#define gobj_to_prop(gobj) \
+		container_of(gobj, struct media_prop, graph_obj)
+
 /**
  * intf_to_devnode - returns the struct media_intf_devnode pointer from the
  *	@intf contained on it.
@@ -727,6 +788,131 @@ int media_create_pad_links(const struct media_device *mdev,
 
 void __media_entity_remove_links(struct media_entity *entity);
 
+/**
+ * media_entity_add_prop() - Add property to entity
+ *
+ * @entity:	entity where to add the property
+ * @type:	property type
+ * @name:	property name
+ * @val:	property value: use if payload_size == 0
+ * @ptr:	property pointer to payload
+ * @payload_size: property payload size
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+int media_entity_add_prop(struct media_entity *ent, u32 type,
+		const char *name, u64 val, const void *ptr, u32 payload_size);
+
+/**
+ * media_pad_add_prop() - Add property to pad
+ *
+ * @pad:	pad where to add the property
+ * @type:	property type
+ * @name:	property name
+ * @val:	property value: use if payload_size == 0
+ * @ptr:	property pointer to payload
+ * @payload_size: property payload size
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+int media_pad_add_prop(struct media_pad *pad, u32 type,
+		const char *name, u64 val, const void *ptr, u32 payload_size);
+
+/**
+ * media_entity_add_prop_u64() - Add u64 property to entity
+ *
+ * @entity:	entity where to add the property
+ * @name:	property name
+ * @val:	property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_entity_add_prop_u64(struct media_entity *entity,
+					    const char *name, u64 val)
+{
+	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_U64,
+				     name, val, NULL, 0);
+}
+
+/**
+ * media_entity_add_prop_s64() - Add s64 property to entity
+ *
+ * @entity:	entity where to add the property
+ * @name:	property name
+ * @val:	property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_entity_add_prop_s64(struct media_entity *entity,
+					    const char *name, s64 val)
+{
+	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_S64,
+				     name, (u64)val, NULL, 0);
+}
+
+/**
+ * media_entity_add_prop_string() - Add string property to entity
+ *
+ * @entity:	entity where to add the property
+ * @name:	property name
+ * @string:	property string value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_entity_add_prop_string(struct media_entity *entity,
+					const char *name, const char *string)
+{
+	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_STRING,
+				     name, 0, string, strlen(string) + 1);
+}
+
+/**
+ * media_pad_add_prop_u64() - Add u64 property to pad
+ *
+ * @pad:	pad where to add the property
+ * @name:	property name
+ * @val:	property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_pad_add_prop_u64(struct media_pad *pad,
+					 const char *name, u64 val)
+{
+	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_U64, name, val, NULL, 0);
+}
+
+/**
+ * media_pad_add_prop_s64() - Add s64 property to pad
+ *
+ * @pad:	pad where to add the property
+ * @name:	property name
+ * @val:	property value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_pad_add_prop_s64(struct media_pad *pad,
+					 const char *name, s64 val)
+{
+	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_S64,
+				  name, (u64)val, NULL, 0);
+}
+
+/**
+ * media_pad_add_prop_string() - Add string property to pad
+ *
+ * @pad:	pad where to add the property
+ * @name:	property name
+ * @string:	property string value
+ *
+ * Returns 0 on success, or an error on failure.
+ */
+static inline int media_pad_add_prop_string(struct media_pad *pad,
+					const char *name, const char *string)
+{
+	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_STRING,
+				  name, 0, string, strlen(string) + 1);
+}
+
 /**
  * media_entity_remove_links() - remove all links associated with an entity
  *
-- 
2.18.0
