Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36751 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752207AbdAYTKp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 14:10:45 -0500
Subject: Re: [PATCH v3 22/24] media: imx: Add MIPI CSI-2 OV5640 sensor subdev
 driver
To: Hans Verkuil <hverkuil@xs4all.nl>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, linux@armlinux.org.uk, mchehab@kernel.org,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org
References: <1483755102-24785-1-git-send-email-steve_longerbeam@mentor.com>
 <1483755102-24785-23-git-send-email-steve_longerbeam@mentor.com>
 <738ab8c3-83ed-cba9-77f4-6c91006d0a18@xs4all.nl>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <62785fbc-74d9-1924-ba85-ce3f06b5b047@gmail.com>
Date: Wed, 25 Jan 2017 11:10:41 -0800
MIME-Version: 1.0
In-Reply-To: <738ab8c3-83ed-cba9-77f4-6c91006d0a18@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/20/2017 06:48 AM, Hans Verkuil wrote:
> On 01/07/2017 03:11 AM, Steve Longerbeam wrote:
>> +
>> +	/* cached control settings */
>> +	int ctrl_cache[OV5640_MAX_CONTROLS];
> This is just duplicating the cached value in the control framework. I think this can be dropped.

done, see below.

>
>> +
>> +static struct ov5640_control ov5640_ctrls[] = {
>> +	{
>> +		.set = ov5640_set_agc,
>> +		.ctrl = {
>> +			.id = V4L2_CID_AUTOGAIN,
>> +			.name = "Auto Gain/Exposure Control",
>> +			.minimum = 0,
>> +			.maximum = 1,
>> +			.step = 1,
>> +			.default_value = 1,
>> +			.type = V4L2_CTRL_TYPE_BOOLEAN,
>> +		},
>> +	}, {
>> +		.set = ov5640_set_exposure,
>> +		.ctrl = {
>> +			.id = V4L2_CID_EXPOSURE,
>> +			.name = "Exposure",
>> +			.minimum = 0,
>> +			.maximum = 65535,
>> +			.step = 1,
>> +			.default_value = 0,
>> +			.type = V4L2_CTRL_TYPE_INTEGER,
>> +		},
>> +	}, {
>> +		.set = ov5640_set_gain,
>> +		.ctrl = {
>> +			.id = V4L2_CID_GAIN,
>> +			.name = "Gain",
>> +			.minimum = 0,
>> +			.maximum = 1023,
>> +			.step = 1,
>> +			.default_value = 0,
>> +			.type = V4L2_CTRL_TYPE_INTEGER,
>> +		},
>> +	}, {
>> +		.set = ov5640_set_hue,
>> +		.ctrl = {
>> +			.id = V4L2_CID_HUE,
>> +			.name = "Hue",
>> +			.minimum = 0,
>> +			.maximum = 359,
>> +			.step = 1,
>> +			.default_value = 0,
>> +			.type = V4L2_CTRL_TYPE_INTEGER,
>> +		},
>> +	}, {
>> +		.set = ov5640_set_contrast,
>> +		.ctrl = {
>> +			.id = V4L2_CID_CONTRAST,
>> +			.name = "Contrast",
>> +			.minimum = 0,
>> +			.maximum = 255,
>> +			.step = 1,
>> +			.default_value = 0,
>> +			.type = V4L2_CTRL_TYPE_INTEGER,
>> +		},
>> +	}, {
>> +		.set = ov5640_set_saturation,
>> +		.ctrl = {
>> +			.id = V4L2_CID_SATURATION,
>> +			.name = "Saturation",
>> +			.minimum = 0,
>> +			.maximum = 255,
>> +			.step = 1,
>> +			.default_value = 64,
>> +			.type = V4L2_CTRL_TYPE_INTEGER,
>> +		},
>> +	}, {
>> +		.set = ov5640_set_awb,
>> +		.ctrl = {
>> +			.id = V4L2_CID_AUTO_WHITE_BALANCE,
>> +			.name = "Auto White Balance",
>> +			.minimum = 0,
>> +			.maximum = 1,
>> +			.step = 1,
>> +			.default_value = 1,
>> +			.type = V4L2_CTRL_TYPE_BOOLEAN,
>> +		},
>> +	}, {
>> +		.set = ov5640_set_red_balance,
>> +		.ctrl = {
>> +			.id = V4L2_CID_RED_BALANCE,
>> +			.name = "Red Balance",
>> +			.minimum = 0,
>> +			.maximum = 4095,
>> +			.step = 1,
>> +			.default_value = 0,
>> +			.type = V4L2_CTRL_TYPE_INTEGER,
>> +		},
>> +	}, {
>> +		.set = ov5640_set_blue_balance,
>> +		.ctrl = {
>> +			.id = V4L2_CID_BLUE_BALANCE,
>> +			.name = "Blue Balance",
>> +			.minimum = 0,
>> +			.maximum = 4095,
>> +			.step = 1,
>> +			.default_value = 0,
>> +			.type = V4L2_CTRL_TYPE_INTEGER,
>> +		},
>> +	},
>> +};
>> +#define OV5640_NUM_CONTROLS ARRAY_SIZE(ov5640_ctrls)
> This should use v4l2_ctrl_new_std() instead of this array.
> Just put a switch on ctrl->id in s_ctrl, and each case calls the corresponding
> set function.

