Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4231 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbaDPWeO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 18:34:14 -0400
Message-ID: <534F0553.2000808@xs4all.nl>
Date: Thu, 17 Apr 2014 00:33:55 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 3/3] saa7134: convert to vb2
References: <1394454049-12879-1-git-send-email-hverkuil@xs4all.nl> <1394454049-12879-4-git-send-email-hverkuil@xs4all.nl> <20140416192343.30a5a8fc@samsung.com>
In-Reply-To: <20140416192343.30a5a8fc@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2014 12:23 AM, Mauro Carvalho Chehab wrote:
> Em Mon, 10 Mar 2014 13:20:49 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Convert the saa7134 driver to vb2.
>>
>> Note that while this uses the vb2-dma-sg version, the VB2_USERPTR mode is
>> disabled. The DMA hardware only supports DMAing full pages, and in the
>> USERPTR memory model the first and last scatter-gather buffer is almost
>> never a full page.
>>
>> In practice this means that we can't use the VB2_USERPTR mode.
> 
> Why not? Provided that the buffer is equal or bigger than the number of
> pages required by saa7134, that should be OK.
> 
> All the driver needs to do is to check if the USERPTR buffer condition is met,
> returning an error otherwise (and likely printing a msg at dmesg).

Yuck. Well, I'll take a look at this.

It has in my view the same problem as abusing USERPTR to pass pointers to
physically contiguous memory: yes, it 'supports' USERPTR, but it has additional
requirements which userspace has no way of knowing or detecting.

It's really not USERPTR at all, it is PAGE_ALIGNED_USERPTR.

Quite different.

I would prefer that you have to enable it explicitly through e.g. a module option.
That way you can still do it, but you really have to know what you are doing.

> I suspect that this change will break some userspace programs used
> for video surveillance equipment.
> 
>> This has been tested with raw video, compressed video, VBI, radio, DVB and
>> video overlays.
>>
>> Unfortunately, a vb2 conversion is one of those things you cannot split
>> up in smaller patches, it's all or nothing. This patch switches the whole
>> driver over to vb2, using the vb2 ioctl and fop helper functions.
> 
> Not quite true. This patch contains lots of non-vb2 stuff, like:
> 	- Coding Style fixes;
> 	- Removal of res_get/res_set/res_free;
> 	- Functions got moved from one place to another one.

I will see if there is anything sensible that I can split up. I'm not aware
of any particular coding style issues, but I'll review it.

The removal of the resource functions is not something I can split up. It
is replaced by the resource handling that's built into the vb2 helper functions.

Regards,

	Hans

> 
> It is really hard to review it, as is, as the real changes are mixed with
> the above code cleanups/changes.
> 
> Please split this patch in a way that it allows reviewing the changes
> there.

