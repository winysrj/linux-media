Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:35501 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab1EaLhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2011 07:37:13 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "JAIN, AMBER" <amber@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>
Date: Tue, 31 May 2011 17:06:59 +0530
Subject: RE: [PATCH] OMAP: V4L2: Remove GFP_DMA allocation as ZONE_DMA is
 not configured on OMAP
Message-ID: <19F8576C6E063C45BE387C64729E739404E2DC73EC@dbde02.ent.ti.com>
References: <1306835503-24631-1-git-send-email-amber@ti.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB037B65850E@dbde02.ent.ti.com>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB037B65850E@dbde02.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> -----Original Message-----
> From: JAIN, AMBER
> Sent: Tuesday, May 31, 2011 3:59 PM
> To: linux-media@vger.kernel.org
> Cc: Hiremath, Vaibhav; sakari.ailus@iki.fi
> Subject: RE: [PATCH] OMAP: V4L2: Remove GFP_DMA allocation as ZONE_DMA is
> not configured on OMAP
> 
> I have tested it on OMAP4430 blaze and OMAP3430 SDP platforms.
> 
> I do not have the hardware to test omap24xxcam change. Can someone please
> help me on this?
> 
[Hiremath, Vaibhav] I would suggest splitting this patch into 2, it would be easier to handle.

I am validating the patch on OMAP3EVM as well; will update you shortly. Pulling in the latest commits, git-fetch is taking huge time.

Thanks,
Vaibhav

> Thanks,
> Amber
> 
> > -----Original Message-----
> > From: JAIN, AMBER
> > Sent: Tuesday, May 31, 2011 3:22 PM
> > To: linux-media@vger.kernel.org
> > Cc: Hiremath, Vaibhav; sakari.ailus@iki.fi; JAIN, AMBER
> > Subject: [PATCH] OMAP: V4L2: Remove GFP_DMA allocation as ZONE_DMA is
> not
> > configured on OMAP
> >
> > Remove GFP_DMA from the __get_free_pages() call as ZONE_DMA is not
> > configured
> > on OMAP. Earlier the page allocator used to return a page from
> ZONE_NORMAL
> > even when GFP_DMA is passed and CONFIG_ZONE_DMA is disabled.
> > As a result of commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac, page
> > allocator
> > returns null in such a scenario with a warning emitted to kernel log.
> >
> > Signed-off-by: Amber Jain <amber@ti.com>
> > ---
> >  drivers/media/video/omap/omap_vout.c |    2 +-
> >  drivers/media/video/omap24xxcam.c    |    4 ++--
> >  2 files changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/media/video/omap/omap_vout.c
> > b/drivers/media/video/omap/omap_vout.c
> > index 4ada9be..8cac624 100644
> > --- a/drivers/media/video/omap/omap_vout.c
> > +++ b/drivers/media/video/omap/omap_vout.c
> > @@ -181,7 +181,7 @@ static unsigned long omap_vout_alloc_buffer(u32
> > buf_size, u32 *phys_addr)
> >
> >  	size = PAGE_ALIGN(buf_size);
> >  	order = get_order(size);
> > -	virt_addr = __get_free_pages(GFP_KERNEL | GFP_DMA, order);
> > +	virt_addr = __get_free_pages(GFP_KERNEL , order);
> >  	addr = virt_addr;
> >
> >  	if (virt_addr) {
> > diff --git a/drivers/media/video/omap24xxcam.c
> > b/drivers/media/video/omap24xxcam.c
> > index f6626e8..ade9262 100644
> > --- a/drivers/media/video/omap24xxcam.c
> > +++ b/drivers/media/video/omap24xxcam.c
> > @@ -309,11 +309,11 @@ static int
> omap24xxcam_vbq_alloc_mmap_buffer(struct
> > videobuf_buffer *vb)
> >  			order--;
> >
> >  		/* try to allocate as many contiguous pages as possible */
> > -		page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> > +		page = alloc_pages(GFP_KERNEL , order);
> >  		/* if allocation fails, try to allocate smaller amount */
> >  		while (page == NULL) {
> >  			order--;
> > -			page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> > +			page = alloc_pages(GFP_KERNEL , order);
> >  			if (page == NULL && !order) {
> >  				err = -ENOMEM;
> >  				goto out;
> > --
> > 1.7.1

