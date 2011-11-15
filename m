Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38219 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756430Ab1KOPxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 10:53:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH v2 2/2] as3645a: Add driver for LED flash controller
Date: Tue, 15 Nov 2011 16:53:51 +0100
Cc: linux-media@vger.kernel.org, andriy.shevchenko@linux.intel.com
References: <1321229950-31451-1-git-send-email-laurent.pinchart@ideasonboard.com> <201111151412.39333.laurent.pinchart@ideasonboard.com> <4EC28506.9080500@maxwell.research.nokia.com>
In-Reply-To: <4EC28506.9080500@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111151653.53565.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tuesday 15 November 2011 16:28:06 Sakari Ailus wrote:
> Laurent Pinchart wrote:
> > On Monday 14 November 2011 10:34:57 Sakari Ailus wrote:

[snip]

> >>> +	if (rval & ~AS_FAULT_INFO_INDICATOR_LED)
> >>> +		dev_dbg(&client->dev, "No faults, nice\n");
> >>> +
> >>> +	return rval;
> >>> +}
> >>> +
> >>> +static int as3645a_get_ctrl(struct v4l2_ctrl *ctrl)
> >>> +{
> >>> +	struct as3645a *flash =
> >>> +		container_of(ctrl->handler, struct as3645a, ctrls);
> >>> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> >>> +	int fault;
> >>> +
> >>> +	switch (ctrl->id) {
> >>> +	case V4L2_CID_FLASH_FAULT:
> >>> +		fault = as3645a_read_fault(flash);
> >>> +		if (fault < 0)
> >>> +			return fault;
> >> 
> >> ctrl->cur.val = 0 here?
> > 
> > fault being negative means that reading the fault register failed. In
> > that case I don't think we should update ctrl->cur.val.
> 
> I thought that ctrl->cur.val should be assigned to zero before settings
> bits in it. Does that sound better? :-)

Oops, my bad, I misunderstood your comment. I'll fix that.

> >>> +static int as3645a_registered(struct v4l2_subdev *sd)
> >>> +{
> >>> +	struct as3645a *flash = to_as3645a(sd);
> >>> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >>> +	int rval, man, model, rfu, version;
> >>> +	const char *factory;
> >>> +
> >>> +	/* Power up the flash driver and read manufacturer ID, model ID, RFU
> >>> +	 * and version.
> >>> +	 */
> >>> +	as3645a_set_power(&flash->subdev, 1);
> >>> +
> >>> +	rval = as3645a_read(flash, AS_DESIGN_INFO_REG);
> >>> +	if (rval < 0)
> >>> +		goto power_off;
> >>> +
> >>> +	man = AS_DESIGN_INFO_FACTORY(rval);
> >>> +	model = AS_DESIGN_INFO_MODEL(rval);
> >>> +
> >>> +	rval = as3645a_read(flash, AS_VERSION_CONTROL_REG);
> >>> +	if (rval < 0)
> >>> +		goto power_off;
> >>> +
> >>> +	rfu = AS_VERSION_CONTROL_RFU(rval);
> >>> +	version = AS_VERSION_CONTROL_VERSION(rval);
> >>> +
> >>> +	/* Verify the chip model and version. */
> >>> +	if (model != 0x0001 || rfu != 0x0000) {
> >>> +		dev_err(&client->dev, "AS3645A not detected "
> >>> +			"(model %d rfu %d)\n", model, rfu);
> >>> +		rval = -ENODEV;
> >> 
> >> Is this so grave issue we should discontinue? I'd perhaps print a
> >> warning if even that.
> > 
> > This could mean that the chip isn't an AS3645A/LM3555 at all. Many I2C
> > drivers perform the same check, they read the ID register and fail if it
> > doesn't contain the expected value.
> 
> Shouldn't we instead check the design info register has a valid id in it
> only? The spec I have doesn't say anything about the version of the
> chip.

I agree that checking the model shoudl be enough. However, if a new chip comes 
out with an RFU value != 0, it will probably mean that the driver will need to 
be adapted anyway. Isn't it better to catch that instead of ignoring it ?

> I.e. I'd leave the rfu check out. Also, the registers are 8 bit
> wide, with each four fields having four bits in all of them.

[snip]

> >>> +static int as3645a_init_controls(struct as3645a *flash)
> >>> +{
> >>> +	struct as3645a_flash_torch_parms *flash_params = NULL;
> >>> +	bool use_ext_strobe = false;
> >>> +	unsigned int leds = 2;
> >>> +	struct v4l2_ctrl *ctrl;
> >>> +	int minimum;
> >>> +	int maximum;
> >>> +
> >>> +	if (flash->platform_data) {
> >>> +		if (flash->platform_data->num_leds)
> >>> +			leds = flash->platform_data->num_leds;
> >>> +
> >>> +		flash_params = flash->platform_data->flash_torch_limits;
> >>> +		use_ext_strobe = flash->platform_data->use_ext_flash_strobe;
> >>> +	}
> >>> +
> >>> +	v4l2_ctrl_handler_init(&flash->ctrls, 9);
> >>> +
> >>> +	/* V4L2_CID_FLASH_LED_MODE */
> >>> +	v4l2_ctrl_new_std_menu(&flash->ctrls, &as3645a_ctrl_ops,
> >>> +			       V4L2_CID_FLASH_LED_MODE, 2, ~7,
> >>> +			       V4L2_FLASH_LED_MODE_NONE);
> >>> +
> >>> +	/* V4L2_CID_FLASH_STROBE_SOURCE */
> >>> +	v4l2_ctrl_new_std_menu(&flash->ctrls, &as3645a_ctrl_ops,
> >>> +			       V4L2_CID_FLASH_STROBE_SOURCE,
> >>> +			       use_ext_strobe ? 1 : 0, use_ext_strobe ? ~3 : ~1,
> >>> +			       V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
> >>> +
> >>> +	flash->strobe_source = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
> >>> +
> >>> +	/* V4L2_CID_FLASH_STROBE */
> >>> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> >>> +			  V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
> >>> +
> >>> +	/* V4L2_CID_FLASH_STROBE_STOP */
> >>> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> >>> +			  V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
> >>> +
> >>> +	/* V4L2_CID_FLASH_TIMEOUT */
> >>> +	if (flash_params) {
> >> 
> >> Shouldn't we require valid values for the flash parameters always?
> >> Chances are very high the default ones for the flash controller won't
> >> apply for the LED connected to it.
> > 
> > Good question. If no flash parameters are provided the driver uses the
> > chip's maximum ratings. I'm fine with both.
> 
> I guess that the most common case of nonexistent flash current and
> timeout limits could be just telling they're missing for a reason or
> another, which can be harmful for the hardware. I'd require them.

OK.

> >>> +struct as3645a_platform_data {
> >>> +	int (*set_power)(struct v4l2_subdev *subdev, int on);
> >>> +	/* used to notify the entity which trigger external strobe signal */
> >>> +	void (*setup_ext_strobe)(int enable);
> >>> +	/* Sends the strobe width to the sensor strobe configuration */
> >>> +	void (*set_strobe_width)(u32 width_in_us);
> >> 
> >> I don't think we should have the above two callbacks at all. This should
> >> be controlled from the user space instead.
> > 
> > Should I remove external strobe mode completely then ?
> 
> Not necessarily. I think the control should come from the sensor (or
> whichever component is controlling the external strobe) instead. Another
> question is then how this should interact with the flash temperature
> protection code.

OK, I'll keep external strobe mode.

v4 is on its way.

-- 
Regards,

Laurent Pinchart
