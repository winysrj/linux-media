Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52076 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301Ab3AITkC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 14:40:02 -0500
Date: Wed, 9 Jan 2013 20:39:53 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Marek Vasut <marex@denx.de>
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
	Rob Clark <robdclark@gmail.com>,
	Leela Krishna Amudala <leelakrishna.a@gmail.com>
Subject: Re: [PATCHv16 0/7] of: add display helper
Message-ID: <20130109193953.GA4780@pengutronix.de>
References: <1355850256-16135-1-git-send-email-s.trumtrar@pengutronix.de>
 <201301092012.01985.marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201301092012.01985.marex@denx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Wed, Jan 09, 2013 at 08:12:01PM +0100, Marek Vasut wrote:
> Dear Steffen Trumtrar,
> 
> I tested this on 3.8-rc1 (next 20130103) with the imx drm driver. After adding 
> the following piece of code (quick hack), this works just fine. Thanks!
> 
> diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-
> drm/parallel-display.c
> index a8064fc..e45002a 100644
> --- a/drivers/staging/imx-drm/parallel-display.c
> +++ b/drivers/staging/imx-drm/parallel-display.c
> @@ -57,6 +57,7 @@ static void imx_pd_connector_destroy(struct drm_connector 
> *connector)
>  static int imx_pd_connector_get_modes(struct drm_connector *connector)
>  {
>         struct imx_parallel_display *imxpd = con_to_imxpd(connector);
> +       struct device_node *np = imxpd->dev->of_node;
>         int num_modes = 0;
>  
>         if (imxpd->edid) {
> @@ -72,6 +73,15 @@ static int imx_pd_connector_get_modes(struct drm_connector 
> *connector)
>                 num_modes++;
>         }
>  
> +       if (np) {
> +               struct drm_display_mode *mode = drm_mode_create(connector->dev);
> +               of_get_drm_display_mode(np, &imxpd->mode, 0);
> +               drm_mode_copy(mode, &imxpd->mode);
> +               mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED,
> +               drm_mode_probed_add(connector, mode);
> +               num_modes++;
> +       }
> +
>         return num_modes;
>  }
> 

Nice! I haven't tried the parallel display, but I think Philipp Zabel might
already have a patch for it. If not, I will definitly keep your patch in my
topic branch.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
