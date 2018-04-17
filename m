Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34137 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753370AbeDQQwW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 12:52:22 -0400
MIME-Version: 1.0
In-Reply-To: <20180416105515.jpufwj7dbq5zl66n@paasikivi.fi.intel.com>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-11-git-send-email-akinobu.mita@gmail.com> <20180416105515.jpufwj7dbq5zl66n@paasikivi.fi.intel.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Wed, 18 Apr 2018 01:52:01 +0900
Message-ID: <CAC5umyhcOObNqdG=mvjFYE1BbvoUFjesiT6jp+QeFzYR9-+ggw@mail.gmail.com>
Subject: Re: [PATCH v2 10/10] media: ov772x: avoid accessing registers under
 power saving mode
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-04-16 19:55 GMT+09:00 Sakari Ailus <sakari.ailus@linux.intel.com>:
> Hi Akinobu,
>
> As the driver now offers a V4L2 sub-device uAPI, it needs to serialise
> access to its internal data structures. This appears to be fine, but there
> are additional requirements; for instance ov772x_select_params() should
> likely fail if you're streaming.

OK.  I can find many subdev drivers that have 'streaming' flag in the
private data to keep track of the streaming state and make set_fmt()
return -EBUSY if streaming is on.

I'll prepare another patch that does the same thing.

> On Mon, Apr 16, 2018 at 11:51:51AM +0900, Akinobu Mita wrote:
>> The set_fmt() in subdev pad ops, the s_ctrl() for subdev control handler,
>> and the s_frame_interval() in subdev video ops could be called when the
>> device is under power saving mode.  These callbacks for ov772x driver
>> cause updating H/W registers that will fail under power saving mode.
>>
>> This avoids it by not apply any changes to H/W if the device is not powered
>> up.  Instead the changes will be restored right after power-up.
>>
>> Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>> * v2
>> - New patch
>>
>>  drivers/media/i2c/ov772x.c | 77 +++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 62 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index 1297a21..c44728f 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -741,19 +741,29 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
>>       struct ov772x_priv *priv = to_ov772x(sd);
>>       struct v4l2_fract *tpf = &ival->interval;
>>       unsigned int fps;
>> -     int ret;
>> +     int ret = 0;
>>
>>       fps = ov772x_select_fps(priv, tpf);
>>
>> -     ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
>> -     if (ret)
>> -             return ret;
>> +     mutex_lock(&priv->power_lock);
>> +     /*
>> +      * If the device is not powered up by the host driver do
>> +      * not apply any changes to H/W at this time. Instead
>> +      * the frame rate will be restored right after power-up.
>> +      */
>> +     if (priv->power_count > 0) {
>> +             ret = ov772x_set_frame_rate(priv, fps, priv->cfmt, priv->win);
>> +             if (ret)
>> +                     goto error;
>> +     }
>>
>>       tpf->numerator = 1;
>>       tpf->denominator = fps;
>>       priv->fps = fps;
>
> Newline before a label would be nice.

I see.
