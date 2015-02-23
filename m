Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49126 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbBWOtD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 09:49:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
	Benoit Parrot <bparrot@ti.com>,
	Darren Etheridge <detheridge@ti.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	David Airlie <airlied@linux.ie>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH v8 1/3] of: Decrement refcount of previous endpoint in of_graph_get_next_endpoint
Date: Mon, 23 Feb 2015 16:50 +0200
Message-ID: <5913850.Ssk1TlHgDf@avalon>
In-Reply-To: <1424688846-10909-2-git-send-email-p.zabel@pengutronix.de>
References: <1424688846-10909-1-git-send-email-p.zabel@pengutronix.de> <1424688846-10909-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

Benoit, please see below for a possible issue in the am437x-vpfe driver.

On Monday 23 February 2015 11:54:04 Philipp Zabel wrote:
> Decrementing the reference count of the previous endpoint node allows to
> use the of_graph_get_next_endpoint function in a for_each_... style macro.
> All current users of this function that pass a non-NULL prev parameter
> (that is, soc_camera and imx-drm) are changed to not decrement the passed
> prev argument's refcount themselves.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Acked-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> ---
> Changes since v7:
>  - Rebased onto v4.0-rc1
>  - Added fix for am437x-vpfe
> ---
>  drivers/coresight/of_coresight.c                  | 13 ++-----------
>  drivers/gpu/drm/imx/imx-drm-core.c                | 11 +----------
>  drivers/gpu/drm/rcar-du/rcar_du_kms.c             | 15 ++++-----------
>  drivers/media/platform/am437x/am437x-vpfe.c       |  1 -
>  drivers/media/platform/soc_camera/soc_camera.c    |  3 ++-
>  drivers/of/base.c                                 |  9 +--------
>  drivers/video/fbdev/omap2/dss/omapdss-boot-init.c |  7 +------
>  7 files changed, 11 insertions(+), 48 deletions(-)

[snip]

> diff --git a/drivers/media/platform/am437x/am437x-vpfe.c
> b/drivers/media/platform/am437x/am437x-vpfe.c index 56a5cb0..0d07fca 100644
> --- a/drivers/media/platform/am437x/am437x-vpfe.c
> +++ b/drivers/media/platform/am437x/am437x-vpfe.c
> @@ -2504,7 +2504,6 @@ vpfe_get_pdata(struct platform_device *pdev)
>  					     GFP_KERNEL);
>  		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_OF;
>  		pdata->asd[i]->match.of.node = rem;
> -		of_node_put(endpoint);
>  		of_node_put(rem);
>  	}

For the am47x-vpfe driver,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Benoit, there seems to be a refcount issue with rem. The node pointer is 
assigned to pdata->asd[i]->match.of.node, which should require a reference, 
but you then call of_node_put(rem), releasing the only reference held. Isn't 
that a problem ?

Furthermore, on the next iteration, if an error occurs the goto done will 
result in of_node_put(rem) being called again, releasing a reference that you 
don't hold. I've sent a patch to fix that.

-- 
Regards,

Laurent Pinchart

