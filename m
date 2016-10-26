Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:33194 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752060AbcJZLPG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 07:15:06 -0400
Received: by mail-wm0-f48.google.com with SMTP id o81so2734245wma.0
        for <linux-media@vger.kernel.org>; Wed, 26 Oct 2016 04:15:06 -0700 (PDT)
Subject: Re: [PATCH v6 2/2] media: Add a driver for the ov5645 camera sensor.
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mark Brown <broonie@linaro.org>
References: <1473326035-25228-1-git-send-email-todor.tomov@linaro.org>
 <1739314.RkalEXrcbu@avalon> <5800C80D.4000006@linaro.org>
 <2757849.cqAmgViGfT@avalon>
Cc: Todor Tomov <todor.tomov@linaro.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mchehab@osg.samsung.com, hverkuil@xs4all.nl, geert@linux-m68k.org,
        matrandg@cisco.com, sakari.ailus@iki.fi,
        linux-media@vger.kernel.org
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <58109035.5030000@linaro.org>
Date: Wed, 26 Oct 2016 14:15:01 +0300
MIME-Version: 1.0
In-Reply-To: <2757849.cqAmgViGfT@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Adding Mark Brown in --to list.

My reply on comments below.
The question on regulator bulk API to Mark Brown still holds.


On 10/19/2016 11:44 AM, Laurent Pinchart wrote:
> Hi Todor,
> 
> (CC'ing Mark Brown for a question on regulators)
> 
> On Friday 14 Oct 2016 14:57:01 Todor Tomov wrote:
>> Hi Laurent,
>>
>> Thank you for the time spent to do this thorough review of the patch!
>>
>> Below I have removed some of the comments where I agree and I'll fix.
>> I have left the places where I have something relevant to say or ask.
>>
>> On 09/08/2016 03:22 PM, Laurent Pinchart wrote:
>>> On Thursday 08 Sep 2016 12:13:55 Todor Tomov wrote:
>>>> The ov5645 sensor from Omnivision supports up to 2592x1944
>>>> and CSI2 interface.
>>>>
>>>> The driver adds support for the following modes:
>>>> - 1280x960
>>>> - 1920x1080
>>>> - 2592x1944
>>>>
>>>> Output format is packed 8bit UYVY.
>>>>
>>>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>>>> ---
>>>>
>>>>  drivers/media/i2c/Kconfig  |   12 +
>>>>  drivers/media/i2c/Makefile |    1 +
>>>>  drivers/media/i2c/ov5645.c | 1372 ++++++++++++++++++++++++++++++++++++++
>>>>  3 files changed, 1385 insertions(+)
>>>>  create mode 100644 drivers/media/i2c/ov5645.c
>>>
>>> [snip]
>>>
>>>> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
>>>> new file mode 100644
>>>> index 0000000..5e5c37e
>>>> --- /dev/null
>>>> +++ b/drivers/media/i2c/ov5645.c
>>>> @@ -0,0 +1,1372 @@
> 
> [snip]
> 
>>>> +	{ 0x3103, 0x11 },
>>>> +	{ 0x3008, 0x82 },
>>>> +	{ 0x3008, 0x42 },
>>>> +	{ 0x3103, 0x03 },
>>>> +	{ 0x3503, 0x07 },
>>>
>>> [snip]
>>>
>>>> +	{ 0x3503, 0x00 },
>>>
>>> Can't you get rid of the first write to 0x3503 ?
>>
>> No, this is a startup sequence from the vendor so I'm following it as it is.
> 
> 0x3503 controls the AEC/AGC mode, I wonder if that's really needed. I'm OK 
> keeping it as-is for now.

I agree that there is a reason to wonder if it is really needed, but I'd still
prefer not to touch it.

> 
>> [snip]
>>
>>>> +static int ov5645_regulators_enable(struct ov5645 *ov5645)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	ret = regulator_enable(ov5645->io_regulator);
>>>> +	if (ret < 0) {
>>>> +		dev_err(ov5645->dev, "set io voltage failed\n");
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	ret = regulator_enable(ov5645->core_regulator);
>>>> +	if (ret) {
>>>> +		dev_err(ov5645->dev, "set core voltage failed\n");
>>>> +		goto err_disable_io;
>>>> +	}
>>>> +
>>>> +	ret = regulator_enable(ov5645->analog_regulator);
>>>> +	if (ret) {
>>>> +		dev_err(ov5645->dev, "set analog voltage failed\n");
>>>> +		goto err_disable_core;
>>>> +	}
>>>
>>> How about using the regulator bulk API ? This would simplify the enable
>>> and disable functions.
>>
>> The driver must enable the regulators in this order. I can see in the
>> implementation of the bulk api that they are enabled again in order
>> but I don't see stated anywhere that it is guaranteed to follow the
>> same order in future. I'd prefer to keep it explicit as it is now.
> 
> I believe it should be an API guarantee, otherwise many drivers using the bulk 
> API would break. Mark, could you please comment on that ?

Ok, let's wait for a response from Mark.

> 
>> [snip]
>>
>>>> +static int ov5645_set_power_on(struct ov5645 *ov5645)
>>>> +{
>>>> +	int ret;
>>>> +
>>>> +	clk_set_rate(ov5645->xclk, ov5645->xclk_freq);
>>>
>>> Is this needed every time you power the sensor on or could you do it just
>>> once at probe time ?
>>
>> I'll move it at probe time.
>>
>>>> +	ret = clk_prepare_enable(ov5645->xclk);
>>>> +	if (ret < 0) {
>>>> +		dev_err(ov5645->dev, "clk prepare enable failed\n");
>>>> +		return ret;
>>>> +	}
>>>
>>> Is it safe to start the clock before the regulators ? Driving an input of
>>> an unpowered chip can lead to latch-up issues.
>>
>> Correct, power should be enabled first. I'll fix this.
>>
>>>> +	ret = ov5645_regulators_enable(ov5645);
>>>> +	if (ret < 0) {
>>>> +		clk_disable_unprepare(ov5645->xclk);
>>>> +		return ret;
>>>> +	}
>>>> +
>>>> +	usleep_range(5000, 15000);
>>>> +	gpiod_set_value_cansleep(ov5645->enable_gpio, 1);
>>>> +
>>>> +	usleep_range(1000, 2000);
>>>> +	gpiod_set_value_cansleep(ov5645->rst_gpio, 0);
>>>> +
>>>> +	msleep(20);
>>>> +
>>>> +	return ret;
>>>
>>> You can return 0.
>>
>> Ok.
>>
>> [snip]
>>
>>>> +static int ov5645_set_hflip(struct ov5645 *ov5645, s32 value)
>>>> +{
>>>> +	u8 val;
>>>> +	int ret;
>>>> +
>>>> +	ret = ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG21, &val);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (value == 0)
>>>> +		val &= ~(OV5645_SENSOR_MIRROR);
>>>> +	else
>>>> +		val |= (OV5645_SENSOR_MIRROR);
>>>> +
>>>> +	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG21, val);
>>>
>>> You could cache this register too.
>>
>> Ok.
>>
>>>> +}
>>>> +
>>>> +static int ov5645_set_vflip(struct ov5645 *ov5645, s32 value)
>>>> +{
>>>> +	u8 val;
>>>> +	int ret;
>>>> +
>>>> +	ret = ov5645_read_reg(ov5645, OV5645_TIMING_TC_REG20, &val);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (value == 0)
>>>> +		val |= (OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
>>>> +	else
>>>> +		val &= ~(OV5645_SENSOR_VFLIP | OV5645_ISP_VFLIP);
>>>> +
>>>> +	return ov5645_write_reg(ov5645, OV5645_TIMING_TC_REG20, val);
>>>
>>> And this one as well.
>>
>> Yes.
>>
>>> How about using regmap by the way ?
>>
>> I'd prefer to keep it as is for now.
>>
>>>> +}
>>>> +
>>>> +static int ov5645_set_test_pattern(struct ov5645 *ov5645, s32 value)
>>>> +{
>>>> +	u8 val;
>>>> +	int ret;
>>>> +
>>>> +	ret = ov5645_read_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, &val);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (value) {
>>>> +		val &= ~OV5645_SET_TEST_PATTERN(OV5645_TEST_PATTERN_MASK);
>>>> +		val |= OV5645_SET_TEST_PATTERN(value - 1);
>>>> +		val |= OV5645_TEST_PATTERN_ENABLE;
>>>> +	} else {
>>>> +		val &= ~OV5645_TEST_PATTERN_ENABLE;
>>>> +	}
>>>> +
>>>> +	return ov5645_write_reg(ov5645, OV5645_PRE_ISP_TEST_SETTING_1, val);
>>>
>>> Are there other bits that need to be preserved in this register ?
>>
>> This driver is based on the driver for OV5645 from QC and the driver for
>> OV5640 that was sent to linux-media. I cannot add additional functionality
>> so I preserve the rest of the bits. But I'll add caching in a variable here
>> too.
> 
> As far as I know, based on the documentation I've seen, all bits in this 
> register control the test pattern and none need to be preserved. The default 
> reset value of the register is 0x00 and the initialization sequence sets it to 
> 0x00 as well, so it should be safe not caching it.
> 

Ok, then I'll remove any reading or caching for this one.

>>>> +}
>>>> +
>>>> +static const char * const ov5645_test_pattern_menu[] = {
>>>> +	"Disabled",
>>>> +	"Vertical Color Bars",
>>>> +	"Pseudo-Random Data",
>>>> +	"Color Square",
>>>> +	"Black Image",
>>>> +};
>>>> +
>>>> +static int ov5645_set_awb(struct ov5645 *ov5645, s32 enable_auto)
>>>> +{
>>>> +	u8 val;
>>>> +	int ret;
>>>> +
>>>> +	ret = ov5645_read_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, &val);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (enable_auto)
>>>> +		val &= ~OV5645_AWB_MANUAL_ENABLE;
>>>> +	else
>>>> +		val |= OV5645_AWB_MANUAL_ENABLE;
>>>> +
>>>> +	return ov5645_write_reg(ov5645, OV5645_AWB_MANUAL_CONTROL, val);
>>>
>>> Same here, are there other bits that need to be preserved ?
>>
>> Same as above.
> 
> Bits 7:1 are documented as "debug mode" and are set to 0 at reset time. It 
> should be fine not caching this register.
> 

I will remove the reading and caching here too.

>>>> +}
> 
> [snip]
> 
>>>> +static int ov5645_entity_init_cfg(struct v4l2_subdev *subdev,
>>>> +				  struct v4l2_subdev_pad_config *cfg)
>>>> +{
>>>> +	struct v4l2_subdev_format fmt = { 0 };
>>>> +
>>>> +	fmt.which = cfg ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
>>>
>>> The function will always be called with cfg != NULL.
>>
>> I intend to call this function from probe to init the active format. Will
>> this be ok?
> 
> If you plan to call it with cfg == NULL then yes this has to be handled.
> 
>>>> +	fmt.format.width = 1920;
>>>> +	fmt.format.height = 1080;
>>>> +
>>>> +	v4l2_subdev_call(subdev, pad, set_fmt, cfg, &fmt);
>>>
>>> You can call ov5645_set_format directly.
>>
>> Ok.
>>
>>>> +	return 0;
>>>> +}
> 
> [snip]
> 

-- 
Best regards,
Todor Tomov
