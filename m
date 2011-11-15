Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58669 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab1KONMb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 08:12:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v2 2/2] as3645a: Add driver for LED flash controller
Date: Tue, 15 Nov 2011 14:12:37 +0100
Cc: linux-media@vger.kernel.org, andriy.shevchenko@linux.intel.com
References: <1321229950-31451-1-git-send-email-laurent.pinchart@ideasonboard.com> <1321229950-31451-3-git-send-email-laurent.pinchart@ideasonboard.com> <4EC0E0C1.6090101@maxwell.research.nokia.com>
In-Reply-To: <4EC0E0C1.6090101@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111151412.39333.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 14 November 2011 10:34:57 Sakari Ailus wrote:
> Hi Laurent,
> 
> Thanks for the patch!! I have a few comments below.

Thanks for the review.

> Laurent Pinchart wrote:
> > This patch adds the driver for the as3645a LED flash controller. This
> > controller supports a high power led in flash and torch modes and an
> > indicator light, sometimes also called privacy light.

[snip]

> > @@ -533,6 +533,13 @@ config VIDEO_ADP1653
> > 
> >  	  This is a driver for the ADP1653 flash controller. It is used for
> >  	  example in Nokia N900.
> > 
> > +config VIDEO_AS3645A
> > +	tristate "AS3645A flash driver support"
> > +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> > +	---help---
> > +	  This is a driver for the AS3645A flash chip. It has build in control
> > +	  for Flash, Torch and Indicator LEDs.
> > +
> 
> You could mention the LM3555 (?) is equal to this; the same driver
> supports it.

OK.

> >  comment "Video improvement chips"
> >  
> >  config VIDEO_UPD64031A
> > 

[snip]

> > diff --git a/drivers/media/video/as3645a.c
> > b/drivers/media/video/as3645a.c new file mode 100644
> > index 0000000..4138eb7
> > --- /dev/null
> > +++ b/drivers/media/video/as3645a.c
> > @@ -0,0 +1,951 @@
> > +/*
> > + * drivers/media/video/as3645a.c
> 
> Same here. This is a "Driver for the as3652a and lm3555 led flash
> controllers." For example.

OK.

> > + * Copyright (C) 2008-2011 Nokia Corporation
> > + *
> > + * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * version 2 as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> > + * General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> > + * 02110-1301 USA
> > + *
> > + * NOTES:
> > + * - Inductor peak current limit setting fixed to 1.75A
> > + * - VREF offset fixed to 0V
> > + *
> > + * TODO:
> > + * - Check hardware FSTROBE control when sensor driver add support for
> > this + *
> > + */

[snip]

> > +struct as3645a {
> > +	struct v4l2_subdev subdev;
> > +	struct as3645a_platform_data *platform_data;
> > +
> > +	struct mutex power_lock;
> > +	int power_count;
> > +
> > +	/* Static parameters */
> > +	u8 vref;
> > +	u8 peak;
> > +
> > +	/* Controls */
> > +	struct v4l2_ctrl_handler ctrls;
> > +
> > +	enum v4l2_flash_led_mode led_mode;
> > +	unsigned int timeout;
> > +	u8 flash_current;
> > +	u8 assist_current;
> > +	u8 indicator_current;
> > +	enum v4l2_flash_strobe_source strobe_source;
> 
> Do you think we should store this information in the controls instead,
> or not?

I've been thinking about that as well. The reason why the control values were 
copied to the as3645a structure is that they were accessed in timer context, 
where taking the control lock wasn't possible.

I could switch to accessing the information in controls directly now, but that 
would require storing pointers to the controls in the as3645a structure, which 
might not be that better :-) And the code will need to change back to storing 
values when overheat protection will be implemented anyway. If you still think 
it's better, I can change it.

> > +};

[snip]

