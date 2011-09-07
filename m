Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63288 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab1IGUrx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2011 16:47:53 -0400
Date: Wed, 7 Sep 2011 22:47:38 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-arm-kernel@lists.infradead.org,
	Baruch Siach <baruch@tkos.co.il>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media i.MX27 camera: remove legacy dma support
In-Reply-To: <20110824073614.GU31404@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1109072246320.31156@axis700.grange>
References: <1314167073-11058-1-git-send-email-s.hauer@pengutronix.de>
 <Pine.LNX.4.64.1108240843001.8985@axis700.grange> <20110824073614.GU31404@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha

(hope, you've had good holidays:-))

Any update on this? Do we want this for 3.2?

Thanks
Guennadi

On Wed, 24 Aug 2011, Sascha Hauer wrote:

> Hi Guennadi,
> 
> On Wed, Aug 24, 2011 at 09:19:24AM +0200, Guennadi Liakhovetski wrote:
> > Sure, if it's broken, let's remove it. But there are a couple of points, 
> > that we have to fix in this patch. Sorry, a stupid question: has this been 
> > tested on i.MX27?
> 
> Nope, I currently do not have mainline board support for this driver.
> Could be a good opportunity to add some...
> 
> Your other points are totally valid and I will fix them in the next
> round. Let's first see if someone proves me wrong and says this dma
> support is indeed working.
> 
> > > -	return IRQ_HANDLED;
> > > -}
> > > -#else
> > >  static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
> > >  {
> > >  	return IRQ_NONE;
> > >  }
> > 
> > If this is really all, what's needed for i.MX27 ISR, let's remove it 
> > completely. But maybe you could explain to me, how it is now supposed to 
> > work on i.MX27. In probe() we have
> > 
> > 	irq_handler_t mx2_cam_irq_handler = cpu_is_mx25() ? mx25_camera_irq
> > 		: mx27_camera_irq;
> > 
> > 	...
> > 
> > 	err = request_irq(pcdev->irq_csi, mx2_cam_irq_handler, 0,
> > 			MX2_CAM_DRV_NAME, pcdev);
> > 
> > So, after this patch i.MX27 will always have a dummy camera ISR and just 
> > use EMMA, right?
> 
> Yes, only the EMMA irq is used, we can remove this one.
> 
> > Then maybe we have to make EMMA resource availability 
> > compulsory on those SoCs, and not optional, as now? You'll have to make 
> > emma the only possibility on i.MX27, then pcdev->use_emma will disappear, 
> > locations like
> 
> ok.
> 
> Sascha
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
