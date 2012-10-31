Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45563 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759981Ab2JaTC5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 15:02:57 -0400
Date: Wed, 31 Oct 2012 20:02:49 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, gcembed@gmail.com,
	javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v4 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
Message-ID: <20121031190249.GO1641@pengutronix.de>
References: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
 <20121031095632.536d9362@infradead.org>
 <20121031131652.GM1641@pengutronix.de>
 <CAOMZO5CLxM41LYoLmPbfzSTF85Zk4B5SqHeVbGU4WjEOXw0eyg@mail.gmail.com>
 <Pine.LNX.4.64.1210311442310.12173@axis700.grange>
 <20121031165303.32921a5c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031165303.32921a5c@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 31, 2012 at 04:53:03PM -0200, Mauro Carvalho Chehab wrote:
> Em Wed, 31 Oct 2012 14:53:47 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> 
> > On Wed, 31 Oct 2012, Fabio Estevam wrote:
> > 
> > > Hi Sascha,
> > > 
> > > On Wed, Oct 31, 2012 at 11:16 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > > 
> > > > Quoting yourself:
> > > >
> > > >> Forgot to comment: as patch 2 relies on this change, the better, IMHO, is
> > > >> to send both via the same tree. If you decide to do so, please get arm
> > > >> maintainer's ack, instead, and we can merge both via my tree.
> > > >
> > > > That's why Fabio resent these patches with my Ack. You are free to take
> > > > these.
> > > 
> > > I have just realized that this patch (1/2) will not apply against
> > > media tree because it does not have commit 27b76486a3 (media:
> > > mx2_camera: remove cpu_is_xxx by using platform_device_id), which
> > > changes from mx2_camera.0 to imx27-camera.0.
> > 
> > This is exactly the reason why I wasn't able to merge it. The problem was, 
> > that this "media: mx2_camera: remove cpu_is_xxx by using 
> > platform_device_id" patch non-trivially touched both arch/arm/ and 
> > drivers/media/ directories. And being patch 27/34 I didn't feel like 
> > asking the author to redo it again:-) This confirms, that it's better to 
> > avoid such overlapping patches whenever possible.
> > 
> > > So it seems to be better to merge this via arm tree to avoid such conflict.
> 
> I agree with Fabio and Guennadi. There are so many changes happening at arm
> that merging those two patches there will likely be easier for everybody.

Ok, then I'll take them. I wasn't aware in arm-soc are sitting patches
for this driver already.

> 
> Otherwise, I'll need to pull from some arm tree that never rebase, with
> the needed patches, and coordinate with you during the merge window,
> to be sure that patches will arrive there at the right order, from the
> right tree.

Hopefully these kind of cross dependencies become fewer over time. SoC
code is getting smaller and gets better abstracted from the drivers, so
chances are good.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
