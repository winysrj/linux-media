Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:35297 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3FPVPi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jun 2013 17:15:38 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: kishon@ti.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [RFC PATCH 3/5] video: exynos_dsi: Use generic PHY driver
Date: Sun, 16 Jun 2013 23:15:37 +0200
Message-ID: <1502179.yCdHZgQgqV@flatron>
In-Reply-To: <1371231951-1969-4-git-send-email-s.nawrocki@samsung.com>
References: <1371231951-1969-1-git-send-email-s.nawrocki@samsung.com> <1371231951-1969-4-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 14 of June 2013 19:45:49 Sylwester Nawrocki wrote:
> Use the generic PHY API instead of the platform callback to control
> the MIPI DSIM DPHY.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/video/display/source-exynos_dsi.c |   36
> +++++++++-------------------- include/video/exynos_dsi.h               
> |    5 ----
>  2 files changed, 11 insertions(+), 30 deletions(-)

Yes, this is what I was really missing a lot while developing this driver.

Definitely looks good! It's a shame we don't have this driver in mainline 
yet ;) ,

Best regards,
Tomasz

> diff --git a/drivers/video/display/source-exynos_dsi.c
> b/drivers/video/display/source-exynos_dsi.c index 145d57b..dfab790
> 100644
> --- a/drivers/video/display/source-exynos_dsi.c
> +++ b/drivers/video/display/source-exynos_dsi.c
> @@ -24,6 +24,7 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
> +#include <linux/phy/phy.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/regulator/consumer.h>
> @@ -219,6 +220,7 @@ struct exynos_dsi {
>  	bool enabled;
> 
>  	struct platform_device *pdev;
> +	struct phy *phy;
>  	struct device *dev;
>  	struct resource *res;
>  	struct clk *pll_clk;
> @@ -816,6 +818,7 @@ again:
> 
>  static bool exynos_dsi_transfer_finish(struct exynos_dsi *dsi)
>  {
> +	static unsigned long j;
>  	struct exynos_dsi_transfer *xfer;
>  	unsigned long flags;
>  	bool start = true;
> @@ -824,7 +827,8 @@ static bool exynos_dsi_transfer_finish(struct
> exynos_dsi *dsi)
> 
>  	if (list_empty(&dsi->transfer_list)) {
>  		spin_unlock_irqrestore(&dsi->transfer_lock, flags);
> -		dev_warn(dsi->dev, "unexpected TX/RX interrupt\n");
> +		if (printk_timed_ratelimit(&j, 500))
> +			dev_warn(dsi->dev, "unexpected TX/RX 
interrupt\n");
>  		return false;
>  	}
> 
> @@ -994,8 +998,7 @@ static int exynos_dsi_enable(struct video_source
> *src) clk_prepare_enable(dsi->bus_clk);
>  	clk_prepare_enable(dsi->pll_clk);
> 
> -	if (dsi->pd->phy_enable)
> -		dsi->pd->phy_enable(dsi->pdev, true);
> +	phy_power_on(dsi->phy);
> 
>  	exynos_dsi_reset(dsi);
>  	exynos_dsi_init_link(dsi);
> @@ -1019,8 +1022,7 @@ static int exynos_dsi_disable(struct video_source
> *src)
> 
>  	exynos_dsi_disable_clock(dsi);
> 
> -	if (dsi->pd->phy_enable)
> -		dsi->pd->phy_enable(dsi->pdev, false);
> +	phy_power_off(dsi->phy);
> 
>  	clk_disable_unprepare(dsi->pll_clk);
>  	clk_disable_unprepare(dsi->bus_clk);
> @@ -1099,12 +1101,6 @@ static const struct dsi_video_source_ops
> exynos_dsi_ops = { * Device Tree
>   */
> 
> -static int (* const of_phy_enables[])(struct platform_device *, bool) =
> { -#ifdef CONFIG_S5P_SETUP_MIPIPHY
> -	[0] = s5p_dsim_phy_enable,
> -#endif
> -};
> -
>  static struct exynos_dsi_platform_data *exynos_dsi_parse_dt(
>  						struct platform_device 
*pdev)
>  {
> @@ -1112,7 +1108,6 @@ static struct exynos_dsi_platform_data
> *exynos_dsi_parse_dt( struct exynos_dsi_platform_data *dsi_pd;
>  	struct device *dev = &pdev->dev;
>  	const __be32 *prop_data;
> -	u32 val;
> 
>  	dsi_pd = kzalloc(sizeof(*dsi_pd), GFP_KERNEL);
>  	if (!dsi_pd) {
> @@ -1120,19 +1115,6 @@ static struct exynos_dsi_platform_data
> *exynos_dsi_parse_dt( return NULL;
>  	}
> 
> -	prop_data = of_get_property(node, "samsung,phy-type", NULL);
> -	if (!prop_data) {
> -		dev_err(dev, "failed to get phy-type property\n");
> -		goto err_free_pd;
> -	}
> -
> -	val = be32_to_cpu(*prop_data);
> -	if (val >= ARRAY_SIZE(of_phy_enables) || !of_phy_enables[val]) {
> -		dev_err(dev, "Invalid phy-type %u\n", val);
> -		goto err_free_pd;
> -	}
> -	dsi_pd->phy_enable = of_phy_enables[val];
> -
>  	prop_data = of_get_property(node, "samsung,pll-stable-time", 
NULL);
>  	if (!prop_data) {
>  		dev_err(dev, "failed to get pll-stable-time property\n");
> @@ -1254,6 +1236,10 @@ static int exynos_dsi_probe(struct
> platform_device *pdev) return -ENOMEM;
>  	}
> 
> +	dsi->phy = devm_phy_get(&pdev->dev, "dsim");
> +	if (IS_ERR(dsi->phy))
> +		return PTR_ERR(dsi->phy);
> +
>  	platform_set_drvdata(pdev, dsi);
> 
>  	dsi->irq = platform_get_irq(pdev, 0);
> diff --git a/include/video/exynos_dsi.h b/include/video/exynos_dsi.h
> index 95e1568..5c062c7 100644
> --- a/include/video/exynos_dsi.h
> +++ b/include/video/exynos_dsi.h
> @@ -25,9 +25,6 @@
>   */
>  struct exynos_dsi_platform_data {
>  	unsigned int enabled;
> -
> -	int (*phy_enable)(struct platform_device *pdev, bool on);
> -
>  	unsigned int pll_stable_time;
>  	unsigned long pll_clk_rate;
>  	unsigned long esc_clk_rate;
> @@ -36,6 +33,4 @@ struct exynos_dsi_platform_data {
>  	unsigned short rx_timeout;
>  };
> 
> -int s5p_dsim_phy_enable(struct platform_device *pdev, bool on);
> -
>  #endif /* _EXYNOS_MIPI_DSIM_H */
