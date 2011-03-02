Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47633 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1CBTSo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Mar 2011 14:18:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: omap3isp cache error when unloading
Date: Wed, 2 Mar 2011 20:18:21 +0100
Cc: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4D6D219D.7020605@matrix-vision.de>
In-Reply-To: <4D6D219D.7020605@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103022018.23446.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Tuesday 01 March 2011 17:41:01 Michael Jones wrote:
> Hi all,
> 
> I get a warning about a cache error with the following steps:
> 
> 0. load omap3-isp
> 1. set up media broken media pipeline. (e.g. set different formats on
> opposite ends of a link, as will be the case for using the lane shifter)
> 2. try to capture images.  isp_video_streamon() returns -EPIPE from the
> failed isp_video_validate_pipeline() call.
> 3. unload omap3-isp module
> 
> then I get the following from kmem_cache_destroy():
> 
> slab error in kmem_cache_destroy(): cache `iovm_area_cache': Can't free all
> objects [<c0040318>] (unwind_backtrace+0x0/0xec) from [<c00bfe14>]
> (kmem_cache_destroy+0x88/0xf4) [<c00bfe14>] (kmem_cache_destroy+0x88/0xf4)
> from [<c00861f8>] (sys_delete_module+0x1c4/0x230) [<c00861f8>]
> (sys_delete_module+0x1c4/0x230) from [<c003b680>]
> (ret_fast_syscall+0x0/0x30)
> 
> Then, when reloading the module:
> SLAB: cache with size 32 has lost its name
> 
> Can somebody else confirm that they also observe this behavior?

I can't reproduce that (tried both 2.6.32 and 2.6.37). Could you give me some 
more details about your exact test procedure (such as how you configure the 
pipeline) ?

-- 
Regards,

Laurent Pinchart
