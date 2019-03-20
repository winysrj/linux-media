Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65BEC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFB612184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbfCTO1x (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:27:53 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:41139 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfCTO1w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:27:52 -0400
X-Originating-IP: 90.88.33.153
Received: from aptenodytes (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 835162000C;
        Wed, 20 Mar 2019 14:27:49 +0000 (UTC)
Message-ID: <ba12d2480e357a37e6110c3ce907c4beea48cc35.camel@bootlin.com>
Subject: Re: [RFC PATCH 05/20] drm: Replace instances of drm_format_info by
 drm_get_format_info
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Date:   Wed, 20 Mar 2019 15:27:49 +0100
In-Reply-To: <2c4461e827cf9a64326962094f7420bfafc5e13b.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
         <2c4461e827cf9a64326962094f7420bfafc5e13b.1553032382.git-series.maxime.ripard@bootlin.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.0 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

Le mardi 19 mars 2019 à 22:57 +0100, Maxime Ripard a écrit :
> drm_get_format_info directly calls into drm_format_info, but takes directly
> a struct drm_mode_fb_cmd2 pointer, instead of the fourcc directly. It's
> shorter to not dereference it, and we can customise the behaviour at the
> driver level if we want to, so let's switch to it where it makes sense.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Makes good sense to me!

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>  drivers/gpu/drm/gma500/framebuffer.c | 2 +-
>  drivers/gpu/drm/omapdrm/omap_fb.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
> index c934b3df1f81..46f0078f7a91 100644
> --- a/drivers/gpu/drm/gma500/framebuffer.c
> +++ b/drivers/gpu/drm/gma500/framebuffer.c
> @@ -232,7 +232,7 @@ static int psb_framebuffer_init(struct drm_device *dev,
>  	 * Reject unknown formats, YUV formats, and formats with more than
>  	 * 4 bytes per pixel.
>  	 */
> -	info = drm_format_info(mode_cmd->pixel_format);
> +	info = drm_get_format_info(dev, mode_cmd);
>  	if (!info || !info->depth || info->cpp[0] > 4)
>  		return -EINVAL;
>  
> diff --git a/drivers/gpu/drm/omapdrm/omap_fb.c b/drivers/gpu/drm/omapdrm/omap_fb.c
> index cfb641363a32..6557b2d6e16e 100644
> --- a/drivers/gpu/drm/omapdrm/omap_fb.c
> +++ b/drivers/gpu/drm/omapdrm/omap_fb.c
> @@ -339,7 +339,7 @@ struct drm_framebuffer *omap_framebuffer_init(struct drm_device *dev,
>  			dev, mode_cmd, mode_cmd->width, mode_cmd->height,
>  			(char *)&mode_cmd->pixel_format);
>  
> -	format = drm_format_info(mode_cmd->pixel_format);
> +	format = drm_get_format_info(dev, mode_cmd);
>  
>  	for (i = 0; i < ARRAY_SIZE(formats); i++) {
>  		if (formats[i] == mode_cmd->pixel_format)
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

