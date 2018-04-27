Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41208 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758975AbeD0RU2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 13:20:28 -0400
MIME-Version: 1.0
In-Reply-To: <20180423083536.GP4235@w540>
References: <1524412577-14419-1-git-send-email-akinobu.mita@gmail.com>
 <1524412577-14419-8-git-send-email-akinobu.mita@gmail.com> <20180423083536.GP4235@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 28 Apr 2018 02:20:08 +0900
Message-ID: <CAC5umyiFtavJHXn2b+COVpDQbKhbFBPrU48NzQwiGv4rnaLnkQ@mail.gmail.com>
Subject: Re: [PATCH v3 07/11] media: ov772x: handle nested s_power() calls
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-04-23 17:35 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> Hi Akinobu,
>    thanks for v3
>
> On Mon, Apr 23, 2018 at 12:56:13AM +0900, Akinobu Mita wrote:
>> Depending on the v4l2 driver, calling s_power() could be nested.  So the
>> actual transitions between power saving mode and normal operation mode
>> should only happen at the first power on and the last power off.
>>
>> This adds an s_power() nesting counter and updates the power state if the
>> counter is modified from 0 to != 0 or from != 0 to 0.
>>
>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>> * v3
>> - Rename mutex name from power_lock to lock
>> - Add warning for duplicated s_power call
>>
>>  drivers/media/i2c/ov772x.c | 34 ++++++++++++++++++++++++++++++----
>>  1 file changed, 30 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index 95c1c95d..8c0b850 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -424,6 +424,9 @@ struct ov772x_priv {
>>       /* band_filter = COM8[5] ? 256 - BDBASE : 0 */
>>       unsigned short                    band_filter;
>>       unsigned int                      fps;
>> +     /* lock to protect power_count */
>> +     struct mutex                      lock;
>> +     int                               power_count;
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>       struct media_pad pad;
>>  #endif
>> @@ -871,9 +874,26 @@ static int ov772x_power_off(struct ov772x_priv *priv)
>>  static int ov772x_s_power(struct v4l2_subdev *sd, int on)
>>  {
>>       struct ov772x_priv *priv = to_ov772x(sd);
>> +     int ret = 0;
>> +
>> +     mutex_lock(&priv->lock);
>> +
>> +     /* If the power count is modified from 0 to != 0 or from != 0 to 0,
>> +      * update the power state.
>> +      */
>> +     if (priv->power_count == !on)
>> +             ret = on ? ov772x_power_on(priv) : ov772x_power_off(priv);
>> +
>> +     if (!ret) {
>> +             /* Update the power count. */
>> +             priv->power_count += on ? 1 : -1;
>> +             WARN(priv->power_count < 0, "Unbalanced power count\n");
>> +             WARN(priv->power_count > 1, "Duplicated s_power call\n");
>
>
> The first time you receive a power on (on == 1, power_count == 0)
> you'll have:
>
>         if (0 == !1)
>                 ret = ov772x_power_on()
>         if (!0)
>                 power_count += 1;
>
> If power management is 'nested' you could receive a second,
> unexpected, power on (on == 1, power_count == 1)
>         if (1 == !1)
>         if (!0)
>                 power_count += 1;
>
> Now power_count == 2, if you now receive a power off, you're going to
> ignore it:
>
>         if (2 == !0)
>                 ret = ov772x_power_off();
>         if (!0)
>                 power_count += -1;
>
> Again you now receive a new power off, and you're going to issue that
> one.
>
>         if (1 == !0)
>                 ret = ov772x_power_off();
>         if (!0)
>                 power_count += -1;
>
> So this seems correct to me!
>
> If I were you, I would simplify this as:
>
>         power_count += on ? 1 : -1;
>         if (power_count == !!on)
>                 return on ? ov772x_power_on(priv) :
>                             ov772x_power_off(priv);
>         WARN_ON(power_count < 0 || power_count > 1);
>
>         return 0;

The only drawback is that the power_count is updated even when the
ov772x_power_on/off failed.

> which, if I'm not wrong expands to:
>
> power_count = 0 ; on = 1
>         power_count += 1;
>         if (1 == !!1)
>                 return ov772x_power_on(priv);
>
> power_count = 1 ; on = 1
>         power_count += 1;
>         if (2 == !!1)
>         WARN_ON(2 > 1)
>
> power_count = 2 ; on = 0
>         power_count -= 1;
>         if (1 == !!0)
>         if (1 > 1 || 1 < 0)
>
> power_count = 1; on = 0
>         power_count -= 1;
>         if (0 == !!0)
>                 return ov772_power_off(priv);
>
> power_count = 0 ; on = 0
>         power_count -= 1;
>         if (-1 == !!0)
>         WARN_ON(-1 < 0)
>
> But if you have seen that pattern in other drivers, and maybe already
> tested your one, I'm fine with either of them.

For now, I leave this patch unchanged. If we can guarantee that s_power()
is not nested, we can simplify it by removing power_count or moving to
common field.

> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
>
> Thanks
>    j
>
>> +     }
>> +
>> +     mutex_unlock(&priv->lock);
>>
>> -     return on ? ov772x_power_on(priv) :
>> -                 ov772x_power_off(priv);
>> +     return ret;
>>  }
>>
>>  static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
>> @@ -1303,6 +1323,7 @@ static int ov772x_probe(struct i2c_client *client,
>>               return -ENOMEM;
>>
>>       priv->info = client->dev.platform_data;
>> +     mutex_init(&priv->lock);
>>
>>       v4l2_i2c_subdev_init(&priv->subdev, client, &ov772x_subdev_ops);
>>       v4l2_ctrl_handler_init(&priv->hdl, 3);
>> @@ -1313,8 +1334,10 @@ static int ov772x_probe(struct i2c_client *client,
>>       v4l2_ctrl_new_std(&priv->hdl, &ov772x_ctrl_ops,
>>                         V4L2_CID_BAND_STOP_FILTER, 0, 256, 1, 0);
>>       priv->subdev.ctrl_handler = &priv->hdl;
>> -     if (priv->hdl.error)
>> -             return priv->hdl.error;
>> +     if (priv->hdl.error) {
>> +             ret = priv->hdl.error;
>> +             goto error_mutex_destroy;
>> +     }
>>
>>       priv->clk = clk_get(&client->dev, "xclk");
>>       if (IS_ERR(priv->clk)) {
>> @@ -1362,6 +1385,8 @@ static int ov772x_probe(struct i2c_client *client,
>>       clk_put(priv->clk);
>>  error_ctrl_free:
>>       v4l2_ctrl_handler_free(&priv->hdl);
>> +error_mutex_destroy:
>> +     mutex_destroy(&priv->lock);
>>
>>       return ret;
>>  }
>> @@ -1376,6 +1401,7 @@ static int ov772x_remove(struct i2c_client *client)
>>               gpiod_put(priv->pwdn_gpio);
>>       v4l2_async_unregister_subdev(&priv->subdev);
>>       v4l2_ctrl_handler_free(&priv->hdl);
>> +     mutex_destroy(&priv->lock);
>>
>>       return 0;
>>  }
>> --
>> 2.7.4
>>
