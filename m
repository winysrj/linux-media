Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxout-07.mxes.net ([216.86.168.182]:35480 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab2FXWCq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jun 2012 18:02:46 -0400
Received: from [192.168.0.196] (unknown [24.18.255.233])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.mxes.net (Postfix) with ESMTPSA id 5BAD422E256
	for <linux-media@vger.kernel.org>; Sun, 24 Jun 2012 18:02:45 -0400 (EDT)
Message-ID: <4FE78E84.1050003@cybermato.com>
Date: Sun, 24 Jun 2012 15:02:44 -0700
From: Chris MacGregor <chris@cybermato.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: hacking MT9P031 (LI-5M03) driver in Ubuntu 12.04 on BeagleBoard xM?
References: <4FE34DF3.6070009@cybermato.com>
In-Reply-To: <4FE34DF3.6070009@cybermato.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.  I was redirected to this list by a response to my post (below) on 
the BeagleBoard group. I'm happy to help/cooperate/etc. in whatever way 
I reasonably can.

-------- Original Message --------

Hello, all.

I managed to get the MT9P031 driver (for the Leopard Imaging LI-5M03 
camera board) working using a slightly modified Ubuntu 12.04 kernel 
(3.2.x), including the mainline kernel version of the MT9P031 driver.  
Once everything is clean and happy I will post info for those still 
trying to get there.  Meanwhile, though, there are some odd issues, and 
a few driver bugs I need to fix and features I need to add.  I wanted to 
reach out to others who are working with this hardware in current (not 
Angstrom 2.6.x) kernels so we can compare notes, and so we don't go off 
in the wrong (or a different) direction on solving some of the problems.

For our application, we are capturing video in raw format (raw Bayer), 
with MT9P031 -> CCDC -> CCDC output (no resizer etc.), reading from 
/dev/video2.  The new media controller framework is pretty cool once you 
get the hang of it - it addresses some significant deficiencies.  I just 
wish the new subdev selection was available, but it's not in 3.2.x... 
hopefully we can move to 3.5 soon and then I just need to implement it 
in the MT9P031 driver (if someone else doesn't do that before I get there).

Some of the issues:

1. To get it working, I had to patch in the Aptina driver mods for 
board-omap3beagle.c etc.  I'm not at all sure this is kosher since I'm 
using the mainline kernel driver, not the Aptina driver (nor the 
RidgeRun one, in which I had to fix a lot of bugs when we were doing 
this on a Leopardboard).  But without these changes, the camera was not 
recognized (likely because it wasn't being powered up).  I would think 
that someone out there must be using the driver in the mainline kernel, 
since it's in there, but how are they getting the camera to be recognized?

2. Max frame rate at full resolution seems to be 6.86 fps.  I think 
we're running at half clock speed.  We'd like to fix that. I can track 
it down, but I don't want to duplicate work already done by someone 
else, and of course this likely relates to issue # 1, above.

3. When I start streaming, then stop streaming, then start streaming 
again without closing and reopening the device in between (and sometimes 
even if I do but reopen right after closing), the second time we start 
streaming, it appears that the green and non-green (red or blue as the 
case may be) pixels are swapped - as if it was offset by one column.  
But if I change the cropping (using VIDIOC_SUBDEV_S_FMT on 
/ev/v4l-subdev8, which is the MT9P031 directly) to include the black 
(inactive) pixels on the top and left, it is still true - but the black 
pixels don't change, only the active ones, even though they still start 
at the same offset (+10,+50 IIRC).  I don't even see how that should be 
possible.  The MT9P031 registers (all of them) are the same whether the 
swapping is occurring or not, and ditto for the CCDC registers per the 
dump in the kernel log.  Has anyone else seen this?  I have worked 
around it for now by closing the device (all of them), sleeping for 2 
ms, and then reopening and reconfiguring.  However, I'd really like to 
find a proper solution, or at least understand the root cause - it's 
kind of disturbing, especially since without the sleep it still didn't 
reliably work correctly.  This may also relate to issue # 1, above.

4. I need to add some additional controls (like a way to manipulate the 
vblank register setting so we can reduce the frame rate without just 
randomly dropping frames - we want to adjust the frame rate to what we 
can fairly reliably store without dropping frames - and access to the 
separate gain controls for R, Gr, Gb, and B, since we're using color 
sensors (cheaper) with IR illumination).  I'd like to get some feedback 
on the most appropriate way to do this.  Obviously I could just hack it 
in, but I'd rather do it right and hopefully get it into the mainline 
driver.  In 3.5-rc2, I see a definition for a VBLANK control, but it 
still isn't clear what ought to be used for separate gain controls.

5. The driver (and likewise the CCDC driver) needs a few small fixes, 
and I'd like to avoid duplication of effort, etc.

Thanks,
       Chris MacGregor

