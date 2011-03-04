Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:25967 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759144Ab1CDKJz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2011 05:09:55 -0500
Date: Fri, 04 Mar 2011 12:07:36 +0200 (EET)
Message-Id: <20110304.120736.177982315275204354.Hiroshi.DOYU@nokia.com>
To: sakari.ailus@maxwell.research.nokia.com
Cc: michael.jones@matrix-vision.de, laurent.pinchart@ideasonboard.com,
	fernando.lugo@ti.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, david.cohen@nokia.com
Subject: Re: omap3isp cache error when unloading
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <4D7096EE.8090105@maxwell.research.nokia.com>
References: <201103022018.23446.laurent.pinchart@ideasonboard.com>
	<4D6FBC7F.1080500@matrix-vision.de>
	<4D7096EE.8090105@maxwell.research.nokia.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: omap3isp cache error when unloading
Date: Fri, 4 Mar 2011 09:38:22 +0200

> Hi Michael,
> 
> Michael Jones wrote:
>> On 03/02/2011 08:18 PM, Laurent Pinchart wrote:
>>> Hi Michael,
>>>
>>> On Tuesday 01 March 2011 17:41:01 Michael Jones wrote:
>>>> Hi all,
>>>>
>>>> I get a warning about a cache error with the following steps:
>>>>
>>>> 0. load omap3-isp
>>>> 1. set up media broken media pipeline. (e.g. set different formats on
>>>> opposite ends of a link, as will be the case for using the lane shifter)
>>>> 2. try to capture images.  isp_video_streamon() returns -EPIPE from the
>>>> failed isp_video_validate_pipeline() call.
>>>> 3. unload omap3-isp module
>>>>
>>>> then I get the following from kmem_cache_destroy():
>>>>
>>>> slab error in kmem_cache_destroy(): cache `iovm_area_cache': Can't free all
>>>> objects [<c0040318>] (unwind_backtrace+0x0/0xec) from [<c00bfe14>]
>>>> (kmem_cache_destroy+0x88/0xf4) [<c00bfe14>] (kmem_cache_destroy+0x88/0xf4)
>>>> from [<c00861f8>] (sys_delete_module+0x1c4/0x230) [<c00861f8>]
>>>> (sys_delete_module+0x1c4/0x230) from [<c003b680>]
>>>> (ret_fast_syscall+0x0/0x30)
>>>>
>>>> Then, when reloading the module:
>>>> SLAB: cache with size 32 has lost its name
>>>>
>>>> Can somebody else confirm that they also observe this behavior?
>>>
>>> I can't reproduce that (tried both 2.6.32 and 2.6.37). Could you give me some 
>>> more details about your exact test procedure (such as how you configure the 
>>> pipeline) ?
>>>
>> 
>> Sorry, I should've mentioned: I'm using your media-0005-omap3isp branch
>> based on 2.6.38-rc5.  I didn't have the problem with 2.6.37, either.
>> It's actually not related to mis-configuring the ISP pipeline like I
>> thought at first- it also happens after I have successfully captured images.
>> 
>> I've since tracked down the problem, although I don't understand the
>> cache management well enough to be sure it's a proper fix, so hopefully
>> some new recipients on this can make suggestions/comments.
>> 
>> The patch below solves the problem, which modifies a commit by Fernando
>> Guzman Lugo from December.
> 
> Thanks for the patch.
> 
> It looks like this patch from Fernando, perhaps unintentionally, also
> makes the first page mappable so the NULL address is also valid. The
> NULL address isn't considered valid by the ISP driver which thus does
> not iommu_vunmap() the NULL address.
> 
> Hiroshi, David, what do you think? I think the patch is correct so it
> could be applied with description changed to mention it disallows
> mapping the first page again.
>
> Or is there a reason to allow mapping the first page automatically? I
> personally don't see any.

I think that was done "unintentionally". The invalid first page may be
quite reasonable generally.
