Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45376 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab1EPUaC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 16:30:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [PATCH 3/3] adp1653: Add driver for LED flash controller
Date: Mon, 16 May 2011 22:31:05 +0200
Cc: linux-media@vger.kernel.org, nkanchev@mm-sol.com,
	g.liakhovetski@gmx.de, hverkuil@xs4all.nl, dacohen@gmail.com,
	riverful@gmail.com, andrew.b.adams@gmail.com, shpark7@stanford.edu
References: <4DD11FEC.8050308@maxwell.research.nokia.com> <1305550839-16724-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1305550839-16724-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105162231.06153.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

Thanks for the patch.

On Monday 16 May 2011 15:00:39 Sakari Ailus wrote:
> This patch adds the driver for the adp1653 LED flash controller. This
> controller supports a high power led in flash and torch modes and an
> indicator light, sometimes also called privacy light.
> 
> The adp1653 is used on the Nokia N900.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: David Cohen <dacohen@gmail.com>

[snip]

> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> new file mode 100644
> index 0000000..92ea38b
> --- /dev/null
> +++ b/drivers/media/video/adp1653.c

[snip]

> +/* Write values into ADP1653 registers. */
> +static int adp1653_update_hw(struct adp1653_flash *flash)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	u8 out_sel;
> +	u8 config = 0;
> +	int rval;
> +
> +	out_sel = flash->indicator_intensity->val
> +		<< ADP1653_REG_OUT_SEL_ILED_SHIFT;
> +
> +	switch (flash->led_mode->val) {
> +	case V4L2_FLASH_LED_MODE_NONE:
> +		break;
> +	case V4L2_FLASH_LED_MODE_FLASH:
> +		/* Flash mode, light on with strobe, duration from timer */
> +		config = ADP1653_REG_CONFIG_TMR_CFG;
> +		config |= TIMEOUT_US_TO_CODE(flash->flash_timeout->val)
> +			  << ADP1653_REG_CONFIG_TMR_SET_SHIFT;
> +		break;
> +	case V4L2_FLASH_LED_MODE_TORCH:
> +		/* Torch mode, light immediately on, duration indefinite */
> +		out_sel |= flash->torch_intensity->val
> +			   << ADP1653_REG_OUT_SEL_HPLED_SHIFT;
> +		break;
> +	}
> +
> +	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, out_sel);

out_sel can be used uninitialized here.

> +	if (rval < 0)
> +		return rval;
> +
> +	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_CONFIG, config);
> +	if (rval < 0)
> +		return rval;
> +
> +	return 0;
> +}

[snip]

> +static int adp1653_get_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adp1653_flash *flash =
> +		container_of(ctrl->handler, struct adp1653_flash, ctrls);
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int fault;
> +	int rval;
> +
> +	fault = i2c_smbus_read_byte_data(client, ADP1653_REG_FAULT);
> +	if (IS_ERR_VALUE(fault))
> +		return fault;
> +
> +	/* Clear faults. */
> +	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, 0);
> +	if (IS_ERR_VALUE(rval))
> +		return rval;

If several applications read controls, only one of them will be notified of 
faults. Shouldn't clearing the fault be handled explicitly by writing to a 
control ? I know this changes the API :-)

> +	/* Restore configuration. */
> +	rval = adp1653_update_hw(flash);
> +	if (IS_ERR_VALUE(rval))
> +		return rval;

Will that produce expected results ? For instance, if a fault was detected 
during flash strobe, won't it try to re-strobe the flash ? Shouldn't the user 
be required to explicitly re-strobe the flash or turn the torch (or indicator) 
on after a fault ? Once again this should be clarified in the API :-)

> +	ctrl->cur.val = 0;
> +
> +	if (fault & ADP1653_REG_FAULT_FLT_SCP)
> +		ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
> +	if (fault & ADP1653_REG_FAULT_FLT_OT)
> +		ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
> +	if (fault & ADP1653_REG_FAULT_FLT_TMR)
> +		ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
> +	if (fault & ADP1653_REG_FAULT_FLT_OV)
> +		ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
> +
> +	return 0;
> +}

[snip]

> +static int
> +adp1653_init_device(struct adp1653_flash *flash)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int rval;
> +
> +	/* Clear FAULT register by writing zero to OUT_SEL */
> +	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, 0);
> +	if (rval < 0) {
> +		dev_err(&client->dev, "failed writing fault register\n");
> +		return -EIO;
> +	}
> +
> +	/* Read FAULT register */
> +	rval = i2c_smbus_read_byte_data(client, ADP1653_REG_FAULT);
> +	if (rval < 0) {
> +		dev_err(&client->dev, "failed reading fault register\n");
> +		return -EIO;
> +	}
> +
> +	if ((rval & 0x0f) != 0) {
> +		dev_err(&client->dev, "device fault\n");

You could print the fault value, that could help debugging problems.

> +		return -EIO;
> +	}
> +
> +	mutex_lock(&flash->ctrls.lock);
> +	rval = adp1653_update_hw(flash);
> +	mutex_unlock(&flash->ctrls.lock);
> +	if (rval) {
> +		dev_err(&client->dev,
> +			"adp1653_update_hw failed at %s\n", __func__);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}

[snip]

-- 
Regards,

Laurent Pinchart
