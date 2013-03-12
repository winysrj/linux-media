Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:64592 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3CLFOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 01:14:44 -0400
Received: by mail-wg0-f54.google.com with SMTP id fm10so5566565wgb.21
        for <linux-media@vger.kernel.org>; Mon, 11 Mar 2013 22:14:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363004536-27314-1-git-send-email-nsekhar@ti.com>
References: <CA+V-a8sMTqU4PkxZ8_EK5yNY1S22G2G=7-bs5j31Umi_Dt97gQ@mail.gmail.com>
 <1363004536-27314-1-git-send-email-nsekhar@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 12 Mar 2013 10:44:23 +0530
Message-ID: <CA+V-a8vaNzio4RYqq8xwe=bOS0F+2t_mkwDWcQ99GbChC97Ayg@mail.gmail.com>
Subject: Re: [PATCH] media: davinci: kconfig: fix incorrect selects
To: Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sekhar,

Thanks for the patch! few nits below

also version number for patch is missing as this should have been v2 :)
BTW this patch still is not  present in media list.

On Mon, Mar 11, 2013 at 5:52 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> drivers/media/platform/davinci/Kconfig uses selects where
> it should be using 'depends on'. This results in warnings of
> the following sort when doing randconfig builds.
>
> warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
>
> The VPIF kconfigs had a strange 'select' and 'depends on' cross
> linkage which have been fixed as well by removing unneeded
> VIDEO_DAVINCI_VPIF config symbol.
>
> Similarly, remove the unnecessary VIDEO_VPSS_SYSTEM and
> VIDEO_VPFE_CAPTURE. They don't select any independent functionality
> and were being used to manage code dependencies which can
> be handled using makefile.
>
> Selecting video modules is now dependent on all ARCH_DAVINCI
> instead of specific EVMs and SoCs earlier. This should help build
> coverage. Remove unnecessary 'default y' for some config symbols.
>
> While at it, fix the Kconfig help text to make it more readable
> and fix names of modules created.
>
> Rename VIDEO_ISIF to VIDEO_DM365_ISIF as per suggestion from
> Prabhakar.
>
> This patch has only been build tested; I have tried to not break
> any existing assumptions. I do not have the setup to test video,
> so any test reports welcome.
>
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
>  drivers/media/platform/davinci/Kconfig  |   99 +++++++++++--------------------
>  drivers/media/platform/davinci/Makefile |   17 ++----
>  2 files changed, 39 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
> index ccfde4e..86f7f34 100644
> --- a/drivers/media/platform/davinci/Kconfig
> +++ b/drivers/media/platform/davinci/Kconfig
> @@ -1,64 +1,33 @@
>  config VIDEO_DAVINCI_VPIF_DISPLAY
> -       tristate "DM646x/DA850/OMAPL138 EVM Video Display"
> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
> +       tristate "TI DaVinci VPIF Video Display"
> +       depends on VIDEO_DEV && ARCH_DAVINCI
>         select VIDEOBUF2_DMA_CONTIG
> -       select VIDEO_DAVINCI_VPIF
>         select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
>         select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
>         help
>           Enables Davinci VPIF module used for display devices.
> -         This module is common for following DM6467/DA850/OMAPL138
> -         based display devices.
> +         This module is used for display on TI DM6467/DA850/OMAPL138
> +         SoCs.
>
> -         To compile this driver as a module, choose M here: the
> -         module will be called vpif_display.
> +         To compile this driver as a module, choose M here. There will
> +         be two modules called vpif.ko and vpif_display.ko
>
>  config VIDEO_DAVINCI_VPIF_CAPTURE
> -       tristate "DM646x/DA850/OMAPL138 EVM Video Capture"
> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
> +       tristate "TI DaVinci VPIF Video Capture"
> +       depends on VIDEO_DEV && ARCH_DAVINCI
>         select VIDEOBUF2_DMA_CONTIG
> -       select VIDEO_DAVINCI_VPIF
>         help
> -         Enables Davinci VPIF module used for captur devices.
> -         This module is common for following DM6467/DA850/OMAPL138
> -         based capture devices.
> +         Enables Davinci VPIF module used for capture devices.
> +         This module is used for capture on TI DM6467/DA850/OMAPL138
> +         SoCs.
>
> -         To compile this driver as a module, choose M here: the
> -         module will be called vpif_capture.
> -
> -config VIDEO_DAVINCI_VPIF
> -       tristate "DaVinci VPIF Driver"
> -       depends on VIDEO_DAVINCI_VPIF_DISPLAY || VIDEO_DAVINCI_VPIF_CAPTURE
> -       help
> -         Support for DaVinci VPIF Driver.
> -
> -         To compile this driver as a module, choose M here: the
> -         module will be called vpif.
> -
> -config VIDEO_VPSS_SYSTEM
> -       tristate "VPSS System module driver"
> -       depends on ARCH_DAVINCI
> -       help
> -         Support for vpss system module for video driver
> -
> -config VIDEO_VPFE_CAPTURE
> -       tristate "VPFE Video Capture Driver"
> -       depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
> -       depends on I2C
> -       select VIDEOBUF_DMA_CONTIG
> -       help
> -         Support for DMx/AMx VPFE based frame grabber. This is the
> -         common V4L2 module for following DMx/AMx SoCs from Texas
> -         Instruments:- DM6446, DM365, DM355 & AM3517/05.
> -
> -         To compile this driver as a module, choose M here: the
> -         module will be called vpfe-capture.
> +         To compile this driver as a module, choose M here. There will
> +         be two modules called vpif.ko and vpif_capture.ko
>
>  config VIDEO_DM6446_CCDC
>         tristate "DM6446 CCDC HW module"
> -       depends on VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> -       default y
> +       depends on VIDEO_V4L2 && (ARCH_DAVINCI || ARCH_OMAP3)
> +       select VIDEOBUF_DMA_CONTIG
>         help
>            Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
>            with decoder modules such as TVP5146 over BT656 or
> @@ -66,14 +35,13 @@ config VIDEO_DM6446_CCDC
>            module configures the interface and CCDC/ISIF to do
>            video frame capture from slave decoders.
>
> -          To compile this driver as a module, choose M here: the
> -          module will be called vpfe.
> +          To compile this driver as a module, choose M here. There will
> +          be three modules called vpfe_capture.ko, vpss.ko and dm644x_ccdc.ko
>
>  config VIDEO_DM355_CCDC
>         tristate "DM355 CCDC HW module"
> -       depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> -       default y
> +       depends on VIDEO_V4L2 && ARCH_DAVINCI
> +       select VIDEOBUF_DMA_CONTIG
>         help
>            Enables DM355 CCD hw module. DM355 CCDC hw interfaces
>            with decoder modules such as TVP5146 over BT656 or
> @@ -81,31 +49,30 @@ config VIDEO_DM355_CCDC
>            module configures the interface and CCDC/ISIF to do
>            video frame capture from a slave decoders
>
> -          To compile this driver as a module, choose M here: the
> -          module will be called vpfe.
> +          To compile this driver as a module, choose M here. There will
> +          be three modules called vpfe_capture.ko, vpss.ko and dm355_ccdc.ko
>
> -config VIDEO_ISIF
> -       tristate "ISIF HW module"
> -       depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> -       default y
> +config VIDEO_DM365_ISIF
> +       tristate "DM365 ISIF HW module"
> +       depends on VIDEO_V4L2 && ARCH_DAVINCI
> +       select VIDEOBUF_DMA_CONTIG
>         help
>            Enables ISIF hw module. This is the hardware module for
> -          configuring ISIF in VPFE to capture Raw Bayer RGB data  from
> +          configuring ISIF in VPFE to capture Raw Bayer RGB data from
>            a image sensor or YUV data from a YUV source.
>
> -          To compile this driver as a module, choose M here: the
> -          module will be called vpfe.
> +          To compile this driver as a module, choose M here. There will
> +          be three modules called vpfe_capture.ko, vpss.ko and isif.ko
>
>  config VIDEO_DAVINCI_VPBE_DISPLAY
>         tristate "DM644X/DM365/DM355 VPBE HW module"
why not change this to 'TI DaVinci VPBE Video Display' as done for vpif ?

