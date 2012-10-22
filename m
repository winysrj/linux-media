Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35713 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2JVHfT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 03:35:19 -0400
Date: Mon, 22 Oct 2012 09:35:10 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: devicetree-discuss@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Rob Herring <robherring2@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
Message-ID: <20121022073510.GA12967@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
 <1349373560-11128-3-git-send-email-s.trumtrar@pengutronix.de>
 <20121020110412.GD12545@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121020110412.GD12545@avionic-0098.mockup.avionic-design.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 20, 2012 at 01:04:12PM +0200, Thierry Reding wrote:
> On Thu, Oct 04, 2012 at 07:59:20PM +0200, Steffen Trumtrar wrote:
> [...]
> > diff --git a/drivers/of/of_videomode.c b/drivers/of/of_videomode.c
> [...]
> > +#if defined(CONFIG_DRM)
> 
> This should be:
> 
> 	#if IS_ENABLED(CONFIG_DRM)
> 
> or the code below won't be included if DRM is built as a module. But see
> my other replies as to how we can probably handle this better by moving
> this into the DRM subsystem.
> 

I already started with moving...now I only need some time to finish with it.

> > +int videomode_to_display_mode(struct videomode *vm, struct drm_display_mode *dmode)
> > +{
> > +	memset(dmode, 0, sizeof(*dmode));
> 
> It appears the usual method to obtain a drm_display_mode to allocate it
> using drm_mode_create(), which will allocate it and associate it with
> the struct drm_device.
> 
> Now, if you do a memset() on the structure you'll overwrite a number of
> fields that have previously been initialized and are actually required
> to get everything cleaned up properly later on.
> 
> So I think we should remove the call to memset().
> 

I was not aware of that. The memset has to go than, of course.

> > +int of_get_fb_videomode(struct device_node *np, struct fb_videomode *fb,
> > +			int index)
> > +{
> [...]
> > +}
> > +EXPORT_SYMBOL_GPL(of_get_drm_display_mode);
> 
> This should be:
> 
> 	EXPORT_SYMBOL_GPL(of_get_fb_videomode);

Oops.

Regrads,

Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
