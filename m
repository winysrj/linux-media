Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:57820 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZBETEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 14:04:38 -0500
Received: by fg-out-1718.google.com with SMTP id 16so263583fgg.17
        for <linux-media@vger.kernel.org>; Thu, 05 Feb 2009 11:04:36 -0800 (PST)
From: Eduard Huguet <eduardhc@gmail.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: cx8802.ko module not being built with current HG tree
Date: Thu, 5 Feb 2009 20:04:25 +0100
Cc: linux-media@vger.kernel.org
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com> <617be8890902050759x74c08498o355be1d34d7735fe@mail.gmail.com> <Pine.LNX.4.58.0902050946560.17300@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0902050946560.17300@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902052004.25732.eduardhc@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A Dijous, 5 de febrer de 2009 19:33:21, Trent Piepho va escriure:
> On Thu, 5 Feb 2009, Eduard Huguet wrote:
> > The module was not being load because kernel was failing to find
> > cx8802_get_driver, etc... entry points, which are exported by
> > cx88-mpeg.c.
> >
> > After a 'make menuconfig' in HG tree the kernel configuration
> > contained these lines (this was using the default config, without
> > adding / removing anything):
> > CONFIG_VIDEO_CX88=m
> > CONFIG_VIDEO_CX88_ALSA=m
> > CONFIG_VIDEO_CX88_BLACKBIRD=m
> > CONFIG_VIDEO_CX88_DVB=m
> > CONFIG_VIDEO_CX88_MPEG=y
> > CONFIG_VIDEO_CX88_VP3054=m
>
> The problem is that CX88_MPEG is y; it should be m.  The kconfig system is
> strange in the way it handles "hidden" entries.  In the Kconfig file, MPEG
> depends on DVB, so having MPEG at 'y' which is higher than DVB at 'm'
> shouldn't be allowed.  And indeed if you unhide DVB it won't be.  But when
> it's hidden the "default y" overrides the dependencies.
>
> The dependencies here are backward though!  It is DVB and BLACKBIRD that
> depend on MPEG.  MPEG depends on CX88.
>
> The right way to do it either to make MPEG visible and give it the right
> dependencies, or keep it hidden and have DVB and BLACKBIRD select it.
>
> Like this:
> diff -r ed3955855d78 linux/drivers/media/video/cx88/Kconfig
> --- a/linux/drivers/media/video/cx88/Kconfig    Thu Feb 05 09:58:48 2009
> -0800 +++ b/linux/drivers/media/video/cx88/Kconfig    Thu Feb 05 10:27:41
> 2009 -0800 @@ -31,9 +31,17 @@ config VIDEO_CX88_ALSA
>           To compile this driver as a module, choose M here: the
>           module will be called cx88-alsa.
>
> +config VIDEO_CX88_MPEG
> +       tristate
> +       depends on VIDEO_CX88
> +       select VIDEO_BTCX
> +       select VIDEOBUF_DMA_SG
> +       default n
> +
>  config VIDEO_CX88_BLACKBIRD
>         tristate "Blackbird MPEG encoder support (cx2388x + cx23416)"
>         depends on VIDEO_CX88
> +       select VIDEO_CX88_MPEG
>         select VIDEO_CX2341X
>         ---help---
>           This adds support for MPEG encoder cards based on the
> @@ -46,6 +54,7 @@ config VIDEO_CX88_DVB
>  config VIDEO_CX88_DVB
>         tristate "DVB/ATSC Support for cx2388x based TV cards"
>         depends on VIDEO_CX88 && DVB_CORE
> +       select VIDEO_CX88_MPEG
>         select VIDEOBUF_DVB
>         select DVB_PLL if !DVB_FE_CUSTOMISE
>         select DVB_MT352 if !DVB_FE_CUSTOMISE
> @@ -69,11 +78,6 @@ config VIDEO_CX88_DVB
>           To compile this driver as a module, choose M here: the
>           module will be called cx88-dvb.
>
> -config VIDEO_CX88_MPEG
> -       tristate
> -       depends on VIDEO_CX88_DVB || VIDEO_CX88_BLACKBIRD
> -       default y
> -
>  config VIDEO_CX88_VP3054
>         tristate "VP-3054 Secondary I2C Bus Support"
>         default m

This is what I thought. I managed to compile the drivers by hacking Kconfig, 
so this makes sense.

Thanks for your quick patch, I hope it's included into the main tree ASAP as 
the CX88-DVB driver is widely used, and it's unusable right now unless you do 
the proper hacking.

Regards, 
  Eduard Huguet


