Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:37285 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab1FGOD6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 10:03:58 -0400
Date: Tue, 7 Jun 2011 08:03:56 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Kassey Lee <ygli@marvell.com>
Subject: Re: [PATCH 7/7] marvell-cam: Basic working MMP camera driver
Message-ID: <20110607080356.39b3db95@bike.lwn.net>
In-Reply-To: <Pine.LNX.4.64.1106070941140.31635@axis700.grange>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
	<1307400003-94758-8-git-send-email-corbet@lwn.net>
	<Pine.LNX.4.64.1106070941140.31635@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 7 Jun 2011 09:44:45 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

> > +obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/  
> 
> Wouldn't it be better to have only one symbol, selecting the marvell-ccic 
> directory in the Makefile and have all CAFE implementations select that 
> symbol?

Except there's two drivers in that directory and you'll almost never want
to build them both.  I guess I could replace one Makefile line with two
Kconfig lines, but I'm not sure it would improve things.

> > +config VIDEO_MMP_CAMERA
> > +	tristate "Marvell Armada 610 integrated camera controller support"
> > +	depends on ARCH_MMP && I2C && VIDEO_V4L2
> > +	select VIDEO_OV7670  
> 
> Is ov7670 really _integrated_ with the camera controller? Can it not be 
> used with any other sensor?

It should work with other sensors, yes, modulo the format information that
now has to be kept in the controller driver.  I'd be more than happy to
see it work with something other than the ov7670, I just don't have the
hardware to test it.

Thanks,

jon
