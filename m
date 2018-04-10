Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34132 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752016AbeDJQfG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 12:35:06 -0400
MIME-Version: 1.0
In-Reply-To: <20180409092747.GY20945@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-7-git-send-email-akinobu.mita@gmail.com> <20180409092747.GY20945@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 11 Apr 2018 01:34:45 +0900
Message-ID: <CAC5umyg=o8F5nDRQBuNOg1DeuiKzPdwNy=tPEAGABjeF6oqfBQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] media: ov772x: support device tree probing
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

2018-04-09 18:27 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> Hi Akinobu,
>
> On Sun, Apr 08, 2018 at 12:48:10AM +0900, Akinobu Mita wrote:
>> The ov772x driver currently only supports legacy platform data probe.
>> This change enables device tree probing.
>>
>> Note that the platform data probe can select auto or manual edge control
>> mode, but the device tree probling can only select auto edge control mode
>> for now.
>>
>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  drivers/media/i2c/ov772x.c | 60 ++++++++++++++++++++++++++++++----------------
>>  1 file changed, 40 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index 5e91fa1..e67ec37 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -763,13 +763,13 @@ static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
>>       case V4L2_CID_VFLIP:
>>               val = ctrl->val ? VFLIP_IMG : 0x00;
>>               priv->flag_vflip = ctrl->val;
>> -             if (priv->info->flags & OV772X_FLAG_VFLIP)
>> +             if (priv->info && (priv->info->flags & OV772X_FLAG_VFLIP))
>>                       val ^= VFLIP_IMG;
>>               return ov772x_mask_set(client, COM3, VFLIP_IMG, val);
>>       case V4L2_CID_HFLIP:
>>               val = ctrl->val ? HFLIP_IMG : 0x00;
>>               priv->flag_hflip = ctrl->val;
>> -             if (priv->info->flags & OV772X_FLAG_HFLIP)
>> +             if (priv->info && (priv->info->flags & OV772X_FLAG_HFLIP))
>>                       val ^= HFLIP_IMG;
>>               return ov772x_mask_set(client, COM3, HFLIP_IMG, val);
>>       case V4L2_CID_BAND_STOP_FILTER:
>> @@ -928,19 +928,14 @@ static void ov772x_select_params(const struct v4l2_mbus_framefmt *mf,
>>       *win = ov772x_select_win(mf->width, mf->height);
>>  }
>>
>> -static int ov772x_set_params(struct ov772x_priv *priv,
>> -                          const struct ov772x_color_format *cfmt,
>> -                          const struct ov772x_win_size *win)
>> +static int ov772x_edgectrl(struct ov772x_priv *priv)
>>  {
>>       struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
>> -     struct v4l2_fract tpf;
>>       int ret;
>> -     u8  val;
>>
>> -     /* Reset hardware. */
>> -     ov772x_reset(client);
>> +     if (!priv->info)
>> +             return 0;
>>
>> -     /* Edge Ctrl. */
>>       if (priv->info->edgectrl.strength & OV772X_MANUAL_EDGE_CTRL) {
>>               /*
>>                * Manual Edge Control Mode.
>> @@ -951,19 +946,19 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>>
>>               ret = ov772x_mask_set(client, DSPAUTO, EDGE_ACTRL, 0x00);
>>               if (ret < 0)
>> -                     goto ov772x_set_fmt_error;
>> +                     return ret;
>>
>>               ret = ov772x_mask_set(client,
>>                                     EDGE_TRSHLD, OV772X_EDGE_THRESHOLD_MASK,
>>                                     priv->info->edgectrl.threshold);
>>               if (ret < 0)
>> -                     goto ov772x_set_fmt_error;
>> +                     return ret;
>>
>>               ret = ov772x_mask_set(client,
>>                                     EDGE_STRNGT, OV772X_EDGE_STRENGTH_MASK,
>>                                     priv->info->edgectrl.strength);
>>               if (ret < 0)
>> -                     goto ov772x_set_fmt_error;
>> +                     return ret;
>>
>>       } else if (priv->info->edgectrl.upper > priv->info->edgectrl.lower) {
>>               /*
>> @@ -975,15 +970,35 @@ static int ov772x_set_params(struct ov772x_priv *priv,
>>                                     EDGE_UPPER, OV772X_EDGE_UPPER_MASK,
>>                                     priv->info->edgectrl.upper);
>>               if (ret < 0)
>> -                     goto ov772x_set_fmt_error;
>> +                     return ret;
>>
>>               ret = ov772x_mask_set(client,
>>                                     EDGE_LOWER, OV772X_EDGE_LOWER_MASK,
>>                                     priv->info->edgectrl.lower);
>>               if (ret < 0)
>> -                     goto ov772x_set_fmt_error;
>> +                     return ret;
>>       }
>>
>> +     return 0;
>> +}
>> +
>> +static int ov772x_set_params(struct ov772x_priv *priv,
>> +                          const struct ov772x_color_format *cfmt,
>> +                          const struct ov772x_win_size *win)
>> +{
>> +     struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
>> +     struct v4l2_fract tpf;
>> +     int ret;
>> +     u8  val;
>> +
>> +     /* Reset hardware. */
>> +     ov772x_reset(client);
>> +
>> +     /* Edge Ctrl. */
>> +     ret =  ov772x_edgectrl(priv);
>> +     if (ret < 0)
>> +             goto ov772x_set_fmt_error;
>> +
>>       /* Format and window size. */
>>       ret = ov772x_write(client, HSTART, win->rect.left >> 2);
>>       if (ret < 0)
>> @@ -1284,11 +1299,6 @@ static int ov772x_probe(struct i2c_client *client,
>>       struct i2c_adapter      *adapter = client->adapter;
>>       int                     ret;
>>
>> -     if (!client->dev.platform_data) {
>
> Not sure this has to be removed completely. I'm debated, as in
> general, for mainline code, we should make sure every user of this
> driver shall provide platform_data during review, and this check is
> not requried. But in general, I still think it may have value.
>
> What about:
>         if (!client->dev.of_node && !client->dev.platform_data) {
>                dev_err(&client->dev, "Missing ov772x platform data\n");
>                return -EINVAL;
>         }

OK. I'll take this.
