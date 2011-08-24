Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37791 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1HXHgV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 03:36:21 -0400
Date: Wed, 24 Aug 2011 09:36:14 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Baruch Siach <baruch@tkos.co.il>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media i.MX27 camera: remove legacy dma support
Message-ID: <20110824073614.GU31404@pengutronix.de>
References: <1314167073-11058-1-git-send-email-s.hauer@pengutronix.de>
 <Pine.LNX.4.64.1108240843001.8985@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108240843001.8985@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Aug 24, 2011 at 09:19:24AM +0200, Guennadi Liakhovetski wrote:
> Sure, if it's broken, let's remove it. But there are a couple of points, 
> that we have to fix in this patch. Sorry, a stupid question: has this been 
> tested on i.MX27?

Nope, I currently do not have mainline board support for this driver.
Could be a good opportunity to add some...

Your other points are totally valid and I will fix them in the next
round. Let's first see if someone proves me wrong and says this dma
support is indeed working.

> > -	return IRQ_HANDLED;
> > -}
> > -#else
> >  static irqreturn_t mx27_camera_irq(int irq_csi, void *data)
> >  {
> >  	return IRQ_NONE;
> >  }
> 
> If this is really all, what's needed for i.MX27 ISR, let's remove it 
> completely. But maybe you could explain to me, how it is now supposed to 
> work on i.MX27. In probe() we have
> 
> 	irq_handler_t mx2_cam_irq_handler = cpu_is_mx25() ? mx25_camera_irq
> 		: mx27_camera_irq;
> 
> 	...
> 
> 	err = request_irq(pcdev->irq_csi, mx2_cam_irq_handler, 0,
> 			MX2_CAM_DRV_NAME, pcdev);
> 
> So, after this patch i.MX27 will always have a dummy camera ISR and just 
> use EMMA, right?

Yes, only the EMMA irq is used, we can remove this one.

> Then maybe we have to make EMMA resource availability 
> compulsory on those SoCs, and not optional, as now? You'll have to make 
> emma the only possibility on i.MX27, then pcdev->use_emma will disappear, 
> locations like

ok.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
