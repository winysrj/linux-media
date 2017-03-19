Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37436
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752053AbdCSQ7O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 19 Mar 2017 12:59:14 -0400
Date: Sun, 19 Mar 2017 13:58:54 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Eric Anholt <eric@anholt.net>
Cc: Michael Zoran <mzoran@crowfest.net>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
Message-ID: <20170319135846.395feef8@vento.lan>
In-Reply-To: <87shmbv2w3.fsf@eliezer.anholt.net>
References: <20170127215503.13208-1-eric@anholt.net>
        <20170315110128.37e2bc5a@vento.lan>
        <87a88m19om.fsf@eliezer.anholt.net>
        <20170315220834.7019fd8b@vento.lan>
        <1489628784.8127.1.camel@crowfest.net>
        <20170316062900.0e835118@vento.lan>
        <87shmbv2w3.fsf@eliezer.anholt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 17 Mar 2017 17:34:36 -0700
Eric Anholt <eric@anholt.net> escreveu:

> Mauro Carvalho Chehab <mchehab@s-opensource.com> writes:
> 
> > Em Wed, 15 Mar 2017 18:46:24 -0700
> > Michael Zoran <mzoran@crowfest.net> escreveu:
> >
> >> On Wed, 2017-03-15 at 22:08 -0300, Mauro Carvalho Chehab wrote:
> >> 
> >> > No, I didn't. Thanks! Applied it but, unfortunately, didn't work.
> >> > Perhaps I'm missing some other patch. I'm compiling it from
> >> > the Greg's staging tree (branch staging-next):
> >> > 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.
> >> > git/log/?h=staging-next
> >> > 
> >> > Btw, as I'm running Raspbian, and didn't want to use compat32 bits, 
> >> > I'm compiling the Kernel as an arm32 bits Kernel.
> >> > 
> >> > I did a small trick to build the DTB on arm32:
> >> > 
> >> > 	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
> >> > arch/arm/boot/dts/bcm2837-rpi-3-b.dts
> >> > 	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837.dtsi
> >> > arch/arm/boot/dts/bcm2837.dtsi
> >> > 	git checkout arch/arm/boot/dts/Makefile
> >> > 	sed "s,bcm2835-rpi-zero.dtb,bcm2835-rpi-zero.dtb bcm2837-rpi-3-
> >> > b.dtb," a && mv a arch/arm/boot/dts/Makefile
> >> >   
> >> 
> >> Two other hacks are currently needed to get the camera to work:
> >> 
> >> 1. Add this to config.txt(This required to get the firmware to detect
> >> the camera)
> >> 
> >> start_x=1
> >> gpu_mem=128
> >
> > I had this already.
> >
> >> 
> >> 2. VC4 is incompatible with the firmware at this time, so you need 
> >> to presently munge the build configuration. What you do is leave
> >> simplefb in the build config(I'm assuming you already have that), but
> >> you will need to remove VC4 from the config.
> >> 
> >> The firmware currently adds a node for a simplefb for debugging
> >> purposes to show the boot log.  Surprisingly, this is still good enough
> >> for basic usage and testing.  
> >
> > That solved the issue. Thanks! It would be good to add a notice
> > about that at the TODO, not let it build if DRM_VC4.
> >
> > Please consider applying the enclosed path.
> 
> The VC4 incompatibility (camera firmware's AWB ends up briefly using the
> GPU, without coordinating with the Linux driver) is supposed to be fixed
> in current firmware
> (https://github.com/raspberrypi/firmware/issues/760#issuecomment-287391025)

With the current firmware, when X starts, the screen becomes blank,
with upstream Kernel (it works with the downstream Kernel shipped with 
the firmware).

Maybe something changed at DT?

Thanks,
Mauro
