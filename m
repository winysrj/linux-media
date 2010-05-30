Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:44407 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab0E3WwX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 18:52:23 -0400
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: mt9m111 swap_rgb_red_blue
References: <20100526141848.GU17272@pengutronix.de> <87bpc2za9i.fsf@free.fr>
	<20100528062731.GE23664@pengutronix.de>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 31 May 2010 00:52:12 +0200
Message-ID: <87y6f1uhnn.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sascha Hauer <s.hauer@pengutronix.de> writes:

> Hi Robert,
>
> I have digged around in the Datasheet and if I understand it correctly
> the PXA swaps red/blue in RGB mode. So if we do not use rgb mode but yuv
> (which should be a pass through) we should be able to support rgb on PXA
> aswell. Robert, can you confirm that with the following patch applied
> you still get an image but with red/blue swapped?
I can confirm the color swap.
If you want to follow that path, I would suggest instead :
   cicr1 |= CICR1_COLOR_SP_VAL(0);

There is no difference from a processing point of view, it's just that
CICR1_COLOR_SP_VAL(0) is "raw colorspace", with means "pass through", and that
seems to be your goal here.

Note that the patch would have to be completed with the BGR565 into RGB565
conversion, if the sensor was to provide only BGR565. But that could very well
be for another patch.

Cheers.

--
Robert
