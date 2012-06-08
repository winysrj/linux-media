Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52178 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757036Ab2FHP0L (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jun 2012 11:26:11 -0400
Date: Fri, 8 Jun 2012 17:25:54 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>, kernel@pengutronix.de,
	Fabio Estevam <festevam@gmail.com>,
	linux-media@vger.kernel.org, Shawn Guo <shawn.guo@linaro.org>,
	Dirk Behme <dirk.behme@googlemail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] Support for H.264/MPEG4 encoder (VPU) in i.MX27.
Message-ID: <20120608152554.GY30400@pengutronix.de>
References: <CACKLOr2jQMnBPTaTFOcfLN_9J1n39tLx-ffDcVGuZ4ZB-odYfg@mail.gmail.com>
 <20120608072601.GD30137@pengutronix.de>
 <CACKLOr1OShoEnLxs8BP6q2TyZrOH0oCnpbKZJqyAo-yXKck9Zw@mail.gmail.com>
 <20120608084802.GS30400@pengutronix.de>
 <CACKLOr2wdF4tnovpnCO+ys7OMhbaKoruorSsj5hPfB26jGzQTA@mail.gmail.com>
 <CACKLOr1G+GBMhRoWSMJ17LoKuiUe0b+BXcuzEKh4OUKNaU_M8A@mail.gmail.com>
 <20120608092343.GU30400@pengutronix.de>
 <CACKLOr1Q1yxbaMmrFVsw-h-SmS3H4q_R+KY=DgnjM5WjaDW9Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr1Q1yxbaMmrFVsw-h-SmS3H4q_R+KY=DgnjM5WjaDW9Cg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 08, 2012 at 01:32:27PM +0200, javier Martin wrote:
> On 8 June 2012 11:23, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Fri, Jun 08, 2012 at 11:02:31AM +0200, javier Martin wrote:
> 
> Hi Sascha,
> 
> From our point of view the current situation is the following:
> We have a very reliable driver for the VPU which is not mainline but
> it's been used for two years in our products. This driver only
> supports encoding in the i.MX27 chip.
> In parallel, you have a a multichip driver in progress which is not
> mainline either, not fully V4L2 compatible and not tested for i.MX27.
> [1]
> At the same time, we have a driver in progress for i.MX27 encoding
> only which follows V4L2 mem2mem framework. [2].
> 
> The first thing to decide would be which of both drivers we take as a
> base for final mainline developing.
> In our view, cleaning up driver from Pengutronix [1] would imply a lot
> of effort of maintaining code that we cannot really test (i.MX5,
> i.MX6) whereas if we continue using [2] we would have something valid
> for i.MX27 much faster. Support for decoding and other chips could be
> added later.
> 
> The second thing would be whether we keep on developing or whether we
> should wait for you to have something in mainline. We have already
> allocated resources to the development of the driver and long-term
> testing to achieve product level reliability. Pengutronix does not
> seem to be committed to developing the features relevant to our
> product (lack of YUV420 support for i.MX27 camera driver[6]) nor
> committed to any deadline (lack of answers or development on dmaengine
> for i.MX27[4][5]). Moreover, development effort is only 50% of the
> cost and we would still have to spend a lot of time checking the video
> stream manually in different real-rife conditions (only extensive
> testing allowed us to catch the "P frame marked as IDR" bug [7]).
> 
> As a conclusion we propose that we keep on developing our driver for
> encoding in the i.MX27 VPU under the following conditions:
> - We will provide a more generic name for the driver than "codadx6",
> maybe something as "imx_vpu".

Since we already know that this is a codadx6 we should name it codadx
instead of anything vpu specific. I also suggest codadx instead of
anything more specific like codadx6 since we should rather motivate
people to merge other coda cores into this driver.

> - We will do an extra effort and will study your code in [1] in order
> to provide a modular approach that makes adding new functionality (new
> chips or decoding) as easy as possible while making obvious that
> further patches do not break support for encoding in the i.MX27.

This sounds like a plan. I am happy that you are willing to keep an eye
on our driver. It would be a pity to have unnecessary barriers for
merging codadx9 stuff later.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
