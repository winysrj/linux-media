Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8DBC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 13:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30FFB20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 13:33:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=poorly.run header.i=@poorly.run header.b="EblUqcEo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfAQNdl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:33:41 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33171 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfAQNdl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 08:33:41 -0500
Received: by mail-yb1-f196.google.com with SMTP id o73so3009001ybc.0
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 05:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=poorly.run; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZRARg234UQKVSq41AjrEKQ+5c7yzrHeZ4hw/irAy5ws=;
        b=EblUqcEo9Li6sgfPoEh51lq1Jqin+oA5kUE4ILCnsCbpILc4POXuGzeu30FhnSWnbf
         z152M8Gzb7N0KujOIMTmtk7vfgWlQw4fubXLZVTO54jymDytkpKAsV3v3EElByiriGRK
         MnwYZmoVXORtw6t55zhdD6jI9MJG4IEGe69TPujKF1Xk3VZdRrEwa8jMUCX0rpg2qG9l
         fYUVcu4GODzWIGjKUYb8zihTvNbwrbuE1oNYiX1ZMTEkt07xG6yLSZ4YajqTpfJvbw//
         WSP7RxXwUEqTsw0CyJNkWmB9LaGk6rEScM5ghsJaP4Vs+Y8+Ujp9PCAe2PgTF/lfcMSJ
         X5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZRARg234UQKVSq41AjrEKQ+5c7yzrHeZ4hw/irAy5ws=;
        b=DYEvN03I8u7St8z22b4SDvaXH5R+SLaUOxH3xgtmkecBHzomt0TG2zQvMS3pmVEhAx
         rV0bM+RpZPhU/534YCD8r4gGM7ABvX/4Qn9KATmgj8GHHKb21Oz34yrgtz1EVOjvzqz+
         YVwbwFAe64Wz+54s71pBmqIVewkJhL5ovIoF0nvAswS9o9QKQTsdblkVie9fJ1RP+Aa9
         eKW8x0VhegayIuPoxKfw3jO2s4rI0FqCCN5yEgGgQawIQSWicyuV1Dm18phdTVbe20KQ
         wYCqdyknmvixDe2Z50kQMa/E2cBIyCoL4EiQ3cKSNOulQy0z6oCaSVYAxNLA8bymANg7
         9yaQ==
X-Gm-Message-State: AJcUukfGYR3INgnO00P8J22GemusuihSzdSf8/ORmFI1Emwku8FzgPg/
        oR76NnF6UNiPWIzFTOI14/3h3w==
X-Google-Smtp-Source: ALg8bN596NMzviejCC9J+HUnvsbq2QQ3OqR5yiZfa9Y/HY6VdbT0dLYoeqosR52sBeAmv1/J4kgnsg==
X-Received: by 2002:a25:4cc4:: with SMTP id z187mr9886470yba.121.1547732020037;
        Thu, 17 Jan 2019 05:33:40 -0800 (PST)
Received: from localhost ([2620:0:1013:11:89c6:2139:5435:371d])
        by smtp.gmail.com with ESMTPSA id k64sm656400ywc.56.2019.01.17.05.33.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Jan 2019 05:33:39 -0800 (PST)
Date:   Thu, 17 Jan 2019 08:33:38 -0500
From:   Sean Paul <sean@poorly.run>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
Subject: Re: [PATCH v4 6/9] drm/bridge: cdns: Separate DSI and D-PHY
 configuration
Message-ID: <20190117133338.GA114153@art_vandelay>
References: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
 <df619f059617d85c00efa146884e295240a07ae7.1547026369.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df619f059617d85c00efa146884e295240a07ae7.1547026369.git-series.maxime.ripard@bootlin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 09, 2019 at 10:33:23AM +0100, Maxime Ripard wrote:
> The current configuration of the DSI bridge and its associated D-PHY is
> intertwined. In order to ease the future conversion to the phy framework
> for the D-PHY part, let's split the configuration in two.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/gpu/drm/bridge/cdns-dsi.c | 96 ++++++++++++++++++++++----------
>  1 file changed, 68 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
> index ce9496d13986..3ac6dd524b6d 100644
> --- a/drivers/gpu/drm/bridge/cdns-dsi.c
> +++ b/drivers/gpu/drm/bridge/cdns-dsi.c
> @@ -545,6 +545,11 @@ bridge_to_cdns_dsi_input(struct drm_bridge *bridge)
>  	return container_of(bridge, struct cdns_dsi_input, bridge);
>  }
>  
> +static unsigned int mode_to_dpi_hfp(const struct drm_display_mode *mode)
> +{
> +	return mode->crtc_hsync_start - mode->crtc_hdisplay;
> +}
> +
>  static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
>  				     struct cdns_dphy_cfg *cfg,
>  				     unsigned int dpi_htotal,
> @@ -731,14 +736,12 @@ static unsigned int dpi_to_dsi_timing(unsigned int dpi_timing,
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
> @@ -757,8 +760,6 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
>  		       mode->crtc_hsync_end : mode->crtc_hsync_start);
>  
>  	dsi_cfg->hbp = dpi_to_dsi_timing(tmp, bpp, DSI_HBP_FRAME_OVERHEAD);
> -	dsi_htotal += dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
> -	dsi_hss_hsa_hse_hbp += dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
>  
>  	if (sync_pulse) {
>  		if (mode_valid_check)
> @@ -768,49 +769,90 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
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
> +	dsi_cfg->hfp = dpi_to_dsi_timing(mode_to_dpi_hfp(mode), bpp,
> +					 DSI_HFP_FRAME_OVERHEAD);

We're throwing away the mode_valid_check switch here to flip between crtc_h*
value and h* value. Is that intentional? We're using it above for hdisplay, so
it's a bit confusing.

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
>  
> -	dsi_cfg->hfp = dpi_to_dsi_timing(dpi_hfp, bpp, DSI_HFP_FRAME_OVERHEAD);
> +	dsi_htotal = dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
> +	if (output->dev->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
> +		dsi_htotal += dsi_cfg->hsa + DSI_HSA_FRAME_OVERHEAD;
> +
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
> +	if ((u64)dphy_cfg->lane_bps * mode_to_dpi_hfp(mode) * nlanes <
>  	    (u64)dsi_hss_hsa_hse_hbp *
>  	    (mode_valid_check ? mode->clock : mode->crtc_clock) * 1000)
>  		return -EINVAL;
> @@ -842,7 +884,7 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
>  	struct cdns_dsi_output *output = &dsi->output;
>  	struct cdns_dphy_cfg dphy_cfg;
>  	struct cdns_dsi_cfg dsi_cfg;
> -	int bpp, nlanes, ret;
> +	int bpp, ret;
>  
>  	/*
>  	 * VFP_DSI should be less than VFP_DPI and VFP_DSI should be at
> @@ -860,11 +902,9 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
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
> @@ -990,7 +1030,7 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
>  	bpp = mipi_dsi_pixel_format_to_bpp(output->dev->format);
>  	nlanes = output->dev->lanes;
>  
> -	WARN_ON_ONCE(cdns_dsi_mode2cfg(dsi, mode, &dsi_cfg, &dphy_cfg, false));
> +	WARN_ON_ONCE(cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, false));
>  
>  	cdns_dsi_hs_init(dsi, &dphy_cfg);
>  	cdns_dsi_init_link(dsi);
> -- 
> git-series 0.9.1

-- 
Sean Paul, Software Engineer, Google / Chromium OS
