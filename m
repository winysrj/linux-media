Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54516 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S936137AbcKXMlV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 07:41:21 -0500
Date: Thu, 24 Nov 2016 14:40:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4l-utils v7 3/7] mediactl: Add
 media_entity_get_backlinks()
Message-ID: <20161124124046.GH16630@valkosipuli.retiisi.org.uk>
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-4-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476282922-11544-4-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Oct 12, 2016 at 04:35:18PM +0200, Jacek Anaszewski wrote:
> Add a new graph helper useful for discovering video pipeline.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/media-ctl/libmediactl.c | 21 +++++++++++++++++++++
>  utils/media-ctl/mediactl.h    | 15 +++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> index 91ed003..155b65f 100644
> --- a/utils/media-ctl/libmediactl.c
> +++ b/utils/media-ctl/libmediactl.c
> @@ -36,6 +36,7 @@
>  #include <unistd.h>
>  
>  #include <linux/media.h>
> +#include <linux/kdev_t.h>

Is there something that needs this one in the patch?

>  #include <linux/videodev2.h>
>  
>  #include "mediactl.h"
> @@ -172,6 +173,26 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
>  	return &entity->info;
>  }
>  
> +int media_entity_get_backlinks(struct media_entity *entity,
> +				struct media_link **backlinks,
> +				unsigned int *num_backlinks)
> +{
> +	unsigned int num_bklinks = 0;
> +	int i;
> +
> +	if (entity == NULL || backlinks == NULL || num_backlinks == NULL)
> +		return -EINVAL;
> +

If you have an interface that accesses a memory buffer of unknown size, you
need to verify that the user has provided a buffer large enough.

How about using the num_backlinks argument to provide the maximum size to
the function, and passing the actual number to the user, the latter of which
you already do?

Alternatively, an iterator style API could be nice as well. Up to you.

I wonder what Laurent thinks.

> +	for (i = 0; i < entity->num_links; ++i)
> +		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
> +		    (entity->links[i].sink->entity == entity))
> +			backlinks[num_bklinks++] = &entity->links[i];
> +
> +	*num_backlinks = num_bklinks;
> +
> +	return 0;
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * Open/close
>   */
> diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
> index 336cbf9..b1f33cd 100644
> --- a/utils/media-ctl/mediactl.h
> +++ b/utils/media-ctl/mediactl.h
> @@ -434,6 +434,20 @@ int media_parse_setup_link(struct media_device *media,
>  int media_parse_setup_links(struct media_device *media, const char *p);
>  
>  /**
> + * @brief Get entity's enabled backlinks
> + * @param entity - media entity.
> + * @param backlinks - array of pointers to matching backlinks.
> + * @param num_backlinks - number of matching backlinks.
> + *
> + * Get links that are connected to the entity sink pads.
> + *
> + * @return 0 on success, or a negative error code on failure.
> + */
> +int media_entity_get_backlinks(struct media_entity *entity,
> +				struct media_link **backlinks,
> +				unsigned int *num_backlinks);
> +
> +/**
>   * @brief Get v4l2_subdev for the entity
>   * @param entity - media entity
>   *
> @@ -443,4 +457,5 @@ int media_parse_setup_links(struct media_device *media, const char *p);
>   */
>  struct v4l2_subdev *media_entity_get_v4l2_subdev(struct media_entity *entity);
>  
> +

Unrelated change.

>  #endif

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
