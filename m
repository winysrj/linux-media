Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:52656 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0HMH0S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Aug 2010 03:26:18 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] [PATCH 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Fri, 13 Aug 2010 09:24:02 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl> <201008011751.17294.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1008111339190.32197@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1008111339190.32197@axis700.grange>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201008130924.04660.jkrzyszt@tis.icnet.pl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Thursday 12 August 2010 23:38:17 Guennadi Liakhovetski napisał(a):
> On Sun, 1 Aug 2010, Janusz Krzysztofik wrote:
> > Friday 30 July 2010 20:49:05 Janusz Krzysztofik napisaÅ(a):
> >
> > I think the right way would be if implemented at the videobuf-core level.
> > Then, drivers should be able to initialize both paths, providing queue
> > callbacks for both sets of methods, contig and sg, for videobuf sole use.
>
> Ok, here're my thoughts about this:
>
> 1. We've discussed this dynamic switching a bit on IRC today. The first
> reaction was - you probably should concentrate on getting the contiguous
> version to work reliably. I.e., to reserve the memory in the board init
> code similar, how other contig users currently do it. 

I already tried before to find out how I could allocate memory at init without 
reinventing a new videobuf-dma-contig implementation. Since in the 
Documentation/video4linux/videobuf I've read that videobuf does not currently 
play well with drivers that play tricks by allocating DMA space at system 
boot time, I've implemented the alternate sg path.

If it's not quite true what the documentation says and you can give me a hint 
how this could be done, I might try again.

> But given problems 
> with this aproach in the current ARM tree [1], this might be a bit
> difficult. Still, those problems have to be and will be fixed somehow
> eventually, so, you might prefer to still just go that route.

My board uses two drivers that allocate dma memory at boot time: 
drivers/video/omap/lcdc.c and sounc/soc/omap/omap-pcm.c. Both use 
alloc_dma_writecombine() for this and work without problems.

> 2. If you do want to do the switching - we also discussed, how forthcoming
> changes to the videobuf subsystem will affest this work. I do not think it
> would be possible to implement this switching in the videobuf core.

OK, I should have probably said that it looked not possible for me to do it 
without any additional support implemented at videobuf-core (or soc_camera) 
level.

> Remember, with the videobuf API you first call the respective
> implementation init method, which doesn't fail. Then, in REQBUFS ioctl you
> call videobuf_reqbufs(), which might already fail but normally doesn't.
> The biggest problem is the mmap call with the contig videobuf
> implementation. This one is likely to fail. So, you would have to catch
> the failing mmap, call videobuf_mmap_free(), then init the SG videobuf,
> request buffers and mmap them... 

That's what I've already discovered, but failed to identify a place in my code 
where I could intercept this failing mmap without replacing parts of the 
videobuf code.

> With my 2 patches from today, there is 
> only one process (file descriptor, to be precise), that manages the
> videobuf queue. So, this all can only be implemented in your driver.

The only way I'm yet able to invent is replacing the 
videobuf_queue->int_ops->mmap_mapper() callback with my own wrapper that 
would intercept a failing videobuf-dma-contig version of mmap_mapper(). This 
could be done in my soc_camera_host->ops->init_videobuf() after the 
videobuf-dma-contig.c version of the videobuf_queue->int_ops->mmap_mapper() 
is installed with the videobuf_queue_dma_contig_init().

Is this method close to what you have on mind?

Thanks,
Janusz
