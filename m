Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:55590 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbcFRJBu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 05:01:50 -0400
Subject: Re: [PATCH 00/38] i.MX5/6 Video Capture
To: Steve Longerbeam <slongerbeam@gmail.com>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Jack Mitchell <ml@embed.me.uk>, linux-media@vger.kernel.org
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
 <64c29bbc-2273-2a9d-3059-ab8f62dc531b@embed.me.uk>
 <576202D0.6010608@mentor.com>
 <597d73df-0fa0-fa8d-e0e5-0ad8b2c49bcf@embed.me.uk>
 <5762DB8A.8090906@mentor.com> <5763A248.1040905@xs4all.nl>
 <576434D3.1040908@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57650DF7.1040008@xs4all.nl>
Date: Sat, 18 Jun 2016 11:01:43 +0200
MIME-Version: 1.0
In-Reply-To: <576434D3.1040908@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/17/2016 07:35 PM, Steve Longerbeam wrote:
> 
> 
> On 06/17/2016 12:10 AM, Hans Verkuil wrote:
>> On 06/16/2016 07:02 PM, Steve Longerbeam wrote:
>>> On 06/16/2016 02:49 AM, Jack Mitchell wrote:
>>>> On 16/06/16 02:37, Steve Longerbeam wrote:
>>>>> Hi Jack,
>>>>>
>>>>> On 06/15/2016 03:43 AM, Jack Mitchell wrote:
>>>>>> <snip>
>>>>>> Trying to use a user pointer rather than mmap also fails and causes a kernel splat.
>>>>>>
>>>>> Hmm, I've tested userptr with the mem2mem driver, but maybe never
>>>>> with video capture. I tried "v4l2-ctl -d/dev/video0 --stream-user=8" but
>>>>> that returns "VIDIOC_QBUF: failed: Invalid argument", haven't tracked
>>>>> down why (could be a bug in v4l2-ctl). Can you share the splat?
>>>>>
>>>> On re-checking the splat was the same v4l_cropcap that was mentioned before so I don't think it's related. The error I get back is:
>>>>
>>>> VIDIOC_QBUF error 22, Invalid argument
>>>>
>>>> I'm using the example program the the v4l2 docs [1].
>>> I found the cause at least in my case. After enabling dynamic debug in
>>> videobuf2-dma-contig.c, "v4l2-ctl -d/dev/video0 --stream-user=8" gives
>>> me
>>>
>>> [  468.826046] user data must be aligned to 64 bytes
>>>
>>>
>>>
>>> But even getting past that alignment issue, I've only tested userptr (in mem2mem
>>> driver) by giving the driver a user address of a mmap'ed kernel contiguous
>>> buffer. A true discontiguous user buffer may not work, the IPU DMA does not
>>> support scatter-gather.
>> I don't think VB2_USERPTR should be enabled in this case due to the DMA limitations.
>> It won't allow you to use malloc()ed memory and the hack that allows you to pass
>> contiguous memory is superseded by the DMABUF mode.
> 
> Hi Hans, yes, I was going to suggest that. I will remove USERPTR
> from both capture and mem2mem io_modes flags. Although I can
> see where userptr support is still useful, that is for legacy middleware
> that are still using mmap'ed userptrs and have not yet converted to
> passing around dmabuf fd's.
> 
> But I've been perplexed for while on this, why vb2_dc_get_userptr() 
> resorts to
> scatter-gather (when the given user buffer is found not to have valid 
> pfn's).
> Shouldn't it be assumed that driver users of the vb2 dma-contig allocator
> only support contiguous dma as the name implies? Maybe the issue is that
> users that set VB2_USERPTR are implying they support scatter/gather, but
> users of vb2-dma-contig could also be implying they do not, and would be
> using vb2-dma-sg if that were the case.

At the end of the vb2_dc_get_userptr() function it checks if the result
is physically contiguous (the call to vb2_dc_get_contiguous_size). If not,
then it returns an error.

I hate it that dma_contig accepts user pointers at all, it should never
have been implemented like that. There is no way for applications to know
that even though the driver support USERPTR, the buffer still has to be
phys. contig. :-(

Regards,

	Hans
