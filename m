Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46230 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965480AbcKXOAv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Nov 2016 09:00:51 -0500
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OH500B3TG9CWP10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2016 14:00:48 +0000 (GMT)
Subject: Re: [PATCH v4l-utils v7 3/7] mediactl: Add media_entity_get_backlinks()
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, mchehab@kernel.org, m.szyprowski@samsung.com,
        s.nawrocki@samsung.com, laurent.pinchart@ideasonboard.com
From: Jacek Anaszewski <j.anaszewski@samsung.com>
Message-id: <b96fdac8-6e9d-b758-22f9-592aaa624bc0@samsung.com>
Date: Thu, 24 Nov 2016 15:00:46 +0100
MIME-version: 1.0
In-reply-to: <20161124124046.GH16630@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <1476282922-11544-1-git-send-email-j.anaszewski@samsung.com>
 <1476282922-11544-4-git-send-email-j.anaszewski@samsung.com>
 <CGME20161124124125epcas4p17ad5ee584d92f73a8762fa72ade9101c@epcas4p1.samsung.com>
 <20161124124046.GH16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On 11/24/2016 01:40 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, Oct 12, 2016 at 04:35:18PM +0200, Jacek Anaszewski wrote:
>> Add a new graph helper useful for discovering video pipeline.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  utils/media-ctl/libmediactl.c | 21 +++++++++++++++++++++
>>  utils/media-ctl/mediactl.h    | 15 +++++++++++++++
>>  2 files changed, 36 insertions(+)
>>
>> diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
>> index 91ed003..155b65f 100644
>> --- a/utils/media-ctl/libmediactl.c
>> +++ b/utils/media-ctl/libmediactl.c
>> @@ -36,6 +36,7 @@
>>  #include <unistd.h>
>>
>>  #include <linux/media.h>
>> +#include <linux/kdev_t.h>
>
> Is there something that needs this one in the patch?

MAJOR and MINOR macros.

>
>>  #include <linux/videodev2.h>
>>
>>  #include "mediactl.h"
>> @@ -172,6 +173,26 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
>>  	return &entity->info;
>>  }
>>
>> +int media_entity_get_backlinks(struct media_entity *entity,
>> +				struct media_link **backlinks,
>> +				unsigned int *num_backlinks)
>> +{
>> +	unsigned int num_bklinks = 0;
>> +	int i;
>> +
>> +	if (entity == NULL || backlinks == NULL || num_backlinks == NULL)
>> +		return -EINVAL;
>> +
>
> If you have an interface that accesses a memory buffer of unknown size, you
> need to verify that the user has provided a buffer large enough.
>
> How about using the num_backlinks argument to provide the maximum size to
> the function, and passing the actual number to the user, the latter of which
> you already do?

Sounds reasonable.

> Alternatively, an iterator style API could be nice as well. Up to you.

It would probably need an addition of some generic infrastructure.
I suppose that there is no such a feature in v4l-utils?

>
> I wonder what Laurent thinks.
>
>> +	for (i = 0; i < entity->num_links; ++i)
>> +		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
>> +		    (entity->links[i].sink->entity == entity))
>> +			backlinks[num_bklinks++] = &entity->links[i];
>> +
>> +	*num_backlinks = num_bklinks;
>> +
>> +	return 0;
>> +}
>> +
>>  /* -----------------------------------------------------------------------------
>>   * Open/close
>>   */
>> diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
>> index 336cbf9..b1f33cd 100644
>> --- a/utils/media-ctl/mediactl.h
>> +++ b/utils/media-ctl/mediactl.h
>> @@ -434,6 +434,20 @@ int media_parse_setup_link(struct media_device *media,
>>  int media_parse_setup_links(struct media_device *media, const char *p);
>>
>>  /**
>> + * @brief Get entity's enabled backlinks
>> + * @param entity - media entity.
>> + * @param backlinks - array of pointers to matching backlinks.
>> + * @param num_backlinks - number of matching backlinks.
>> + *
>> + * Get links that are connected to the entity sink pads.
>> + *
>> + * @return 0 on success, or a negative error code on failure.
>> + */
>> +int media_entity_get_backlinks(struct media_entity *entity,
>> +				struct media_link **backlinks,
>> +				unsigned int *num_backlinks);
>> +
>> +/**
>>   * @brief Get v4l2_subdev for the entity
>>   * @param entity - media entity
>>   *
>> @@ -443,4 +457,5 @@ int media_parse_setup_links(struct media_device *media, const char *p);
>>   */
>>  struct v4l2_subdev *media_entity_get_v4l2_subdev(struct media_entity *entity);
>>
>> +
>
> Unrelated change.
>
>>  #endif
>


-- 
Best regards,
Jacek Anaszewski
