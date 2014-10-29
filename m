Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3348 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285AbaJ2NyR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Oct 2014 09:54:17 -0400
Message-ID: <5450F171.2040104@xs4all.nl>
Date: Wed, 29 Oct 2014 14:53:53 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Divneil Wadhawan <divneil.wadhawan@st.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] vb2: replace VIDEO_MAX_FRAME with VB2_MAX_FRAME
References: <5437932A.7000706@xs4all.nl> <8693824.jOpqngyjmV@avalon> <20141029110534.138af0ab@recife.lan> <1478241.MdfDLTXDIM@avalon>
In-Reply-To: <1478241.MdfDLTXDIM@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/29/14 14:17, Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Wednesday 29 October 2014 11:05:34 Mauro Carvalho Chehab wrote:
>> Em Wed, 29 Oct 2014 14:46:55 +0200 Laurent Pinchart escreveu:
>>>>> Hmm, so you think VIDEO_MAX_FRAME should just be updated to 64?
>>>>
>>>> Yes.
>>>>
>>>>> I am a bit afraid that that might break applications (especially if
>>>>> there are any that use bits in a 32-bit unsigned variable).
>>>>
>>>> What 32-bits have to do with that? This is just the maximum number of
>>>> buffers, and not the number of bits.
>>>
>>> Applications might use a bitmask to track buffers.
>>
>> True, but then it should be limiting the max buffer to 32, if the
>> implementation won't support more than 32 bits at its bitmask
>> implementation.
>>
>> Anyway, we need to double check if nothing will break at the open
>> source apps before being able to change its value.
> 
> I don't think we should change the value of VIDEO_MAX_FRAME. Applications that 
> rely on it will thus allocate a maximum of 32 buffers, nothing should break 
> (provided that no driver requires a minimum number of buffers higher than 32).
> 
>>>>> Should userspace know about this at all? I think that the maximum
>>>>> number of frames is driver dependent, and in fact one of the future
>>>>> vb2 improvements would be to stop hardcoding this and leave the
>>>>> maximum up to the driver.
>>>>
>>>> It is not driver dependent. It basically depends on the streaming logic.
>>>> Both VB and VB2 are free to set whatever size it is needed. They can
>>>> even change the logic to use a linked list, to avoid pre-allocating
>>>> anything.
>>>>
>>>> Ok, there's actually a hardware limit, with is the maximum amount of
>>>> memory that could be used for DMA on a given hardware/architecture.
>>>>
>>>> The 32 limit was just a random number that was chosen.
>>>
>>> So, can't we just mark VIDEO_MAX_FRAME as deprecated ? We can't remove it
>>> as applications might depend on it, but it's pretty useless otherwise.
>>
>> As I pointed below, even the applications _we_ wrote at v4l-utils use
>> it. The good news is that I double-checked xawtv3, xawtv4 and tvtime:
>> none of them use it. Perhaps we're lucky enough, but I wouldn't count
>> with that.
>>
>> Ok, we can always write a note there saying that this is deprecated,
>> but the same symbol is still used internally on the drivers.
>>
>> If we're willing to deprecate, we should do something like:
>>
>> #ifndef __KERNEL__
>> 	/* This define is deprecated because (...) */
>> 	#define VIDEO_MAX_FRAME	32
>> #endif
>>
>> And then remove all occurrences of it at Kernelspace.

No problem.

> 
> Agreed.
> 
>> We should also first fix v4l-utils no not use it, as v4l-utils is currently
>> the reference code for users.
> 
> That sounds reasonable to me. There's no urgency, as nothing will break if an 
> application uses VIDEO_MAX_FRAME set to 32 while VB2 can support 64, but we 
> should still remove references to VIDEO_MAX_FRAME from v4l-utils.
> 
>> Please notice, however, that v4l-compliance depends on it. I suspect that it
>> wants/needs to test the maximum buffer size. What would be a reasonable way
>> to replace it, and still be able to test the maximum buffer limit?
> 
> I'll let Hans comment on that.

None of this is difficult to do. And it would most likely improve the code as well.

OK. How about this:

1) Remove the use of VIDEO_MAX_FRAME in the kernel by introducing VB1_MAX_FRAME
   and VB2_MAX_FRAME defines, initially both are set to 32.
2) Remove the use of VIDEO_MAX_FRAME in v4l-utils.
3) Patch VB2_MAX_FRAME to 64 and update the spec.

Regards,

	Hans
