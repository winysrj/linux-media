Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34217 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab2KMM7i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Nov 2012 07:59:38 -0500
Date: Tue, 13 Nov 2012 13:59:27 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>, kernel@pengutronix.de
Subject: Re: [PATCH v8 2/6] video: add of helper for videomode
Message-ID: <20121113125927.GD27797@pengutronix.de>
References: <1352734626-27412-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352734626-27412-3-git-send-email-s.trumtrar@pengutronix.de>
 <50A15EAC.9030608@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A15EAC.9030608@wwwdotorg.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 12, 2012 at 01:40:12PM -0700, Stephen Warren wrote:
> On 11/12/2012 08:37 AM, Steffen Trumtrar wrote:
> > This adds support for reading display timings from DT or/and convert one of those
> > timings to a videomode.
> > The of_display_timing implementation supports multiple children where each
> > property can have up to 3 values. All children are read into an array, that
> > can be queried.
> > of_get_videomode converts exactly one of that timings to a struct videomode.
> 
> > diff --git a/Documentation/devicetree/bindings/video/display-timings.txt b/Documentation/devicetree/bindings/video/display-timings.txt
> 
> The device tree bindings look reasonable to me, so,
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> 

Thanks,

Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
