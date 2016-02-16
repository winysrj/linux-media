Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58511 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbcBPJTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 04:19:11 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O2M000EIV7XTY60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Feb 2016 09:19:09 +0000 (GMT)
Message-id: <56C2E98C.10107@samsung.com>
Date: Tue, 16 Feb 2016 10:19:08 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 08/15] mediactl: Add support for media device pipelines
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
 <1453133860-21571-9-git-send-email-j.anaszewski@samsung.com>
 <20160215165302.GC1639@paasikivi.fi.intel.com>
In-reply-to: <20160215165302.GC1639@paasikivi.fi.intel.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 02/15/2016 05:53 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Mon, Jan 18, 2016 at 05:17:33PM +0100, Jacek Anaszewski wrote:
>> Add infrastructure for linking media entities and discovering
>> media device pipelines.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   utils/media-ctl/libmediactl.c   |  117 +++++++++++++++++++++++++++++++++++++++
>>   utils/media-ctl/mediactl-priv.h |    6 ++
>>   utils/media-ctl/mediactl.h      |   71 ++++++++++++++++++++++++
>>   3 files changed, 194 insertions(+)
>>
>> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
>> index 3a45ecc..9909c1c 100644
>> --- a/utils/media-ctl/libmediactl.c
>> +++ b/utils/media-ctl/libmediactl.c
>> @@ -1109,3 +1109,120 @@ int media_parse_setup_links(struct media_device *media, const char *p)
>>
>>   	return *end ? -EINVAL : 0;
>>   }
>> +
>> +/* -----------------------------------------------------------------------------
>> + * Pipeline operations
>> + */
>> +
>> +int media_discover_pipeline_by_entity(struct media_device *media,
>> +				      struct media_entity *entity)
>> +{
>> +	struct media_entity *pipe_head = NULL;
>> +	struct media_pad *src_pad;
>> +	struct media_link *link = NULL, *backlinks[10];
>> +	int i, num_backlinks, ret;
>> +
>> +	if (entity == NULL)
>> +		return -EINVAL;
>> +
>> +	for (;;) {
>> +		/* Make recently discovered entity the pipeline head */
>> +		if (pipe_head == NULL) {
>> +			pipe_head = entity;
>> +		} else {
>> +			entity->next = pipe_head;
>> +			pipe_head = entity;
>> +		}
>> +
>> +		/* Cache a source pad used for linking the entity */
>> +		if (link)
>> +			entity->pipe_src_pad = link->source;
>> +
>> +		ret = media_get_backlinks_by_entity(entity,
>> +						    backlinks,
>> +						    &num_backlinks);
>> +		if (ret < 0)
>> +			return ret;
>> +
>> +		/* check if pipeline source entity has been reached */
>> +		if (num_backlinks > 2) {
>> +			media_dbg(media, "Unexpected number of busy sink pads (%d)\n", num_backlinks);
>> +			return -EINVAL;
>> +		} else if (num_backlinks == 2) {
>> +			/*
>> +			 * Allow two active pads only in case of
>> +			 * S5C73M3-OIF entity.
>> +			 */
>
> This piece of code appears to be too device specific to me to fit into
> libmediactl. Could it be put to the plugin instead?
>
> When it comes to automatically finding out a possible pipeline --- I don't
> think it's best fit for libmediactl. Nothing prevents adding a new library
> for that though.

OK, I'll move it to the plugin.

>
>> +			if (strcmp(entity->info.name, "S5C73M3-OIF")) {
>> +				media_dbg(media, "Ambiguous media device topology: two busy sink pads");
>> +				return -EINVAL;
>> +			}
>> +			/*
>> +			 * Two active links are allowed betwen S5C73M3-OIF and
>> +			 * S5C73M3 entities. In such a case a route through pad
>> +			 * with id == 0 has to be selected.
>> +			 */
>> +			for (i = 0; i < num_backlinks; i++)
>> +				if (backlinks[i]->sink->index == 0)
>> +					link = backlinks[i];
>> +		} else if (num_backlinks == 1)
>> +			link = backlinks[0];
>> +		else
>> +			break;
>> +
>> +		/* Cache a sink pad used for linking the entity */
>> +		entity->pipe_sink_pad = link->sink;
>> +
>> +		media_dbg(media, "Discovered sink pad %d for the %s entity\n",
>> +			  entity->pipe_sink_pad->index, media_entity_get_name(entity));
>> +
>> +		src_pad = media_entity_remote_source(link->sink);
>> +		if (!src_pad)
>> +			return -EINVAL;
>> +
>> +		entity = src_pad->entity;
>> +	}
>> +
>> +	media->pipeline = pipe_head;
>> +
>> +	return 0;
>> +}
>> +
>> +int media_has_pipeline_entity(struct media_entity *pipeline, char *entity_name)
>> +{
>> +	if (pipeline == NULL || entity_name == NULL)
>> +		return -EINVAL;
>> +
>> +	while (pipeline) {
>> +		if (!strncmp(pipeline->info.name, entity_name,
>> +			     strlen(entity_name)))
>> +			return 1;
>> +		pipeline = pipeline->next;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/* -----------------------------------------------------------------------------
>> + * Media entity access
>> + */
>> +
>> +struct media_entity *media_get_pipeline(struct media_device *media)
>> +{
>> +	return media->pipeline;
>> +}
>> +
>> +int media_entity_get_src_pad_index(struct media_entity *entity)
>> +{
>> +	return entity->pipe_src_pad->index;
>> +}
>> +
>> +int media_entity_get_sink_pad_index(struct media_entity *entity)
>> +{
>> +	return entity->pipe_sink_pad->index;
>> +}
>> +
>> +struct media_entity *media_entity_get_next(struct media_entity *entity)
>> +{
>> +	return entity->next;
>> +}
>> diff --git a/utils/media-ctl/mediactl-priv.h b/utils/media-ctl/mediactl-priv.h
>> index f531c52..3378880 100644
>> --- a/utils/media-ctl/mediactl-priv.h
>> +++ b/utils/media-ctl/mediactl-priv.h
>> @@ -36,9 +36,14 @@ struct media_entity {
>>   	unsigned int max_links;
>>   	unsigned int num_links;
>>
>> +	struct media_pad *pipe_src_pad;
>> +	struct media_pad *pipe_sink_pad;
>
> This suggests that a pipeline has to be linear. It's not uncommon to have
> non-linear pipelines these days.
>
> That said, supposing that the functionality is fully moved to another
> library, then one needs to somehow solve associating information specific to
> that library to entities.

Will be moved too.

>> +
>>   	struct v4l2_subdev *sd;
>>
>>   	char devname[32];
>> +
>> +	struct media_entity *next;
>
> If you stored the source / sink links instead, you could remove next (as
> it's link->sink->entity).
>
>>   };
>>
>>   struct media_device {
>> @@ -49,6 +54,7 @@ struct media_device {
>>   	struct media_device_info info;
>>   	struct media_entity *entities;
>>   	unsigned int entities_count;
>> +	struct media_entity *pipeline;
>
> This makes the assumption that there's only a single pipeline within the
> media device. Again, I don't think that's a sound generic assumption.
>
> This should go to the plugin instead.

OK.

>>
>>   	void (*debug_handler)(void *, ...);
>>   	void *debug_priv;
>> diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
>> index 1d62191..4570160 100644
>> --- a/utils/media-ctl/mediactl.h
>> +++ b/utils/media-ctl/mediactl.h
>> @@ -500,4 +500,75 @@ int media_get_backlinks_by_entity(struct media_entity *entity,
>>   				struct media_link **backlinks,
>>   				int *num_backlinks);
>>
>> +/**
>> + * @brief Check presence of the entity in the pipeline
>> + * @param pipeline - video pipeline within a media device.
>> + * @param entity_name - name of the entity to search for.
>> + *
>> + * Check if the entity with entity_name belongs to
>> + * the pipeline.
>> + *
>> + * @return 0 on success, or a negative error code on failure.
>> + */
>> +int media_has_pipeline_entity(struct media_entity *pipeline, char *entity_name);
>> +
>> +/**
>> + * @brief Discover the video pipeline
>> + * @param media - media device.
>> + * @param entity - media entity.
>> + *
>> + * Discover the pipeline of sub-devices, by walking
>> + * upstream starting from the passed sink entity until
>> + * the camera sensor entity is encountered.
>> + *
>> + * @return 0 on success, or a negative error code on failure.
>> + */
>> +int media_discover_pipeline_by_entity(struct media_device *media,
>> +				struct media_entity *entity);
>> +
>> +/**
>> + * @brief Get source pad of the pipeline entity
>> + * @param entity - media entity.
>> + *
>> + * This function returns the source pad of the entity.
>> + *
>> + * @return entity source pad, or NULL if the entity is not linked.
>> + */
>> +int media_entity_get_src_pad_index(struct media_entity *entity);
>> +
>> +/**
>> + * @brief Get sink pad of the pipeline entity
>> + * @param entity - media entity.
>> + *
>> + * This function returns the sink pad of the entity.
>> + *
>> + * @return entity sink pad, or NULL if the entity is not linked.
>> + */
>> +int media_entity_get_sink_pad_index(struct media_entity *entity);
>> +
>> +/**
>> + * @brief Get next entity in the pipeline
>> + * @param entity - media entity
>> + *
>> + * This function gets the entity connected to a source pad of this entity.
>> + *
>> + * @return next enetity in the pipeline,
>> + *	   or NULL if the entity is not linked
>> + */
>> +struct media_entity *media_entity_get_next(struct media_entity *entity);
>> +
>> +/**
>> + * @brief Get the video pipeline
>> + * @param media - media device
>> + *
>> + * This function gets the pipeline of media entities. The pipeline
>> + * source entity is a camera sensor and the sink one is the entity
>> + * representing opened video device node. The pipeline has to be
>> + * discovered with use of the function media_discover_pipeline_by_entity.
>> + *
>> + * @return first media_entity in the pipeline,
>> + *	   or NULL if the pipeline hasn't been discovered
>> + */
>> +struct media_entity *media_get_pipeline(struct media_device *media);
>> +
>>   #endif
>


-- 
Best regards,
Jacek Anaszewski
