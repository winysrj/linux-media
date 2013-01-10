Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:32939 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3AJCv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 21:51:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130109201541.GB4780@pengutronix.de>
References: <1355850256-16135-1-git-send-email-s.trumtrar@pengutronix.de> <20130109201541.GB4780@pengutronix.de>
From: Leela Krishna Amudala <leelakrishna.a@gmail.com>
Date: Thu, 10 Jan 2013 08:21:36 +0530
Message-ID: <CAL1wa8eQfr4ZV7zjCKp-kpBTMBzEjY_fj+UtDAy-auJXTCJghQ@mail.gmail.com>
Subject: Re: [PATCHv16 0/7] of: add display helper
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>,
	Rob Clark <robdclark@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen,

On Thu, Jan 10, 2013 at 1:45 AM, Steffen Trumtrar
<s.trumtrar@pengutronix.de> wrote:
>
> On Tue, Dec 18, 2012 at 06:04:09PM +0100, Steffen Trumtrar wrote:
> > Hi!
> >
> > Finally, right in time before the end of the world on friday, v16 of the
> > display helpers.
> >
>
> So, any more criticism on the series? Any takers for the series as is?
> I guess it could be merged via the fbdev-tree if David Airlie can agree
> to the DRM patches ?! Does that sound about right?
>
> I think the series was tested at least with
>         - imx6q: sabrelite, sabresd
>         - imx53: tqma53/mba53
>         - omap: DA850 EVM, AM335x EVM, EVM-SK
>
> I don't know what Laurent Pinchart, Marek Vasut and Leela Krishna Amudala
> are using.

I tested V16 patches with Exynos: smdk5250 board and it works fine for me.

> Those are the people I know from the top of my head, that use
> or at least did use the patches in one of its iterations. If I forgot
> anyone, please speak up and possibly add your new HW to the list of tested
> devices.
>
> Thanks,
> Steffen
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
