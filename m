Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:39122 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943234AbcJSOuC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:50:02 -0400
Subject: Re: [PATCH v3 2/2] Add support for Omnivision OV5647
To: Pavel Machek <pavel@ucw.cz>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1476286687.git.roliveir@synopsys.com>
 <17092ffede9eb8aff0d6a7f54ca771e81712b18e.1476286687.git.roliveir@synopsys.com>
 <20161018183133.GA26548@amd>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <mchehab@kernel.org>,
        <davem@davemloft.net>, <geert@linux-m68k.org>,
        <akpm@linux-foundation.org>, <kvalo@codeaurora.org>,
        <linux@roeck-us.net>, <hverkuil@xs4all.nl>, <lars@metafoo.de>,
        <robert.jarzmik@free.fr>, <slongerbeam@gmail.com>,
        <dheitmueller@kernellabs.com>, <pali.rohar@gmail.com>,
        <CARLOS.PALMINHA@synopsys.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <375952b7-7993-b23a-10e8-85cba64b2679@synopsys.com>
Date: Wed, 19 Oct 2016 12:12:00 +0100
MIME-Version: 1.0
In-Reply-To: <20161018183133.GA26548@amd>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On 10/18/2016 7:31 PM, Pavel Machek wrote:
> Hi!
>
>> +/*
>> + * A V4L2 driver for OmniVision OV5647 cameras.
>> + *
>> + * Based on Samsung S5K6AAFX SXGA 1/6" 1.3M CMOS Image Sensor driver
>> + * Copyright (C) 2011 Sylwester Nawrocki <s.nawrocki@samsung.com>
>> + *
>> + * Based on Omnivision OV7670 Camera Driver
>> + * Copyright (C) 2006-7 Jonathan Corbet <corbet@lwn.net>
>> + *
>> + * Copyright (C) 2016, Synopsys, Inc.
>> + *
>> + */
> If you do copyrights, you should also specify license.
>
>> +static bool debug;
>> +module_param(debug, bool, 0644);
>> +MODULE_PARM_DESC(debug, "Debug level (0-1)");
> Please remove, we have generic infrastructure for debugging.
>
>> +/*
>> + * The ov5647 sits on i2c with ID 0x6c
>> + */
>> +#define OV5647_I2C_ADDR 0x6c
>> +#define SENSOR_NAME "ov5647"
>> +
>> +#define OV5647_REG_CHIPID_H	0x300A
>> +#define OV5647_REG_CHIPID_L	0x300B
>> +
>> +#define REG_TERM 0xfffe
>> +#define VAL_TERM 0xfe
>> +#define REG_DLY  0xffff
>> +
>> +/*define the voltage level of control signal*/
> "/* ", " */".
>
>> +#define CSI_STBY_ON		1
>> +#define CSI_STBY_OFF		0
>> +#define CSI_RST_ON		0
>> +#define CSI_RST_OFF		1
>> +#define CSI_PWR_ON		1
>> +#define CSI_PWR_OFF		0
>> +#define CSI_AF_PWR_ON		1
>> +#define CSI_AF_PWR_OFF		0
> ...
>> +enum power_seq_cmd {
>> +	CSI_SUBDEV_PWR_OFF = 0x00,
>> +	CSI_SUBDEV_PWR_ON = 0x01,
>> +};
> Pick one style for defines/enums?
>
>> +struct regval_list {
>> +	uint16_t addr;
>> +	uint8_t data;
>> +};
> u8/u16?

This sensor uses 16 bits for addresses and 8 for data, so I think it makes sense
to keep it this way.

