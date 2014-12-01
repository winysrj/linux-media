Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46541 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaLALXU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 06:23:20 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFW00HAGIFDR470@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 01 Dec 2014 11:26:01 +0000 (GMT)
Message-id: <547C4FA3.30605@samsung.com>
Date: Mon, 01 Dec 2014 12:23:15 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hans.verkuil@cisco.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC v4 05/11] mediactl: Add media device graph helpers
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
 <1416586480-19982-6-git-send-email-j.anaszewski@samsung.com>
 <20141128170655.GO8907@valkosipuli.retiisi.org.uk>
In-reply-to: <20141128170655.GO8907@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for a review.

On 11/28/2014 06:06 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Fri, Nov 21, 2014 at 05:14:34PM +0100, Jacek Anaszewski wrote:
>> Add new graph helpers useful for video pipeline discovering.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>   utils/media-ctl/libmediactl.c |  174 +++++++++++++++++++++++++++++++++++++++++
>>   utils/media-ctl/mediactl.h    |  121 ++++++++++++++++++++++++++++
>>   2 files changed, 295 insertions(+)
>>
>> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
>> index af7dd43..a476601 100644
>> --- a/utils/media-ctl/libmediactl.c
>> +++ b/utils/media-ctl/libmediactl.c
>> @@ -35,6 +35,7 @@
>>   #include <unistd.h>
>>
>>   #include <linux/media.h>
>> +#include <linux/kdev_t.h>
>>   #include <linux/videodev2.h>
>>
>>   #include "mediactl.h"
>> @@ -87,6 +88,28 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
>>   	return NULL;
>>   }
>>
>> +struct media_entity *media_get_entity_by_devname(struct media_device *media,
>> +					      const char *devname, size_t length)
>> +{
>> +	unsigned int i;
>> +
>> +	/* A match is impossible if the entity devname is longer than the maximum
>
> Over 80 characters per line.
>
>> +	 * size we can get from the kernel.
>> +	 */
>> +	if (length >= FIELD_SIZEOF(struct media_entity, devname))
>> +		return NULL;
>> +
>> +	for (i = 0; i < media->entities_count; ++i) {
>> +		struct media_entity *entity = &media->entities[i];
>> +
>> +		if (strncmp(entity->devname, devname, length) == 0 &&
>> +		    entity->devname[length] == '\0')
>> +			return entity;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>>   struct media_entity *media_get_entity_by_id(struct media_device *media,
>>   					    __u32 id)
>>   {
>> @@ -145,6 +168,11 @@ const char *media_entity_get_devname(struct media_entity *entity)
>>   	return entity->devname[0] ? entity->devname : NULL;
>>   }
>>
>> +const char *media_entity_get_name(struct media_entity *entity)
>> +{
>> +	return entity->info.name ? entity->info.name : NULL;
>
> You could simply return entity->info.name.

Right.

>> +}
>> +
>>   struct media_entity *media_get_default_entity(struct media_device *media,
>>   					      unsigned int type)
>>   {
>> @@ -177,6 +205,152 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
>>   	return &entity->info;
>>   }
>>
>> +int media_get_link_by_sink_pad(struct media_device *media,
>> +				struct media_pad *pad,
>> +				struct media_link **link)
>> +{
>> +	struct media_link *cur_link = NULL;
>> +	int i, j;
>> +
>> +	if (pad == NULL || link == NULL)
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < media->entities_count; ++i) {
>> +		for (j = 0; j < media->entities[i].num_links; ++j) {
>> +			cur_link = &media->entities[i].links[j];
>> +			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
>> +			    /* check if cur_link's sink entity matches the pad parent entity */
>> +			    (cur_link->sink->entity->info.id == pad->entity->info.id) &&
>
> Hmm. This looks harder than it should be. Would it be possible loop over the
> array of links in struct media_entity instead, and look for a sink?

I thought that the entity has only outbound links as it is in case of
MEDIA_IOC_ENUM_LINKS ioctl, but it seems that it has also the
inbound ones. Nice.

>> +			    /* check if cur_link's sink pad id matches */
>> +			    (cur_link->sink->index == pad->index)) {
>> +				*link = cur_link;
>> +				return 0;
>> +			}
>> +		}
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +int media_get_link_by_source_pad(struct media_entity *entity,
>> +				struct media_pad *pad,
>> +				struct media_link **link)
>> +{
>> +	int i;
>> +
>> +	if (entity == NULL || pad == NULL || link == NULL)
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < entity->num_links; ++i) {
>
> ...just like you do it here. :-)
>
>> +		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
>> +		    (entity->links[i].source->index == pad->index)) {
>> +			*link = &entity->links[i];
>> +			return 0;
>> +		}
>> +	}
>> +
>> +	return -EINVAL;
>> +}
>> +
>> +int media_get_pads_by_entity(struct media_entity *entity, unsigned int type,
>
> type should be flags, and flags uses __u32 type.
>
>> +				struct media_pad **pads, int *num_pads)
>> +{
>> +	struct media_pad *entity_pads;
>> +	int cnt_pads, i;
>> +
>> +	if (entity == NULL || pads == NULL || num_pads == NULL)
>> +		return -EINVAL;
>> +
>> +	entity_pads = malloc(sizeof(*entity_pads));
>
> How about allocating room for entity->info.pads pads, and then making it
> smaller as needed?

Sounds reasonable.

>> +	cnt_pads = 0;
>
> You could use *num_pads instead of cnt_pads.
>
>> +	for (i = 0; i < entity->info.pads; ++i) {
>> +		if (entity->pads[i].flags & type) {
>> +			entity_pads = realloc(entity_pads, (i + 1) *
>> +					      sizeof(*entity_pads));
>> +			entity_pads[cnt_pads++] = entity->pads[i];
>> +		}
>> +	}
>> +
>> +	if (cnt_pads == 0)
>> +		free(entity_pads);
>> +
>> +	*pads = entity_pads;
>> +	*num_pads = cnt_pads;
>> +
>> +	return 0;
>> +}
>> +
>> +int media_get_busy_pads_by_entity(struct media_device *media,
>> +				struct media_entity *entity,
>> +				unsigned int type,
>> +				struct media_pad **busy_pads,
>> +				int *num_busy_pads)
>
> Are you looking for enabled links that someone else would have configured
> here?

