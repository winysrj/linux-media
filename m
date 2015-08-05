Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:48293 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbbHEL1K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Aug 2015 07:27:10 -0400
Message-ID: <55C1F307.40805@xs4all.nl>
Date: Wed, 05 Aug 2015 13:27:03 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: media-workshop@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH_RFC_v1 2/4] media: Add a common embeed struct for all
 media graph objects
References: <cover.1438687440.git.mchehab@osg.samsung.com>	<3e0cf7e0a2feed17220b7580df2419d073fe8098.1438687440.git.mchehab@osg.samsung.com>	<55C0AF5C.1050307@xs4all.nl> <20150804102605.778fca38@recife.lan>
In-Reply-To: <20150804102605.778fca38@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/04/2015 03:26 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 04 Aug 2015 14:26:04 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>>
>>
>> On 08/04/2015 01:41 PM, Mauro Carvalho Chehab wrote:
>>> Due to the MC API proposed changes, we'll need to:
>>> 	- have an unique object ID for all graph objects;
>>> 	- be able to dynamically create/remove objects;
>>> 	- be able to group objects;
>>> 	- keep the object in memory until we stop use it.
>>>
>>> Due to that, create a struct media_graph_obj and put there the
>>> common elements that all media objects will have in common.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
>>> index 0c003d817493..faead169fe32 100644
>>> --- a/include/media/media-entity.h
>>> +++ b/include/media/media-entity.h
>>> @@ -27,11 +27,54 @@
>>>  #include <linux/kernel.h>
>>>  #include <linux/list.h>
>>>  #include <linux/media.h>
>>> +#include <linux/kref.h>
>>> +
>>> +/* Enums used internally at the media controller to represent graphs */
>>> +
>>> +/**
>>> + * enum media_graph_type - type of a graph element
>>> + *
>>> + * @MEDIA_GRAPH_ENTITY:		Identify a media entity
>>> + * @MEDIA_GRAPH_PAD:		Identify a media PAD
>>> + * @MEDIA_GRAPH_LINK:		Identify a media link
>>> + */
>>> +enum media_graph_type {
>>> +	MEDIA_GRAPH_ENTITY,
>>> +	MEDIA_GRAPH_PAD,
>>> +	MEDIA_GRAPH_LINK,
>>> +};
>>> +
>>> +
>>> +/* Structs to represent the objects that belong to a media graph */
>>> +
>>> +/**
>>> + * struct media_graph_obj - Define a graph object.
>>> + *
>>> + * @list:		List of media graph objects
>>> + * @obj_id:		Non-zero object ID identifier. The ID should be unique
>>> + *			inside a media_device
>>> + * @type:		Type of the graph object
>>> + * @mdev:		Media device that contains the object
>>> + * @kref:		pointer to struct kref, used to avoid destroying the
>>> + *			object before stopping using it
>>> + *
>>> + * All elements on the media graph should have this struct embedded
>>> + */
>>> +struct media_graph_obj {
>>> +	struct list_head	list;
>>> +	struct list_head	group;
>>> +	u32			obj_id;
>>> +	enum media_graph_type	type;
>>
>> I think that using the top 8 bits of the ID for the type and the lower 24 bits for
>> the ID is more efficient. I proposed this in my RFC.
> 
> Oh, somehow I missed it. I'll read and comment it in a few.
>>
>> The IDs are still unique, but you don't need to keep track of the type since that's
>> encoded in the ID. You'd need an array of MAX_TYPE atomics to get per-type unique IDs,
>> but that's trivial. 
> 
> That could be done, but I'm not sure about that. The code becomes a
> little more complex. The interface will also be more complex. We're
> already having enough complexity without that...

I don't really see why it would be more complex, to be honest.

> So, I would prefer to keep this in separate, at least for now. We
> can latter change it (of course before finishing the final interface).
> This is not a blocker to me, though.

My main concern is that in the new media_link struct we currently have the
two object IDs that are linked, but both userspace and kernelspace needs to
know the type of those objects as well. By encoding the type in the ID this
is O(1) to retrieve. If you have to look it up it will be O(log N) where N
is the number of objects. I really would like to avoid that, esp. when we
get audio graphs with 4000 objects or more.

So I think it should either be encoded in the ID, or it should be a separate
type field in the media_link struct (I'm talking about the userspace API here).
Either is fine by me, although I have a preference for encoding it in the ID
since it is more compact.

Regards,

	Hans

> 
> Maybe, for now, I can add one define to get object type. This way, we can
> easily replace the code latter to merge both ID and types into one u32. 
> Something like:
> 
> #define obj_type(gobj)	((gobj)->type)
> 
>> It also avoid the need for a connector flag since that would be
>> a distinct type (although using the same media_entity struct).
> 
> Well, this can be done anyway, no matter if we encap type/ID into a
> single u32 or not.
> 
> For me, a connector entity makes sense. It also makes sense, at least
> at Kernel level, to have more than one interface type, but I'll discuss
> that latter on, when I add the devnode interface at a new patch series.
> 
>> This is not a blocker for me, but I'd like to hear what others think.
>>
>> Otherwise this patch series looks OK.
> 
> Thanks for review!
> Mauro
> 
