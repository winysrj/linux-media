Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50956 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbeHCS6Y (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Aug 2018 14:58:24 -0400
Date: Fri, 3 Aug 2018 14:01:12 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 2/3] media: add support for properties
Message-ID: <20180803140112.4fd5ba78@coco.lan>
In-Reply-To: <20180803143626.48191-3-hverkuil@xs4all.nl>
References: <20180803143626.48191-1-hverkuil@xs4all.nl>
        <20180803143626.48191-3-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  3 Aug 2018 16:36:25 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Initially support u64/s64 and string properties.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/media-device.c |  98 +++++++++++++++++++-
>  drivers/media/media-entity.c |  65 +++++++++++++
>  include/media/media-device.h |   6 ++
>  include/media/media-entity.h | 172 +++++++++++++++++++++++++++++++++++
>  4 files changed, 338 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index fcdf3d5dc4b6..6fa9555a669f 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -241,10 +241,15 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  	struct media_interface *intf;
>  	struct media_pad *pad;
>  	struct media_link *link;
> +	struct media_prop *prop;
>  	struct media_v2_entity kentity, __user *uentity;
>  	struct media_v2_interface kintf, __user *uintf;
>  	struct media_v2_pad kpad, __user *upad;
>  	struct media_v2_link klink, __user *ulink;
> +	struct media_v2_prop kprop, __user *uprop;
> +	void __user *uprop_payload;
> +	unsigned int payload_size = 0;
> +	unsigned int payload_offset = 0;
>  	unsigned int i;
>  	int ret = 0;
>  
> @@ -374,6 +379,73 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  	topo->num_links = i;
>  	topo->reserved4 = 0;
>  
> +	/* Get properties and number of properties */
> +	i = 0;
> +	uprop = media_get_uptr(topo->ptr_props);
> +	payload_offset = topo->num_props * sizeof(*uprop);
> +	media_device_for_each_prop(prop, mdev) {
> +		payload_size += prop->payload_size;
> +		i++;
> +
> +		if (ret || !uprop)
> +			continue;

I would add here filter capabilities to to the objects requested by
the ioctl, e. g. something similar to this:

	bool return_prop = false;

	enum media_gobj_type type = media_type(prop->graph_obj.id);

	/* 
	 * If only props are required, don't filter them.
	 * Otherwise, filter properties according with the types requested
	 * by G_TOPOLOGY call
	 */
	if (!(uentity || uintf || upad || ulink)) 
		return_prop = true;
	else if (uentity && type == MEDIA_GRAPH_ENTITY)
		return_prop = true;
	else if (uintf && type == MEDIA_GRAPH_INTF_DEVNODE)
		return_prop = true;
	else if (upad && type == MEDIA_GRAPH_PAD)
		return_prop = true;
	else if (link && type == MEDIA_GRAPH_LINK)
		return_prop = true;

	if (return_prop) {
		/* the code that copy properties below */
	}

> +
> +		if (i > topo->num_props) {
> +			ret = -ENOSPC;
> +			continue;
> +		}
> +
> +		memset(&kprop, 0, sizeof(kprop));
> +
> +		/* Copy prop fields to userspace struct */
> +		kprop.id = prop->graph_obj.id;
> +		kprop.owner_id = prop->owner->id;
> +		kprop.type = prop->type;
> +		kprop.flags = 0;
> +		kprop.payload_size = prop->payload_size;
> +		if (kprop.payload_size)
> +			kprop.payload_offset = payload_offset +
> +				payload_size - prop->payload_size;
> +		else
> +			kprop.payload_offset = 0;
> +		payload_offset -= sizeof(*uprop);
> +		memcpy(kprop.name, prop->name, sizeof(kprop.name));
> +		kprop.uval = prop->uval;
> +
> +		if (copy_to_user(uprop, &kprop, sizeof(kprop)))
> +			ret = -EFAULT;
> +		uprop++;

This way, properties will be filtered according with userspace's needs.

> +	}
> +	topo->num_props = i;
> +	if (uprop && topo->props_payload_size < payload_size)
> +		ret = -ENOSPC;
> +	topo->props_payload_size = payload_size;
> +	if (!uprop || ret)
> +		return ret;
> +
> +	uprop_payload = uprop;
> +	media_device_for_each_prop(prop, mdev) {
> +		i++;
> +
> +		if (!prop->payload_size)
> +			continue;

You would need a similar test here too.

> +
> +		if (copy_to_user(uprop_payload, prop->string, prop->payload_size))
> +			return -EFAULT;
> +		uprop_payload += prop->payload_size;
> +	}
> +
> +	return 0;
> +}
> +
> +static long media_device_get_topology_1(struct media_device *mdev, void *arg)
> +{
> +	struct media_v2_topology topo = {};
> +	long ret;
> +
> +	memcpy(&topo, arg, sizeof(struct media_v2_topology_1));
> +	ret = media_device_get_topology(mdev, &topo);
> +	memcpy(arg, &topo, sizeof(struct media_v2_topology_1));
>  	return ret;
>  }

