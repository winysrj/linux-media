Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0718BC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 08:16:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9FD02175B
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 08:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbfBGIP7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 03:15:59 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:51947 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbfBGIP6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 03:15:58 -0500
X-Originating-IP: 90.88.22.177
Received: from aptenodytes (aaubervilliers-681-1-80-177.w90-88.abo.wanadoo.fr [90.88.22.177])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 20AE86000D;
        Thu,  7 Feb 2019 08:15:50 +0000 (UTC)
Message-ID: <8856006f5cf615b7d278d4ead16a5fbc6e95d334.camel@bootlin.com>
Subject: Re: [PATCH v5 4/9] sun6i: dsi: Convert to generic phy handling
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
Date:   Thu, 07 Feb 2019 09:15:49 +0100
In-Reply-To: <dc6450e2978b6dafcc464595ad06204d22d2658f.1548085432.git-series.maxime.ripard@bootlin.com>
References: <cover.fbf0776c70c0cfb7b7fd88ce6a96b4597d620cac.1548085432.git-series.maxime.ripard@bootlin.com>
         <dc6450e2978b6dafcc464595ad06204d22d2658f.1548085432.git-series.maxime.ripard@bootlin.com>
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
> Now that we have everything in place in the PHY framework to deal in a
> generic way with MIPI D-PHY phys, let's convert our PHY driver and its
> associated DSI driver to that new API.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Cheers,

Paul

