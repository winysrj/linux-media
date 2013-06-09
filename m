Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40984 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3FISiK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 14:38:10 -0400
Received: by mail-bk0-f44.google.com with SMTP id r7so2987671bkg.17
        for <linux-media@vger.kernel.org>; Sun, 09 Jun 2013 11:38:08 -0700 (PDT)
Message-ID: <51B4CB8D.1010507@gmail.com>
Date: Sun, 09 Jun 2013 20:38:05 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC PATCH v2 1/2] media: Add function removing all media entity
 links
References: <1368102573-16183-2-git-send-email-s.nawrocki@samsung.com> <1368180037-24091-1-git-send-email-s.nawrocki@samsung.com> <20130606194124.GB3103@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130606194124.GB3103@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks a lot for the review.

On 06/06/2013 09:41 PM, Sakari Ailus wrote:
> Hi Sylwester,
>
> Thanks for the patch.
>
> On Fri, May 10, 2013 at 12:00:37PM +0200, Sylwester Nawrocki wrote:
>> This function allows to remove all media entity's links to other
>> entities, leaving no references to a media entity's links array
>> at its remote entities.
>>
>> Currently when a driver of some entity is removed it will free its
>> media entities links[] array, leaving dangling pointers at other
>> entities that are part of same media graph. This is troublesome when
>> drivers of a media device entities are in separate kernel modules,
>> removing only some modules will leave others in incorrect state.
>>
>> This function is intended to be used when an entity is being
>> unregistered from a media device.
>>
>> With an assumption that media links should be created only after
>> they are registered to a media device and with the graph mutex held.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Reviewed-by: Andrzej Hajda<a.hajda@samsung.com>
>> [locking error in the initial patch version]
>> Reported-by: Dan Carpenter<dan.carpenter@oracle.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>> Changes since the initial version:
>>   - fixed erroneous double mutex lock in media_entity_links_remove()
>>     function.
>>
>>   drivers/media/media-entity.c |   51 ++++++++++++++++++++++++++++++++++++++++++
>>   include/media/media-entity.h |    3 +++
>>   2 files changed, 54 insertions(+)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index e1cd132..bd85dc3 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -429,6 +429,57 @@ media_entity_create_link(struct media_entity *source, u16 source_pad,
>>   }
>>   EXPORT_SYMBOL_GPL(media_entity_create_link);
>>
>> +void __media_entity_remove_links(struct media_entity *entity)
>> +{
>> +	int i, r;
>
> u16? r can be defined inside the loop.

I would argue 'unsigned int' would be more optimal type for i in most
cases. Will move r inside the loop.

>> +	for (i = 0; i<  entity->num_links; i++) {
>> +		struct media_link *link =&entity->links[i];
>> +		struct media_entity *remote;
>> +		int num_links;
>
> num_links is u16 in struct media_entity. I'd use the same type.

I would go with 'unsigned int', as a more natural type for the CPU in
most cases. It's a minor issue, but I can't see how u16 would have been
more optimal than unsigned int for a local variable like this, while
this code is mostly used on 32-bit systems at least.

>> +		if (link->source->entity == entity)
>> +			remote = link->sink->entity;
>> +		else
>> +			remote = link->source->entity;
>> +
>> +		num_links = remote->num_links;
>> +
>> +		for (r = 0; r<  num_links; r++) {
>
> Is caching remote->num_links needed, or do I miss something?

Yes, it is needed, remote->num_links is decremented inside the loop.

>> +			struct media_link *rlink =&remote->links[r];
>> +
>> +			if (rlink != link->reverse)
>> +				continue;
>> +
>> +			if (link->source->entity == entity)
>> +				remote->num_backlinks--;
>> +
>> +			remote->num_links--;
>> +
>> +			if (remote->num_links<  1)
>
> How about: if (!remote->num_links) ?

Hmm, perhaps squashing the above two lines to:

			if (--remote->num_links == 0)

?
>> +				break;
>> +
>> +			/* Insert last entry in place of the dropped link. */
>> +			remote->links[r--] = remote->links[remote->num_links];
>> +		}
>> +	}
>> +
>> +	entity->num_links = 0;
>> +	entity->num_backlinks = 0;
>> +}
>> +EXPORT_SYMBOL_GPL(__media_entity_remove_links);
>> +
>> +void media_entity_remove_links(struct media_entity *entity)
>> +{
>> +	if (WARN_ON_ONCE(entity->parent == NULL))
>> +		return;

This WARN_ON_ONCE() is a bit problematic, I'm going to remove it in the 
next
iteration. I found that tracking entity->parent without races is not so
straightforward in drivers currently, and this needs to be taken care of
before we can have something like asynchronous subdevice registration.

>> +	mutex_lock(&entity->parent->graph_mutex);
>> +	__media_entity_remove_links(entity);
>> +	mutex_unlock(&entity->parent->graph_mutex);
>> +}
>> +EXPORT_SYMBOL_GPL(media_entity_remove_links);

Regards,
Sylwester
