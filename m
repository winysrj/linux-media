Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51977 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab2HXXos (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 19:44:48 -0400
Received: by wgbdr13 with SMTP id dr13so1880369wgb.1
        for <linux-media@vger.kernel.org>; Fri, 24 Aug 2012 16:44:47 -0700 (PDT)
Message-ID: <503811EC.8030808@gmail.com>
Date: Sat, 25 Aug 2012 01:44:44 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 10/12] [media] move i2c files into drivers/media/i2c
References: <502AC079.50902@gmail.com> <1345038500-28734-1-git-send-email-mchehab@redhat.com> <1345038500-28734-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1345038500-28734-11-git-send-email-mchehab@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------010905010706050806040603"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010905010706050806040603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Mauro,

On 08/15/2012 03:48 PM, Mauro Carvalho Chehab wrote:
> Move ancillary I2C drivers into drivers/media/i2c, in order to
> better organize them.
> 
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
> ---
>   drivers/media/Kconfig                              |   9 +-
>   drivers/media/Makefile                             |   2 +-
>   drivers/media/i2c/Kconfig                          | 566 ++++++++++++++++++++
>   drivers/media/i2c/Makefile                         |  63 +++
>   drivers/media/{video =>  i2c}/adp1653.c             |   2 +-
...
>   rename drivers/media/{video =>  i2c}/wm8775.c (100%)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index c9cdc61..26f3de5 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -151,18 +151,15 @@ source "drivers/media/rc/Kconfig"
> 
>   source "drivers/media/tuners/Kconfig"
> 
> +source "drivers/media/i2c/Kconfig"
> +
>   #
> -# Video/Radio/Hybrid adapters
> +# V4L platform/mem2mem drivers
>   #
> -
>   source "drivers/media/video/Kconfig"
> 
>   source "drivers/media/radio/Kconfig"
> 
> -#
> -# DVB adapters
> -#
> -
>   source "drivers/media/pci/Kconfig"
>   source "drivers/media/usb/Kconfig"
>   source "drivers/media/mmc/Kconfig"
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index 360c44d..e1be196 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -9,7 +9,7 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
>   endif
> 
>   obj-y += tuners/ common/ rc/ video/
> -obj-y += pci/ usb/ mmc/ firewire/ parport/
> +obj-y += i2c/ pci/ usb/ mmc/ firewire/ parport/

That way all i2c drivers won't be linked before bridge drivers, which
causes failure of sensor subdev registration. There was a comment
about it in the original Makefile, please see further below.

This issue have already shown up for me in a real system,

[    1.075000] s3c_camif_driver_init:633
[    1.080000] s3c-camif s3c2440-camif: sensor clock frequency: 12000000
[    1.090000] s3c-camif: failed to acquire subdev OV9650
[    1.095000] platform s3c2440-camif: Driver s3c-camif requests probe deferral
[    1.100000] ov965x_i2c_driver_init:820

I've attached a patch to fix this issue.

>   obj-$(CONFIG_VIDEO_DEV) += radio/ v4l2-core/
>   obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb-frontends/

[snip]

> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index a0c6692..52a04fa 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -2,73 +2,9 @@
>   # Makefile for the video capture/playback device drivers.
>   #
> 
> -msp3400-objs	:=	msp3400-driver.o msp3400-kthreads.o
> -
>   omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
> 
> -# Helper modules
> -
> -obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
> -
> -# All i2c modules must come first:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                    |
This is currently not preserved ----+
   
> -obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
> -obj-$(CONFIG_VIDEO_TDA7432) += tda7432.o
> -obj-$(CONFIG_VIDEO_SAA6588) += saa6588.o

--

Regards,
Sylwester

--------------010905010706050806040603
Content-Type: text/x-patch;
 name="0001-media-Fix-link-order-of-the-V4L2-bridge-and-I2C-modu.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-media-Fix-link-order-of-the-V4L2-bridge-and-I2C-modu.pa";
 filename*1="tch"

>From ca02e4cba9f400a0066f2875c2fe4284bc8e06dc Mon Sep 17 00:00:00 2001
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Date: Sat, 25 Aug 2012 01:23:14 +0200
Subject: [PATCH] [media] Fix link order of the V4L2 bridge and I2C modules

All I2C modules must be linked first to ensure proper module
initialization order. With platform devices linked before I2C
modules I2C subdev registration fails as the subdev drivers
are not yet initialized during bridge driver's probing.

This fixes regression introduced with commmit cb7a01ac324bf2ee2,
"[media] move i2c files into drivers/media/i2c".

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 drivers/media/Makefile |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index b0b0193..92a8bcf 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -8,8 +8,9 @@ ifeq ($(CONFIG_MEDIA_CONTROLLER),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += media.o
 endif
 
-obj-y += tuners/ common/ rc/ platform/
-obj-y += i2c/ pci/ usb/ mmc/ firewire/ parport/
+obj-$(CONFIG_VIDEO_DEV) += v4l2-core/
+obj-y += common/ rc/ i2c/
+obj-y += tuners/ platform/ pci/ usb/ mmc/ firewire/ parport/
 
-obj-$(CONFIG_VIDEO_DEV) += radio/ v4l2-core/
+obj-$(CONFIG_VIDEO_DEV) += radio/
 obj-$(CONFIG_DVB_CORE)  += dvb-core/ dvb-frontends/
-- 
1.7.4.1


--------------010905010706050806040603--
