Return-path: <linux-media-owner@vger.kernel.org>
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:39434 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752245AbdIHL6c (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 07:58:32 -0400
Subject: Re: [PATCH v3 3/6] drm/exynos/gsc: Add hardware rotation limits
To: Hoegeun Kwon <hoegeun.kwon@samsung.com>, inki.dae@samsung.com,
        airlied@linux.ie, kgene@kernel.org, krzk@kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com,
        will.deacon@arm.com, mchehab@kernel.org, s.nawrocki@samsung.com,
        m.szyprowski@samsung.com
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        a.hajda@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
References: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
 <CGME20170908060308epcas1p3016314e10d2ba9fb5129cd2b398086f4@epcas1p3.samsung.com>
 <1504850560-27950-4-git-send-email-hoegeun.kwon@samsung.com>
From: Robin Murphy <robin.murphy@arm.com>
Message-ID: <a4f3bd0b-d733-79ec-b724-2de0e0d4aab7@arm.com>
Date: Fri, 8 Sep 2017 12:58:27 +0100
MIME-Version: 1.0
In-Reply-To: <1504850560-27950-4-git-send-email-hoegeun.kwon@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/09/17 07:02, Hoegeun Kwon wrote:
> The gscaler has hardware rotation limits that need to be hardcoded
> into driver. Distinguish them and add them to the property list.
> 
> The hardware rotation limits are related to the cropped source size.
> When swap occurs, use rot_max size instead of crop_max size.
> 
> Also the scaling limits are related to pos size, use pos size to check
> the limits.
> 
> Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_gsc.c | 93 +++++++++++++++++++++++----------
>  include/uapi/drm/exynos_drm.h           |  2 +
>  2 files changed, 66 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_gsc.c b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
> index 0506b2b..a4fb347 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_gsc.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_gsc.c
> @@ -17,6 +17,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/mfd/syscon.h>
>  #include <linux/regmap.h>
> +#include <linux/of_device.h>
>  
>  #include <drm/drmP.h>
>  #include <drm/exynos_drm.h>
> @@ -150,6 +151,15 @@ struct gsc_context {
>  	bool	suspended;
>  };
>  
> +/*
> + * struct gsc_driverdata - per device type driver data for init time.
> + *
> + * @rot_max: rotation max resolution.
> + */
> +struct gsc_driverdata {
> +	struct drm_exynos_sz rot_max;
> +};
> +
>  /* 8-tap Filter Coefficient */
>  static const int h_coef_8t[GSC_COEF_RATIO][GSC_COEF_ATTR][GSC_COEF_H_8T] = {
>  	{	/* Ratio <= 65536 (~8:8) */
> @@ -1401,6 +1411,23 @@ static int gsc_ippdrv_check_property(struct device *dev,
>  	bool swap;
>  	int i;
>  
> +	config = &property->config[EXYNOS_DRM_OPS_DST];
> +
> +	/* check for degree */
> +	switch (config->degree) {
> +	case EXYNOS_DRM_DEGREE_90:
> +	case EXYNOS_DRM_DEGREE_270:
> +		swap = true;
> +		break;
> +	case EXYNOS_DRM_DEGREE_0:
> +	case EXYNOS_DRM_DEGREE_180:
> +		swap = false;
> +		break;
> +	default:
> +		DRM_ERROR("invalid degree.\n");
> +		goto err_property;
> +	}
> +
>  	for_each_ipp_ops(i) {
>  		if ((i == EXYNOS_DRM_OPS_SRC) &&
>  			(property->cmd == IPP_CMD_WB))
> @@ -1416,21 +1443,6 @@ static int gsc_ippdrv_check_property(struct device *dev,
>  			goto err_property;
>  		}
>  
> -		/* check for degree */
> -		switch (config->degree) {
> -		case EXYNOS_DRM_DEGREE_90:
> -		case EXYNOS_DRM_DEGREE_270:
> -			swap = true;
> -			break;
> -		case EXYNOS_DRM_DEGREE_0:
> -		case EXYNOS_DRM_DEGREE_180:
> -			swap = false;
> -			break;
> -		default:
> -			DRM_ERROR("invalid degree.\n");
> -			goto err_property;
> -		}
> -
>  		/* check for buffer bound */
>  		if ((pos->x + pos->w > sz->hsize) ||
>  			(pos->y + pos->h > sz->vsize)) {
> @@ -1438,21 +1450,27 @@ static int gsc_ippdrv_check_property(struct device *dev,
>  			goto err_property;
>  		}
>  
> +		/*
> +		 * The rotation hardware limits are related to the cropped
> +		 * source size. So use rot_max size to check the limits when
> +		 * swap happens. And also the scaling limits are related to pos
> +		 * size, use pos size to check the limits.
> +		 */
>  		/* check for crop */
>  		if ((i == EXYNOS_DRM_OPS_SRC) && (pp->crop)) {
>  			if (swap) {
>  				if ((pos->h < pp->crop_min.hsize) ||
> -					(sz->vsize > pp->crop_max.hsize) ||
> +					(pos->h > pp->rot_max.hsize) ||
>  					(pos->w < pp->crop_min.vsize) ||
> -					(sz->hsize > pp->crop_max.vsize)) {
> +					(pos->w > pp->rot_max.vsize)) {
>  					DRM_ERROR("out of crop size.\n");
>  					goto err_property;
>  				}
>  			} else {
>  				if ((pos->w < pp->crop_min.hsize) ||
> -					(sz->hsize > pp->crop_max.hsize) ||
> +					(pos->w > pp->crop_max.hsize) ||
>  					(pos->h < pp->crop_min.vsize) ||
> -					(sz->vsize > pp->crop_max.vsize)) {
> +					(pos->h > pp->crop_max.vsize)) {
>  					DRM_ERROR("out of crop size.\n");
>  					goto err_property;
>  				}
> @@ -1463,17 +1481,17 @@ static int gsc_ippdrv_check_property(struct device *dev,
>  		if ((i == EXYNOS_DRM_OPS_DST) && (pp->scale)) {
>  			if (swap) {
>  				if ((pos->h < pp->scale_min.hsize) ||
> -					(sz->vsize > pp->scale_max.hsize) ||
> +					(pos->h > pp->scale_max.hsize) ||
>  					(pos->w < pp->scale_min.vsize) ||
> -					(sz->hsize > pp->scale_max.vsize)) {
> +					(pos->w > pp->scale_max.vsize)) {
>  					DRM_ERROR("out of scale size.\n");
>  					goto err_property;
>  				}
>  			} else {
>  				if ((pos->w < pp->scale_min.hsize) ||
> -					(sz->hsize > pp->scale_max.hsize) ||
> +					(pos->w > pp->scale_max.hsize) ||
>  					(pos->h < pp->scale_min.vsize) ||
> -					(sz->vsize > pp->scale_max.vsize)) {
> +					(pos->h > pp->scale_max.vsize)) {
>  					DRM_ERROR("out of scale size.\n");
>  					goto err_property;
>  				}
> @@ -1657,12 +1675,34 @@ static void gsc_ippdrv_stop(struct device *dev, enum drm_exynos_ipp_cmd cmd)
>  	gsc_write(cfg, GSC_ENABLE);
>  }
>  
> +static struct gsc_driverdata gsc_exynos5250_drvdata = {
> +	.rot_max = { 2048, 2048 },
> +};
> +
> +static struct gsc_driverdata gsc_exynos5420_drvdata = {
> +	.rot_max = { 2016, 2016 },
> +};
> +
> +static const struct of_device_id exynos_drm_gsc_of_match[] = {
> +	{
> +		.compatible = "samsung,exynos5250-gsc",
> +		.data = &gsc_exynos5250_drvdata,
> +	},
> +	{
> +		.compatible = "samsung,exynos5420-gsc",
> +		.data = &gsc_exynos5420_drvdata,
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, exynos_drm_gsc_of_match);
> +
>  static int gsc_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
>  	struct gsc_context *ctx;
>  	struct resource *res;
>  	struct exynos_drm_ippdrv *ippdrv;
> +	const struct gsc_driverdata *drv_data = of_device_get_match_data(dev);
>  	int ret;
>  
>  	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
> @@ -1722,6 +1762,7 @@ static int gsc_probe(struct platform_device *pdev)
>  		dev_err(dev, "failed to init property list.\n");
>  		return ret;
>  	}
> +	ctx->ippdrv.prop_list.rot_max = drv_data->rot_max;
>  
>  	DRM_DEBUG_KMS("id[%d]ippdrv[%pK]\n", ctx->id, ippdrv);
>  
> @@ -1784,12 +1825,6 @@ static int __maybe_unused gsc_runtime_resume(struct device *dev)
>  	SET_RUNTIME_PM_OPS(gsc_runtime_suspend, gsc_runtime_resume, NULL)
>  };
>  
> -static const struct of_device_id exynos_drm_gsc_of_match[] = {
> -	{ .compatible = "samsung,exynos5-gsc" },
> -	{ },
> -};
> -MODULE_DEVICE_TABLE(of, exynos_drm_gsc_of_match);

As Krzysztof noted, this breaks compatibility with existing DTBs, and
not everyone wants to update their firmware in lock-step with their
kernel. That said, as far as I can see there's little need to remove it
anyway - as long as there is some set of lowest-common-denominator
limits that will work on any hardware variant, there doesn't seem to be
much harm in keeping a generic fallback around indefinitely.

Robin.

> -
>  struct platform_driver gsc_driver = {
>  	.probe		= gsc_probe,
>  	.remove		= gsc_remove,
> diff --git a/include/uapi/drm/exynos_drm.h b/include/uapi/drm/exynos_drm.h
> index cb3e9f9..d5d5518 100644
> --- a/include/uapi/drm/exynos_drm.h
> +++ b/include/uapi/drm/exynos_drm.h
> @@ -192,6 +192,7 @@ enum drm_exynos_planer {
>   * @crop_max: crop max resolution.
>   * @scale_min: scale min resolution.
>   * @scale_max: scale max resolution.
> + * @rot_max: rotation max resolution.
>   */
>  struct drm_exynos_ipp_prop_list {
>  	__u32	version;
> @@ -210,6 +211,7 @@ struct drm_exynos_ipp_prop_list {
>  	struct drm_exynos_sz	crop_max;
>  	struct drm_exynos_sz	scale_min;
>  	struct drm_exynos_sz	scale_max;
> +	struct drm_exynos_sz	rot_max;
>  };
>  
>  /**
> 
