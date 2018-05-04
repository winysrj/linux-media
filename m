Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751239AbeEDOHM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:07:12 -0400
Date: Fri, 4 May 2018 11:07:01 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-fbdev@vger.kernel.org
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2 7/7] media: via-camera: allow build on non-x86 archs
 with COMPILE_TEST
Message-ID: <20180504110701.5436d05c@vento.lan>
In-Reply-To: <5323943.SkjzUNBk3k@amdc3058>
References: <cover.1524245455.git.mchehab@s-opensource.com>
        <396bfb33e763c31ead093ac1035b2ecf7311b5bc.1524245455.git.mchehab@s-opensource.com>
        <20180420160321.4ecefa00@vento.lan>
        <CGME20180423121932eucas1p212eb6412ff8df511047c3afa782db6e0@eucas1p2.samsung.com>
        <5323943.SkjzUNBk3k@amdc3058>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Apr 2018 14:19:31 +0200
Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> escreveu:


> How's about just allowing COMPILE_TEST for FB_VIA instead of adding
> all these stubs?

Works for me.

Do you want to apply it via your tree or via the media one?

If you prefer to apply on yours:

Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Thanks!
Mauro

> 
> 
> From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Subject: [PATCH] video: fbdev: via: allow COMPILE_TEST build
> 
> This patch allows viafb driver to be build on !X86 archs
> using COMPILE_TEST config option.
> 
> Since via-camera driver (VIDEO_VIA_CAMERA) depends on viafb
> it also needs a little fixup.
> 
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> ---
>  drivers/media/platform/via-camera.c |    5 +++++
>  drivers/video/fbdev/Kconfig         |    2 +-
>  drivers/video/fbdev/via/global.h    |    6 ++++++
>  drivers/video/fbdev/via/hw.c        |    1 -
>  drivers/video/fbdev/via/via-core.c  |    1 -
>  drivers/video/fbdev/via/via_clock.c |    2 +-
>  drivers/video/fbdev/via/viafbdev.c  |    1 -
>  7 files changed, 13 insertions(+), 5 deletions(-)
> 
> Index: b/drivers/media/platform/via-camera.c
> ===================================================================
> --- a/drivers/media/platform/via-camera.c	2018-04-23 13:46:37.000000000 +0200
> +++ b/drivers/media/platform/via-camera.c	2018-04-23 14:01:07.873322815 +0200
> @@ -27,7 +27,12 @@
>  #include <linux/via-core.h>
>  #include <linux/via-gpio.h>
>  #include <linux/via_i2c.h>
> +
> +#ifdef CONFIG_X86
>  #include <asm/olpc.h>
> +#else
> +#define machine_is_olpc(x) 0
> +#endif
>  
>  #include "via-camera.h"
>  
> Index: b/drivers/video/fbdev/Kconfig
> ===================================================================
> --- a/drivers/video/fbdev/Kconfig	2018-04-10 12:34:26.618867549 +0200
> +++ b/drivers/video/fbdev/Kconfig	2018-04-23 13:55:41.389314593 +0200
> @@ -1437,7 +1437,7 @@ config FB_SIS_315
>  
>  config FB_VIA
>         tristate "VIA UniChrome (Pro) and Chrome9 display support"
> -       depends on FB && PCI && X86 && GPIOLIB && I2C
> +       depends on FB && PCI && GPIOLIB && I2C && (X86 || COMPILE_TEST)
>         select FB_CFB_FILLRECT
>         select FB_CFB_COPYAREA
>         select FB_CFB_IMAGEBLIT
> Index: b/drivers/video/fbdev/via/global.h
> ===================================================================
> --- a/drivers/video/fbdev/via/global.h	2017-10-18 14:35:22.079448310 +0200
> +++ b/drivers/video/fbdev/via/global.h	2018-04-23 13:52:57.121310456 +0200
> @@ -33,6 +33,12 @@
>  #include <linux/console.h>
>  #include <linux/timer.h>
>  
> +#ifdef CONFIG_X86
> +#include <asm/olpc.h>
> +#else
> +#define machine_is_olpc(x) 0
> +#endif
> +
>  #include "debug.h"
>  
>  #include "viafbdev.h"
> Index: b/drivers/video/fbdev/via/hw.c
> ===================================================================
> --- a/drivers/video/fbdev/via/hw.c	2017-10-18 14:35:22.079448310 +0200
> +++ b/drivers/video/fbdev/via/hw.c	2018-04-23 13:54:24.881312666 +0200
> @@ -20,7 +20,6 @@
>   */
>  
>  #include <linux/via-core.h>
> -#include <asm/olpc.h>
>  #include "global.h"
>  #include "via_clock.h"
>  
> Index: b/drivers/video/fbdev/via/via-core.c
> ===================================================================
> --- a/drivers/video/fbdev/via/via-core.c	2017-11-22 14:11:59.852728679 +0100
> +++ b/drivers/video/fbdev/via/via-core.c	2018-04-23 13:53:24.893311156 +0200
> @@ -17,7 +17,6 @@
>  #include <linux/platform_device.h>
>  #include <linux/list.h>
>  #include <linux/pm.h>
> -#include <asm/olpc.h>
>  
>  /*
>   * The default port config.
> Index: b/drivers/video/fbdev/via/via_clock.c
> ===================================================================
> --- a/drivers/video/fbdev/via/via_clock.c	2017-10-18 14:35:22.083448309 +0200
> +++ b/drivers/video/fbdev/via/via_clock.c	2018-04-23 13:53:45.389311672 +0200
> @@ -25,7 +25,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/via-core.h>
> -#include <asm/olpc.h>
> +
>  #include "via_clock.h"
>  #include "global.h"
>  #include "debug.h"
> Index: b/drivers/video/fbdev/via/viafbdev.c
> ===================================================================
> --- a/drivers/video/fbdev/via/viafbdev.c	2017-11-22 14:11:59.852728679 +0100
> +++ b/drivers/video/fbdev/via/viafbdev.c	2018-04-23 13:53:55.325311922 +0200
> @@ -25,7 +25,6 @@
>  #include <linux/stat.h>
>  #include <linux/via-core.h>
>  #include <linux/via_i2c.h>
> -#include <asm/olpc.h>
>  
>  #define _MASTER_FILE
>  #include "global.h"
> 
> 



Thanks,
Mauro
