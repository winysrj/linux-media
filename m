Return-path: <linux-media-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33229 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab0ENAkm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 20:40:42 -0400
Date: Fri, 14 May 2010 09:40:24 +0900
To: pete@sensoray.com, gregkh@suse.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux-media@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] Staging: saa7134-go7007: replace dma_sync_single with
 dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1273789524.4502.51.camel@pete-desktop>
References: <20100513124613U.fujita.tomonori@lab.ntt.co.jp>
	<1273789524.4502.51.camel@pete-desktop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100514094117H.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 13 May 2010 15:25:24 -0700
Pete Eberlein <pete@sensoray.com> wrote:

> Thanks, Tomonori.
> 
> Does this need to get submitted to the linux-media tree as well, or will
> this patch get pulled automatically from Linus' tree?

I think that patches for staging drivers are merged via Greg's staging
tree.


> Thanks,
> Pete Eberlein
> 
> On Thu, 2010-05-13 at 12:45 +0900, FUJITA Tomonori wrote:
> > dma_sync_single() is deprecated and will be removed soon.
> > 
> > No functional change since dma_sync_single is the wrapper of
> > dma_sync_single_for_cpu.
> > 
> > saa7134-go7007.c is commented out but anyway let's replace it.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  drivers/staging/go7007/saa7134-go7007.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/go7007/saa7134-go7007.c b/drivers/staging/go7007/saa7134-go7007.c
> > index b25d7d2..0d36ce7 100644
> > --- a/drivers/staging/go7007/saa7134-go7007.c
> > +++ b/drivers/staging/go7007/saa7134-go7007.c
> > @@ -242,13 +242,13 @@ static void saa7134_go7007_irq_ts_done(struct saa7134_dev *dev,
> >  		printk(KERN_DEBUG "saa7134-go7007: irq: lost %ld\n",
> >  				(status >> 16) & 0x0f);
> >  	if (status & 0x100000) {
> > -		dma_sync_single(&dev->pci->dev,
> > -				saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
> > +		dma_sync_single_for_cpu(&dev->pci->dev,
> > +					saa->bottom_dma, PAGE_SIZE, DMA_FROM_DEVICE);
> >  		go7007_parse_video_stream(go, saa->bottom, PAGE_SIZE);
> >  		saa_writel(SAA7134_RS_BA2(5), cpu_to_le32(saa->bottom_dma));
> >  	} else {
> > -		dma_sync_single(&dev->pci->dev,
> > -				saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
> > +		dma_sync_single_for_cpu(&dev->pci->dev,
> > +					saa->top_dma, PAGE_SIZE, DMA_FROM_DEVICE);
> >  		go7007_parse_video_stream(go, saa->top, PAGE_SIZE);
> >  		saa_writel(SAA7134_RS_BA1(5), cpu_to_le32(saa->top_dma));
> >  	}
> 
> 
> 
> 
