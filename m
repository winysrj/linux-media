Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1223 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161088AbaDQJuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:50:11 -0400
Message-ID: <534FA3BF.2010308@xs4all.nl>
Date: Thu, 17 Apr 2014 11:49:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/3] saa7134: convert to vb2
References: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl> <1394454049-12879-4-git-send-email-hverkuil@xs4all.nl> <20140416192343.30a5a8fc@samsung.com> <534F0553.2000808@xs4all.nl> <20140416231730.6252aae7@samsung.com>
In-Reply-To: <20140416231730.6252aae7@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2014 04:17 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 17 Apr 2014 00:33:55 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 04/17/2014 12:23 AM, Mauro Carvalho Chehab wrote:
>>> Em Mon, 10 Mar 2014 13:20:49 +0100
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Convert the saa7134 driver to vb2.
>>>>
>>>> Note that while this uses the vb2-dma-sg version, the VB2_USERPTR mode is
>>>> disabled. The DMA hardware only supports DMAing full pages, and in the
>>>> USERPTR memory model the first and last scatter-gather buffer is almost
>>>> never a full page.
>>>>
>>>> In practice this means that we can't use the VB2_USERPTR mode.
>>>
>>> Why not? Provided that the buffer is equal or bigger than the number of
>>> pages required by saa7134, that should be OK.
>>>
>>> All the driver needs to do is to check if the USERPTR buffer condition is met,
>>> returning an error otherwise (and likely printing a msg at dmesg).
>>
>> Yuck. Well, I'll take a look at this.
>>
>> It has in my view the same problem as abusing USERPTR to pass pointers to
>> physically contiguous memory: yes, it 'supports' USERPTR, but it has additional
>> requirements which userspace has no way of knowing or detecting.
>>
>> It's really not USERPTR at all, it is PAGE_ALIGNED_USERPTR.
>>
>> Quite different.
> 
> Hmm... If I remember well, mmapped memory (being userptr or not) are always
> page aligned, at least on systems with MMU.

Not malloc()ed memory. That's what userptr is about.

> 
>> I would prefer that you have to enable it explicitly through e.g. a module option.
>> That way you can still do it, but you really have to know what you are doing.
>>
>>> I suspect that this change will break some userspace programs used
>>> for video surveillance equipment.
>>>
>>>> This has been tested with raw video, compressed video, VBI, radio, DVB and
>>>> video overlays.
>>>>
>>>> Unfortunately, a vb2 conversion is one of those things you cannot split
>>>> up in smaller patches, it's all or nothing. This patch switches the whole
>>>> driver over to vb2, using the vb2 ioctl and fop helper functions.
>>>
>>> Not quite true. This patch contains lots of non-vb2 stuff, like:
>>> 	- Coding Style fixes;
>>> 	- Removal of res_get/res_set/res_free;
>>> 	- Functions got moved from one place to another one.
>>
>> I will see if there is anything sensible that I can split up. I'm not aware
>> of any particular coding style issues, but I'll review it.
> 
> There are several, like:
> 
> -	dprintk("buffer_finish %p\n",q->curr);
> +	dprintk("buffer_finish %p\n", q->curr);
> 
> Also, it seems that you moved some functions, like:
> 
> ts_reset_encoder(struct saa7134_dev* dev) that was moved
> to some other part of the code and renamed as stop_streaming().
> 
> There are several of such cases, with makes hard to really see the
> VB2 changes, and what it might be some code dropped by mistake.
> 
>>
>> The removal of the resource functions is not something I can split up. It
>> is replaced by the resource handling that's built into the vb2 helper functions.
> 
> Well, currently, it is really hard to see that all the checks between
> empress and normal video streams are still done right, as the patch
> become big and messy.

The original checks were never correct. This driver was buggy as hell once
you tried to use multiple streams at the same time.

I have split it up some more, but the actual vb2 conversion remains a big
patch.

Regards,

	Hans

> 
> Please try to break it into a more granular set of patches that
> would help to check if everything is there.
> 
> Thanks,
> Mauro
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>> It is really hard to review it, as is, as the real changes are mixed with
>>> the above code cleanups/changes.
>>>
>>> Please split this patch in a way that it allows reviewing the changes
>>> there.
>>
> 
> 

