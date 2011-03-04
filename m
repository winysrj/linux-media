Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:44793 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab1CDHie (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Mar 2011 02:38:34 -0500
Message-ID: <4D7096EE.8090105@maxwell.research.nokia.com>
Date: Fri, 04 Mar 2011 09:38:22 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	fernando.lugo@ti.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-omap@vger.kernel.org, Hiroshi.DOYU@nokia.com,
	Cohen David Abraham <david.cohen@nokia.com>
Subject: Re: omap3isp cache error when unloading
References: <4D6D219D.7020605@matrix-vision.de> <201103022018.23446.laurent.pinchart@ideasonboard.com> <4D6FBC7F.1080500@matrix-vision.de>
In-Reply-To: <4D6FBC7F.1080500@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Michael Jones wrote:
> On 03/02/2011 08:18 PM, Laurent Pinchart wrote:
>> Hi Michael,
>>
>> On Tuesday 01 March 2011 17:41:01 Michael Jones wrote:
>>> Hi all,
>>>
>>> I get a warning about a cache error with the following steps:
>>>
>>> 0. load omap3-isp
>>> 1. set up media broken media pipeline. (e.g. set different formats on
>>> opposite ends of a link, as will be the case for using the lane shifter)
>>> 2. try to capture images.  isp_video_streamon() returns -EPIPE from the
>>> failed isp_video_validate_pipeline() call.
>>> 3. unload omap3-isp module
>>>
>>> then I get the following from kmem_cache_destroy():
>>>
>>> slab error in kmem_cache_destroy(): cache `iovm_area_cache': Can't free all
>>> objects [<c0040318>] (unwind_backtrace+0x0/0xec) from [<c00bfe14>]
>>> (kmem_cache_destroy+0x88/0xf4) [<c00bfe14>] (kmem_cache_destroy+0x88/0xf4)
>>> from [<c00861f8>] (sys_delete_module+0x1c4/0x230) [<c00861f8>]
>>> (sys_delete_module+0x1c4/0x230) from [<c003b680>]
>>> (ret_fast_syscall+0x0/0x30)
>>>
>>> Then, when reloading the module:
>>> SLAB: cache with size 32 has lost its name
>>>
>>> Can somebody else confirm that they also observe this behavior?
>>
>> I can't reproduce that (tried both 2.6.32 and 2.6.37). Could you give me some 
>> more details about your exact test procedure (such as how you configure the 
>> pipeline) ?
>>
> 
> Sorry, I should've mentioned: I'm using your media-0005-omap3isp branch
> based on 2.6.38-rc5.  I didn't have the problem with 2.6.37, either.
> It's actually not related to mis-configuring the ISP pipeline like I
> thought at first- it also happens after I have successfully captured images.
> 
> I've since tracked down the problem, although I don't understand the
> cache management well enough to be sure it's a proper fix, so hopefully
> some new recipients on this can make suggestions/comments.
> 
> The patch below solves the problem, which modifies a commit by Fernando
> Guzman Lugo from December.

Thanks for the patch.

It looks like this patch from Fernando, perhaps unintentionally, also
makes the first page mappable so the NULL address is also valid. The
NULL address isn't considered valid by the ISP driver which thus does
not iommu_vunmap() the NULL address.

Hiroshi, David, what do you think? I think the patch is correct so it
could be applied with description changed to mention it disallows
mapping the first page again.

Or is there a reason to allow mapping the first page automatically? I
personally don't see any.

Cheers,

> From db35fb8edca2a4f8fd37197d77fd58676cb1dcac Mon Sep 17 00:00:00 2001
> From: Michael Jones <michael.jones@matrix-vision.de>
> Date: Thu, 3 Mar 2011 16:50:39 +0100
> Subject: [PATCH] fix iovmm slab cache error on module unload
> 
> modify "OMAP: iommu: create new api to set valid da range"
> 
> This modifies commit c7f4ab26e3bcdaeb3e19ec658e3ad9092f1a6ceb.
> ---
>  arch/arm/plat-omap/iovmm.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
> index 6dc1296..2fba6f1 100644
> --- a/arch/arm/plat-omap/iovmm.c
> +++ b/arch/arm/plat-omap/iovmm.c
> @@ -280,7 +280,10 @@ static struct iovm_struct *alloc_iovm_area(struct iommu *obj, u32 da,
>  	alignement = PAGE_SIZE;
>  
>  	if (flags & IOVMF_DA_ANON) {
> -		start = obj->da_start;
> +		/*
> +		 * Reserve the first page for NULL
> +		 */
> +		start = obj->da_start + PAGE_SIZE;
>  
>  		if (flags & IOVMF_LINEAR)
>  			alignement = iopgsz_max(bytes);


-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