> -       depends on ARCH_DAVINCI_DM644x || ARCH_DAVINCI_DM355 || ARCH_DAVINCI_DM365
> -       select VIDEO_VPSS_SYSTEM
> +       depends on ARCH_DAVINCI
>         select VIDEOBUF2_DMA_CONTIG
>         help
>             Enables Davinci VPBE module used for display devices.
> -           This module is common for following DM644x/DM365/DM355
> +           This module is used for dipslay on TI DM644x/DM365/DM355
display

Regards,
--Prabhakar Lad

>             based display devices.
>
> -           To compile this driver as a module, choose M here: the
> -           module will be called vpbe.
> +           To compile this driver as a module, choose M here. There will
> +           be five modules created called vpss.ko, vpbe.ko, vpbe_osd.ko,
> +           vpbe_venc.ko and vpbe_display.ko
> diff --git a/drivers/media/platform/davinci/Makefile b/drivers/media/platform/davinci/Makefile
> index f40f521..d74d9ee 100644
> --- a/drivers/media/platform/davinci/Makefile
> +++ b/drivers/media/platform/davinci/Makefile
> @@ -2,19 +2,14 @@
>  # Makefile for the davinci video device drivers.
>  #
>
> -# VPIF
> -obj-$(CONFIG_VIDEO_DAVINCI_VPIF) += vpif.o
> -
>  #VPIF Display driver
> -obj-$(CONFIG_VIDEO_DAVINCI_VPIF_DISPLAY) += vpif_display.o
> +obj-$(CONFIG_VIDEO_DAVINCI_VPIF_DISPLAY) += vpif.o vpif_display.o
>  #VPIF Capture driver
> -obj-$(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE) += vpif_capture.o
> +obj-$(CONFIG_VIDEO_DAVINCI_VPIF_CAPTURE) += vpif.o vpif_capture.o
>
>  # Capture: DM6446 and DM355
> -obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
> -obj-$(CONFIG_VIDEO_VPFE_CAPTURE) += vpfe_capture.o
> -obj-$(CONFIG_VIDEO_DM6446_CCDC) += dm644x_ccdc.o
> -obj-$(CONFIG_VIDEO_DM355_CCDC) += dm355_ccdc.o
> -obj-$(CONFIG_VIDEO_ISIF) += isif.o
> -obj-$(CONFIG_VIDEO_DAVINCI_VPBE_DISPLAY) += vpbe.o vpbe_osd.o \
> +obj-$(CONFIG_VIDEO_DM6446_CCDC) += vpfe_capture.o vpss.o dm644x_ccdc.o
> +obj-$(CONFIG_VIDEO_DM355_CCDC) += vpfe_capture.o vpss.o dm355_ccdc.o
> +obj-$(CONFIG_VIDEO_DM365_ISIF) += vpfe_capture.o vpss.o isif.o
> +obj-$(CONFIG_VIDEO_DAVINCI_VPBE_DISPLAY) += vpss.o vpbe.o vpbe_osd.o \
>         vpbe_venc.o vpbe_display.o
> --
> 1.7.10.1
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
