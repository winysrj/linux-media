Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59168 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3FRWDU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 18:03:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v3 1/3] media: added managed media entity initialization
Date: Wed, 19 Jun 2013 00:03:35 +0200
Message-ID: <2229025.9VJ8P9QgzO@avalon>
In-Reply-To: <1368692074-483-2-git-send-email-a.hajda@samsung.com>
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com> <1368692074-483-2-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thank you for the patch.

On Thursday 16 May 2013 10:14:32 Andrzej Hajda wrote:
> This patch adds managed versions of initialization
> function for media entity.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> v3:
> 	- removed managed cleanup
> ---
>  drivers/media/media-entity.c |   44 +++++++++++++++++++++++++++++++++++++++
>  include/media/media-entity.h |    5 +++++
>  2 files changed, 49 insertions(+)
> 
> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
> index e1cd132..b1e29a7 100644
> --- a/drivers/media/media-entity.c
> +++ b/drivers/media/media-entity.c
> @@ -82,9 +82,53 @@ void
>  media_entity_cleanup(struct media_entity *entity)
>  {
>  	kfree(entity->links);
> +	entity->links = NULL;
>  }
>  EXPORT_SYMBOL_GPL(media_entity_cleanup);
> 
> +static void devm_media_entity_release(struct device *dev, void *res)
> +{
> +	struct media_entity **entity = res;
> +
> +	media_entity_cleanup(*entity);
> +}
> +
> +/**
> + * devm_media_entity_init - managed media entity initialization
> + *
> + * @dev: Device for which @entity belongs to.
> + * @entity: Entity to be initialized.
> + * @num_pads: Total number of sink and source pads.
> + * @pads: Array of 'num_pads' pads.
> + * @extra_links: Initial estimate of the number of extra links.
> + *
> + * This is a managed version of media_entity_init. Entity initialized with
> + * this function will be automatically cleaned up on driver detach.
> + */
> +int
> +devm_media_entity_init(struct device *dev, struct media_entity *entity,
> +		       u16 num_pads, struct media_pad *pads, u16 extra_links)

What kind of users do you see for this function ? Aren't subdev drivers 
supposed to use the devm_* functions from patch 3/3 instead ? We should at 
least make it clear in the documentation that drivers must not use both 
devm_media_entity_init() and devm_v4l2_subdev_i2c_init().

> +{
> +	struct media_entity **dr;
> +	int rc;
> +
> +	dr = devres_alloc(devm_media_entity_release, sizeof(*dr), GFP_KERNEL);
> +	if (!dr)
> +		return -ENOMEM;
> +
> +	rc = media_entity_init(entity, num_pads, pads, extra_links);
> +	if (rc) {
> +		devres_free(dr);
> +		return rc;
> +	}
> +
> +	*dr = entity;
> +	devres_add(dev, dr);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devm_media_entity_init);
> +
>  /*
> ---------------------------------------------------------------------------
> -- * Graph traversal
>   */
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 0c16f51..e25730e 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -26,6 +26,8 @@
>  #include <linux/list.h>
>  #include <linux/media.h>
> 
> +struct device;
> +
>  struct media_pipeline {
>  };
> 
> @@ -126,6 +128,9 @@ int media_entity_init(struct media_entity *entity, u16
> num_pads, struct media_pad *pads, u16 extra_links);
>  void media_entity_cleanup(struct media_entity *entity);
> 
> +int devm_media_entity_init(struct device *dev, struct media_entity *entity,
> +		u16 num_pads, struct media_pad *pads, u16 extra_links);
> +
>  int media_entity_create_link(struct media_entity *source, u16 source_pad,
>  		struct media_entity *sink, u16 sink_pad, u32 flags);
>  int __media_entity_setup_link(struct media_link *link, u32 flags);
-- 
Regards,

Laurent Pinchart