> ---
>  drivers/gpu/drm/sun4i/Kconfig           |  11 +-
>  drivers/gpu/drm/sun4i/Makefile          |   6 +-
>  drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c | 164 ++++++++++++++-----------
>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c  |  31 ++---
>  drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h  |  17 +---
>  5 files changed, 126 insertions(+), 103 deletions(-)
> 
> diff --git a/drivers/gpu/drm/sun4i/Kconfig b/drivers/gpu/drm/sun4i/Kconfig
> index c2c042287c19..2b8db82c4bab 100644
> --- a/drivers/gpu/drm/sun4i/Kconfig
> +++ b/drivers/gpu/drm/sun4i/Kconfig
> @@ -45,10 +45,19 @@ config DRM_SUN6I_DSI
>  	default MACH_SUN8I
>  	select CRC_CCITT
>  	select DRM_MIPI_DSI
> +	select DRM_SUN6I_DPHY
>  	help
>  	  Choose this option if you want have an Allwinner SoC with
>  	  MIPI-DSI support. If M is selected the module will be called
> -	  sun6i-dsi
> +	  sun6i_mipi_dsi.
> +
> +config DRM_SUN6I_DPHY
> +	tristate "Allwinner A31 MIPI D-PHY Support"
> +	select GENERIC_PHY_MIPI_DPHY
> +	help
> +	  Choose this option if you have an Allwinner SoC with
> +	  MIPI-DSI support. If M is selected, the module will be
> +	  called sun6i_mipi_dphy.
>  
>  config DRM_SUN8I_DW_HDMI
>  	tristate "Support for Allwinner version of DesignWare HDMI"
> diff --git a/drivers/gpu/drm/sun4i/Makefile b/drivers/gpu/drm/sun4i/Makefile
> index 0eb38ac8e86e..1e2320d824b5 100644
> --- a/drivers/gpu/drm/sun4i/Makefile
> +++ b/drivers/gpu/drm/sun4i/Makefile
> @@ -24,9 +24,6 @@ sun4i-tcon-y			+= sun4i_lvds.o
>  sun4i-tcon-y			+= sun4i_tcon.o
>  sun4i-tcon-y			+= sun4i_rgb.o
>  
> -sun6i-dsi-y			+= sun6i_mipi_dphy.o
> -sun6i-dsi-y			+= sun6i_mipi_dsi.o
> -
>  obj-$(CONFIG_DRM_SUN4I)		+= sun4i-drm.o
>  obj-$(CONFIG_DRM_SUN4I)		+= sun4i-tcon.o
>  obj-$(CONFIG_DRM_SUN4I)		+= sun4i_tv.o
> @@ -37,7 +34,8 @@ ifdef CONFIG_DRM_SUN4I_BACKEND
>  obj-$(CONFIG_DRM_SUN4I)		+= sun4i-frontend.o
>  endif
>  obj-$(CONFIG_DRM_SUN4I_HDMI)	+= sun4i-drm-hdmi.o
> -obj-$(CONFIG_DRM_SUN6I_DSI)	+= sun6i-dsi.o
> +obj-$(CONFIG_DRM_SUN6I_DPHY)	+= sun6i_mipi_dphy.o
> +obj-$(CONFIG_DRM_SUN6I_DSI)	+= sun6i_mipi_dsi.o
>  obj-$(CONFIG_DRM_SUN8I_DW_HDMI)	+= sun8i-drm-hdmi.o
>  obj-$(CONFIG_DRM_SUN8I_MIXER)	+= sun8i-mixer.o
>  obj-$(CONFIG_DRM_SUN8I_TCON_TOP) += sun8i_tcon_top.o
> diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
> index e4d19431fa0e..79c8af5c7c1d 100644
> --- a/drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
> +++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dphy.c
> @@ -8,11 +8,14 @@
>  
>  #include <linux/bitops.h>
>  #include <linux/clk.h>
> +#include <linux/module.h>
>  #include <linux/of_address.h>
> +#include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/reset.h>
>  
> -#include "sun6i_mipi_dsi.h"
> +#include <linux/phy/phy.h>
> +#include <linux/phy/phy-mipi-dphy.h>
>  
>  #define SUN6I_DPHY_GCTL_REG		0x00
>  #define SUN6I_DPHY_GCTL_LANE_NUM(n)		((((n) - 1) & 3) << 4)
> @@ -81,12 +84,46 @@
>  
>  #define SUN6I_DPHY_DBG5_REG		0xf4
>  
> -int sun6i_dphy_init(struct sun6i_dphy *dphy, unsigned int lanes)
> +struct sun6i_dphy {
> +	struct clk				*bus_clk;
> +	struct clk				*mod_clk;
> +	struct regmap				*regs;
> +	struct reset_control			*reset;
> +
> +	struct phy				*phy;
> +	struct phy_configure_opts_mipi_dphy	config;
> +};
> +
> +static int sun6i_dphy_init(struct phy *phy)
>  {
> +	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
> +
>  	reset_control_deassert(dphy->reset);
>  	clk_prepare_enable(dphy->mod_clk);
>  	clk_set_rate_exclusive(dphy->mod_clk, 150000000);
>  
> +	return 0;
> +}
> +
> +static int sun6i_dphy_configure(struct phy *phy, union phy_configure_opts *opts)
> +{
> +	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
> +	int ret;
> +
> +	ret = phy_mipi_dphy_config_validate(&opts->mipi_dphy);
> +	if (ret)
> +		return ret;
> +
> +	memcpy(&dphy->config, opts, sizeof(dphy->config));
> +
> +	return 0;
> +}
> +
> +static int sun6i_dphy_power_on(struct phy *phy)
> +{
> +	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
> +	u8 lanes_mask = GENMASK(dphy->config.lanes - 1, 0);
> +
>  	regmap_write(dphy->regs, SUN6I_DPHY_TX_CTL_REG,
>  		     SUN6I_DPHY_TX_CTL_HS_TX_CLK_CONT);
>  
> @@ -111,16 +148,9 @@ int sun6i_dphy_init(struct sun6i_dphy *dphy, unsigned int lanes)
>  		     SUN6I_DPHY_TX_TIME4_HS_TX_ANA1(3));
>  
>  	regmap_write(dphy->regs, SUN6I_DPHY_GCTL_REG,
> -		     SUN6I_DPHY_GCTL_LANE_NUM(lanes) |
> +		     SUN6I_DPHY_GCTL_LANE_NUM(dphy->config.lanes) |
>  		     SUN6I_DPHY_GCTL_EN);
>  
> -	return 0;
> -}
> -
> -int sun6i_dphy_power_on(struct sun6i_dphy *dphy, unsigned int lanes)
> -{
> -	u8 lanes_mask = GENMASK(lanes - 1, 0);
> -
>  	regmap_write(dphy->regs, SUN6I_DPHY_ANA0_REG,
>  		     SUN6I_DPHY_ANA0_REG_PWS |
>  		     SUN6I_DPHY_ANA0_REG_DMPC |
> @@ -181,16 +211,20 @@ int sun6i_dphy_power_on(struct sun6i_dphy *dphy, unsigned int lanes)
>  	return 0;
>  }
>  
> -int sun6i_dphy_power_off(struct sun6i_dphy *dphy)
> +static int sun6i_dphy_power_off(struct phy *phy)
>  {
> +	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
> +
>  	regmap_update_bits(dphy->regs, SUN6I_DPHY_ANA1_REG,
>  			   SUN6I_DPHY_ANA1_REG_VTTMODE, 0);
>  
>  	return 0;
>  }
>  
> -int sun6i_dphy_exit(struct sun6i_dphy *dphy)
> +static int sun6i_dphy_exit(struct phy *phy)
>  {
> +	struct sun6i_dphy *dphy = phy_get_drvdata(phy);
> +
>  	clk_rate_exclusive_put(dphy->mod_clk);
>  	clk_disable_unprepare(dphy->mod_clk);
>  	reset_control_assert(dphy->reset);
> @@ -198,6 +232,15 @@ int sun6i_dphy_exit(struct sun6i_dphy *dphy)
>  	return 0;
>  }
>  
> +
> +static struct phy_ops sun6i_dphy_ops = {
> +	.configure	= sun6i_dphy_configure,
> +	.power_on	= sun6i_dphy_power_on,
> +	.power_off	= sun6i_dphy_power_off,
> +	.init		= sun6i_dphy_init,
> +	.exit		= sun6i_dphy_exit,
> +};
> +
>  static struct regmap_config sun6i_dphy_regmap_config = {
>  	.reg_bits	= 32,
>  	.val_bits	= 32,
> @@ -206,87 +249,70 @@ static struct regmap_config sun6i_dphy_regmap_config = {
>  	.name		= "mipi-dphy",
>  };
>  
> -static const struct of_device_id sun6i_dphy_of_table[] = {
> -	{ .compatible = "allwinner,sun6i-a31-mipi-dphy" },
> -	{ }
> -};
> -
> -int sun6i_dphy_probe(struct sun6i_dsi *dsi, struct device_node *node)
> +static int sun6i_dphy_probe(struct platform_device *pdev)
>  {
> +	struct phy_provider *phy_provider;
>  	struct sun6i_dphy *dphy;
> -	struct resource res;
> +	struct resource *res;
>  	void __iomem *regs;
> -	int ret;
> -
> -	if (!of_match_node(sun6i_dphy_of_table, node)) {
> -		dev_err(dsi->dev, "Incompatible D-PHY\n");
> -		return -EINVAL;
> -	}
>  
> -	dphy = devm_kzalloc(dsi->dev, sizeof(*dphy), GFP_KERNEL);
> +	dphy = devm_kzalloc(&pdev->dev, sizeof(*dphy), GFP_KERNEL);
>  	if (!dphy)
>  		return -ENOMEM;
>  
> -	ret = of_address_to_resource(node, 0, &res);
> -	if (ret) {
> -		dev_err(dsi->dev, "phy: Couldn't get our resources\n");
> -		return ret;
> -	}
> -
> -	regs = devm_ioremap_resource(dsi->dev, &res);
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	regs = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(regs)) {
> -		dev_err(dsi->dev, "Couldn't map the DPHY encoder registers\n");
> +		dev_err(&pdev->dev, "Couldn't map the DPHY encoder registers\n");
>  		return PTR_ERR(regs);
>  	}
>  
> -	dphy->regs = devm_regmap_init_mmio(dsi->dev, regs,
> -					   &sun6i_dphy_regmap_config);
> +	dphy->regs = devm_regmap_init_mmio_clk(&pdev->dev, "bus",
> +					       regs, &sun6i_dphy_regmap_config);
>  	if (IS_ERR(dphy->regs)) {
> -		dev_err(dsi->dev, "Couldn't create the DPHY encoder regmap\n");
> +		dev_err(&pdev->dev, "Couldn't create the DPHY encoder regmap\n");
>  		return PTR_ERR(dphy->regs);
>  	}
>  
> -	dphy->reset = of_reset_control_get_shared(node, NULL);
> +	dphy->reset = devm_reset_control_get_shared(&pdev->dev, NULL);
>  	if (IS_ERR(dphy->reset)) {
> -		dev_err(dsi->dev, "Couldn't get our reset line\n");
> +		dev_err(&pdev->dev, "Couldn't get our reset line\n");
>  		return PTR_ERR(dphy->reset);
>  	}
>  
> -	dphy->bus_clk = of_clk_get_by_name(node, "bus");
> -	if (IS_ERR(dphy->bus_clk)) {
> -		dev_err(dsi->dev, "Couldn't get the DPHY bus clock\n");
> -		ret = PTR_ERR(dphy->bus_clk);
> -		goto err_free_reset;
> -	}
> -	regmap_mmio_attach_clk(dphy->regs, dphy->bus_clk);
> -
> -	dphy->mod_clk = of_clk_get_by_name(node, "mod");
> +	dphy->mod_clk = devm_clk_get(&pdev->dev, "mod");
>  	if (IS_ERR(dphy->mod_clk)) {
> -		dev_err(dsi->dev, "Couldn't get the DPHY mod clock\n");
> -		ret = PTR_ERR(dphy->mod_clk);
> -		goto err_free_bus;
> +		dev_err(&pdev->dev, "Couldn't get the DPHY mod clock\n");
> +		return PTR_ERR(dphy->mod_clk);
>  	}
>  
> -	dsi->dphy = dphy;
> +	dphy->phy = devm_phy_create(&pdev->dev, NULL, &sun6i_dphy_ops);
> +	if (IS_ERR(dphy->phy)) {
> +		dev_err(&pdev->dev, "failed to create PHY\n");
> +		return PTR_ERR(dphy->phy);
> +	}
>  
> -	return 0;
> +	phy_set_drvdata(dphy->phy, dphy);
> +	phy_provider = devm_of_phy_provider_register(&pdev->dev, of_phy_simple_xlate);
>  
> -err_free_bus:
> -	regmap_mmio_detach_clk(dphy->regs);
> -	clk_put(dphy->bus_clk);
> -err_free_reset:
> -	reset_control_put(dphy->reset);
> -	return ret;
> +	return PTR_ERR_OR_ZERO(phy_provider);
>  }
>  
> -int sun6i_dphy_remove(struct sun6i_dsi *dsi)
> -{
> -	struct sun6i_dphy *dphy = dsi->dphy;
> -
> -	regmap_mmio_detach_clk(dphy->regs);
> -	clk_put(dphy->mod_clk);
> -	clk_put(dphy->bus_clk);
> -	reset_control_put(dphy->reset);
> +static const struct of_device_id sun6i_dphy_of_table[] = {
> +	{ .compatible = "allwinner,sun6i-a31-mipi-dphy" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, sun6i_dphy_of_table);
> +
> +static struct platform_driver sun6i_dphy_platform_driver = {
> +	.probe		= sun6i_dphy_probe,
> +	.driver		= {
> +		.name		= "sun6i-mipi-dphy",
> +		.of_match_table	= sun6i_dphy_of_table,
> +	},
> +};
> +module_platform_driver(sun6i_dphy_platform_driver);
>  
> -	return 0;
> -}
> +MODULE_AUTHOR("Maxime Ripard <maxime.ripard@bootlin>");
> +MODULE_DESCRIPTION("Allwinner A31 MIPI D-PHY Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
> index e3b34a345546..7bbce7708265 100644
> --- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
> +++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.c
> @@ -16,6 +16,7 @@
>  #include <linux/slab.h>
>  
>  #include <linux/phy/phy.h>
> +#include <linux/phy/phy-mipi-dphy.h>
>  
>  #include <drm/drmP.h>
>  #include <drm/drm_atomic_helper.h>
> @@ -616,6 +617,8 @@ static void sun6i_dsi_encoder_enable(struct drm_encoder *encoder)
>  	struct drm_display_mode *mode = &encoder->crtc->state->adjusted_mode;
>  	struct sun6i_dsi *dsi = encoder_to_sun6i_dsi(encoder);
>  	struct mipi_dsi_device *device = dsi->device;
> +	union phy_configure_opts opts = { 0 };
> +	struct phy_configure_opts_mipi_dphy *cfg = &opts.mipi_dphy;
>  	u16 delay;
>  
>  	DRM_DEBUG_DRIVER("Enabling DSI output\n");
> @@ -634,8 +637,15 @@ static void sun6i_dsi_encoder_enable(struct drm_encoder *encoder)
>  	sun6i_dsi_setup_format(dsi, mode);
>  	sun6i_dsi_setup_timings(dsi, mode);
>  
> -	sun6i_dphy_init(dsi->dphy, device->lanes);
> -	sun6i_dphy_power_on(dsi->dphy, device->lanes);
> +	phy_init(dsi->dphy);
> +
> +	phy_mipi_dphy_get_default_config(mode->clock * 1000,
> +					 mipi_dsi_pixel_format_to_bpp(device->format),
> +					 device->lanes, cfg);
> +
> +	phy_set_mode(dsi->dphy, PHY_MODE_MIPI_DPHY);
> +	phy_configure(dsi->dphy, &opts);
> +	phy_power_on(dsi->dphy);
>  
>  	if (!IS_ERR(dsi->panel))
>  		drm_panel_prepare(dsi->panel);
> @@ -673,8 +683,8 @@ static void sun6i_dsi_encoder_disable(struct drm_encoder *encoder)
>  		drm_panel_unprepare(dsi->panel);
>  	}
>  
> -	sun6i_dphy_power_off(dsi->dphy);
> -	sun6i_dphy_exit(dsi->dphy);
> +	phy_power_off(dsi->dphy);
> +	phy_exit(dsi->dphy);
>  
>  	pm_runtime_put(dsi->dev);
>  }
> @@ -967,7 +977,6 @@ static const struct component_ops sun6i_dsi_ops = {
>  static int sun6i_dsi_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> -	struct device_node *dphy_node;
>  	struct sun6i_dsi *dsi;
>  	struct resource *res;
>  	void __iomem *base;
> @@ -1013,10 +1022,8 @@ static int sun6i_dsi_probe(struct platform_device *pdev)
>  	 */
>  	clk_set_rate_exclusive(dsi->mod_clk, 297000000);
>  
> -	dphy_node = of_parse_phandle(dev->of_node, "phys", 0);
> -	ret = sun6i_dphy_probe(dsi, dphy_node);
> -	of_node_put(dphy_node);
> -	if (ret) {
> +	dsi->dphy = devm_phy_get(dev, "dphy");
> +	if (IS_ERR(dsi->dphy)) {
>  		dev_err(dev, "Couldn't get the MIPI D-PHY\n");
>  		goto err_unprotect_clk;
>  	}
> @@ -1026,7 +1033,7 @@ static int sun6i_dsi_probe(struct platform_device *pdev)
>  	ret = mipi_dsi_host_register(&dsi->host);
>  	if (ret) {
>  		dev_err(dev, "Couldn't register MIPI-DSI host\n");
> -		goto err_remove_phy;
> +		goto err_pm_disable;
>  	}
>  
>  	ret = component_add(&pdev->dev, &sun6i_dsi_ops);
> @@ -1039,9 +1046,8 @@ static int sun6i_dsi_probe(struct platform_device *pdev)
>  
>  err_remove_dsi_host:
>  	mipi_dsi_host_unregister(&dsi->host);
> -err_remove_phy:
> +err_pm_disable:
>  	pm_runtime_disable(dev);
> -	sun6i_dphy_remove(dsi);
>  err_unprotect_clk:
>  	clk_rate_exclusive_put(dsi->mod_clk);
>  	return ret;
> @@ -1055,7 +1061,6 @@ static int sun6i_dsi_remove(struct platform_device *pdev)
>  	component_del(&pdev->dev, &sun6i_dsi_ops);
>  	mipi_dsi_host_unregister(&dsi->host);
>  	pm_runtime_disable(dev);
> -	sun6i_dphy_remove(dsi);
>  	clk_rate_exclusive_put(dsi->mod_clk);
>  
>  	return 0;
> diff --git a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
> index dbbc5b3ecbda..a07090579f84 100644
> --- a/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
> +++ b/drivers/gpu/drm/sun4i/sun6i_mipi_dsi.h
> @@ -13,13 +13,6 @@
>  #include <drm/drm_encoder.h>
>  #include <drm/drm_mipi_dsi.h>
>  
> -struct sun6i_dphy {
> -	struct clk		*bus_clk;
> -	struct clk		*mod_clk;
> -	struct regmap		*regs;
> -	struct reset_control	*reset;
> -};
> -
>  struct sun6i_dsi {
>  	struct drm_connector	connector;
>  	struct drm_encoder	encoder;
> @@ -29,7 +22,7 @@ struct sun6i_dsi {
>  	struct clk		*mod_clk;
>  	struct regmap		*regs;
>  	struct reset_control	*reset;
> -	struct sun6i_dphy	*dphy;
> +	struct phy		*dphy;
>  
>  	struct device		*dev;
>  	struct sun4i_drv	*drv;
> @@ -52,12 +45,4 @@ static inline struct sun6i_dsi *encoder_to_sun6i_dsi(const struct drm_encoder *e
>  	return container_of(encoder, struct sun6i_dsi, encoder);
>  };
>  
> -int sun6i_dphy_probe(struct sun6i_dsi *dsi, struct device_node *node);
> -int sun6i_dphy_remove(struct sun6i_dsi *dsi);
> -
> -int sun6i_dphy_init(struct sun6i_dphy *dphy, unsigned int lanes);
> -int sun6i_dphy_power_on(struct sun6i_dphy *dphy, unsigned int lanes);
> -int sun6i_dphy_power_off(struct sun6i_dphy *dphy);
> -int sun6i_dphy_exit(struct sun6i_dphy *dphy);
> -
>  #endif /* _SUN6I_MIPI_DSI_H_ */
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

