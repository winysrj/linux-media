Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:55941 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZFJQwS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 12:52:18 -0400
Date: Wed, 10 Jun 2009 13:52:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jirislaby@gmail.com, fujita.tomonori@lab.ntt.co.jp,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] vino: replace dma_sync_single with
 dma_sync_single_for_cpu
Message-ID: <20090610135200.00b858b8@pedra.chehab.org>
In-Reply-To: <20090601110831E.fujita.tomonori@lab.ntt.co.jp>
References: <20090528100938I.fujita.tomonori@lab.ntt.co.jp>
	<4A1E28E6.2090807@gmail.com>
	<20090601110831E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 1 Jun 2009 11:08:26 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> escreveu:

> On Thu, 28 May 2009 08:02:14 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > On 05/28/2009 03:10 AM, FUJITA Tomonori wrote:
> > > This replaces dma_sync_single() with dma_sync_single_for_cpu() because
> > > dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:
> > > 
> > > /* Backwards compat, remove in 2.7.x */
> > > #define dma_sync_single		dma_sync_single_for_cpu
> > > #define dma_sync_sg		dma_sync_sg_for_cpu
> > > 
> > > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > ---
> > >  drivers/media/video/vino.c |    6 +++---
> > >  1 files changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
> > > index 43e0998..97b082f 100644
> > > --- a/drivers/media/video/vino.c
> > > +++ b/drivers/media/video/vino.c
> > > @@ -868,9 +868,9 @@ static void vino_sync_buffer(struct vino_framebuffer *fb)
> > >  	dprintk("vino_sync_buffer():\n");
> > >  
> > >  	for (i = 0; i < fb->desc_table.page_count; i++)
> > > -		dma_sync_single(NULL,
> > > -				fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
> > > -				PAGE_SIZE, DMA_FROM_DEVICE);
> > > +		dma_sync_single_for_cpu(NULL,
> > > +					fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
> > > +					PAGE_SIZE, DMA_FROM_DEVICE);
> > 
> > Shouldn't be there sync_for_device in vino_dma_setup (or somewhere)
> > then? If I understand the API correctly this won't (and didn't) work on
> > some platforms.

Well, this driver is bound to an specific architecture:

config VIDEO_VINO
        tristate "SGI Vino Video For Linux (EXPERIMENTAL)"
        depends on I2C && SGI_IP22 && EXPERIMENTAL && VIDEO_V4L2

So, it works only with a few SGI machines.

> 
> Yeah, you might be right.
> 
> However, looks like this driver does only DMA_FROM_DEVICE transfer and
> cpu doesn't modify the DMA buffer.
> 
> So we don't need to worry that the hardware gets old data. And it's
> not possible that we write back old data in cache to the main memory
> after DMA. It means that the driver doesn't need
> sync_single_for_device(), I think.
> 
> Note that this patch doesn't break the driver (this patch doesn't
> change anything). If this patch doesn't work, then this driver is
> already broken.

This driver were written a long time ago. I'm not sure if it still works fine,
since all patches we receive are related to API changes.

Yet, it seems better to apply your patch, since it doesn't hurt. For now, I'll
apply it.

It would be interesting to have someone to test the removal of this call, since
it looks that this call is not needed.

Cheers,
Mauro
