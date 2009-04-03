Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51280 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbZDCMsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 08:48:02 -0400
Date: Fri, 3 Apr 2009 14:47:58 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Darius Augulis <augulis.darius@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V4] Add camera (CSI) driver for MX1
Message-ID: <20090403124758.GW23731@pengutronix.de>
References: <20090403113054.11098.67516.stgit@localhost.localdomain> <Pine.LNX.4.64.0904031352350.4729@axis700.grange> <20090403122939.GT23731@pengutronix.de> <Pine.LNX.4.64.0904031437540.4729@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904031437540.4729@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 03, 2009 at 02:41:16PM +0200, Guennadi Liakhovetski wrote:
> On Fri, 3 Apr 2009, Sascha Hauer wrote:
> 
> > On Fri, Apr 03, 2009 at 02:15:34PM +0200, Guennadi Liakhovetski wrote:
> > > Wondering, if it still will work then... At least it compiles. BTW, should 
> > > it really also work with IMX? Then you might want to change this
> > > 
> > > 	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
> > > 
> > > to
> > > 
> > > 	depends on VIDEO_DEV && (ARCH_MX1 || ARCH_IMX) && SOC_CAMERA
> > 
> > This shouldn't be necessary. ARCH_IMX does not have the platform part to
> > make use of this driver and will never get it.
> 
> Confused... Then why the whole that "IMX/MX1" in the driver? And why will 
> it never get it - are they compatible or not? 

Not just compatible, they are the same. A little bit of history: I
originally brought i.MX1 support to the kernel in the early 2.6 days.
around 2.6.25 Freescale pushed initial i.MX31 support using plat-mxc. We in
turn based our i.MX27 port on this code and since then it evolved
further. Darius based a new i.MX1 support on this code and now we can
remove arch-imx.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
