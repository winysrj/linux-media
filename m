Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:45060 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751229AbeEDOvA (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 10:51:00 -0400
MIME-Version: 1.0
In-Reply-To: <20180503210333.GF19612@w540>
References: <1525021993-17789-1-git-send-email-akinobu.mita@gmail.com>
 <1525021993-17789-13-git-send-email-akinobu.mita@gmail.com> <20180503210333.GF19612@w540>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri, 4 May 2018 23:50:39 +0900
Message-ID: <CAC5umyiVf8VorE8EKop+9cUYCvw1HGyRC_=P23igepaeScfCcA@mail.gmail.com>
Subject: Re: [PATCH v4 12/14] media: ov772x: avoid accessing registers under
 power saving mode
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

2018-05-04 6:03 GMT+09:00 jacopo mondi <jacopo@jmondi.org>:
> Hi Akinobu,
>   let me see if I got this right...
>
> On Mon, Apr 30, 2018 at 02:13:11AM +0900, Akinobu Mita wrote:
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
>> * v4
>> - No changes
>>
>>  drivers/media/i2c/ov772x.c | 79 +++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 64 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
>> index 3e6ca98..bd37169 100644
>> --- a/drivers/media/i2c/ov772x.c
>> +++ b/drivers/media/i2c/ov772x.c
>> @@ -741,19 +741,30 @@ static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
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
>> +     mutex_lock(&priv->lock);
>> +     /*
>> +      * If the device is not powered up by the host driver do
>> +      * not apply any changes to H/W at this time. Instead
>> +      * the frame rate will be restored right after power-up.
>> +      */
>> +     if (priv->power_count > 0) {
>
> If I'm not wrong this is not protected when the device is
> streaming.
>
> Since Hans' series frame control is called by g/s_parm (until a new
> ioctl is not introduced) and I've looked at the call stack and it
> seems to me it does not check for active streaming[1]. I -think-
> this is even worse when this is called on the subdev, as there is
> no shared notion of active streaming. Am I wrong?
>
> If you have to check for active streaming here (I see some other
> drivers doing that, eg ov5640), then I see two ways, or you just
> return -EBUSY, or you save the desired FPS for later, but then it gets
> messy as you won't be able to just restore paramters at power_on()
> time, but you would need to do that also at start streaming time.
>
> My opinion is that you should check for streaming active (as you're
> doing for the set_fmt() function in [13/14], do you agree?

I agree.  I would like to make ov772x_s_frame_interval() return -EBUSY
without saving the desired FPS for later when the device is streaming.

I'm going to prepare v5 patches that address the above and other issues
you found in v4 unless you prefer the incremental patch series.

> [1] This calls for a device wise 'streaming' state handler. Maybe it's
> there but I failed to find checks for that.
