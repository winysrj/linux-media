Return-Path: <SRS0=yFxv=OW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,T_MIXED_ES autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9FCC67839
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5093D2075B
	for <linux-media@archiver.kernel.org>; Thu, 13 Dec 2018 09:29:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5093D2075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbeLMJ3N (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:29:13 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:32820 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbeLMJ3N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Dec 2018 04:29:13 -0500
Received: from [IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6] ([IPv6:2001:983:e9a7:1:8c39:f7d7:e233:2ba6])
        by smtp-cloud8.xs4all.net with ESMTPA
        id XNIrgqhJhuDWoXNIsgMZkt; Thu, 13 Dec 2018 10:29:11 +0100
Subject: Re: [RFCv4 PATCH 0/3] This RFC patch series implements properties for
 the media controller.
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
 <20181212055854.0a92c404@coco.lan>
 <2fde46aa-c5e3-7163-2b0e-ecfac26a6a51@xs4all.nl>
 <20181212183218.6e9abc2f@coco.lan>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <365959e7-eda6-6036-a278-861b86e831d6@xs4all.nl>
Date:   Thu, 13 Dec 2018 10:29:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181212183218.6e9abc2f@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHQSJIxlzoUB0rfq/5ZE6Y09hwcgjEw5aq5vOSvtM+FRlSTz/EGGdmeWPpnLus+txVJ+gBCelMSv6wiZuy/SKcfbP0JN6mRIYtpHinyXNYX2UZR0EyJn
 f8OvaQJzALOmiYyRNRy5yg8AiuQMZahoD+6w9PV/NXIW6ib46k6B3my30ZpjkXZk0KDX/tSLpVI28nDkgpdvlx1xY2gmuijOcGrYW4wgIfJ6H17YzIA0sh3c
 e39JIb1VK8PZhfv2JmKavCTFys3dJijWaU/B7K8+8stwvZ1IR5O/j5KR1Mw/yI7YexvejMAsVUWuy13sFWk5ZQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/12/18 9:32 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 12 Dec 2018 09:27:17 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 12/12/18 8:58 AM, Mauro Carvalho Chehab wrote:
>>> Hi Hans,
>>>
>>> Em Wed, 21 Nov 2018 16:40:21 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>   
>>>> The main changes since RFCv3 are:
>>>>
>>>> - Add entity index to media_v2_pad
>>>> - Add source/sink pad index to media_v2_link
>>>> - Add owner_idx and owner type flags to media_v2_prop  
>>>
>>> Sorry, but I didn't get why this is needed for properties to work
>>> (if the changes are not directly related to properties, please add
>>> on separate patches, in order to make easier for review/understanding).  
>>
>> I can separate it.
>>
>>> The lack of an uAPI documentation at the patchset makes it harder
>>> to understand.
>>>
>>> For the last one, you added a documentation at kAPI:
>>>   
>>>> + * @owner_idx:	Index to entities/pads/properties, depending on the owner ID
>>>> + *		type.  
>>>
>>> But it doesn't really explain anything. Is it the new owner_id
>>> field? Is it something else? Why do we need bot owner_id and 
>>> owner_idx?  
>>
>> Currently when G_TOPOLOGY returns e.g. a link it has two IDs: one
>> for the sink object, one for the source object. The application now
>> has to traverse the entities array to find the entities referred to
>> by the link IDs.
> 
> With is O(n).
> 
>>
>> That's painful, but by providing indices into the entities array as
>> well, userspace can just do a direct lookup entities[sink_idx] to
>> find the entity with ID sink_id.
> 
> This only works when there is an 1:1 map (like the current case of
> links). At the moment we have a 1:n association (like the pads that
> belong to and entity), application will still need to do a O(n)
> lookup (with can easily become O(n^2) if it needs to do for all
> entities.

Not if you put all the pads belong to an entity together, then the
entity's pad index points to the first pad, and userspace can just
walk over the following pads until either the end of the array or
the pad's entity ID is different from the one you are looking at.

I.e., if you have two entities E1 and E2 and each has two pads,
E1P1, E1P2, E2P1, E2P2, then right now the pads can be in any order,
e.g.:

E1P2 E2P1 E1P1 E2P2

But if you keep pads belonging to one entity together:

E1P1 E1P2 E2P1 E2P2

then each entity can point to the first pad in the pads array and
just walk over the remaining pads.

A pad can also contain an index right back to the entity it belongs
to, so you can directly look up the entity.

The same can be done for links, properties, etc.

All this would make the resulting topology much easier to traverse
without having to build your own data structure. Why make it hard
for userspace when we can just order the data more intelligently?
It doesn't cost the kernel any additional time, it's just a matter
of being smarter.

The current approach is especially painful when you are using just plain
C.

Anyway, I'm working on splitting up the series, separating the property
code from the 'layout' code. That way properties can be added independently
from the layout changes.

Regards,

	Hans

> 
> It should be very simple for all lookups to be O(1), Applications (or
> the library) just need to parse the properties once, storing the
> object ID on a hash table (unordered map, in c++). With that, all
> lookups will be O(1), and a lookup for every single object would be
> O(n).
> 
> Or, if O(log n) is good enough (probably it is), a binary tree 
> (or a sorted array) would equally work.
> 
>> I expect that this will will make it possible in many cases to avoid
>> userspace from having to create their own datastructure, but instead
>> they can use the returned information directly.
> 
> It will still need to traverse the objects, depending on what
> userspace wants. Also, in order to optimize object search for the 1:n
> case, you would need to return data on certain order, as, otherwise
> userspace will still need to traverse the entire pads array.
> 
> Basically, you're creating a lot of complexity inside the
> Kernel and adding hacks like checking if the index has just 16
> bits inside the G_TOPOLOGY return code just to avoid userspace 
> to create their own index table.
> 
> The way I see is that we should have an userspace library that it
> would do the index itself. For userspace apps, the data model used
> to optimize lookups will be transparent.
> 
> One advantage is that, once better algorithms are developed, it
> should be easier to switch the library to take advantage of them.
> The userspace library may even decide on runtime if it would use
> a binary tree or a hash, depending on the number of objects returned
> by G_TOPOLOGY.
> 
>>
>>>   
>>>>
>>>> An updated v4l2-ctl and v4l2-compliance that can report properties
>>>> is available here:
>>>>
>>>> https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props
>>>>
>>>> Currently I support u64, s64 and const char * property types. And also
>>>> a 'group' type that groups sub-properties. But it can be extended to any
>>>> type including binary data if needed. No array support (as we have for
>>>> controls), but there are enough reserved fields in media_v2_prop
>>>> to add this if needed.
>>>>
>>>> I added properties for entities and pads to vimc, so I could test this.
>>>>
>>>> Note that the changes to media_device_get_topology() are hard to read
>>>> from the patch. It is easier to just look at the source code:
>>>>
>>>> https://git.linuxtv.org/hverkuil/media_tree.git/tree/drivers/media/media-device.c?h=mc-props
>>>>
>>>> I have some ideas to improve this some more:
>>>>
>>>> 1) Add the properties directly to media_gobj. This would simplify some
>>>>    of the code, but it would require a media_gobj_init function to
>>>>    initialize the property list. In general I am a bit unhappy about
>>>>    media_gobj_create: it doesn't really create the graph object, instead
>>>>    it just adds it to the media_device. It's confusing and it is something
>>>>    I would like to change.
>>>>
>>>> 2) The links between pads are stored in media_entity instead of in media_pad.
>>>>    This is a bit unexpected and makes it harder to traverse the data
>>>>    structures since to find the links for a pad you need to walk the entity
>>>>    links and find the links for that pad. Putting all links in the entity
>>>>    also mixes up pad and interface links, and it would be much cleaner if
>>>>    those are separated.
>>>>
>>>> 3) I still think adding support for backlinks to G_TOPOLOGY is a good idea.
>>>>    Since the current data structure represents a flattened tree that is easy
>>>>    to navigate the only thing missing for userspace is backlink support.
>>>>    This is still something that userspace needs to figure out when the kernel
>>>>    has this readily available. I think that with this in place applications
>>>>    can just do all the lookups directly on the topology data structure.  
>>>
>>> Apps don't need to follow the exact data struct model as the Kernel,
>>> and can dynamically create any indexes they need in order to quickly
>>> seek for a link (if search performance would be a problem).  
>>
>> But if the kernel can directly without additional cost provide that
>> information to userspace, why on earth shouldn't we do that?
> 
> Based on what I saw on your patches, this is not transparent and
> has a cost of adding ugly hacks to limit the number of objects.
> 
>>> I don't like the idea of reporting all links twice to userspace. 
>>> Specially after Spectre/Meltdown, context switches are expensive.  
>>
>> You need to call G_TOPOLOGY in any case, so returning backlinks
>> in addition to all the other data should not add to the expense. Or
>> am I missing something?
> 
> You're doubling the size of the link table for no good reason.
> If the number of links is high, you'll be doubling the number
> of pages to be used between kernelspace-userspace.
> 
>>
>>>
>>> Duplicating data is a very bad idea, as it will enforce an specific
>>> data model at the application and at userspace. We want to be able
>>> to change the internals (on both sides) if needed for whatever
>>> reason.   
>>
>> Whenever you have a link, you also have a backlink. If userspace doesn't
>> need that information, they can just not query for it (i.e. set the
>> backlinks pointer to 0). But if they do need it, and the kernel has it
>> readily available, then why not export this information? Why force
>> applications to make their own data structures?
> 
> The point is that we're limiting the Kernel to always have backlinks
> stored. The current data model we used internally has it, but IMHO
> we should get rid of that. I remember I wrote something in the past
> on that direction - not sure if I submitted or not. I ended by
> giving up merging it because I got out of time to do such cleanup
> (and, for the current stuff mapped via MC, this is not really an
> issue).
> 
> Yet, I remember someone mentioning that the number of links on some
> kinds of hardware (Industrial I/O?) is at the order of 10k. If we
> ever need to support things like that, we should for sure redesign
> the Kernel and get rid of doubling the storage for links.
> 
>>> Also, what happens if the duplicated information is not really
>>> the same (that could happen due to a bug somewhere)? Should  
>>
>> Well, that's called a bug and it should be fixed.
>>
>> And if we have support for backlinks, then v4l2-compliance will most
>> definitely check for consistency.
>>
>>> apps validate it? Worse than that, if we report the same link
>>> twice (on both directions), userspace will send link changes
>>> at the backlinks, making the Kernel code more complex (and
>>> bound forever to an specific implementation) for no good reason.  
>>
>> Huh? When introducing an S_TOPOLOGY I would expect that initially
>> only the flags in the links array can be changed. The backlinks
>> array would not be involved.
>>
>> Now, having all said this, creating support for backlinks isn't
>> that easy without first making data structure changes in the kernel.
>>
>> So I have no plans to work on backlink support any time soon (if at
>> all).
> 
> Ok, so let's postpone any discussions with regards to it to the
> future, if you decide to work on it.
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>   
>>>>
>>>> 1+2 are internal cleanups that can be done later.
>>>>
>>>> 3 is a low-priority future enhancement. This might become easier to implement
>>>> once 1+2 are done.
>>>>
>>>> This is pretty much the last RFC. If everyone agree with this approach, then
>>>> I can make a final patch series, adding documentation etc.
>>>>
>>>> Regards,
>>>>
>>>>         Hans
>>>>
>>>>
>>>> Hans Verkuil (3):
>>>>   uapi/linux/media.h: add property support
>>>>   media controller: add properties support
>>>>   vimc: add property test code
>>>>
>>>>  drivers/media/media-device.c              | 335 +++++++++++++++++-----
>>>>  drivers/media/media-entity.c              | 107 ++++++-
>>>>  drivers/media/platform/vimc/vimc-common.c |  50 ++++
>>>>  include/media/media-device.h              |   6 +
>>>>  include/media/media-entity.h              | 318 ++++++++++++++++++++
>>>>  include/uapi/linux/media.h                |  88 +++++-
>>>>  6 files changed, 819 insertions(+), 85 deletions(-)
>>>>  
>>>
>>>
>>>
>>> Thanks,
>>> Mauro
>>>   
>>
> 
> 
> 
> Thanks,
> Mauro
> 

