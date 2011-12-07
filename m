Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51429 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab1LGBr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 20:47:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Robert =?iso-8859-1?q?=C5kerblom-Andersson?=" <robert.nr1@gmail.com>
Subject: Re: Beagleboard-xM rev C + mt9p031 + LI-5M03
Date: Wed, 7 Dec 2011 02:47:32 +0100
Cc: linux-media@vger.kernel.org
References: <CABiSWBhsVjrCF3PEWnn6junDU=ora4y6+ikVcKPNhuzLTGjMxA@mail.gmail.com> <CABiSWBiwssqOdqmgSTaY-K7VoCDWa0QSmRO4hbSG2SoGQjdi7A@mail.gmail.com>
In-Reply-To: <CABiSWBiwssqOdqmgSTaY-K7VoCDWa0QSmRO4hbSG2SoGQjdi7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112070247.34280.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Sunday 04 December 2011 08:33:34 Robert Åkerblom-Andersson wrote:
> Hi, I have been trying to get the mt9p031 driver to work with a
> LI-5M03 camera module and Beagleboard-xM rev C for week's now but I
> just can't get it right for some reason.
> 
> I have an older version with 2.6.32 kernel that works, so I know that
> it's not a hardware problem (even though I have suspected that I have
> problems with pullups like mentioned here
> http://permalink.gmane.org/gmane.comp.hardware.beagleboard.general/15871).
> I'm not sure how I got that old image to work, I only have an image
> file and not the sources files left, it might also have been the
> Aptina driver (in contrast to the linux-media provided driver I want
> to have and are trying to use).
> 
> Here is dmesg output: http://pastebin.com/LdfUYkfc The part that are
> significantly later in time is from when I tried to use the driver
> with the command:
> mplayer tv:// -tv driver=v4l2:width=640:height=
> 480:device=/dev/video1:fps=10 -vo x11
> (Mplayer output only: http://pastebin.com/caDjvjV6)
> 
> This thread described very similar errors:
> https://groups.google.com/forum/#!topic/beagleboard/E90i6pAjAec But
> Joel who posted that thread did have a different camera module that
> the one I have (I use the same kernel version and the camera that
> should be supported).
> 
> Something that I do think is a little weird, but I might also be since
> I miss some information, is that the errors in the kernel log appear
> when using two different devices. Both /dev/video1 and /dev/video2
> gives the same error. It feels related to this statment in the kernel
> log "#[    2.665954] sysfs: cannot create duplicate filename
> '/devices/platform/omap/omap_i2c.2'".

Your platform core registers I2C bus 2 twice, once through OMAP hwmod, and 
once in arch/arm/mach-omap2/board-omap3beagle-camera.c:

	omap_register_i2c_bus(2, 100, NULL, 0);

Removing this second registration should get rid of the associated warnings.

You then get a failure to register the sensor:

[    2.670928] isp_register_subdev_group: Unable to register subdev mt9p031

Is the mt9p031 driver built in ? If you want to build it as a module, the 
omap3-isp driver needs to be built as a module as well.

The warnings shown at the bottom of your log are caused by an omap3-isp driver 
bug. A fix is available at 
http://git.linuxtv.org/pinchartl/media.git/commit/a361d1cfec0ac0901a680a6a77dc21ee0531a542. 
I will push it to v3.3.

> I would be very thankful if someone could help out with some tips on
> how to get this to work. I'm been up so many nights now without any
> real progress that I need to do something different.
> 
> If someone want to reproduce my scenario it possible to do with help
> of this one liner:
> git clone git://github.com/Scorpiion/Renux_Kernel.git && cd
> Renux_Kernel && git submodule init && git submodule update &&
> ./buildKernel.bash
> 
> It basically just downloads kernel sources, checks out a tag branch
> depending on a settings file (settings/build.conf, v2.6.39 in this
> case), applies some patches (collected from openembedded) and then
> compiles the kernel. I guess you first thought might be that I should
> use Ångstrom, and yes, maybe I should, but I have had problems with
> bitbake and Ångstrom, it gives me errors all the time. I also thinks
> it fun to do write scripts like these, it's a good learning
> experience. (Linux tree is from git tmlind OMAP, openembedded patches
> (camera patches is there) directory  recipes/linux/linux-omap-2.6.39,
> git tag "v2.6.39")
> 
> The cross compilation toolchain I've used is also homemade or so to
> speak, but I don't think it should be a problem. I have compiled many
> many kernels by now and never got any compiler errors, so I don't
> think that the problem. It is based on Gcc 4.5. And if someone is
> interested my script to build it, it is here:
> git://github.com/Scorpiion/Renux_cross_toolchain.git
> 
> I have tested it on several different Ubuntu machines (32 and 64 bits)
> and it have worked very good. The only requirement except normal build
> stuff is Gcc 4.5, does not work with 4.4 or 4.6 I think. The only
> think you need to do is to run:
> ./createCrossToolchain.bash
> A cleaned progress output can be viewed in a different terminal during
> the build.
> 
> Ps. I'm not that very used to mailing lists, and I know there are
> rules etc even thought I don't know them all. If my post is to long or
> in some other way not as it suppose to be feel free to point it out
> and I'll do it better next time. Ds.

You did a very good job, explaining your problem and providing related 
important information such as the kernel log contents.

-- 
Regards,

Laurent Pinchart
