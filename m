Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60799 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755199Ab0EaGpx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 02:45:53 -0400
Date: Mon, 31 May 2010 08:46:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: mt9m111 swap_rgb_red_blue
In-Reply-To: <87y6f1uhnn.fsf@free.fr>
Message-ID: <Pine.LNX.4.64.1005310842160.16053@axis700.grange>
References: <20100526141848.GU17272@pengutronix.de> <87bpc2za9i.fsf@free.fr>
 <20100528062731.GE23664@pengutronix.de> <87y6f1uhnn.fsf@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 31 May 2010, Robert Jarzmik wrote:

> Sascha Hauer <s.hauer@pengutronix.de> writes:
> 
> > Hi Robert,
> >
> > I have digged around in the Datasheet and if I understand it correctly
> > the PXA swaps red/blue in RGB mode. So if we do not use rgb mode but yuv
> > (which should be a pass through) we should be able to support rgb on PXA
> > aswell. Robert, can you confirm that with the following patch applied
> > you still get an image but with red/blue swapped?
> I can confirm the color swap.
> If you want to follow that path, I would suggest instead :
>    cicr1 |= CICR1_COLOR_SP_VAL(0);
> 
> There is no difference from a processing point of view, it's just that
> CICR1_COLOR_SP_VAL(0) is "raw colorspace", with means "pass through", and that
> seems to be your goal here.

That would be the default case in that switch, but raw only supports 8, 9, 
or 10 bpp, so, you'd have to use 8bpp but then fake the pixels-per-line 
field. But that would be the cleanest way, yes. Would that work like that?

> Note that the patch would have to be completed with the BGR565 into RGB565
> conversion, if the sensor was to provide only BGR565. But that could very well
> be for another patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
