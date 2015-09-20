Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34410 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbbITH1u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Sep 2015 03:27:50 -0400
Subject: Re: [RFC 0/9] Unrestricted media entity ID range support
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	javier@osg.samsung.com, hverkuil@xs4all.nl
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
 <20150919092231.55fd5c28@osg.samsung.com>
From: Sakari Ailus <sakari.ailus@linux.intel.com>
Message-ID: <55FE5F91.6090506@linux.intel.com>
Date: Sun, 20 Sep 2015 10:26:09 +0300
MIME-Version: 1.0
In-Reply-To: <20150919092231.55fd5c28@osg.samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Hi Sakari,
>
> On Fri, 11 Sep 2015 13:09:03 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
>
>> Hi all,
>>
>> This patchset adds an API for managing entity enumerations, i.e.
>> storing a bit of information per entity. The entity ID is no longer
>> limited to small integers (e.g. 31 or 63), but
>> MEDIA_ENTITY_MAX_LOW_ID. The drivers are also converted to use that
>> instead of a fixed number.
>>
>> If the number of entities in a real use case grows beyond the
>> capabilities of the approach, the algorithm may be changed. But most
>> importantly, the API is used to perform the same operation everywhere
>> it's done.
>>
>> I'm sending this for review only, the code itself is untested.
>>
>> I haven't entirely made up my mind on the fourth patch. It could be
>> dropped, as it uses the API for a somewhat different purpose.
>>
>
> Sorry for not reviewing this earlier, but I'm traveling this week to
> China, and I was having some troubles with the Internet. Btw, I don't
> have my notebook here (just a chromebook without the media tree).
> So, please consider this as just a preliminary review.
>
> I won't be comment this series patch by patch, because it is really
> painful to do it while here with this Internet.
>
> Also, I want to discuss the patch series as a hole.
>
>  From what we've agreed last week, we won't be using a separate ID
> range for the entity ID, but this patch series is actually adding
> it, and, IMHO, using a confusing nomenclature: instead of calling the
> entity ID range as "entity_id" at the media_device struct, you're
> now calling it "low_id". That sounds confusing to me. If you think
> we should keep a separate range for entities, calling it as
> "entity_id" is clearer.

It's *not* the entity ID. It's a number used internally to keep track of 
the entities, and only used for this purpose, nothing else. If you look 
at the patch, the number of places where low_id is used is very limited. 
Individual drivers do not and must not access the low_id field.

The underlying algorithm for keeping track of entities does not change, 
but that could be changed later on without affecting the users of the 
alrogithm. --- See patch 3.

There are two main reasons for this:

1. No need to implement a new algorithm which would be less efficient 
but could cope in cases we do not have yet; this can be done later on, 
as patch 3 adds an API to access the information without making 
assumptions on the implementation.

2. It does solve the problem. The graph object IDs of the entities can 
be large without adversely affecting the functionality of existing drivers.

>
> Also, you said at the low_id comment that if an entity is
> unregistered and then re-registered, it would preserve the same

I never claimed that, and the patchset does not implement that either.

If an entity is unregistered and registered again, from the MC point of 
view it is not the same entity. We do not keep track of entities that 
are not registered with MC, do we?

> entity ID. That doesn't seem easy to implement, as we would need
> to track those previously-used ID. On the other hand, if we just
> re-use a previously released ID for some other entity, this can
> be a problem, as userspace may not be aware of such changes and
> might be asking the Kernel to do the wrong thing.

Let's not do that then. This is why we have graph object IDs.

>
> So, I can't see how non-monotonically incremented numbers would
> work here.
>
> Finally, the changes you did still rely on having the ID limited
> to a well-defined, hardcoded number (MEDIA_ENTITY_MAX_LOW_ID).
>
> I can see this working only if:
>
> - We keep a separate range ID for entities (so, having a minimum
>    of two ranges);
>
> - the entity maximum ID is defined by the driver (as the number
>    of entities is actually dependent on the hardware);

The case is that we do not have a driver requiring more entities. Once 
we do, we can implement a new algorithm for the purpose. Memory 
allocation will be required, but that's a separate matter from the graph 
object ID of the entities, which is the problem this patchset was 
intended to solve.

>
> - some other mechanism would be available for drivers that
>    would support dynamic entity creation.
>
> So, I don't see how this would solve the problems that we
> discussed at the last week IRC chats.
>
> Am I missing something?

This set indeed solves a problem, and that problem was unrestricting the 
graph object ID of the entities. There are other problems remaining 
before entities can be e.g. unregistered one by one, but they are 
separate problems.

>
> Regards,
> Mauro
>
> PS.: sparse already complains on two places at the media-entity where
> bitmaps are declared at the stack. With max entities equal to 64,
> that's not an issue, but if we change to a higher number, those will
> need to be dynamically allocated, in order to avoid stack overflows.
> I didn't see any patches touching that.

I agree. The aim of the set was not to increase the number of concurrent 
entities. That is a separate problem which can be solved later on once 
we have a use case for it.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
