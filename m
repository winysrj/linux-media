Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48799 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752271Ab0F3JIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jun 2010 05:08:32 -0400
Date: Wed, 30 Jun 2010 11:08:41 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
cc: Baruch Siach <baruch@tkos.co.il>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCHv4 1/3] mx2_camera: Add soc_camera support for i.MX25/i.MX27
In-Reply-To: <20100630072808.GD11746@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1006301058170.17489@axis700.grange>
References: <cover.1277096909.git.baruch@tkos.co.il>
 <03d6e55c39690618e92a91a580ec34549a135c79.1277096909.git.baruch@tkos.co.il>
 <20100630070717.GA11746@pengutronix.de> <Pine.LNX.4.64.1006300918190.17489@axis700.grange>
 <20100630072808.GD11746@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, there's a question for you below.

On Wed, 30 Jun 2010, Uwe Kleine-König wrote:

> Hi Guennadi,
> 
> On Wed, Jun 30, 2010 at 09:20:36AM +0200, Guennadi Liakhovetski wrote:
> > > > --- a/arch/arm/plat-mxc/include/mach/memory.h
> > > > +++ b/arch/arm/plat-mxc/include/mach/memory.h
> > > > @@ -44,12 +44,12 @@
> > > >   */
> > > >  #define CONSISTENT_DMA_SIZE SZ_8M
> > > >  
> > > > -#elif defined(CONFIG_MX1_VIDEO)
> > > > +#elif defined(CONFIG_MX1_VIDEO) || defined(CONFIG_MX2_VIDEO)
> > > >  /*
> > > >   * Increase size of DMA-consistent memory region.
> > > >   * This is required for i.MX camera driver to capture at least four VGA frames.
> > > >   */
> > > >  #define CONSISTENT_DMA_SIZE SZ_4M
> > > > -#endif /* CONFIG_MX1_VIDEO */
> > > > +#endif /* CONFIG_MX1_VIDEO || CONFIG_MX2_VIDEO */
> > > Why not use CONFIG_VIDEO_MX2 here and get rid of CONFIG_MX2_VIDEO?
> > 
> > Well, firstly for uniformity with MX1 and MX3,
> Using a common scheme for names on all platforms is fine, but if the
> existing names are bad better establish a nicer scheme.
> 
> >                                                secondly not to have to use 
> > (CONFIG_VIDEO_MX2 || CONFIG_VIDEO_MX2_MODULE),
> ah, didn't notice that MX?_VIDEO is bool while VIDEO_MX? is tristate.
> That's fine.  Still I would prefer a better naming that doesn't force
> having to look up which variable is for the driver and which is for the
> arch stuff.
> 
> >                                                also note, that 
> > CONFIG_MX1_VIDEO is also used for linking of the FIQ handler for the camera.
> This is just a matter of fixing the corresponding Makefile.

So, you call a change like

 # Support for CMOS sensor interface
-obj-$(CONFIG_MX1_VIDEO)	+= ksym_mx1.o mx1_camera_fiq.o
+ifneq ($(CONFIG_VIDEO_MX1),)
+obj-y				+= ksym_mx1.o mx1_camera_fiq.o
+endif

a fix?... In any case, I'm fine with the patch as it is, so, here's

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

I think, it would be better if you, Uwe, or Sascha pull all these 3 
patches via one of your tree, because patches 2/3 and 3/3 are ARM/MX2 
stuff anyway and this patch changes some files under arch/arm and collides 
with some mx2 changes. Mauro, do you agree? Do we need your ack too? So, 
taking them all via IMX/MXC would make synchronisation easier. However, if 
you change anything under drivers/media (including Makefile / Kconfig) or 
include/media, please let me know, so that I can ack it again.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
