Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58457 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab2KVT0C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:26:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
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
Date: Thu, 22 Nov 2012 09:50:10 +0100
Message-ID: <1554720.pFHYnMF1G4@avalon>
In-Reply-To: <20121122062000.GW10369@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <96696218.4l3uYOulV3@avalon> <20121122062000.GW10369@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sascha,

On Thursday 22 November 2012 07:20:00 Sascha Hauer wrote:
> On Wed, Nov 21, 2012 at 11:02:44PM +0100, Laurent Pinchart wrote:
> > Hi Steffen,
> > 
> > > +
> > > +	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
> > > +		 vm->hsync_len;
> > > +	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
> > > +		 vm->vsync_len;
> > > +	fbmode->refresh = (vm->pixelclock * 1000) / (htotal * vtotal);
> > 
> > This will fail if vm->pixelclock >= ((1 << 32) / 1000). The easiest
> > solution is probably to use 64-bit computation.
> 
> You have displays with a pixelclock > 4GHz?

vm->pixelclock is expressed in Hz. vm->pixelclock * 1000 will thus overflow if 
the clock frequency is >= ~4.3 MHz. I have displays with a clock frequency 
higher than that :-)

-- 
Regards,

Laurent Pinchart

