Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49093 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1ERHbZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 03:31:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: [RFC v2 3/3] adp1653: Add driver for LED flash controller
Date: Wed, 18 May 2011 09:31:24 +0200
Cc: linux-media@vger.kernel.org, nkanchev@mm-sol.com,
	g.liakhovetski@gmx.de, hverkuil@xs4all.nl, dacohen@gmail.com,
	riverful@gmail.com, andrew.b.adams@gmail.com, shpark7@stanford.edu
References: <4DD29088.1060703@maxwell.research.nokia.com> <1305645244-11878-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
In-Reply-To: <1305645244-11878-3-git-send-email-sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180931.24827.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Tuesday 17 May 2011 17:14:04 Sakari Ailus wrote:
> This patch adds the driver for the adp1653 LED flash controller. This
> controller supports a high power led in flash and torch modes and an
> indicator light, sometimes also called privacy light.
> 
> The adp1653 is used on the Nokia N900.

[snip]

> diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
> new file mode 100644
> index 0000000..1679707
> --- /dev/null
> +++ b/drivers/media/video/adp1653.c

[snip]

> +static int adp1653_get_fault(struct adp1653_flash *flash)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int fault;
> +	int rval;
> +
> +	fault = i2c_smbus_read_byte_data(client, ADP1653_REG_FAULT);
> +	if (IS_ERR_VALUE(fault))
> +		return fault;
> +
> +	flash->fault |= fault;
> +
> +	if (!flash->fault)
> +		return 0;
> +
> +	/* Clear faults. */
> +	rval = i2c_smbus_write_byte_data(client, ADP1653_REG_OUT_SEL, 0);
> +	if (IS_ERR_VALUE(rval))
> +		return rval;

Should the faults be cleared right away, instead of when the user reads the 
faults control ?

> +	flash->led_mode->val = V4L2_FLASH_LED_MODE_NONE;

Does the hardware switch back to "none" mode when a fault occurs ? The 
datasheet just states that "the ADP1653 is disabled". Does that mean 
temporarily disabled until the faults are cleared ? If so you should update 
the registers to turn the LED off.

> +	return flash->fault;
> +}

[snip]

> +static int adp1653_get_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct adp1653_flash *flash =
> +		container_of(ctrl->handler, struct adp1653_flash, ctrls);
> +
> +	adp1653_get_fault(flash);
> +	if (IS_ERR_VALUE(flash->fault))

Shouldn't you check the adp1653_get_fault() return value instead ?

> +		return flash->fault;
> +
> +	ctrl->cur.val = 0;
> +
> +	if (flash->fault & ADP1653_REG_FAULT_FLT_SCP)
> +		ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
> +	if (flash->fault & ADP1653_REG_FAULT_FLT_OT)
> +		ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
> +	if (flash->fault & ADP1653_REG_FAULT_FLT_TMR)
> +		ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
> +	if (flash->fault & ADP1653_REG_FAULT_FLT_OV)
> +		ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
> +
> +	flash->fault = 0;
> +
> +	return 0;
> +}

[snip]

> +static int
> +adp1653_registered(struct v4l2_subdev *subdev)
> +{
> +	struct adp1653_flash *flash = to_adp1653_flash(subdev);
> +
> +	return adp1653_init_controls(flash);

Can't this be moved to adp1653_probe() ? You could then get rid of the 
registered callback.

> +}
> +
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

Same comment as last time :-)

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
