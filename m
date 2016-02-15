Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:9347 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbcBOMCI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2016 07:02:08 -0500
Subject: Re: [PATCH 05/15] mediactl: Add media device graph helpers
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, gjasny@googlemail.com,
	hdegoede@redhat.com, hverkuil@xs4all.nl
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
 <1453133860-21571-6-git-send-email-j.anaszewski@samsung.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <56C1BE3A.2090603@linux.intel.com>
Date: Mon, 15 Feb 2016 14:02:02 +0200
MIME-Version: 1.0
In-Reply-To: <1453133860-21571-6-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

Jacek Anaszewski wrote:
> Add new graph helpers useful for video pipeline discovering.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/media-ctl/libmediactl.c |   48 +++++++++++++++++++++++++++++++++++++++++
>  utils/media-ctl/mediactl.h    |   36 +++++++++++++++++++++++++++++++
>  2 files changed, 84 insertions(+)
> 
> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> index 61b5f50..0be1845 100644
> --- a/utils/media-ctl/libmediactl.c
> +++ b/utils/media-ctl/libmediactl.c
> @@ -35,6 +35,7 @@
>  #include <unistd.h>
>  
>  #include <linux/media.h>
> +#include <linux/kdev_t.h>
>  #include <linux/videodev2.h>
>  
>  #include "mediactl.h"
> @@ -87,6 +88,29 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
>  	return NULL;
>  }
>  
> +struct media_entity *media_get_entity_by_devname(struct media_device *media,
> +						 const char *devname,
> +						 size_t length)
> +{
> +	unsigned int i;
> +
> +	/* A match is impossible if the entity devname is longer than the
> +	 * maximum size we can get from the kernel.
> +	 */
> +	if (length >= FIELD_SIZEOF(struct media_entity, devname))
> +		return NULL;
> +
> +	for (i = 0; i < media->entities_count; ++i) {
> +		struct media_entity *entity = &media->entities[i];
> +
> +		if (strncmp(entity->devname, devname, length) == 0 &&
> +		    entity->devname[length] == '\0')
> +			return entity;
> +	}
> +
> +	return NULL;
> +}

Just out of curiosity: where do you need this? I.e. why do you need to
translate a device name to an entity?

> +
>  struct media_entity *media_get_entity_by_id(struct media_device *media,
>  					    __u32 id)
>  {
> @@ -145,6 +169,11 @@ const char *media_entity_get_devname(struct media_entity *entity)
>  	return entity->devname[0] ? entity->devname : NULL;
>  }
>  
> +const char *media_entity_get_name(struct media_entity *entity)
> +{
> +	return entity->info.name;
> +}

You should instead use media_get_info()->name . If you have an entity,
the return value will be valid.

> +
>  struct media_entity *media_get_default_entity(struct media_device *media,
>  					      unsigned int type)
>  {
> @@ -177,6 +206,25 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
>  	return &entity->info;
>  }
>  
> +int media_get_backlinks_by_entity(struct media_entity *entity,

How about calling this media_entity_get_backlinks()?

> +				struct media_link **backlinks,
> +				int *num_backlinks)

unsigned int.

> +{
> +	int num_bklinks = 0, i;

Same here.

> +
> +	if (entity == NULL || backlinks == NULL || num_backlinks == NULL)
> +		return -EINVAL;
> +
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
> index 3faee71..9db40a8 100644
> --- a/utils/media-ctl/mediactl.h
> +++ b/utils/media-ctl/mediactl.h
> @@ -231,6 +231,15 @@ const struct media_link *media_entity_get_link(struct media_entity *entity,
>  const char *media_entity_get_devname(struct media_entity *entity);
>  
>  /**
> + * @brief Get the name for an entity
> + * @param entity - media entity.
> + *
> + * This function returns the name of the entity.
> + *
> + * @return A pointer to the string with entity name
> + */
> +const char *media_entity_get_name(struct media_entity *entity);
> +
>   * @brief Get the type of an entity.
>   * @param entity - the entity.
>   *
> @@ -255,6 +264,19 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
>  	const char *name, size_t length);
>  
>  /**
> + * @brief Find an entity by the corresponding device node name.
> + * @param media - media device.
> + * @param devname - device node name.
> + * @param length - size of @a devname.
> + *
> + * Search for an entity with a device node name equal to @a devname.
> + *
> + * @return A pointer to the entity if found, or NULL otherwise.
> + */
> +struct media_entity *media_get_entity_by_devname(struct media_device *media,
> +	const char *devname, size_t length);
> +
> +/**
>   * @brief Find an entity by its ID.
>   * @param media - media device.
>   * @param id - entity ID.
> @@ -434,4 +456,18 @@ int media_parse_setup_link(struct media_device *media,
>   */
>  int media_parse_setup_links(struct media_device *media, const char *p);
>  
> +/**
> + * @brief Get entity's enabled backlinks
> + * @param entity - media entity.
> + * @param backlinks - array of pointers to matching backlinks.
> + * @param num_backlinks - number of matching backlinks.
> + *
> + * Get links that are connected to the entity sink pads.
> + *
> + * @return 0 on success, or a negative error code on failure.
> + */
> +int media_get_backlinks_by_entity(struct media_entity *entity,
> +				struct media_link **backlinks,
> +				int *num_backlinks);
> +
>  #endif
> 


-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
