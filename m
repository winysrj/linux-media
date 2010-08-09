Return-path: <baruch@tkos.co.il>
Received: from tango.tkos.co.il ([62.219.50.35]:49754 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029Ab0HILqc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Aug 2010 07:46:32 -0400
Date: Mon, 9 Aug 2010 14:46:11 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 2/4] mx2_camera: return IRQ_NONE when doing nothing
Message-ID: <20100809114611.GD2894@jasper.tkos.co.il>
References: <cover.1280229966.git.baruch@tkos.co.il>
 <49da2476310a921b19226d572503b7c04175204d.1280229966.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1007281317400.23907@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007281317400.23907@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wed, Jul 28, 2010 at 01:25:27PM +0200, Guennadi Liakhovetski wrote:
> A general comment to your patches: the actual driver is going to be merged 
> via the ARM tree, all other your incremental patches should rather go via 
> the v4l tree. So, we'll have to synchronise with ARM, let's hope ARM 
> patches go in early enough.

Since the driver is now merged upstream this series can go via the v4l tree.

> On Tue, 27 Jul 2010, Baruch Siach wrote:
> 
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
> > +	else if (status & CSISR_DMA_TSF_FB1_INT)
> >  		mx25_camera_frame_done(pcdev, 1, VIDEOBUF_DONE);
> >  	else if (status & CSISR_DMA_TSF_FB2_INT)
> >  		mx25_camera_frame_done(pcdev, 2, VIDEOBUF_DONE);
> >  
> >  	/* FIXME: handle CSISR_RFF_OR_INT */
> >  
> > -	writel(status, pcdev->base_csi + CSISR);
> > -
> >  	return IRQ_HANDLED;
> >  }
> 
> I don't think this is correct. You should return IRQ_NONE if this is not 
> an interrupt from your device at all. In this case you don't have to ack 
> your interrupts, which, I presume, is what the write to CSISR is doing. 
> OTOH, if this is an interrupt from your device, but you're just not 
> interested in it, you should ack it and return IRQ_HANDLED. So, the 
> original behaviour was more correct, than what this your patch is doing. 
> The only improvement I can think of is, that you can return IRQ_NONE if 
> status is 0, but then you don't have to ack it.

OK. Drop this one, then. Patches in this series are independent from each 
other, so the others can go in.

baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
