Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51595 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0ESIzo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 04:55:44 -0400
Date: Wed, 19 May 2010 10:55:35 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/3] mx2_camera: Add soc_camera support for
	i.MX25/i.MX27
Message-ID: <20100519085534.GI31199@pengutronix.de>
References: <cover.1273150585.git.baruch@tkos.co.il> <a029bab8fcb3273df4a1d98f779f110b127742bd.1273150585.git.baruch@tkos.co.il> <Pine.LNX.4.64.1005090045230.10524@axis700.grange> <20100517072720.GD31199@pengutronix.de> <20100517135800.GB30927@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100517135800.GB30927@jasper.tkos.co.il>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 17, 2010 at 04:58:00PM +0300, Baruch Siach wrote:
> Hi Sascha,
> 
> Thanks for your comments.
> 
> On Mon, May 17, 2010 at 09:27:20AM +0200, Sascha Hauer wrote:
> > On Wed, May 12, 2010 at 09:02:29PM +0200, Guennadi Liakhovetski wrote:
> > > Hi Baruch
> > > 
> > > Thanks for eventually mainlining this driver! A couple of comments below. 
> > > Sascha, would be great, if you could get it tested on imx27 with and 
> > > without emma.
> > 
> > I will see what I can do. Testing and probably breathing life into a
> > camera driver usually takes me two days given that the platform support
> > is very outdated. I hope our customer is interested in this, then it
> > would be possible to test it.
> > 
> > > BTW, if you say, that you use emma to avoid using the 
> > > standard DMA controller, why would anyone want not to use emma? Resource 
> > > conflict? There is also a question for you down in the comments, please, 
> > > skim over.
> > 
> > I originally did not know how all the components should work together.
> > Now I think it's the right way to use the EMMA to be able to scale
> > images and to do colour conversions (which does not work with our Bayer
> > format cameras, so I cannot test it).
> 
> So can I remove the non EMMA code from this driver? This will simplify the 
> code quite a bit.

Please don't. I had a talk with our customer and it seems I can put some
effort into the i.MX27 part. That's good news because I also want this
driver mainline.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
