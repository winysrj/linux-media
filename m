Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52574
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751055AbdCPJf6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Mar 2017 05:35:58 -0400
Date: Thu, 16 Mar 2017 06:29:00 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Michael Zoran <mzoran@crowfest.net>
Cc: Eric Anholt <eric@anholt.net>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
Message-ID: <20170316062900.0e835118@vento.lan>
In-Reply-To: <1489628784.8127.1.camel@crowfest.net>
References: <20170127215503.13208-1-eric@anholt.net>
        <20170315110128.37e2bc5a@vento.lan>
        <87a88m19om.fsf@eliezer.anholt.net>
        <20170315220834.7019fd8b@vento.lan>
        <1489628784.8127.1.camel@crowfest.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 15 Mar 2017 18:46:24 -0700
Michael Zoran <mzoran@crowfest.net> escreveu:

> On Wed, 2017-03-15 at 22:08 -0300, Mauro Carvalho Chehab wrote:
> 
> > No, I didn't. Thanks! Applied it but, unfortunately, didn't work.
> > Perhaps I'm missing some other patch. I'm compiling it from
> > the Greg's staging tree (branch staging-next):
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.
> > git/log/?h=staging-next
> > 
> > Btw, as I'm running Raspbian, and didn't want to use compat32 bits, 
> > I'm compiling the Kernel as an arm32 bits Kernel.
> > 
> > I did a small trick to build the DTB on arm32:
> > 
> > 	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dts
> > arch/arm/boot/dts/bcm2837-rpi-3-b.dts
> > 	ln -sf ../../../arm64/boot/dts/broadcom/bcm2837.dtsi
> > arch/arm/boot/dts/bcm2837.dtsi
> > 	git checkout arch/arm/boot/dts/Makefile
> > 	sed "s,bcm2835-rpi-zero.dtb,bcm2835-rpi-zero.dtb bcm2837-rpi-3-
> > b.dtb," a && mv a arch/arm/boot/dts/Makefile
> >   
> 
> Two other hacks are currently needed to get the camera to work:
> 
> 1. Add this to config.txt(This required to get the firmware to detect
> the camera)
> 
> start_x=1
> gpu_mem=128

I had this already.

> 
> 2. VC4 is incompatible with the firmware at this time, so you need 
> to presently munge the build configuration. What you do is leave
> simplefb in the build config(I'm assuming you already have that), but
> you will need to remove VC4 from the config.
> 
> The firmware currently adds a node for a simplefb for debugging
> purposes to show the boot log.  Surprisingly, this is still good enough
> for basic usage and testing.  

That solved the issue. Thanks! It would be good to add a notice
about that at the TODO, not let it build if DRM_VC4.

Please consider applying the enclosed path.

> The only remaining issue is that since simplefb is intented for
> debugging, you wan't be able to use many of the RPI specific
> applications.  
> 
> I've been using cheese and ffmpeg to test the camera which are not RPI
> specific.

I did a quick test with camorama and qv4l2. it worked with both.

Thanks,
Mauro


[PATCH] staging: bcm2835-camera: make it dependent of !DRM_VC4

Currently, if DRM_VC4 is enabled, this driver doesn't work,
as the firmware doesn't support having both enabled at the
same time.

Document that and prevent it to be built if !DRM_VC4.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

diff --git a/drivers/staging/vc04_services/bcm2835-camera/Kconfig b/drivers/staging/vc04_services/bcm2835-camera/Kconfig
index b8b01aa4e426..678dc2efb91a 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/Kconfig
+++ b/drivers/staging/vc04_services/bcm2835-camera/Kconfig
@@ -2,6 +2,8 @@ config VIDEO_BCM2835
 	tristate "BCM2835 Camera"
 	depends on MEDIA_SUPPORT
 	depends on VIDEO_V4L2 && (ARCH_BCM2835 || COMPILE_TEST)
+	# Currently, firmware is incompatible with VC4 DRM driver
+	depends on !DRM_VC4
 	select BCM2835_VCHIQ
 	select VIDEOBUF2_VMALLOC
 	select BTREE
diff --git a/drivers/staging/vc04_services/bcm2835-camera/TODO b/drivers/staging/vc04_services/bcm2835-camera/TODO
index 61a509992b9a..fec70a1cc4a3 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/TODO
+++ b/drivers/staging/vc04_services/bcm2835-camera/TODO
@@ -37,3 +37,4 @@ v4l2 module after VCHI loads.
 This was a temporary workaround for a bug that was fixed mid-2014, and
 we should remove it before stabilizing the driver.
 
+6) Make firmware compatible with both DRM_VC4 and VIDEO_BCM2835.
