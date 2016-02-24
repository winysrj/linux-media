Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:38929 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbcBXX42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 18:56:28 -0500
Date: Thu, 25 Feb 2016 08:56:22 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: platform: rcar_jpu, sh_vou, vsp1: Use ARCH_RENESAS
Message-ID: <20160224235619.GA5936@verge.net.au>
References: <1456280542-13113-1-git-send-email-horms+renesas@verge.net.au>
 <CAMuHMdUwvgaLtLLSk7jdg1N7mafpGz0VsikhbcFsuGQDHAunVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUwvgaLtLLSk7jdg1N7mafpGz0VsikhbcFsuGQDHAunVw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 24, 2016 at 08:46:31AM +0100, Geert Uytterhoeven wrote:
> Hi Simon,
> 
> On Wed, Feb 24, 2016 at 3:22 AM, Simon Horman
> <horms+renesas@verge.net.au> wrote:
> > Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
> >
> > This is part of an ongoing process to migrate from ARCH_SHMOBILE to
> > ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
> > appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
> >
> > Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> > ---
> >  drivers/media/platform/Kconfig | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >  Based on media_tree/master
> >
> > diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> > index 201f5c296a95..662c029400de 100644
> > --- a/drivers/media/platform/Kconfig
> > +++ b/drivers/media/platform/Kconfig
> > @@ -37,7 +37,7 @@ config VIDEO_SH_VOU
> >         tristate "SuperH VOU video output driver"
> >         depends on MEDIA_CAMERA_SUPPORT
> >         depends on VIDEO_DEV && I2C && HAS_DMA
> > -       depends on ARCH_SHMOBILE || COMPILE_TEST
> > +       depends on ARCH_RENESAS || COMPILE_TEST
> 
> This driver is used on sh7722/sh7723/sh7724 only.
> While these are Renesas parts, ARCH_RENESAS isn't set for SuperH SoCs,
> making this driver unavailable where needed.

Thanks for pointing that out, I had missed that detail.

Ideally I would like to stop setting ARCH_SHMOBILE for ARM Based
SoCs. So perhaps the following would be best?

	depends on ARCH_SHMOBILE || ARCH_RENESAS || COMPILE_TEST

> >         select VIDEOBUF2_DMA_CONTIG
> >         help
> >           Support for the Video Output Unit (VOU) on SuperH SoCs.
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
