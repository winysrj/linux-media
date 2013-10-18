Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f177.google.com ([209.85.128.177]:37971 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab3JREsh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 00:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <524971FC.5030907@xs4all.nl>
References: <1380279558-21651-1-git-send-email-arun.kk@samsung.com>
	<1380279558-21651-10-git-send-email-arun.kk@samsung.com>
	<524971FC.5030907@xs4all.nl>
Date: Fri, 18 Oct 2013 10:18:36 +0530
Message-ID: <CALt3h7-F91rz4xP_2K=WExiKkYbRNW2v=4i2XMiq6LoYgOJ2Nw@mail.gmail.com>
Subject: Re: [PATCH v9 09/13] [media] exynos5-fimc-is: Add the hardware
 pipeline control
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Shaik Ameer Basha <shaik.ameer@samsung.com>,
	kilyeon.im@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Mon, Sep 30, 2013 at 6:13 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 09/27/2013 12:59 PM, Arun Kumar K wrote:
>> This patch adds the crucial hardware pipeline control for the
>> fimc-is driver. All the subdev nodes will call this pipeline
>> interfaces to reach the hardware. Responsibilities of this module
>> involves configuring and maintaining the hardware pipeline involving
>> multiple sub-ips like ISP, DRC, Scalers, ODC, 3DNR, FD etc.
>>
>> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  .../media/platform/exynos5-is/fimc-is-pipeline.c   | 1708 ++++++++++++++++++++
>>  .../media/platform/exynos5-is/fimc-is-pipeline.h   |  129 ++
>>  2 files changed, 1837 insertions(+)
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.c
>>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-pipeline.h
>>
>> diff --git a/drivers/media/platform/exynos5-is/fimc-is-pipeline.c b/drivers/media/platform/exynos5-is/fimc-is-pipeline.c
>> new file mode 100644
>> index 0000000..a73d952
>> --- /dev/null
>> +++ b/drivers/media/platform/exynos5-is/fimc-is-pipeline.c
>
> <snip>
>
>> +int fimc_is_pipeline_open(struct fimc_is_pipeline *pipeline,
>> +                     struct fimc_is_sensor *sensor)
>> +{
>> +     struct fimc_is *is = pipeline->is;
>> +     struct is_region *region;
>> +     unsigned long index[2] = {0};
>> +     int ret;
>> +
>> +     if (!sensor)
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&pipeline->pipe_lock);
>> +
>> +     if (test_bit(PIPELINE_OPEN, &pipeline->state)) {
>> +             dev_err(pipeline->dev, "Pipeline already open\n");
>> +             ret = -EINVAL;
>> +             goto err_exit;
>> +     }
>> +
>> +     pipeline->fcount = 0;
>> +     pipeline->sensor = sensor;
>> +
>> +     if (is->num_pipelines == 0) {
>> +             /* Init memory */
>> +             ret = fimc_is_pipeline_initmem(pipeline);
>> +             if (ret) {
>> +                     dev_err(pipeline->dev, "Pipeline memory init failed\n");
>> +                     goto err_exit;
>> +             }
>> +
>> +             /* Load firmware */
>> +             ret = fimc_is_pipeline_load_firmware(pipeline);
>> +             if (ret) {
>> +                     dev_err(pipeline->dev, "Firmware load failed\n");
>> +                     goto err_fw;
>> +             }
>> +
>> +             /* Power ON */
>> +             ret = fimc_is_pipeline_power(pipeline, 1);
>> +             if (ret) {
>> +                     dev_err(pipeline->dev, "A5 power on failed\n");
>> +                     goto err_fw;
>> +             }
>> +
>> +             /* Wait for FW Init to complete */
>> +             ret = fimc_is_itf_wait_init_state(&is->interface);
>> +             if (ret) {
>> +                     dev_err(pipeline->dev, "FW init failed\n");
>> +                     goto err_fw;
>> +             }
>> +     }
>> +
>> +     /* Open Sensor */
>> +     region = pipeline->is_region;
>> +     ret = fimc_is_itf_open_sensor(&is->interface,
>> +                     pipeline->instance,
>> +                     sensor->drvdata->id,
>> +                     sensor->i2c_bus,
>> +                     pipeline->minfo->shared.paddr);
>> +     if (ret) {
>> +             dev_err(pipeline->dev, "Open sensor failed\n");
>> +             goto err_exit;
>> +     }
>> +
>> +     /* Load setfile */
>> +     ret = fimc_is_pipeline_setfile(pipeline);
>> +     if (ret)
>> +             goto err_exit;
>> +
>> +     /* Stream off */
>> +     ret = fimc_is_itf_stream_off(&is->interface, pipeline->instance);
>> +     if (ret)
>> +             goto err_exit;
>> +
>> +     /* Process off */
>> +     ret = fimc_is_itf_process_off(&is->interface, pipeline->instance);
>> +     if (ret)
>> +             goto err_exit;
>> +
>> +     if (is->num_pipelines == 0) {
>> +             /* Copy init params to FW region */
>> +             memset(&region->parameter, 0x0, sizeof(struct is_param_region));
>> +
>> +             memcpy(&region->parameter.sensor, &init_sensor_param,
>> +                             sizeof(struct sensor_param));
>
> How about:
>
>                 region->parameter.sensor = init_sensor_param;
>
> Shorter and type-safe.
>
> Ditto for the memcpy's below.
>

Yes this would make nicer code.
Will make this change.

Regards
Arun