Nah, no need that.

>  
> @@ -424,6 +496,7 @@ static const struct media_ioctl_info ioctl_info[] = {
>  	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC(G_TOPOLOGY_1, media_device_get_topology_1, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
>  };

Nah, need for that!

Sakari made once a patch changing this struct to allow variable params.
Basically, he added a minimum and maximum size at the struct.

See it at:
	https://patchwork.kernel.org/patch/9012371/

>  
> @@ -438,12 +511,12 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
>  	long ret;
>  
>  	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info)
> -	    || ioctl_info[_IOC_NR(cmd)].cmd != cmd)
> +	    || (ioctl_info[_IOC_NR(cmd)].cmd != cmd))
>  		return -ENOIOCTLCMD;
>  
>  	info = &ioctl_info[_IOC_NR(cmd)];
>  
> -	if (_IOC_SIZE(info->cmd) > sizeof(__karg)) {
> +	if (_IOC_SIZE(cmd) > sizeof(__karg)) {
>  		karg = kmalloc(_IOC_SIZE(info->cmd), GFP_KERNEL);
>  		if (!karg)
>  			return -ENOMEM;
> @@ -582,6 +655,7 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	WARN_ON(entity->graph_obj.mdev != NULL);
>  	entity->graph_obj.mdev = mdev;
>  	INIT_LIST_HEAD(&entity->links);
> +	INIT_LIST_HEAD(&entity->props);
>  	entity->num_links = 0;
>  	entity->num_backlinks = 0;
>  
> @@ -635,6 +709,18 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  }
>  EXPORT_SYMBOL_GPL(media_device_register_entity);
>  
> +static void media_device_free_props(struct list_head *list)
> +{
> +	while (!list_empty(list)) {
> +		struct media_prop *prop;
> +
> +		prop = list_first_entry(list, struct media_prop, list);
> +		list_del(&prop->list);
> +		media_gobj_destroy(&prop->graph_obj);
> +		kfree(prop);
> +	}
> +}
> +
>  static void __media_device_unregister_entity(struct media_entity *entity)
>  {
>  	struct media_device *mdev = entity->graph_obj.mdev;
> @@ -656,8 +742,13 @@ static void __media_device_unregister_entity(struct media_entity *entity)
>  	__media_entity_remove_links(entity);
>  
>  	/* Remove all pads that belong to this entity */
> -	for (i = 0; i < entity->num_pads; i++)
> +	for (i = 0; i < entity->num_pads; i++) {
> +		media_device_free_props(&entity->pads[i].props);
>  		media_gobj_destroy(&entity->pads[i].graph_obj);
> +	}
> +
> +	/* Remove all props that belong to this entity */
> +	media_device_free_props(&entity->props);
>  
>  	/* Remove the entity */
>  	media_gobj_destroy(&entity->graph_obj);
> @@ -696,6 +787,7 @@ void media_device_init(struct media_device *mdev)
>  	INIT_LIST_HEAD(&mdev->interfaces);
>  	INIT_LIST_HEAD(&mdev->pads);
>  	INIT_LIST_HEAD(&mdev->links);
> +	INIT_LIST_HEAD(&mdev->props);
>  	INIT_LIST_HEAD(&mdev->entity_notify);
>  	mutex_init(&mdev->graph_mutex);
>  	ida_init(&mdev->entity_internal_idx);
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 3498551e618e..5c09f1937bc9 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -34,6 +34,8 @@ static inline const char *gobj_type(enum media_gobj_type type)
>  		return "link";
>  	case MEDIA_GRAPH_INTF_DEVNODE:
>  		return "intf-devnode";
> +	case MEDIA_GRAPH_PROP:
> +		return "prop";
>  	default:
>  		return "unknown";
>  	}
> @@ -147,6 +149,16 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  			devnode->major, devnode->minor);
>  		break;
>  	}
> +	case MEDIA_GRAPH_PROP:
> +	{
> +		struct media_prop *prop = gobj_to_prop(gobj);
> +
> +		dev_dbg(gobj->mdev->dev,
> +			"%s id %u: prop '%s':%u[%u]\n",
> +			event_name, media_id(gobj),
> +			prop->name, media_id(prop->owner), prop->index);
> +		break;
> +	}
>  	}
>  #endif
>  }
> @@ -175,6 +187,9 @@ void media_gobj_create(struct media_device *mdev,
>  	case MEDIA_GRAPH_INTF_DEVNODE:
>  		list_add_tail(&gobj->list, &mdev->interfaces);
>  		break;
> +	case MEDIA_GRAPH_PROP:
> +		list_add_tail(&gobj->list, &mdev->props);
> +		break;
>  	}
>  
>  	mdev->topology_version++;
> @@ -212,6 +227,7 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>  	if (num_pads >= MEDIA_ENTITY_MAX_PADS)
>  		return -E2BIG;
>  
> +	INIT_LIST_HEAD(&entity->props);
>  	entity->num_pads = num_pads;
>  	entity->pads = pads;

