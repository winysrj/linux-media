Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.200.34]:37569 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932898AbeGIPVz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 11:21:55 -0400
Subject: Re: [RFC] Make entity to interface links immutable
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Shuah Khan <shuah@kernel.org>
References: <354b01c0-6825-4302-a1f4-d120cf8c34e3@xs4all.nl>
 <20180702064116.401a244e@coco.lan>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <ebcb62c0-c979-6886-f841-0d82f12b027a@kernel.org>
Date: Mon, 9 Jul 2018 09:21:45 -0600
MIME-Version: 1.0
In-Reply-To: <20180702064116.401a244e@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Hans,

On 07/02/2018 03:41 AM, Mauro Carvalho Chehab wrote:
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
> 

I have been sidetracked by USB over IP security vulnerability reports
and fixing them since last November. Sorry for not picking this work
back up.

I am back from a week of vacation and I will dig my patches and respond
with details in a couple of days.

thanks for your patience,
-- Shuah
