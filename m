Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab0G1H1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 03:27:44 -0400
Date: Wed, 28 Jul 2010 08:27:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Baruch Siach <baruch@tkos.co.il>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/4] mx2_camera: return IRQ_NONE when doing nothing
Message-ID: <20100728072718.GB29277@n2100.arm.linux.org.uk>
References: <cover.1280229966.git.baruch@tkos.co.il> <49da2476310a921b19226d572503b7c04175204d.1280229966.git.baruch@tkos.co.il> <20100728065337.GC14113@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728065337.GC14113@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 28, 2010 at 08:53:37AM +0200, Sascha Hauer wrote:
> On Tue, Jul 27, 2010 at 03:06:08PM +0300, Baruch Siach wrote:
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  drivers/media/video/mx2_camera.c |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > index 1536bd4..b42ad8d 100644
> > --- a/drivers/media/video/mx2_camera.c
> > +++ b/drivers/media/video/mx2_camera.c
> > @@ -420,15 +420,17 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
> >  	struct mx2_camera_dev *pcdev = data;
> >  	u32 status = readl(pcdev->base_csi + CSISR);
> >  
> > -	if (status & CSISR_DMA_TSF_FB1_INT)
> > +	writel(status, pcdev->base_csi + CSISR);
> > +
> > +	if (!(status & (CSISR_DMA_TSF_FB1_INT | CSISR_DMA_TSF_FB2_INT)))
> > +		return IRQ_NONE;
> 
> I'm not sure this is correct. When we get here, the interrupt definitely
> is from the camera, it's not a shared interrupt. So this only provokes a
> 'nobody cared' message from the kernel (if it's still present, I don't
> know).

You'll only get the 'nobody cared' message if it's happened many times
in a short space of time.  The odd spurious IRQ_NONE has little effect.

It is good practice to return IRQ_NONE if there's nothing pending - it
allows stuck IRQs to be detected and disabled without taking the system
down.  In other words, it should make the system more robust.
