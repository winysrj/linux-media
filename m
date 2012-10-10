Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35388 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2JJIkO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Oct 2012 04:40:14 -0400
Date: Wed, 10 Oct 2012 10:40:06 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
Message-ID: <20121010084006.GQ27665@pengutronix.de>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
 <20121005151057.GA5125@pengutronix.de>
 <Pine.LNX.4.64.1210051735360.13761@axis700.grange>
 <20121005160242.GX1322@pengutronix.de>
 <Pine.LNX.4.64.1210080950350.11034@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210080950350.11034@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, Oct 08, 2012 at 09:58:58AM +0200, Guennadi Liakhovetski wrote:
> On Fri, 5 Oct 2012, Sascha Hauer wrote:
> 
> > On Fri, Oct 05, 2012 at 05:41:00PM +0200, Guennadi Liakhovetski wrote:
> > > Hi Sascha
> > > 
> > > > 
> > > > Maybe the example would be clearer if you split it up in two, one simple
> > > > case with the csi2_1 <-> imx074_1 and a more advanced with the link in
> > > > between.
> > > 
> > > With no link between two ports no connection is possible, so, only 
> > > examples with links make sense.
> > 
> > I should have said with the renesas,sh-mobile-ceu in between.
> > 
> > So simple example: csi2_1 <-l-> imx074_1
> > advanced: csi2_2 <-l-> ceu <-l-> ov772x
> 
> No, CEU is the DMA engine with some image processing, so, it's always 
> present. The CSI-2 is just a MIPI CSI-2 interface, that in the above case 
> is used with the CEU too. So, it's like
> 
>        ,-l- ov772x
>       /
> ceu0 <
>       \
>        `-l- csi2 -l- imx074
> 
> > > > It took me some time until I figured out that these are two
> > > > separate camera/sensor pairs. Somehow I was looking for a multiplexer
> > > > between them.
> > > 
> > > Maybe I can add more comments to the file, perhaps, add an ASCII-art 
> > > chart.
> > 
> > That would be good.
> 
> Is the above good enough? :)

Yes, thanks. We thought and disucssed about this devicetree binding
quite much the last days. Finally I understood it and I must say that I
like it. I think more prosa to explain the general concept would be good
in the binding doc.

Mark, when do we get the same for aSoC? ;)

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
