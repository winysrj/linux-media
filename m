Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:38396 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbeC2HuO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 03:50:14 -0400
Received: by mail-wr0-f173.google.com with SMTP id m13so4485762wrj.5
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2018 00:50:13 -0700 (PDT)
From: Todor Tomov <todor.tomov@linaro.org>
Subject: Re: [v2,2/2] media: Add a driver for the ov7251 camera sensor
To: jacopo mondi <jacopo@jmondi.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1521778460-8717-3-git-send-email-todor.tomov@linaro.org>
 <20180323134003.GB11499@w540>
Message-ID: <419f6976-ee6a-f2c1-1097-a51776469ee4@linaro.org>
Date: Thu, 29 Mar 2018 10:50:10 +0300
MIME-Version: 1.0
In-Reply-To: <20180323134003.GB11499@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for your prompt review.

On 23.03.2018 15:40, jacopo mondi wrote:
> Hi Todor,
>    thanks for the patch.
> 
> When running checkpatch --strict I see a few warning you can easily
> close (braces indentation mostly, and one additional empty line at
> line 1048).

Thank you for pointing me to the --strict mode. There are a few CHECKs for
braces alignment for which the alignment is still better as it is now
I think. However there were also a few reasonable points and I have
updated the code according to them.

> 
> A few more nits below.
> 
> On Fri, Mar 23, 2018 at 12:14:20PM +0800, Todor Tomov wrote:
>> The ov7251 sensor is a 1/7.5-Inch B&W VGA (640x480) CMOS Digital Image
>> Sensor from Omnivision.
>>
>> The driver supports the following modes:
>> - 640x480 30fps
>> - 640x480 60fps
>> - 640x480 90fps
>>
>> Output format is MIPI RAW 10.
>>
>> The driver supports configuration via user controls for:
>> - exposure and gain;
>> - horizontal and vertical flip;
>> - test pattern.
>>
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/i2c/Kconfig  |   13 +
>>  drivers/media/i2c/Makefile |    1 +
>>  drivers/media/i2c/ov7251.c | 1494 ++++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 1508 insertions(+)
>>  create mode 100644 drivers/media/i2c/ov7251.c
>>
>> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
>> index 541f0d28..89aecb3 100644
>> --- a/drivers/media/i2c/Kconfig
>> +++ b/drivers/media/i2c/Kconfig
>> @@ -688,6 +688,19 @@ config VIDEO_OV5695
>>  	  To compile this driver as a module, choose M here: the
>>  	  module will be called ov5695.
>>
>> +config VIDEO_OV7251
>> +	tristate "OmniVision OV7251 sensor support"
>> +	depends on OF
>> +	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> +	depends on MEDIA_CAMERA_SUPPORT
>> +	select V4L2_FWNODE
>> +	---help---
>> +	  This is a Video4Linux2 sensor-level driver for the OmniVision
>> +	  OV7251 camera.
>> +
>> +	  To compile this driver as a module, choose M here: the
>> +	  module will be called ov7251.
>> +
>>  config VIDEO_OV772X
>>  	tristate "OmniVision OV772x sensor support"
>>  	depends on I2C && VIDEO_V4L2
>> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
>> index ea34aee..c8585b1 100644
>> --- a/drivers/media/i2c/Makefile
>> +++ b/drivers/media/i2c/Makefile
>> @@ -70,6 +70,7 @@ obj-$(CONFIG_VIDEO_OV5647) += ov5647.o
>>  obj-$(CONFIG_VIDEO_OV5670) += ov5670.o
>>  obj-$(CONFIG_VIDEO_OV5695) += ov5695.o
>>  obj-$(CONFIG_VIDEO_OV6650) += ov6650.o
>> +obj-$(CONFIG_VIDEO_OV7251) += ov7251.o
>>  obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
>>  obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
>>  obj-$(CONFIG_VIDEO_OV772X) += ov772x.o
>> diff --git a/drivers/media/i2c/ov7251.c b/drivers/media/i2c/ov7251.c
>> new file mode 100644
>> index 0000000..7b401a9
>> --- /dev/null
>> +++ b/drivers/media/i2c/ov7251.c
>> @@ -0,0 +1,1494 @@

<snip>

