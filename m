Return-path: <linux-media-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54703 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbZFACIv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 22:08:51 -0400
Date: Mon, 1 Jun 2009 11:08:26 +0900
To: jirislaby@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, mchehab@redhat.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] vino: replace dma_sync_single with
 dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A1E28E6.2090807@gmail.com>
References: <20090528100938I.fujita.tomonori@lab.ntt.co.jp>
	<4A1E28E6.2090807@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090601110831E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 28 May 2009 08:02:14 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> On 05/28/2009 03:10 AM, FUJITA Tomonori wrote:
> > This replaces dma_sync_single() with dma_sync_single_for_cpu() because
> > dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:
> > 
> > /* Backwards compat, remove in 2.7.x */
> > #define dma_sync_single		dma_sync_single_for_cpu
> > #define dma_sync_sg		dma_sync_sg_for_cpu
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  drivers/media/video/vino.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
> > index 43e0998..97b082f 100644
> > --- a/drivers/media/video/vino.c
> > +++ b/drivers/media/video/vino.c
> > @@ -868,9 +868,9 @@ static void vino_sync_buffer(struct vino_framebuffer *fb)
> >  	dprintk("vino_sync_buffer():\n");
> >  
> >  	for (i = 0; i < fb->desc_table.page_count; i++)
> > -		dma_sync_single(NULL,
> > -				fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
> > -				PAGE_SIZE, DMA_FROM_DEVICE);
> > +		dma_sync_single_for_cpu(NULL,
> > +					fb->desc_table.dma_cpu[VINO_PAGE_RATIO * i],
> > +					PAGE_SIZE, DMA_FROM_DEVICE);
> 
> Shouldn't be there sync_for_device in vino_dma_setup (or somewhere)
> then? If I understand the API correctly this won't (and didn't) work on
> some platforms.

Yeah, you might be right.

However, looks like this driver does only DMA_FROM_DEVICE transfer and
cpu doesn't modify the DMA buffer.

So we don't need to worry that the hardware gets old data. And it's
not possible that we write back old data in cache to the main memory
after DMA. It means that the driver doesn't need
sync_single_for_device(), I think.

Note that this patch doesn't break the driver (this patch doesn't
change anything). If this patch doesn't work, then this driver is
already broken.


> The same for other drivers who don't free the buffer after the sync but
> recycle it instead.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
