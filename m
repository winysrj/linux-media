Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:38303 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbcCHA0w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2016 19:26:52 -0500
Date: Tue, 8 Mar 2016 09:26:46 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] media: sh_mobile_ceu_camera, rcar_vin: Use ARCH_RENESAS
Message-ID: <20160308002646.GD5024@verge.net.au>
References: <1456969935-31879-1-git-send-email-horms+renesas@verge.net.au>
 <CAMuHMdXePj4R6pw+58xKQfAqhdCBZ=8qc-fXeVsDe8APmjunGA@mail.gmail.com>
 <20160307012755.GA22756@verge.net.au>
 <CAMuHMdVr+T73VknnJqhfSv6-OZAJzZ9J4qONuFr4GnXQ1LRJ8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVr+T73VknnJqhfSv6-OZAJzZ9J4qONuFr4GnXQ1LRJ8g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 07, 2016 at 08:53:56AM +0100, Geert Uytterhoeven wrote:
> Hi Simon,
> 
> Oops, seems I dropped all CCs in my earlier reply. Fixing up...
> 
> On Mon, Mar 7, 2016 at 2:28 AM, Simon Horman <horms@verge.net.au> wrote:
> > On Thu, Mar 03, 2016 at 09:40:07AM +0100, Geert Uytterhoeven wrote:
> >> On Thu, Mar 3, 2016 at 2:52 AM, Simon Horman <horms+renesas@verge.net.au> wrote:
> >> > Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
> >> >
> >> > This is part of an ongoing process to migrate from ARCH_SHMOBILE to
> >> > ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
> >> > appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
> >> >
> >> > Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> >>
> >> > --- a/drivers/media/platform/soc_camera/Kconfig
> >> > +++ b/drivers/media/platform/soc_camera/Kconfig
> >> > @@ -36,7 +36,7 @@ config VIDEO_PXA27x
> >> >  config VIDEO_RCAR_VIN
> >> >         tristate "R-Car Video Input (VIN) support"
> >> >         depends on VIDEO_DEV && SOC_CAMERA
> >> > -       depends on ARCH_SHMOBILE || COMPILE_TEST
> >> > +       depends on ARCH_RENESAS || COMPILE_TEST
> >>
> >> OK
> >>
> >> >>  config VIDEO_SH_MOBILE_CEU
> >> >         tristate "SuperH Mobile CEU Interface driver"
> >> >         depends on VIDEO_DEV && SOC_CAMERA && HAS_DMA && HAVE_CLK
> >> > -       depends on ARCH_SHMOBILE || SUPERH || COMPILE_TEST
> >> > +       depends on ARCH_RENESAS || SUPERH || COMPILE_TEST
> >>
> >> I think dropping the SUPERH dependency is the right approach here, as all
> >> SuperH platforms using this driver select ARCH_SHMOBILE.
> >>
> >> "sh_mobile_ceu" is used on SH_AP325RXA, SH_ECOVEC, SH_KFR2R09, SH_MIGOR,
> >> and SH_7724_SOLUTION_ENGINE, which depend on either CPU_SUBTYPE_SH7722,
> >>  CPU_SUBTYPE_SH7723, or
> >> CPU_SUBTYPE_SH7724, and all three select ARCH_SHMOBILE.
> >
> > Dropping SUPERH seems fine to me. But in that case I think the following
> > would be best as I would like to stop selecting ARCH_SHMOBILE for
> > the ARM SoCs.
> >
> >         depends on ARCH_RENESAS || ARCH_SHMOBILE || COMPILE_TEST
> 
> Do we need this driver with ARCH_RENESAS? It does not support DT.
> 
> R8a7740 has the sh_mobile_ceu hardware, but support for it was dropped with
> r8a7740/armadillo legacy removal.

Silly me, no it is not needed.
