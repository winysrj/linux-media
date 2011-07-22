Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44219 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab1GVG0N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 02:26:13 -0400
Message-ID: <4E291800.7060402@gmail.com>
Date: Fri, 22 Jul 2011 11:56:08 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Subject: Re: [PATCH v3 08/19] s5p-fimc: Add the media device driver
References: <1309802110-16682-1-git-send-email-s.nawrocki@samsung.com> <1309802110-16682-9-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1309802110-16682-9-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On 07/04/2011 11:24 PM, Sylwester Nawrocki wrote:
> The fimc media device driver is hooked onto "s5p-fimc-md" platform device.
> Such a platform device need to be added in a board initialization code
> and then camera sensors need to be specified as it's platform data.
> The "s5p-fimc-md" device is a top level entity for all FIMC, mipi-csis
> and sensor devices.
>
> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
>   drivers/media/video/Kconfig                 |    2 +-
>   drivers/media/video/s5p-fimc/Makefile       |    2 +-
...
>
>   /* -----------------------------------------------------*/
>   /* fimc-capture.c					*/
> diff --git a/drivers/media/video/s5p-fimc/fimc-mdevice.c b/drivers/media/video/s5p-fimc/fimc-mdevice.c
> new file mode 100644
> index 0000000..10c8d5d
> --- /dev/null
> +++ b/drivers/media/video/s5p-fimc/fimc-mdevice.c
> @@ -0,0 +1,804 @@
...
> +
> +static int fimc_md_register_sensor_entities(struct fimc_md *fmd)
> +{
> +	struct s5p_platform_fimc *pdata = fmd->pdev->dev.platform_data;
> +	struct fimc_dev *fd = NULL;
> +	int num_clients, ret, i;
> +
> +	/*
> +	 * Runtime resume one of the FIMC entities to make sure
> +	 * the sclk_cam clocks are not globally disabled.
> +	 */
> +	for (i = 0; !fd&&  i<  ARRAY_SIZE(fmd->fimc); i++)
> +		if (fmd->fimc[i])
> +			fd = fmd->fimc[i];
> +	if (!fd)
> +		return -ENXIO;
> +	ret = pm_runtime_get_sync(&fd->pdev->dev);
> +	if (ret<  0)
> +		return ret;
> +
> +	WARN_ON(pdata->num_clients>  ARRAY_SIZE(fmd->sensor));
> +	num_clients = min_t(u32, pdata->num_clients, ARRAY_SIZE(fmd->sensor));
> +
> +	fmd->num_sensors = num_clients;
> +	for (i = 0; i<  num_clients; i++) {
> +		fmd->sensor[i].pdata =&pdata->isp_info[i];
> +		ret = __fimc_md_set_camclk(fmd,&fmd->sensor[i], true);
> +		if (ret)
> +			break;
> +		fmd->sensor[i].subdev =
> +			fimc_md_register_sensor(fmd,&fmd->sensor[i]);

There is an issue here. Function fimc_md_register_sensor(), can return 
subdev, as also error codes when i2c_get_adapter() or NULL when 
v4l2_i2c_new_subdev_board() fail. But we do not invalidate, and assume 
the return value is valid subdev. It will cause kernel NULL pointer 
exception later in fimc_md_create_links().

> +		ret = __fimc_md_set_camclk(fmd,&fmd->sensor[i], false);
> +		if (ret)
> +			break;
> +	}
> +	pm_runtime_put(&fd->pdev->dev);
> +	return ret;
> +}
> +
> +/*
> + * MIPI CSIS and FIMC platform devices registration.
> + */

Regards,
Subash
SISO-SLG
