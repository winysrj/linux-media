Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:49375 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237Ab1CAQlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2011 11:41:04 -0500
Message-ID: <4D6D219D.7020605@matrix-vision.de>
Date: Tue, 01 Mar 2011 17:41:01 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: omap3isp cache error when unloading
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

I get a warning about a cache error with the following steps:

0. load omap3-isp
1. set up media broken media pipeline. (e.g. set different formats on
opposite ends of a link, as will be the case for using the lane shifter)
2. try to capture images.  isp_video_streamon() returns -EPIPE from the
failed isp_video_validate_pipeline() call.
3. unload omap3-isp module

then I get the following from kmem_cache_destroy():

slab error in kmem_cache_destroy(): cache `iovm_area_cache': Can't free all objects
[<c0040318>] (unwind_backtrace+0x0/0xec) from [<c00bfe14>] (kmem_cache_destroy+0x88/0xf4)
[<c00bfe14>] (kmem_cache_destroy+0x88/0xf4) from [<c00861f8>] (sys_delete_module+0x1c4/0x230)
[<c00861f8>] (sys_delete_module+0x1c4/0x230) from [<c003b680>] (ret_fast_syscall+0x0/0x30)

Then, when reloading the module:
SLAB: cache with size 32 has lost its name

Can somebody else confirm that they also observe this behavior?

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
