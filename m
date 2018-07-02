Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:53750 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1030190AbeGBKiZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 06:38:25 -0400
Subject: Re: [RFC] Make entity to interface links immutable
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>
References: <354b01c0-6825-4302-a1f4-d120cf8c34e3@xs4all.nl>
 <20180702064116.401a244e@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <99caf821-16f9-baa9-4e97-36d91e25d1ac@xs4all.nl>
Date: Mon, 2 Jul 2018 12:38:23 +0200
MIME-Version: 1.0
In-Reply-To: <20180702064116.401a244e@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/18 11:41, Mauro Carvalho Chehab wrote:
> Em Mon, 2 Jul 2018 10:18:37 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> While working on v4l2-compliance I noticed that entity to interface links
>> have just the MEDIA_LNK_FL_ENABLED flag set.
>>
>> Shouldn't we also set the MEDIA_LNK_FL_IMMUTABLE? After all, you cannot change
>> an entity-interface link. It feels inconsistent not to have this flag.
> 
> It could make sense for non-hybrid devices, but this may not be true
> for hybrid ones. See below.
> 
>> I also propose that media_create_intf_link() drops the last flags argument:
>> it can set the link flags directly since they are always the same anyway.
> 
> When we came with this design, the idea is that an interface can be 
> disabled/enabled at runtime, if the entity it links can't be used,
> because the hardware is busy doing something else. 
> 
> That could happen with hybrid devices, where the analog part could
> be consuming resources that would be needed for the digital part.
> 
> Disabling the link at runtime has an advantage that it makes easier
> to check - as open() syscalls could just use it to return -EBUSY,
> instead of doing a complete graph analysis. Also, applications can
> test it directly, in order to have a hint if a device is ready for
> usage.
> 
> That was one of the approaches we considered at the design, but I
> don't remember if Shuah's patch series actually used it or not,
> as I don't look at her pending patches for a long time. I suspect
> she took a different approach.
> 
> Anyway, before touching it, I'd like to see her patches merged,
> and do some tests with real case scenarios before changing it.

Hmm, this also highlights another deficiency in the spec. Currently
the description of IMMUTABLE says:

"The link enabled state can’t be modified at runtime. An immutable link
 is always enabled."

But in the plan above the link can change, but only the driver can
enable/disable the link. It makes no sense AFAICS for userspace to
enable/disable an interface link.

If I am right that it makes no sense for userspace to disable an interface
link, then we should update the spec to clarify that this is not allowed
(in fact, it is not possible today anyway). And we should also clarify
that the driver can disable an interface link and what that means.

If userspace CAN in some circumstances disable an interface link, then
we need to add something like a READ_ONLY flag to signal whether or not
userspace can change an interface link. If it is READ_ONLY, then only the
driver can change that.

That said, given that today there are no drivers that disable an interface
link, I still think that we should mark them all as IMMUTABLE. That flag
can be removed when we actually let drivers change this.

It would be consistent with the current usage of interface links.

Regards,

	Hans
