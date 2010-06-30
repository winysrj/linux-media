Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38114 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0F3JjG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 05:39:06 -0400
Date: Wed, 30 Jun 2010 11:38:55 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Baruch Siach <baruch@tkos.co.il>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv4 1/3] mx2_camera: Add soc_camera support for
	i.MX25/i.MX27
Message-ID: <20100630093855.GF11746@pengutronix.de>
References: <cover.1277096909.git.baruch@tkos.co.il> <03d6e55c39690618e92a91a580ec34549a135c79.1277096909.git.baruch@tkos.co.il> <20100630070717.GA11746@pengutronix.de> <Pine.LNX.4.64.1006300918190.17489@axis700.grange> <20100630072808.GD11746@pengutronix.de> <Pine.LNX.4.64.1006301058170.17489@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.1006301058170.17489@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Wed, Jun 30, 2010 at 11:08:41AM +0200, Guennadi Liakhovetski wrote:
> Mauro, there's a question for you below.
> 
> On Wed, 30 Jun 2010, Uwe Kleine-König wrote:
> 
> > Hi Guennadi,
> > 
> > On Wed, Jun 30, 2010 at 09:20:36AM +0200, Guennadi Liakhovetski wrote:
> > > > > --- a/arch/arm/plat-mxc/include/mach/memory.h
> > > > > +++ b/arch/arm/plat-mxc/include/mach/memory.h
> > > > > @@ -44,12 +44,12 @@
> > > > >   */
> > > > >  #define CONSISTENT_DMA_SIZE SZ_8M
> > > > >  
> > > > > -#elif defined(CONFIG_MX1_VIDEO)
> > > > > +#elif defined(CONFIG_MX1_VIDEO) || defined(CONFIG_MX2_VIDEO)
> > > > >  /*
> > > > >   * Increase size of DMA-consistent memory region.
> > > > >   * This is required for i.MX camera driver to capture at least four VGA frames.
> > > > >   */
> > > > >  #define CONSISTENT_DMA_SIZE SZ_4M
> > > > > -#endif /* CONFIG_MX1_VIDEO */
> > > > > +#endif /* CONFIG_MX1_VIDEO || CONFIG_MX2_VIDEO */
> > > > Why not use CONFIG_VIDEO_MX2 here and get rid of CONFIG_MX2_VIDEO?
> > > 
> > > Well, firstly for uniformity with MX1 and MX3,
> > Using a common scheme for names on all platforms is fine, but if the
> > existing names are bad better establish a nicer scheme.
> > 
> > >                                                secondly not to have to use 
> > > (CONFIG_VIDEO_MX2 || CONFIG_VIDEO_MX2_MODULE),
> > ah, didn't notice that MX?_VIDEO is bool while VIDEO_MX? is tristate.
> > That's fine.  Still I would prefer a better naming that doesn't force
> > having to look up which variable is for the driver and which is for the
> > arch stuff.
> > 
> > >                                                also note, that 
> > > CONFIG_MX1_VIDEO is also used for linking of the FIQ handler for the camera.
> > This is just a matter of fixing the corresponding Makefile.
> 
> So, you call a change like
> 
>  # Support for CMOS sensor interface
> -obj-$(CONFIG_MX1_VIDEO)	+= ksym_mx1.o mx1_camera_fiq.o
> +ifneq ($(CONFIG_VIDEO_MX1),)
> +obj-y				+= ksym_mx1.o mx1_camera_fiq.o
> +endif
No, I'd do something like

	config VIDEO_MX1_HOSTSUPPORT
		bool

	config VIDEO_MX1
		tristate ...
		selects VIDEO_MX1_HOSTSUPPORT
 
I'm not entirely happy with "...HOSTSUPPORT" but it's better than
MX1_VIDEO.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
