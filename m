Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:36258 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751399Ab3I3IMa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 04:12:30 -0400
Date: Mon, 30 Sep 2013 16:12:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: kbuild-all@01.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mcam-core.c:undefined reference to `vb2_dma_sg_memops'
Message-ID: <20130930081224.GA27870@localhost>
References: <5248d26d.XCpLjin/D8FfRGFk%fengguang.wu@intel.com>
 <20130930030518.GA3024@localhost>
 <CAMuHMdWj2BBQ88Wrx_sNNELVG5LiupsaG+RxWpidC2HC-=Y8MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWj2BBQ88Wrx_sNNELVG5LiupsaG+RxWpidC2HC-=Y8MA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 30, 2013 at 09:09:13AM +0200, Geert Uytterhoeven wrote:
> Hi Fengguang,
> 
> On Mon, Sep 30, 2013 at 5:05 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > FYI, kernel build failed on
> >
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   15c03dd4859ab16f9212238f29dd315654aa94f6
> > commit: 866f321339988293a5bb3ec6634c2c9d8396bf54 Revert "staging/solo6x10: depend on CONFIG_FONTS"
> > date:   3 months ago
> > config: x86_64-randconfig-c5-0930 (attached as .config)
> >
> > All error/warnings:
> >
> >    drivers/built-in.o: In function `mcam_v4l_open':
> >>> mcam-core.c:(.text+0x3bf73a): undefined reference to `vb2_dma_sg_memops'
> 
> The referenced commit above is completely unrelated to this failure, as
> both CONFIG_SOLO6X10=m and CONFIG_VIDEOBUF2_DMA_SG=m,
> while this is about a missing symbol in builtin code.

You are probably right.. However I tried manually reproduce this error
and find that 866f3213 is the first bad commit (for whatever reason),
so I decided to email the report out.

> However, there's something wrong with the VIDEO_CAFE_CCIC dependencies.
> Untested gmail-white-space-damaged patch below (so your trick of emailing random
> people to obtain a solution worked ;-)

Yeah, indeed! :)

Thanks,
Fengguang

> >From 8a53ff3c33cfaa8641c9ba3e16bc5b0a35c74842 Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Mon, 30 Sep 2013 09:03:20 +0200
> Subject: [PATCH] [media] VIDEO_CAFE_CCIC should select VIDEOBUF2_DMA_SG
> 
> If VIDEO_CAFE_CCIC=y, but VIDEOBUF2_DMA_SG=m:
> 
> drivers/built-in.o: In function `mcam_v4l_open':
> >> mcam-core.c:(.text+0x3bf73a): undefined reference to `vb2_dma_sg_memops'
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  drivers/media/platform/marvell-ccic/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/platform/marvell-ccic/Kconfig
> b/drivers/media/platform/marvell-ccic/Kconfig
> index bf739e3..ec4c771 100644
> --- a/drivers/media/platform/marvell-ccic/Kconfig
> +++ b/drivers/media/platform/marvell-ccic/Kconfig
> @@ -4,6 +4,7 @@ config VIDEO_CAFE_CCIC
>   select VIDEO_OV7670
>   select VIDEOBUF2_VMALLOC
>   select VIDEOBUF2_DMA_CONTIG
> + select VIDEOBUF2_DMA_SG
>   ---help---
>    This is a video4linux2 driver for the Marvell 88ALP01 integrated
>    CMOS camera controller.  This is the controller found on first-
> -- 
> 1.7.9.5
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
