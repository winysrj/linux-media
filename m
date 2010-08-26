Return-path: <mchehab@pedra>
Received: from mail.issp.bas.bg ([195.96.236.10]:47391 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab0HZSgK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Aug 2010 14:36:10 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Thu, 26 Aug 2010 21:32:26 +0300
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
	g.liakhovetski@gmx.de, linux-sh@vger.kernel.org, gregkh@suse.de,
	linux-kernel@vger.kernel.org, u.kleine-koenig@pengutronix.de,
	jkrzyszt@tis.icnet.pl, philippe.retornaz@epfl.ch,
	akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org
References: <Pine.LNX.4.64.1008261100150.14167@axis700.grange> <20100826185102I.fujita.tomonori@lab.ntt.co.jp> <20100826174909.GA13224@n2100.arm.linux.org.uk>
In-Reply-To: <20100826174909.GA13224@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008262132.35523.mitov@issp.bas.bg>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thursday, August 26, 2010 08:49:09 pm Russell King - ARM Linux wrote:
> On Thu, Aug 26, 2010 at 06:51:48PM +0900, FUJITA Tomonori wrote:
> > On Thu, 26 Aug 2010 11:45:58 +0200 (CEST)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > 
> > > On Thu, 26 Aug 2010, FUJITA Tomonori wrote:
> > > 
> > > > Why can't you revert a commit that causes the regression?
> > > 
> > > See this reply, and the complete thread too.
> > > 
> > > http://marc.info/?l=linux-sh&m=128130485208262&w=2
> > > 
> > > > The related DMA API wasn't changed in 2.6.36-rc1. The DMA API is not
> > > > responsible for the regression. And the patchset even exnteds the
> > > > definition of the DMA API (dma_declare_coherent_memory). Such change
> > > > shouldn't applied after rc1. I think that DMA-API.txt says that
> > > > dma_declare_coherent_memory() handles coherent memory for a particular
> > > > device. It's not for the API that reserves coherent memory that can be
> > > > used for any device for a single device.
> > > 
> > > Anyway, we need a way to fix the regression.
> > 
> > Needs to find a different way.
> 
> No.  ioremap on memory mapped by the kernel is just plain not permitted
> with ARMv6 and ARMv7 architectures.

Hi Russell,

Just because ioremap on memory mapped by the kernel is just plain not permitted
I have proposed a new pair of functions: dma_reserve_coherent_memory()/dma_free_reserved_memory()

http://lkml.org/lkml/2010/8/19/200

but it is not quite well accepted from the community.
What is your opinion?

Thanks,

Marin Mitov

> 
> It's not something you can say "oh, need to find another way" because there
> is _no_ software solution to having physical regions mapped multiple times
> with different attributes.  It's an architectural restriction.
> 
> We can't unmap the kernel's memory mapping either, as I've already explained
> several times this month - and I'm getting frustrated at having to keep
> on explaining that point.
> 
> Just accept the plain fact that multiple mappings of the same physical
> regions have become illegal.
> 
> What we need is another alternative other than using ioremap on memory
> already mapped by the kernel - eg, by reserving a certain chunk of
> memory for this purpose at boot time which his _never_ mapped by the
> kernel, except via ioremap.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
