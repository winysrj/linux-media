Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50121 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2FHJYO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 05:24:14 -0400
Date: Fri, 8 Jun 2012 11:23:43 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, kernel@pengutronix.de,
	Fabio Estevam <festevam@gmail.com>,
	linux-media@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
	Dirk Behme <dirk.behme@googlemail.com>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
Message-ID: <20120608092343.GU30400@pengutronix.de>
References: <CACKLOr2jQMnBPTaTFOcfLN_9J1n39tLx-ffDcVGuZ4ZB-odYfg@mail.gmail.com>
 <20120608072601.GD30137@pengutronix.de>
 <CACKLOr1OShoEnLxs8BP6q2TyZrOH0oCnpbKZJqyAo-yXKck9Zw@mail.gmail.com>
 <20120608084802.GS30400@pengutronix.de>
 <CACKLOr2wdF4tnovpnCO+ys7OMhbaKoruorSsj5hPfB26jGzQTA@mail.gmail.com>
 <CACKLOr1G+GBMhRoWSMJ17LoKuiUe0b+BXcuzEKh4OUKNaU_M8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr1G+GBMhRoWSMJ17LoKuiUe0b+BXcuzEKh4OUKNaU_M8A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 08, 2012 at 11:02:31AM +0200, javier Martin wrote:
> Hi,
> I've checked this matter with a colleague and we have several reasons
> to doubt that the i.MX27 and the i.MX53 can share the same driver for
> their Video Processing Units (VPU):
> 
> 1. The VPU in the i.MX27 is a "codadx6" with support for H.264, H.263
> and MPEG4-Part2 [1]. Provided Freescale is using the same IP provider
> for i.MX53 and looking at the features that the VPU in this SoC
> supports (1080p resolution, VP8) we are probably dealing with a "coda
> 9 series" [2].
> 
> 2. An important part of the functionality for controlling the
> "codadx6" is implemented using software messages between the main CPU
> and the VPU, this means that a different firmware loaded in the VPU
> can substantially change the way it is handled. As previously stated,
> i.MX27 and i.MX53 have different IP blocks and because of this, those
> messages will be very different.
> 
> For these reasons we suggest that we carry on developing different
> drivers for the i.MX27 and the i.MX53. Though it's true that both
> drivers could share some overhead given by the use of mem2mem
> framework, I don't think this is a good enough reason the merge them.
> 
> By the way, driver for the VPU in the i.MX27 will be called
> "codadx6"[3], I suggest you call your driver "coda9" to avoid
> confusion.

Well, our driver works on i.MX27 and i.MX5. Yes, it needs some
abstraction for different register layouts and different features, but
the cores behave sufficiently similar that it makes sense to share the
code in a single driver.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
