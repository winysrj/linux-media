Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52933
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752296AbdBCLQO (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 06:16:14 -0500
Date: Fri, 3 Feb 2017 09:16:04 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Petri Gynther <pgynther@google.com>
Cc: linux-media@vger.kernel.org
Subject: Re: cx231xx: how to disable V4L2 interface?
Message-ID: <20170203091604.68442f38@vento.lan>
In-Reply-To: <CAGXr9JEfe9pNJa9=_ZwPqrait2Q6PtJGkbw5JS8X-todxSNbWg@mail.gmail.com>
References: <CAGXr9JEfe9pNJa9=_ZwPqrait2Q6PtJGkbw5JS8X-todxSNbWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 9 Dec 2016 11:17:20 -0800
Petri Gynther <pgynther@google.com> escreveu:

> Hi linux-media:
> 
> For drivers/media/usb/cx231xx, I'd like to add a kernel config option:
> CONFIG_VIDEO_CX231XX_V4L2
> 
> that allows us to disable the V4L2 interface when only the DVB
> interface is needed.
> 
> au0828 driver handles this cleanly:
> drivers/media/usb/au0828/Makefile
> ifeq ($(CONFIG_VIDEO_AU0828_V4L2),y)
>   au0828-objs   += au0828-video.o au0828-vbi.o
> endif
> 
> Trying to do the same in cx231xx driver:
> diff --git a/drivers/media/usb/cx231xx/Kconfig
> b/drivers/media/usb/cx231xx/Kconfig
> index 0cced3e..63d63aa 100644
> --- a/drivers/media/usb/cx231xx/Kconfig
> +++ b/drivers/media/usb/cx231xx/Kconfig
> @@ -39,6 +39,13 @@ config VIDEO_CX231XX_ALSA
>           To compile this driver as a module, choose M here: the
>           module will be called cx231xx-alsa
> 
> +config VIDEO_CX231XX_V4L2
> +       bool "Conexant cx231xx V4L2 interface"
> +       depends on VIDEO_CX231XX
> +       default y
> +       ---help---
> +         Enable or disable V4L2 interface of cx231xx
> +
>  config VIDEO_CX231XX_DVB
>         tristate "DVB/ATSC Support for Cx231xx based TV cards"
>         depends on VIDEO_CX231XX && DVB_CORE
> 
> diff --git a/drivers/media/usb/cx231xx/Makefile
> b/drivers/media/usb/cx231xx/Makefile
> index 52cf769..425d899 100644
> --- a/drivers/media/usb/cx231xx/Makefile
> +++ b/drivers/media/usb/cx231xx/Makefile
> @@ -1,5 +1,6 @@
> -cx231xx-y += cx231xx-video.o cx231xx-i2c.o cx231xx-cards.o cx231xx-core.o
> -cx231xx-y += cx231xx-avcore.o cx231xx-417.o cx231xx-pcb-cfg.o cx231xx-vbi.o
> +cx231xx-y += cx231xx-i2c.o cx231xx-cards.o cx231xx-core.o
> +cx231xx-y += cx231xx-avcore.o cx231xx-417.o cx231xx-pcb-cfg.o
> +cx231xx-$(CONFIG_VIDEO_CX231XX_V4L2) += cx231xx-video.o cx231xx-vbi.o
>  cx231xx-$(CONFIG_VIDEO_CX231XX_RC) += cx231xx-input.o
> 
>  cx231xx-alsa-objs := cx231xx-audio.o
> 
> and then building with VIDEO_CX231XX_V4L2 unset, the result is:
> 
> drivers/built-in.o: In function `cx231xx_release_resources':
> (.text+0x3528c9): undefined reference to `cx231xx_release_analog_resources'
> drivers/built-in.o: In function `cx231xx_usb_probe':
> cx231xx-cards.c:(.text+0x352f56): undefined reference to
> `cx231xx_register_analog_devices'
> cx231xx-cards.c:(.text+0x352f71): undefined reference to
> `cx231xx_release_analog_resources'
> cx231xx-cards.c:(.text+0x353429): undefined reference to
> `cx231xx_release_analog_resources'
> drivers/built-in.o: In function `cx231xx_init_bulk':
> (.text+0x3544d8): undefined reference to `video_mux'
> drivers/built-in.o:(.rodata+0x7fcc0): undefined reference to `cx231xx_querycap'
> drivers/built-in.o:(.rodata+0x7fe98): undefined reference to
> `cx231xx_enum_input'
> drivers/built-in.o:(.rodata+0x7fea0): undefined reference to `cx231xx_g_input'
> drivers/built-in.o:(.rodata+0x7fea8): undefined reference to `cx231xx_s_input'
> drivers/built-in.o:(.rodata+0x7ffb8): undefined reference to `cx231xx_g_tuner'
> drivers/built-in.o:(.rodata+0x7ffc0): undefined reference to `cx231xx_s_tuner'
> drivers/built-in.o:(.rodata+0x7ffc8): undefined reference to
> `cx231xx_g_frequency'
> drivers/built-in.o:(.rodata+0x7ffd0): undefined reference to
> `cx231xx_s_frequency'
> make: *** [vmlinux] Error 1
> 
> Based on the above, looks like some functions would need to be moved
> out from cx231xx-video.c to cx231xx-core.c (?) to accomplish this.
> 
> Any suggestions?

It is not that simple. You'll need to split the driver into
two separate ones. We did that on some drivers. Maybe you
could take a look on the patches that split those drivers in
order to see how that happens. It is not trivial: you'll need
to move functions from -core to -video and be sure that it won't
have any troubles with the power manager.

Regards,
Mauro

Thanks,
Mauro
