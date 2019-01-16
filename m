Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC98C43444
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 08:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87D2520859
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 08:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="B2VV7Tw2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388789AbfAPIhz (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 03:37:55 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:50838 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729090AbfAPIhz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 03:37:55 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x0G8bXO4100226;
        Wed, 16 Jan 2019 02:37:34 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1547627854;
        bh=dH2m8U4vXfkWqfx0Lmr3QYeorBuPRQK+pRnRCFMttF4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=B2VV7Tw2trllGf4h6ziTQUpln5tMQh3mRAjhKM5iy9sz0MbvOvBM4LPRDZxVJjDhx
         eog9nUoe4RtsJBzI3fhJku5zT4YeUhHG8H7rm1F6Qc59dC+P1DwBcaXpPDuFRLiDI/
         Cllg7EI33rqL6aqqU4PAtxcjYXdS3TTBYbXZzck8=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x0G8bXcL116660
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Jan 2019 02:37:33 -0600
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1591.10; Wed, 16
 Jan 2019 02:37:33 -0600
Received: from dlep32.itg.ti.com (157.170.170.100) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_0,
 cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.1.1591.10 via Frontend Transport;
 Wed, 16 Jan 2019 02:37:33 -0600
Received: from [172.24.190.233] (ileax41-snat.itg.ti.com [10.172.224.153])
        by dlep32.itg.ti.com (8.14.3/8.13.8) with ESMTP id x0G8bTwV009746;
        Wed, 16 Jan 2019 02:37:30 -0600
Subject: Re: [PATCH v4 9/9] drm/bridge: cdns: Convert to phy framework
To:     Maxime Ripard <maxime.ripard@bootlin.com>
CC:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Chen-Yu Tsai <wens@csie.org>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Krzysztof Witos <kwitos@cadence.com>,
        Rafal Ciepiela <rafalc@cadence.com>
References: <cover.5d91ef683e3f432342f536e0f2fe239dbcebcb3e.1547026369.git-series.maxime.ripard@bootlin.com>
 <8693505fc758fbf3958e1c8b2fe481ec3223138d.1547026369.git-series.maxime.ripard@bootlin.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <c744edad-3c04-3ddb-f8e2-c916af9e70ca@ti.com>
Date:   Wed, 16 Jan 2019 14:07:07 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <8693505fc758fbf3958e1c8b2fe481ec3223138d.1547026369.git-series.maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On 09/01/19 3:03 PM, Maxime Ripard wrote:
> Now that we have everything we need in the phy framework to allow to tune
> the phy parameters, let's convert the Cadence DSI bridge to that API
> instead of creating a ad-hoc driver for its phy.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

For this too, need ACKs from DRM MAINTAINERS.

