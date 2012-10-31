Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:53460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760341Ab2JaTue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 15:50:34 -0400
Date: Wed, 31 Oct 2012 17:50:17 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, gcembed@gmail.com,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v4 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
Message-ID: <20121031175017.75640dc1@infradead.org>
In-Reply-To: <20121031190249.GO1641@pengutronix.de>
References: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
	<20121031095632.536d9362@infradead.org>
	<20121031131652.GM1641@pengutronix.de>
	<CAOMZO5CLxM41LYoLmPbfzSTF85Zk4B5SqHeVbGU4WjEOXw0eyg@mail.gmail.com>
	<Pine.LNX.4.64.1210311442310.12173@axis700.grange>
	<20121031165303.32921a5c@infradead.org>
	<20121031190249.GO1641@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 Oct 2012 20:02:49 +0100
Sascha Hauer <s.hauer@pengutronix.de> escreveu:

> On Wed, Oct 31, 2012 at 04:53:03PM -0200, Mauro Carvalho Chehab wrote:
> > Em Wed, 31 Oct 2012 14:53:47 +0100 (CET)
> > Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> > 
> > > On Wed, 31 Oct 2012, Fabio Estevam wrote:

> > I agree with Fabio and Guennadi. There are so many changes happening at arm
> > that merging those two patches there will likely be easier for everybody.
> 
> Ok, then I'll take them. I wasn't aware in arm-soc are sitting patches
> for this driver already.

Thank you!

> > 
> > Otherwise, I'll need to pull from some arm tree that never rebase, with
> > the needed patches, and coordinate with you during the merge window,
> > to be sure that patches will arrive there at the right order, from the
> > right tree.
> 
> Hopefully these kind of cross dependencies become fewer over time. SoC
> code is getting smaller and gets better abstracted from the drivers, so
> chances are good.

Yes, I'm expecting so.

Regards,
Mauro
