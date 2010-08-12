Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:46385 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754932Ab0HLViU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 17:38:20 -0400
Date: Thu, 12 Aug 2010 23:38:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Discussion of the Amstrad E3 emailer hardware/software
	<e3-hacking@earth.li>
Subject: Re: [RFC] [PATCH 1/6] SoC Camera: add driver for OMAP1 camera
 interface
In-Reply-To: <201008011751.17294.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1008111339190.32197@axis700.grange>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl>
 <Pine.LNX.4.64.1007291043380.16266@axis700.grange> <201007302049.09085.jkrzyszt@tis.icnet.pl>
 <201008011751.17294.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Sun, 1 Aug 2010, Janusz Krzysztofik wrote:

> Friday 30 July 2010 20:49:05 Janusz Krzysztofik napisał(a):
> > Friday 30 July 2010 13:07:42 Guennadi Liakhovetski napisał(a):
> > > On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:
> > > > This is a V4L2 driver for TI OMAP1 SoC camera interface.
> > > >
> > > > Two versions of the driver are provided, using either
> > > > videobuf-dma-contig or videobuf-dma-sg. The former uses less processing
> > > > power, but often fails to allocate contignuous buffer memory. The
> > > > latter is free of this problem, but generates tens of DMA interrupts
> > > > per frame.
> > >
> > > Hm, would it be difficult to first try contig, and if it fails - fall
> > > back to sg?
> >
> > Hmm, let me think about it.
> 
> Hi Gennadi,
> 
> For me, your idea of frist trying contig and then falling back to sg if it 
> fails, sounds great. However, I'm not sure if implementing it at a specific 
> hardware driver level is a good solution. Nor soc_camera framework seems the 
> right place for it either.
> 
> I think the right way would be if implemented at the videobuf-core level. 
> Then, drivers should be able to initialize both paths, providing queue 
> callbacks for both sets of methods, contig and sg, for videobuf sole use.

Ok, here're my thoughts about this:

1. We've discussed this dynamic switching a bit on IRC today. The first 
reaction was - you probably should concentrate on getting the contiguous 
version to work reliably. I.e., to reserve the memory in the board init 
code similar, how other contig users currently do it. But given problems 
with this aproach in the current ARM tree [1], this might be a bit 
difficult. Still, those problems have to be and will be fixed somehow 
eventually, so, you might prefer to still just go that route.

2. If you do want to do the switching - we also discussed, how forthcoming 
changes to the videobuf subsystem will affest this work. I do not think it 
would be possible to implement this switching in the videobuf core. 
Remember, with the videobuf API you first call the respective 
implementation init method, which doesn't fail. Then, in REQBUFS ioctl you 
call videobuf_reqbufs(), which might already fail but normally doesn't. 
The biggest problem is the mmap call with the contig videobuf 
implementation. This one is likely to fail. So, you would have to catch 
the failing mmap, call videobuf_mmap_free(), then init the SG videobuf, 
request buffers and mmap them... With my 2 patches from today, there is 
only one process (file descriptor, to be precise), that manages the 
videobuf queue. So, this all can only be implemented in your driver.

[1] http://thread.gmane.org/gmane.linux.ports.sh.devel/8560

> I'm not sure if I have enough skills to implement this idea. However, if there 
> is a consensus on its general usfullness as a videobuf extension, I can have 
> a look at it in my spare time.
> 
> For now, I'd propose limiting my changes for v2 to splitting both methods into 
> separate sections, not interleaved with #ifdefs like they are now, as you've 
> already suggested.

Yep, so, I think, your choice is either to drop sg completely, or to 
separate the two cleanly and switch between them dynamically in your 
driver.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
