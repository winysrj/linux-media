Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:34228 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752365AbbIKOqV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 10:46:21 -0400
Message-ID: <55F2E8F5.8050902@xs4all.nl>
Date: Fri, 11 Sep 2015 16:45:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v8 55/55] [media] media-entity.h: document all the structs
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <8943d6841f2278a0030fd1fdaee0a90a7e70385b.1441540862.git.mchehab@osg.samsung.com>
In-Reply-To: <8943d6841f2278a0030fd1fdaee0a90a7e70385b.1441540862.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/06/2015 02:03 PM, Mauro Carvalho Chehab wrote:
> Only a few structs are documented on kernel-doc-nano format
> (the ones added by the MC next gen patches).
> 
> Add a documentation for all structs, and ensure that they'll
> be producing the documentation at the Kernel's device driver
> DocBook.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

After correcting some typos (see below):

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index fb5f0e21f137..e1a89899deef 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -55,11 +55,13 @@ enum media_gobj_type {
>  /**
>   * struct media_gobj - Define a graph object.
>   *
> + * @mdev:	Pointer to the struct media_device that owns the object
>   * @id:		Non-zero object ID identifier. The ID should be unique
>   *		inside a media_device, as it is composed by
>   *		MEDIA_BITS_PER_TYPE to store the type plus
>   *		MEDIA_BITS_PER_LOCAL_ID	to store a per-type ID
>   *		(called as "local ID").
> + * @list:	Linked list associated to one of the per-type mdev object lists
>   *
>   * All objects on the media graph should have this struct embedded
>   */
> @@ -73,6 +75,28 @@ struct media_gobj {
>  struct media_pipeline {
>  };
>  
> +/**
> + * struct media_link - Define a media link graph object.
> + *
> + * @graph_obj:	Embedded structure containing the media object common data
> + * @list:	Linked list associated with an entity or an interface that
> + *		owns the link.
> + * @gobj0:	Part of an union. Used to get the pointer for the first

s/an union/a union/  (in multiple places)

See: https://answers.yahoo.com/question/index?qid=20081006092816AAvPO9n

> + *		graph_object of the link.
> + * @source:	Part of an union. Used only if the first object (gobj0) is
> + *		a pad. On such case, it represents the source pad.

s/On such case/In that case/  (in multiple places)

> + * @intf:	Part of an union. Used only if the first object (gobj0) is
> + *		an interface.
> + * @gobj1:	Part of an union. Used to get the pointer for the second
> + *		graph_object of the link.
> + * @source:	Part of an union. Used only if the second object (gobj0) is
> + *		a pad. On such case, it represents the sink pad.
> + * @entity:	Part of an union. Used only if the second object (gobj0) is
> + *		an entity.
> + * @reverse:	Pointer to the link for the reverse direction of a pad to pad
> + *		link.
> + * @flags:	Link flags, as defined at uapi/media.h (MEDIA_LNK_FL_*)

s/as defined at/as defined in/  (in multiple places)

> + */
>  struct media_link {
>  	struct media_gobj graph_obj;
>  	struct list_head list;
> @@ -86,15 +110,23 @@ struct media_link {
>  		struct media_pad *sink;
>  		struct media_entity *entity;
>  	};
> -	struct media_link *reverse;	/* Link in the reverse direction */
> -	unsigned long flags;		/* Link flags (MEDIA_LNK_FL_*) */
> +	struct media_link *reverse;
> +	unsigned long flags;
>  };
>  
> +/**
> + * struct media_pad - Define a media pad graph object.
> + *
> + * @graph_obj:	Embedded structure containing the media object common data
> + * @entity:	Entity where this object belongs
> + * @index:	Pad index in the entity pads array, numbered from 0 to n
> + * @flags:	Pad flags, as defined at uapi/media.h (MEDIA_PAD_FL_*)
> + */
>  struct media_pad {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
> -	struct media_entity *entity;	/* Entity this pad belongs to */
> -	u16 index;			/* Pad index in the entity pads array */
> -	unsigned long flags;		/* Pad flags (MEDIA_PAD_FL_*) */
> +	struct media_entity *entity;
> +	u16 index;
> +	unsigned long flags;
>  };
>  
>  /**
> @@ -113,51 +145,73 @@ struct media_entity_operations {
>  	int (*link_validate)(struct media_link *link);
>  };
>  
> +/**
> + * struct media_entity - Define a media entity graph object.
> + *
> + * @graph_obj:	Embedded structure containing the media object common data.
> + * @name:	Entity name.
> + * @type:	Entity type, as defined at uapi/media.h (MEDIA_ENT_T_*)
> + * @revision:	Entity revision - OBSOLETE - should be removed soon.
> + * @flags:	Entity flags, as defined at uapi/media.h (MEDIA_ENT_FL_*)
> + * @group_id:	Entity group ID - OBSOLETE - should be removed soon.
> + * @num_pads:	Number of sink and source pads.
> + * @num_links:	Number of existing links, both enabled and disabled.
> + * @num_backlinks: Number of backlinks
> + * @pads:	Pads array with the size defined by @num_pads.
> + * @links:	Linked list for the data links.
> + * @ops:	Entity operations.
> + * @stream_count: Stream count for the entity.
> + * @use_count:	Use count for the entity.
> + * @pipe:	Pipeline this entity belongs to.
> + * @info:	Union with devnode information.  Kept just for backward
> + * 		compatibility.
> + * @major:	Devnode major number (zero if not applicable). Kept just
> + * 		for backward compatibility.
> + * @minor:	Devnode minor number (zero if not applicable). Kept just
> + * 		for backward compatibility.
> + *
> + * NOTE: @stream_count and @use_count reference counts must never be
> + * negative, but are signed integers on purpose: a simple WARN_ON(<0) check
> + * can be used to detect reference count bugs that would make them negative.
> + */
>  struct media_entity {
>  	struct media_gobj graph_obj;	/* must be first field in struct */
> -	const char *name;		/* Entity name */
> -	u32 type;			/* Entity type (MEDIA_ENT_T_*) */
> -	u32 revision;			/* Entity revision, driver specific */
> -	unsigned long flags;		/* Entity flags (MEDIA_ENT_FL_*) */
> -	u32 group_id;			/* Entity group ID */
> +	const char *name;
> +	u32 type;
> +	u32 revision;
> +	unsigned long flags;
> +	u32 group_id;
>  
> -	u16 num_pads;			/* Number of sink and source pads */
> -	u16 num_links;			/* Number of existing links, both
> -					 * enabled and disabled */
> -	u16 num_backlinks;		/* Number of backlinks */
> +	u16 num_pads;
> +	u16 num_links;
> +	u16 num_backlinks;
>  
> -	struct media_pad *pads;		/* Pads array (num_pads objects) */
> -	struct list_head links;		/* Pad-to-pad links list */
> +	struct media_pad *pads;
> +	struct list_head links;
>  
> -	const struct media_entity_operations *ops;	/* Entity operations */
> +	const struct media_entity_operations *ops;
>  
>  	/* Reference counts must never be negative, but are signed integers on
>  	 * purpose: a simple WARN_ON(<0) check can be used to detect reference
>  	 * count bugs that would make them negative.
>  	 */
> -	int stream_count;		/* Stream count for the entity. */
> -	int use_count;			/* Use count for the entity. */
> +	int stream_count;
> +	int use_count;
>  
> -	struct media_pipeline *pipe;	/* Pipeline this entity belongs to. */
> +	struct media_pipeline *pipe;
>  
>  	union {
> -		/* Node specifications */
>  		struct {
>  			u32 major;
>  			u32 minor;
>  		} dev;
> -
> -		/* Sub-device specifications */
> -		/* Nothing needed yet */
>  	} info;
>  };
>  
>  /**
> - * struct media_interface - Define a Kernel API interface
> + * struct media_interface - Define a media interface graph object
>   *
>   * @graph_obj:		embedded graph object
> - * @list:		Linked list used to find other interfaces that belong
> - *			to the same media controller
>   * @links:		List of links pointing to graph entities
>   * @type:		Type of the interface as defined at the
>   *			uapi/media/media.h header, e. g.
> @@ -177,7 +231,7 @@ struct media_interface {
>  };
>  
>  /**
> - * struct media_intf_devnode - Define a Kernel API interface via a device node
> + * struct media_intf_devnode - Define a media interface via a device node
>   *
>   * @intf:	embedded interface object
>   * @major:	Major number of a device node
> 

Regards,

	Hans
