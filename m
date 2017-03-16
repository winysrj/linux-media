Return-path: <linux-media-owner@vger.kernel.org>
Received: from gw.crowfest.net ([52.42.241.221]:56686 "EHLO gw.crowfest.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750988AbdCPBqZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 21:46:25 -0400
Message-ID: <1489628784.8127.1.camel@crowfest.net>
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
From: Michael Zoran <mzoran@crowfest.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Eric Anholt <eric@anholt.net>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Date: Wed, 15 Mar 2017 18:46:24 -0700
In-Reply-To: <20170315220834.7019fd8b@vento.lan>
References: <20170127215503.13208-1-eric@anholt.net>
         <20170315110128.37e2bc5a@vento.lan> <87a88m19om.fsf@eliezer.anholt.net>
         <20170315220834.7019fd8b@vento.lan>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2017-03-15 at 22:08 -0300, Mauro Carvalho Chehab wrote:

> No, I didn't. Thanks! Applied it but, unfortunately, didn't work.
> Perhaps I'm missing some other patch. I'm compiling it from
> the Greg's staging tree (branch staging-next):
> 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.
> git/log/?h=staging-next
> 
> Btw, as I'm running Raspbian, and didn't want to use compat32 bits, 
> I'm compiling the Kernel as an arm32 bits Kernel.
> 
> I did a small trick to build the DTB on arm32:
> 
> 	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
> arch/arm/boot/dts/bcm2837-rpi-3-b.dts
> 	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837.dtsi
> arch/arm/boot/dts/bcm2837.dtsi
> 	git checkout arch/arm/boot/dts/Makefile
> 	sed "s,bcm2835-rpi-zero.dtb,bcm2835-rpi-zero.dtb bcm2837-rpi-3-
> b.dtb," a && mv a arch/arm/boot/dts/Makefile
> 

Two other hacks are currently needed to get the camera to work:

1. Add this to config.txt(This required to get the firmware to detect
the camera)

start_x=1
gpu_mem=128

2. VC4 is incompatible with the firmware at this time, so you need 
to presently munge the build configuration. What you do is leave
simplefb in the build config(I'm assuming you already have that), but
you will need to remove VC4 from the config.

The firmware currently adds a node for a simplefb for debugging
purposes to show the boot log.  Surprisingly, this is still good enough
for basic usage and testing.  

The only remaining issue is that since simplefb is intented for
debugging, you wan't be able to use many of the RPI specific
applications.  

I've been using cheese and ffmpeg to test the camera which are not RPI
specific.