>
>> +/**
>> +* @short I2C Write operation
>> +* @param[in] i2c_client I2C client
>> +* @param[in] reg register address
>> +* @param[in] val value to write
>> +* @return Error code
>> +*/
> " *"?
>
>> +static int ov5647_write(struct v4l2_subdev *sd, uint16_t reg, uint8_t val)
>> +{
>> +	int ret;
>> +	unsigned char data[3] = { reg >> 8, reg & 0xff, val};
> " }".
>
>> +static int ov5647_write_array(struct v4l2_subdev *subdev,
>> +				struct regval_list *regs, int array_size)
>> +{
>> +	int i = 0;
>> +	int ret = 0;
>> +
>> +	if (!regs)
>> +		return -EINVAL;
>> +
>> +	while (i < array_size) {
>> +		if (regs->addr == REG_DLY)
>> +			mdelay(regs->data);
>> +		else
>> +			ret = ov5647_write(subdev, regs->addr, regs->data);
> The "REG_DLY" is never used AFAICT? Remove?
>
>> +		if (ret == -EIO)
>> +			return ret;
>> +
> ov5647_write() can return errors other then EIO. Are they handled correctly?
>
>> +/**
>> + * @short Set SW standby
>> + * @param[in] subdev v4l2 subdev
>> + * @param[in] on_off standby on or off
>> + * @return Error code
>> + */
>> +static int sensor_s_sw_stby(struct v4l2_subdev *subdev, int on_off)
>> +{
>> +	int ret;
>> +	unsigned char rdval;
>> +
>> +	ret = ov5647_read(subdev, 0x0100, &rdval);
>> +	if (ret != 0)
>> +		return ret;
>> +
>> +	if (on_off == CSI_STBY_ON)
>> +		ret = ov5647_write(subdev, 0x0100, rdval&0xfe);
>> +
>> +	else
>> +		ret = ov5647_write(subdev, 0x0100, rdval|0x01);
> I'd get rid of CSI_STBY_ON, and convert arg to bool, as you don't
> really handle other values. Plus, naming it "set_sw_standby()" would
> make core slightly more readable. Also kill the empty line before
> else.
>
>> +/**
>> +* @short Initialize sensor
>> +* @param[in] subdev v4l2 subdev
>> +* @param[in] val not used
>> +* @return Error code
>> +*/
>> +static int __sensor_init(struct v4l2_subdev *subdev)
>> +{
>> +	int ret;
>> +	uint8_t resetval;
>> +	unsigned char rdval;
> u8 for both?
>
>> +	ov5647_read(subdev, 0x0100, &resetval);
>> +		if (!resetval&0x01) {
>> +			v4l2_dbg(1, debug, subdev,
>> +					"DEVICE WAS IN SOFTWARE STANDBY");
> No shouting please? If it is important maybe it should have higher
> priority?
>
>> +static int sensor_power(struct v4l2_subdev *subdev, int on)
>> +{
>> +	int ret;
>> +	struct ov5647 *ov5647 = to_state(subdev);
>> +
>> +	ret = 0;
>> +	mutex_lock(&ov5647->lock);
>> +
>> +	switch (on) {
>> +	case CSI_SUBDEV_PWR_OFF:
> ...
>> +	case CSI_SUBDEV_PWR_ON:
> ...
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	mutex_unlock(&ov5647->lock);
> I'd really convert this to bool. Note how it returns with lock held?
>
>
>> +int ov5647_detect(struct v4l2_subdev *sd)
>> +{
>> +	unsigned char v;
>> +	int ret;
>> +
>> +	ret = sensor_power(sd, 1);
>> +	if (ret < 0)
>> +		return ret;
>> +	ret = ov5647_read(sd, OV5647_REG_CHIPID_H, &v);
>> +	if (ret < 0)
>> +		return ret;
>> +	if (v != 0x56) /* OV manuf. id. */
>> +		return -ENODEV;
>> +	ret = ov5647_read(sd, OV5647_REG_CHIPID_L, &v);
>> +	if (ret < 0)
>> +		return ret;
>> +	if (v != 0x47)
>> +		return -ENODEV;
> I guess invalid chipid deserves a printk?
>
>> +* Refer to Linux errors.
> Useful?
>
>> +/**
>> +* @short of_device_id structure
>> +*/
>> +static const struct i2c_device_id ov5647_id[] = {
> Umm. The comment looks useless and wrong.
>
> Best regards,
> 									Pavel

Thanks for the feedback. I agree with most of your suggestions, and I commented
with the one I didn't agree.

Thanks,
Ramiro

