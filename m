Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48613 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab2KVTUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:20:00 -0500
Date: Thu, 22 Nov 2012 07:20:00 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 3/6] fbmon: add videomode helpers
Message-ID: <20121122062000.GW10369@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-4-git-send-email-s.trumtrar@pengutronix.de>
 <96696218.4l3uYOulV3@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96696218.4l3uYOulV3@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Wed, Nov 21, 2012 at 11:02:44PM +0100, Laurent Pinchart wrote:
> Hi Steffen,
> 
> > +
> > +	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
> > +		 vm->hsync_len;
> > +	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
> > +		 vm->vsync_len;
> > +	fbmode->refresh = (vm->pixelclock * 1000) / (htotal * vtotal);
> 
> This will fail if vm->pixelclock >= ((1 << 32) / 1000). The easiest solution 
> is probably to use 64-bit computation.

You have displays with a pixelclock > 4GHz?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