Thanks
Kishon
> ---
>  drivers/gpu/drm/bridge/Kconfig    |   1 +-
>  drivers/gpu/drm/bridge/cdns-dsi.c | 485 +++----------------------------
>  drivers/phy/cadence/cdns-dphy.c   |   2 +-
>  3 files changed, 61 insertions(+), 427 deletions(-)
> 
> diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
> index 2fee47b0d50b..8840f396a7b6 100644
> --- a/drivers/gpu/drm/bridge/Kconfig
> +++ b/drivers/gpu/drm/bridge/Kconfig
> @@ -30,6 +30,7 @@ config DRM_CDNS_DSI
>  	select DRM_KMS_HELPER
>  	select DRM_MIPI_DSI
>  	select DRM_PANEL_BRIDGE
> +	select GENERIC_PHY_MIPI_DPHY
>  	depends on OF
>  	help
>  	  Support Cadence DPI to DSI bridge. This is an internal
> diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
> index 3ac6dd524b6d..7b432257ffbe 100644
> --- a/drivers/gpu/drm/bridge/cdns-dsi.c
> +++ b/drivers/gpu/drm/bridge/cdns-dsi.c
> @@ -21,6 +21,9 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/reset.h>
>  
> +#include <linux/phy/phy.h>
> +#include <linux/phy/phy-mipi-dphy.h>
> +
>  #define IP_CONF				0x0
>  #define SP_HS_FIFO_DEPTH(x)		(((x) & GENMASK(30, 26)) >> 26)
>  #define SP_LP_FIFO_DEPTH(x)		(((x) & GENMASK(25, 21)) >> 21)
> @@ -419,44 +422,11 @@
>  #define DSI_NULL_FRAME_OVERHEAD		6
>  #define DSI_EOT_PKT_SIZE		4
>  
> -#define REG_WAKEUP_TIME_NS		800
> -#define DPHY_PLL_RATE_HZ		108000000
> -
> -/* DPHY registers */
> -#define DPHY_PMA_CMN(reg)		(reg)
> -#define DPHY_PMA_LCLK(reg)		(0x100 + (reg))
> -#define DPHY_PMA_LDATA(lane, reg)	(0x200 + ((lane) * 0x100) + (reg))
> -#define DPHY_PMA_RCLK(reg)		(0x600 + (reg))
> -#define DPHY_PMA_RDATA(lane, reg)	(0x700 + ((lane) * 0x100) + (reg))
> -#define DPHY_PCS(reg)			(0xb00 + (reg))
> -
> -#define DPHY_CMN_SSM			DPHY_PMA_CMN(0x20)
> -#define DPHY_CMN_SSM_EN			BIT(0)
> -#define DPHY_CMN_TX_MODE_EN		BIT(9)
> -
> -#define DPHY_CMN_PWM			DPHY_PMA_CMN(0x40)
> -#define DPHY_CMN_PWM_DIV(x)		((x) << 20)
> -#define DPHY_CMN_PWM_LOW(x)		((x) << 10)
> -#define DPHY_CMN_PWM_HIGH(x)		(x)
> -
> -#define DPHY_CMN_FBDIV			DPHY_PMA_CMN(0x4c)
> -#define DPHY_CMN_FBDIV_VAL(low, high)	(((high) << 11) | ((low) << 22))
> -#define DPHY_CMN_FBDIV_FROM_REG		(BIT(10) | BIT(21))
> -
> -#define DPHY_CMN_OPIPDIV		DPHY_PMA_CMN(0x50)
> -#define DPHY_CMN_IPDIV_FROM_REG		BIT(0)
> -#define DPHY_CMN_IPDIV(x)		((x) << 1)
> -#define DPHY_CMN_OPDIV_FROM_REG		BIT(6)
> -#define DPHY_CMN_OPDIV(x)		((x) << 7)
> -
> -#define DPHY_PSM_CFG			DPHY_PCS(0x4)
> -#define DPHY_PSM_CFG_FROM_REG		BIT(0)
> -#define DPHY_PSM_CLK_DIV(x)		((x) << 1)
> -
>  struct cdns_dsi_output {
>  	struct mipi_dsi_device *dev;
>  	struct drm_panel *panel;
>  	struct drm_bridge *bridge;
> +	union phy_configure_opts phy_opts;
>  };
>  
>  enum cdns_dsi_input_id {
> @@ -465,14 +435,6 @@ enum cdns_dsi_input_id {
>  	CDNS_DSC_INPUT,
>  };
>  
> -struct cdns_dphy_cfg {
> -	u8 pll_ipdiv;
> -	u8 pll_opdiv;
> -	u16 pll_fbdiv;
> -	unsigned long lane_bps;
> -	unsigned int nlanes;
> -};
> -
>  struct cdns_dsi_cfg {
>  	unsigned int hfp;
>  	unsigned int hsa;
> @@ -481,34 +443,6 @@ struct cdns_dsi_cfg {
>  	unsigned int htotal;
>  };
>  
> -struct cdns_dphy;
> -
> -enum cdns_dphy_clk_lane_cfg {
> -	DPHY_CLK_CFG_LEFT_DRIVES_ALL = 0,
> -	DPHY_CLK_CFG_LEFT_DRIVES_RIGHT = 1,
> -	DPHY_CLK_CFG_LEFT_DRIVES_LEFT = 2,
> -	DPHY_CLK_CFG_RIGHT_DRIVES_ALL = 3,
> -};
> -
> -struct cdns_dphy_ops {
> -	int (*probe)(struct cdns_dphy *dphy);
> -	void (*remove)(struct cdns_dphy *dphy);
> -	void (*set_psm_div)(struct cdns_dphy *dphy, u8 div);
> -	void (*set_clk_lane_cfg)(struct cdns_dphy *dphy,
> -				 enum cdns_dphy_clk_lane_cfg cfg);
> -	void (*set_pll_cfg)(struct cdns_dphy *dphy,
> -			    const struct cdns_dphy_cfg *cfg);
> -	unsigned long (*get_wakeup_time_ns)(struct cdns_dphy *dphy);
> -};
> -
> -struct cdns_dphy {
> -	struct cdns_dphy_cfg cfg;
> -	void __iomem *regs;
> -	struct clk *psm_clk;
> -	struct clk *pll_ref_clk;
> -	const struct cdns_dphy_ops *ops;
> -};
> -
>  struct cdns_dsi_input {
>  	enum cdns_dsi_input_id id;
>  	struct drm_bridge bridge;
> @@ -526,7 +460,7 @@ struct cdns_dsi {
>  	struct reset_control *dsi_p_rst;
>  	struct clk *dsi_sys_clk;
>  	bool link_initialized;
> -	struct cdns_dphy *dphy;
> +	struct phy *dphy;
>  };
>  
>  static inline struct cdns_dsi *input_to_dsi(struct cdns_dsi_input *input)
> @@ -550,175 +484,6 @@ static unsigned int mode_to_dpi_hfp(const struct drm_display_mode *mode)
>  	return mode->crtc_hsync_start - mode->crtc_hdisplay;
>  }
>  
> -static int cdns_dsi_get_dphy_pll_cfg(struct cdns_dphy *dphy,
> -				     struct cdns_dphy_cfg *cfg,
> -				     unsigned int dpi_htotal,
> -				     unsigned int dpi_bpp,
> -				     unsigned int dpi_hz,
> -				     unsigned int dsi_htotal,
> -				     unsigned int dsi_nlanes,
> -				     unsigned int *dsi_hfp_ext)
> -{
> -	u64 dlane_bps, dlane_bps_max, fbdiv, fbdiv_max, adj_dsi_htotal;
> -	unsigned long pll_ref_hz = clk_get_rate(dphy->pll_ref_clk);
> -
> -	memset(cfg, 0, sizeof(*cfg));
> -
> -	cfg->nlanes = dsi_nlanes;
> -
> -	if (pll_ref_hz < 9600000 || pll_ref_hz >= 150000000)
> -		return -EINVAL;
> -	else if (pll_ref_hz < 19200000)
> -		cfg->pll_ipdiv = 1;
> -	else if (pll_ref_hz < 38400000)
> -		cfg->pll_ipdiv = 2;
> -	else if (pll_ref_hz < 76800000)
> -		cfg->pll_ipdiv = 4;
> -	else
> -		cfg->pll_ipdiv = 8;
> -
> -	/*
> -	 * Make sure DSI htotal is aligned on a lane boundary when calculating
> -	 * the expected data rate. This is done by extending HFP in case of
> -	 * misalignment.
> -	 */
> -	adj_dsi_htotal = dsi_htotal;
> -	if (dsi_htotal % dsi_nlanes)
> -		adj_dsi_htotal += dsi_nlanes - (dsi_htotal % dsi_nlanes);
> -
> -	dlane_bps = (u64)dpi_hz * adj_dsi_htotal;
> -
> -	/* data rate in bytes/sec is not an integer, refuse the mode. */
> -	if (do_div(dlane_bps, dsi_nlanes * dpi_htotal))
> -		return -EINVAL;
> -
> -	/* data rate was in bytes/sec, convert to bits/sec. */
> -	dlane_bps *= 8;
> -
> -	if (dlane_bps > 2500000000UL || dlane_bps < 160000000UL)
> -		return -EINVAL;
> -	else if (dlane_bps >= 1250000000)
> -		cfg->pll_opdiv = 1;
> -	else if (dlane_bps >= 630000000)
> -		cfg->pll_opdiv = 2;
> -	else if (dlane_bps >= 320000000)
> -		cfg->pll_opdiv = 4;
> -	else if (dlane_bps >= 160000000)
> -		cfg->pll_opdiv = 8;
> -
> -	/*
> -	 * Allow a deviation of 0.2% on the per-lane data rate to try to
> -	 * recover a potential mismatch between DPI and PPI clks.
> -	 */
> -	dlane_bps_max = dlane_bps + DIV_ROUND_DOWN_ULL(dlane_bps, 500);
> -	fbdiv_max = DIV_ROUND_DOWN_ULL(dlane_bps_max * 2 *
> -				       cfg->pll_opdiv * cfg->pll_ipdiv,
> -				       pll_ref_hz);
> -	fbdiv = DIV_ROUND_UP_ULL(dlane_bps * 2 * cfg->pll_opdiv *
> -				 cfg->pll_ipdiv,
> -				 pll_ref_hz);
> -
> -	/*
> -	 * Iterate over all acceptable fbdiv and try to find an adjusted DSI
> -	 * htotal length providing an exact match.
> -	 *
> -	 * Note that we could do something even trickier by relying on the fact
> -	 * that a new line is not necessarily aligned on a lane boundary, so,
> -	 * by making adj_dsi_htotal non aligned on a dsi_lanes we can improve a
> -	 * bit the precision. With this, the step would be
> -	 *
> -	 *	pll_ref_hz / (2 * opdiv * ipdiv * nlanes)
> -	 *
> -	 * instead of
> -	 *
> -	 *	pll_ref_hz / (2 * opdiv * ipdiv)
> -	 *
> -	 * The drawback of this approach is that we would need to make sure the
> -	 * number or lines is a multiple of the realignment periodicity which is
> -	 * a function of the number of lanes and the original misalignment. For
> -	 * example, for NLANES = 4 and HTOTAL % NLANES = 3, it takes 4 lines
> -	 * to realign on a lane:
> -	 * LINE 0: expected number of bytes, starts emitting first byte of
> -	 *	   LINE 1 on LANE 3
> -	 * LINE 1: expected number of bytes, starts emitting first 2 bytes of
> -	 *	   LINE 2 on LANES 2 and 3
> -	 * LINE 2: expected number of bytes, starts emitting first 3 bytes of
> -	 *	   of LINE 3 on LANES 1, 2 and 3
> -	 * LINE 3: one byte less, now things are realigned on LANE 0 for LINE 4
> -	 *
> -	 * I figured this extra complexity was not worth the benefit, but if
> -	 * someone really has unfixable mismatch, that would be something to
> -	 * investigate.
> -	 */
> -	for (; fbdiv <= fbdiv_max; fbdiv++) {
> -		u32 rem;
> -
> -		adj_dsi_htotal = (u64)fbdiv * pll_ref_hz * dsi_nlanes *
> -				 dpi_htotal;
> -
> -		/*
> -		 * Do the division in 2 steps to avoid an overflow on the
> -		 * divider.
> -		 */
> -		rem = do_div(adj_dsi_htotal, dpi_hz);
> -		if (rem)
> -			continue;
> -
> -		rem = do_div(adj_dsi_htotal,
> -			     cfg->pll_opdiv * cfg->pll_ipdiv * 2 * 8);
> -		if (rem)
> -			continue;
> -
> -		cfg->pll_fbdiv = fbdiv;
> -		*dsi_hfp_ext = adj_dsi_htotal - dsi_htotal;
> -		break;
> -	}
> -
> -	/* No match, let's just reject the display mode. */
> -	if (!cfg->pll_fbdiv)
> -		return -EINVAL;
> -
> -	dlane_bps = DIV_ROUND_DOWN_ULL((u64)dpi_hz * adj_dsi_htotal * 8,
> -				       dsi_nlanes * dpi_htotal);
> -	cfg->lane_bps = dlane_bps;
> -
> -	return 0;
> -}
> -
> -static int cdns_dphy_setup_psm(struct cdns_dphy *dphy)
> -{
> -	unsigned long psm_clk_hz = clk_get_rate(dphy->psm_clk);
> -	unsigned long psm_div;
> -
> -	if (!psm_clk_hz || psm_clk_hz > 100000000)
> -		return -EINVAL;
> -
> -	psm_div = DIV_ROUND_CLOSEST(psm_clk_hz, 1000000);
> -	if (dphy->ops->set_psm_div)
> -		dphy->ops->set_psm_div(dphy, psm_div);
> -
> -	return 0;
> -}
> -
> -static void cdns_dphy_set_clk_lane_cfg(struct cdns_dphy *dphy,
> -				       enum cdns_dphy_clk_lane_cfg cfg)
> -{
> -	if (dphy->ops->set_clk_lane_cfg)
> -		dphy->ops->set_clk_lane_cfg(dphy, cfg);
> -}
> -
> -static void cdns_dphy_set_pll_cfg(struct cdns_dphy *dphy,
> -				  const struct cdns_dphy_cfg *cfg)
> -{
> -	if (dphy->ops->set_pll_cfg)
> -		dphy->ops->set_pll_cfg(dphy, cfg);
> -}
> -
> -static unsigned long cdns_dphy_get_wakeup_time_ns(struct cdns_dphy *dphy)
> -{
> -	return dphy->ops->get_wakeup_time_ns(dphy);
> -}
> -
>  static unsigned int dpi_to_dsi_timing(unsigned int dpi_timing,
>  				      unsigned int dpi_bpp,
>  				      unsigned int dsi_pkt_overhead)
> @@ -780,17 +545,20 @@ static int cdns_dsi_mode2cfg(struct cdns_dsi *dsi,
>  	return 0;
>  }
>  
> -static int cdns_dphy_validate(struct cdns_dsi *dsi,
> +static int cdns_dsi_adjust_phy_config(struct cdns_dsi *dsi,
>  			      struct cdns_dsi_cfg *dsi_cfg,
> -			      struct cdns_dphy_cfg *dphy_cfg,
> +			      struct phy_configure_opts_mipi_dphy *phy_cfg,
>  			      const struct drm_display_mode *mode,
>  			      bool mode_valid_check)
>  {
>  	struct cdns_dsi_output *output = &dsi->output;
> +	unsigned long long dlane_bps;
> +	unsigned long adj_dsi_htotal;
>  	unsigned long dsi_htotal;
> -	unsigned int dsi_hfp_ext = 0;
> -
> -	int ret;
> +	unsigned long dpi_htotal;
> +	unsigned long dpi_hz;
> +	unsigned int dsi_hfp_ext;
> +	unsigned int lanes = output->dev->lanes;
>  
>  	dsi_htotal = dsi_cfg->hbp + DSI_HBP_FRAME_OVERHEAD;
>  	if (output->dev->mode_flags & MIPI_DSI_MODE_VIDEO_SYNC_PULSE)
> @@ -799,25 +567,27 @@ static int cdns_dphy_validate(struct cdns_dsi *dsi,
>  	dsi_htotal += dsi_cfg->hact;
>  	dsi_htotal += dsi_cfg->hfp + DSI_HFP_FRAME_OVERHEAD;
>  
> -	if (mode_valid_check)
> -		ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
> -						mode->htotal,
> -						mode->clock * 1000,
> -						mipi_dsi_pixel_format_to_bpp(output->dev->format),
> -						dsi_htotal,
> -						output->dev->lanes,
> -						&dsi_hfp_ext);
> -	else
> -		ret = cdns_dsi_get_dphy_pll_cfg(dsi->dphy, dphy_cfg,
> -						mode->crtc_htotal,
> -						mipi_dsi_pixel_format_to_bpp(output->dev->format),
> -						mode->crtc_clock * 1000,
> -						dsi_htotal,
> -						output->dev->lanes,
> -						&dsi_hfp_ext);
> -	if (ret)
> -		return ret;
> +	/*
> +	 * Make sure DSI htotal is aligned on a lane boundary when calculating
> +	 * the expected data rate. This is done by extending HFP in case of
> +	 * misalignment.
> +	 */
> +	adj_dsi_htotal = dsi_htotal;
> +	if (dsi_htotal % lanes)
> +		adj_dsi_htotal += lanes - (dsi_htotal % lanes);
> +
> +	dpi_hz = (mode_valid_check ? mode->clock : mode->crtc_clock) * 1000;
> +	dlane_bps = (unsigned long long)dpi_hz * adj_dsi_htotal;
> +
> +	/* data rate in bytes/sec is not an integer, refuse the mode. */
> +	dpi_htotal = mode_valid_check ? mode->htotal : mode->crtc_htotal;
> +	if (do_div(dlane_bps, lanes * dpi_htotal))
> +		return -EINVAL;
>  
> +	/* data rate was in bytes/sec, convert to bits/sec. */
> +	phy_cfg->hs_clk_rate = dlane_bps * 8;
> +
> +	dsi_hfp_ext = adj_dsi_htotal - dsi_htotal;
>  	dsi_cfg->hfp += dsi_hfp_ext;
>  	dsi_cfg->htotal = dsi_htotal + dsi_hfp_ext;
>  
> @@ -827,10 +597,10 @@ static int cdns_dphy_validate(struct cdns_dsi *dsi,
>  static int cdns_dsi_check_conf(struct cdns_dsi *dsi,
>  			       const struct drm_display_mode *mode,
>  			       struct cdns_dsi_cfg *dsi_cfg,
> -			       struct cdns_dphy_cfg *dphy_cfg,
>  			       bool mode_valid_check)
>  {
>  	struct cdns_dsi_output *output = &dsi->output;
> +	struct phy_configure_opts_mipi_dphy *phy_cfg = &output->phy_opts.mipi_dphy;
>  	unsigned long dsi_hss_hsa_hse_hbp;
>  	unsigned int nlanes = output->dev->lanes;
>  	int ret;
> @@ -839,7 +609,15 @@ static int cdns_dsi_check_conf(struct cdns_dsi *dsi,
>  	if (ret)
>  		return ret;
>  
> -	ret = cdns_dphy_validate(dsi, dsi_cfg, dphy_cfg, mode, mode_valid_check);
> +	phy_mipi_dphy_get_default_config(mode->crtc_clock * 1000,
> +					 mipi_dsi_pixel_format_to_bpp(output->dev->format),
> +					 nlanes, phy_cfg);
> +
> +	ret = cdns_dsi_adjust_phy_config(dsi, dsi_cfg, phy_cfg, mode, mode_valid_check);
> +	if (ret)
> +		return ret;
> +
> +	ret = phy_validate(dsi->dphy, PHY_MODE_MIPI_DPHY, 0, &output->phy_opts);
>  	if (ret)
>  		return ret;
>  
> @@ -852,7 +630,7 @@ static int cdns_dsi_check_conf(struct cdns_dsi *dsi,
>  	 * is empty before we start a receiving a new line on the DPI
>  	 * interface.
>  	 */
> -	if ((u64)dphy_cfg->lane_bps * mode_to_dpi_hfp(mode) * nlanes <
> +	if ((u64)phy_cfg->hs_clk_rate * mode_to_dpi_hfp(mode) * nlanes <
>  	    (u64)dsi_hss_hsa_hse_hbp *
>  	    (mode_valid_check ? mode->clock : mode->crtc_clock) * 1000)
>  		return -EINVAL;
> @@ -882,7 +660,6 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
>  	struct cdns_dsi_input *input = bridge_to_cdns_dsi_input(bridge);
>  	struct cdns_dsi *dsi = input_to_dsi(input);
>  	struct cdns_dsi_output *output = &dsi->output;
> -	struct cdns_dphy_cfg dphy_cfg;
>  	struct cdns_dsi_cfg dsi_cfg;
>  	int bpp, ret;
>  
> @@ -902,7 +679,7 @@ cdns_dsi_bridge_mode_valid(struct drm_bridge *bridge,
>  	if ((mode->hdisplay * bpp) % 32)
>  		return MODE_H_ILLEGAL;
>  
> -	ret = cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, true);
> +	ret = cdns_dsi_check_conf(dsi, mode, &dsi_cfg, true);
>  	if (ret)
>  		return MODE_BAD;
>  
> @@ -925,9 +702,9 @@ static void cdns_dsi_bridge_disable(struct drm_bridge *bridge)
>  	pm_runtime_put(dsi->base.dev);
>  }
>  
> -static void cdns_dsi_hs_init(struct cdns_dsi *dsi,
> -			     const struct cdns_dphy_cfg *dphy_cfg)
> +static void cdns_dsi_hs_init(struct cdns_dsi *dsi)
>  {
> +	struct cdns_dsi_output *output = &dsi->output;
>  	u32 status;
>  
>  	/*
> @@ -938,30 +715,10 @@ static void cdns_dsi_hs_init(struct cdns_dsi *dsi,
>  	       DPHY_CMN_PDN | DPHY_PLL_PDN,
>  	       dsi->regs + MCTL_DPHY_CFG0);
>  
> -	/*
> -	 * Configure the internal PSM clk divider so that the DPHY has a
> -	 * 1MHz clk (or something close).
> -	 */
> -	WARN_ON_ONCE(cdns_dphy_setup_psm(dsi->dphy));
> -
> -	/*
> -	 * Configure attach clk lanes to data lanes: the DPHY has 2 clk lanes
> -	 * and 8 data lanes, each clk lane can be attache different set of
> -	 * data lanes. The 2 groups are named 'left' and 'right', so here we
> -	 * just say that we want the 'left' clk lane to drive the 'left' data
> -	 * lanes.
> -	 */
> -	cdns_dphy_set_clk_lane_cfg(dsi->dphy, DPHY_CLK_CFG_LEFT_DRIVES_LEFT);
> -
> -	/*
> -	 * Configure the DPHY PLL that will be used to generate the TX byte
> -	 * clk.
> -	 */
> -	cdns_dphy_set_pll_cfg(dsi->dphy, dphy_cfg);
> -
> -	/* Start TX state machine. */
> -	writel(DPHY_CMN_SSM_EN | DPHY_CMN_TX_MODE_EN,
> -	       dsi->dphy->regs + DPHY_CMN_SSM);
> +	phy_init(dsi->dphy);
> +	phy_set_mode(dsi->dphy, PHY_MODE_MIPI_DPHY);
> +	phy_configure(dsi->dphy, &output->phy_opts);
> +	phy_power_on(dsi->dphy);
>  
>  	/* Activate the PLL and wait until it's locked. */
>  	writel(PLL_LOCKED, dsi->regs + MCTL_MAIN_STS_CLR);
> @@ -971,7 +728,7 @@ static void cdns_dsi_hs_init(struct cdns_dsi *dsi,
>  					status & PLL_LOCKED, 100, 100));
>  	/* De-assert data and clock reset lines. */
>  	writel(DPHY_CMN_PSO | DPHY_ALL_D_PDN | DPHY_C_PDN | DPHY_CMN_PDN |
> -	       DPHY_D_RSTB(dphy_cfg->nlanes) | DPHY_C_RSTB,
> +	       DPHY_D_RSTB(output->dev->lanes) | DPHY_C_RSTB,
>  	       dsi->regs + MCTL_DPHY_CFG0);
>  }
>  
> @@ -1017,7 +774,7 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
>  	struct cdns_dsi *dsi = input_to_dsi(input);
>  	struct cdns_dsi_output *output = &dsi->output;
>  	struct drm_display_mode *mode;
> -	struct cdns_dphy_cfg dphy_cfg;
> +	struct phy_configure_opts_mipi_dphy *phy_cfg = &output->phy_opts.mipi_dphy;
>  	unsigned long tx_byte_period;
>  	struct cdns_dsi_cfg dsi_cfg;
>  	u32 tmp, reg_wakeup, div;
> @@ -1030,9 +787,9 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
>  	bpp = mipi_dsi_pixel_format_to_bpp(output->dev->format);
>  	nlanes = output->dev->lanes;
>  
> -	WARN_ON_ONCE(cdns_dsi_check_conf(dsi, mode, &dsi_cfg, &dphy_cfg, false));
> +	WARN_ON_ONCE(cdns_dsi_check_conf(dsi, mode, &dsi_cfg, false));
>  
> -	cdns_dsi_hs_init(dsi, &dphy_cfg);
> +	cdns_dsi_hs_init(dsi);
>  	cdns_dsi_init_link(dsi);
>  
>  	writel(HBP_LEN(dsi_cfg.hbp) | HSA_LEN(dsi_cfg.hsa),
> @@ -1068,9 +825,8 @@ static void cdns_dsi_bridge_enable(struct drm_bridge *bridge)
>  		tmp -= DIV_ROUND_UP(DSI_EOT_PKT_SIZE, nlanes);
>  
>  	tx_byte_period = DIV_ROUND_DOWN_ULL((u64)NSEC_PER_SEC * 8,
> -					    dphy_cfg.lane_bps);
> -	reg_wakeup = cdns_dphy_get_wakeup_time_ns(dsi->dphy) /
> -		     tx_byte_period;
> +					    phy_cfg->hs_clk_rate);
> +	reg_wakeup = (phy_cfg->hs_prepare + phy_cfg->hs_zero) / tx_byte_period;
>  	writel(REG_WAKEUP_TIME(reg_wakeup) | REG_LINE_DURATION(tmp),
>  	       dsi->regs + VID_DPHY_TIME);
>  
> @@ -1384,8 +1140,6 @@ static int __maybe_unused cdns_dsi_resume(struct device *dev)
>  	reset_control_deassert(dsi->dsi_p_rst);
>  	clk_prepare_enable(dsi->dsi_p_clk);
>  	clk_prepare_enable(dsi->dsi_sys_clk);
> -	clk_prepare_enable(dsi->dphy->psm_clk);
> -	clk_prepare_enable(dsi->dphy->pll_ref_clk);
>  
>  	return 0;
>  }
> @@ -1394,8 +1148,6 @@ static int __maybe_unused cdns_dsi_suspend(struct device *dev)
>  {
>  	struct cdns_dsi *dsi = dev_get_drvdata(dev);
>  
> -	clk_disable_unprepare(dsi->dphy->pll_ref_clk);
> -	clk_disable_unprepare(dsi->dphy->psm_clk);
>  	clk_disable_unprepare(dsi->dsi_sys_clk);
>  	clk_disable_unprepare(dsi->dsi_p_clk);
>  	reset_control_assert(dsi->dsi_p_rst);
> @@ -1406,121 +1158,6 @@ static int __maybe_unused cdns_dsi_suspend(struct device *dev)
>  static UNIVERSAL_DEV_PM_OPS(cdns_dsi_pm_ops, cdns_dsi_suspend, cdns_dsi_resume,
>  			    NULL);
>  
> -static unsigned long cdns_dphy_ref_get_wakeup_time_ns(struct cdns_dphy *dphy)
> -{
> -	/* Default wakeup time is 800 ns (in a simulated environment). */
> -	return 800;
> -}
> -
> -static void cdns_dphy_ref_set_pll_cfg(struct cdns_dphy *dphy,
> -				      const struct cdns_dphy_cfg *cfg)
> -{
> -	u32 fbdiv_low, fbdiv_high;
> -
> -	fbdiv_low = (cfg->pll_fbdiv / 4) - 2;
> -	fbdiv_high = cfg->pll_fbdiv - fbdiv_low - 2;
> -
> -	writel(DPHY_CMN_IPDIV_FROM_REG | DPHY_CMN_OPDIV_FROM_REG |
> -	       DPHY_CMN_IPDIV(cfg->pll_ipdiv) |
> -	       DPHY_CMN_OPDIV(cfg->pll_opdiv),
> -	       dphy->regs + DPHY_CMN_OPIPDIV);
> -	writel(DPHY_CMN_FBDIV_FROM_REG |
> -	       DPHY_CMN_FBDIV_VAL(fbdiv_low, fbdiv_high),
> -	       dphy->regs + DPHY_CMN_FBDIV);
> -	writel(DPHY_CMN_PWM_HIGH(6) | DPHY_CMN_PWM_LOW(0x101) |
> -	       DPHY_CMN_PWM_DIV(0x8),
> -	       dphy->regs + DPHY_CMN_PWM);
> -}
> -
> -static void cdns_dphy_ref_set_psm_div(struct cdns_dphy *dphy, u8 div)
> -{
> -	writel(DPHY_PSM_CFG_FROM_REG | DPHY_PSM_CLK_DIV(div),
> -	       dphy->regs + DPHY_PSM_CFG);
> -}
> -
> -/*
> - * This is the reference implementation of DPHY hooks. Specific integration of
> - * this IP may have to re-implement some of them depending on how they decided
> - * to wire things in the SoC.
> - */
> -static const struct cdns_dphy_ops ref_dphy_ops = {
> -	.get_wakeup_time_ns = cdns_dphy_ref_get_wakeup_time_ns,
> -	.set_pll_cfg = cdns_dphy_ref_set_pll_cfg,
> -	.set_psm_div = cdns_dphy_ref_set_psm_div,
> -};
> -
> -static const struct of_device_id cdns_dphy_of_match[] = {
> -	{ .compatible = "cdns,dphy", .data = &ref_dphy_ops },
> -	{ /* sentinel */ },
> -};
> -
> -static struct cdns_dphy *cdns_dphy_probe(struct platform_device *pdev)
> -{
> -	const struct of_device_id *match;
> -	struct cdns_dphy *dphy;
> -	struct of_phandle_args args;
> -	struct resource res;
> -	int ret;
> -
> -	ret = of_parse_phandle_with_args(pdev->dev.of_node, "phys",
> -					 "#phy-cells", 0, &args);
> -	if (ret)
> -		return ERR_PTR(-ENOENT);
> -
> -	match = of_match_node(cdns_dphy_of_match, args.np);
> -	if (!match || !match->data)
> -		return ERR_PTR(-EINVAL);
> -
> -	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
> -	if (!dphy)
> -		return ERR_PTR(-ENOMEM);
> -
> -	dphy->ops = match->data;
> -
> -	ret = of_address_to_resource(args.np, 0, &res);
> -	if (ret)
> -		return ERR_PTR(ret);
> -
> -	dphy->regs = devm_ioremap_resource(&pdev->dev, &res);
> -	if (IS_ERR(dphy->regs))
> -		return ERR_CAST(dphy->regs);
> -
> -	dphy->psm_clk = of_clk_get_by_name(args.np, "psm");
> -	if (IS_ERR(dphy->psm_clk))
> -		return ERR_CAST(dphy->psm_clk);
> -
> -	dphy->pll_ref_clk = of_clk_get_by_name(args.np, "pll_ref");
> -	if (IS_ERR(dphy->pll_ref_clk)) {
> -		ret = PTR_ERR(dphy->pll_ref_clk);
> -		goto err_put_psm_clk;
> -	}
> -
> -	if (dphy->ops->probe) {
> -		ret = dphy->ops->probe(dphy);
> -		if (ret)
> -			goto err_put_pll_ref_clk;
> -	}
> -
> -	return dphy;
> -
> -err_put_pll_ref_clk:
> -	clk_put(dphy->pll_ref_clk);
> -
> -err_put_psm_clk:
> -	clk_put(dphy->psm_clk);
> -
> -	return ERR_PTR(ret);
> -}
> -
> -static void cdns_dphy_remove(struct cdns_dphy *dphy)
> -{
> -	if (dphy->ops->remove)
> -		dphy->ops->remove(dphy);
> -
> -	clk_put(dphy->pll_ref_clk);
> -	clk_put(dphy->psm_clk);
> -}
> -
>  static int cdns_dsi_drm_probe(struct platform_device *pdev)
>  {
>  	struct cdns_dsi *dsi;
> @@ -1559,13 +1196,13 @@ static int cdns_dsi_drm_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return irq;
>  
> -	dsi->dphy = cdns_dphy_probe(pdev);
> +	dsi->dphy = devm_phy_get(&pdev->dev, "dphy");
>  	if (IS_ERR(dsi->dphy))
>  		return PTR_ERR(dsi->dphy);
>  
>  	ret = clk_prepare_enable(dsi->dsi_p_clk);
>  	if (ret)
> -		goto err_remove_dphy;
> +		return ret;
>  
>  	val = readl(dsi->regs + ID_REG);
>  	if (REV_VENDOR_ID(val) != 0xcad) {
> @@ -1623,9 +1260,6 @@ static int cdns_dsi_drm_probe(struct platform_device *pdev)
>  err_disable_pclk:
>  	clk_disable_unprepare(dsi->dsi_p_clk);
>  
> -err_remove_dphy:
> -	cdns_dphy_remove(dsi->dphy);
> -
>  	return ret;
>  }
>  
> @@ -1635,7 +1269,6 @@ static int cdns_dsi_drm_remove(struct platform_device *pdev)
>  
>  	mipi_dsi_host_unregister(&dsi->base);
>  	pm_runtime_disable(&pdev->dev);
> -	cdns_dphy_remove(dsi->dphy);
>  
>  	return 0;
>  }
> diff --git a/drivers/phy/cadence/cdns-dphy.c b/drivers/phy/cadence/cdns-dphy.c
> index 1d0abba03f37..cde12b3aa4d4 100644
> --- a/drivers/phy/cadence/cdns-dphy.c
> +++ b/drivers/phy/cadence/cdns-dphy.c
> @@ -227,7 +227,7 @@ static int cdns_dphy_config_from_opts(struct phy *phy,
>  	if (ret)
>  		return ret;
>  
> -	opts->wakeup = cdns_dphy_get_wakeup_time_ns(dphy) * 1000;
> +	opts->wakeup = cdns_dphy_get_wakeup_time_ns(dphy) / 1000;
>  
>  	return 0;
>  }
> 
