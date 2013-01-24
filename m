Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51321 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3AXH4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 02:56:55 -0500
Date: Thu, 24 Jan 2013 08:56:45 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Dave Airlie <airlied@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>,
	devicetree-discuss@lists.ozlabs.org,
	David Airlie <airlied@linux.ie>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>,
	"Mohammed, Afzal" <afzal@ti.com>, kernel@pengutronix.de
Subject: Re: [PATCH v16 RESEND 0/7] of: add display helper
Message-ID: <20130124075645.GA12862@pengutronix.de>
References: <1358766482-6275-1-git-send-email-s.trumtrar@pengutronix.de>
 <CAF6AEGvFNA1gc_5XWqL_baEnn8DTn0R-xqui034rg3Eo-V_6Qw@mail.gmail.com>
 <20130123091202.GA11828@pengutronix.de>
 <CAPM=9txadRcm4j7_GryvxgosEhF8S3-1rGxqR_bw8UXMaoVWug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9txadRcm4j7_GryvxgosEhF8S3-1rGxqR_bw8UXMaoVWug@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 24, 2013 at 10:15:54AM +1000, Dave Airlie wrote:
> >> > Hi!
> >> >
> >> > There was still no maintainer, that commented, ack'd, nack'd, apply'd the
> >> > series. So, this is just a resend.
> >> > The patches were tested with:
> >> >
> >> >         - v15 on Tegra by Thierry
> >> >         - sh-mobile-lcdcfb by Laurent
> >> >         - MX53QSB by Marek
> >> >         - Exynos: smdk5250 by Leela
> >> >         - AM335X EVM & AM335X EVM-SK by Afzal
> >> >         - imx6q: sabrelite, sabresd by Philipp and me
> >> >         - imx53: tqma53/mba53 by me
> >>
> >>
> >> btw, you can add my tested-by for this series..  I've been using them
> >> for the tilcdc lcd-panel output driver support.
> >>
> >
> > Thanks. The more drivers the merrier ;-)
> >
> 
> I'll probably merge these via my tree for lack of anyone else doing
> it. I just don't want to end up as the fbdev maintainer by default,

\o/ very good to hear. Thanks.

> maybe if we move the console stuff out of drivers/video to somewhere

Okay. That confused me for a second, but it doesn't seem to be directed at
me *phew*.

> else I'd be willing to look after it, but the thought of maintaining
> fbdev drivers would drive me to a liver transplant.
> 
> Dave.
> 

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
