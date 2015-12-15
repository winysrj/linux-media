Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:62317 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964850AbbLOKBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:01:16 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NZE005C9961N860@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 Dec 2015 10:01:13 +0000 (GMT)
Subject: Re: [RFC PATCH] vb2: Stop allocating 'alloc_ctx',
 just set the device instead
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <566ED3D4.9050803@xs4all.nl> <28435978.1Ghf2YSlFk@avalon>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <566FE4E7.5060001@samsung.com>
Date: Tue, 15 Dec 2015 11:01:11 +0100
MIME-version: 1.0
In-reply-to: <28435978.1Ghf2YSlFk@avalon>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2015-12-14 16:40, Laurent Pinchart wrote:
> Hi Hans,
>
> On Monday 14 December 2015 15:36:04 Hans Verkuil wrote:
>> (Before I post this as the 'final' patch and CC all the driver developers
>> that are affected, I'd like to do an RFC post first. I always hated the
>> alloc context for obfuscating what is really going on, but let's see what
>> others think).
>>
>>
>> Instead of allocating a struct that contains just a single device pointer,
>> just pass that device pointer around. This avoids having to check for
>> memory allocation errors and is much easier to understand since it makes
>> explicit what was hidden in an opaque handle before.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> As most devices use the same allocation context for all planes, wouldn't it
> make sense to just store the struct device pointer in the queue structure ?
> The oddball driver that requires different allocation contexts (I'm thinking
> about s5p-mfc here, there might be a couple more) would have to set the
> allocation contexts properly in the queue_setup handler, but for all other
> devices you could just remove that code completely.

This seams a reasonable approach. vb2 was written with special (or 
strange ;)
requirements in mind to align it with Exynos HW. However after some time it
turned out that most device drivers are simple and don't need fancy handling
of allocator context, so this definitely can be simplified. It also 
turned out
also that there is no real 'context' for vb2 memory allocators, although 
some
out-of-tree code (used in Android kernels) use some more advanced structures
there. Maybe it will be enough to let drivers to change defaults in 
queue_setup
and ensure that there is a 'void *alloc_ctx_priv' placeholder for allocator
specific data.

There is one more advantage of moving struct device * to vb2_queue. One can
then change all debugs to use dev_info/err/dbg infrastructure, so the 
logs will
be significantly easier to read, especially when more than one media 
device is
used.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

