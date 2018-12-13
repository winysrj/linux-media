Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC1BAC65BAE
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FB0220879
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 17:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544721255;
	bh=+AcG9f60dGWac4k/toYZEhBQ66Ll2pDY3jLy1HgKc34=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=dalfrZ1aiwy+d2aXAalwQ1u6DXOskAXyRS3+JeYWQZCppYf8xKGB1BNxYwrRKNMJk
	 QcPB6xc6IKvJj2e11XiOR0qjkjVmHrMFnMl2+l51TsQjzpP/5RBAqXBoK9zMX6WNlx
	 dtdx93gMIvodkbFXHHHkWS5WdLt8CuGiMDMd413A=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FB0220879
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbeLMROO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 12:14:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:34556 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729654AbeLMRON (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 12:14:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2yCM9iDMa7/fVPKlHaZmxxokXlxkIFclEvcNSRtS+As=; b=Nknd9Kv2lykBIvaqYpq9v6WyXo
        MlWfbU6VjDG3z44o+vm0K+FMF2gDDy3RT+44bQFI8YaKoTT5s7aJG7xMDM0SKS+bFviPqytZ/ZTkK
        qYgbRFjVG4LZTRX1MQ/F3pBB1OGlIOUESwQF1E2Sh5WqdDKEUVS5VsJFpaKk2TQ63cK+Q0de5wZ3P
        c61F50kmZXL+2CGFAZ4hxEzUIRoWhLyU9gJB1mIkJai5K5+kWsYxdyKGsuqGwPU2je23QOvhs8mAK
        UiJ1xKf6HcKjWDqncddUtW6Ynf5OVFDooISS5MDjebbNpaNyDAkXR7OfB7IhO44oX5b7pFIVsw2jH
        Q7HINGrw==;
Received: from 177.43.150.95.dynamic.adsl.gvt.net.br ([177.43.150.95] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gXUYt-00030g-8c; Thu, 13 Dec 2018 17:14:11 +0000
Date:   Thu, 13 Dec 2018 15:14:07 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org
Subject: Re: [RFCv5 PATCH 2/4] media controller: add properties support
Message-ID: <20181213151407.69752454@coco.lan>
In-Reply-To: <20181213134113.15247-3-hverkuil-cisco@xs4all.nl>
References: <20181213134113.15247-1-hverkuil-cisco@xs4all.nl>
        <20181213134113.15247-3-hverkuil-cisco@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Thu, 13 Dec 2018 14:41:11 +0100
hverkuil-cisco@xs4all.nl escreveu:

> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Add support for properties. In this initial implementation properties
> can be added to entities and pads. In addition, properties can be
> nested.
> 
> Most of the changes are straightforward, but I had to make some changes
> to the way entities are initialized, since the struct has to be
> initialized either when media_entity_pads_init() is called or when
> media_device_register_entity() is called, whichever comes first.
> 
> The properties list in the entity has to be initialized in both cases,
> otherwise you can't add properties to it.
> 
> The entity struct is now initialized in media_entity_init and called
> from both functions if ent->inited is 0.
> 
> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> ---
>  drivers/media/media-device.c | 129 ++++++++++++++++++++++++++++++++---
>  drivers/media/media-entity.c |  26 +++++--
>  include/media/media-device.h |   6 ++
>  include/media/media-entity.h |  58 ++++++++++++++++
>  4 files changed, 205 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index bed24372e61f..a932e6848d47 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -242,10 +242,14 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  	struct media_interface *intf;
>  	struct media_pad *pad;
>  	struct media_link *link;
> +	struct media_prop *prop;
>  	struct media_v2_entity kentity, __user *uentity;
>  	struct media_v2_interface kintf, __user *uintf;
>  	struct media_v2_pad kpad, __user *upad;
>  	struct media_v2_link klink, __user *ulink;
> +	struct media_v2_prop kprop, __user *uprop;
> +	unsigned int props_payload_size = 0;
> +	unsigned int prop_payload_offset;
>  	unsigned int i;
>  	int ret = 0;
>  
> @@ -375,6 +379,48 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  	topo->num_links = i;
>  	topo->reserved4 = 0;
>  
> +	/* Get properties and number of properties */
> +	i = 0;
> +	uprop = media_get_uptr(topo->ptr_props);
> +	media_device_for_each_prop(prop, mdev) {
> +		i++;
> +		props_payload_size += ALIGN(prop->payload_size, sizeof(u64));

I wouldn't be aligning it to u64. Instead, I would use something like:

	ALIGN(prop->payload_size, sizeof(void *))

This way, it would waste less space on 32-bits CPU.

> +	}
> +	if (i > topo->num_props ||
> +	    props_payload_size > topo->props_payload_size)
> +		ret = ret ? : -ENOSPC;
> +	topo->props_payload_size = props_payload_size;
> +	topo->num_props = i;
> +	topo->reserved4 = 0;
> +
> +	if (ret || !uprop)
> +		return ret;
> +
> +	prop_payload_offset = topo->num_props * sizeof(*uprop);
> +	media_device_for_each_prop(prop, mdev) {
> +		memset(&kprop, 0, sizeof(kprop));
> +
> +		/* Copy prop fields to userspace struct */
> +		kprop.id = prop->graph_obj.id;
> +		kprop.type = prop->type;
> +		kprop.owner_id = prop->owner->id;
> +		kprop.owner_type = media_type(prop->owner);
> +		kprop.payload_size = prop->payload_size;
> +		if (prop->payload_size) {
> +			kprop.payload_offset = prop_payload_offset;
> +			if (copy_to_user((u8 __user *)uprop + prop_payload_offset,
> +					 prop->payload, prop->payload_size))
> +				return -EFAULT;
> +			prop_payload_offset += ALIGN(prop->payload_size, sizeof(u64));
> +		}
> +		memcpy(kprop.name, prop->name, sizeof(kprop.name));
> +
> +		if (copy_to_user(uprop, &kprop, sizeof(kprop)))
> +			return -EFAULT;
> +		uprop++;
> +		prop_payload_offset -= sizeof(*uprop);
> +	}
> +
>  	return ret;
>  }
>  
> @@ -408,9 +454,10 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
>  /* Do acquire the graph mutex */
>  #define MEDIA_IOC_FL_GRAPH_MUTEX	BIT(0)
>  
> -#define MEDIA_IOC_ARG(__cmd, func, fl, from_user, to_user)		\
> +#define MEDIA_IOC_ARG(__cmd, alts, func, fl, from_user, to_user)	\
>  	[_IOC_NR(MEDIA_IOC_##__cmd)] = {				\
>  		.cmd = MEDIA_IOC_##__cmd,				\
> +		.alternatives = (alts),					\
>  		.fn = (long (*)(struct media_device *, void *))func,	\
>  		.flags = fl,						\
>  		.arg_from_user = from_user,				\
> @@ -418,23 +465,39 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
>  	}
>  
>  #define MEDIA_IOC(__cmd, func, fl)					\
> -	MEDIA_IOC_ARG(__cmd, func, fl, copy_arg_from_user, copy_arg_to_user)
> +	MEDIA_IOC_ARG(__cmd, NULL, func, fl, copy_arg_from_user, copy_arg_to_user)
> +#define MEDIA_IOC_ALTS(__cmd, alts, func, fl)				\
> +	MEDIA_IOC_ARG(__cmd, alts, func, fl, copy_arg_from_user, copy_arg_to_user)
>  
>  /* the table is indexed by _IOC_NR(cmd) */
>  struct media_ioctl_info {
>  	unsigned int cmd;
> +	const unsigned int *alternatives;
>  	unsigned short flags;
>  	long (*fn)(struct media_device *dev, void *arg);
>  	long (*arg_from_user)(void *karg, void __user *uarg, unsigned int cmd);
>  	long (*arg_to_user)(void __user *uarg, void *karg, unsigned int cmd);
>  };
>  
> +#define _IOWR_COMPAT(type, nr, size) \
> +	_IOC(_IOC_READ | _IOC_WRITE, (type), (nr), (size))
> +
> +/* Old MEDIA_IOC_G_TOPOLOGY ioctl without props support */
> +#define MEDIA_IOC_G_TOPOLOGY_V1 _IOWR_COMPAT('|', 0x04, offsetof(struct media_v2_topology, num_props))
> +
> +static const unsigned int topo_alts[] = {
> +	/* Old MEDIA_IOC_G_TOPOLOGY without props support */
> +	MEDIA_IOC_G_TOPOLOGY_V1,
> +	0
> +};
> +
>  static const struct media_ioctl_info ioctl_info[] = {
>  	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
> +	MEDIA_IOC_ALTS(G_TOPOLOGY, topo_alts, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(REQUEST_ALLOC, media_device_request_alloc, 0),
>  };
>  
> @@ -448,17 +511,29 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
>  	char __karg[256], *karg = __karg;
>  	long ret;
>  
> -	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info)
> -	    || ioctl_info[_IOC_NR(cmd)].cmd != cmd)
> +	if (_IOC_NR(cmd) >= ARRAY_SIZE(ioctl_info))
>  		return -ENOIOCTLCMD;
>  
>  	info = &ioctl_info[_IOC_NR(cmd)];
>  
> +	if (info->cmd != cmd) {
> +		const unsigned int *p;
> +
> +		for (p = info->alternatives; p && *p; p++)
> +			if (*p == cmd)
> +				break;
> +		if (!p || !*p)
> +			return -ENOIOCTLCMD;
> +	}
> +
>  	if (_IOC_SIZE(info->cmd) > sizeof(__karg)) {
>  		karg = kmalloc(_IOC_SIZE(info->cmd), GFP_KERNEL);
>  		if (!karg)
>  			return -ENOMEM;
>  	}
> +	if (_IOC_SIZE(info->cmd) > _IOC_SIZE(cmd))
> +		memset(karg + _IOC_SIZE(cmd), 0,
> +		       _IOC_SIZE(info->cmd) - _IOC_SIZE(cmd));
>  
>  	if (info->arg_from_user) {
>  		ret = info->arg_from_user(karg, arg, cmd);
> @@ -571,6 +646,16 @@ static void media_device_release(struct media_devnode *devnode)
>  	dev_dbg(devnode->parent, "Media device released\n");
>  }
>  
> +static void init_prop_list(struct media_device *mdev, struct list_head *list)
> +{
> +	struct media_prop *prop;
> +
> +	list_for_each_entry(prop, list, list) {
> +		media_gobj_create(mdev, MEDIA_GRAPH_PROP, &prop->graph_obj);
> +		init_prop_list(mdev, &prop->props);
> +	}
> +}
> +
>  /**
>   * media_device_register_entity - Register an entity with a media device
>   * @mdev:	The media device
> @@ -592,9 +677,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	/* Warn if we apparently re-register an entity */
>  	WARN_ON(entity->graph_obj.mdev != NULL);

It seems that you missed my comments on this hunk (or maybe I missed your
answer to my review of patch 2/3 of RFCv4[1]).

[1] https://lore.kernel.org/linux-media/20181212070225.2863a72e@coco.lan/

I'll repeat it here:

For this:

	>  	/* Warn if we apparently re-register an entity */
	>  	WARN_ON(entity->graph_obj.mdev != NULL);  

Side note: it would probably make sense to change the above to:

	if (WARN_ON(entity->graph_obj.mdev != NULL))
		return -EINVAL;

That should be on a separate patch, as it is unrelated to the
properties API addition.

>  	entity->graph_obj.mdev = mdev;
> -	INIT_LIST_HEAD(&entity->links);
> -	entity->num_links = 0;
> -	entity->num_backlinks = 0;
> +	if (!entity->inited)
> +		media_entity_init(entity);

Nitpick: I would add a comment for this explaining why the check is
required here.

>  
>  	ret = ida_alloc_min(&mdev->entity_internal_idx, 1, GFP_KERNEL);
>  	if (ret < 0)
> @@ -608,10 +692,17 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	/* Initialize media_gobj embedded at the entity */
>  	media_gobj_create(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
>  
> +	/* Initialize objects at the props */
> +	init_prop_list(mdev, &entity->props);
> +
>  	/* Initialize objects at the pads */
> -	for (i = 0; i < entity->num_pads; i++)
> +	for (i = 0; i < entity->num_pads; i++) {
>  		media_gobj_create(mdev, MEDIA_GRAPH_PAD,
> -			       &entity->pads[i].graph_obj);
> +				  &entity->pads[i].graph_obj);
> +
> +		/* Initialize objects at the pad props */
> +		init_prop_list(mdev, &entity->pads[i].props);
> +	}
>  
>  	/* invoke entity_notify callbacks */
>  	list_for_each_entry_safe(notify, next, &mdev->entity_notify, list)
> @@ -640,6 +731,18 @@ int __must_check media_device_register_entity(struct media_device *mdev,
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
> @@ -661,8 +764,13 @@ static void __media_device_unregister_entity(struct media_entity *entity)
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
> @@ -701,6 +809,7 @@ void media_device_init(struct media_device *mdev)
>  	INIT_LIST_HEAD(&mdev->interfaces);
>  	INIT_LIST_HEAD(&mdev->pads);
>  	INIT_LIST_HEAD(&mdev->links);
> +	INIT_LIST_HEAD(&mdev->props);
>  	INIT_LIST_HEAD(&mdev->entity_notify);
>  
>  	mutex_init(&mdev->req_queue_mutex);
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 0b1cb3559140..62c4d5b4d33f 100644
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



> @@ -106,7 +108,7 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  	switch (media_type(gobj)) {
>  	case MEDIA_GRAPH_ENTITY:
>  		dev_dbg(gobj->mdev->dev,
> -			"%s id %u: entity '%s'\n",
> +			"%s id 0x%08x: entity '%s'\n",
>  			event_name, media_id(gobj),
>  			gobj_to_entity(gobj)->name);
>  		break;
> @@ -115,7 +117,7 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  		struct media_link *link = gobj_to_link(gobj);
>  
>  		dev_dbg(gobj->mdev->dev,
> -			"%s id %u: %s link id %u ==> id %u\n",
> +			"%s id 0x%08x: %s link id 0x%08x ==> id 0x%08x\n",
>  			event_name, media_id(gobj),
>  			media_type(link->gobj0) == MEDIA_GRAPH_PAD ?
>  				"data" : "interface",
> @@ -128,7 +130,7 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  		struct media_pad *pad = gobj_to_pad(gobj);
>  
>  		dev_dbg(gobj->mdev->dev,
> -			"%s id %u: %s%spad '%s':%d\n",
> +			"%s id 0x%08x: %s%spad '%s':%d\n",
>  			event_name, media_id(gobj),
>  			pad->flags & MEDIA_PAD_FL_SINK   ? "sink " : "",
>  			pad->flags & MEDIA_PAD_FL_SOURCE ? "source " : "",
> @@ -141,12 +143,22 @@ static void dev_dbg_obj(const char *event_name,  struct media_gobj *gobj)
>  		struct media_intf_devnode *devnode = intf_to_devnode(intf);
>  
>  		dev_dbg(gobj->mdev->dev,
> -			"%s id %u: intf_devnode %s - major: %d, minor: %d\n",
> +			"%s id 0x%08x: intf_devnode %s - major: %d, minor: %d\n",
>  			event_name, media_id(gobj),
>  			intf_type(intf),
>  			devnode->major, devnode->minor);
>  		break;
>  	}

I also suggested to move the above hunks to a separate patch, as this change
is not really related to the addition of the properties.

> +	case MEDIA_GRAPH_PROP:
> +	{
> +		struct media_prop *prop = gobj_to_prop(gobj);
> +
> +		dev_dbg(gobj->mdev->dev,
> +			"%s id 0x%08x: prop '%s':0x%08x\n",
> +			event_name, media_id(gobj),
> +			prop->name, media_id(prop->owner));
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
> @@ -212,6 +227,8 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>  	if (num_pads >= MEDIA_ENTITY_MAX_PADS)
>  		return -E2BIG;
>  
> +	if (!entity->inited)
> +		media_entity_init(entity);
>  	entity->num_pads = num_pads;
>  	entity->pads = pads;
>  
> @@ -221,6 +238,7 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>  	for (i = 0; i < num_pads; i++) {
>  		pads[i].entity = entity;
>  		pads[i].index = i;
> +		INIT_LIST_HEAD(&pads[i].props);
>  		if (mdev)
>  			media_gobj_create(mdev, MEDIA_GRAPH_PAD,
>  					&entity->pads[i].graph_obj);
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index c8ddbfe8b74c..d422a1e1c367 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -101,6 +101,7 @@ struct media_device_ops {
>   * @interfaces:	List of registered interfaces
>   * @pads:	List of registered pads
>   * @links:	List of registered links
> + * @props:	List of registered properties
>   * @entity_notify: List of registered entity_notify callbacks
>   * @graph_mutex: Protects access to struct media_device data
>   * @pm_count_walk: Graph walk for power state walk. Access serialised using
> @@ -170,6 +171,7 @@ struct media_device {
>  	struct list_head interfaces;
>  	struct list_head pads;
>  	struct list_head links;
> +	struct list_head props;
>  
>  	/* notify callback list invoked when a new entity is registered */
>  	struct list_head entity_notify;
> @@ -411,6 +413,10 @@ void media_device_unregister_entity_notify(struct media_device *mdev,
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
> index e5f6960d92f6..5d05ebf712d0 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -21,6 +21,7 @@
>  
>  #include <linux/bitmap.h>
>  #include <linux/bug.h>
> +#include <linux/err.h>
>  #include <linux/fwnode.h>
>  #include <linux/kernel.h>
>  #include <linux/list.h>
> @@ -36,12 +37,14 @@
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
> @@ -193,6 +196,7 @@ enum media_pad_signal_type {
>   * @flags:	Pad flags, as defined in
>   *		:ref:`include/uapi/linux/media.h <media_header>`
>   *		(seek for ``MEDIA_PAD_FL_*``)
> + * @props:	The list pad properties
>   */
>  struct media_pad {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
> @@ -200,6 +204,33 @@ struct media_pad {
>  	u16 index;
>  	enum media_pad_signal_type sig_type;
>  	unsigned long flags;
> +	struct list_head props;
> +};
> +
> +/**
> + * struct media_prop - A media property graph object.
> + *
> + * @graph_obj:	Embedded structure containing the media object common data
> + * @list:	Linked list associated with the object that owns the link.
> + * @owner:	Graph object this property belongs to
> + * @index:	Property index for the owner property array, numbered
> + *		from 0 to n
> + * @type:	Property type
> + * @payload_size: Property payload size (i.e. additional bytes beyond this
> + *		struct)
> + * @props:	The list of sub-properties
> + * @name:	Property name
> + * @payload:	Property payload starts here
> + */
> +struct media_prop {
> +	struct media_gobj graph_obj;	/* must be first field in struct */
> +	struct list_head list;
> +	struct media_gobj *owner;

OK.

Despite my comment at uAPI about the N:1 case of removing the owner
there, here, I would keep it.

For the first version of properties API, we should stick with 1:1 map.

We can later expand for N:1 if needed - and if we don't export owner_id
at uAPI inside the properties structure.

> +	u32 type;
> +	u32 payload_size;
> +	struct list_head props;
> +	char name[32];
> +	u8 payload[];
>  };
>  
>  /**
> @@ -266,6 +297,7 @@ enum media_entity_type {
>   * @flags:	Entity flags, as defined in
>   *		:ref:`include/uapi/linux/media.h <media_header>`
>   *		(seek for ``MEDIA_ENT_FL_*``)
> + * @inited:	Non-zero if this struct was initialized.
>   * @num_pads:	Number of sink and source pads.
>   * @num_links:	Total number of links, forward and back, enabled and disabled.
>   * @num_backlinks: Number of backlinks
> @@ -273,6 +305,7 @@ enum media_entity_type {
>   *		re-used if entities are unregistered or registered again.
>   * @pads:	Pads array with the size defined by @num_pads.
>   * @links:	List of data links.
> + * @props:	List of entity properties.
>   * @ops:	Entity operations.
>   * @stream_count: Stream count for the entity.
>   * @use_count:	Use count for the entity.
> @@ -300,6 +333,7 @@ struct media_entity {
>  	enum media_entity_type obj_type;
>  	u32 function;
>  	unsigned long flags;
> +	unsigned int inited;
>  
>  	u16 num_pads;
>  	u16 num_links;
> @@ -308,6 +342,7 @@ struct media_entity {
>  
>  	struct media_pad *pads;
>  	struct list_head links;
> +	struct list_head props;
>  
>  	const struct media_entity_operations *ops;
>  
> @@ -362,6 +397,20 @@ struct media_intf_devnode {
>  	u32				minor;
>  };
>  
> +/**
> + * media_entity_init() - initialize the media entity struct
> + *
> + * @entity:	pointer to &media_entity
> + */
> +static inline void media_entity_init(struct media_entity *entity)
> +{
> +	INIT_LIST_HEAD(&entity->links);
> +	INIT_LIST_HEAD(&entity->props);
> +	entity->num_links = 0;
> +	entity->num_backlinks = 0;
> +	entity->inited = true;
> +}
> +

As I said before, I would keep it together with the C file, as it makes
easier to read (except, of course, if are there any reason why you
would need to call it on a different C file).

>  /**
>   * media_entity_id() - return the media entity graph object id
>   *
> @@ -595,6 +644,15 @@ static inline bool media_entity_enum_intersects(
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



Thanks,
Mauro
