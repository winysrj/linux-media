Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A074C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC6682184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:27:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfCTO1C (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:27:02 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:41307 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfCTO1C (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:27:02 -0400
X-Originating-IP: 90.88.33.153
Received: from aptenodytes (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id A876C1BF203;
        Wed, 20 Mar 2019 14:26:57 +0000 (UTC)
Message-ID: <1dcd84b1ece0a0d063bcd5142297b58d43ce0c94.camel@bootlin.com>
Subject: Re: [RFC PATCH 04/20] drm/fourcc: Pass the format_info pointer to
 drm_format_plane_width/height
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
Date:   Wed, 20 Mar 2019 15:26:57 +0100
In-Reply-To: <ec00e0a01a09e1711fda190cfcb2ed6a0fbca6eb.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
         <ec00e0a01a09e1711fda190cfcb2ed6a0fbca6eb.1553032382.git-series.maxime.ripard@bootlin.com>
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
> So far, the drm_format_plane_height/width functions were operating on the
> format's fourcc and was doing a lookup to retrieve the drm_format_info
> structure and return the cpp.
> 
> However, this is inefficient since in most cases, we will have the
> drm_format_info pointer already available so we shouldn't have to perform a
> new lookup. Some drm_fourcc functions also already operate on the
> drm_format_info pointer for that reason, so the API is quite inconsistent
> there.

Same comment as for the previous patch, I think having a
drm_format_info prefix and switching to an inline helper would make
good sense.

Cheers,

Paul

> Let's follow the latter pattern and remove the extra lookup while being a
> bit more consistent.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/gpu/drm/drm_fourcc.c          | 16 ++++++----------
>  drivers/gpu/drm/meson/meson_overlay.c |  6 +++---
>  include/drm/drm_fourcc.h              |  6 ++++--
>  3 files changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
> index d8ada4cb689e..57389b9753b2 100644
> --- a/drivers/gpu/drm/drm_fourcc.c
> +++ b/drivers/gpu/drm/drm_fourcc.c
> @@ -325,17 +325,15 @@ EXPORT_SYMBOL(drm_format_plane_cpp);
>  /**
>   * drm_format_plane_width - width of the plane given the first plane
>   * @width: width of the first plane
> - * @format: pixel format
> + * @format: pixel format info
>   * @plane: plane index
>   *
>   * Returns:
>   * The width of @plane, given that the width of the first plane is @width.
>   */
> -int drm_format_plane_width(int width, uint32_t format, int plane)
> +int drm_format_plane_width(int width, const struct drm_format_info *info,
> +			   int plane)
>  {
> -	const struct drm_format_info *info;
> -
> -	info = drm_format_info(format);
>  	if (!info || plane >= info->num_planes)
>  		return 0;
>  
> @@ -349,17 +347,15 @@ EXPORT_SYMBOL(drm_format_plane_width);
>  /**
>   * drm_format_plane_height - height of the plane given the first plane
>   * @height: height of the first plane
> - * @format: pixel format
> + * @format: pixel format info
>   * @plane: plane index
>   *
>   * Returns:
>   * The height of @plane, given that the height of the first plane is @height.
>   */
> -int drm_format_plane_height(int height, uint32_t format, int plane)
> +int drm_format_plane_height(int height, const struct drm_format_info *info,
> +			    int plane)
>  {
> -	const struct drm_format_info *info;
> -
> -	info = drm_format_info(format);
>  	if (!info || plane >= info->num_planes)
>  		return 0;
>  
> diff --git a/drivers/gpu/drm/meson/meson_overlay.c b/drivers/gpu/drm/meson/meson_overlay.c
> index 8ff15d01a8f9..6987c15b6ab9 100644
> --- a/drivers/gpu/drm/meson/meson_overlay.c
> +++ b/drivers/gpu/drm/meson/meson_overlay.c
> @@ -475,7 +475,7 @@ static void meson_overlay_atomic_update(struct drm_plane *plane,
>  		priv->viu.vd1_stride2 = fb->pitches[2];
>  		priv->viu.vd1_height2 =
>  			drm_format_plane_height(fb->height,
> -						fb->format->format, 2);
> +						fb->format, 2);
>  		DRM_DEBUG("plane 2 addr 0x%x stride %d height %d\n",
>  			 priv->viu.vd1_addr2,
>  			 priv->viu.vd1_stride2,
> @@ -487,7 +487,7 @@ static void meson_overlay_atomic_update(struct drm_plane *plane,
>  		priv->viu.vd1_stride1 = fb->pitches[1];
>  		priv->viu.vd1_height1 =
>  			drm_format_plane_height(fb->height,
> -						fb->format->format, 1);
> +						fb->format, 1);
>  		DRM_DEBUG("plane 1 addr 0x%x stride %d height %d\n",
>  			 priv->viu.vd1_addr1,
>  			 priv->viu.vd1_stride1,
> @@ -499,7 +499,7 @@ static void meson_overlay_atomic_update(struct drm_plane *plane,
>  		priv->viu.vd1_stride0 = fb->pitches[0];
>  		priv->viu.vd1_height0 =
>  			drm_format_plane_height(fb->height,
> -						fb->format->format, 0);
> +						fb->format, 0);
>  		DRM_DEBUG("plane 0 addr 0x%x stride %d height %d\n",
>  			 priv->viu.vd1_addr0,
>  			 priv->viu.vd1_stride0,
> diff --git a/include/drm/drm_fourcc.h b/include/drm/drm_fourcc.h
> index 97a58f3e7462..2291f2618211 100644
> --- a/include/drm/drm_fourcc.h
> +++ b/include/drm/drm_fourcc.h
> @@ -269,8 +269,10 @@ uint32_t drm_mode_legacy_fb_format(uint32_t bpp, uint32_t depth);
>  uint32_t drm_driver_legacy_fb_format(struct drm_device *dev,
>  				     uint32_t bpp, uint32_t depth);
>  int drm_format_plane_cpp(const struct drm_format_info *info, int plane);
> -int drm_format_plane_width(int width, uint32_t format, int plane);
> -int drm_format_plane_height(int height, uint32_t format, int plane);
> +int drm_format_plane_width(int width, const struct drm_format_info *info,
> +			   int plane);
> +int drm_format_plane_height(int height, const struct drm_format_info *info,
> +			    int plane);
>  unsigned int drm_format_info_block_width(const struct drm_format_info *info,
>  					 int plane);
>  unsigned int drm_format_info_block_height(const struct drm_format_info *info,
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

