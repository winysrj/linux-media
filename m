Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9702 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3FJK0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 06:26:52 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MO600IARAC6EP50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 10 Jun 2013 11:26:49 +0100 (BST)
Message-id: <51B5A9E6.20903@samsung.com>
Date: Mon, 10 Jun 2013 12:26:46 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hj210.choi@samsung.com, sw0312.kim@samsung.com,
	a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC PATCH v2 1/2] media: Add function removing all media entity
 links
References: <1368102573-16183-2-git-send-email-s.nawrocki@samsung.com>
 <1368180037-24091-1-git-send-email-s.nawrocki@samsung.com>
 <20130606194124.GB3103@valkosipuli.retiisi.org.uk>
 <51B4CB8D.1010507@gmail.com> <51B4FE9C.9020300@iki.fi>
In-reply-to: <51B4FE9C.9020300@iki.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 06/10/2013 12:15 AM, Sakari Ailus wrote:
> Sylwester Nawrocki wrote:
> ...
>>>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>>>> index e1cd132..bd85dc3 100644
>>>> --- a/drivers/media/media-entity.c
>>>> +++ b/drivers/media/media-entity.c
>>>> @@ -429,6 +429,57 @@ media_entity_create_link(struct media_entity
>>>> *source, u16 source_pad,
>>>>   }
>>>>   EXPORT_SYMBOL_GPL(media_entity_create_link);
>>>>
>>>> +void __media_entity_remove_links(struct media_entity *entity)
>>>> +{
>>>> +    int i, r;
>>>
>>> u16? r can be defined inside the loop.
>>
>> I would argue 'unsigned int' would be more optimal type for i in most
>> cases. Will move r inside the loop.
>>
>>>> +    for (i = 0; i<  entity->num_links; i++) {
>>>> +        struct media_link *link =&entity->links[i];
>>>> +        struct media_entity *remote;
>>>> +        int num_links;
>>>
>>> num_links is u16 in struct media_entity. I'd use the same type.
>>
>> I would go with 'unsigned int', as a more natural type for the CPU in
>> most cases. It's a minor issue, but I can't see how u16 would have been
>> more optimal than unsigned int for a local variable like this, while
>> this code is mostly used on 32-bit systems at least.
>>
>>>> +        if (link->source->entity == entity)
>>>> +            remote = link->sink->entity;
>>>> +        else
>>>> +            remote = link->source->entity;
>>>> +
>>>> +        num_links = remote->num_links;
>>>> +
>>>> +        for (r = 0; r<  num_links; r++) {
>>>
>>> Is caching remote->num_links needed, or do I miss something?
>>
>> Yes, it is needed, remote->num_links is decremented inside the loop.
> 
> Oh, forgot this one... yes, remote->num_links is decremented, but so is 
> r it's compared to. So I don't think it's necessary to cache it, but 
> it's neither an error to do so.

Indeed, it seems more correct to not cache it, thanks.

>>>> +            struct media_link *rlink =&remote->links[r];
>>>> +
>>>> +            if (rlink != link->reverse)
>>>> +                continue;
>>>> +
>>>> +            if (link->source->entity == entity)
>>>> +                remote->num_backlinks--;
>>>> +
>>>> +            remote->num_links--;
>>>> +
>>>> +            if (remote->num_links<  1)
>>>
>>> How about: if (!remote->num_links) ?
>>
>> Hmm, perhaps squashing the above two lines to:
>>
>>              if (--remote->num_links == 0)
>>
>> ?
> 
> I'm not too fond of --/++ operators as part of more complex structures 
> so I'd keep it separate. Fewer lines doesn't always equate to more 
> readable code. :-)

In general I agree, however it's quite simple statement in this case -
only decrement and test, it's often only one instruction even in the
assembly language...

I'm going to squash following to this patch:

diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index f5ea82e..1fb619d 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -436,18 +436,18 @@ void __media_entity_remove_links(struct media_entity *entity)
        for (i = 0; i < entity->num_links; i++) {
                struct media_link *link = &entity->links[i];
                struct media_entity *remote;
-               unsigned int r, num_links;
+               unsigned int r;

                if (link->source->entity == entity)
                        remote = link->sink->entity;
                else
                        remote = link->source->entity;

-               num_links = remote->num_links;
-
-               for (r = 0; r < num_links; r++) {
-                       if (remote->links[r] != link->reverse)
+               while (r < remote->num_links; r++) {
+                       if (remote->links[r] != link->reverse) {
+                               r++;
                                continue;
+                       }

                        if (link->source->entity == entity)
                                remote->num_backlinks--;
@@ -456,7 +456,7 @@ void __media_entity_remove_links(struct media_entity *entity)
                                break;

                        /* Insert last entry in place of the dropped link. */
-                       remote->links[r--] = remote->links[remote->num_links];
+                       remote->links[r] = remote->links[remote->num_links];
                }
        }

So the loop looks something like:


		while (r < remote->num_links) {
			if (remote->links[r] != link->reverse) {
				r++;
				continue;
			}

			if (link->source->entity == entity)
				remote->num_backlinks--;

			if (--remote->num_links == 0)
				break;

			/* Insert last entry in place of the dropped link. */
			remote->links[r] = remote->links[remote->num_links];
		}

Does it sound OK ?

Regards,
Sylwester

