Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:45784 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab1KOP2O (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 10:28:14 -0500
Message-ID: <4EC28506.9080500@maxwell.research.nokia.com>
Date: Tue, 15 Nov 2011 17:28:06 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH v2 2/2] as3645a: Add driver for LED flash controller
References: <1321229950-31451-1-git-send-email-laurent.pinchart@ideasonboard.com> <1321229950-31451-3-git-send-email-laurent.pinchart@ideasonboard.com> <4EC0E0C1.6090101@maxwell.research.nokia.com> <201111151412.39333.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201111151412.39333.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,

Hi Laurent,

> On Monday 14 November 2011 10:34:57 Sakari Ailus wrote:
>> Hi Laurent,
>>
>> Thanks for the patch!! I have a few comments below.
> 
> Thanks for the review.

Thanks for the reply to my review. :-)

...

>>> +struct as3645a {
>>> +	struct v4l2_subdev subdev;
>>> +	struct as3645a_platform_data *platform_data;
>>> +
>>> +	struct mutex power_lock;
>>> +	int power_count;
>>> +
>>> +	/* Static parameters */
>>> +	u8 vref;
>>> +	u8 peak;
>>> +
>>> +	/* Controls */
>>> +	struct v4l2_ctrl_handler ctrls;
>>> +
>>> +	enum v4l2_flash_led_mode led_mode;
>>> +	unsigned int timeout;
>>> +	u8 flash_current;
>>> +	u8 assist_current;
>>> +	u8 indicator_current;
>>> +	enum v4l2_flash_strobe_source strobe_source;
>>
>> Do you think we should store this information in the controls instead,
>> or not?
> 
> I've been thinking about that as well. The reason why the control values were 
> copied to the as3645a structure is that they were accessed in timer context, 
> where taking the control lock wasn't possible.
> 
> I could switch to accessing the information in controls directly now, but that 
> would require storing pointers to the controls in the as3645a structure, which 
> might not be that better :-) And the code will need to change back to storing 
> values when overheat protection will be implemented anyway. If you still think 
> it's better, I can change it.

I think it should stay as-is, at least for now.

...

