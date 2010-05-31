Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53439 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0EaHy0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 03:54:26 -0400
Date: Mon, 31 May 2010 09:54:25 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mt9m111 swap_rgb_red_blue
Message-ID: <20100531075424.GD26820@pengutronix.de>
References: <20100526141848.GU17272@pengutronix.de> <87bpc2za9i.fsf@free.fr> <20100528062731.GE23664@pengutronix.de> <87y6f1uhnn.fsf@free.fr> <Pine.LNX.4.64.1005310842160.16053@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005310842160.16053@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 31, 2010 at 08:46:00AM +0200, Guennadi Liakhovetski wrote:
> On Mon, 31 May 2010, Robert Jarzmik wrote:
> 
> > Sascha Hauer <s.hauer@pengutronix.de> writes:
> > 
> > > Hi Robert,
> > >
> > > I have digged around in the Datasheet and if I understand it correctly
> > > the PXA swaps red/blue in RGB mode. So if we do not use rgb mode but yuv
> > > (which should be a pass through) we should be able to support rgb on PXA
> > > aswell. Robert, can you confirm that with the following patch applied
> > > you still get an image but with red/blue swapped?
> > I can confirm the color swap.
> > If you want to follow that path, I would suggest instead :
> >    cicr1 |= CICR1_COLOR_SP_VAL(0);
> > 
> > There is no difference from a processing point of view, it's just that
> > CICR1_COLOR_SP_VAL(0) is "raw colorspace", with means "pass through", and that
> > seems to be your goal here.
> 
> That would be the default case in that switch, but raw only supports 8, 9, 
> or 10 bpp, so, you'd have to use 8bpp but then fake the pixels-per-line 
> field.

That's why I suggested yuv. I could leave a big comment why this is
done, but I would implement it using raw mode aswell if that's prefered.

> But that would be the cleanest way, yes. Would that work like that?
> 
> > Note that the patch would have to be completed with the BGR565 into RGB565
> > conversion, if the sensor was to provide only BGR565. But that could very well
> > be for another patch.

Will do, I just wanted to see if this works at all.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
