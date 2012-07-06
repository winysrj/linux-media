Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54783 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GFHzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 03:55:49 -0400
Date: Fri, 6 Jul 2012 09:55:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, fabio.estevam@freescale.com,
	laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	mchehab@infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH] [v2] i.MX27: Fix emma-prp clocks in mx2_camera.c
Message-ID: <20120706075544.GF30009@pengutronix.de>
References: <1341558791-9928-1-git-send-email-javier.martin@vista-silicon.com>
 <20120706073414.GD30009@pengutronix.de>
 <CACKLOr3jUA+2adSk=B=QvtAUdncP9jevW=svOCz6+z0tGPe2WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACKLOr3jUA+2adSk=B=QvtAUdncP9jevW=svOCz6+z0tGPe2WQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 06, 2012 at 09:46:46AM +0200, javier Martin wrote:
> On 6 July 2012 09:34, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Fri, Jul 06, 2012 at 09:13:11AM +0200, Javier Martin wrote:
> >>       if (cpu_is_mx27()) {
> >>               free_irq(pcdev->irq_emma, pcdev);
> >> -             clk_disable(pcdev->clk_emma);
> >> -             clk_put(pcdev->clk_emma);
> >> +             clk_disable_unprepare(pcdev->clk_emma_ipg);
> >> +             clk_disable_unprepare(pcdev->clk_emma_ahb);
> >
> > The clk_disable_unprepare is inside a cpu_is_mx27() which seems correct.
> > Shouldn't the corresponding clk_get be in cpu_is_mx27() aswell?
> 
> Yes indeed. Should I fix it in a new version of this patch or should I
> send another one instead?

Another version of this patch should be fine.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
