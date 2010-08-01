Return-path: <linux-media-owner@vger.kernel.org>
Received: from d1.icnet.pl ([212.160.220.21]:56291 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab0HAPwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Aug 2010 11:52:07 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] [PATCH 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Sun, 1 Aug 2010 17:51:15 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1007291043380.16266@axis700.grange> <201007302049.09085.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201007302049.09085.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201008011751.17294.jkrzyszt@tis.icnet.pl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Friday 30 July 2010 20:49:05 Janusz Krzysztofik napisał(a):
> Friday 30 July 2010 13:07:42 Guennadi Liakhovetski napisał(a):
> > On Sun, 18 Jul 2010, Janusz Krzysztofik wrote:
> > > This is a V4L2 driver for TI OMAP1 SoC camera interface.
> > >
> > > Two versions of the driver are provided, using either
> > > videobuf-dma-contig or videobuf-dma-sg. The former uses less processing
> > > power, but often fails to allocate contignuous buffer memory. The
> > > latter is free of this problem, but generates tens of DMA interrupts
> > > per frame.
> >
> > Hm, would it be difficult to first try contig, and if it fails - fall
> > back to sg?
>
> Hmm, let me think about it.

Hi Gennadi,

For me, your idea of frist trying contig and then falling back to sg if it 
fails, sounds great. However, I'm not sure if implementing it at a specific 
hardware driver level is a good solution. Nor soc_camera framework seems the 
right place for it either.

I think the right way would be if implemented at the videobuf-core level. 
Then, drivers should be able to initialize both paths, providing queue 
callbacks for both sets of methods, contig and sg, for videobuf sole use.

I'm not sure if I have enough skills to implement this idea. However, if there 
is a consensus on its general usfullness as a videobuf extension, I can have 
a look at it in my spare time.

For now, I'd propose limiting my changes for v2 to splitting both methods into 
separate sections, not interleaved with #ifdefs like they are now, as you've 
already suggested.

Thanks,
Janusz
