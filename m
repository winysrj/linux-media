Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,T_MIXED_ES,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CB4C65BAF
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2991A2084E
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 09:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544605359;
	bh=ms+JGnpAZmdnwBOWXzRLB81YVhAQDDu5SyJ/YC999Pc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=QB033Gzi+ePE28luPh+/zWHeKsyif11/i3SQWdYREK8Lf7FTIw+Gf8IhYijl7iw95
	 1ZA57BYurjSGBlMK/KCaPUG8bRPWeEHSG0emCRs9ODJNk+cBZ5QQoIXs4dPFG6tTq2
	 Qs0RctnwiNH2p3dYTngc8Kvcgke8RnoPw3kwC0dw=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2991A2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbeLLJCi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 04:02:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:56726 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726437AbeLLJCh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 04:02:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=I8RIw7QxEo3PclIRBe8b00hB84TR5PQHsBZvfdWRnAg=; b=I+7pxPZ5AbcCISoM7kgKdZv0dF
        zDoLpF4wTkE0u6sobozgnJ1q+m8oQfvMJX8uGqXj4bQamz4IdeKsdglpAZNEU2gdDNu5CYGB5O4b7
        oYtqnSyMYjGi3g0Ic1mKD7qq9swobGDLjGqGmvvFCHpIAjqH407YYeVWpkY6hIYqPxvuhBOjmECXq
        ajSiG4bPTArqbeJNUYYaHVU951vYUhsF8x2LodJgS5zRmTjQl8AIaA3lfdxouzxmcarU5Ln2d2Z39
        vQbQOV7QpTaXNfOvEFDFFNd/JmJ3JnLT4tTcFl9pKFfau/si9V489UIjs33LkXgBXFwybJr3YpwYz
        Dw49+YDg==;
Received: from [177.159.254.7] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gX0PZ-0006nY-4B; Wed, 12 Dec 2018 09:02:34 +0000
Date:   Wed, 12 Dec 2018 07:02:25 -0200
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 2/3] media controller: add properties support
Message-ID: <20181212070225.2863a72e@coco.lan>
In-Reply-To: <20181121154024.13906-3-hverkuil@xs4all.nl>
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
        <20181121154024.13906-3-hverkuil@xs4all.nl>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Wed, 21 Nov 2018 16:40:23 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add support for properties. In this initial implementation properties
