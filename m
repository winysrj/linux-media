Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:18512 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABT7D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 14:59:03 -0500
Date: Thu, 02 Jan 2014 17:58:56 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/6] exynos4-is: Add clock provider for the external
 clocks
Message-id: <20140102175856.36f57ffb@samsung.com>
In-reply-to: <1382033211-32329-5-git-send-email-s.nawrocki@samsung.com>
References: <1382033211-32329-1-git-send-email-s.nawrocki@samsung.com>
 <1382033211-32329-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 17 Oct 2013 20:06:49 +0200
Sylwester Nawrocki <s.nawrocki@samsung.com> escreveu:

> This patch adds clock provider to expose the sclk_cam0/1 clocks
> for external image sensor devices.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since v2:
>  - use 'camera' DT node drirectly as clock provider node, rather than
>   creating additional clock-controller child node.
> ---
>  .../devicetree/bindings/media/samsung-fimc.txt     |   15 ++-
>  drivers/media/platform/exynos4-is/media-dev.c      |  108 ++++++++++++++++++++
>  drivers/media/platform/exynos4-is/media-dev.h      |   18 +++-
>  3 files changed, 137 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> index 96312f6..968e065 100644
> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
> @@ -32,6 +32,15 @@ way around.
>  
>  The 'camera' node must include at least one 'fimc' child node.
>  
> +Optional properties:
> +
> +- #clock-cells: from the common clock bindings (../clock/clock-bindings.txt),
> +  must be 1. A clock provider is associated with the camera node and it should
> +  be referenced by external sensors that use clocks provided by the SoC on
> +  CAM_*_CLKOUT pins. The second cell of the clock specifier is a clock's index.
> +  The indexes are 0, 1 for CAM_A_CLKOUT, CAM_B_CLKOUT clocks respectively.
> +
> +
>  'fimc' device nodes
>  -------------------
>  
> @@ -114,7 +123,7 @@ Example:
>  			vddio-supply = <...>;
>  
>  			clock-frequency = <24000000>;
> -			clocks = <...>;
> +			clocks = <&camera 1>;
>  			clock-names = "mclk";
>  
>  			port {
> @@ -135,7 +144,7 @@ Example:
>  			vddio-supply = <...>;
>  
>  			clock-frequency = <24000000>;
> -			clocks = <...>;
> +			clocks = <&camera 0>;
>  			clock-names = "mclk";
>  
>  			port {
> @@ -151,8 +160,8 @@ Example:
>  		compatible = "samsung,fimc", "simple-bus";
>  		#address-cells = <1>;
>  		#size-cells = <1>;
> +		#clock-cells = <1>;
>  		status = "okay";
> -
>  		pinctrl-names = "default";
>  		pinctrl-0 = <&cam_port_a_clk_active>;

I didn't see the above on the patch series you sent me on your git pull
request. Where is it?

>  
> diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
> index a835112..d78e3da 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.c
> +++ b/drivers/media/platform/exynos4-is/media-dev.c
> @@ -11,6 +11,8 @@
>   */
>  
>  #include <linux/bug.h>
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
>  #include <linux/device.h>
>  #include <linux/errno.h>
>  #include <linux/i2c.h>
> @@ -1437,6 +1439,101 @@ static int fimc_md_get_pinctrl(struct fimc_md *fmd)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static int cam_clk_prepare(struct clk_hw *hw)
> +{
> +	struct cam_clk *camclk = to_cam_clk(hw);
> +	int ret;
> +
> +	if (camclk->fmd->pmf == NULL)
> +		return -ENODEV;
> +
> +	ret = pm_runtime_get_sync(camclk->fmd->pmf);
> +	return ret < 0 ? ret : 0;
> +}
> +
> +static void cam_clk_unprepare(struct clk_hw *hw)
> +{
> +	struct cam_clk *camclk = to_cam_clk(hw);
> +
> +	if (camclk->fmd->pmf == NULL)
> +		return;
> +
> +	pm_runtime_put_sync(camclk->fmd->pmf);
> +}
> +
> +static const struct clk_ops cam_clk_ops = {
> +	.prepare = cam_clk_prepare,
> +	.unprepare = cam_clk_unprepare,
> +};
> +
> +static const char *cam_clk_p_names[] = { "sclk_cam0", "sclk_cam1" };
> +
> +static void fimc_md_unregister_clk_provider(struct fimc_md *fmd)
> +{
> +	struct cam_clk_provider *cp = &fmd->clk_provider;
> +	unsigned int i;
> +
> +	if (cp->of_node)
> +		of_clk_del_provider(cp->of_node);
> +
> +	for (i = 0; i < ARRAY_SIZE(cp->clks); i++)
> +		if (!IS_ERR(cp->clks[i]))
> +			clk_unregister(cp->clks[i]);

Huh? Why to initialize an array with an error code??? Does it make sense to
have one of the clocks with an error and the others ok, and to store the
error code? The code below doesn't seem to allow that.

Just initialize cp->clks with zero and test it with:

	if (cp->clks[i])
		clk_unregister(cp->clks[i]);

That makes it easier to understand and review.

> +}
> +
> +static int fimc_md_register_clk_provider(struct fimc_md *fmd)
> +{
> +	struct cam_clk_provider *cp = &fmd->clk_provider;
> +	struct device *dev = &fmd->pdev->dev;
> +	int i, ret;
> +
> +	for (i = 0; i < ARRAY_SIZE(cp->clks); i++)
> +		cp->clks[i] = ERR_PTR(-EINVAL);

That looks weird for me, due to several reasons:

1) ARRAY_SIZE(cp->clks) is equal to FIMC_MAX_CAMCLKS. Why are you using
different syntaxes on the first loop and on the next one? Just to loose
more time from reviewers to double check what number is bigger?

2) Why don't you just do:

	memset(cp->clks, ARRAY_SIZE(cp->clks), 0).

or initialize struct fimc_md with kzalloc()?

> +
> +	for (i = 0; i < FIMC_MAX_CAMCLKS; i++) {
> +		struct cam_clk *camclk = &cp->camclk[i];
> +		struct clk_init_data init;
> +		char clk_name[16];
> +		struct clk *clk;
> +
> +		snprintf(clk_name, sizeof(clk_name), "cam_clkout%d", i);
> +
> +		init.name = clk_name;
> +		init.ops = &cam_clk_ops;
> +		init.flags = CLK_SET_RATE_PARENT;
> +		init.parent_names = &cam_clk_p_names[i];
> +		init.num_parents = 1;
> +		camclk->hw.init = &init;
> +		camclk->fmd = fmd;
> +
> +		clk = clk_register(dev, &camclk->hw);
> +		if (IS_ERR(clk)) {
> +			dev_err(dev, "failed to register clock: %s (%ld)\n",
> +						clk_name, PTR_ERR(clk));
> +			ret = PTR_ERR(clk);
> +			goto err;
> +		}
> +		cp->clks[i] = clk;
> +	}
> +
> +	cp->clk_data.clks = cp->clks;
> +	cp->clk_data.clk_num = i;
> +	cp->of_node = dev->of_node;
> +
> +	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
> +				  &cp->clk_data);
> +	if (!ret)
> +		return 0;
> +err:
> +	fimc_md_unregister_clk_provider(fmd);
> +	return ret;
> +}
> +#else
> +#define fimc_md_register_clk_provider(fmd) (0)
> +#define fimc_md_unregister_clk_provider(fmd) (0)
> +#endif
> +
>  static int fimc_md_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> @@ -1464,16 +1561,24 @@ static int fimc_md_probe(struct platform_device *pdev)
>  
>  	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
>  
> +	ret = fimc_md_register_clk_provider(fmd);
> +	if (ret < 0) {
> +		v4l2_err(v4l2_dev, "clock provider registration failed\n");
> +		return ret;
> +	}
> +
>  	ret = v4l2_device_register(dev, &fmd->v4l2_dev);
>  	if (ret < 0) {
>  		v4l2_err(v4l2_dev, "Failed to register v4l2_device: %d\n", ret);
>  		return ret;
>  	}
> +
>  	ret = media_device_register(&fmd->media_dev);
>  	if (ret < 0) {
>  		v4l2_err(v4l2_dev, "Failed to register media device: %d\n", ret);
>  		goto err_md;
>  	}
> +
>  	ret = fimc_md_get_clocks(fmd);
>  	if (ret)
>  		goto err_clk;
> @@ -1507,6 +1612,7 @@ static int fimc_md_probe(struct platform_device *pdev)
>  	ret = fimc_md_create_links(fmd);
>  	if (ret)
>  		goto err_unlock;
> +
>  	ret = v4l2_device_register_subdev_nodes(&fmd->v4l2_dev);
>  	if (ret)
>  		goto err_unlock;
> @@ -1527,6 +1633,7 @@ err_clk:
>  	media_device_unregister(&fmd->media_dev);
>  err_md:
>  	v4l2_device_unregister(&fmd->v4l2_dev);
> +	fimc_md_unregister_clk_provider(fmd);
>  	return ret;
>  }
>  
> @@ -1537,6 +1644,7 @@ static int fimc_md_remove(struct platform_device *pdev)
>  	if (!fmd)
>  		return 0;
>  
> +	fimc_md_unregister_clk_provider(fmd);
>  	v4l2_device_unregister(&fmd->v4l2_dev);
>  	device_remove_file(&pdev->dev, &dev_attr_subdev_conf_mode);
>  	fimc_md_unregister_entities(fmd);
> diff --git a/drivers/media/platform/exynos4-is/media-dev.h b/drivers/media/platform/exynos4-is/media-dev.h
> index 62599fd..240ca71 100644
> --- a/drivers/media/platform/exynos4-is/media-dev.h
> +++ b/drivers/media/platform/exynos4-is/media-dev.h
> @@ -10,6 +10,7 @@
>  #define FIMC_MDEVICE_H_
>  
>  #include <linux/clk.h>
> +#include <linux/clk-provider.h>
>  #include <linux/platform_device.h>
>  #include <linux/mutex.h>
>  #include <linux/of.h>
> @@ -89,6 +90,12 @@ struct fimc_sensor_info {
>  	struct fimc_dev *host;
>  };
>  
> +struct cam_clk {
> +	struct clk_hw hw;
> +	struct fimc_md *fmd;
> +};
> +#define to_cam_clk(_hw) container_of(_hw, struct cam_clk, hw)
> +
>  /**
>   * struct fimc_md - fimc media device information
>   * @csis: MIPI CSIS subdevs data
> @@ -105,6 +112,7 @@ struct fimc_sensor_info {
>   * @pinctrl: camera port pinctrl handle
>   * @state_default: pinctrl default state handle
>   * @state_idle: pinctrl idle state handle
> + * @cam_clk_provider: CAMCLK clock provider structure
>   * @user_subdev_api: true if subdevs are not configured by the host driver
>   * @slock: spinlock protecting @sensor array
>   */
> @@ -122,13 +130,21 @@ struct fimc_md {
>  	struct media_device media_dev;
>  	struct v4l2_device v4l2_dev;
>  	struct platform_device *pdev;
> +
>  	struct fimc_pinctrl {
>  		struct pinctrl *pinctrl;
>  		struct pinctrl_state *state_default;
>  		struct pinctrl_state *state_idle;
>  	} pinctl;
> -	bool user_subdev_api;
>  
> +	struct cam_clk_provider {
> +		struct clk *clks[FIMC_MAX_CAMCLKS];
> +		struct clk_onecell_data clk_data;
> +		struct device_node *of_node;
> +		struct cam_clk camclk[FIMC_MAX_CAMCLKS];
> +	} clk_provider;
> +
> +	bool user_subdev_api;
>  	spinlock_t slock;
>  	struct list_head pipelines;
>  };


-- 

Cheers,
Mauro
