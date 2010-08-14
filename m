Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:48976 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0HNKaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Aug 2010 06:30:16 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Marin Mitov <mitov@issp.bas.bg>
Subject: Re: [RFC] [PATCH 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Sat, 14 Aug 2010 12:28:36 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl> <201008132113.10147.jkrzyszt@tis.icnet.pl> <201008140747.57140.mitov@issp.bas.bg>
In-Reply-To: <201008140747.57140.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201008141228.39053.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Saturday 14 August 2010 06:47:56 Marin Mitov napisał(a):
> On Friday, August 13, 2010 10:13:08 pm Janusz Krzysztofik wrote:
> > Friday 13 August 2010 11:11:52 Marin Mitov napisał(a):
> > > On Friday, August 13, 2010 11:52:41 am Guennadi Liakhovetski wrote:
> > > > On Fri, 13 Aug 2010, Janusz Krzysztofik wrote:
> > > > > Thursday 12 August 2010 23:38:17 Guennadi Liakhovetski napisał(a):
> > > > > > 1. We've discussed this dynamic switching a bit on IRC today. The
> > > > > > first reaction was - you probably should concentrate on getting
> > > > > > the contiguous version to work reliably. I.e., to reserve the
> > > > > > memory in the board init code similar, how other contig users
> > > > > > currently do it.
> > > > >
> > > > > I already tried before to find out how I could allocate memory at
> > > > > init without reinventing a new videobuf-dma-contig implementation.
> > > > > Since in the Documentation/video4linux/videobuf I've read that
> > > > > videobuf does not currently play well with drivers that play tricks
> > > > > by allocating DMA space at system boot time, I've implemented the
> > > > > alternate sg path.
> > > > >
> > > > > If it's not quite true what the documentation says and you can give
> > > > > me a hint how this could be done, I might try again.
> > > >
> > > > For an example look at
> > > > arch/arm/mach-mx3/mach-pcm037.c::pcm037_camera_alloc_dma().
> >
> > Yes, this is the solution that suffers from the already discussed
> > limitation of not being able to remap a memory with different attributes,
> > which affects OMAP1 as well.
> >
> > > For preallocating dma-coherent memory for device personal use during
> > > device probe() time (when the memory is less fragmented compared to
> > > open() time) see also dt3155_alloc_coherent/dt3155_free_coherent in
> > > drivers/staging/dt3155v4l/dt3155vfl.c (for x86 arch, I do not know if
> > > it works for arm arch)
> >
> > With this workaround applied, I get much better results, thank you Marin.
> > However, it seems not bullet proof, since mmap still happens to fail for
> > a reason not quite clear to me:
>
> This is just a preallocation of coherent memory kept for further private
> driver use, should not be connected to mmap problem.

I'm not sure if it is related or not. This "mmap problem" exhibits ultimately 
when my driver is trying to allocate a piece of memory that has been 
preallocated that "custom" way.

> > Maybe I should preallocate a few more pages than will be actually used by
> > the driver?
> >
> > Anyways, I'm not sure if this piece of code could be accepted for
> > inclusion into the mainline tree, perhaps only under drivers/staging.
>
> The idea for the piece of code I have proposed to you is taken from the
> functions dma_declare_coherent_memory()/dma_release_declared_memory() in
> mainline drivers/base/dma-coherent.c

Then why not using the dma_declare_coherent_memory(), possibly after providing 
a patch that corrects a problem with it if there is one, instead of 
reimplementing it inside a driver?

If I understood what a difference it could make if we put a 
dma_alloc_coherent() returned virtual address space pointer to the allocated 
region, instead of the ioremapped physical address base of this region, to 
the dev->dma_mem->virt_base, then maybe I could say something more on this.

Thanks,
Janusz
