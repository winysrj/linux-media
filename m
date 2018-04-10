Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36593 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbeDJQcJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 12:32:09 -0400
MIME-Version: 1.0
In-Reply-To: <20180409083237.GW20945@w540>
References: <1523116090-13101-1-git-send-email-akinobu.mita@gmail.com>
 <1523116090-13101-5-git-send-email-akinobu.mita@gmail.com> <20180409083237.GW20945@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 11 Apr 2018 01:31:48 +0900
Message-ID: <CAC5umyhC_PS8dsYujgbbivdX02=-xN6B5u-vhzXEoGbSxw+Egg@mail.gmail.com>
Subject: Re: [PATCH 4/6] media: ov772x: add media controller support
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

2018-04-09 17:32 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> Hi Akinobu,
>
> On Sun, Apr 08, 2018 at 12:48:08AM +0900, Akinobu Mita wrote:
>> Create a source pad and set the media controller type to the sensor.
>>
>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  drivers/media/i2c/ov772x.c | 22 ++++++++++++++++++++--
>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index 4bb81ff..5e91fa1 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -425,6 +425,9 @@ struct ov772x_priv {
>>       unsigned short                    band_filter;
>>       unsigned int                      fps;
>>       int (*reg_read)(struct i2c_client *client, u8 addr);
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +     struct media_pad pad;
>> +#endif
>>  };
>>
>>  /*
>> @@ -1328,9 +1331,17 @@ static int ov772x_probe(struct i2c_client *client,
>>               goto error_clk_put;
>>       }
>>
>> -     ret = ov772x_video_probe(priv);
>> +#ifdef CONFIG_MEDIA_CONTROLLER
>> +     priv->pad.flags = MEDIA_PAD_FL_SOURCE;
>> +     priv->subdev.entity.function = MEDIA_ENT_F_CAM_SENSOR;
>> +     ret = media_entity_pads_init(&priv->subdev.entity, 1, &priv->pad);
>>       if (ret < 0)
>>               goto error_gpio_put;
>> +#endif
>> +
>> +     ret = ov772x_video_probe(priv);
>> +     if (ret < 0)
>> +             goto error_entity_cleanup;
>
> If you remove the #ifdef around the media_entity_cleanup() below, I
> suggest moving video_probe() before the entity intialization so you
> don't have to #ifdef around the error_gpio_put: label, which otherwise
> the compiler complains for being defined but not used.

I see.
