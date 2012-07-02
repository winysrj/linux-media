Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45215 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2GBMsu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2012 08:48:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Chris MacGregor <chris@cybermato.com>
Cc: linux-media@vger.kernel.org
Subject: Re: hacking MT9P031 (LI-5M03) driver in Ubuntu 12.04 on BeagleBoard xM?
Date: Mon, 02 Jul 2012 14:48:57 +0200
Message-ID: <4301383.IPfSC38GGz@avalon>
In-Reply-To: <4FED31EC.7010705@cybermato.com>
References: <ade8080d-dbbf-4b60-804c-333d7340c01e@googlegroups.com> <3242652.yHvnWhQcZZ@avalon> <4FED31EC.7010705@cybermato.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,

On Thursday 28 June 2012 21:41:16 Chris MacGregor wrote:
> On 06/27/2012 02:30 AM, Laurent Pinchart wrote:
> > On Thursday 21 June 2012 09:38:11 Chris MacGregor wrote:
> >> ...
> >> 
> >> Some of the issues:
> >> 
> >> 1. To get it working, I had to patch in the Aptina driver mods for board-
> >> omap3beagle.c etc. I'm not at all sure this is kosher since I'm using the
> >> mainline kernel driver, not the Aptina driver (nor the RidgeRun one, in
> >> which I had to fix a lot of bugs when we were doing this on a
> >> Leopardboard). But without these changes, the camera was not recognized
> >> (likely because it wasn't being powered up). I would think that someone
> >> out there must be using the driver in the mainline kernel, since it's in
> >> there, but how are they getting the camera to be recognized?
> > 
> > Unlike on PC hardware, operating systems on embedded hardware usually
> > can't discover devices at runtime. The Linux kernel thus needs a list of
> > the devices present on the system (both inside the SoC and on the board)
> > to handle them properly.
> > 
> > That list is usually hardcoded in board code, and the Linux kernel on ARM
> > recently started a migration to the Device Tree that provides such a
> > hardware description from outside the kernel.
> > 
> > Devices present inside the SoC or directly on the board are not removable
> > and can be hardcoded in board code or in the device tree. However,
> > devices that come on add-on boards are problematic as they're not always
> > present and can be replaced.
> > 
> > Several sensor modules exist for the Beagleboard-xM, we can't hardcode
> > support for one of them in the mainline kernel. There's currently no way
> > to properly support the different sensor modules with a single kernel,
> > mostly because nobody developed a solution so far (although proposals
> > have been posted to mailing lists).
> > 
> > For that reason I currently maintain board code with sensor support for
> > several OMAP3 platforms in the omap3isp-sensors-board branch of my git
> > tree at http://git.linuxtv.org/pinchartl/media.git. I'd be happy to push
> > that to mainline if we had a good technical solution.
> 
> I was expecting that the code would be in there somewhere, but (for the
> reason you describe) not enabled by default. I was expecting that I might
> need to tweak the kernel config to enable the sensor support (and indeed I
> did), but I was very surprised that code necessary to make it actually work
> was nowhere in sight.
> 
> I would (naively, perhaps) think that it would be appropriate to have the
> code present, but enabled only if both MACH_OMAP3_BEAGLE and VIDEO_MT9P031
> are enabled.  What am I missing?

We're trying to move to a single kernel image for all ARMv7 platforms. A 
compile-time option wouldn't allow that., the option must be runtime-
configurable (possibly through a kernel command line argument, or through the 
device tree).

> I took a look at your branch (briefly). The Ubuntu 12.04 kernel is currently
> based on a roughly 3.2.x (maybe 3.2.18?) kernel. Do you happen to have a
> version of the board files that would be likely to work well on that
> vintage?

No, but it should be very easy to backport the code.

> Or for that matter, do you have a recommendation as to what (whose) kernel
> would be my best bet for production use in a BeagleBoard xM (rev C, maybe
> some B's) using the Leopard Imaging LI-5M03 camera board? I get the sense
> that the BB xM community is mostly on 3.2.x (or older) at the moment, and I
> hesitate to assume there isn't a good reason for that. But if some kernel
> newer than Ubuntu's is reasonably stable and trustworthy on a BB xM, I'd be
> happy enough to use it. (I do intend to continue with the Ubuntu 12.04 world
> for everything other than the kernel.)

I usually upgrade to the latest stable kernels when they are released, until 
there's a need to freeze the code base. Depending on your support 
requirements, picking up a long term stable version can be a good idea.

> > Where did you get the Aptina board code patch from ?
> 
>  From here: https://github.com/Aptina/BeagleBoard-xM

That's definitely outdated, the code is based on a very old OMAP3 ISP driver 
that was more or less broken by design. Nowadays anything other than the 
mainline version isn't supported by the community.

> Which is linked to from here:
> http://blog.galemin.com/2011/04/li-5m03-camera-on-beagleboard-xm/
> 
> I started in trying to get the cameras working on our BeagleBoards (as
> the first step in switching from Leopardboards, with the same cameras),
> and quickly found that it was not at all obvious how to get the MT9P031
> to be recognized in Ubuntu's kernel, nor in Robert C. Nelson's. I googled
> around and found Max Galemin's stuff, which got me a kernel that recognized
> the sensor but had some other quirks. Further googling in search of an
> answer to why it worked in Max's kernel but not the others - despite no
> visibly relevant difference in the driver sources - led me to the above, or
> maybe I followed the link from Max's blog - I don't remember at this point.
> The patch file in there was the most significant clue, and so I crossed my
> fingers and patched in the files under arch/arm, and sure enough, it worked. 
> Mostly...
> 
> >> 2. Max frame rate at full resolution seems to be 6.86 fps. I think we're
> >> running at half clock speed. We'd like to fix that. I can track it down,
> >> but I don't want to duplicate work already done by someone else, and of
> >> course this likely relates to issue # 1, above.
> > 
> > The clock speed is configurable, but the device is limited to 48 MHz when
> > using 1.8V I/O. To reach 96 MHz we would have to power the I/O supply with
> > 2.8V and add a level shifter on the board, as the OMAP3 use 1/8V I/O.
> 
> This is definitely something we'll want to pursue.  Some of the organisms
> we're trying to watch (this is for University of Washington Seattle's
> Oceanography Dept.) move fast enough that we want the full frame rate (~14
> fps) or closer to it. We can use cropping to increase the frame rate, but
> sometimes we need the full field of view as well.
> 
> Do you have or can you point me to more details on the mods needed, both in
> the software and in the hardware?  (Has anyone out there already done this
> successfully?)

I'm not aware of any sensor module with a 2.8V to 1.8V level shifter. If you 
want to ran the MT9P031 at 96 MHz with a Beagleboard-xM the best way would 
probably to design your own sensor board.

> >> 3. When I start streaming, then stop streaming, then start streaming
> >> again without closing and reopening the device in between (and sometimes
> >> even if I do but reopen right after closing), the second time we start
> >> streaming, it appears that the green and non-green (red or blue as the
> >> case may be) pixels are swapped - as if it was offset by one column. But
> >> if I change the cropping (using VIDIOC_SUBDEV_S_FMT on /ev/v4l-subdev8,
> >> which is the MT9P031 directly) to include the black (inactive) pixels on
> >> the top and left, it is still true - but the black pixels don't change,
> >> only the active ones, even though they still start at the same offset
> >> (+10,+50 IIRC). I don't even see how that should be possible.
> > 
> > Just to make sure I understand that properly, do you mean that the
> > boundary between the black and non-black pixels doesn't move, when you
> > expected it to be shifted by one column or one line if the color swap had
> > been caused by an image shift ?
> 
> Yes, precisely that.
> 
> > Did you include both black lines and black columns in your test ?
> 
> Yes.  I set the crop region to start at (0,0), so I got 10 black columns
> and 50 black lines, IIRC.
> 
> >> The MT9P031 registers (all of them) are the same whether the swapping is
> >> occurring or not, and ditto for the CCDC registers per the dump in the
> >> kernel log. Has anyone else seen this? I have worked around it for now by
> >> closing the device (all of them), sleeping for 2 ms, and then reopening
> >> and reconfiguring. However, I'd really like to find a proper solution, or
> >> at least understand the root cause - it's kind of disturbing, especially
> >> since without the sleep it still didn't reliably work correctly. This may
> >> also relate to issue # 1, above.
> > 
> > I've never experienced that issue and I'm quite surprised. I'd like to
> > check your board code first (although if all registers are identical it
> > shouldn't play a big role).
> 
> Agreed, I'm highly suspicious of my current configuration, given how I
> arrived at it.  :-)
> 
> > What's your test procedure ?
> 
> I'm not sure I understand what you're asking for. I have an app that
> configures everything (media controller, v4l-subdev8 for the mt9p031, etc.)
> and then starts streaming, capturing to a file or the network. The app can
> keep the device open, and under control of the UI, start and stop streaming
> repeatedly. After a while I figured out that the swapping/shifting problem
> often happened about every other time I started streaming (though not 100%
> consistently). Eventually I was able to find that closing the device and
> reopening it would generally avoid the problem; when I did that from the UI
> it worked pretty well, but not when I did it directly within the code, until
> I added the 2 ms sleep. So by the end, my test procedure was to start it,
> see if it was screwed up or not, stop it, and repeat. Once I added the
> sleep, it seemed to be good enough as a temporary solution - I couldn't
> delay any longer. The critters are in the water, and their schedule does not
> change no matter how good my excuses... :-/
> 
> >> 4. I need to add some additional controls (like a way to manipulate the
> >> vblank register setting so we can reduce the frame rate without just
> >> randomly dropping frames - we want to adjust the frame rate to what we
> >> can fairly reliably store without dropping frames - and access to the
> >> separate gain controls for R, Gr, Gb, and B, since we're using color
> >> sensors (cheaper) with IR illumination). I'd like to get some feedback on
> >> the most appropriate way to do this. Obviously I could just hack it in,
> >> but I'd rather do it right and hopefully get it into the mainline driver.
> >> In 3.5-rc2, I see a definition for a VBLANK control,
> > 
> > That's the one you should use.
> > 
> >> but it still isn't clear what ought to be used for separate gain
> >> controls.
> > 
> > We need new per-component gain controls. The usual way to do this is to
> > post a proposal to the linux-media mailing list, either in plain English
> > if you want initial feedback on a complex idea before implementing it, or
> > as a patch (don't forget to update
> > Documentation/DocBook/media/v4l/controls.xml).
>
> Thanks, I'll do that.  I wanted to find out what the consensus was on
> the general concept (e.g., do people agree that this is best addressed
> by exposing new per-component gain controls) before I took that step.
> I'll take your statement above as a sufficient consensus for now.  :-)
> 
> One sticky bit is that the driver currently implements a one-gain-to-fit-
> them-all approach. Should I replace that with the new ones (simple and clean
> but breaks current users of it), or try to figure out a way for them to co-
> exist in a meaningful and coherent way (appears hairy and error-prone, but
> preserves compatibility)?

We could remove the global gain control, and group the per-component controls 
in a cluster. That way, if the 4 gains are equal, the driver could perform a 
single I2C write instead of 4.

> >> 5. The driver (and likewise the CCDC driver) needs a few small fixes, and
> >> I'd like to avoid duplication of effort, etc.
> > 
> > The latest version of the driver with the patches that should be included
> > in the next kernel version is available from my git tree
> > (omap3isp-omap3isp-next branch, please note that the branch is regularly
> > rebased). If the fixes are not included there, the best way to avoid
> > effort duplication is to post a mail to the list with the description of
> > the problem(s). If nobody answers with a patch, you will have to write
> > one yourself. For very small fixes posting a patch up-front is usually
> > easier and even less time-consuming.
> 
> Okay, I'll post questions and/or patches here.  (Aiming for patches, but
> starting with questions where it seems appropriate.)
> 
> One other issue that it would be nice to address is why one or two frames
> (perhaps three, sometimes?) are corrupted at the start of streaming. I don't
> think it's inherent to the sensor, since we never saw that with the very
> same sensor and camera board on a Leopardboard (DM365). So it's either
> OMAP3-specific, or something in the drivers. I'm happy to help chase this
> down, but hoping someone else has already gotten a start on it.  Any clues
> out there?

How corrupt are they ?

-- 
Regards,

Laurent Pinchart