As I said before, I long term the best is to use internally a tree model,
and attach the property to the object id, instead of adding it to each
type of entity, but for the first version, this works.

I very much prefer to start with a sub-optimal internal model but have
something to merge than wait forever to have a complex schema.

>  
> @@ -221,6 +237,7 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>  	for (i = 0; i < num_pads; i++) {
>  		pads[i].entity = entity;
>  		pads[i].index = i;
> +		INIT_LIST_HEAD(&pads[i].props);
>  		if (mdev)
>  			media_gobj_create(mdev, MEDIA_GRAPH_PAD,
>  					&entity->pads[i].graph_obj);
> @@ -233,6 +250,54 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>  }
>  EXPORT_SYMBOL_GPL(media_entity_pads_init);
>  
> +static struct media_prop *media_create_prop(struct media_gobj *owner, u32 type,
> +		const char *name, u64 val, const void *ptr, u32 payload_size)
> +{
> +	struct media_prop *prop = kzalloc(sizeof(*prop) + payload_size,
> +					  GFP_KERNEL);
> +
> +	if (!prop)
> +		return NULL;
> +	prop->type = type;
> +	strlcpy(prop->name, name, sizeof(prop->name));
> +	media_gobj_create(owner->mdev, MEDIA_GRAPH_PROP, &prop->graph_obj);
> +	prop->owner = owner;
> +	if (payload_size) {
> +		prop->string = (char *)&prop[1];
> +		memcpy(prop->string, ptr, payload_size);
> +		prop->payload_size = payload_size;
> +	} else {
> +		prop->uval = val;
> +	}
> +	return prop;
> +}
> +
> +int media_entity_add_prop(struct media_entity *ent, u32 type,
> +		const char *name, u64 val, const void *ptr, u32 payload_size)
> +{
> +	struct media_prop *prop = media_create_prop(&ent->graph_obj, type,
> +						name, val, ptr, payload_size);
> +
> +	if (!prop)
> +		return -ENOMEM;
> +	list_add_tail(&prop->list, &ent->props);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_entity_add_prop);
> +
> +int media_pad_add_prop(struct media_pad *pad, u32 type,
> +		const char *name, u64 val, const void *ptr, u32 payload_size)
> +{
> +	struct media_prop *prop = media_create_prop(&pad->graph_obj, type,
> +						name, val, ptr, payload_size);
> +
> +	if (!prop)
> +		return -ENOMEM;
> +	list_add_tail(&prop->list, &pad->props);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(media_pad_add_prop);
> +
>  /* -----------------------------------------------------------------------------
>   * Graph traversal
>   */
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index bcc6ec434f1f..a30a931df00b 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -78,6 +78,7 @@ struct media_device_ops {
>   * @interfaces:	List of registered interfaces
>   * @pads:	List of registered pads
>   * @links:	List of registered links
> + * @props:	List of registered properties
>   * @entity_notify: List of registered entity_notify callbacks
>   * @graph_mutex: Protects access to struct media_device data
>   * @pm_count_walk: Graph walk for power state walk. Access serialised using
> @@ -144,6 +145,7 @@ struct media_device {
>  	struct list_head interfaces;
>  	struct list_head pads;
>  	struct list_head links;
> +	struct list_head props;
>  
>  	/* notify callback list invoked when a new entity is registered */
>  	struct list_head entity_notify;
> @@ -382,6 +384,10 @@ void media_device_unregister_entity_notify(struct media_device *mdev,
>  #define media_device_for_each_link(link, mdev)			\
>  	list_for_each_entry(link, &(mdev)->links, graph_obj.list)
>  
> +/* Iterate over all props. */
> +#define media_device_for_each_prop(prop, mdev)			\
> +	list_for_each_entry(prop, &(mdev)->props, graph_obj.list)
> +
>  /**
>   * media_device_pci_init() - create and initialize a
>   *	struct &media_device from a PCI device.
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 3aa3d58d1d58..01b13809656d 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -36,12 +36,14 @@
>   * @MEDIA_GRAPH_LINK:		Identify a media link
>   * @MEDIA_GRAPH_INTF_DEVNODE:	Identify a media Kernel API interface via
>   *				a device node
> + * @MEDIA_GRAPH_PROP:		Identify a media property
>   */
>  enum media_gobj_type {
>  	MEDIA_GRAPH_ENTITY,
>  	MEDIA_GRAPH_PAD,
>  	MEDIA_GRAPH_LINK,
>  	MEDIA_GRAPH_INTF_DEVNODE,
> +	MEDIA_GRAPH_PROP,
>  };
>  
>  #define MEDIA_BITS_PER_TYPE		8
> @@ -164,12 +166,44 @@ struct media_link {
>   * @flags:	Pad flags, as defined in
>   *		:ref:`include/uapi/linux/media.h <media_header>`
>   *		(seek for ``MEDIA_PAD_FL_*``)
> + * @num_props:	Number of pad properties
> + * @props:	The list pad properties
>   */
>  struct media_pad {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
>  	struct media_entity *entity;
>  	u16 index;
>  	unsigned long flags;
> +	u16 num_props;
> +	struct list_head props;
> +};
> +
> +/**
> + * struct media_prop - A media property graph object.
> + *
> + * @graph_obj:	Embedded structure containing the media object common data
> + * @list:	Linked list associated with the object that owns the link.
> + * @owner:	Graph object this property belongs to
> + * @index:	Property index for the owner property array, numbered from 0 to n
> + * @type:	Property type
> + * @payload_size: Property payload size (i.e. additional bytes beyond this struct)
> + * @name:	Property name
> + * @uval:	Property value (unsigned)
> + * @sval:	Property value (signed)
> + * @string:	Property string value
> + */
> +struct media_prop {
> +	struct media_gobj graph_obj;	/* must be first field in struct */
> +	struct list_head list;
> +	struct media_gobj *owner;
> +	u32 type;
> +	u32 payload_size;
> +	char name[32];
> +	union {
> +		u64 uval;
> +		s64 sval;
> +		char *string;
> +	};
>  };
>  
>  /**
> @@ -239,10 +273,12 @@ enum media_entity_type {
>   * @num_pads:	Number of sink and source pads.
>   * @num_links:	Total number of links, forward and back, enabled and disabled.
>   * @num_backlinks: Number of backlinks
> + * @num_props:	Number of entity properties.
>   * @internal_idx: An unique internal entity specific number. The numbers are
>   *		re-used if entities are unregistered or registered again.
>   * @pads:	Pads array with the size defined by @num_pads.
>   * @links:	List of data links.
> + * @props:	List of entity properties.
>   * @ops:	Entity operations.
>   * @stream_count: Stream count for the entity.
>   * @use_count:	Use count for the entity.
> @@ -274,10 +310,12 @@ struct media_entity {
>  	u16 num_pads;
>  	u16 num_links;
>  	u16 num_backlinks;
> +	u16 num_props;
>  	int internal_idx;
>  
>  	struct media_pad *pads;
>  	struct list_head links;
> +	struct list_head props;
>  
>  	const struct media_entity_operations *ops;
>  
> @@ -565,6 +603,15 @@ static inline bool media_entity_enum_intersects(
>  #define gobj_to_intf(gobj) \
>  		container_of(gobj, struct media_interface, graph_obj)
>  
> +/**
> + * gobj_to_prop - returns the struct &media_prop pointer from the
> + *	@gobj contained on it.
> + *
> + * @gobj: Pointer to the struct &media_gobj graph object
> + */
> +#define gobj_to_prop(gobj) \
> +		container_of(gobj, struct media_prop, graph_obj)
> +
>  /**
>   * intf_to_devnode - returns the struct media_intf_devnode pointer from the
>   *	@intf contained on it.
> @@ -727,6 +774,131 @@ int media_create_pad_links(const struct media_device *mdev,
>  
>  void __media_entity_remove_links(struct media_entity *entity);
>  
> +/**
> + * media_entity_add_prop() - Add property to entity
> + *
> + * @entity:	entity where to add the property
> + * @type:	property type
> + * @name:	property name
> + * @val:	property value: use if payload_size == 0
> + * @ptr:	property pointer to payload
> + * @payload_size: property payload size
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +int media_entity_add_prop(struct media_entity *ent, u32 type,
> +		const char *name, u64 val, const void *ptr, u32 payload_size);
> +
> +/**
> + * media_pad_add_prop() - Add property to pad
> + *
> + * @pad:	pad where to add the property
> + * @type:	property type
> + * @name:	property name
> + * @val:	property value: use if payload_size == 0
> + * @ptr:	property pointer to payload
> + * @payload_size: property payload size
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +int media_pad_add_prop(struct media_pad *pad, u32 type,
> +		const char *name, u64 val, const void *ptr, u32 payload_size);
> +
> +/**
> + * media_entity_add_prop_u64() - Add u64 property to entity
> + *
> + * @entity:	entity where to add the property
> + * @name:	property name
> + * @val:	property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_entity_add_prop_u64(struct media_entity *entity,
> +					    const char *name, u64 val)
> +{
> +	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_U64,
> +				     name, val, NULL, 0);
> +}
> +
> +/**
> + * media_entity_add_prop_s64() - Add s64 property to entity
> + *
> + * @entity:	entity where to add the property
> + * @name:	property name
> + * @val:	property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_entity_add_prop_s64(struct media_entity *entity,
> +					    const char *name, s64 val)
> +{
> +	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_S64,
> +				     name, (u64)val, NULL, 0);
> +}
> +
> +/**
> + * media_entity_add_prop_string() - Add string property to entity
> + *
> + * @entity:	entity where to add the property
> + * @name:	property name
> + * @string:	property string value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_entity_add_prop_string(struct media_entity *entity,
> +					const char *name, const char *string)
> +{
> +	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_STRING,
> +				     name, 0, string, strlen(string) + 1);
> +}
> +
> +/**
> + * media_pad_add_prop_u64() - Add u64 property to pad
> + *
> + * @pad:	pad where to add the property
> + * @name:	property name
> + * @val:	property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_pad_add_prop_u64(struct media_pad *pad,
> +					 const char *name, u64 val)
> +{
> +	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_U64, name, val, NULL, 0);
> +}
> +
> +/**
> + * media_pad_add_prop_s64() - Add s64 property to pad
> + *
> + * @pad:	pad where to add the property
> + * @name:	property name
> + * @val:	property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_pad_add_prop_s64(struct media_pad *pad,
> +					 const char *name, s64 val)
> +{
> +	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_S64,
> +				  name, (u64)val, NULL, 0);
> +}
> +
> +/**
> + * media_pad_add_prop_string() - Add string property to pad
> + *
> + * @pad:	pad where to add the property
> + * @name:	property name
> + * @string:	property string value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_pad_add_prop_string(struct media_pad *pad,
> +					const char *name, const char *string)
> +{
> +	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_STRING,
> +				  name, 0, string, strlen(string) + 1);
> +}
> +
>  /**
>   * media_entity_remove_links() - remove all links associated with an entity
>   *



Thanks,
Mauro
