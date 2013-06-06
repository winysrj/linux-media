Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:36788 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3FFGjC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Jun 2013 02:39:02 -0400
Received: by mail-oa0-f48.google.com with SMTP id i4so1878796oah.21
        for <linux-media@vger.kernel.org>; Wed, 05 Jun 2013 23:39:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370005408-10853-6-git-send-email-arun.kk@samsung.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-6-git-send-email-arun.kk@samsung.com>
Date: Thu, 6 Jun 2013 12:09:01 +0530
Message-ID: <CAK9yfHyaAAxg7b0HocGCAQEGSF0iH8JJhMp4mbw=Rx1_z8fchQ@mail.gmail.com>
Subject: Re: [RFC v2 05/10] exynos5-fimc-is: Adds the sensor subdev
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31 May 2013 18:33, Arun Kumar K <arun.kk@samsung.com> wrote:
> FIMC-IS uses certain sensors which are exclusively controlled
> from the IS firmware. This patch adds the sensor subdev for the
> fimc-is sensors.
>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> ---
>  drivers/media/platform/exynos5-is/fimc-is-sensor.c |  463 ++++++++++++++++++++
>  drivers/media/platform/exynos5-is/fimc-is-sensor.h |  168 +++++++
>  2 files changed, 631 insertions(+)
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-sensor.h
>
[snip]

> +static int sensor_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +       struct fimc_is_sensor *sensor = sd_to_fimc_is_sensor(sd);
> +       int ret;
> +
> +       if (enable) {
> +               pr_debug("Stream ON\n");
> +               /* Open pipeline */
> +               ret = fimc_is_pipeline_open(sensor->pipeline, sensor);
> +               if (ret < 0) {
> +                       pr_err("Pipeline already opened.\n");
> +                       return -EBUSY;

why not propogate 'ret'? Same for other instances below.

> +               }
> +
> +               /* Start IS pipeline */
> +               ret = fimc_is_pipeline_start(sensor->pipeline);
> +               if (ret < 0) {
> +                       pr_err("Pipeline start failed.\n");
> +                       return -EINVAL;
> +               }
> +       } else {
> +               pr_debug("Stream OFF\n");
> +               /* Stop IS pipeline */
> +               ret = fimc_is_pipeline_stop(sensor->pipeline);
> +               if (ret < 0) {
> +                       pr_err("Pipeline stop failed.\n");
> +                       return -EINVAL;
> +               }
> +
> +               /* Close pipeline */
> +               ret = fimc_is_pipeline_close(sensor->pipeline);
> +               if (ret < 0) {
> +                       pr_err("Pipeline close failed\n");
> +                       return -EBUSY;
> +               }
> +       }
> +
> +       return 0;
> +}
> +

[snip]

> +
> +static int fimc_is_sensor_probe(struct i2c_client *client,
> +                               const struct i2c_device_id *id)
> +{
> +       struct device *dev = &client->dev;
> +       struct fimc_is_sensor *sensor;
> +       const struct of_device_id *of_id;
> +       struct v4l2_subdev *sd;
> +       int gpio, ret;
> +       unsigned int sensor_id;
> +
> +       sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
> +       if (!sensor)
> +               return -ENOMEM;
> +
> +       sensor->gpio_reset = -EINVAL;
> +
> +       gpio = of_get_gpio_flags(dev->of_node, 0, NULL);
> +       if (gpio_is_valid(gpio)) {
> +               ret = gpio_request_one(gpio, GPIOF_OUT_INIT_LOW, DRIVER_NAME);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +       pr_err("GPIO Request success : %d", gpio);
> +       sensor->gpio_reset = gpio;
> +
> +       of_id = of_match_node(fimc_is_sensor_of_match, dev->of_node);
> +       if (!of_id) {
> +               ret = -ENODEV;
> +               goto err_gpio;
> +       }
> +
> +       sensor->drvdata = (struct fimc_is_sensor_drv_data *) of_id->data;
> +       sensor->dev = dev;
> +
> +       /* Get FIMC-IS context */
> +       ret = sensor_parse_dt(sensor, dev->of_node);
> +       if (ret) {
> +               pr_err("Unable to obtain IS context\n");
> +               ret = -ENODEV;

Why not propagate 'ret' itself?


-- 
With warm regards,
Sachin
