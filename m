Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:58489 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754219AbdIGMTE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Sep 2017 08:19:04 -0400
Subject: Re: [PATCH 1/1] media: Check for active and has_no_links overrun
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>
References: <20170829134640.7054-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <de9b504a-26d5-f681-7628-b8a2836403f0@xs4all.nl>
Date: Thu, 7 Sep 2017 14:18:59 +0200
MIME-Version: 1.0
In-Reply-To: <20170829134640.7054-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/17 15:46, Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
> 
> The active and has_no_links arrays will overrun in
> media_entity_pipeline_start() if there's an entity which has more than
> MEDIA_ENTITY_MAX_PAD pads. Ensure in media_entity_init() that there are
> fewer pads than that.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
>  drivers/media/media-entity.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index 2ace0410d277..f7c6d64e6031 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -214,12 +214,20 @@ void media_gobj_destroy(struct media_gobj *gobj)
>  	gobj->mdev = NULL;
>  }
>  
> +/*
> + * TODO: Get rid of this.
> + */
> +#define MEDIA_ENTITY_MAX_PADS		512
> +
>  int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
>  			   struct media_pad *pads)
>  {
>  	struct media_device *mdev = entity->graph_obj.mdev;
>  	unsigned int i;
>  
> +	if (num_pads >= MEDIA_ENTITY_MAX_PADS)
> +		return -E2BIG;
> +
>  	entity->num_pads = num_pads;
>  	entity->pads = pads;
>  
> @@ -280,11 +288,6 @@ static struct media_entity *stack_pop(struct media_graph *graph)
>  #define link_top(en)	((en)->stack[(en)->top].link)
>  #define stack_top(en)	((en)->stack[(en)->top].entity)
>  
> -/*
> - * TODO: Get rid of this.
> - */
> -#define MEDIA_ENTITY_MAX_PADS		512
> -
>  /**
>   * media_graph_walk_init - Allocate resources for graph walk
>   * @graph: Media graph structure that will be used to walk the graph
> 
