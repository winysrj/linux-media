Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49842 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbbELUvb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 12 May 2015 16:51:31 -0400
Date: Tue, 12 May 2015 22:51:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: linux-media@vger.kernel.org
Subject: Re: v4.1-rcX regression in v4l2 build
In-Reply-To: <87d225mve4.fsf@belgarion.home>
Message-ID: <Pine.LNX.4.64.1505122221150.11250@axis700.grange>
References: <87d225mve4.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Tue, 12 May 2015, Robert Jarzmik wrote:

> Hi Guennadi,
> 
> Today I noticed the mioa701 build is broken on v4.1-rcX series. It was working
> in v4.0.
> 
> The build error I get is :
>   LINK    vmlinux
>   LD      vmlinux.o
>   MODPOST vmlinux.o
>   GEN     .version
>   CHK     include/generated/compile.h
>   UPD     include/generated/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
> drivers/built-in.o: In function `v4l2_clk_set_rate':
> /home/rj/mio_linux/kernel/drivers/media/v4l2-core/v4l2-clk.c:196: undefined reference to `clk_round_rate'
> Makefile:932: recipe for target 'vmlinux' failed
> make: *** [vmlinux] Error 1
> make: Target '_all' not remade because of errors.

Not good:(

> I have no idea what changed. Do you have a clue ?

I've seen some patches on ALKML for PXA CCF, is it in the mainline now? 
Could that have been the reason? Is CONFIG_COMMON_CLK defined in your 
.config? Although, no, it's not PXA CCF, it's most probably this

commit 4f528afcfbcac540c8690b41307cac5c22088ff1
Author: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date:   Sun Feb 1 08:12:33 2015 -0300

    [media] V4L: add CCF support to the v4l2_clk API

:( But I don't understand how this can happen. V4L is certainly not the 
only driver in your build, that uses clk ops! They are exported from 
drivers/clk/clk.c for GPL, but v4l2-dev.c defines the GPL licence, so, 
should be ok. V4L is built as a module in your configuration, right? Can 
you try building it into the image?

Thanks
Guennadi

> 
> Cheers.
> 
> -- 
> Robert
> 
> PS: A small extract of my .config
> rj@belgarion:~/mio_linux/kernel$ grep CLK .config
> CONFIG_HAVE_CLK=y
> CONFIG_PM_CLK=y
> # CONFIG_MMC_CLKGATE is not set
> CONFIG_CLKDEV_LOOKUP=y
> CONFIG_CLKSRC_OF=y
> CONFIG_CLKSRC_MMIO=y
> CONFIG_CLKSRC_PXA=y
> rj@belgarion:~/mio_linux/kernel$ grep V4L .config
> CONFIG_VIDEO_V4L2=y
> CONFIG_V4L_PLATFORM_DRIVERS=y
> # CONFIG_V4L_MEM2MEM_DRIVERS is not set
> # CONFIG_V4L_TEST_DRIVERS is not set
> CONFIG_DVB_AU8522_V4L=m
> 
