Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1102 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3I3MoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 08:44:14 -0400
Message-ID: <524971FC.5030907@xs4all.nl>
Date: Mon, 30 Sep 2013 14:43:40 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	swarren@wwwdotorg.org, mark.rutland@arm.com, Pawel.Moll@arm.com,
	galak@codeaurora.org, a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH v9 09/13] [media] exynos5-fimc-is: Add the hardware pipeline
 control
References: <1380279558-21651-1-git-send-email-arun.kk@samsung.com> <1380279558-21651-10-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1380279558-21651-10-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/2013 12:59 PM, Arun Kumar K wrote:
> This patch adds the crucial hardware pipeline control for the
> fimc-is driver. All the subdev nodes will call this pipeline
> interfaces to reach the hardware. Responsibilities of this module
> involves configuring and maintaining the hardware pipeline involving
> multiple sub-ips like ISP, DRC, Scalers, ODC, 3DNR, FD etc.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1708 ++++++++++++++++++++
>  .../media/platform/exynos5-is/fimc-is-pipeline.h   |  129 ++
>  2 files changed, 1837 insertions(+)
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.h
> 
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-pipeline.c b/drivers/media/platform/exynos5-is/fimc-is-pipeline.c
> new file mode 100644
> index 0000000..a73d952
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-pipeline.c

<snip>

> +int fimc_is_pipeline_open(struct fimc_is_pipeline *pipeline,
> +			struct fimc_is_sensor *sensor)
> +{
> +	struct fimc_is *is = pipeline->is;
> +	struct is_region *region;
> +	unsigned long index[2] = {0};
> +	int ret;
> +
> +	if (!sensor)
> +		return -EINVAL;
> +
> +	mutex_lock(&pipeline->pipe_lock);
> +
> +	if (test_bit(PIPELINE_OPEN, &pipeline->state)) {
> +		dev_err(pipeline->dev, "Pipeline already open\n");
> +		ret = -EINVAL;
> +		goto err_exit;
> +	}
> +
> +	pipeline->fcount = 0;
> +	pipeline->sensor = sensor;
> +
> +	if (is->num_pipelines == 0) {
> +		/* Init memory */
> +		ret = fimc_is_pipeline_initmem(pipeline);
> +		if (ret) {
> +			dev_err(pipeline->dev, "Pipeline memory init failed\n");
> +			goto err_exit;
> +		}
> +
> +		/* Load firmware */
> +		ret = fimc_is_pipeline_load_firmware(pipeline);
> +		if (ret) {
> +			dev_err(pipeline->dev, "Firmware load failed\n");
> +			goto err_fw;
> +		}
> +
> +		/* Power ON */
> +		ret = fimc_is_pipeline_power(pipeline, 1);
> +		if (ret) {
> +			dev_err(pipeline->dev, "A5 power on failed\n");
> +			goto err_fw;
> +		}
> +
> +		/* Wait for FW Init to complete */
> +		ret = fimc_is_itf_wait_init_state(&is->interface);
> +		if (ret) {
> +			dev_err(pipeline->dev, "FW init failed\n");
> +			goto err_fw;
> +		}
> +	}
> +
> +	/* Open Sensor */
> +	region = pipeline->is_region;
> +	ret = fimc_is_itf_open_sensor(&is->interface,
> +			pipeline->instance,
> +			sensor->drvdata->id,
> +			sensor->i2c_bus,
> +			pipeline->minfo->shared.paddr);
> +	if (ret) {
> +		dev_err(pipeline->dev, "Open sensor failed\n");
> +		goto err_exit;
> +	}
> +
> +	/* Load setfile */
> +	ret = fimc_is_pipeline_setfile(pipeline);
> +	if (ret)
> +		goto err_exit;
> +
> +	/* Stream off */
> +	ret = fimc_is_itf_stream_off(&is->interface, pipeline->instance);
> +	if (ret)
> +		goto err_exit;
> +
> +	/* Process off */
> +	ret = fimc_is_itf_process_off(&is->interface, pipeline->instance);
> +	if (ret)
> +		goto err_exit;
> +
> +	if (is->num_pipelines == 0) {
> +		/* Copy init params to FW region */
> +		memset(&region->parameter, 0x0, sizeof(struct is_param_region));
> +
> +		memcpy(&region->parameter.sensor, &init_sensor_param,
> +				sizeof(struct sensor_param));

How about:

		region->parameter.sensor = init_sensor_param;

Shorter and type-safe.

Ditto for the memcpy's below.

> +		memcpy(&region->parameter.isp, &init_isp_param,
> +				sizeof(struct isp_param));
> +		memcpy(&region->parameter.drc, &init_drc_param,
> +				sizeof(struct drc_param));
> +		memcpy(&region->parameter.scalerc, &init_scalerc_param,
> +				sizeof(struct scalerc_param));
> +		memcpy(&region->parameter.odc, &init_odc_param,
> +				sizeof(struct odc_param));
> +		memcpy(&region->parameter.dis, &init_dis_param,
> +				sizeof(struct dis_param));
> +		memcpy(&region->parameter.tdnr, &init_tdnr_param,
> +				sizeof(struct tdnr_param));
> +		memcpy(&region->parameter.scalerp, &init_scalerp_param,
> +				sizeof(struct scalerp_param));
> +		memcpy(&region->parameter.fd, &init_fd_param,
> +				sizeof(struct fd_param));
> +		wmb();
> +
> +		/* Set all init params to FW */
> +		index[0] = 0xffffffff;
> +		index[1] = 0xffffffff;
> +		ret = fimc_is_itf_set_param(&is->interface, pipeline->instance,
> +				index[0], index[1]);
> +		if (ret) {
> +			dev_err(pipeline->dev, "%s failed\n", __func__);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	/* Set state to OPEN */
> +	set_bit(PIPELINE_OPEN, &pipeline->state);
> +	is->num_pipelines++;
> +
> +	mutex_unlock(&pipeline->pipe_lock);
> +	return 0;
> +
> +err_fw:
> +	fimc_is_pipeline_freemem(pipeline);
> +err_exit:
> +	mutex_unlock(&pipeline->pipe_lock);
> +	return ret;
> +}

Regards,

	Hans

