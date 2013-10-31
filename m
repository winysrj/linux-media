Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:27147 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3JaLqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Oct 2013 07:46:54 -0400
Date: Thu, 31 Oct 2013 09:46:40 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
	alsa-devel@alsa-project.org, b43-dev@lists.infradead.org,
	devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, e1000-devel@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 19/51] DMA-API: media: dt3155v4l: replace
 dma_set_mask()+dma_set_coherent_mask() with new helper
Message-id: <20131031094640.205840a2@samsung.com>
In-reply-to: <5249673B.5020705@xs4all.nl>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk>
 <E1VMm13-0007hO-9l@rmk-PC.arm.linux.org.uk> <5249673B.5020705@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Russell,

Em Mon, 30 Sep 2013 13:57:47 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/19/2013 11:44 PM, Russell King wrote:
> > Replace the following sequence:
> > 
> > 	dma_set_mask(dev, mask);
> > 	dma_set_coherent_mask(dev, mask);
> > 
> > with a call to the new helper dma_set_mask_and_coherent().
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Somehow, I lost your original post (I got unsubscribed on a few days 
from all vger mailing lists at the end of september).

I suspect that you want to sent this via your tree, right?
If so:

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> 
> Regards,
> 
> 	Hans
> 
> > ---
> >  drivers/staging/media/dt3155v4l/dt3155v4l.c |    5 +----
> >  1 files changed, 1 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/staging/media/dt3155v4l/dt3155v4l.c b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> > index 90d6ac4..081407b 100644
> > --- a/drivers/staging/media/dt3155v4l/dt3155v4l.c
> > +++ b/drivers/staging/media/dt3155v4l/dt3155v4l.c
> > @@ -901,10 +901,7 @@ dt3155_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  	int err;
> >  	struct dt3155_priv *pd;
> >  
> > -	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
> > -	if (err)
> > -		return -ENODEV;
> > -	err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
> > +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> >  	if (err)
> >  		return -ENODEV;
> >  	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
