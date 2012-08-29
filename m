Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:61239 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2H2QCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Aug 2012 12:02:35 -0400
Date: Wed, 29 Aug 2012 18:02:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Josh Wu <josh.wu@atmel.com>, linux-media@vger.kernel.org,
	nicolas.ferre@atmel.com, mchehab@redhat.com,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] [media] atmel_isi: allocate memory to store the isi
 platform data.
In-Reply-To: <503E323A.8060409@samsung.com>
Message-ID: <alpine.DEB.2.00.1208291755220.3095@axis700.grange>
References: <1346235093-28613-1-git-send-email-josh.wu@atmel.com> <503E323A.8060409@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 29 Aug 2012, Sylwester Nawrocki wrote:

> Hi,
> 
> On 08/29/2012 12:11 PM, Josh Wu wrote:
> > This patch fix the bug: ISI driver's platform data became invalid 
> > when isi platform data's attribution is __initdata.
> > 
> > If the isi platform data is passed as __initdata. Then we need store
> > it in driver allocated memory. otherwise when we use it out of the 
> > probe() function, then the isi platform data is invalid.
> > 
> > Signed-off-by: Josh Wu <josh.wu@atmel.com>
> > ---
> >  drivers/media/platform/soc_camera/atmel-isi.c |   12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> > index ec3f6a0..dc0fdec 100644
> > --- a/drivers/media/platform/soc_camera/atmel-isi.c
> > +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> > @@ -926,6 +926,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
> >  	clk_put(isi->mck);
> >  	clk_unprepare(isi->pclk);
> >  	clk_put(isi->pclk);
> > +	kfree(isi->pdata);
> >  	kfree(isi);
> >  
> >  	return 0;
> > @@ -968,8 +969,15 @@ static int __devinit atmel_isi_probe(struct platform_device *pdev)
> >  		goto err_alloc_isi;
> >  	}
> >  
> > +	isi->pdata = kzalloc(sizeof(struct isi_platform_data), GFP_KERNEL);
> > +	if (!isi->pdata) {
> > +		ret = -ENOMEM;
> > +		dev_err(&pdev->dev, "Can't allocate isi platform data!\n");
> > +		goto err_alloc_isi_pdata;
> > +	}
> > +	memcpy(isi->pdata, pdata, sizeof(struct isi_platform_data));
> > +
> 
> Why not just embed struct isi_platform_data in struct atmel_isi and drop this
> another kzalloc() ?
> Then you could simply do isi->pdata = *pdata.
> 
> Also, is this going to work when this driver is build and as a module
> and its loading is deferred past system booting ? At that time the driver's
> platform data may be well discarded.

Right, it will be gone, I think.

> You may wan't to duplicate it on the
> running boards in board code with kmemdup() or something.

How about removing __initdata from board code?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
