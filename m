Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51754 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754112Ab3FFTl3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 6 Jun 2013 15:41:29 -0400
Date: Thu, 6 Jun 2013 22:41:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC PATCH v2 1/2] media: Add function removing all media entity
 links
Message-ID: <20130606194124.GB3103@valkosipuli.retiisi.org.uk>
References: <1368102573-16183-2-git-send-email-s.nawrocki@samsung.com>
 <1368180037-24091-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368180037-24091-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for the patch.

On Fri, May 10, 2013 at 12:00:37PM +0200, Sylwester Nawrocki wrote:
> This function allows to remove all media entity's links to other
> entities, leaving no references to a media entity's links array
> at its remote entities.
> 
> Currently when a driver of some entity is removed it will free its
> media entities links[] array, leaving dangling pointers at other
> entities that are part of same media graph. This is troublesome when
> drivers of a media device entities are in separate kernel modules,
> removing only some modules will leave others in incorrect state.
> 
> This function is intended to be used when an entity is being
> unregistered from a media device.
> 
> With an assumption that media links should be created only after
> they are registered to a media device and with the graph mutex held.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> [locking error in the initial patch version]
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since the initial version:
>  - fixed erroneous double mutex lock in media_entity_links_remove() 
>    function.
> 
>  drivers/media/media-entity.c |   51 ++++++++++++++++++++++++++++++++++++++++++
>  include/media/media-entity.h |    3 +++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index e1cd132..bd85dc3 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -429,6 +429,57 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
>  }
>  EXPORT_SYMBOL_GPL(media_entity_create_link);
>  
> +void __media_entity_remove_links(struct media_entity *entity)
> +{
> +	int i, r;

u16? r can be defined inside the loop.

> +	for (i = 0; i < entity->num_links; i++) {
> +		struct media_link *link = &entity->links[i];
> +		struct media_entity *remote;
> +		int num_links;

num_links is u16 in struct media_entity. I'd use the same type.

> +		if (link->source->entity == entity)
> +			remote = link->sink->entity;
> +		else
> +			remote = link->source->entity;
> +
> +		num_links = remote->num_links;
> +
> +		for (r = 0; r < num_links; r++) {

Is caching remote->num_links needed, or do I miss something?

> +			struct media_link *rlink = &remote->links[r];
> +
> +			if (rlink != link->reverse)
> +				continue;
> +
> +			if (link->source->entity == entity)
> +				remote->num_backlinks--;
> +
> +			remote->num_links--;
> +
> +			if (remote->num_links < 1)

How about: if (!remote->num_links) ?

> +				break;
> +
> +			/* Insert last entry in place of the dropped link. */
> +			remote->links[r--] = remote->links[remote->num_links];
> +		}
> +	}
> +
> +	entity->num_links = 0;
> +	entity->num_backlinks = 0;
> +}
> +EXPORT_SYMBOL_GPL(__media_entity_remove_links);
> +
> +void media_entity_remove_links(struct media_entity *entity)
> +{
> +	if (WARN_ON_ONCE(entity->parent == NULL))
> +		return;
> +
> +	mutex_lock(&entity->parent->graph_mutex);
> +	__media_entity_remove_links(entity);
> +	mutex_unlock(&entity->parent->graph_mutex);
> +}
> +EXPORT_SYMBOL_GPL(media_entity_remove_links);
> +
>  static int __media_entity_setup_link_notify(struct media_link *link, u32 flags)
>  {
>  	int ret;

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
