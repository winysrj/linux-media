Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:41206 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753692AbeDSQVq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 12:21:46 -0400
MIME-Version: 1.0
In-Reply-To: <20180418124119.GA3999@w540>
References: <1523847111-12986-1-git-send-email-akinobu.mita@gmail.com>
 <1523847111-12986-9-git-send-email-akinobu.mita@gmail.com> <20180418124119.GA3999@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri, 20 Apr 2018 01:21:25 +0900
Message-ID: <CAC5umyiQOTpEqiRpVst2VtpwWCtACndVF_K6aqtHwzpF4JDW6Q@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] media: ov772x: handle nested s_power() calls
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

2018-04-18 21:41 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> Hi Akinobu,
>
> On Mon, Apr 16, 2018 at 11:51:49AM +0900, Akinobu Mita wrote:
>> Depending on the v4l2 driver, calling s_power() could be nested.  So the
>> actual transitions between power saving mode and normal operation mode
>> should only happen at the first power on and the last power off.
>
> What do you mean with 'nested' ?
>
> My understanding is that:
> - if a sensor driver is mc compliant, it's s_power is called from
>   v4l2_mc.c pipeline_pm_power_one() only when the power state changes
> - if a sensor driver is not mc compliant, the s_power routine is
>   called from the platform driver, and it should not happen that it is
>   called twice with the same power state
> - if a sensor implements subdev's internal operations open and close
>   it may call it's own s_power routines from there, and it can be
>   opened more that once.
>
> My understanding is that this driver s_power routines are only called
> from platform drivers, and they -should- be safe.

For pxa_camera driver, if there are more than two openers for a video
device at the same time, calling s_power() could be nested.  Because
there is nothing to prevent from calling s_power() in
pxac_fops_camera_open().

However, most of other V4L2 drivers use v4l2_fh_is_singular_file() to
prevent from nested s_power() in their open operation.  So we can do
the same for pxa_camera driver.

> Although, I'm not against this protection completely. Others might be,
> though.
>
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
>> * v2
>> - New patch
>>
>>  drivers/media/i2c/ov772x.c | 33 +++++++++++++++++++++++++++++----
>>  1 file changed, 29 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index 4245a46..2cd6e85 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -424,6 +424,9 @@ struct ov772x_priv {
>>       /* band_filter = COM8[5] ? 256 - BDBASE : 0 */
>>       unsigned short                    band_filter;
>>       unsigned int                      fps;
>> +     /* lock to protect power_count */
>> +     struct mutex                      power_lock;
>> +     int                               power_count;
>>  #ifdef CONFIG_MEDIA_CONTROLLER
>>       struct media_pad pad;
>>  #endif
>> @@ -871,9 +874,25 @@ static int ov772x_power_off(struct ov772x_priv *priv)
>>  static int ov772x_s_power(struct v4l2_subdev *sd, int on)
>>  {
>>       struct ov772x_priv *priv = to_ov772x(sd);
>> +     int ret = 0;
>> +
>> +     mutex_lock(&priv->power_lock);
>>
>> -     return on ? ov772x_power_on(priv) :
>> -                 ov772x_power_off(priv);
>> +     /* If the power count is modified from 0 to != 0 or from != 0 to 0,
>> +      * update the power state.
>> +      */
>> +     if (priv->power_count == !on)
>> +             ret = on ? ov772x_power_on(priv) : ov772x_power_off(priv);
>
> Just release the mutex and return 0 if (power_count == on)
> The code will be more readable imho.

OK.  Actually, the change in this patch is used like boilerplate in
many subdev drivers.  Also, it's better to print warning when nested
s_power() call is detected as it should not be happened.