> can be added to entities and pads. In addition, properties can be
> nested.
> 
> Since this patch adds the topology_idx to the graph objects it is now
> easy to fill in the index fields in the topology to allow userspace
> to quickly look up a reference from one object to another.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/media-device.c | 335 +++++++++++++++++++++++++++--------
>  drivers/media/media-entity.c | 107 ++++++++++-
>  include/media/media-device.h |   6 +
>  include/media/media-entity.h | 318 +++++++++++++++++++++++++++++++++
>  4 files changed, 685 insertions(+), 81 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index bed24372e61f..099ab3532475 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -235,6 +235,21 @@ static long media_device_setup_link(struct media_device *mdev, void *arg)
>  	return __media_entity_setup_link(link, linkd->flags);
>  }
>  
> +static void walk_props(struct list_head *head, u32 *prop_idx, u32 *payload_size)
> +{
> +	struct media_prop *prop;
> +
> +	if (list_empty(head))
> +		return;
> +
> +	list_for_each_entry(prop, head, list) {
> +		prop->graph_obj.topology_idx = (*prop_idx)++;
> +		*payload_size += prop->payload_size;
> +	}
> +	list_for_each_entry(prop, head, list)
> +		walk_props(&prop->props, prop_idx, payload_size);
> +}
> +
>  static long media_device_get_topology(struct media_device *mdev, void *arg)
>  {
>  	struct media_v2_topology *topo = arg;
> @@ -242,27 +257,96 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  	struct media_interface *intf;
>  	struct media_pad *pad;
>  	struct media_link *link;
> +	struct media_prop *prop, *subprop;
>  	struct media_v2_entity kentity, __user *uentity;
>  	struct media_v2_interface kintf, __user *uintf;
>  	struct media_v2_pad kpad, __user *upad;
>  	struct media_v2_link klink, __user *ulink;
> +	struct media_v2_prop kprop, __user *uprop;
> +	u32 payload_size = 0;
> +	u32 payload_offset = 0;
> +	u32 entity_idx = 0;
> +	u32 interface_idx = 0;
> +	u32 pad_idx = 0;
> +	u32 link_idx = 0;
> +	u32 prop_idx = 0;
>  	unsigned int i;
>  	int ret = 0;
>  
>  	topo->topology_version = mdev->topology_version;
>  
> +	/* Set entity/pad/link indices and number of entities */
> +	media_device_for_each_entity(entity, mdev) {
> +		entity->graph_obj.topology_idx = entity_idx++;
> +		walk_props(&entity->props, &prop_idx, &payload_size);
> +		for (i = 0; i < entity->num_pads; i++) {
> +			pad = entity->pads + i;
> +			pad->graph_obj.topology_idx = pad_idx++;
> +			walk_props(&pad->props, &prop_idx, &payload_size);
> +		}
> +		/* Note: links are ordered by source pad index */
> +		list_for_each_entry(link, &entity->links, list)
> +			if (!link->is_backlink)
> +				link->graph_obj.topology_idx = link_idx++;
> +	}
> +	if (topo->ptr_entities && entity_idx > topo->num_entities)
> +		ret = -ENOSPC;
> +	topo->num_entities = entity_idx;
> +	topo->reserved1 = 0;
> +
> +	/* Set interface/link indices and number of interfaces */
> +	media_device_for_each_intf(intf, mdev) {
> +		intf->graph_obj.topology_idx = interface_idx++;
> +		list_for_each_entry(link, &intf->links, list)
> +			link->graph_obj.topology_idx = link_idx++;
> +	}
> +
> +	if (topo->ptr_interfaces && interface_idx > topo->num_interfaces)
> +		ret = -ENOSPC;
> +	topo->num_interfaces = interface_idx;
> +	topo->reserved2 = 0;
> +
> +	/* Set number of pads */
> +	if (topo->ptr_pads && pad_idx > topo->num_pads)
> +		ret = -ENOSPC;
> +	topo->num_pads = pad_idx;
> +	topo->reserved3 = 0;
> +
> +	/* Set number of links */
> +	if (topo->ptr_links && link_idx > topo->num_links)
> +		ret = -ENOSPC;
> +	topo->num_links = link_idx;
> +	topo->reserved4 = 0;
> +
> +	/* Set number of properties */
> +	if (topo->ptr_props &&
> +	    (prop_idx > topo->num_props ||
> +	     payload_size > topo->props_payload_size))
> +		ret = -ENOSPC;
> +	topo->num_props = prop_idx;
> +	topo->props_payload_size = payload_size;
> +
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * We use u16 for the graph object indices,
> +	 * so check that it will fit in 16 bits.
> +	 */
> +	if (WARN_ON(entity_idx >= 0x10000 ||
> +		    interface_idx >= 0x10000 ||
> +		    pad_idx >= 0x10000 ||
> +		    link_idx >= 0x10000 ||
> +		    prop_idx >= 0x10000))
> +		return -EINVAL;
> +

This is really hacky!!! It shows that the proposed API is not OK.

I understand if we had some checks like the above internally at
the Kernel, avoiding it to have a very large number of objects,
but the API should be independent on whatever internal limit
our current implementation has.

>  	/* Get entities and number of entities */
> -	i = 0;
>  	uentity = media_get_uptr(topo->ptr_entities);
> -	media_device_for_each_entity(entity, mdev) {
> -		i++;
> -		if (ret || !uentity)
> -			continue;
> +	if (!uentity)
> +		goto skip_entities;
>  
> -		if (i > topo->num_entities) {
> -			ret = -ENOSPC;
> -			continue;
> -		}
> +	media_device_for_each_entity(entity, mdev) {
> +		u16 idx = entity->graph_obj.topology_idx;
>  
>  		/* Copy fields to userspace struct if not error */
>  		memset(&kentity, 0, sizeof(kentity));
> @@ -270,27 +354,30 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  		kentity.function = entity->function;
>  		kentity.flags = entity->flags;
>  		strscpy(kentity.name, entity->name,
> -			sizeof(kentity.name));
> +				sizeof(kentity.name));

This hunk seems broken, as it is just mangling the indentation.

> +		if (entity->num_pads) {
> +			kentity.pad_idx = entity->pads[0].graph_obj.topology_idx;
> +			kentity.flags |= MEDIA_ENT_FL_PAD_IDX;
> +		}

Already mentioned before: why? (won't repeat myself below on similar
patterns)

Userspace can just do the same while parsing the topology, if it needs a
per-entity pad index. 

> +		if (!list_empty(&entity->props)) {
> +			prop = list_first_entry(&entity->props,
> +						struct media_prop, list);
> +			kentity.prop_idx = prop->graph_obj.topology_idx;
> +			kentity.flags |= MEDIA_ENT_FL_PROP_IDX;
> +		}

After thinking a little bit more about that, I'm also in doubt why
a property index is needed.

It should trivial for the application to do the mapping, if each
property contains the object ID of the associated graph object.

The Kernel shouldn't even warrant that the properties would be
reported on a particular order.

By adding a prop_idx, you will need to ensure that all properties
for a certain type would be placed together.

If we remove all those *_idx, the code would just be (removing 
sanity checks) something similar to:

	media_device_for_each_props(props, mdev)
		copy_to_user(uprops, &kprops, sizeof(kprops));

>  
> -		if (copy_to_user(uentity, &kentity, sizeof(kentity)))
> -			ret = -EFAULT;
> -		uentity++;
> +		if (copy_to_user(uentity + idx, &kentity, sizeof(kentity)))
> +			return -EFAULT;
>  	}
> -	topo->num_entities = i;
> -	topo->reserved1 = 0;
> +skip_entities:
>  
>  	/* Get interfaces and number of interfaces */
> -	i = 0;
>  	uintf = media_get_uptr(topo->ptr_interfaces);
> -	media_device_for_each_intf(intf, mdev) {
> -		i++;
> -		if (ret || !uintf)
> -			continue;
> +	if (!uintf)
> +		goto skip_interfaces;
>  
> -		if (i > topo->num_interfaces) {
> -			ret = -ENOSPC;
> -			continue;
> -		}
> +	media_device_for_each_intf(intf, mdev) {
> +		u16 idx = intf->graph_obj.topology_idx;
>  
>  		memset(&kintf, 0, sizeof(kintf));
>  
> @@ -298,6 +385,12 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  		kintf.id = intf->graph_obj.id;
>  		kintf.intf_type = intf->type;
>  		kintf.flags = intf->flags;
> +		if (!list_empty(&intf->links)) {
> +			link = list_first_entry(&intf->links,
> +						struct media_link, list);
> +			kintf.link_idx = link->graph_obj.topology_idx;
> +			kintf.flags |= MEDIA_INTF_FL_LINK_IDX;
> +		}
>  
>  		if (media_type(&intf->graph_obj) == MEDIA_GRAPH_INTF_DEVNODE) {
>  			struct media_intf_devnode *devnode;
> @@ -308,74 +401,115 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
>  			kintf.devnode.minor = devnode->minor;
>  		}
>  
> -		if (copy_to_user(uintf, &kintf, sizeof(kintf)))
> -			ret = -EFAULT;
> -		uintf++;
> +		if (copy_to_user(uintf + idx, &kintf, sizeof(kintf)))
> +			return -EFAULT;
>  	}
> -	topo->num_interfaces = i;
> -	topo->reserved2 = 0;
> +skip_interfaces:
>  
>  	/* Get pads and number of pads */
> -	i = 0;
>  	upad = media_get_uptr(topo->ptr_pads);
> -	media_device_for_each_pad(pad, mdev) {
> -		i++;
> -		if (ret || !upad)
> -			continue;
> +	if (!upad)
> +		goto skip_pads;
>  
> -		if (i > topo->num_pads) {
> -			ret = -ENOSPC;
> -			continue;
> -		}
> +	media_device_for_each_pad(pad, mdev) {
> +		u16 idx = pad->graph_obj.topology_idx;
>  
>  		memset(&kpad, 0, sizeof(kpad));
>  
>  		/* Copy pad fields to userspace struct */
>  		kpad.id = pad->graph_obj.id;
>  		kpad.entity_id = pad->entity->graph_obj.id;
> -		kpad.flags = pad->flags;
> +		kpad.entity_idx = pad->entity->graph_obj.topology_idx;
> +		kpad.flags = pad->flags | MEDIA_PAD_FL_ENTITY_IDX;
>  		kpad.index = pad->index;
>  
> -		if (copy_to_user(upad, &kpad, sizeof(kpad)))
> -			ret = -EFAULT;
> -		upad++;
> +		entity = pad->entity;
> +		list_for_each_entry(link, &entity->links, list) {
> +			if (link->source == pad) {
> +				kpad.link_idx = link->graph_obj.topology_idx;
> +				kpad.flags |= MEDIA_PAD_FL_LINK_IDX;
> +				break;
> +			}
> +		}
> +		if (!list_empty(&pad->props)) {
> +			prop = list_first_entry(&pad->props,
> +						struct media_prop, list);
> +			kpad.prop_idx = prop->graph_obj.topology_idx;
> +			kpad.flags |= MEDIA_PAD_FL_PROP_IDX;
> +		}
> +
> +		if (copy_to_user(upad + idx, &kpad, sizeof(kpad)))
> +			return -EFAULT;
>  	}
> -	topo->num_pads = i;
> -	topo->reserved3 = 0;
> +skip_pads:
>  
>  	/* Get links and number of links */
> -	i = 0;
>  	ulink = media_get_uptr(topo->ptr_links);
> -	media_device_for_each_link(link, mdev) {
> -		if (link->is_backlink)
> -			continue;
> -
> -		i++;
> +	if (!ulink)
> +		goto skip_links;
>  
> -		if (ret || !ulink)
> -			continue;
> +	media_device_for_each_link(link, mdev) {
> +		u16 idx;
>  
> -		if (i > topo->num_links) {
> -			ret = -ENOSPC;
> +		if (link->is_backlink)
>  			continue;
> -		}
> +		idx = link->graph_obj.topology_idx;
>  
>  		memset(&klink, 0, sizeof(klink));
>  
>  		/* Copy link fields to userspace struct */
>  		klink.id = link->graph_obj.id;
>  		klink.source_id = link->gobj0->id;
> +		klink.source_idx = link->gobj0->topology_idx;
>  		klink.sink_id = link->gobj1->id;
> -		klink.flags = link->flags;
> +		klink.sink_idx = link->gobj1->topology_idx;
> +		klink.flags = link->flags | MEDIA_LNK_FL_SOURCE_IDX |
> +					    MEDIA_LNK_FL_SINK_IDX;
>  
> -		if (copy_to_user(ulink, &klink, sizeof(klink)))
> -			ret = -EFAULT;
> -		ulink++;
> +		if (copy_to_user(ulink + idx, &klink, sizeof(klink)))
> +			return -EFAULT;
>  	}
> -	topo->num_links = i;
> -	topo->reserved4 = 0;
> +skip_links:
> +
> +	/* Get properties and number of properties */
> +	uprop = media_get_uptr(topo->ptr_props);
> +	if (!uprop)
> +		goto skip_props;
> +
> +	payload_offset = topo->num_props * sizeof(*uprop);
> +	media_device_for_each_prop(prop, mdev) {
> +		u16 idx = prop->graph_obj.topology_idx;
> +
> +		memset(&kprop, 0, sizeof(kprop));
> +
> +		/* Copy prop fields to userspace struct */
> +		kprop.id = prop->graph_obj.id;
> +		kprop.owner_id = prop->owner->id;
> +		kprop.owner_idx = prop->owner->topology_idx;
> +		kprop.type = prop->type;
> +		kprop.payload_size = prop->payload_size;
> +		if (prop->payload_size)
> +			kprop.payload_offset =
> +				payload_offset - idx * sizeof(*uprop);
> +		memcpy(kprop.name, prop->name, sizeof(kprop.name));
> +		kprop.flags = media_type(prop->owner);
> +		if (!list_empty(&prop->props)) {
> +			subprop = list_first_entry(&prop->props,
> +						   struct media_prop, list);
> +			kprop.prop_idx = subprop->graph_obj.topology_idx;
> +			kprop.flags |= MEDIA_PROP_FL_PROP_IDX;
> +		}
>  
> -	return ret;
> +		if (copy_to_user(uprop + idx, &kprop, sizeof(kprop)))
> +			return -EFAULT;
> +		if (copy_to_user((u8 __user *)uprop + payload_offset,
> +				 prop->payload, prop->payload_size))
> +			return -EFAULT;
> +		payload_offset += prop->payload_size;
> +	}
> +skip_props:
> +
> +	return 0;
>  }

Didn't review the above code, as, IMHO, it is a way more complex than
it should be.

>  
>  static long media_device_request_alloc(struct media_device *mdev,
> @@ -408,9 +542,10 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
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
> @@ -418,23 +553,33 @@ static long copy_arg_to_user(void __user *uarg, void *karg, unsigned int cmd)
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
> +static const unsigned int topo_alts[] = {
> +	/* Old MEDIA_IOC_G_TOPOLOGY without props support */
> +	MEDIA_IOC_G_TOPOLOGY_OLD,
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
> @@ -448,17 +593,29 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
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
> @@ -571,6 +728,16 @@ static void media_device_release(struct media_devnode *devnode)
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
> @@ -592,9 +759,8 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  	/* Warn if we apparently re-register an entity */
>  	WARN_ON(entity->graph_obj.mdev != NULL);

Side note: it would probably make sense to change the above to:

	if (WARN_ON(entity->graph_obj.mdev != NULL))
		return -EINVAL;

(if the WARN_ON still applies - see below)

>  	entity->graph_obj.mdev = mdev;
> -	INIT_LIST_HEAD(&entity->links);
> -	entity->num_links = 0;
> -	entity->num_backlinks = 0;
> +	if (!entity->inited)
> +		media_entity_init(entity);

Why to do such change?

If this can now be called twice, why are you keeping the WARN_ON()?

>  
>  	ret = ida_alloc_min(&mdev->entity_internal_idx, 1, GFP_KERNEL);
>  	if (ret < 0)
> @@ -608,10 +774,17 @@ int __must_check media_device_register_entity(struct media_device *mdev,
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
> @@ -640,6 +813,18 @@ int __must_check media_device_register_entity(struct media_device *mdev,
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
> @@ -661,8 +846,13 @@ static void __media_device_unregister_entity(struct media_entity *entity)
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
> @@ -701,6 +891,7 @@ void media_device_init(struct media_device *mdev)
>  	INIT_LIST_HEAD(&mdev->interfaces);
>  	INIT_LIST_HEAD(&mdev->pads);
>  	INIT_LIST_HEAD(&mdev->links);
> +	INIT_LIST_HEAD(&mdev->props);
>  	INIT_LIST_HEAD(&mdev->entity_notify);
>  
>  	mutex_init(&mdev->req_queue_mutex);
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 0b1cb3559140..dfd0073eae31 100644
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

Makes sense, but should probably be on a separate patch
(same applies to other similar debug patches below - for the existing
stuff).

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
> @@ -233,6 +251,66 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>  }
>  EXPORT_SYMBOL_GPL(media_entity_pads_init);
>  
> +static struct media_prop *media_create_prop(struct media_gobj *owner, u32 type,
> +		const char *name, const void *ptr, u32 payload_size)
> +{
> +	struct media_prop *prop = kzalloc(sizeof(*prop) + payload_size,
> +					  GFP_KERNEL);
> +
> +	if (!prop)
> +		return ERR_PTR(-ENOMEM);
> +	prop->type = type;
> +	strscpy(prop->name, name, sizeof(prop->name));
> +	if (owner->mdev)
> +		media_gobj_create(owner->mdev, MEDIA_GRAPH_PROP,
> +				  &prop->graph_obj);
> +	prop->owner = owner;
> +	prop->payload_size = payload_size;
> +	if (payload_size && ptr)
> +		memcpy(prop->payload, ptr, payload_size);
> +	INIT_LIST_HEAD(&prop->props);
> +	return prop;
> +}
> +
> +struct media_prop *media_entity_add_prop(struct media_entity *ent, u32 type,
> +		const char *name, const void *ptr, u32 payload_size)
> +{
> +	struct media_prop *prop;
> +
> +	if (!ent->inited)
> +		media_entity_init(ent);
> +	prop = media_create_prop(&ent->graph_obj, type,
> +				 name, ptr, payload_size);
> +	if (!IS_ERR(prop))
> +		list_add_tail(&prop->list, &ent->props);
> +	return prop;
> +}
> +EXPORT_SYMBOL_GPL(media_entity_add_prop);
> +
> +struct media_prop *media_pad_add_prop(struct media_pad *pad, u32 type,
> +		const char *name, const void *ptr, u32 payload_size)
> +{
> +	struct media_prop *prop = media_create_prop(&pad->graph_obj, type,
> +						name, ptr, payload_size);
> +
> +	if (!IS_ERR(prop))
> +		list_add_tail(&prop->list, &pad->props);
> +	return prop;
> +}
> +EXPORT_SYMBOL_GPL(media_pad_add_prop);
> +
> +struct media_prop *media_prop_add_prop(struct media_prop *prop, u32 type,
> +		const char *name, const void *ptr, u32 payload_size)
> +{
> +	struct media_prop *subprop = media_create_prop(&prop->graph_obj, type,
> +						name, ptr, payload_size);
> +
> +	if (!IS_ERR(subprop))
> +		list_add_tail(&subprop->list, &prop->props);
> +	return subprop;
> +}
> +EXPORT_SYMBOL_GPL(media_prop_add_prop);
> +
>  /* -----------------------------------------------------------------------------
>   * Graph traversal
>   */

My next comments apply to the code that starts here:

-----------------------------------

> @@ -618,14 +696,25 @@ EXPORT_SYMBOL_GPL(media_entity_put);
>   * Links management
>   */
>  
> -static struct media_link *media_add_link(struct list_head *head)
> +static struct media_link *media_add_link(struct list_head *head,
> +					 u16 pad, bool add_tail)
>  {
> -	struct media_link *link;
> +	struct media_link *link, *tmp;
>  
>  	link = kzalloc(sizeof(*link), GFP_KERNEL);
>  	if (link == NULL)
>  		return NULL;
>  
> +	if (add_tail) {
> +		list_add_tail(&link->list, head);
> +		return link;
> +	}
> +	list_for_each_entry(tmp, head, list) {
> +		if (tmp->source->index == pad) {
> +			list_add(&link->list, &tmp->list);
> +			return link;
> +		}
> +	}
>  	list_add_tail(&link->list, head);
>  
>  	return link;
> @@ -699,7 +788,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
>  	BUG_ON(source_pad >= source->num_pads);
>  	BUG_ON(sink_pad >= sink->num_pads);
>  
> -	link = media_add_link(&source->links);
> +	link = media_add_link(&source->links, source_pad, false);
>  	if (link == NULL)
>  		return -ENOMEM;
>  
> @@ -714,7 +803,7 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
>  	/* Create the backlink. Backlinks are used to help graph traversal and
>  	 * are not reported to userspace.
>  	 */
> -	backlink = media_add_link(&sink->links);
> +	backlink = media_add_link(&sink->links, 0, true);
>  	if (backlink == NULL) {
>  		__media_entity_remove_link(source, link);
>  		return -ENOMEM;
> @@ -998,7 +1087,7 @@ struct media_link *media_create_intf_link(struct media_entity *entity,
>  {
>  	struct media_link *link;
>  
> -	link = media_add_link(&intf->links);
> +	link = media_add_link(&intf->links, 0, true);
>  	if (link == NULL)
>  		return NULL;

Those hunks seem confusing to me... it doesn't sound directly related
to adding properties. Is it fixing a bug? What bug?

Anyway, it sounds better to split on a separate patch that would 
provide a better explanation about why this change is needed and
how it was implemented.

>  
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
> index e5f6960d92f6..2a8c2b22657b 100644
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
> @@ -65,6 +68,7 @@ enum media_gobj_type {
>  struct media_gobj {
>  	struct media_device	*mdev;
>  	u32			id;
> +	u16			topology_idx;
>  	struct list_head	list;
>  };
>  
> @@ -193,6 +197,7 @@ enum media_pad_signal_type {
>   * @flags:	Pad flags, as defined in
>   *		:ref:`include/uapi/linux/media.h <media_header>`
>   *		(seek for ``MEDIA_PAD_FL_*``)
> + * @props:	The list pad properties
>   */
>  struct media_pad {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
> @@ -200,6 +205,33 @@ struct media_pad {
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
> +	u32 type;
> +	u32 payload_size;
> +	struct list_head props;
> +	char name[32];
> +	u8 payload[];
>  };
>  
>  /**
> @@ -266,6 +298,7 @@ enum media_entity_type {
>   * @flags:	Entity flags, as defined in
>   *		:ref:`include/uapi/linux/media.h <media_header>`
>   *		(seek for ``MEDIA_ENT_FL_*``)
> + * @inited:	This struct was initialized.
>   * @num_pads:	Number of sink and source pads.
>   * @num_links:	Total number of links, forward and back, enabled and disabled.
>   * @num_backlinks: Number of backlinks
> @@ -273,6 +306,7 @@ enum media_entity_type {
>   *		re-used if entities are unregistered or registered again.
>   * @pads:	Pads array with the size defined by @num_pads.
>   * @links:	List of data links.
> + * @props:	List of entity properties.
>   * @ops:	Entity operations.
>   * @stream_count: Stream count for the entity.
>   * @use_count:	Use count for the entity.
> @@ -300,6 +334,7 @@ struct media_entity {
>  	enum media_entity_type obj_type;
>  	u32 function;
>  	unsigned long flags;
> +	bool inited;
>  
>  	u16 num_pads;
>  	u16 num_links;
> @@ -308,6 +343,7 @@ struct media_entity {
>  
>  	struct media_pad *pads;
>  	struct list_head links;
> +	struct list_head props;
>  
>  	const struct media_entity_operations *ops;
>  
> @@ -362,6 +398,20 @@ struct media_intf_devnode {
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

IMO, it would be a lot easier to understand the code if you
keep this at the C file.

>  /**
>   * media_entity_id() - return the media entity graph object id
>   *
> @@ -595,6 +645,15 @@ static inline bool media_entity_enum_intersects(
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
> @@ -775,6 +834,265 @@ int media_create_pad_links(const struct media_device *mdev,
>  
>  void __media_entity_remove_links(struct media_entity *entity);
>  
> +/**
> + * media_entity_add_prop() - Add property to entity
> + *
> + * @entity:	entity where to add the property
> + * @type:	property type
> + * @name:	property name
> + * @ptr:	property pointer to payload
> + * @payload_size: property payload size
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +struct media_prop *media_entity_add_prop(struct media_entity *ent, u32 type,
> +		const char *name, const void *ptr, u32 payload_size);
> +
> +/**
> + * media_pad_add_prop() - Add property to pad
> + *
> + * @pad:	pad where to add the property
> + * @type:	property type
> + * @name:	property name
> + * @ptr:	property pointer to payload
> + * @payload_size: property payload size
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +struct media_prop *media_pad_add_prop(struct media_pad *pad, u32 type,
> +		const char *name, const void *ptr, u32 payload_size);
> +
> +/**
> + * media_prop() - Add sub-property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @type:	sub-property type
> + * @name:	sub-property name
> + * @ptr:	sub-property pointer to payload
> + * @payload_size: sub-property payload size
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +struct media_prop *media_prop_add_prop(struct media_prop *prop, u32 type,
> +		const char *name, const void *ptr, u32 payload_size);
> +
> +/**
> + * media_entity_add_prop_group() - Add group property to entity
> + *
> + * @entity:	entity where to add the property
> + * @name:	property name
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +static inline struct media_prop *
> +media_entity_add_prop_group(struct media_entity *entity, const char *name)
> +{
> +	return media_entity_add_prop(entity, MEDIA_PROP_TYPE_GROUP,
> +				     name, NULL, 0);
> +}
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
> +	struct media_prop *prop =
> +		media_entity_add_prop(entity, MEDIA_PROP_TYPE_U64,
> +				      name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(prop);
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
> +	struct media_prop *prop =
> +		media_entity_add_prop(entity, MEDIA_PROP_TYPE_S64,
> +				      name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(prop);
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
> +	struct media_prop *prop =
> +		media_entity_add_prop(entity, MEDIA_PROP_TYPE_STRING,
> +				      name, string, strlen(string) + 1);
> +
> +	return PTR_ERR_OR_ZERO(prop);
> +}
> +
> +/**
> + * media_pad_add_prop_group() - Add group property to pad
> + *
> + * @pad:	pad where to add the property
> + * @name:	property name
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +static inline struct media_prop *media_pad_add_prop_group(struct media_pad *pad,
> +					   const char *name)
> +{
> +	return media_pad_add_prop(pad, MEDIA_PROP_TYPE_GROUP,
> +				  name, NULL, 0);
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
> +	struct media_prop *prop =
> +		media_pad_add_prop(pad, MEDIA_PROP_TYPE_U64,
> +				   name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(prop);
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
> +	struct media_prop *prop =
> +		media_pad_add_prop(pad, MEDIA_PROP_TYPE_S64,
> +				   name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(prop);
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
> +	struct media_prop *prop =
> +		media_pad_add_prop(pad, MEDIA_PROP_TYPE_STRING,
> +				   name, string, strlen(string) + 1);
> +
> +	return PTR_ERR_OR_ZERO(prop);
> +}
> +
> +/**
> + * media_prop_add_prop_group() - Add group sub-property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @name:	sub-property name
> + *
> + * Returns the new property on success, or an error pointer on failure.
> + */
> +static inline struct media_prop *
> +media_prop_add_prop_group(struct media_prop *prop, const char *name)
> +{
> +	return media_prop_add_prop(prop, MEDIA_PROP_TYPE_GROUP,
> +				  name, NULL, 0);
> +}
> +
> +/**
> + * media_prop_add_prop_u64() - Add u64 property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @name:	sub-property name
> + * @val:	sub-property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_prop_add_prop_u64(struct media_prop *prop,
> +					  const char *name, u64 val)
> +{
> +	struct media_prop *subprop =
> +		media_prop_add_prop(prop, MEDIA_PROP_TYPE_U64,
> +				    name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(subprop);
> +}
> +
> +/**
> + * media_prop_add_prop_s64() - Add s64 property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @name:	sub-property name
> + * @val:	sub-property value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_prop_add_prop_s64(struct media_prop *prop,
> +					  const char *name, s64 val)
> +{
> +	struct media_prop *subprop =
> +		media_prop_add_prop(prop, MEDIA_PROP_TYPE_S64,
> +				    name, &val, sizeof(val));
> +
> +	return PTR_ERR_OR_ZERO(subprop);
> +}
> +
> +/**
> + * media_prop_add_prop_string() - Add string property to property
> + *
> + * @prop:	property where to add the sub-property
> + * @name:	sub-property name
> + * @string:	sub-property string value
> + *
> + * Returns 0 on success, or an error on failure.
> + */
> +static inline int media_prop_add_prop_string(struct media_prop *prop,
> +					     const char *name,
> +					     const char *string)
> +{
> +	struct media_prop *subprop =
> +		media_prop_add_prop(prop, MEDIA_PROP_TYPE_STRING,
> +				    name, string, strlen(string) + 1);
> +
> +	return PTR_ERR_OR_ZERO(subprop);
> +}
> +
>  /**
>   * media_entity_remove_links() - remove all links associated with an entity
>   *



Thanks,
Mauro
