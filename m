Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49580 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbZDCM3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2009 08:29:44 -0400
Date: Fri, 3 Apr 2009 14:29:39 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Darius Augulis <augulis.darius@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	paulius.zaleckas@teltonika.lt
Subject: Re: [PATCH V4] Add camera (CSI) driver for MX1
Message-ID: <20090403122939.GT23731@pengutronix.de>
References: <20090403113054.11098.67516.stgit@localhost.localdomain> <Pine.LNX.4.64.0904031352350.4729@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904031352350.4729@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 03, 2009 at 02:15:34PM +0200, Guennadi Liakhovetski wrote:
> On Fri, 3 Apr 2009, Darius Augulis wrote:
> 
> > From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> > 
> > Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> > Signed-off-by: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
> 
> Ok, I'll just swap these two Sob's to reflect the processing chain, add a 
> description like
> 
> Add support for CMOS Sensor Interface on i.MX1 and i.MXL SoCs.
> 
> and fix a couple of trivial conflicts, which probably appear, because you 
> based your patches on an MXC tree, and not on current linux-next. 
> Wondering, if it still will work then... At least it compiles. BTW, should 
> it really also work with IMX? Then you might want to change this
> 
> 	depends on VIDEO_DEV && ARCH_MX1 && SOC_CAMERA
> 
> to
> 
> 	depends on VIDEO_DEV && (ARCH_MX1 || ARCH_IMX) && SOC_CAMERA

This shouldn't be necessary. ARCH_IMX does not have the platform part to
make use of this driver and will never get it.

> 
> but you can do this later, maybe, when you actually get a chance to test 
> it on IMX (if you haven't done so yet).
> 
> Sascha, we need your ack for the ARM part.

I'm OK with this driver: I have never worked with FIQs though so I can't
say much to it.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