The assumption is made here that there will be no concurrent users of
a media device and an entity will have no more than one link connected
to its sink pad. If this assumption is not valid than all the links
in the pipeline would have to be defined in the media config and
the pipeline would have to be only validated not discovered.
By pipeline validation I mean checking whether all config links are
enabled

> I think we should have a more generic solution to that. This one still does
> not guard against concurrent user space processes that attempt to configure
> the media device.
> One possibility would be to add IOCTLs to grant and release exclusive write
> (i.e. change configuration) access to the device. Once streaming is started,
> exclusive access could be released by the user. I wonder what Laurent would
> think about that. I think this would be very robust --- one could start with
> resetting all the links one can, and then configure those that are needed;
> if this fails, then the pipeline is already used by someone else and
> streaming cannot taken place on it. No cleanup of the configuration is
> needed.

This approach would preclude having more than one pipeline configured
in a media device.

> But this is definitely out of scope of this patchset (also because this is
> for the user space).

Taking into account that there are cases when it would be useful
to allow for having more than one active pipelines in a media device
I think that we would require changes in the media controller API.

I would hide from the user a possibility of reconfiguring the links
one by one, but instead provide an ioctl which would accept
a definition of a whole pipeline to be linked. Something
similar to extended controls.
A user space process calling such an ioctl would take the ownership
of the all involved sub-devices, and their linkage couldn't be
reconfigured until released.

Best Regards,
Jacek Anaszewski
