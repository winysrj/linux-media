Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51001 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab2F0JaY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 05:30:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Chris MacGregor <chris@cybermato.com>
Cc: linux-media@vger.kernel.org
Subject: Re: hacking MT9P031 (LI-5M03) driver in Ubuntu 12.04 on BeagleBoard xM?
Date: Wed, 27 Jun 2012 11:30:26 +0200
Message-ID: <3242652.yHvnWhQcZZ@avalon>
In-Reply-To: <4FE34DF3.6070009@cybermato.com>
References: <ade8080d-dbbf-4b60-804c-333d7340c01e@googlegroups.com> <4FE34DF3.6070009@cybermato.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Thursday 21 June 2012 09:38:11 Chris MacGregor wrote:
> Hi.  I was redirected to this list by a response to my post (below) on
> the BeagleBoard group.  I'm happy to help/cooperate/etc. in whatever way
> I reasonably can.
> 
> -------- Original Message --------
> 
> Hello, all.
> 
> I managed to get the MT9P031 driver (for the Leopard Imaging LI-5M03 camera
> board) working using a slightly modified Ubuntu 12.04 kernel, including the
> mainline kernel version of the MT9P031 driver. Once everything is clean and
> happy I will post info for those still trying to get there. Meanwhile,
> though, there are some odd issues, and a few driver bugs I need to fix and
> features I need to add. I wanted to reach out to others who are working with
> this hardware in current (not Angstrom 2.6.x) kernels so we can compare
> notes, and so we don't go off in the wrong (or a different) direction on
> solving some of the problems.
> 
> For our application, we are capturing video in raw format (raw Bayer), with
> MT9P031 -> CCDC -> CCDC output (no resizer etc.), reading from /dev/video2. 
> The new media controller framework is pretty cool once you get the hang of
> it - it addresses some significant deficiencies.

Thank you :-)

> I just wish the new subdev selection was available, but it's not in 3.2.x...
> hopefully we can move to 3.5 soon and then I just need to implement it in
> the MT9P031 driver (if someone else doesn't do that before I get there).
> 
> Some of the issues:
> 
> 1. To get it working, I had to patch in the Aptina driver mods for board-
> omap3beagle.c etc. I'm not at all sure this is kosher since I'm using the
> mainline kernel driver, not the Aptina driver (nor the RidgeRun one, in
> which I had to fix a lot of bugs when we were doing this on a Leopardboard). 
> But without these changes, the camera was not recognized (likely because it
> wasn't being powered up). I would think that someone out there must be using
> the driver in the mainline kernel, since it's in there, but how are they
> getting the camera to be recognized?

Unlike on PC hardware, operating systems on embedded hardware usually can't 
discover devices at runtime. The Linux kernel thus needs a list of the devices 
present on the system (both inside the SoC and on the board) to handle them 
properly.

That list is usually hardcoded in board code, and the Linux kernel on ARM 
recently started a migration to the Device Tree that provides such a hardware 
description from outside the kernel.

Devices present inside the SoC or directly on the board are not removable and 
can be hardcoded in board code or in the device tree. However, devices that 
come on add-on boards are problematic as they're not always present and can be 
replaced.

Several sensor modules exist for the Beagleboard-xM, we can't hardcode support 
for one of them in the mainline kernel. There's currently no way to properly 
support the different sensor modules with a single kernel, mostly because 
nobody developed a solution so far (although proposals have been posted to 
mailing lists).

For that reason I currently maintain board code with sensor support for 
several OMAP3 platforms in the omap3isp-sensors-board branch of my git tree at 
http://git.linuxtv.org/pinchartl/media.git. I'd be happy to push that to 
mainline if we had a good technical solution.

Where did you get the Aptina board code patch from ?

> 2. Max frame rate at full resolution seems to be 6.86 fps. I think we're
> running at half clock speed. We'd like to fix that. I can track it down, but
> I don't want to duplicate work already done by someone else, and of course
> this likely relates to issue # 1, above.

The clock speed is configurable, but the device is limited to 48 MHz when 
using 1.8V I/O. To reach 96 MHz we would have to power the I/O supply with 
2.8V and add a level shifter on the board, as the OMAP3 use 1/8V I/O.

> 3. When I start streaming, then stop streaming, then start streaming again
> without closing and reopening the device in between (and sometimes even if I
> do but reopen right after closing), the second time we start streaming, it
> appears that the green and non-green (red or blue as the case may be) pixels
> are swapped - as if it was offset by one column. But if I change the
> cropping (using VIDIOC_SUBDEV_S_FMT on /ev/v4l-subdev8, which is the MT9P031
> directly) to include the black (inactive) pixels on the top and left, it is
> still true - but the black pixels don't change, only the active ones, even
> though they still start at the same offset (+10,+50 IIRC). I don't even see
> how that should be possible.

Just to make sure I understand that properly, do you mean that the boundary 
between the black and non-black pixels doesn't move, when you expected it to 
be shifted by one column or one line if the color swap had been caused by an 
image shift ? Did you include both black lines and black columns in your test 
?

> The MT9P031 registers (all of them) are the same whether the swapping is
> occurring or not, and ditto for the CCDC registers per the dump in the
> kernel log. Has anyone else seen this? I have worked around it for now by
> closing the device (all of them), sleeping for 2 ms, and then reopening and
> reconfiguring. However, I'd really like to find a proper solution, or at
> least understand the root cause - it's kind of disturbing, especially since
> without the sleep it still didn't reliably work correctly. This may also
> relate to issue # 1, above.

I've never experienced that issue and I'm quite surprised. I'd like to check 
your board code first (although if all registers are identical it shouldn't 
play a big role).

What's your test procedure ?

> 4. I need to add some additional controls (like a way to manipulate the
> vblank register setting so we can reduce the frame rate without just
> randomly dropping frames - we want to adjust the frame rate to what we can
> fairly reliably store without dropping frames - and access to the separate
> gain controls for R, Gr, Gb, and B, since we're using color sensors
> (cheaper) with IR illumination). I'd like to get some feedback on the most
> appropriate way to do this. Obviously I could just hack it in, but I'd
> rather do it right and hopefully get it into the mainline driver. In
> 3.5-rc2, I see a definition for a VBLANK control,

That's the one you should use.

> but it still isn't clear what ought to be used for separate gain controls.

We need new per-component gain controls. The usual way to do this is to post a 
proposal to the linux-media mailing list, either in plain English if you want 
initial feedback on a complex idea before implementing it, or as a patch 
(don't forget to update Documentation/DocBook/media/v4l/controls.xml).

> 5. The driver (and likewise the CCDC driver) needs a few small fixes, and
> I'd like to avoid duplication of effort, etc.

The latest version of the driver with the patches that should be included in 
the next kernel version is available from my git tree (omap3isp-omap3isp-next 
branch, please note that the branch is regularly rebased). If the fixes are 
not included there, the best way to avoid effort duplication is to post a mail 
to the list with the description of the problem(s). If nobody answers with a 
patch, you will have to write one yourself. For very small fixes posting a 
patch up-front is usually easier and even less time-consuming.

-- 
Regards,

Laurent Pinchart

