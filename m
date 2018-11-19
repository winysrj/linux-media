Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51362 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727059AbeKTAHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 19:07:39 -0500
Date: Mon, 19 Nov 2018 15:43:57 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Maxime Ripard <maxime.ripard@bootlin.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
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
Subject: Re: [PATCH v2 4/9] phy: dphy: Add configuration helpers
Message-ID: <20181119134357.743nskpkqqfkrjux@valkosipuli.retiisi.org.uk>
References: <cover.c2c2ae47383b9dbbdee6b69cafdd7391c06dde4f.1541516029.git-series.maxime.ripard@bootlin.com>
 <4d44460c4ecbd47f4cbd9141c6bf2632b6c21e1e.1541516029.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d44460c4ecbd47f4cbd9141c6bf2632b6c21e1e.1541516029.git-series.maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Maxime,

Apologies for the delayed review. Please see my comments below.

On Tue, Nov 06, 2018 at 03:54:16PM +0100, Maxime Ripard wrote:
> The MIPI D-PHY spec defines default values and boundaries for most of the
> parameters it defines. Introduce helpers to help drivers get meaningful
> values based on their current parameters, and validate the boundaries of
> these parameters if needed.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  drivers/phy/Kconfig               |   8 ++-
>  drivers/phy/Makefile              |   1 +-
>  drivers/phy/phy-core-mipi-dphy.c  | 160 +++++++++++++++++++++++++++++++-
>  include/linux/phy/phy-mipi-dphy.h |   6 +-
>  4 files changed, 175 insertions(+)
>  create mode 100644 drivers/phy/phy-core-mipi-dphy.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 60f949e2a684..c87a7d49eaab 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -15,6 +15,14 @@ config GENERIC_PHY
>  	  phy users can obtain reference to the PHY. All the users of this
>  	  framework should select this config.
>  
> +config GENERIC_PHY_MIPI_DPHY
> +	bool
> +	help
> +	  Generic MIPI D-PHY support.
> +
> +	  Provides a number of helpers a core functions for MIPI D-PHY
> +	  drivers to us.
> +
>  config PHY_LPC18XX_USB_OTG
>  	tristate "NXP LPC18xx/43xx SoC USB OTG PHY driver"
>  	depends on OF && (ARCH_LPC18XX || COMPILE_TEST)
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 0301e25d07c1..baec59cebbab 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -4,6 +4,7 @@
>  #
>  
>  obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
> +obj-$(CONFIG_GENERIC_PHY_MIPI_DPHY)	+= phy-core-mipi-dphy.o
>  obj-$(CONFIG_PHY_LPC18XX_USB_OTG)	+= phy-lpc18xx-usb-otg.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
>  obj-$(CONFIG_PHY_PISTACHIO_USB)		+= phy-pistachio-usb.o
> diff --git a/drivers/phy/phy-core-mipi-dphy.c b/drivers/phy/phy-core-mipi-dphy.c
> new file mode 100644
> index 000000000000..127ca6960084
> --- /dev/null
> +++ b/drivers/phy/phy-core-mipi-dphy.c
> @@ -0,0 +1,160 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2013 NVIDIA Corporation
> + * Copyright (C) 2018 Cadence Design Systems Inc.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/export.h>
> +#include <linux/kernel.h>
> +#include <linux/time64.h>
> +
> +#include <linux/phy/phy.h>
> +#include <linux/phy/phy-mipi-dphy.h>
> +
> +/*
> + * Minimum D-PHY timings based on MIPI D-PHY specification. Derived
> + * from the valid ranges specified in Section 6.9, Table 14, Page 41
> + * of the D-PHY specification (v2.1).

I assume these values are compliant with the earlier spec releases.

> + */
> +int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,

How about using the bus frequency instead of the pixel clock? Chances are
that the caller already has that information, instead of calculating it
here?

