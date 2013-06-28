Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:58347 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab3F1GSu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 02:18:50 -0400
Message-id: <51CD2ACA.1000109@samsung.com>
Date: Fri, 28 Jun 2013 15:18:50 +0900
From: Donghwa Lee <dh09.lee@samsung.com>
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	kgene.kim@samsung.com, devicetree-discuss@lists.ozlabs.org,
	jg1.han@samsung.com, balbi@ti.com, kishon@ti.com,
	inki.dae@samsung.com, kyungmin.park@samsung.com,
	plagnioj@jcrosoft.com, t.figa@samsung.com,
	linux-media@vger.kernel.org, dh09.lee@samsung.com
Subject: Re: [PATCH v3 3/5] video: exynos_mipi_dsim: Use the generic PHY driver
References: <1372258946-15607-1-git-send-email-s.nawrocki@samsung.com>
 <1372258946-15607-4-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372258946-15607-4-git-send-email-s.nawrocki@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2013 00:02, Sylwester Nawrocki wrote:
> Use the generic PHY API instead of the platform callback to control
> the MIPI DSIM DPHY. The 'phy_label' field is added to the platform
> data structure to allow PHY lookup on non-dt platforms.
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> ---
>   drivers/video/exynos/exynos_mipi_dsi.c |   18 +++++++++---------
>   include/video/exynos_mipi_dsim.h       |    6 ++++--
>   2 files changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/video/exynos/exynos_mipi_dsi.c b/drivers/video/exynos/exynos_mipi_dsi.c
> index 32e5406..1f96004 100644
> --- a/drivers/video/exynos/exynos_mipi_dsi.c
> +++ b/drivers/video/exynos/exynos_mipi_dsi.c
> @@ -156,8 +156,7 @@ static int exynos_mipi_dsi_blank_mode(struct mipi_dsim_device *dsim, int power)
>   		exynos_mipi_regulator_enable(dsim);
>   
>   		/* enable MIPI-DSI PHY. */
> -		if (dsim->pd->phy_enable)
> -			dsim->pd->phy_enable(pdev, true);
> +		phy_power_on(dsim->phy);
>   
>   		clk_enable(dsim->clock);
>   
> @@ -373,6 +372,10 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
>   		return ret;
>   	}
>   
> +	dsim->phy = devm_phy_get(&pdev->dev, dsim_pd->phy_label);
> +	if (IS_ERR(dsim->phy))
> +		return PTR_ERR(dsim->phy);
> +
>   	dsim->clock = devm_clk_get(&pdev->dev, "dsim0");
>   	if (IS_ERR(dsim->clock)) {
>   		dev_err(&pdev->dev, "failed to get dsim clock source\n");
> @@ -439,8 +442,7 @@ static int exynos_mipi_dsi_probe(struct platform_device *pdev)
>   	exynos_mipi_regulator_enable(dsim);
>   
>   	/* enable MIPI-DSI PHY. */
> -	if (dsim->pd->phy_enable)
> -		dsim->pd->phy_enable(pdev, true);
> +	phy_power_on(dsim->phy);
>   
>   	exynos_mipi_update_cfg(dsim);
>   
> @@ -504,9 +506,8 @@ static int exynos_mipi_dsi_suspend(struct device *dev)
>   	if (client_drv && client_drv->suspend)
>   		client_drv->suspend(client_dev);
>   
> -	/* enable MIPI-DSI PHY. */
> -	if (dsim->pd->phy_enable)
> -		dsim->pd->phy_enable(pdev, false);
> +	/* disable MIPI-DSI PHY. */
> +	phy_power_off(dsim->phy);
>   
>   	clk_disable(dsim->clock);
>   
> @@ -536,8 +537,7 @@ static int exynos_mipi_dsi_resume(struct device *dev)
>   	exynos_mipi_regulator_enable(dsim);
>   
>   	/* enable MIPI-DSI PHY. */
> -	if (dsim->pd->phy_enable)
> -		dsim->pd->phy_enable(pdev, true);
> +	phy_power_on(dsim->phy);
>   
>   	clk_enable(dsim->clock);
>   
> diff --git a/include/video/exynos_mipi_dsim.h b/include/video/exynos_mipi_dsim.h
> index 89dc88a..fd69beb 100644
> --- a/include/video/exynos_mipi_dsim.h
> +++ b/include/video/exynos_mipi_dsim.h
> @@ -216,6 +216,7 @@ struct mipi_dsim_config {
>    *	automatically.
>    * @e_clk_src: select byte clock source.
>    * @pd: pointer to MIPI-DSI driver platform data.
> + * @phy: pointer to the generic PHY
>    */
>   struct mipi_dsim_device {
>   	struct device			*dev;
> @@ -236,6 +237,7 @@ struct mipi_dsim_device {
>   	bool				suspended;
>   
>   	struct mipi_dsim_platform_data	*pd;
> +	struct phy			*phy;
>   };
>   
>   /*
> @@ -248,7 +250,7 @@ struct mipi_dsim_device {
>    * @enabled: indicate whether mipi controller got enabled or not.
>    * @lcd_panel_info: pointer for lcd panel specific structure.
>    *	this structure specifies width, height, timing and polarity and so on.
> - * @phy_enable: pointer to a callback controlling D-PHY enable/reset
> + * @phy_label: the generic PHY label
>    */
>   struct mipi_dsim_platform_data {
>   	char				lcd_panel_name[PANEL_NAME_SIZE];
> @@ -257,7 +259,7 @@ struct mipi_dsim_platform_data {
>   	unsigned int			enabled;
>   	void				*lcd_panel_info;
>   
> -	int (*phy_enable)(struct platform_device *pdev, bool on);
> +	const char 			*phy_label;
>   };
>   
>   /*
I confirmed that this patch operates well. It looks good to me.

Acked-by: Donghwa Lee <dh09.lee@samsung.com>

Thank you,
Donghwa Lee

