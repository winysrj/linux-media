Return-path: <mchehab@gaivota>
Received: from d1.icnet.pl ([212.160.220.21]:33176 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab0LSLsd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Dec 2010 06:48:33 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RESEND] [PATCH 1/2] OMAP1: allow reserving memory for camera
Date: Sun, 19 Dec 2010 12:46:13 +0100
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Tony Lindgren <tony@atomide.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201012051929.07220.jkrzyszt@tis.icnet.pl> <AANLkTi=ZYi=12k2vZMGp9AWNX8zofp6C-FnMu2egQOA1@mail.gmail.com> <20101215170142.GA10883@n2100.arm.linux.org.uk>
In-Reply-To: <20101215170142.GA10883@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012191246.17064.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Wednesday 15 December 2010 18:01:42 Russell King - ARM Linux wrote:
> On Wed, Dec 15, 2010 at 12:39:20PM +0000, Catalin Marinas wrote:
> >
> > Should we not try to fix the generic code and still allow platforms
> > to use dma_declare_coherent_memory() in a safer way? I guess it may
> > need some arguing/explanation on linux-arch.
>
> I think so - 

Hi Russel,
I've already started implementing what you've suggested, with an already 
working result, but have two questions:

1. Is it save to leave iounmap() being called on virtual addresses not 
   obtained with ioremap()? This would make things less complicated.

2. Can I quote your full explanation, just like it looks below, in my 
   commit message?

Thanks,
Janusz

Wednesday 15 December 2010 18:01:42 Russell King - ARM Linux wrote:
> ... one of the issues with dma_declare_coherent_memory() is 
> that it's original intention (as I understand it) was to allow
> drivers to use on-device dma coherent memory.
>
> Eg, a network controller with its own local SRAM which it can fetch
> DMA descriptors from, which tells it where in the bus address space
> to fetch packets from.  This SRAM is not part of the hosts memory,
> but is on the peripheral's bus, and so ioremap() (or maybe
> ioremap_wc()) would be appropriate for it.
>
> However, ioremap() on system RAM (even that which has been taken out
> on the memory map) may be problematical.
>
> I think the correct solution would be to revise the interface so it
> takes a void * pointer, which can be handed out by
> dma_alloc_coherent() directly without the API having to worry about
> how to map the memory.  IOW, push the mapping of that memory up a
> level to the caller of
> dma_declare_coherent_memory().
>
> We can then sanely do preallocations via dma_coherent_alloc() and
> caching them back into dma_declare_coherent_memory() without creating
> additional mappings which cause architectural violations.
