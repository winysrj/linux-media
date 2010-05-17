Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:60204 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab0EQN7J (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 May 2010 09:59:09 -0400
Date: Mon, 17 May 2010 16:58:00 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/3] mx2_camera: Add soc_camera support for
 i.MX25/i.MX27
Message-ID: <20100517135800.GB30927@jasper.tkos.co.il>
References: <cover.1273150585.git.baruch@tkos.co.il>
 <a029bab8fcb3273df4a1d98f779f110b127742bd.1273150585.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1005090045230.10524@axis700.grange>
 <20100517072720.GD31199@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517072720.GD31199@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

Thanks for your comments.

On Mon, May 17, 2010 at 09:27:20AM +0200, Sascha Hauer wrote:
> On Wed, May 12, 2010 at 09:02:29PM +0200, Guennadi Liakhovetski wrote:
> > Hi Baruch
> > 
> > Thanks for eventually mainlining this driver! A couple of comments below. 
> > Sascha, would be great, if you could get it tested on imx27 with and 
> > without emma.
> 
> I will see what I can do. Testing and probably breathing life into a
> camera driver usually takes me two days given that the platform support
> is very outdated. I hope our customer is interested in this, then it
> would be possible to test it.
> 
> > BTW, if you say, that you use emma to avoid using the 
> > standard DMA controller, why would anyone want not to use emma? Resource 
> > conflict? There is also a question for you down in the comments, please, 
> > skim over.
> 
> I originally did not know how all the components should work together.
> Now I think it's the right way to use the EMMA to be able to scale
> images and to do colour conversions (which does not work with our Bayer
> format cameras, so I cannot test it).

So can I remove the non EMMA code from this driver? This will simplify the 
code quite a bit.

[snip]

> > > +static int mclk_get_divisor(struct mx2_camera_dev *pcdev)
> > > +{
> > > +	dev_info(pcdev->dev, "%s not implemented. Running at max speed\n",
> > > +			__func__);
> > 
> > Hm, why is this unimplemented?
> > 
> > > +
> > > +#if 0
> > > +	unsigned int mclk = pcdev->pdata->clk_csi;
> > > +	unsigned int pclk = clk_get_rate(pcdev->clk_csi);
> > > +	int i;
> > > +
> > > +	dev_dbg(pcdev->dev, "%s: %ld %ld\n", __func__, mclk, pclk);
> > > +
> > > +	for (i = 0; i < 0xf; i++)
> > > +		if ((i + 1) * 2 * mclk <= pclk)
> > > +			break;
> > 
> > This doesn't look right. You increment the counter i, and terminate the
> > loop as soon as "(i + 1) * 2 * mclk <= pclk". Obviously, if 2 * mclk <= pclk,
> > this will terminate immediately, otherwise it will run until the end and
> > return 0xf without satisfying the condition. What exactly are you trying to
> > achieve? Find the _largest_ i, such that "(i + 1) * 2 * mclk <= pclk"? Then
> > why not just do "i = pclk / 2 / mclk - 1"?
> > 
> > > +	return i;
> > > +#endif
> > > +	return 0;
> > > +}

Can you shed some light on this?

Thanks,
baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
