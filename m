Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:41428 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3CFJaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 04:30:00 -0500
Received: by mail-we0-f171.google.com with SMTP id u54so7443081wey.2
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 01:29:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1362492801-13202-1-git-send-email-nsekhar@ti.com>
References: <1362492801-13202-1-git-send-email-nsekhar@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 6 Mar 2013 14:59:38 +0530
Message-ID: <CA+V-a8u0XLAN72ky05JO_4vvoMjnHXoXS7JAk6OPO3r8r46CLw@mail.gmail.com>
Subject: Re: [PATCH] media: davinci: kconfig: fix incorrect selects
To: Sekhar Nori <nsekhar@ti.com>
Cc: Prabhakar Lad <prabhakar.lad@ti.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sekhar,

Thanks for the patch!

On Tue, Mar 5, 2013 at 7:43 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> drivers/media/platform/davinci/Kconfig uses selects where
> it should be using 'depends on'. This results in warnings of
> the following sort when doing randconfig builds.
>
> warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
>
> The VPIF kconfigs had a strange 'select' and 'depends on' cross
> linkage which have been fixed as well.
>
> This patch has only been build tested, I do not have the setup
> to test video. I also do not know if the dependencies are really
> needed, I have just tried to not break any existing assumptions.
>
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
>  drivers/media/platform/davinci/Kconfig |   22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
> index 3c56037..313e343 100644
> --- a/drivers/media/platform/davinci/Kconfig
> +++ b/drivers/media/platform/davinci/Kconfig
> @@ -1,8 +1,7 @@
>  config VIDEO_DAVINCI_VPIF_DISPLAY
>         tristate "DM646x/DA850/OMAPL138 EVM Video Display"
> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
> +       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM) && VIDEO_DAVINCI_VPIF
>         select VIDEOBUF2_DMA_CONTIG
> -       select VIDEO_DAVINCI_VPIF
>         select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
>         select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
>         help
> @@ -15,9 +14,8 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
>
>  config VIDEO_DAVINCI_VPIF_CAPTURE
>         tristate "DM646x/DA850/OMAPL138 EVM Video Capture"
> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
> +       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM) && VIDEO_DAVINCI_VPIF
>         select VIDEOBUF2_DMA_CONTIG
> -       select VIDEO_DAVINCI_VPIF
>         help
>           Enables Davinci VPIF module used for captur devices.
>           This module is common for following DM6467/DA850/OMAPL138
> @@ -28,7 +26,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
>
>  config VIDEO_DAVINCI_VPIF
>         tristate "DaVinci VPIF Driver"
> -       depends on VIDEO_DAVINCI_VPIF_DISPLAY || VIDEO_DAVINCI_VPIF_CAPTURE
> +       depends on ARCH_DAVINCI

It would be better if this was  depends on MACH_DAVINCI_DM6467_EVM ||
MACH_DAVINCI_DA850_EVM
rather than 'ARCH_DAVINCI' then you can remove 'MACH_DAVINCI_DM6467_EVM' and
'MACH_DAVINCI_DA850_EVM' dependency from VIDEO_DAVINCI_VPIF_DISPLAY and
VIDEO_DAVINCI_VPIF_CAPTURE. So it would be just 'depends on VIDEO_DEV
&& VIDEO_DAVINCI_VPIF'

BTW this patch doesn’t apply on3.9.0-rc1.

Regards,
--Prabhakar Lad

>         help
>           Support for DaVinci VPIF Driver.
>
> @@ -56,8 +54,7 @@ config VIDEO_VPFE_CAPTURE
>
>  config VIDEO_DM6446_CCDC
>         tristate "DM6446 CCDC HW module"
> -       depends on VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> +       depends on VIDEO_VPFE_CAPTURE && VIDEO_VPSS_SYSTEM
>         default y
>         help
>            Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
> @@ -71,8 +68,7 @@ config VIDEO_DM6446_CCDC
>
>  config VIDEO_DM355_CCDC
>         tristate "DM355 CCDC HW module"
> -       depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> +       depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE && VIDEO_VPSS_SYSTEM
>         default y
>         help
>            Enables DM355 CCD hw module. DM355 CCDC hw interfaces
> @@ -86,8 +82,7 @@ config VIDEO_DM355_CCDC
>
>  config VIDEO_ISIF
>         tristate "ISIF HW module"
> -       depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> +       depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE && VIDEO_VPSS_SYSTEM
>         default y
>         help
>            Enables ISIF hw module. This is the hardware module for
> @@ -99,8 +94,7 @@ config VIDEO_ISIF
>
>  config VIDEO_DM644X_VPBE
>         tristate "DM644X VPBE HW module"
> -       depends on ARCH_DAVINCI_DM644x
> -       select VIDEO_VPSS_SYSTEM
> +       depends on ARCH_DAVINCI_DM644x && VIDEO_VPSS_SYSTEM
>         select VIDEOBUF2_DMA_CONTIG
>         help
>             Enables VPBE modules used for display on a DM644x
> @@ -113,7 +107,7 @@ config VIDEO_DM644X_VPBE
>  config VIDEO_VPBE_DISPLAY
>         tristate "VPBE V4L2 Display driver"
>         depends on ARCH_DAVINCI_DM644x
> -       select VIDEO_DM644X_VPBE
> +       depends on VIDEO_DM644X_VPBE
>         help
>             Enables VPBE V4L2 Display driver on a DM644x device
>
> --
> 1.7.10.1
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
