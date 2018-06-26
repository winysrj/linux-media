Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:36724 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933522AbeFZNrL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 09:47:11 -0400
Subject: Re: [PATCH] media: video-i2c: add hwmon support for amg88xx
To: Matt Ranostay <matt.ranostay@konsulko.com>,
        linux-media@vger.kernel.org
Cc: linux-hwmon@vger.kernel.org
References: <20180626063025.7778-1-matt.ranostay@konsulko.com>
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <50948d52-3dcd-79b6-52e8-cf6651393449@roeck-us.net>
Date: Tue, 26 Jun 2018 06:47:08 -0700
MIME-Version: 1.0
In-Reply-To: <20180626063025.7778-1-matt.ranostay@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/25/2018 11:30 PM, Matt Ranostay wrote:
> AMG88xx has an on-board thermistor which is used for more accurate
> processing of its temperature readings from the 8x8 thermopile array
> 
> Cc: linux-hwmon@vger.kernel.org
> Signed-off-by: Matt Ranostay <matt.ranostay@konsulko.com>
> ---
>   drivers/media/i2c/video-i2c.c | 73 +++++++++++++++++++++++++++++++++++
>   1 file changed, 73 insertions(+)
> 
> diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
> index 0b347cc19aa5..16c3e03af219 100644
> --- a/drivers/media/i2c/video-i2c.c
> +++ b/drivers/media/i2c/video-i2c.c
> @@ -10,6 +10,8 @@
>   
>   #include <linux/delay.h>
>   #include <linux/freezer.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>

The second include is not needed.

>   #include <linux/kthread.h>
>   #include <linux/i2c.h>
>   #include <linux/list.h>
> @@ -77,6 +79,9 @@ struct video_i2c_chip {
>   
>   	/* xfer function */
>   	int (*xfer)(struct video_i2c_data *data, char *buf);
> +
> +	/* hwmon init function */
> +	int (*hwmon_init)(struct video_i2c_data *data);
>   };
>   
>   static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
> @@ -101,6 +106,70 @@ static int amg88xx_xfer(struct video_i2c_data *data, char *buf)
>   	return (ret == 2) ? 0 : -EIO;
>   }
>   
> +#if defined(CONFIG_HWMON) || (defined(MODULE) && defined(CONFIG_HWMON_MODULE))
> +
> +static const u32 amg88xx_temp_config[] = {
> +	HWMON_T_INPUT,
> +	0
> +};
> +
> +static const struct hwmon_channel_info amg88xx_temp = {
> +	.type = hwmon_temp,
> +	.config = amg88xx_temp_config,
> +};
> +
> +static const struct hwmon_channel_info *amg88xx_info[] = {
> +	&amg88xx_temp,
> +	NULL
> +};
> +
> +static umode_t amg88xx_is_visible(const void *drvdata,
> +				  enum hwmon_sensor_types type,
> +				  u32 attr, int channel)
> +{
> +	return 0444;
> +}
> +
> +static int amg88xx_read(struct device *dev, enum hwmon_sensor_types type,
> +			u32 attr, int channel, long *val)
> +{
> +	struct video_i2c_data *data = dev_get_drvdata(dev);
> +	struct i2c_client *client = data->client;
> +	int tmp = i2c_smbus_read_word_data(client, 0x0e);
> +
> +	if (tmp < 0)
> +		return -EINVAL;
> +

Please return the error. This does not reflect an invalid argument.


> +	/* check for sign bit, and invert temp reading to a negative value */
> +	if (0x800 & tmp)

Yoda programming dislike I do. All it does to obfuscate the code and confuse
the reader. Don't tell me that "if (0 > ret)" is somehow better than
"if (ret < 0)". On top of that, it is misguided here. It was introduced
to prevent sloppy programmers from writing code such as
	if (i = 15)
which does not apply here.

> +		tmp = -(tmp & 0x7ff);

0x800 => 0x0 -> -0x0 -> 0x0

seems wrong. Maybe consider using sign_extend32() instead ?

> +
> +	*val = (tmp * 625) / 10;
> +
> +	return 0;
> +}
> +
> +static const struct hwmon_ops amg88xx_hwmon_ops = {
> +	.is_visible = amg88xx_is_visible,
> +	.read = amg88xx_read,
> +};
> +
> +static const struct hwmon_chip_info amg88xx_chip_info = {
> +	.ops = &amg88xx_hwmon_ops,
> +	.info = amg88xx_info,
> +};
> +
> +static int amg88xx_hwmon_init(struct video_i2c_data *data)
> +{
> +	void *hwmon = devm_hwmon_device_register_with_info(&data->client->dev,
> +				"amg88xx", data, &amg88xx_chip_info, NULL);
> +
> +	return IS_ERR(hwmon);

What is the point of not returning the error (eg with PTR_ERR_OR_ZERO) but a boolean ?

> +}
> +#else
> +#define	amg88xx_hwmon_init	NULL
> +#endif
> +
>   #define AMG88XX		0
>   
>   static const struct video_i2c_chip video_i2c_chip[] = {
> @@ -111,6 +180,7 @@ static const struct video_i2c_chip video_i2c_chip[] = {
>   		.buffer_size	= 128,
>   		.bpp		= 16,
>   		.xfer		= &amg88xx_xfer,
> +		.hwmon_init	= &amg88xx_hwmon_init,

This won't work if amg88xx_hwmon_init is NULL. Besides, & in front of
a function name is unnecessary.

>   	}
>   };
>   
> @@ -505,6 +575,9 @@ static int video_i2c_probe(struct i2c_client *client,
>   	video_set_drvdata(&data->vdev, data);
>   	i2c_set_clientdata(client, data);
>   
> +	if (data->chip->hwmon_init)
> +		data->chip->hwmon_init(data);

What is the point of having the function return an int (or bool) and
if the return value is ignored ?

> +
>   	ret = video_register_device(&data->vdev, VFL_TYPE_GRABBER, -1);
>   	if (ret < 0)
>   		goto error_unregister_device;
> 