> > +static int as3645a_set_output(struct as3645a *flash, bool strobe)
> > +{
> > +	enum as_mode mode;
> > +	bool on;
> > +	int ret;
> > +
> > +	switch (flash->led_mode) {
> > +	case V4L2_FLASH_LED_MODE_NONE:
> > +		on = flash->indicator_current != 0;
> > +		mode = AS_MODE_INDICATOR;
> > +		break;
> > +	case V4L2_FLASH_LED_MODE_TORCH:
> > +		on = true;
> > +		mode = AS_MODE_ASSIST;
> > +		break;
> > +	case V4L2_FLASH_LED_MODE_FLASH:
> > +		on = strobe;
> > +		mode = AS_MODE_FLASH;
> > +		break;
> > +	default:
> > +		return 0;
> 
> Isn't this expected not to happen ever?

Right, I'll fix that.

> > +	}
> > +
> > +	/* Configure output parameters and operation mode. */
> > +	ret = as3645a_set_control(flash, mode, on);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	return 0;
> > +}

[snip]

> > +static int as3645a_read_fault(struct as3645a *flash)
> > +{
> > +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> > +	int rval;
> > +
> > +	/* NOTE: reading register clear fault status */
> > +	rval = as3645a_read(flash, AS_FAULT_INFO_REG);
> > +	if (rval < 0)
> > +		return rval;
> > +
> > +	if (rval & AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT)
> > +		dev_err(&client->dev, "Inductor Peak limit fault\n");
> > +
> > +	if (rval & AS_FAULT_INFO_INDICATOR_LED)
> > +		dev_err(&client->dev, "Indicator LED fault: "
> > +			"Short circuit or open loop\n");
> > +
> > +	dev_dbg(&client->dev, "%u connected LEDs\n",
> > +		rval & AS_FAULT_INFO_LED_AMOUNT ? 2 : 1);
> > +
> > +	if (rval & AS_FAULT_INFO_TIMEOUT)
> > +		dev_err(&client->dev, "Timeout fault\n");
> > +
> > +	if (rval & AS_FAULT_INFO_OVER_TEMPERATURE)
> > +		dev_err(&client->dev, "Over temperature fault\n");
> > +
> > +	if (rval & AS_FAULT_INFO_SHORT_CIRCUIT)
> > +		dev_err(&client->dev, "Short circuit fault\n");
> > +
> > +	if (rval & AS_FAULT_INFO_OVER_VOLTAGE)
> > +		dev_err(&client->dev, "Over voltage fault: "
> > +			"Indicates missing capacitor or open connection\n");
> 
> Shouldn't at least some of the above use dev_dbg() instead, if not all?

All of them I think. I'll fix that.

> > +	if (rval & ~AS_FAULT_INFO_INDICATOR_LED)
> > +		dev_dbg(&client->dev, "No faults, nice\n");
> > +
> > +	return rval;
> > +}
> > +
> > +static int as3645a_get_ctrl(struct v4l2_ctrl *ctrl)
> > +{
> > +	struct as3645a *flash =
> > +		container_of(ctrl->handler, struct as3645a, ctrls);
> > +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> > +	int fault;
> > +
> > +	switch (ctrl->id) {
> > +	case V4L2_CID_FLASH_FAULT:
> > +		fault = as3645a_read_fault(flash);
> > +		if (fault < 0)
> > +			return fault;
> 
> ctrl->cur.val = 0 here?

fault being negative means that reading the fault register failed. In that 
case I don't think we should update ctrl->cur.val.

> > +
> > +		if (fault & AS_FAULT_INFO_SHORT_CIRCUIT)
> > +			ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
> > +		if (fault & AS_FAULT_INFO_OVER_TEMPERATURE)
> > +			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
> > +		if (fault & AS_FAULT_INFO_TIMEOUT)
> > +			ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
> > +		if (fault & AS_FAULT_INFO_OVER_VOLTAGE)
> > +			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
> > +		if (fault & AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT)
> > +			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_CURRENT;
> > +		if (fault & AS_FAULT_INFO_INDICATOR_LED)
> > +			ctrl->cur.val |= V4L2_FLASH_FAULT_INDICATOR;
> > +		break;
> > +
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	dev_dbg(&client->dev, "G_CTRL %08x:%d\n", ctrl->id, ctrl->cur.val);
> > +
> > +	return 0;
> > +}

[snip]

> > +static int as3645a_registered(struct v4l2_subdev *sd)
> > +{
> > +	struct as3645a *flash = to_as3645a(sd);
> > +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> > +	int rval, man, model, rfu, version;
> > +	const char *factory;
> > +
> > +	/* Power up the flash driver and read manufacturer ID, model ID, RFU
> > +	 * and version.
> > +	 */
> > +	as3645a_set_power(&flash->subdev, 1);
> > +
> > +	rval = as3645a_read(flash, AS_DESIGN_INFO_REG);
> > +	if (rval < 0)
> > +		goto power_off;
> > +
> > +	man = AS_DESIGN_INFO_FACTORY(rval);
> > +	model = AS_DESIGN_INFO_MODEL(rval);
> > +
> > +	rval = as3645a_read(flash, AS_VERSION_CONTROL_REG);
> > +	if (rval < 0)
> > +		goto power_off;
> > +
> > +	rfu = AS_VERSION_CONTROL_RFU(rval);
> > +	version = AS_VERSION_CONTROL_VERSION(rval);
> > +
> > +	/* Verify the chip model and version. */
> > +	if (model != 0x0001 || rfu != 0x0000) {
> > +		dev_err(&client->dev, "AS3645A not detected "
> > +			"(model %d rfu %d)\n", model, rfu);
> > +		rval = -ENODEV;
> 
> Is this so grave issue we should discontinue? I'd perhaps print a
> warning if even that.

This could mean that the chip isn't an AS3645A/LM3555 at all. Many I2C drivers 
perform the same check, they read the ID register and fail if it doesn't 
contain the expected value.

> > +		goto power_off;
> > +	}
> > +
> > +	switch (man) {
> > +	case 1:
> > +		factory = "AMS, Austria Micro Systems";
> > +		break;
> > +	case 2:
> > +		factory = "ADI, Analog Devices Inc.";
> > +		break;
> > +	case 3:
> > +		factory = "NSC, National Semiconductor";
> > +		break;
> > +	case 4:
> > +		factory = "NXP";
> > +		break;
> > +	case 5:
> > +		factory = "TI, Texas Instrument";
> > +		break;
> > +	default:
> > +		factory = "Unknown";
> > +	}
> > +
> > +	dev_dbg(&client->dev, "Factory: %s(%d) Version: %d\n", factory, man,
> > +		version);
> 
> Is that really a factor or is it the chip vendor --- which might
> contract another factory to actually manufacture the chips?

I don't know :-)

> > +	rval = as3645a_write(flash, AS_PASSWORD_REG, AS_PASSWORD_UNLOCK_VALUE);
> > +	if (rval < 0)
> > +		goto power_off;
> > +
> > +	rval = as3645a_write(flash, AS_BOOST_REG, AS_BOOST_CURRENT_DISABLE);
> > +	if (rval < 0)
> > +		goto power_off;
> > +
> > +	/* Setup default values. This makes sure that the chip is in a known
> > +	 * state, in case the power rail can't be controlled.
> > +	 */
> > +	rval = as3645a_setup(flash);
> > +
> > +power_off:
> > +	as3645a_set_power(&flash->subdev, 0);
> > +
> > +	return rval;
> > +}

[snip]

> > +static int as3645a_init_controls(struct as3645a *flash)
> > +{
> > +	struct as3645a_flash_torch_parms *flash_params = NULL;
> > +	bool use_ext_strobe = false;
> > +	unsigned int leds = 2;
> > +	struct v4l2_ctrl *ctrl;
> > +	int minimum;
> > +	int maximum;
> > +
> > +	if (flash->platform_data) {
> > +		if (flash->platform_data->num_leds)
> > +			leds = flash->platform_data->num_leds;
> > +
> > +		flash_params = flash->platform_data->flash_torch_limits;
> > +		use_ext_strobe = flash->platform_data->use_ext_flash_strobe;
> > +	}
> > +
> > +	v4l2_ctrl_handler_init(&flash->ctrls, 9);
> > +
> > +	/* V4L2_CID_FLASH_LED_MODE */
> > +	v4l2_ctrl_new_std_menu(&flash->ctrls, &as3645a_ctrl_ops,
> > +			       V4L2_CID_FLASH_LED_MODE, 2, ~7,
> > +			       V4L2_FLASH_LED_MODE_NONE);
> > +
> > +	/* V4L2_CID_FLASH_STROBE_SOURCE */
> > +	v4l2_ctrl_new_std_menu(&flash->ctrls, &as3645a_ctrl_ops,
> > +			       V4L2_CID_FLASH_STROBE_SOURCE,
> > +			       use_ext_strobe ? 1 : 0, use_ext_strobe ? ~3 : ~1,
> > +			       V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
> > +
> > +	flash->strobe_source = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
> > +
> > +	/* V4L2_CID_FLASH_STROBE */
> > +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > +			  V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
> > +
> > +	/* V4L2_CID_FLASH_STROBE_STOP */
> > +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > +			  V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
> > +
> > +	/* V4L2_CID_FLASH_TIMEOUT */
> > +	if (flash_params) {
> 
> Shouldn't we require valid values for the flash parameters always?
> Chances are very high the default ones for the flash controller won't
> apply for the LED connected to it.

Good question. If no flash parameters are provided the driver uses the chip's 
maximum ratings. I'm fine with both.

> > +		minimum = flash_params->timeout_min;
> > +		maximum = flash_params->timeout_max;
> > +	} else {
> > +		minimum = 1;
> > +		maximum = AS3645A_FLASH_TIMEOUT_MAX;
> > +	}
> > +
> > +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > +			  V4L2_CID_FLASH_TIMEOUT, minimum, maximum,
> > +			  1, maximum);
> > +
> > +	flash->timeout = maximum;
> > +
> > +	/* V4L2_CID_FLASH_INTENSITY */
> > +	if (flash_params) {
> > +		minimum = flash_params->flash_min_current;
> > +		maximum = flash_params->flash_max_current;
> > +	} else {
> > +		minimum = AS3645A_FLASH_INTENSITY_MIN;
> > +		maximum = leds == 1 ? AS3645A_FLASH_INTENSITY_MAX_1LED
> > +				    : AS3645A_FLASH_INTENSITY_MAX_2LEDS;
> > +	}
> > +
> > +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > +			  V4L2_CID_FLASH_INTENSITY, minimum, maximum,
> > +			  AS3645A_FLASH_INTENSITY_STEP, maximum);
> > +
> > +	flash->flash_current = (maximum - AS3645A_FLASH_INTENSITY_MIN)
> > +			     / AS3645A_FLASH_INTENSITY_STEP;
> > +
> > +	/* V4L2_CID_FLASH_TORCH_INTENSITY */
> > +	if (flash_params) {
> > +		minimum = flash_params->torch_min_current;
> > +		maximum = flash_params->torch_max_current;
> > +	} else {
> > +		minimum = AS3645A_TORCH_INTENSITY_MIN;
> > +		maximum = AS3645A_TORCH_INTENSITY_MAX;
> > +	}
> > +
> > +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > +			  V4L2_CID_FLASH_TORCH_INTENSITY, minimum, maximum,
> > +			  AS3645A_TORCH_INTENSITY_STEP, minimum);
> > +
> > +	flash->assist_current = (minimum - AS3645A_TORCH_INTENSITY_MIN)
> > +			      / AS3645A_TORCH_INTENSITY_STEP;
> > +
> > +	/* V4L2_CID_FLASH_INDICATOR_INTENSITY */
> > +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > +			  V4L2_CID_FLASH_INDICATOR_INTENSITY,
> > +			  AS3645A_INDICATOR_INTENSITY_MIN,
> > +			  AS3645A_INDICATOR_INTENSITY_MAX,
> > +			  AS3645A_INDICATOR_INTENSITY_STEP,
> > +			  AS3645A_INDICATOR_INTENSITY_MIN);
> > +
> > +	flash->indicator_current = 0;
> > +
> > +	/* V4L2_CID_FLASH_FAULT */
> > +	ctrl = v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > +				 V4L2_CID_FLASH_FAULT, 0,
> > +				 V4L2_FLASH_FAULT_OVER_VOLTAGE |
> > +				 V4L2_FLASH_FAULT_TIMEOUT |
> > +				 V4L2_FLASH_FAULT_OVER_TEMPERATURE |
> > +				 V4L2_FLASH_FAULT_SHORT_CIRCUIT, 0, 0);
> > +	if (ctrl != NULL)
> > +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> > +
> > +	flash->subdev.ctrl_handler = &flash->ctrls;
> > +
> > +	return flash->ctrls.error;
> > +}
> > +
> > +static int as3645a_probe(struct i2c_client *client,
> > +			 const struct i2c_device_id *devid)
> > +{
> > +	struct as3645a *flash;
> > +	int ret;
> > +
> > +	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
> > +	if (flash == NULL)
> > +		return -ENOMEM;
> > +
> > +	flash->platform_data = client->dev.platform_data;
> > +
> > +	v4l2_i2c_subdev_init(&flash->subdev, client, &as3645a_ops);
> > +	flash->subdev.internal_ops = &as3645a_internal_ops;
> > +	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> > +
> > +	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
> > +	if (ret < 0) {
> > +		kfree(flash);
> > +		return ret;
> > +	}
> 
> +
> + 	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;

OK.

> > +
> > +	mutex_init(&flash->power_lock);
> > +
> > +	/* FIXME: These are hard coded for now */
> > +	flash->vref = 0;	/* 0V */
> > +	flash->peak = 2;	/* 1.75A */
> 
> How about putting these to the platform data?

Sounds good to me.

> > +	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> > +
> > +	ret = as3645a_init_controls(flash);
> > +	if (ret < 0) {
> > +		kfree(flash);
> > +		return ret;
> > +	}
> > +
> > +	return 0;
> > +}

[snip]

> > +struct as3645a_platform_data {
> > +	int (*set_power)(struct v4l2_subdev *subdev, int on);
> > +	/* used to notify the entity which trigger external strobe signal */
> > +	void (*setup_ext_strobe)(int enable);
> > +	/* Sends the strobe width to the sensor strobe configuration */
> > +	void (*set_strobe_width)(u32 width_in_us);
> 
> I don't think we should have the above two callbacks at all. This should
> be controlled from the user space instead.

Should I remove external strobe mode completely then ?

> > +	/* positive value if Torch pin is used */
> > +	int ext_torch;
> 
> ext_torch is unused.

OK.

> > +	/* positive value if Flash Strobe pin is used for triggering
> > +	 * the Flash light (no matter where is connected to, host processor or
> > +	 * image sensor)
> > +	 */
> > +	int use_ext_flash_strobe;
> > +	/* Number of attached LEDs, 1 or 2 */
> > +	int num_leds;
> > +	/* LED limitations with this flash chip */
> > +	struct as3645a_flash_torch_parms *flash_torch_limits;
> 
> This struct could be part of the as3654a_platform_data struct directly.

OK.

> > +};
> > +
> > +#endif /* __AS3645A_H__ */

-- 
Regards,

Laurent Pinchart
