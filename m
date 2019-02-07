Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA9DC282CC
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 08:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFA8920818
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 08:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbfBGIow (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 03:44:52 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:58309 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbfBGIov (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 03:44:51 -0500
X-Originating-IP: 90.88.22.177
Received: from aptenodytes (aaubervilliers-681-1-80-177.w90-88.abo.wanadoo.fr [90.88.22.177])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 2B4181BF20B;
        Thu,  7 Feb 2019 08:44:47 +0000 (UTC)
Message-ID: <1d6fb3d0f97880d829a88b6da5aa71456f50507f.camel@bootlin.com>
Subject: Re: [PATCH v5 6/9] drm/bridge: cdns: Separate DSI and D-PHY
 configuration
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Cc:     Rafal Ciepiela <rafalc@cadence.com>,
        Krzysztof Witos <kwitos@cadence.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chen-Yu Tsai <wens@csie.org>,
        Sean Paul <seanpaul@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Date:   Thu, 07 Feb 2019 09:44:46 +0100
In-Reply-To: <0b3bea44e05745b65c23af7926ca546bc80a1bcc.1548085432.git-series.maxime.ripard@bootlin.com>
References: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
         <0b3bea44e05745b65c23af7926ca546bc80a1bcc.1548085432.git-series.maxime.ripard@bootlin.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Mon, 2019-01-21 at 16:45 +0100, Maxime Ripard wrote:
> The current configuration of the DSI bridge and its associated D-PHY is
> intertwined. In order to ease the future conversion to the phy framework
> for the D-PHY part, let's split the configuration in two.

See below about a silly mistake when refactoring. Looks good otherwise,
so with that fixed:

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/gpu/drm/bridge/cdns-dsi.c | 101 ++++++++++++++++++++++---------
>  1 file changed, 73 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
> index ce9496d13986..796874e76308 100644
> --- a/drivers/gpu/drm/bridge/cdns-dsi.c
> +++ b/drivers/gpu/drm/bridge/cdns-dsi.c
> @@ -545,6 +545,15 @@ bridge_to_cdns_dsi_input(struct drm_bridge *bridge)
>  	return container_of(bridge, struct cdns_dsi_input, bridge);
>  }
>  
> +static unsigned int mode_to_dpi_hfp(const struct drm_display_mode *mode,
> +				    bool mode_valid_check)
> +{
> +	if (mode_valid_check)
> +		return mode->hsync_start - mode->hdisplay;
> +
> +	return mode->crtc_hsync_start - mode->crtc_hdisplay;
> +}
> +
>  static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
>  				     struct cdns_dphy_cfg *cfg,
>  				     unsigned int dpi_htotal,
> @@ -731,14 +740,12 @@ static unsigned int dpi_to_dsi_timing(unsigned int dpi_timing,
>  static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
>  			     const struct drm_display_mode *mode,
>  			     struct cdns_dsi_cfg *dsi_cfg,
> -			     struct cdns_dphy_cfg *dphy_cfg,
>  			     bool mode_valid_check)
>  {
> -	unsigned long dsi_htotal = 0, dsi_hss_hsa_hse_hbp = 0;
>  	struct cdns_dsi_output *output = &dsi->output;
> -	unsigned int dsi_hfp_ext = 0, dpi_hfp, tmp;
> +	unsigned int tmp;
>  	bool sync_pulse = false;
> -	int bpp, nlanes, ret;
> +	int bpp, nlanes;
>  
>  	memset(dsi_cfg, 0, sizeof(*dsi_cfg));
>  
> @@ -757,8 +764,6 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
>  		       mode->crtc_hsync_end : mode->crtc_hsync_start);
>  
>  	dsi_cfg->hbp = dpi_to_dsi_timing(tmp, bpp, DSI_HBP_FRAME_OVERHEAD);
> -	dsi_htotal += dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
> -	dsi_hss_hsa_hse_hbp += dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
>  
>  	if (sync_pulse) {
>  		if (mode_valid_check)
> @@ -768,49 +773,91 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
>  
>  		dsi_cfg->hsa = dpi_to_dsi_timing(tmp, bpp,
>  						 DSI_HSA_FRAME_OVERHEAD);
> -		dsi_htotal += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
> -		dsi_hss_hsa_hse_hbp += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
>  	}
>  
>  	dsi_cfg->hact = dpi_to_dsi_timing(mode_valid_check ?
>  					  mode->hdisplay : mode->crtc_hdisplay,
>  					  bpp, 0);
> -	dsi_htotal += dsi_cfg->hact;
> +	dsi_cfg->hfp = dpi_to_dsi_timing(mode_to_dpi_hfp(mode, mode_valid_check),
> +					 bpp, DSI_HFP_FRAME_OVERHEAD);
>  
> -	if (mode_valid_check)
> -		dpi_hfp = mode->hsync_start - mode->hdisplay;
> -	else
> -		dpi_hfp = mode->crtc_hsync_start - mode->crtc_hdisplay;
> +	return 0;
> +}
> +
> +static int cdns_dphy_validate(struct cdns_dsi *dsi,
> +			      struct cdns_dsi_cfg *dsi_cfg,
> +			      struct cdns_dphy_cfg *dphy_cfg,
> +			      const struct drm_display_mode *mode,
> +			      bool mode_valid_check)
> +{
> +	struct cdns_dsi_output *output = &dsi->output;
> +	unsigned long dsi_htotal;
> +	unsigned int dsi_hfp_ext = 0;
> +
> +	int ret;
> +
> +	dsi_htotal = dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
> +	if (output->dev->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
> +		dsi_htotal += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
>  
> -	dsi_cfg->hfp = dpi_to_dsi_timing(dpi_hfp, bpp, DSI_HFP_FRAME_OVERHEAD);
> +	dsi_htotal += dsi_cfg->hact;
>  	dsi_htotal += dsi_cfg->hfp + DSI_HFP_FRAME_OVERHEAD;
>  
>  	if (mode_valid_check)
>  		ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
> -						mode->htotal, bpp,
> +						mode->htotal,
>  						mode->clock * 1000,
> -						dsi_htotal, nlanes,
> +						mipi_dsi_pixel_format_to_bpp(output->dev->format),

The bpp argument sits between htotal and clock, this puts it after
clock which looks incorrect.

Cheers,

Paul

> +						dsi_htotal,
> +						output->dev->lanes,
>  						&dsi_hfp_ext);
>  	else
>  		ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
> -						mode->crtc_htotal, bpp,
> +						mode->crtc_htotal,
> +						mipi_dsi_pixel_format_to_bpp(output->dev->format),
>  						mode->crtc_clock * 1000,
> -						dsi_htotal, nlanes,
> +						dsi_htotal,
> +						output->dev->lanes,
>  						&dsi_hfp_ext);
> -
>  	if (ret)
>  		return ret;
>  
>  	dsi_cfg->hfp += dsi_hfp_ext;
> -	dsi_htotal += dsi_hfp_ext;
> -	dsi_cfg->htotal = dsi_htotal;
> +	dsi_cfg->htotal = dsi_htotal + dsi_hfp_ext;
> +
> +	return 0;
> +}
> +
> +static int cdns_dsi_check_conf(struct cdns_dsi *dsi,
> +			       const struct drm_display_mode *mode,
> +			       struct cdns_dsi_cfg *dsi_cfg,
> +			       struct cdns_dphy_cfg *dphy_cfg,
> +			       bool mode_valid_check)
> +{
> +	struct cdns_dsi_output *output = &dsi->output;
> +	unsigned long dsi_hss_hsa_hse_hbp;
> +	unsigned int nlanes = output->dev->lanes;
> +	int ret;
> +
> +	ret = cdns_dsi_mode2cfg(dsi, mode, dsi_cfg, mode_valid_check);
> +	if (ret)
> +		return ret;
> +
> +	ret = cdns_dphy_validate(dsi, dsi_cfg, dphy_cfg, mode, mode_valid_check);
> +	if (ret)
> +		return ret;
> +
> +	dsi_hss_hsa_hse_hbp = dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
> +	if (output->dev->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
> +		dsi_hss_hsa_hse_hbp += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
>  
>  	/*
>  	 * Make sure DPI(HFP) > DSI(HSS+HSA+HSE+HBP) to guarantee that the FIFO
>  	 * is empty before we start a receiving a new line on the DPI
>  	 * interface.
>  	 */
> -	if ((u64)dphy_cfg->lane_bps * dpi_hfp * nlanes <
> +	if ((u64)dphy_cfg->lane_bps *
> +	    mode_to_dpi_hfp(mode, mode_valid_check) * nlanes <
>  	    (u64)dsi_hss_hsa_hse_hbp *
>  	    (mode_valid_check ? mode->clock : mode->crtc_clock) * 1000)
>  		return -EINVAL;
> @@ -842,7 +889,7 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
>  	struct cdns_dsi_output *output = &dsi->output;
>  	struct cdns_dphy_cfg dphy_cfg;
>  	struct cdns_dsi_cfg dsi_cfg;
> -	int bpp, nlanes, ret;
> +	int bpp, ret;
>  
>  	/*
>  	 * VFP_DSI should be less than VFP_DPI and VFP_DSI should be at
> @@ -860,11 +907,9 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
>  	if ((mode->hdisplay * bpp) % 32)
>  		return MODE_H_ILLEGAL;
>  
> -	nlanes = output->dev->lanes;
> -
> -	ret = cdns_dsi_mode2cfg(dsi, mode, &dsi_cfg, &dphy_cfg, true);
> +	ret = cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, true);
>  	if (ret)
> -		return MODE_CLOCK_RANGE;
> +		return MODE_BAD;
>  
>  	return MODE_OK;
>  }
> @@ -990,7 +1035,7 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
>  	bpp = mipi_dsi_pixel_format_to_bpp(output->dev->format);
>  	nlanes = output->dev->lanes;
>  
> -	WARN_ON_ONCE(cdns_dsi_mode2cfg(dsi, mode, &dsi_cfg, &dphy_cfg, false));
> +	WARN_ON_ONCE(cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, false));
>  
>  	cdns_dsi_hs_init(dsi, &dphy_cfg);
>  	cdns_dsi_init_link(dsi);
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

