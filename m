Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:35017 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbeF0DU2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 23:20:28 -0400
Received: by mail-it0-f66.google.com with SMTP id l16-v6so4582058ita.0
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2018 20:20:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50948d52-3dcd-79b6-52e8-cf6651393449@roeck-us.net>
References: <20180626063025.7778-1-matt.ranostay@konsulko.com> <50948d52-3dcd-79b6-52e8-cf6651393449@roeck-us.net>
From: Matt Ranostay <matt.ranostay@konsulko.com>
Date: Tue, 26 Jun 2018 20:20:27 -0700
Message-ID: <CAJCx=g=ownrgsmx6UXrTEn98JhV6_1arnj4xP2Ly_OszEeCkUA@mail.gmail.com>
Subject: Re: [PATCH] media: video-i2c: add hwmon support for amg88xx
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-media@vger.kernel.org, linux-hwmon@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2018 at 6:47 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 06/25/2018 11:30 PM, Matt Ranostay wrote:
>>
>> AMG88xx has an on-board thermistor which is used for more accurate
>> processing of its temperature readings from the 8x8 thermopile array
>>
>> Cc: linux-hwmon@vger.kernel.org
>> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
>> ---
>>   drivers/media/i2c/video-i2c.c | 73 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 73 insertions(+)
>>
>> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
>> index 0b347cc19aa5..16c3e03af219 100644
>> --- a/drivers/media/i2c/video-i2c.c
>> +++ b/drivers/media/i2c/video-i2c.c
>> @@ -10,6 +10,8 @@
>>     #include <linux/delay.h>
>>   #include <linux/freezer.h>
>> +#include <linux/hwmon.h>
>> +#include <linux/hwmon-sysfs.h>
>
>
> The second include is not needed.
>
Noted.

>
>>   #include <linux/kthread.h>
>>   #include <linux/i2c.h>
>>   #include <linux/list.h>
>> @@ -77,6 +79,9 @@ struct video_i2c_chip {
>>         /* xfer function */
>>         int (*xfer)(struct video_i2c_data *data, char *buf);
>> +
>> +       /* hwmon init function */
>> +       int (*hwmon_init)(struct video_i2c_data *data);
>>   };
>>     static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
>> @@ -101,6 +106,70 @@ static int amg88xx_xfer(struct video_i2c_data *data,
>> char *buf)
>>         return (ret == 2) ? 0 : -EIO;
>>   }
>>   +#if defined(CONFIG_HWMON) || (defined(MODULE) &&
>> defined(CONFIG_HWMON_MODULE))
>> +
>> +static const u32 amg88xx_temp_config[] = {
>> +       HWMON_T_INPUT,
>> +       0
>> +};
>> +
>> +static const struct hwmon_channel_info amg88xx_temp = {
>> +       .type = hwmon_temp,
>> +       .config = amg88xx_temp_config,
>> +};
>> +
>> +static const struct hwmon_channel_info *amg88xx_info[] = {
>> +       &amg88xx_temp,
>> +       NULL
>> +};
>> +
>> +static umode_t amg88xx_is_visible(const void *drvdata,
>> +                                 enum hwmon_sensor_types type,
>> +                                 u32 attr, int channel)
>> +{
>> +       return 0444;
>> +}
>> +
>> +static int amg88xx_read(struct device *dev, enum hwmon_sensor_types type,
>> +                       u32 attr, int channel, long *val)
>> +{
>> +       struct video_i2c_data *data = dev_get_drvdata(dev);
>> +       struct i2c_client *client = data->client;
>> +       int tmp = i2c_smbus_read_word_data(client, 0x0e);
>> +
>> +       if (tmp < 0)
>> +               return -EINVAL;
>> +
>
>
> Please return the error. This does not reflect an invalid argument.

Ok noted.
>
>
>> +       /* check for sign bit, and invert temp reading to a negative value
>> */
>> +       if (0x800 & tmp)
>
>
> Yoda programming dislike I do. All it does to obfuscate the code and confuse
> the reader. Don't tell me that "if (0 > ret)" is somehow better than
> "if (ret < 0)". On top of that, it is misguided here. It was introduced
> to prevent sloppy programmers from writing code such as
>         if (i = 15)
> which does not apply here.

Understood :)  and probably should use the BIT() macro

>
>> +               tmp = -(tmp & 0x7ff);
>
>
> 0x800 => 0x0 -> -0x0 -> 0x0
>
> seems wrong. Maybe consider using sign_extend32() instead ?
>

Heh yes I knew someone was going to see this and scratch their head on this..

So the sign bit just says if the value is positive or negative, and
the value isn't two's (or even one's) complement value.
If it is negative you have to basically have to  invert the absolute
value (tested this with a freezer to be sure it wasn't a datasheet
mistake).

Datasheet: https://cdn-learn.adafruit.com/assets/assets/000/043/261/original/Grid-EYE_SPECIFICATIONS%28Reference%29.pdf

>> +
>> +       *val = (tmp * 625) / 10;
>> +
>> +       return 0;
>> +}
>> +
>> +static const struct hwmon_ops amg88xx_hwmon_ops = {
>> +       .is_visible = amg88xx_is_visible,
>> +       .read = amg88xx_read,
>> +};
>> +
>> +static const struct hwmon_chip_info amg88xx_chip_info = {
>> +       .ops = &amg88xx_hwmon_ops,
>> +       .info = amg88xx_info,
>> +};
>> +
>> +static int amg88xx_hwmon_init(struct video_i2c_data *data)
>> +{
>> +       void *hwmon =
>> devm_hwmon_device_register_with_info(&data->client->dev,
>> +                               "amg88xx", data, &amg88xx_chip_info,
>> NULL);
>> +
>> +       return IS_ERR(hwmon);
>
>
> What is the point of not returning the error (eg with PTR_ERR_OR_ZERO) but a
> boolean ?
>

No reason, and you are correct it should return the error code in the
return value.

>> +}
>> +#else
>> +#define        amg88xx_hwmon_init      NULL
>> +#endif
>> +
>>   #define AMG88XX               0
>>     static const struct video_i2c_chip video_i2c_chip[] = {
>> @@ -111,6 +180,7 @@ static const struct video_i2c_chip video_i2c_chip[] =
>> {
>>                 .buffer_size    = 128,
>>                 .bpp            = 16,
>>                 .xfer           = &amg88xx_xfer,
>> +               .hwmon_init     = &amg88xx_hwmon_init,
>
>
> This won't work if amg88xx_hwmon_init is NULL. Besides, & in front of
> a function name is unnecessary.
>

D'oh yea explains why kbuild bot just emailed me about this..

>>         }
>>   };
>>   @@ -505,6 +575,9 @@ static int video_i2c_probe(struct i2c_client
>> *client,
>>         video_set_drvdata(&data->vdev, data);
>>         i2c_set_clientdata(client, data);
>>   +     if (data->chip->hwmon_init)
>> +               data->chip->hwmon_init(data);
>
>
> What is the point of having the function return an int (or bool) and
> if the return value is ignored ?
>

Correct... I'll put a warning here since I don't think the video side
should fail to register if the hwmon bits fail.

>
>> +
>>         ret = video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
>>         if (ret < 0)
>>                 goto error_unregister_device;
>>
>