> +				     unsigned int bpp,
> +				     unsigned int lanes,
> +				     struct phy_configure_opts_mipi_dphy *cfg)
> +{
> +	unsigned long hs_clk_rate;
> +	unsigned long ui;
> +
> +	if (!cfg)
> +		return -EINVAL;
> +
> +	hs_clk_rate = pixel_clock * bpp / lanes;
> +	ui = DIV_ROUND_UP(NSEC_PER_SEC, hs_clk_rate);

Nanoseconds may not be precise enough for practical computations on these
values. At 1 GHz, this ends up being precisely 1. At least Intel hardware
has some more precision, I presume others do, too. How about using
picoseconds instead?

> +
> +	cfg->clk_miss = 0;
> +	cfg->clk_post = 60 + 52 * ui;
> +	cfg->clk_pre = 8;
> +	cfg->clk_prepare = 38;
> +	cfg->clk_settle = 95;
> +	cfg->clk_term_en = 0;
> +	cfg->clk_trail = 60;
> +	cfg->clk_zero = 262;
> +	cfg->d_term_en = 0;
> +	cfg->eot = 0;
> +	cfg->hs_exit = 100;
> +	cfg->hs_prepare = 40 + 4 * ui;
> +	cfg->hs_zero = 105 + 6 * ui;
> +	cfg->hs_settle = 85 + 6 * ui;
> +	cfg->hs_skip = 40;
> +
> +	/*
> +	 * The MIPI D-PHY specification (Section 6.9, v1.2, Table 14, Page 40)
> +	 * contains this formula as:
> +	 *
> +	 *     T_HS-TRAIL = max(n * 8 * ui, 60 + n * 4 * ui)
> +	 *
> +	 * where n = 1 for forward-direction HS mode and n = 4 for reverse-
> +	 * direction HS mode. There's only one setting and this function does
> +	 * not parameterize on anything other that ui, so this code will
> +	 * assumes that reverse-direction HS mode is supported and uses n = 4.
> +	 */
> +	cfg->hs_trail = max(4 * 8 * ui, 60 + 4 * 4 * ui);
> +
> +	cfg->init = 100000;
> +	cfg->lpx = 60;
> +	cfg->ta_get = 5 * cfg->lpx;
> +	cfg->ta_go = 4 * cfg->lpx;
> +	cfg->ta_sure = 2 * cfg->lpx;
> +	cfg->wakeup = 1000000;
> +
> +	cfg->hs_clk_rate = hs_clk_rate;

How about the LP clock?

Frankly, I have worked with MIPI CSI-2 hardware soon a decade, and the very
few cases where software has needed to deal with these values has been in
form of defaults for a receiver, mostly limiting to clk_settle,
clk_term_en, d_term_en as well as hs_settle. On some hardware, the data
lane specific values can be at least in theory configured separately on
different lanes (but perhaps we could ignore that now).

That doesn't say that it'd be useless to convey these values to the PHY
though. What I'm a little worried about though is what could be the effect
of adding support for this for existing drivers? If you have a new driver,
then there is no chance of regressions.

I can't help noticing that many of the above values end up being unused in
the rest of the patches in the set. I guess that's ok, they come from the
standard anyway and some hardware may need them to be configured.

Then there's the question of where should these values originate from.
Some drivers appear to have a need to obtain one of these values via
firmware, see Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
. I presume the defaults should be applicable to most cases, and specific
values would need to be defined in the firmware. That means that the
defaults have effectively the property of firmware API, meaning that they
effectively can never be changed. That suggests we should be pretty sure
the defaults are something that should work for the widest possible set of
the hardware.

> +	cfg->lanes = lanes;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_mipi_dphy_get_default_config);
> +
> +/*
> + * Validate D-PHY configuration according to MIPI D-PHY specification
> + * (v1.2, Section Section 6.9 "Global Operation Timing Parameters").
> + */
> +int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg)
> +{
> +	unsigned long ui;
> +
> +	if (!cfg)
> +		return -EINVAL;
> +
> +	ui = DIV_ROUND_UP(NSEC_PER_SEC, cfg->hs_clk_rate);
> +
> +	if (cfg->clk_miss > 60)
> +		return -EINVAL;
> +
> +	if (cfg->clk_post < (60 + 52 * ui))

Extra parentheses.

> +		return -EINVAL;
> +
> +	if (cfg->clk_pre < 8)
> +		return -EINVAL;
> +
> +	if (cfg->clk_prepare < 38 || cfg->clk_prepare > 95)
> +		return -EINVAL;
> +
> +	if (cfg->clk_settle < 95 || cfg->clk_settle > 300)
> +		return -EINVAL;
> +
> +	if (cfg->clk_term_en > 38)
> +		return -EINVAL;
> +
> +	if (cfg->clk_trail < 60)
> +		return -EINVAL;
> +
> +	if (cfg->clk_prepare + cfg->clk_zero < 300)
> +		return -EINVAL;
> +
> +	if (cfg->d_term_en > 35 + 4 * ui)
> +		return -EINVAL;
> +
> +	if (cfg->eot > 105 + 12 * ui)
> +		return -EINVAL;
> +
> +	if (cfg->hs_exit < 100)
> +		return -EINVAL;
> +
> +	if (cfg->hs_prepare < 40 + 4 * ui ||
> +	    cfg->hs_prepare > 85 + 6 * ui)
> +		return -EINVAL;
> +
> +	if (cfg->hs_prepare + cfg->hs_zero < 145 + 10 * ui)
> +		return -EINVAL;
> +
> +	if ((cfg->hs_settle < 85 + 6 * ui) ||
> +	    (cfg->hs_settle > 145 + 10 * ui))

Ditto.

> +		return -EINVAL;
> +
> +	if (cfg->hs_skip < 40 || cfg->hs_skip > 55 + 4 * ui)
> +		return -EINVAL;
> +
> +	if (cfg->hs_trail < max(8 * ui, 60 + 4 * ui))
> +		return -EINVAL;
> +
> +	if (cfg->init < 100000)
> +		return -EINVAL;
> +
> +	if (cfg->lpx < 50)
> +		return -EINVAL;
> +
> +	if (cfg->ta_get != 5 * cfg->lpx)
> +		return -EINVAL;
> +
> +	if (cfg->ta_go != 4 * cfg->lpx)
> +		return -EINVAL;
> +
> +	if (cfg->ta_sure < cfg->lpx || cfg->ta_sure > 2 * cfg->lpx)
> +		return -EINVAL;
> +
> +	if (cfg->wakeup < 1000000)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(phy_mipi_dphy_config_validate);
> diff --git a/include/linux/phy/phy-mipi-dphy.h b/include/linux/phy/phy-mipi-dphy.h
> index 0b05932916af..5e3673778afa 100644
> --- a/include/linux/phy/phy-mipi-dphy.h
> +++ b/include/linux/phy/phy-mipi-dphy.h
> @@ -229,4 +229,10 @@ struct phy_configure_opts_mipi_dphy {
>  	unsigned char		lanes;
>  };
>  
> +int phy_mipi_dphy_get_default_config(unsigned long pixel_clock,
> +				     unsigned int bpp,
> +				     unsigned int lanes,
> +				     struct phy_configure_opts_mipi_dphy *cfg);
> +int phy_mipi_dphy_config_validate(struct phy_configure_opts_mipi_dphy *cfg);
> +
>  #endif /* __PHY_MIPI_DPHY_H_ */

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
