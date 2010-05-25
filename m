Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58955 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0EYHUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 May 2010 03:20:06 -0400
Date: Tue, 25 May 2010 09:20:04 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Baruch Siach <baruch@tkos.co.il>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] Driver for the i.MX2x CMOS Sensor Interface
Message-ID: <20100525072004.GI17272@pengutronix.de>
References: <cover.1273150585.git.baruch@tkos.co.il> <20100521072045.GD17272@pengutronix.de> <20100521072737.GA6967@tarshish> <Pine.LNX.4.64.1005212023400.8450@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1005212023400.8450@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 21, 2010 at 08:33:40PM +0200, Guennadi Liakhovetski wrote:
> On Fri, 21 May 2010, Baruch Siach wrote:
> 
> > Hi Sascha,
> > 
> > On Fri, May 21, 2010 at 09:20:45AM +0200, Sascha Hauer wrote:
> > > On Thu, May 06, 2010 at 04:09:38PM +0300, Baruch Siach wrote:
> > > > This series contains a soc_camera driver for the i.MX25/i.MX27 CSI device, and 
> > > > platform code for the i.MX25 and i.MX27 chips. This driver is based on a driver 
> > > > for i.MX27 CSI from Sascha Hauer, that  Alan Carvalho de Assis has posted in 
> > > > linux-media last December[1]. Since all I have is a i.MX25 PDK paltform I can't 
> > > > test the mx27 specific code. Testers and comment are welcome.
> > > > 
> > > > [1] https://patchwork.kernel.org/patch/67636/
> > > > 
> > > > Baruch Siach (3):
> > > >   mx2_camera: Add soc_camera support for i.MX25/i.MX27
> > > >   mx27: add support for the CSI device
> > > >   mx25: add support for the CSI device
> > > 
> > > With the two additions I sent I can confirm this working on i.MX27, so
> > > no need to remove the related code.
> > 
> > Thanks. I'll add your patches to my queue and resend the series next week.
> 
> Firstly, Sascha, unfortunately, you've forgotten to CC the maintainer, 
> that will have to deal with these patches.
> 
> Secondly, I don't think that's a good idea to submit mx27 fixes as 
> incremental patches. I'd prefer to have them rolled into the actual driver 
> submission patches, where Sascha would just add his Sob / acked-by / 
> tested-by / whatever... Or you can first submit an mx25-only driver and 
> let Sascha add mx27 to it, in which case this would be a functionality 
> extension, but not a fix of a broken driver.

My intention with these fixes was that Baruch integrates them into his
patch (which he did).

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
