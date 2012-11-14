Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34434 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2KNOSP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 09:18:15 -0500
Date: Wed, 14 Nov 2012 15:18:06 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v9 5/6] drm_modes: add videomode helpers
Message-ID: <20121114141806.GE18579@pengutronix.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-6-git-send-email-s.trumtrar@pengutronix.de>
 <20121114124944.GF2803@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114124944.GF2803@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2012 at 01:49:44PM +0100, Thierry Reding wrote:
> On Wed, Nov 14, 2012 at 12:43:22PM +0100, Steffen Trumtrar wrote:
> [...]
> > diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
> [...]
> > @@ -504,6 +505,41 @@ drm_gtf_mode(struct drm_device *dev, int hdisplay, int vdisplay, int vrefresh,
> >  }
> >  EXPORT_SYMBOL(drm_gtf_mode);
> >  
> > +#if IS_ENABLED(CONFIG_VIDEOMODE)
> > +int display_mode_from_videomode(struct videomode *vm, struct drm_display_mode *dmode)
> 
> Given that this is still a DRM core function, maybe it should get a drm_
> prefix? Also the line is too long, so you may want to wrap the argument
> list.
> 
> Thierry

Yes, seems to fit better to the rest of the file.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
