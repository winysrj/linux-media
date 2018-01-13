Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:37396 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754956AbeAMQJP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Jan 2018 11:09:15 -0500
MIME-Version: 1.0
In-Reply-To: <02ea7734-fa64-7a3a-1eaf-7944bbe6caa4@samsung.com>
References: <1515344064-23156-1-git-send-email-akinobu.mita@gmail.com>
 <CGME20180112141412epcas2p1e00472715d601bc52dcef6d850d5f13c@epcas2p1.samsung.com>
 <1515344064-23156-2-git-send-email-akinobu.mita@gmail.com> <02ea7734-fa64-7a3a-1eaf-7944bbe6caa4@samsung.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sun, 14 Jan 2018 01:08:54 +0900
Message-ID: <CAC5umyjRhs7Y9oPktny=ua9-y-RZwi7Wjpr9c0hikCKgJexqpQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: ov9650: support device tree probing
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo@jmondi.org>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-01-12 23:14 GMT+09:00 Sylwester Nawrocki <s.nawrocki@samsung.com>:
> On 01/07/2018 05:54 PM, Akinobu Mita wrote:
>> The ov9650 driver currently only supports legacy platform data probe.
>> This change adds device tree probing.
>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>
>>  drivers/media/i2c/ov9650.c | 130 ++++++++++++++++++++++++++++++++-------------
>>  1 file changed, 92 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
>> index 69433e1..99a3eab 100644
>> --- a/drivers/media/i2c/ov9650.c
>> +++ b/drivers/media/i2c/ov9650.c
>
>> -static void __ov965x_set_power(struct ov965x *ov965x, int on)
>> +static int __ov965x_set_power(struct ov965x *ov965x, int on)
>>  {
>>       if (on) {
>> -             ov965x_gpio_set(ov965x->gpios[GPIO_PWDN], 0);
>> -             ov965x_gpio_set(ov965x->gpios[GPIO_RST], 0);
>> +             int ret = clk_prepare_enable(ov965x->clk);
>
> It seems you rely on the fact clk_prepare_enable() is a nop when passed
> argument is NULL, which happens in non-DT case.

So this works fine as before in non-DT case, doesn't it?

>> +             if (ret)
>> +                     return ret;
>> +
>> +             gpiod_set_value_cansleep(ov965x->gpios[GPIO_PWDN], 0);
>> +             gpiod_set_value_cansleep(ov965x->gpios[GPIO_RST], 0);
>>               msleep(25);
>>       } else {
>> -             ov965x_gpio_set(ov965x->gpios[GPIO_RST], 1);
>> -             ov965x_gpio_set(ov965x->gpios[GPIO_PWDN], 1);
>> +             gpiod_set_value_cansleep(ov965x->gpios[GPIO_RST], 1);
>> +             gpiod_set_value_cansleep(ov965x->gpios[GPIO_PWDN], 1);
>> +
>> +             clk_disable_unprepare(ov965x->clk);
>>       }
>>
>>       ov965x->streaming = 0;
>> +
>> +     return 0;
>>  }
>
>> @@ -1408,16 +1414,17 @@ static const struct v4l2_subdev_ops ov965x_subdev_ops = {
>>  /*
>>   * Reset and power down GPIOs configuration
>>   */
>> -static int ov965x_configure_gpios(struct ov965x *ov965x,
>> -                               const struct ov9650_platform_data *pdata)
>> +static int ov965x_configure_gpios_pdata(struct ov965x *ov965x,
>> +                             const struct ov9650_platform_data *pdata)
>>  {
>>       int ret, i;
>> +     int gpios[NUM_GPIOS];
>>
>> -     ov965x->gpios[GPIO_PWDN] = pdata->gpio_pwdn;
>> -     ov965x->gpios[GPIO_RST]  = pdata->gpio_reset;
>> +     gpios[GPIO_PWDN] = pdata->gpio_pwdn;
>> +     gpios[GPIO_RST]  = pdata->gpio_reset;
>>
>>       for (i = 0; i < ARRAY_SIZE(ov965x->gpios); i++) {
>> -             int gpio = ov965x->gpios[i];
>> +             int gpio = gpios[i];
>>
>>               if (!gpio_is_valid(gpio))
>>                       continue;
>> @@ -1427,9 +1434,30 @@ static int ov965x_configure_gpios(struct ov965x *ov965x,
>>                       return ret;
>>               v4l2_dbg(1, debug, &ov965x->sd, "set gpio %d to 1\n", gpio);
>>
>> -             gpio_set_value(gpio, 1);
>> +             gpio_set_value_cansleep(gpio, 1);
>>               gpio_export(gpio, 0);
>> -             ov965x->gpios[i] = gpio;
>> +             ov965x->gpios[i] = gpio_to_desc(gpio);
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static int ov965x_configure_gpios(struct ov965x *ov965x)
>> +{
>> +     struct device *dev = &ov965x->client->dev;
>> +
>> +     ov965x->gpios[GPIO_PWDN] = devm_gpiod_get_optional(dev, "powerdown",
>> +                                                     GPIOD_OUT_HIGH);
>> +     if (IS_ERR(ov965x->gpios[GPIO_PWDN])) {
>> +             dev_info(dev, "can't get %s GPIO\n", "powerdown");
>> +             return PTR_ERR(ov965x->gpios[GPIO_PWDN]);
>> +     }
>> +
>> +     ov965x->gpios[GPIO_RST] = devm_gpiod_get_optional(dev, "reset",
>> +                                                     GPIOD_OUT_HIGH);
>> +     if (IS_ERR(ov965x->gpios[GPIO_RST])) {
>> +             dev_info(dev, "can't get %s GPIO\n", "reset");
>> +             return PTR_ERR(ov965x->gpios[GPIO_RST]);
>>       }
>>
>>       return 0;
>> @@ -1443,7 +1471,10 @@ static int ov965x_detect_sensor(struct v4l2_subdev *sd)
>>       int ret;
>>
>>       mutex_lock(&ov965x->lock);
>> -     __ov965x_set_power(ov965x, 1);
>> +     ret = __ov965x_set_power(ov965x, 1);
>> +     if (ret)
>> +             goto out;
>> +
>>       msleep(25);
>>
>>       /* Check sensor revision */
>> @@ -1463,6 +1494,7 @@ static int ov965x_detect_sensor(struct v4l2_subdev *sd)
>>                       ret = -ENODEV;
>>               }
>>       }
>> +out:
>>       mutex_unlock(&ov965x->lock);
>>
>>       return ret;
>> @@ -1476,23 +1508,39 @@ static int ov965x_probe(struct i2c_client *client,
>>       struct ov965x *ov965x;
>>       int ret;
>>
>> -     if (!pdata) {
>> -             dev_err(&client->dev, "platform data not specified\n");
>> -             return -EINVAL;
>> -     }
>> -
>> -     if (pdata->mclk_frequency == 0) {
>> -             dev_err(&client->dev, "MCLK frequency not specified\n");
>> -             return -EINVAL;
>> -     }
>> -
>>       ov965x = devm_kzalloc(&client->dev, sizeof(*ov965x), GFP_KERNEL);
>>       if (!ov965x)
>>               return -ENOMEM;
>>
>> -     mutex_init(&ov965x->lock);
>
> I would leave mutex initialization as first thing after the private data
> structure allocation, is there a need to move it further?

Yes, there is.  This enables to reduce several lines in clk and gpio
initialization.

For example,

        if (IS_ERR(ov965x->clk)) {
                ret = PTR_ERR(ov965x->clk);
                goto err_mutex;
        }

vs.
        if (IS_ERR(ov965x->clk))
                return PTR_ERR(ov965x->clk);

>>       ov965x->client = client;
>> -     ov965x->mclk_frequency = pdata->mclk_frequency;
>> +
>> +     if (pdata) {
>> +             if (pdata->mclk_frequency == 0) {
>> +                     dev_err(&client->dev, "MCLK frequency not specified\n");
>> +                     return -EINVAL;
>> +             }
>> +             ov965x->mclk_frequency = pdata->mclk_frequency;
>> +
>> +             ret = ov965x_configure_gpios_pdata(ov965x, pdata);
>> +             if (ret < 0)
>> +                     return ret;
>> +     } else if (dev_fwnode(&client->dev)) {
>> +             ov965x->clk = devm_clk_get(&ov965x->client->dev, NULL);
>> +             if (IS_ERR(ov965x->clk))
>> +                     return PTR_ERR(ov965x->clk);
>> +             ov965x->mclk_frequency = clk_get_rate(ov965x->clk);
>> +
>> +             ret = ov965x_configure_gpios(ov965x);
>> +             if (ret < 0)
>> +                     return ret;
>> +     } else {
>> +             dev_err(&client->dev,
>> +                     "Neither platform data nor device property specified\n");
>> +
>> +             return -EINVAL;
>> +     }
>> +
>> +     mutex_init(&ov965x->lock);
>>
>>       sd = &ov965x->sd;
>>       v4l2_i2c_subdev_init(sd, client, &ov965x_subdev_ops);
>> @@ -1502,10 +1550,6 @@ static int ov965x_probe(struct i2c_client *client,
>>       sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
>>                    V4L2_SUBDEV_FL_HAS_EVENTS;
>>
>> -     ret = ov965x_configure_gpios(ov965x, pdata);
>> -     if (ret < 0)
>> -             goto err_mutex;
>> -
>>       ov965x->pad.flags = MEDIA_PAD_FL_SOURCE;
>>       sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
>>       ret = media_entity_pads_init(&sd->entity, 1, &ov965x->pad);
>> @@ -1561,9 +1605,19 @@ static const struct i2c_device_id ov965x_id[] = {
>>  };
>>  MODULE_DEVICE_TABLE(i2c, ov965x_id);
>>
>> +#if IS_ENABLED(CONFIG_OF)
>
> Is there any advantage in using IS_ENABLED() rather than just
> #ifdef CONFIG_OF ? of_match_ptr() is defined with just #idef CONFIG_OF/
> #else/#endif. I would use simply #ifdef CONFIG_OF here.

There is no difference between these in this context.

I think it doesn't look too strange because ov2659, ov5647, and ov7670
also do like this.

> Otherwise looks good.
>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Thanks for your review.
