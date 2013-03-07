Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:42752 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3CGHSP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 02:18:15 -0500
Received: by mail-we0-f172.google.com with SMTP id d46so158364wer.3
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 23:18:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <513750ED.2040701@ti.com>
References: <1362492801-13202-1-git-send-email-nsekhar@ti.com>
 <CA+V-a8u0XLAN72ky05JO_4vvoMjnHXoXS7JAk6OPO3r8r46CLw@mail.gmail.com>
 <51371553.5030103@ti.com> <CA+V-a8uRWQxcBSoTkuDAqzzCyR2e20JHEWzVuS39389QEoPazg@mail.gmail.com>
 <5137191F.6050707@ti.com> <CA+V-a8s_x_X_GdQ0aa36e-B3DhxpXJ5vzsce0yqPcn78g81m+w@mail.gmail.com>
 <513750ED.2040701@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 7 Mar 2013 12:47:54 +0530
Message-ID: <CA+V-a8vaT4d52goryzrF5YdeXBVvCzfGnVicaNMuYL85Lmabcg@mail.gmail.com>
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

Sekhar,

On Wed, Mar 6, 2013 at 7:51 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>
> On 3/6/2013 4:05 PM, Prabhakar Lad wrote:
>> On Wed, Mar 6, 2013 at 3:53 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>>> On 3/6/2013 3:46 PM, Prabhakar Lad wrote:
>>>> Sekhar,
>>>>
>>>> On Wed, Mar 6, 2013 at 3:37 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>>>>> On 3/6/2013 2:59 PM, Prabhakar Lad wrote:
>>>>>
>>>>>>>  config VIDEO_DAVINCI_VPIF_DISPLAY
>>>>>>>         tristate "DM646x/DA850/OMAPL138 EVM Video Display"
>>>>>>> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
>>>>>>> +       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM) && VIDEO_DAVINCI_VPIF
>>>>>>>         select VIDEOBUF2_DMA_CONTIG
>>>>>>> -       select VIDEO_DAVINCI_VPIF
>>>>>>>         select VIDEO_ADV7343 if MEDIA_SUBDRV_AUTOSELECT
>>>>>>>         select VIDEO_THS7303 if MEDIA_SUBDRV_AUTOSELECT
>>>>>>>         help
>>>>>>> @@ -15,9 +14,8 @@ config VIDEO_DAVINCI_VPIF_DISPLAY
>>>>>>>
>>>>>>>  config VIDEO_DAVINCI_VPIF_CAPTURE
>>>>>>>         tristate "DM646x/DA850/OMAPL138 EVM Video Capture"
>>>>>>> -       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM)
>>>>>>> +       depends on VIDEO_DEV && (MACH_DAVINCI_DM6467_EVM || MACH_DAVINCI_DA850_EVM) && VIDEO_DAVINCI_VPIF
>>>>>>>         select VIDEOBUF2_DMA_CONTIG
>>>>>>> -       select VIDEO_DAVINCI_VPIF
>>>>>>>         help
>>>>>>>           Enables Davinci VPIF module used for captur devices.
>>>>>>>           This module is common for following DM6467/DA850/OMAPL138
>>>>>>> @@ -28,7 +26,7 @@ config VIDEO_DAVINCI_VPIF_CAPTURE
>>>>>>>
>>>>>>>  config VIDEO_DAVINCI_VPIF
>>>>>>>         tristate "DaVinci VPIF Driver"
>>>>>>> -       depends on VIDEO_DAVINCI_VPIF_DISPLAY || VIDEO_DAVINCI_VPIF_CAPTURE
>>>>>>> +       depends on ARCH_DAVINCI
>>>>>>
>>>>>> It would be better if this was  depends on MACH_DAVINCI_DM6467_EVM ||
>>>>>> MACH_DAVINCI_DA850_EVM
>>>>>> rather than 'ARCH_DAVINCI' then you can remove 'MACH_DAVINCI_DM6467_EVM' and
>>>>>> 'MACH_DAVINCI_DA850_EVM' dependency from VIDEO_DAVINCI_VPIF_DISPLAY and
>>>>>> VIDEO_DAVINCI_VPIF_CAPTURE. So it would be just 'depends on VIDEO_DEV
>>>>>> && VIDEO_DAVINCI_VPIF'
>>>>>
>>>>> I could, but vpif.c seems pretty board independent to me. Are you sure
>>>>> no other board would like to build vpif.c? BTW, are vpif_display.c and
>>>>> vpif_capture.c really that board specific? May be we can all make them
>>>>> depend on ARCH_DAVINCI?
>>>>>
>>>> VPIF is present only in DM646x and DA850/OMAP-L1138.
>>>> vpif.c is common file which is used by vpif_capture and vpif_display.
>>>
>>> So vpif.c per se doesn't do anything useful. Why the dependency on EVMs?
>>> There are other boards for these platform which could use VPIF.
>>>
>> yep agreed!
>
> So instead of presenting a non-useful vpif selection to users,
> vpif.c dependency is better handled in makefile, no?
>
Agreed that’s a better fix.

> How about the patch below (now also rebased on v3.9-rc1)?
>
Looks good.

> What about vpss.c? Does it make sense not to present a config
> for that as well?
>
Yes there isn't a need in config for it too, this also should be
handled in Makefile as well.

