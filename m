Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:36162 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964882AbbLOKLm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 05:11:42 -0500
Subject: Re: [RFC PATCH] vb2: Stop allocating 'alloc_ctx', just set the device
 instead
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <566ED3D4.9050803@xs4all.nl> <28435978.1Ghf2YSlFk@avalon>
 <566FE4E7.5060001@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <566FE816.8070704@cisco.com>
Date: Tue, 15 Dec 2015 11:14:46 +0100
MIME-Version: 1.0
In-Reply-To: <566FE4E7.5060001@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/15/15 11:01, Marek Szyprowski wrote:
> Hello,
> 
> On 2015-12-14 16:40, Laurent Pinchart wrote:
>> Hi Hans,
>>
>> On Monday 14 December 2015 15:36:04 Hans Verkuil wrote:
>>> (Before I post this as the 'final' patch and CC all the driver developers
>>> that are affected, I'd like to do an RFC post first. I always hated the
>>> alloc context for obfuscating what is really going on, but let's see what
>>> others think).
>>>
>>>
>>> Instead of allocating a struct that contains just a single device pointer,
>>> just pass that device pointer around. This avoids having to check for
>>> memory allocation errors and is much easier to understand since it makes
>>> explicit what was hidden in an opaque handle before.
>>>
>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> As most devices use the same allocation context for all planes, wouldn't it
>> make sense to just store the struct device pointer in the queue structure ?
>> The oddball driver that requires different allocation contexts (I'm thinking
>> about s5p-mfc here, there might be a couple more) would have to set the
>> allocation contexts properly in the queue_setup handler, but for all other
>> devices you could just remove that code completely.
> 
> This seams a reasonable approach. vb2 was written with special (or strange ;)
> requirements in mind to align it with Exynos HW. However after some time it
> turned out that most device drivers are simple and don't need fancy handling
> of allocator context, so this definitely can be simplified. It also turned out
> also that there is no real 'context' for vb2 memory allocators, although some
> out-of-tree code (used in Android kernels) use some more advanced structures
> there. Maybe it will be enough to let drivers to change defaults in queue_setup
> and ensure that there is a 'void *alloc_ctx_priv' placeholder for allocator
> specific data.
> 
> There is one more advantage of moving struct device * to vb2_queue. One can
> then change all debugs to use dev_info/err/dbg infrastructure, so the logs will
> be significantly easier to read, especially when more than one media device is
> used.

I hadn't thought of that. That's nice indeed. However, it would require that
vb2-vmalloc drivers also set the device pointer.

I think I'll work on this a bit more, clearly it is the right direction to go.

Regards,

	Hans
