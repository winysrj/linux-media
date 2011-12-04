Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43784 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630Ab1LDHdg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Dec 2011 02:33:36 -0500
Received: by lagp5 with SMTP id p5so667559lag.19
        for <linux-media@vger.kernel.org>; Sat, 03 Dec 2011 23:33:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABiSWBhsVjrCF3PEWnn6junDU=ora4y6+ikVcKPNhuzLTGjMxA@mail.gmail.com>
References: <CABiSWBhsVjrCF3PEWnn6junDU=ora4y6+ikVcKPNhuzLTGjMxA@mail.gmail.com>
Date: Sun, 4 Dec 2011 08:33:34 +0100
Message-ID: <CABiSWBiwssqOdqmgSTaY-K7VoCDWa0QSmRO4hbSG2SoGQjdi7A@mail.gmail.com>
Subject: Beagleboard-xM rev C + mt9p031 + LI-5M03
From: =?ISO-8859-1?Q?Robert_=C5kerblom=2DAndersson?=
	<robert.nr1@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I have been trying to get the mt9p031 driver to work with a
LI-5M03 camera module and Beagleboard-xM rev C for week's now but I
just can't get it right for some reason.

I have an older version with 2.6.32 kernel that works, so I know that
it's not a hardware problem (even though I have suspected that I have
problems with pullups like mentioned here
http://permalink.gmane.org/gmane.comp.hardware.beagleboard.general/15871).
I'm not sure how I got that old image to work, I only have an image
file and not the sources files left, it might also have been the
Aptina driver (in contrast to the linux-media provided driver I want
to have and are trying to use).

Here is dmesg output: http://pastebin.com/LdfUYkfc The part that are
significantly later in time is from when I tried to use the driver
with the command:
mplayer tv:// -tv driver=v4l2:width=640:height=
480:device=/dev/video1:fps=10 -vo x11
(Mplayer output only: http://pastebin.com/caDjvjV6)

This thread described very similar errors:
https://groups.google.com/forum/#!topic/beagleboard/E90i6pAjAec But
Joel who posted that thread did have a different camera module that
the one I have (I use the same kernel version and the camera that
should be supported).

Something that I do think is a little weird, but I might also be since
I miss some information, is that the errors in the kernel log appear
when using two different devices. Both /dev/video1 and /dev/video2
gives the same error. It feels related to this statment in the kernel
log "#[    2.665954] sysfs: cannot create duplicate filename
'/devices/platform/omap/omap_i2c.2'".

I would be very thankful if someone could help out with some tips on
how to get this to work. I'm been up so many nights now without any
real progress that I need to do something different.

If someone want to reproduce my scenario it possible to do with help
of this one liner:
git clone git://github.com/Scorpiion/Renux_Kernel.git && cd
Renux_Kernel && git submodule init && git submodule update &&
./buildKernel.bash

It basically just downloads kernel sources, checks out a tag branch
depending on a settings file (settings/build.conf, v2.6.39 in this
case), applies some patches (collected from openembedded) and then
compiles the kernel. I guess you first thought might be that I should
use Ångstrom, and yes, maybe I should, but I have had problems with
bitbake and Ångstrom, it gives me errors all the time. I also thinks
it fun to do write scripts like these, it's a good learning
experience. (Linux tree is from git tmlind OMAP, openembedded patches
(camera patches is there) directory  recipes/linux/linux-omap-2.6.39,
git tag "v2.6.39")

The cross compilation toolchain I've used is also homemade or so to
speak, but I don't think it should be a problem. I have compiled many
many kernels by now and never got any compiler errors, so I don't
think that the problem. It is based on Gcc 4.5. And if someone is
interested my script to build it, it is here:
git://github.com/Scorpiion/Renux_cross_toolchain.git

I have tested it on several different Ubuntu machines (32 and 64 bits)
and it have worked very good. The only requirement except normal build
stuff is Gcc 4.5, does not work with 4.4 or 4.6 I think. The only
think you need to do is to run:
./createCrossToolchain.bash
A cleaned progress output can be viewed in a different terminal during
the build.

Ps. I'm not that very used to mailing lists, and I know there are
rules etc even thought I don't know them all. If my post is to long or
in some other way not as it suppose to be feel free to point it out
and I'll do it better next time. Ds.

--
Regards, Robert Åkerblom-Andersson