>>> +	if (rval & ~AS_FAULT_INFO_INDICATOR_LED)
>>> +		dev_dbg(&client->dev, "No faults, nice\n");
>>> +
>>> +	return rval;
>>> +}
>>> +
>>> +static int as3645a_get_ctrl(struct v4l2_ctrl *ctrl)
>>> +{
>>> +	struct as3645a *flash =
>>> +		container_of(ctrl->handler, struct as3645a, ctrls);
>>> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
>>> +	int fault;
>>> +
>>> +	switch (ctrl->id) {
>>> +	case V4L2_CID_FLASH_FAULT:
>>> +		fault = as3645a_read_fault(flash);
>>> +		if (fault < 0)
>>> +			return fault;
>>
>> ctrl->cur.val = 0 here?
> 
> fault being negative means that reading the fault register failed. In that 
> case I don't think we should update ctrl->cur.val.

I thought that ctrl->cur.val should be assigned to zero before settings
bits in it. Does that sound better? :-)

...

>>> +static int as3645a_registered(struct v4l2_subdev *sd)
>>> +{
>>> +	struct as3645a *flash = to_as3645a(sd);
>>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
>>> +	int rval, man, model, rfu, version;
>>> +	const char *factory;
>>> +
>>> +	/* Power up the flash driver and read manufacturer ID, model ID, RFU
>>> +	 * and version.
>>> +	 */
>>> +	as3645a_set_power(&flash->subdev, 1);
>>> +
>>> +	rval = as3645a_read(flash, AS_DESIGN_INFO_REG);
>>> +	if (rval < 0)
>>> +		goto power_off;
>>> +
>>> +	man = AS_DESIGN_INFO_FACTORY(rval);
>>> +	model = AS_DESIGN_INFO_MODEL(rval);
>>> +
>>> +	rval = as3645a_read(flash, AS_VERSION_CONTROL_REG);
>>> +	if (rval < 0)
>>> +		goto power_off;
>>> +
>>> +	rfu = AS_VERSION_CONTROL_RFU(rval);
>>> +	version = AS_VERSION_CONTROL_VERSION(rval);
>>> +
>>> +	/* Verify the chip model and version. */
>>> +	if (model != 0x0001 || rfu != 0x0000) {
>>> +		dev_err(&client->dev, "AS3645A not detected "
>>> +			"(model %d rfu %d)\n", model, rfu);
>>> +		rval = -ENODEV;
>>
>> Is this so grave issue we should discontinue? I'd perhaps print a
>> warning if even that.
> 
> This could mean that the chip isn't an AS3645A/LM3555 at all. Many I2C drivers 
> perform the same check, they read the ID register and fail if it doesn't 
> contain the expected value.

Shouldn't we instead check the design info register has a valid id in it
only? The spec I have doesn't say anything about the version of the
chip. I.e. I'd leave the rfu check out. Also, the registers are 8 bit
wide, with each four fields having four bits in all of them.

>>> +		goto power_off;
>>> +	}
>>> +
>>> +	switch (man) {
>>> +	case 1:
>>> +		factory = "AMS, Austria Micro Systems";
>>> +		break;
>>> +	case 2:
>>> +		factory = "ADI, Analog Devices Inc.";
>>> +		break;
>>> +	case 3:
>>> +		factory = "NSC, National Semiconductor";
>>> +		break;
>>> +	case 4:
>>> +		factory = "NXP";
>>> +		break;
>>> +	case 5:
>>> +		factory = "TI, Texas Instrument";
>>> +		break;
>>> +	default:
>>> +		factory = "Unknown";
>>> +	}
>>> +
>>> +	dev_dbg(&client->dev, "Factory: %s(%d) Version: %d\n", factory, man,
>>> +		version);
>>
>> Is that really a factor or is it the chip vendor --- which might
>> contract another factory to actually manufacture the chips?
> 
> I don't know :-)
> 
>>> +	rval = as3645a_write(flash, AS_PASSWORD_REG, AS_PASSWORD_UNLOCK_VALUE);
>>> +	if (rval < 0)
>>> +		goto power_off;
>>> +
>>> +	rval = as3645a_write(flash, AS_BOOST_REG, AS_BOOST_CURRENT_DISABLE);
>>> +	if (rval < 0)
>>> +		goto power_off;
>>> +
>>> +	/* Setup default values. This makes sure that the chip is in a known
>>> +	 * state, in case the power rail can't be controlled.
>>> +	 */
>>> +	rval = as3645a_setup(flash);
>>> +
>>> +power_off:
>>> +	as3645a_set_power(&flash->subdev, 0);
>>> +
>>> +	return rval;
>>> +}
> 
> [snip]
> 
>>> +static int as3645a_init_controls(struct as3645a *flash)
>>> +{
>>> +	struct as3645a_flash_torch_parms *flash_params = NULL;
>>> +	bool use_ext_strobe = false;
>>> +	unsigned int leds = 2;
>>> +	struct v4l2_ctrl *ctrl;
>>> +	int minimum;
>>> +	int maximum;
>>> +
>>> +	if (flash->platform_data) {
>>> +		if (flash->platform_data->num_leds)
>>> +			leds = flash->platform_data->num_leds;
>>> +
>>> +		flash_params = flash->platform_data->flash_torch_limits;
>>> +		use_ext_strobe = flash->platform_data->use_ext_flash_strobe;
>>> +	}
>>> +
>>> +	v4l2_ctrl_handler_init(&flash->ctrls, 9);
>>> +
>>> +	/* V4L2_CID_FLASH_LED_MODE */
>>> +	v4l2_ctrl_new_std_menu(&flash->ctrls, &as3645a_ctrl_ops,
>>> +			       V4L2_CID_FLASH_LED_MODE, 2, ~7,
>>> +			       V4L2_FLASH_LED_MODE_NONE);
>>> +
>>> +	/* V4L2_CID_FLASH_STROBE_SOURCE */
>>> +	v4l2_ctrl_new_std_menu(&flash->ctrls, &as3645a_ctrl_ops,
>>> +			       V4L2_CID_FLASH_STROBE_SOURCE,
>>> +			       use_ext_strobe ? 1 : 0, use_ext_strobe ? ~3 : ~1,
>>> +			       V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
>>> +
>>> +	flash->strobe_source = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
>>> +
>>> +	/* V4L2_CID_FLASH_STROBE */
>>> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
>>> +			  V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
>>> +
>>> +	/* V4L2_CID_FLASH_STROBE_STOP */
>>> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
>>> +			  V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
>>> +
>>> +	/* V4L2_CID_FLASH_TIMEOUT */
>>> +	if (flash_params) {
>>
>> Shouldn't we require valid values for the flash parameters always?
>> Chances are very high the default ones for the flash controller won't
>> apply for the LED connected to it.
> 
> Good question. If no flash parameters are provided the driver uses the chip's 
> maximum ratings. I'm fine with both.

I guess that the most common case of nonexistent flash current and
timeout limits could be just telling they're missing for a reason or
another, which can be harmful for the hardware. I'd require them.

...

>>> +struct as3645a_platform_data {
>>> +	int (*set_power)(struct v4l2_subdev *subdev, int on);
>>> +	/* used to notify the entity which trigger external strobe signal */
>>> +	void (*setup_ext_strobe)(int enable);
>>> +	/* Sends the strobe width to the sensor strobe configuration */
>>> +	void (*set_strobe_width)(u32 width_in_us);
>>
>> I don't think we should have the above two callbacks at all. This should
>> be controlled from the user space instead.
> 
> Should I remove external strobe mode completely then ?

Not necessarily. I think the control should come from the sensor (or
whichever component is controlling the external strobe) instead. Another
question is then how this should interact with the flash temperature
protection code.

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
