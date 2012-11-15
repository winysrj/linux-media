Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43055 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2KOKB7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Nov 2012 05:01:59 -0500
Date: Thu, 15 Nov 2012 11:01:49 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v10 6/6] drm_modes: add of_videomode helpers
Message-ID: <20121115100149.GA1963@pengutronix.de>
References: <1352971437-29877-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352971437-29877-7-git-send-email-s.trumtrar@pengutronix.de>
 <20121115095848.GA31538@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121115095848.GA31538@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 15, 2012 at 10:58:49AM +0100, Thierry Reding wrote:
> On Thu, Nov 15, 2012 at 10:23:57AM +0100, Steffen Trumtrar wrote:
> [...]
> > +int of_get_drm_display_mode(struct device_node *np,
> > +			    struct drm_display_mode *dmode, unsigned int index)
> > +{
> > +	struct videomode vm;
> > +	int ret;
> > +
> > +	ret = of_get_videomode(np, &vm, index);
> > +	if (ret)
> > +		return ret;
> > +
> > +	display_mode_from_videomode(&vm, dmode);
> 
> This function is now called drm_display_mode_from_videomode().
> 
Well, can't argue with that. You are right.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
