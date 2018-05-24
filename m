Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:38472 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030620AbeEXQQx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 12:16:53 -0400
Received: by mail-pl0-f67.google.com with SMTP id c11-v6so1355248plr.5
        for <linux-media@vger.kernel.org>; Thu, 24 May 2018 09:16:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180522135958.sywjvur3ff7ejw37@paasikivi.fi.intel.com>
References: <1526830838-2812-1-git-send-email-akinobu.mita@gmail.com> <20180522135958.sywjvur3ff7ejw37@paasikivi.fi.intel.com>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri, 25 May 2018 01:16:32 +0900
Message-ID: <CAC5umyju4Fd7Si2D67x_y7H_U686j-Zkk7EQF9BdEKZcND4uEQ@mail.gmail.com>
Subject: Re: [PATCH] media: pxa_camera: avoid duplicate s_power calls
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018-05-22 22:59 GMT+09:00 Sakari Ailus <sakari.ailus@linux.intel.com>:
> Dear Mita-san,
>
> On Mon, May 21, 2018 at 12:40:38AM +0900, Akinobu Mita wrote:
>> The open() operation for the pxa_camera driver always calls s_power()
>> operation to put its subdevice sensor in normal operation mode, and the
>> release() operation always call s_power() operation to put the subdevice
>> in power saving mode.
>>
>> This requires the subdevice sensor driver to keep track of its power
>> state in order to avoid putting the subdevice in power saving mode while
>> the device is still opened by some users.
>>
>> Many subdevice drivers handle it by the boilerplate code that increments
>> and decrements an internal counter in s_power() like below:
>>
>>       /*
>>        * If the power count is modified from 0 to != 0 or from != 0 to 0,
>>        * update the power state.
>>        */
>>       if (sensor->power_count == !on) {
>>               ret = ov5640_set_power(sensor, !!on);
>>               if (ret)
>>                       goto out;
>>       }
>>
>>       /* Update the power count. */
>>       sensor->power_count += on ? 1 : -1;
>>
>> However, some subdevice drivers don't handle it and may cause a problem
>> with the pxa_camera driver if the video device is opened by more than
>> two users at the same time.
>>
>> Instead of propagating the boilerplate code for each subdevice driver
>> that implement s_power, this introduces an trick that many V4L2 drivers
>> are using with v4l2_fh_is_singular_file().
>
> I'd rather like that the sub-device drivers would move to use runtime PM
> instead of depending on the s_power() callback. It's much cleaner that way.

Sounds good.
I'll look into whether some sensor drivers can be converted to use it.

> It's not a near-term solution though. The approach seems fine, please see
> comments below though.
>
>>
>> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> ---
>>  drivers/media/platform/pxa_camera.c | 17 ++++++++++++-----
>>  1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
>> index c71a007..c792cb1 100644
>> --- a/drivers/media/platform/pxa_camera.c
>> +++ b/drivers/media/platform/pxa_camera.c
>> @@ -2040,6 +2040,9 @@ static int pxac_fops_camera_open(struct file *filp)
>>       if (ret < 0)
>>               goto out;
>>
>> +     if (!v4l2_fh_is_singular_file(filp))
>> +             goto out;
>> +
>>       ret = sensor_call(pcdev, core, s_power, 1);
>>       if (ret)
>>               v4l2_fh_release(filp);
>> @@ -2052,13 +2055,17 @@ static int pxac_fops_camera_release(struct file *filp)
>>  {
>>       struct pxa_camera_dev *pcdev = video_drvdata(filp);
>>       int ret;
>> -
>> -     ret = vb2_fop_release(filp);
>> -     if (ret < 0)
>> -             return ret;
>> +     bool fh_singular;
>>
>>       mutex_lock(&pcdev->mlock);
>> -     ret = sensor_call(pcdev, core, s_power, 0);
>> +
>> +     fh_singular = v4l2_fh_is_singular_file(filp);
>> +
>> +     ret = _vb2_fop_release(filp, NULL);
>
> I'm not sure whether using the return value to return an error from release
> is really useful. If you want to use it, I'd shout loud instead.

What is the best way to handle these errors in release?

AFAICS, vb2_fop_release() always returns zero for now and most platform
drivers don't use return value from s_power() calling with on == 0.

So ignoring both of vb2_fop_release error and s_power error makes sense?

>> +
>> +     if (fh_singular)
>
> ret assigned previously is overwritten here without checking.
>
>> +             ret = sensor_call(pcdev, core, s_power, 0);
>> +
>>       mutex_unlock(&pcdev->mlock);
>>
>>       return ret;
>
> --
> Sakari Ailus
> sakari.ailus@linux.intel.com