>> +static int ov7251_s_power(struct v4l2_subdev *sd, int on)
>> +{
>> +	struct ov7251 *ov7251 = to_ov7251(sd);
>> +	int ret = 0;
>> +
>> +	mutex_lock(&ov7251->power_lock);
>> +
>> +	/*
>> +	 * If the power state is modified from 0 to 1 or from 1 to 0,
>> +	 * update the power state.
>> +	 */
>> +	if (ov7251->power_on == !on) {
> 
>         if (ov7251->power_on == !!on) {
>                 mutex_unlock(&ov7251->power_lock);
>                 return 0;
>         }
> 
> And you can save one indentation level and remove ret initialization.
> 

Good hint, I'd rather save one indentation level by:

	if (ov7251->power_on == !!on)
		goto exit;

> 
>> +		if (on) {
>> +			ret = ov7251_set_power_on(ov7251);
>> +			if (ret < 0)
>> +				goto exit;
>> +
>> +			ret = ov7251_set_register_array(ov7251,
>> +					ov7251_global_init_setting,
>> +					ARRAY_SIZE(ov7251_global_init_setting));
>> +			if (ret < 0) {
>> +				dev_err(ov7251->dev,
>> +					"could not set init registers\n");
>> +				ov7251_set_power_off(ov7251);
>> +				goto exit;
>> +			}
>> +
>> +			ov7251->power_on = true;
>> +		} else {
>> +			ov7251_set_power_off(ov7251);
>> +			ov7251->power_on = false;
>> +		}
>> +	}
>> +
>> +exit:
>> +	mutex_unlock(&ov7251->power_lock);
>> +
>> +	return ret;
>> +}
>> +

<snip>

>> +
>> +static int ov7251_enum_frame_size(struct v4l2_subdev *subdev,
>> +				  struct v4l2_subdev_pad_config *cfg,
>> +				  struct v4l2_subdev_frame_size_enum *fse)
>> +{
> 
> Shouldn't you check for (pad != 0) in all subdev pad operations?
> I see other driver with a single pad doing this...

I looked up now and I can see that this is checked in v4l2-subdev.c
in subdev_do_ioctl() before the driver's callback is called.

> 
> 
>> +	if (fse->code != MEDIA_BUS_FMT_SBGGR10_1X10)
>> +		return -EINVAL;
>> +
>> +	if (fse->index >= ARRAY_SIZE(ov7251_mode_info_data))
>> +		return -EINVAL;
>> +
>> +	fse->min_width = ov7251_mode_info_data[fse->index].width;
>> +	fse->max_width = ov7251_mode_info_data[fse->index].width;
>> +	fse->min_height = ov7251_mode_info_data[fse->index].height;
>> +	fse->max_height = ov7251_mode_info_data[fse->index].height;
>> +
>> +	return 0;
>> +}
>> +

<snip>

>> +
>> +static const struct i2c_device_id ov7251_id[] = {
>> +	{ "ov7251", 0 },
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(i2c, ov7251_id);
>> +
>> +static const struct of_device_id ov7251_of_match[] = {
>> +	{ .compatible = "ovti,ov7251" },
>> +	{ /* sentinel */ }
>> +};
>> +MODULE_DEVICE_TABLE(of, ov7251_of_match);
>> +
>> +static struct i2c_driver ov7251_i2c_driver = {
>> +	.driver = {
>> +		.of_match_table = of_match_ptr(ov7251_of_match),
>> +		.name  = "ov7251",
>> +	},
>> +	.probe  = ov7251_probe,
>> +	.remove = ov7251_remove,
>> +	.id_table = ov7251_id,
> 
> As this driver depends on CONFIG_OF, I've been suggested to use probe_new and
> get rid of i2c id_tables.

Yes, I'll do that.

> 
> With the above nits clarified, and as you addressed my v1 comments:
> 
> Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>

Would you like to see the corrections or I can add the tag before sending them?

> 
> Thanks
>    j
> 
>> +};
>> +
>> +module_i2c_driver(ov7251_i2c_driver);
>> +
>> +MODULE_DESCRIPTION("Omnivision OV7251 Camera Driver");
>> +MODULE_AUTHOR("Todor Tomov <todor.tomov@linaro.org>");
>> +MODULE_LICENSE("GPL v2");

-- 
Best regards,
Todor Tomov