In this case, because there are lots of controls, my preference is to use
table lookup rather than a large switch statement. However I did remove
.name and .type from the table entries, leaving only .def, .min, .max, .step
as required to pass to v4l2_ctrl_new_std(). Also converted to 'struct 
v4l2_ctrl_config'
in the table.


>
>> +
>> +static int ov5640_restore_ctrls(struct ov5640_dev *sensor)
>> +{
>> +	struct ov5640_control *c;
>> +	int i;
>> +
>> +	for (i = 0; i < OV5640_NUM_CONTROLS; i++) {
>> +		c = &ov5640_ctrls[i];
>> +		c->set(sensor, sensor->ctrl_cache[i]);
>> +	}
>> +
>> +	return 0;
>> +}
> This does the same as v4l2_ctrl_handler_setup() if I understand the code correctly.

yes thanks. I remember looking at this and thinking 
v4l2_ctrl_handler_setup()
was setting up the default values rather than the current values, but 
after a
re-read it does look to be restoring the current values, which is 
exactly what
is needed here.

>> +
>> +static int ov5640_init_controls(struct ov5640_dev *sensor)
>> +{
>> +	struct ov5640_control *c;
>> +	int i;
>> +
>> +	v4l2_ctrl_handler_init(&sensor->ctrl_hdl, OV5640_NUM_CONTROLS);
>> +
>> +	for (i = 0; i < OV5640_NUM_CONTROLS; i++) {
>> +		c = &ov5640_ctrls[i];
>> +
>> +		v4l2_ctrl_new_std(&sensor->ctrl_hdl, &ov5640_ctrl_ops,
>> +				  c->ctrl.id, c->ctrl.minimum, c->ctrl.maximum,
>> +				  c->ctrl.step, c->ctrl.default_value);
>> +	}
> As mentioned, just drop the ov5640_ctrls array and call v4l2_ctr_new_std for each
> control you're adding.

if really pressed I can be persuaded to use a switch statement and call
v4l2_ctrl_new_std() multiple times, but I don't any problem with using
a table.

>> +
>> +module_i2c_driver(ov5640_i2c_driver);
>> +
>> +MODULE_AUTHOR("Freescale Semiconductor, Inc.");
>> +MODULE_AUTHOR("Steve Longerbeam <steve_longerbeam@mentor.com>");
>> +MODULE_DESCRIPTION("OV5640 MIPI Camera Subdev Driver");
>> +MODULE_LICENSE("GPL");
>> +MODULE_VERSION("1.0");
>>
> Same comments apply to the next patch, so I won't repeat them.

done, I've made the same mods to the ov5642 subdev.

Steve


