Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59815 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751842AbaK1RHc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Nov 2014 12:07:32 -0500
Date: Fri, 28 Nov 2014 19:06:56 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hans.verkuil@cisco.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 05/11] mediactl: Add media device graph helpers
Message-ID: <20141128170655.GO8907@valkosipuli.retiisi.org.uk>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
 <1416586480-19982-6-git-send-email-j.anaszewski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416586480-19982-6-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Fri, Nov 21, 2014 at 05:14:34PM +0100, Jacek Anaszewski wrote:
> Add new graph helpers useful for video pipeline discovering.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  utils/media-ctl/libmediactl.c |  174 +++++++++++++++++++++++++++++++++++++++++
>  utils/media-ctl/mediactl.h    |  121 ++++++++++++++++++++++++++++
>  2 files changed, 295 insertions(+)
> 
> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
> index af7dd43..a476601 100644
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
> @@ -87,6 +88,28 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
>  	return NULL;
>  }
>  
> +struct media_entity *media_get_entity_by_devname(struct media_device *media,
> +					      const char *devname, size_t length)
> +{
> +	unsigned int i;
> +
> +	/* A match is impossible if the entity devname is longer than the maximum

Over 80 characters per line.

> +	 * size we can get from the kernel.
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
> +
>  struct media_entity *media_get_entity_by_id(struct media_device *media,
>  					    __u32 id)
>  {
> @@ -145,6 +168,11 @@ const char *media_entity_get_devname(struct media_entity *entity)
>  	return entity->devname[0] ? entity->devname : NULL;
>  }
>  
> +const char *media_entity_get_name(struct media_entity *entity)
> +{
> +	return entity->info.name ? entity->info.name : NULL;

You could simply return entity->info.name.

> +}
> +
>  struct media_entity *media_get_default_entity(struct media_device *media,
>  					      unsigned int type)
>  {
> @@ -177,6 +205,152 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
>  	return &entity->info;
>  }
>  
> +int media_get_link_by_sink_pad(struct media_device *media,
> +				struct media_pad *pad,
> +				struct media_link **link)
> +{
> +	struct media_link *cur_link = NULL;
> +	int i, j;
> +
> +	if (pad == NULL || link == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < media->entities_count; ++i) {
> +		for (j = 0; j < media->entities[i].num_links; ++j) {
> +			cur_link = &media->entities[i].links[j];
> +			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
> +			    /* check if cur_link's sink entity matches the pad parent entity */
> +			    (cur_link->sink->entity->info.id == pad->entity->info.id) &&

Hmm. This looks harder than it should be. Would it be possible loop over the
array of links in struct media_entity instead, and look for a sink?

> +			    /* check if cur_link's sink pad id matches */
> +			    (cur_link->sink->index == pad->index)) {
> +				*link = cur_link;
> +				return 0;
> +			}
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +int media_get_link_by_source_pad(struct media_entity *entity,
> +				struct media_pad *pad,
> +				struct media_link **link)
> +{
> +	int i;
> +
> +	if (entity == NULL || pad == NULL || link == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < entity->num_links; ++i) {

...just like you do it here. :-)

> +		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
> +		    (entity->links[i].source->index == pad->index)) {
> +			*link = &entity->links[i];
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +int media_get_pads_by_entity(struct media_entity *entity, unsigned int type,

type should be flags, and flags uses __u32 type.

> +				struct media_pad **pads, int *num_pads)
> +{
> +	struct media_pad *entity_pads;
> +	int cnt_pads, i;
> +
> +	if (entity == NULL || pads == NULL || num_pads == NULL)
> +		return -EINVAL;
> +
> +	entity_pads = malloc(sizeof(*entity_pads));

How about allocating room for entity->info.pads pads, and then making it
smaller as needed?

> +	cnt_pads = 0;

You could use *num_pads instead of cnt_pads.

> +	for (i = 0; i < entity->info.pads; ++i) {
> +		if (entity->pads[i].flags & type) {
> +			entity_pads = realloc(entity_pads, (i + 1) *
> +					      sizeof(*entity_pads));
> +			entity_pads[cnt_pads++] = entity->pads[i];
> +		}
> +	}
> +
> +	if (cnt_pads == 0)
> +		free(entity_pads);
> +
> +	*pads = entity_pads;
> +	*num_pads = cnt_pads;
> +
> +	return 0;
> +}
> +
> +int media_get_busy_pads_by_entity(struct media_device *media,
> +				struct media_entity *entity,
> +				unsigned int type,
> +				struct media_pad **busy_pads,
> +				int *num_busy_pads)

Are you looking for enabled links that someone else would have configured
here?

I think we should have a more generic solution to that. This one still does
not guard against concurrent user space processes that attempt to configure
the media device.

One possibility would be to add IOCTLs to grant and release exclusive write
(i.e. change configuration) access to the device. Once streaming is started,
exclusive access could be released by the user. I wonder what Laurent would
think about that. I think this would be very robust --- one could start with
resetting all the links one can, and then configure those that are needed;
if this fails, then the pipeline is already used by someone else and
streaming cannot taken place on it. No cleanup of the configuration is
needed.

But this is definitely out of scope of this patchset (also because this is
for the user space).

> +{
> +	struct media_pad *bpads, *pads;
> +	struct media_link *link;
> +	int cnt_bpads = 0, num_pads, i, ret;
> +
> +	if (entity == NULL || busy_pads == NULL || num_busy_pads == NULL ||
> +	    (type == MEDIA_PAD_FL_SINK && media == NULL))
> +		return -EINVAL;
> +
> +	ret = media_get_pads_by_entity(entity, type, &pads, &num_pads);
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	if (num_pads == 0)
> +		goto done;
> +
> +	bpads = malloc(sizeof(*pads));
> +	if (bpads == NULL)
> +		goto error_ret;
> +
> +	for (i = 0; i < num_pads; ++i) {
> +		if (type == MEDIA_PAD_FL_SINK)
> +			ret = media_get_link_by_sink_pad(media, &pads[i], &link);
> +		else
> +			ret = media_get_link_by_source_pad(entity, &pads[i], &link);
> +		if (ret == 0) {
> +			bpads = realloc(bpads, (i + 1) *
> +						sizeof(*bpads));
> +			bpads[cnt_bpads++] = pads[i];
> +		}
> +	}
> +	if (num_pads > 0)
> +		free(pads);
> +
> +	if (cnt_bpads == 0)
> +		free(bpads);
> +
> +done:
> +	*busy_pads = bpads;
> +	*num_busy_pads = cnt_bpads;
> +
> +	return 0;
> +
> +error_ret:
> +	return -EINVAL;
> +}
> +
> +int media_get_pad_by_index(struct media_pad *pads, int num_pads,
> +				int index, struct media_pad *out_pad)
> +{
> +	int i;
> +
> +	if (pads == NULL || out_pad == NULL)
> +		return -EINVAL;
> +
> +	for (i = 0; i < num_pads; ++i) {
> +		if (pads[i].index == index) {
> +			*out_pad = pads[i];
> +			return 0;
> +		}
> +	}
> +
> +	return -EINVAL;
> +}
> +
>  /* -----------------------------------------------------------------------------
>   * Open/close
>   */
> diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
> index 7309b16..18a1e0e 100644
> --- a/utils/media-ctl/mediactl.h
> +++ b/utils/media-ctl/mediactl.h
> @@ -23,6 +23,7 @@
>  #define __MEDIA_H__
>  
>  #include <linux/media.h>
> +#include <sys/types.h>
>  
>  struct media_link {
>  	struct media_pad *source;
> @@ -231,6 +232,16 @@ const struct media_link *media_entity_get_link(struct media_entity *entity,
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
> +/**
>   * @brief Get the type of an entity.
>   * @param entity - the entity.
>   *
> @@ -255,6 +266,19 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
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
> @@ -435,6 +459,103 @@ int media_parse_setup_link(struct media_device *media,
>  int media_parse_setup_links(struct media_device *media, const char *p);
>  
>  /**
> + * @brief Get entity's pads of a given type
> + * @param entity - media entity
> + * @param type - pad type (MEDIA_PAD_FL_SINK or MEDIA_PAD_FL_SOURCE)
> + * @param pads - array of matching pads
> + * @param num_pads - number of matching pads
> + *
> + * Get only sink or source pads for an entity. The returned pads
> + * array has to be freed by the caller.
> + *
> + * @return 0 on success, or a negative error code on failure.
> + */
> +int media_get_pads_by_entity(struct media_entity *entity,
> +				unsigned int type,
> +				struct media_pad **pads,
> +				int *num_pads);
> +/**
> + * @brief Get occupied entity's pads of a given type
> + * @param media - media device
> + * @param entity - media entity
> + * @param type - pad type (MEDIA_PAD_FL_SINK or MEDIA_PAD_FL_SOURCE)
> + * @param busy_pads - array of matching pads
> + * @param num_busy_pads - number of matching pads
> + *
> + * Get only sink or source pads for an entity, with active links.
> + * The returned pads array has to be freed by the caller.
> + *
> + * @return 0 on success, or a negative error code on failure.
> + */
> +int media_get_busy_pads_by_entity(struct media_device *media,
> +				struct media_entity *entity,
> +				unsigned int type,
> +				struct media_pad **busy_pads,
> +				int *num_busy_pads);
> +
> +/**
> + * @brief Get link for  sink pad
> + * @param media - media device
> + * @param pad - pad to search the link for
> + * @param link - matching link
> + *
> + * Get the link connected to the entity's sink pad.
> + *
> + * @return 0 on success, or a negative error code on failure.
> + */
> +int media_get_link_by_sink_pad(struct media_device *media,
> +				struct media_pad *pad,
> +				struct media_link **link);
> +
> +/**
> + * @brief Get link for source pad
> + * @param entity - media entity
> + * @param pad - pad to search the link for
> + * @param link - matching link
> + *
> + * Get the link connected to the entity's source pad.
> + *
> + * @return 0 on success, or a negative error code on failure.
> + */
> +int media_get_link_by_source_pad(struct media_entity *entity,
> +				struct media_pad *pad,
> +				struct media_link **link);
> +
> +/**
> + * @brief Get pad with given index
> + * @param pads - array of pads
> + * @param num_pads - number of pads in the array
> + * @param index - index of a pad to search for
> + * @param out_pad - matching pad
> + *
> + * Get pad with given index from the given pads array.
> + *
> + * @return 0 on success, or a negative error code on failure.
> + */
> +int media_get_pad_by_index(struct media_pad *pads, int num_pads,
> +				int index, struct media_pad *out_pad);
> +
> +/**
> + * @brief Get source pad of the pipeline entity
> + * @param entity - media entity
> + *
> + * This function returns the source pad of the entity.
> + *
> + * @return entity source pad, or NULL if the entity is not linked.
> + */
> +int media_entity_get_src_pad_index(struct media_entity *entity);
> +
> +/**
> + * @brief Get sink pad of the pipeline entity
> + * @param entity - media entity
> + *
> + * This function returns the sink pad of the entity.
> + *
> + * @return entity sink pad, or NULL if the entity is not linked
> + */
> +int media_entity_get_sink_pad_index(struct media_entity *entity);
> +
> +/**
>   * @brief Get file descriptor of the entity sub-device
>   * @param entity - media entity
>   *

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