> I also noticed that module build of VPIF is broken in mainline.
> That needs to be fixed too.
>
Posted a patch fixing it(http://patchwork.linuxtv.org/patch/17145/).

Regards,
--Prabhakar

> Thanks,
> Sekhar
>
> ---8<---
> From: Sekhar Nori <nsekhar@ti.com>
> Date: Tue, 5 Mar 2013 19:08:59 +0530
> Subject: [PATCH] media: davinci: kconfig: fix incorrect selects
>
> drivers/media/platform/davinci/Kconfig uses selects where
> it should be using 'depends on'. This results in warnings of
> the following sort when doing randconfig builds.
>
> warning: (VIDEO_DM6446_CCDC && VIDEO_DM355_CCDC && VIDEO_ISIF && VIDEO_DAVINCI_VPBE_DISPLAY) selects VIDEO_VPSS_SYSTEM which has unmet direct dependencies (MEDIA_SUPPORT && V4L_PLATFORM_DRIVERS && ARCH_DAVINCI)
>
> The VPIF kconfigs had a strange 'select' and 'depends on' cross
> linkage which have been fixed as well by removing unneeded
> VIDEO_DAVINCI_VPIF config symbol. Selecting VPIF is now possible
> on all DaVinci platforms instead of two specific EVMs earlier.
>
> While at it, fix the Kconfig help text to make it more readable.
>
> This patch has only been build tested, I do not have the setup
> to test video. I also do not know if the dependencies are really
> needed, I have just tried to not break any existing assumptions.
>
> Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> ---
>  drivers/media/platform/davinci/Kconfig  |   41 ++++++++++---------------------
>  drivers/media/platform/davinci/Makefile |    7 ++----
>  2 files changed, 15 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/Kconfig b/drivers/media/platform/davinci/Kconfig
> index ccfde4e..42152f9 100644
> --- a/drivers/media/platform/davinci/Kconfig
> +++ b/drivers/media/platform/davinci/Kconfig
> @@ -1,40 +1,29 @@
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
>           To compile this driver as a module, choose M here: the
>           module will be called vpif_display.
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
>           To compile this driver as a module, choose M here: the
>           module will be called vpif_capture.
>
> -config VIDEO_DAVINCI_VPIF
> -       tristate "DaVinci VPIF Driver"
> -       depends on VIDEO_DAVINCI_VPIF_DISPLAY || VIDEO_DAVINCI_VPIF_CAPTURE
> -       help
> -         Support for DaVinci VPIF Driver.
> -
> -         To compile this driver as a module, choose M here: the
> -         module will be called vpif.
> -
>  config VIDEO_VPSS_SYSTEM
>         tristate "VPSS System module driver"
>         depends on ARCH_DAVINCI
> @@ -56,8 +45,7 @@ config VIDEO_VPFE_CAPTURE
>
>  config VIDEO_DM6446_CCDC
>         tristate "DM6446 CCDC HW module"
> -       depends on VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> +       depends on VIDEO_VPFE_CAPTURE && VIDEO_VPSS_SYSTEM
>         default y
>         help
>            Enables DaVinci CCD hw module. DaVinci CCDC hw interfaces
> @@ -71,8 +59,7 @@ config VIDEO_DM6446_CCDC
>
>  config VIDEO_DM355_CCDC
>         tristate "DM355 CCDC HW module"
> -       depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> +       depends on ARCH_DAVINCI_DM355 && VIDEO_VPFE_CAPTURE && VIDEO_VPSS_SYSTEM
>         default y
>         help
>            Enables DM355 CCD hw module. DM355 CCDC hw interfaces
> @@ -86,8 +73,7 @@ config VIDEO_DM355_CCDC
>
>  config VIDEO_ISIF
>         tristate "ISIF HW module"
> -       depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE
> -       select VIDEO_VPSS_SYSTEM
> +       depends on ARCH_DAVINCI_DM365 && VIDEO_VPFE_CAPTURE && VIDEO_VPSS_SYSTEM
>         default y
>         help
>            Enables ISIF hw module. This is the hardware module for
> @@ -99,8 +85,7 @@ config VIDEO_ISIF
>
>  config VIDEO_DAVINCI_VPBE_DISPLAY
>         tristate "DM644X/DM365/DM355 VPBE HW module"
> -       depends on ARCH_DAVINCI_DM644x || ARCH_DAVINCI_DM355 || ARCH_DAVINCI_DM365
> -       select VIDEO_VPSS_SYSTEM
> +       depends on (ARCH_DAVINCI_DM644x || ARCH_DAVINCI_DM355 || ARCH_DAVINCI_DM365) && VIDEO_VPSS_SYSTEM
>         select VIDEOBUF2_DMA_CONTIG
>         help
>             Enables Davinci VPBE module used for display devices.
> diff --git a/drivers/media/platform/davinci/Makefile b/drivers/media/platform/davinci/Makefile
> index f40f521..4d91cb9 100644
> --- a/drivers/media/platform/davinci/Makefile
> +++ b/drivers/media/platform/davinci/Makefile
> @@ -2,13 +2,10 @@
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
>  obj-$(CONFIG_VIDEO_VPSS_SYSTEM) += vpss.o
