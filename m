Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FC4C04EB8
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B00D20870
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 08:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B00D20870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbeLLI1V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 03:27:21 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:55651 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726317AbeLLI1V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 03:27:21 -0500
Received: from [IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0] ([IPv6:2001:983:e9a7:1:d5c3:7636:7173:44a0])
        by smtp-cloud8.xs4all.net with ESMTPA
        id WzrRggwcEuDWoWzrSgGpbQ; Wed, 12 Dec 2018 09:27:18 +0100
Subject: Re: [RFCv4 PATCH 0/3] This RFC patch series implements properties for
 the media controller.
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     linux-media@vger.kernel.org
References: <20181121154024.13906-1-hverkuil@xs4all.nl>
 <20181212055854.0a92c404@coco.lan>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2fde46aa-c5e3-7163-2b0e-ecfac26a6a51@xs4all.nl>
Date:   Wed, 12 Dec 2018 09:27:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20181212055854.0a92c404@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfHTOm2VARg8RZNfrHO1kmEOADCU09bcH1SrY2r73kdTe7y91D+eDIBAogfE3lfWtQRP8I/mjtmN5KKAsqFUObz+YANbYshb9HEJWHoPtAWTS6LxLG7R2
 RDR3gpzRKr69Q9U7eAxaq8VmXqZiSG1lgkjjOesz0fArAgA2pkE6SWhJIba8mupr7doemmiPCxxmwKVHWk7254UZvkVC6DkXJpgof1Xa5+1WpUtSv4jlGOqP
 EeZvZAfFDp80+LxNhv6u0EtXFYavJ5jNQf8o8KhkVg2tda318zgMcY2wkN9GclPF8orS7BYIsi2ZgdCLECv/bQ==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/12/18 8:58 AM, Mauro Carvalho Chehab wrote:
> Hi Hans,
> 
> Em Wed, 21 Nov 2018 16:40:21 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> The main changes since RFCv3 are:
>>
>> - Add entity index to media_v2_pad
>> - Add source/sink pad index to media_v2_link
>> - Add owner_idx and owner type flags to media_v2_prop
> 
> Sorry, but I didn't get why this is needed for properties to work
> (if the changes are not directly related to properties, please add
> on separate patches, in order to make easier for review/understanding).

I can separate it.

> The lack of an uAPI documentation at the patchset makes it harder
> to understand.
> 
> For the last one, you added a documentation at kAPI:
> 
>> + * @owner_idx:	Index to entities/pads/properties, depending on the owner ID
>> + *		type.
> 
> But it doesn't really explain anything. Is it the new owner_id
> field? Is it something else? Why do we need bot owner_id and 
> owner_idx?

Currently when G_TOPOLOGY returns e.g. a link it has two IDs: one
for the sink object, one for the source object. The application now
has to traverse the entities array to find the entities referred to
by the link IDs.

That's painful, but by providing indices into the entities array as
well, userspace can just do a direct lookup entities[sink_idx] to
find the entity with ID sink_id.

I expect that this will will make it possible in many cases to avoid
userspace from having to create their own datastructure, but instead
they can use the returned information directly.

> 
>>
>> An updated v4l2-ctl and v4l2-compliance that can report properties
>> is available here:
>>
>> https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=props
>>
>> Currently I support u64, s64 and const char * property types. And also
>> a 'group' type that groups sub-properties. But it can be extended to any
>> type including binary data if needed. No array support (as we have for
>> controls), but there are enough reserved fields in media_v2_prop
>> to add this if needed.
>>
>> I added properties for entities and pads to vimc, so I could test this.
>>
>> Note that the changes to media_device_get_topology() are hard to read
>> from the patch. It is easier to just look at the source code:
>>
>> https://git.linuxtv.org/hverkuil/media_tree.git/tree/drivers/media/media-device.c?h=mc-props
>>
>> I have some ideas to improve this some more:
>>
>> 1) Add the properties directly to media_gobj. This would simplify some
>>    of the code, but it would require a media_gobj_init function to
>>    initialize the property list. In general I am a bit unhappy about
>>    media_gobj_create: it doesn't really create the graph object, instead
>>    it just adds it to the media_device. It's confusing and it is something
>>    I would like to change.
>>
>> 2) The links between pads are stored in media_entity instead of in media_pad.
>>    This is a bit unexpected and makes it harder to traverse the data
>>    structures since to find the links for a pad you need to walk the entity
>>    links and find the links for that pad. Putting all links in the entity
>>    also mixes up pad and interface links, and it would be much cleaner if
>>    those are separated.
>>
>> 3) I still think adding support for backlinks to G_TOPOLOGY is a good idea.
>>    Since the current data structure represents a flattened tree that is easy
>>    to navigate the only thing missing for userspace is backlink support.
>>    This is still something that userspace needs to figure out when the kernel
>>    has this readily available. I think that with this in place applications
>>    can just do all the lookups directly on the topology data structure.
> 
> Apps don't need to follow the exact data struct model as the Kernel,
> and can dynamically create any indexes they need in order to quickly
> seek for a link (if search performance would be a problem).

But if the kernel can directly without additional cost provide that
information to userspace, why on earth shouldn't we do that?

> I don't like the idea of reporting all links twice to userspace. 
> Specially after Spectre/Meltdown, context switches are expensive.

You need to call G_TOPOLOGY in any case, so returning backlinks
in addition to all the other data should not add to the expense. Or
am I missing something?

> 
> Duplicating data is a very bad idea, as it will enforce an specific
> data model at the application and at userspace. We want to be able
> to change the internals (on both sides) if needed for whatever
> reason. 

Whenever you have a link, you also have a backlink. If userspace doesn't
need that information, they can just not query for it (i.e. set the
backlinks pointer to 0). But if they do need it, and the kernel has it
readily available, then why not export this information? Why force
applications to make their own data structures?

> 
> Also, what happens if the duplicated information is not really
> the same (that could happen due to a bug somewhere)? Should

Well, that's called a bug and it should be fixed.

And if we have support for backlinks, then v4l2-compliance will most
definitely check for consistency.

> apps validate it? Worse than that, if we report the same link
> twice (on both directions), userspace will send link changes
> at the backlinks, making the Kernel code more complex (and
> bound forever to an specific implementation) for no good reason.

Huh? When introducing an S_TOPOLOGY I would expect that initially
only the flags in the links array can be changed. The backlinks
array would not be involved.

Now, having all said this, creating support for backlinks isn't
that easy without first making data structure changes in the kernel.

So I have no plans to work on backlink support any time soon (if at
all).

Regards,

	Hans

> 
>>
>> 1+2 are internal cleanups that can be done later.
>>
>> 3 is a low-priority future enhancement. This might become easier to implement
>> once 1+2 are done.
>>
>> This is pretty much the last RFC. If everyone agree with this approach, then
>> I can make a final patch series, adding documentation etc.
>>
>> Regards,
>>
>>         Hans
>>
>>
>> Hans Verkuil (3):
>>   uapi/linux/media.h: add property support
>>   media controller: add properties support
>>   vimc: add property test code
>>
>>  drivers/media/media-device.c              | 335 +++++++++++++++++-----
>>  drivers/media/media-entity.c              | 107 ++++++-
>>  drivers/media/platform/vimc/vimc-common.c |  50 ++++
>>  include/media/media-device.h              |   6 +
>>  include/media/media-entity.h              | 318 ++++++++++++++++++++
>>  include/uapi/linux/media.h                |  88 +++++-
>>  6 files changed, 819 insertions(+), 85 deletions(-)
>>
> 
> 
> 
> Thanks,
> Mauro
> 

