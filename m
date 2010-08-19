Return-path: <mchehab@pedra>
Received: from mail.issp.bas.bg ([195.96.236.10]:48818 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab0HSR1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Aug 2010 13:27:19 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: Re: [RFC] [PATCH 1/6] SoC Camera: add driver for OMAP1 camera interface
Date: Thu, 19 Aug 2010 20:25:31 +0300
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201007180618.08266.jkrzyszt@tis.icnet.pl> <201008191516.21910.mitov@issp.bas.bg> <201008191909.28697.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201008191909.28697.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008192025.31660.mitov@issp.bas.bg>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thursday, August 19, 2010 08:09:27 pm Janusz Krzysztofik wrote:
> Thursday 19 August 2010 14:16:21 Marin Mitov napisał(a):
> > On Thursday, August 19, 2010 02:39:47 pm Guennadi Liakhovetski wrote:
> > >
> > > No, I don't think you should go to the next power of 2 - that's too
> > > crude. Try rounding your buffer size to the page size, that should
> > > suffice.
> 
> Guennadi,
> If you have a look at how a device reserved memory is next allocated to a 
> driver with drivers/base/dma-coherent.c::dma_alloc_from_coherent(), then than 
> you may find my conclusion on a power of 2 as true:
> 
> int dma_alloc_from_coherent(struct device *dev, ssize_t size,
> 					dma_addr_t *dma_handle, void **ret)
> {
> ...
>         int order = get_order(size);
> ...
> 	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
> ...
> }
> 
> 
> > Allocated coherent memory is always a power of 2.
> 
> Marin,
> For ARM, this seems true as long as allocated with the above from a device 
> assigned pool, but not true for a (pre)allocation from a generic system RAM. 
> See arch/arm/mm/dma-mapping.c::__dma_alloc_buffer(), where it looks like extra 
> pages are freed:
> 
> static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gfp)
> {
> 	unsigned long order = get_order(size);
> ...
> 	page = alloc_pages(gfp, order);
> ...
> 	split_page(page, order);
>         for (p = page + (size >> PAGE_SHIFT), e = page + (1 << order); p < e; p++)
>                 __free_page(p);
> ...
> }	

Thanks for the clarification.

Marin Mitov

> 
> 
> Thanks,
> Janusz
> 
