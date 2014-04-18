Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4416 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaDRLqK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Apr 2014 07:46:10 -0400
Message-ID: <5351106E.4080700@xs4all.nl>
Date: Fri, 18 Apr 2014 13:45:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/3] saa7134: convert to vb2
References: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl> <1394454049-12879-4-git-send-email-hverkuil@xs4all.nl> <20140416192343.30a5a8fc@samsung.com> <534F0553.2000808@xs4all.nl> <20140416231730.6252aae7@samsung.com> <534FA3BF.2010308@xs4all.nl> <20140417101310.0111d236@samsung.com>
In-Reply-To: <20140417101310.0111d236@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2014 03:13 PM, Mauro Carvalho Chehab wrote:
> Em Thu, 17 Apr 2014 11:49:51 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 04/17/2014 04:17 AM, Mauro Carvalho Chehab wrote:
>>> Em Thu, 17 Apr 2014 00:33:55 +0200
>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>
>>>> On 04/17/2014 12:23 AM, Mauro Carvalho Chehab wrote:
>>>>> Em Mon, 10 Mar 2014 13:20:49 +0100
>>>>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>>>>
>>>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>>>
>>>>>> Convert the saa7134 driver to vb2.
>>>>>>
>>>>>> Note that while this uses the vb2-dma-sg version, the VB2_USERPTR mode is
>>>>>> disabled. The DMA hardware only supports DMAing full pages, and in the
>>>>>> USERPTR memory model the first and last scatter-gather buffer is almost
>>>>>> never a full page.
>>>>>>
>>>>>> In practice this means that we can't use the VB2_USERPTR mode.
>>>>>
>>>>> Why not? Provided that the buffer is equal or bigger than the number of
>>>>> pages required by saa7134, that should be OK.
>>>>>
>>>>> All the driver needs to do is to check if the USERPTR buffer condition is met,
>>>>> returning an error otherwise (and likely printing a msg at dmesg).
>>>>
>>>> Yuck. Well, I'll take a look at this.
>>>>
>>>> It has in my view the same problem as abusing USERPTR to pass pointers to
>>>> physically contiguous memory: yes, it 'supports' USERPTR, but it has additional
>>>> requirements which userspace has no way of knowing or detecting.
>>>>
>>>> It's really not USERPTR at all, it is PAGE_ALIGNED_USERPTR.

This was a bit confusing following the previous paragraph. I meant to say that the
*saa7134* userptr implementation is not USERPTR at all but PAGE_ALIGNED_USERPTR.

A proper USERPTR implementation (like in bttv) can use any malloc()ed pointer as
it should, but saa7134 can't as it requires the application to align the pointer
to a page boundary, which is non-standard.

Regards,

	Hans

>>>>
>>>> Quite different.
>>>
>>> Hmm... If I remember well, mmapped memory (being userptr or not) are always
>>> page aligned, at least on systems with MMU.
>>
>> Not malloc()ed memory. That's what userptr is about.
> 
> Take a look at videobuf_dma_init_user_locked at
> drivers/media/v4l2-core/videobuf-dma-sg.c:
> 
> 	first = (data          & PAGE_MASK) >> PAGE_SHIFT;
> 	last  = ((data+size-1) & PAGE_MASK) >> PAGE_SHIFT;
> 	dma->offset = data & ~PAGE_MASK;
> 	dma->size = size;
> 	dma->nr_pages = last-first+1;
> 	dma->pages = kmalloc(dma->nr_pages * sizeof(struct page *), GFP_KERNEL);
> 
> The physical memory is always page aligned, even if VM memory isn't.
> The offset there is actually used just to subtract the size, at
> videobuf_pages_to_sg().
> 
> So, with VB1, USERPTR works fine, and no special care is needed on
> userspace to align the offset.
> 
> Btw, it seems that VB2 also does the same. Take a look at
> vb2_dma_sg_get_userptr().


