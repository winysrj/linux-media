Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46599 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab2JaNRB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 09:17:01 -0400
Date: Wed, 31 Oct 2012 14:16:52 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, g.liakhovetski@gmx.de,
	kernel@pengutronix.de, gcembed@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/2] ARM: clk-imx27: Add missing clock for mx2-camera
Message-ID: <20121031131652.GM1641@pengutronix.de>
References: <1351598606-8485-1-git-send-email-fabio.estevam@freescale.com>
 <20121031095632.536d9362@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031095632.536d9362@infradead.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Oct 31, 2012 at 09:56:32AM -0200, Mauro Carvalho Chehab wrote:
> Em Tue, 30 Oct 2012 10:03:25 -0200
> Fabio Estevam <fabio.estevam@freescale.com> escreveu:
> 
> > During the clock conversion for mx27 the "per4_gate" clock was missed to get
> > registered as a dependency of mx2-camera driver.
> > 
> > In the old mx27 clock driver we used to have:
> > 
> > DEFINE_CLOCK1(csi_clk, 0, NULL, 0, parent, &csi_clk1, &per4_clk);
> > 
> > ,so does the same in the new clock driver
> > 
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> As it seems that those patches depend on some patches at the arm tree,
> the better is to merge them via -arm tree.

Quoting yourself:

> Forgot to comment: as patch 2 relies on this change, the better, IMHO, is
> to send both via the same tree. If you decide to do so, please get arm
> maintainer's ack, instead, and we can merge both via my tree.

That's why Fabio resent these patches with my Ack. You are free to take
these.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
