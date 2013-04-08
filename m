Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f173.google.com ([209.85.128.173]:55418 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab3DHIKD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 04:10:03 -0400
Received: by mail-ve0-f173.google.com with SMTP id cy12so5092259veb.4
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 01:10:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363079692-16683-1-git-send-email-nsekhar@ti.com>
References: <513EE45E.6050004@ti.com> <1363079692-16683-1-git-send-email-nsekhar@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 8 Apr 2013 13:39:42 +0530
Message-ID: <CA+V-a8ug3fre3WWp=1cri7rcPMFC+vhCOMkAViUyMz7yQ5nPaQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: davinci: kconfig: fix incorrect selects
To: Sekhar Nori <nsekhar@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sekhar,

On Tue, Mar 12, 2013 at 2:44 PM, Sekhar Nori <nsekhar@ti.com> wrote:
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
> and fix names of modules created during module build.
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

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

> ---
> Since v2, revisited config prompt texts and made them
> more meaningful/consistent.
>
>  drivers/media/platform/davinci/Kconfig  |  103 +++++++++++--------------------
>  drivers/media/platform/davinci/Makefile |   17 ++---
>  2 files changed, 41 insertions(+), 79 deletions(-)

[Snip]

>  config VIDEO_DAVINCI_VPBE_DISPLAY
> -       tristate "DM644X/DM365/DM355 VPBE HW module"
> -       depends on ARCH_DAVINCI_DM644x || ARCH_DAVINCI_DM355 || ARCH_DAVINCI_DM365
> -       select VIDEO_VPSS_SYSTEM
> +       tristate "TI DaVinci VPBE V4L2-Display driver"
> +       depends on ARCH_DAVINCI
>         select VIDEOBUF2_DMA_CONTIG
>         help
>             Enables Davinci VPBE module used for display devices.
> -           This module is common for following DM644x/DM365/DM355
> +           This module is used for dipslay on TI DM644x/DM365/DM355
>             based display devices.
>
s/dipslay/display

Fixed it while queueing

Regards,
--Prabhakar
