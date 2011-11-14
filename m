Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:39357 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab1KNJfF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 04:35:05 -0500
Message-ID: <4EC0E0C1.6090101@maxwell.research.nokia.com>
Date: Mon, 14 Nov 2011 11:34:57 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, andriy.shevchenko@linux.intel.com
Subject: Re: [PATCH v2 2/2] as3645a: Add driver for LED flash controller
References: <1321229950-31451-1-git-send-email-laurent.pinchart@ideasonboard.com> <1321229950-31451-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1321229950-31451-3-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Laurent,

Thanks for the patch!! I have a few comments below.

Laurent Pinchart wrote:
> This patch adds the driver for the as3645a LED flash controller. This
> controller supports a high power led in flash and torch modes and an
> indicator light, sometimes also called privacy light.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Nayden Kanchev <nkanchev@mm-sol.com>
> Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
> Signed-off-by: Antti Koskipaa <antti.koskipaa@gmail.com>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Signed-off-by: Mika Westerberg <ext-mika.1.westerberg@nokia.com>
> Signed-off-by: David Cohen <dacohen@gmail.com>
> ---
>  drivers/media/video/Kconfig   |    7 +
>  drivers/media/video/Makefile  |    1 +
>  drivers/media/video/as3645a.c |  951 +++++++++++++++++++++++++++++++++++++++++
>  include/media/as3645a.h       |   69 +++
>  4 files changed, 1028 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/as3645a.c
>  create mode 100644 include/media/as3645a.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 4e8a0c4..ba27f89 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -533,6 +533,13 @@ config VIDEO_ADP1653
>  	  This is a driver for the ADP1653 flash controller. It is used for
>  	  example in Nokia N900.
>  
> +config VIDEO_AS3645A
> +	tristate "AS3645A flash driver support"
> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +	---help---
> +	  This is a driver for the AS3645A flash chip. It has build in control
> +	  for Flash, Torch and Indicator LEDs.
> +

You could mention the LM3555 (?) is equal to this; the same driver
supports it.

>  comment "Video improvement chips"
>  
>  config VIDEO_UPD64031A
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index ddeaa6c..86aabd6 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -74,6 +74,7 @@ obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
>  obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
>  obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
>  obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
> +obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
>  
>  obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
>  obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
> diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> new file mode 100644
> index 0000000..4138eb7
> --- /dev/null
> +++ b/drivers/media/video/as3645a.c
> @@ -0,0 +1,951 @@
> +/*
> + * drivers/media/video/as3645a.c

Same here. This is a "Driver for the as3652a and lm3555 led flash
controllers." For example.

> + * Copyright (C) 2008-2011 Nokia Corporation
> + *
> + * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + * NOTES:
> + * - Inductor peak current limit setting fixed to 1.75A
> + * - VREF offset fixed to 0V
> + *
> + * TODO:
> + * - Check hardware FSTROBE control when sensor driver add support for this
> + *
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/mutex.h>
> +
> +#include <media/as3645a.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define AS_TIMER_MS_TO_CODE(t)			(((t) - 100) / 50)
> +#define AS_TIMER_CODE_TO_MS(c)			(50 * (c) + 100)
> +
> +/* Register definitions */
> +
> +/* Read-only Design info register: Reset state: xxxx 0001 */
> +#define AS_DESIGN_INFO_REG			0x00
> +#define AS_DESIGN_INFO_FACTORY(x)		(((x) >> 4))
> +#define AS_DESIGN_INFO_MODEL(x)			((x) & 0x0f)
> +
> +/* Read-only Version control register: Reset state: 0000 0000
> + * for first engineering samples
> + */
> +#define AS_VERSION_CONTROL_REG			0x01
> +#define AS_VERSION_CONTROL_RFU(x)		(((x) >> 4))
> +#define AS_VERSION_CONTROL_VERSION(x)		((x) & 0x0f)
> +
> +/* Read / Write	(Indicator and timer register): Reset state: 0000 1111 */
> +#define AS_INDICATOR_AND_TIMER_REG		0x02
> +#define AS_INDICATOR_AND_TIMER_TIMEOUT_SHIFT	0
> +#define AS_INDICATOR_AND_TIMER_VREF_SHIFT	4
> +#define AS_INDICATOR_AND_TIMER_INDICATOR_SHIFT	6
> +
> +/* Read / Write	(Current set register): Reset state: 0110 1001 */
> +#define AS_CURRENT_SET_REG			0x03
> +#define AS_CURRENT_ASSIST_LIGHT_SHIFT		0
> +#define AS_CURRENT_LED_DET_ON			(1 << 3)
> +#define AS_CURRENT_FLASH_CURRENT_SHIFT		4
> +
> +/* Read / Write	(Control register): Reset state: 1011 0100 */
> +#define AS_CONTROL_REG				0x04
> +#define AS_CONTROL_MODE_SETTING_SHIFT		0
> +#define AS_CONTROL_STROBE_ON			(1 << 2)
> +#define AS_CONTROL_OUT_ON			(1 << 3)
> +#define AS_CONTROL_EXT_TORCH_ON			(1 << 4)
> +#define AS_CONTROL_STROBE_TYPE_EDGE		(0 << 5)
> +#define AS_CONTROL_STROBE_TYPE_LEVEL		(1 << 5)
> +#define AS_CONTROL_COIL_PEAK_SHIFT		6
> +
> +/* Read only (D3 is read / write) (Fault and info): Reset state: 0000 x000 */
> +#define AS_FAULT_INFO_REG			0x05
> +#define AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT	(1 << 1)
> +#define AS_FAULT_INFO_INDICATOR_LED		(1 << 2)
> +#define AS_FAULT_INFO_LED_AMOUNT		(1 << 3)
> +#define AS_FAULT_INFO_TIMEOUT			(1 << 4)
> +#define AS_FAULT_INFO_OVER_TEMPERATURE		(1 << 5)
> +#define AS_FAULT_INFO_SHORT_CIRCUIT		(1 << 6)
> +#define AS_FAULT_INFO_OVER_VOLTAGE		(1 << 7)
> +
> +/* Boost register */
> +#define AS_BOOST_REG				0x0d
> +#define AS_BOOST_CURRENT_DISABLE		(0 << 0)
> +#define AS_BOOST_CURRENT_ENABLE			(1 << 0)
> +
> +/* Password register is used to unlock boost register writing */
> +#define AS_PASSWORD_REG				0x0f
> +#define AS_PASSWORD_UNLOCK_VALUE		0x55
> +
> +/* AS_CONTROL_EXT_TORCH_ON - on, 0 - off */
> +#define TORCH_IN_STANDBY			0
> +
> +#define AS3645A_FLASH_TIMEOUT_MIN		100000	/* us */
> +#define AS3645A_FLASH_TIMEOUT_MAX		850000
> +#define AS3645A_FLASH_TIMEOUT_STEP		50000
> +
> +#define AS3645A_FLASH_INTENSITY_MIN		200	/* mA */
> +#define AS3645A_FLASH_INTENSITY_MAX_1LED	500
> +#define AS3645A_FLASH_INTENSITY_MAX_2LEDS	400
> +#define AS3645A_FLASH_INTENSITY_STEP		20
> +
> +#define AS3645A_TORCH_INTENSITY_MIN		20	/* mA */
> +#define AS3645A_TORCH_INTENSITY_MAX		160
> +#define AS3645A_TORCH_INTENSITY_STEP		20
> +
> +#define AS3645A_INDICATOR_INTENSITY_MIN		0	/* uA */
> +#define AS3645A_INDICATOR_INTENSITY_MAX		10000
> +#define AS3645A_INDICATOR_INTENSITY_STEP	2500
> +
> +enum as_mode {
> +	AS_MODE_EXT_TORCH = 0 << AS_CONTROL_MODE_SETTING_SHIFT,
> +	AS_MODE_INDICATOR = 1 << AS_CONTROL_MODE_SETTING_SHIFT,
> +	AS_MODE_ASSIST = 2 << AS_CONTROL_MODE_SETTING_SHIFT,
> +	AS_MODE_FLASH = 3 << AS_CONTROL_MODE_SETTING_SHIFT,
> +};
> +
> +/*
> + * struct as3645a
> + *
> + * @subdev:		V4L2 subdev
> + * @platform_data:	Flash platform data
> + * @power_lock:		Protects power_count
> + * @power_count:	Power reference count
> + * @vref:		VREF offset (0=0V, 1=+0.3V, 2=-0.3V, 3=+0.6V)
> + * @peak:		Inductor peak current limit (0=1.25A, 1=1.5A, 2=1.75A,
> + *			3=2.0A)
> + * @led_mode:		V4L2 flash LED mode
> + * @timeout:		Flash timeout in microseconds
> + * @flash_current:	Flash current (0=200mA ... 15=500mA). Maximum
> + *			values are 400mA for two LEDs and 500mA for one LED.
> + * @assist_current:	Torch/Assist light current (0=20mA, 1=40mA ... 7=160mA)
> + * @indicator_current:	Indicator LED current (0=0mA, 1=2.5mA ... 4=10mA)
> + * @strobe_source:	Flash strobe source (software or external)
> + */
> +struct as3645a {
> +	struct v4l2_subdev subdev;
> +	struct as3645a_platform_data *platform_data;
> +
> +	struct mutex power_lock;
> +	int power_count;
> +
> +	/* Static parameters */
> +	u8 vref;
> +	u8 peak;
> +
> +	/* Controls */
> +	struct v4l2_ctrl_handler ctrls;
> +
> +	enum v4l2_flash_led_mode led_mode;
> +	unsigned int timeout;
> +	u8 flash_current;
> +	u8 assist_current;
> +	u8 indicator_current;
> +	enum v4l2_flash_strobe_source strobe_source;

Do you think we should store this information in the controls instead,
or not?

> +};
> +
> +#define to_as3645a(sd) container_of(sd, struct as3645a, subdev)
> +
> +/* Return negative errno else zero on success */
> +static int as3645a_write(struct as3645a *flash, u8 addr, u8 val)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int rval;
> +
> +	rval = i2c_smbus_write_byte_data(client, addr, val);
> +
> +	dev_dbg(&client->dev, "Write Addr:%02X Val:%02X %s\n", addr, val,
> +		rval < 0 ? "fail" : "ok");
> +
> +	return rval;
> +}
> +
> +/* Return negative errno else a data byte received from the device. */
> +static int as3645a_read(struct as3645a *flash, u8 addr)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int rval;
> +
> +	rval = i2c_smbus_read_byte_data(client, addr);
> +
> +	dev_dbg(&client->dev, "Read Addr:%02X Val:%02X %s\n", addr, rval,
> +		rval < 0 ? "fail" : "ok");
> +
> +	return rval;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Hardware configuration and trigger
> + */
> +
> +/*
> + * as3645a_set_config - Set flash configuration registers
> + * @flash: The flash
> + *
> + * Configure the hardware with flash, assist and indicator currents, as well as
> + * flash timeout.
> + *
> + * Return 0 on success, or a negative error code if an I2C communication error
> + * occurred.
> + */
> +static int as3645a_set_config(struct as3645a *flash)
> +{
> +	int ret;
> +	u8 val;
> +
> +	val = (flash->flash_current << AS_CURRENT_FLASH_CURRENT_SHIFT)
> +	    | (flash->assist_current << AS_CURRENT_ASSIST_LIGHT_SHIFT)
> +	    | AS_CURRENT_LED_DET_ON;
> +
> +	ret = as3645a_write(flash, AS_CURRENT_SET_REG, val);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (flash->strobe_source == V4L2_FLASH_STROBE_SOURCE_EXTERNAL) {
> +		/* Use timeout to protect the flash in case the external
> +		 * strobe gets stuck. Minimum value 100 ms, maximum 850 ms.
> +		 */
> +		u32 timeout = DIV_ROUND_UP(flash->timeout, 1000);
> +		timeout = max_t(u32, DIV_ROUND_UP(timeout, 50) * 50, 100);
> +		val = AS_TIMER_MS_TO_CODE(timeout)
> +		    << AS_INDICATOR_AND_TIMER_TIMEOUT_SHIFT;
> +	} else {
> +		val = AS_TIMER_MS_TO_CODE(flash->timeout / 1000)
> +		    << AS_INDICATOR_AND_TIMER_TIMEOUT_SHIFT;
> +	}
> +
> +	val |= (flash->vref << AS_INDICATOR_AND_TIMER_VREF_SHIFT)
> +	    |  ((flash->indicator_current ? flash->indicator_current - 1 : 0)
> +		 << AS_INDICATOR_AND_TIMER_INDICATOR_SHIFT);
> +
> +	return as3645a_write(flash, AS_INDICATOR_AND_TIMER_REG, val);
> +}
> +
> +/*
> + * as3645a_set_control - Set flash control register
> + * @flash: The flash
> + * @mode: Desired output mode
> + * @on: Desired output state
> + *
> + * Configure the hardware with output mode and state.
> + *
> + * Return 0 on success, or a negative error code if an I2C communication error
> + * occurred.
> + */
> +static int
> +as3645a_set_control(struct as3645a *flash, enum as_mode mode, bool on)
> +{
> +	u8 reg;
> +
> +	/* Configure output parameters and operation mode. */
> +	reg = (flash->peak << AS_CONTROL_COIL_PEAK_SHIFT)
> +	    | TORCH_IN_STANDBY
> +	    | (on ? AS_CONTROL_OUT_ON : 0)
> +	    | mode;
> +
> +	if (flash->led_mode == V4L2_FLASH_LED_MODE_FLASH &&
> +	    flash->strobe_source == V4L2_FLASH_STROBE_SOURCE_EXTERNAL) {
> +		if (flash->platform_data->setup_ext_strobe)
> +			flash->platform_data->setup_ext_strobe(1);
> +		reg |= AS_CONTROL_STROBE_TYPE_LEVEL
> +		    |  AS_CONTROL_STROBE_ON;
> +	}
> +
> +	return as3645a_write(flash, AS_CONTROL_REG, reg);
> +}
> +
> +/*
> + * as3645a_set_output - Configure output and operation mode
> + * @flash: Flash controller
> + * @strobe: Strobe the flash (only valid in flash mode)
> + *
> + * Turn the LEDs output on/off and set the operation mode based on the current
> + * parameters.
> + *
> + * The AS3645A can't control the indicator LED independently of the flash/torch
> + * LED. If the flash controller is in V4L2_FLASH_LED_MODE_NONE mode, set the
> + * chip to indicator mode. Otherwise set it to assist light (torch) or flash
> + * mode.
> + *
> + * In indicator and assist modes, turn the output on/off based on the indicator
> + * and torch currents. In software strobe flash mode, turn the output on/off
> + * based on the strobe parameter.
> + */
> +static int as3645a_set_output(struct as3645a *flash, bool strobe)
> +{
> +	enum as_mode mode;
> +	bool on;
> +	int ret;
> +
> +	switch (flash->led_mode) {
> +	case V4L2_FLASH_LED_MODE_NONE:
> +		on = flash->indicator_current != 0;
> +		mode = AS_MODE_INDICATOR;
> +		break;
> +	case V4L2_FLASH_LED_MODE_TORCH:
> +		on = true;
> +		mode = AS_MODE_ASSIST;
> +		break;
> +	case V4L2_FLASH_LED_MODE_FLASH:
> +		on = strobe;
> +		mode = AS_MODE_FLASH;
> +		break;
> +	default:
> +		return 0;

Isn't this expected not to happen ever?

> +	}
> +
> +	/* Configure output parameters and operation mode. */
> +	ret = as3645a_set_control(flash, mode, on);
> +	if (ret < 0)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 controls
> + */
> +
> +static int as3645a_read_fault(struct as3645a *flash)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int rval;
> +
> +	/* NOTE: reading register clear fault status */
> +	rval = as3645a_read(flash, AS_FAULT_INFO_REG);
> +	if (rval < 0)
> +		return rval;
> +
> +	if (rval & AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT)
> +		dev_err(&client->dev, "Inductor Peak limit fault\n");
> +
> +	if (rval & AS_FAULT_INFO_INDICATOR_LED)
> +		dev_err(&client->dev, "Indicator LED fault: "
> +			"Short circuit or open loop\n");
> +
> +	dev_dbg(&client->dev, "%u connected LEDs\n",
> +		rval & AS_FAULT_INFO_LED_AMOUNT ? 2 : 1);
> +
> +	if (rval & AS_FAULT_INFO_TIMEOUT)
> +		dev_err(&client->dev, "Timeout fault\n");
> +
> +	if (rval & AS_FAULT_INFO_OVER_TEMPERATURE)
> +		dev_err(&client->dev, "Over temperature fault\n");
> +
> +	if (rval & AS_FAULT_INFO_SHORT_CIRCUIT)
> +		dev_err(&client->dev, "Short circuit fault\n");
> +
> +	if (rval & AS_FAULT_INFO_OVER_VOLTAGE)
> +		dev_err(&client->dev, "Over voltage fault: "
> +			"Indicates missing capacitor or open connection\n");

Shouldn't at least some of the above use dev_dbg() instead, if not all?

> +	if (rval & ~AS_FAULT_INFO_INDICATOR_LED)
> +		dev_dbg(&client->dev, "No faults, nice\n");
> +
> +	return rval;
> +}
> +
> +static int as3645a_get_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct as3645a *flash =
> +		container_of(ctrl->handler, struct as3645a, ctrls);
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int fault;
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_FLASH_FAULT:
> +		fault = as3645a_read_fault(flash);
> +		if (fault < 0)
> +			return fault;

ctrl->cur.val = 0 here?

> +
> +		if (fault & AS_FAULT_INFO_SHORT_CIRCUIT)
> +			ctrl->cur.val |= V4L2_FLASH_FAULT_SHORT_CIRCUIT;
> +		if (fault & AS_FAULT_INFO_OVER_TEMPERATURE)
> +			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_TEMPERATURE;
> +		if (fault & AS_FAULT_INFO_TIMEOUT)
> +			ctrl->cur.val |= V4L2_FLASH_FAULT_TIMEOUT;
> +		if (fault & AS_FAULT_INFO_OVER_VOLTAGE)
> +			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_VOLTAGE;
> +		if (fault & AS_FAULT_INFO_INDUCTOR_PEAK_LIMIT)
> +			ctrl->cur.val |= V4L2_FLASH_FAULT_OVER_CURRENT;
> +		if (fault & AS_FAULT_INFO_INDICATOR_LED)
> +			ctrl->cur.val |= V4L2_FLASH_FAULT_INDICATOR;
> +		break;
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	dev_dbg(&client->dev, "G_CTRL %08x:%d\n", ctrl->id, ctrl->cur.val);
> +
> +	return 0;
> +}
> +
> +static int as3645a_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct as3645a *flash =
> +		container_of(ctrl->handler, struct as3645a, ctrls);
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int ret;
> +
> +	dev_dbg(&client->dev, "S_CTRL %08x:%d\n", ctrl->id, ctrl->val);
> +
> +	/* If a control that doesn't apply to the current mode is modified,
> +	 * we store the value and return immediately. The setting will be
> +	 * applied when the LED mode is changed. Otherwise we apply the setting
> +	 * immediately.
> +	 */
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_FLASH_LED_MODE:
> +		if (flash->indicator_current)
> +			return -EBUSY;
> +
> +		ret = as3645a_set_config(flash);
> +		if (ret < 0)
> +			return ret;
> +
> +		flash->led_mode = ctrl->val;
> +		return as3645a_set_output(flash, false);
> +
> +	case V4L2_CID_FLASH_STROBE_SOURCE:
> +		flash->strobe_source = ctrl->val;
> +
> +		/* Applies to flash mode only. */
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			break;
> +
> +		return as3645a_set_output(flash, false);
> +
> +	case V4L2_CID_FLASH_STROBE:
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			return -EBUSY;
> +
> +		return as3645a_set_output(flash, true);
> +
> +	case V4L2_CID_FLASH_STROBE_STOP:
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			return -EBUSY;
> +
> +		return as3645a_set_output(flash, false);
> +
> +	case V4L2_CID_FLASH_TIMEOUT:
> +		/* This is ugly. The step value is different depending on strobe
> +		 * mode, so only round the value when using I2C strobing.
> +		 */
> +		if (flash->strobe_source == V4L2_FLASH_STROBE_SOURCE_EXTERNAL &&
> +		    flash->platform_data->set_strobe_width != NULL) {
> +			flash->platform_data->set_strobe_width(ctrl->val);
> +		} else {
> +			if (ctrl->val < AS3645A_FLASH_TIMEOUT_MIN)
> +				ctrl->val = AS3645A_FLASH_TIMEOUT_MIN;
> +			ctrl->val = ctrl->val / AS3645A_FLASH_TIMEOUT_STEP
> +				  * AS3645A_FLASH_TIMEOUT_STEP;
> +		}
> +		flash->timeout = ctrl->val;
> +
> +		/* Applies to flash mode only. */
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			break;
> +
> +		return as3645a_set_config(flash);
> +
> +	case V4L2_CID_FLASH_INTENSITY:
> +		flash->flash_current = (ctrl->val - AS3645A_FLASH_INTENSITY_MIN)
> +				     / AS3645A_FLASH_INTENSITY_STEP;
> +
> +		/* Applies to flash mode only. */
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_FLASH)
> +			break;
> +
> +		return as3645a_set_config(flash);
> +
> +	case V4L2_CID_FLASH_TORCH_INTENSITY:
> +		flash->assist_current =
> +			(ctrl->val - AS3645A_TORCH_INTENSITY_MIN)
> +			/ AS3645A_TORCH_INTENSITY_STEP;
> +
> +		/* Applies to torch mode only. */
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_TORCH)
> +			break;
> +
> +		return as3645a_set_config(flash);
> +
> +	case V4L2_CID_FLASH_INDICATOR_INTENSITY:
> +		if (flash->led_mode != V4L2_FLASH_LED_MODE_NONE)
> +			return -EBUSY;
> +
> +		flash->indicator_current =
> +			(ctrl->val - AS3645A_INDICATOR_INTENSITY_MIN)
> +			/ AS3645A_INDICATOR_INTENSITY_STEP;
> +
> +		ret = as3645a_set_config(flash);
> +		if (ret < 0)
> +			return ret;
> +
> +		if ((ctrl->val == 0) == (ctrl->cur.val == 0))
> +			break;
> +
> +		return as3645a_set_output(flash, false);
> +
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops as3645a_ctrl_ops = {
> +	.g_volatile_ctrl = as3645a_get_ctrl,
> +	.s_ctrl = as3645a_set_ctrl,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 subdev core operations
> + */
> +
> +/* Put device into know state. */
> +static int as3645a_setup(struct as3645a *flash)
> +{
> +	struct i2c_client *client = v4l2_get_subdevdata(&flash->subdev);
> +	int ret;
> +
> +	/* clear errors */
> +	ret = as3645a_read(flash, AS_FAULT_INFO_REG);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(&client->dev, "Fault info: %02x\n", ret);
> +
> +	ret = as3645a_set_config(flash);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = as3645a_set_output(flash, false);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* read status */
> +	ret = as3645a_read_fault(flash);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev_dbg(&client->dev, "AS_INDICATOR_AND_TIMER_REG: %02x\n",
> +		as3645a_read(flash, AS_INDICATOR_AND_TIMER_REG));
> +	dev_dbg(&client->dev, "AS_CURRENT_SET_REG: %02x\n",
> +		as3645a_read(flash, AS_CURRENT_SET_REG));
> +	dev_dbg(&client->dev, "AS_CONTROL_REG: %02x\n",
> +		as3645a_read(flash, AS_CONTROL_REG));
> +
> +	return ret & ~AS_FAULT_INFO_LED_AMOUNT ? -EIO : 0;
> +}
> +
> +static int __as3645a_set_power(struct as3645a *flash, int on)
> +{
> +	int ret;
> +
> +	if (!on)
> +		as3645a_set_control(flash, AS_MODE_EXT_TORCH, false);
> +
> +	if (flash->platform_data && flash->platform_data->set_power) {
> +		ret = flash->platform_data->set_power(&flash->subdev, on);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return on ? as3645a_setup(flash) : 0;
> +}
> +
> +static int as3645a_set_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct as3645a *flash = to_as3645a(sd);
> +	int ret = 0;
> +
> +	mutex_lock(&flash->power_lock);
> +
> +	if (flash->power_count == !on) {
> +		ret = __as3645a_set_power(flash, !!on);
> +		if (ret < 0)
> +			goto done;
> +	}
> +
> +	flash->power_count += on ? 1 : -1;
> +	WARN_ON(flash->power_count < 0);
> +
> +done:
> +	mutex_unlock(&flash->power_lock);
> +	return ret;
> +}
> +
> +static int as3645a_registered(struct v4l2_subdev *sd)
> +{
> +	struct as3645a *flash = to_as3645a(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int rval, man, model, rfu, version;
> +	const char *factory;
> +
> +	/* Power up the flash driver and read manufacturer ID, model ID, RFU
> +	 * and version.
> +	 */
> +	as3645a_set_power(&flash->subdev, 1);
> +
> +	rval = as3645a_read(flash, AS_DESIGN_INFO_REG);
> +	if (rval < 0)
> +		goto power_off;
> +
> +	man = AS_DESIGN_INFO_FACTORY(rval);
> +	model = AS_DESIGN_INFO_MODEL(rval);
> +
> +	rval = as3645a_read(flash, AS_VERSION_CONTROL_REG);
> +	if (rval < 0)
> +		goto power_off;
> +
> +	rfu = AS_VERSION_CONTROL_RFU(rval);
> +	version = AS_VERSION_CONTROL_VERSION(rval);
> +
> +	/* Verify the chip model and version. */
> +	if (model != 0x0001 || rfu != 0x0000) {
> +		dev_err(&client->dev, "AS3645A not detected "
> +			"(model %d rfu %d)\n", model, rfu);
> +		rval = -ENODEV;

Is this so grave issue we should discontinue? I'd perhaps print a
warning if even that.

> +		goto power_off;
> +	}
> +
> +	switch (man) {
> +	case 1:
> +		factory = "AMS, Austria Micro Systems";
> +		break;
> +	case 2:
> +		factory = "ADI, Analog Devices Inc.";
> +		break;
> +	case 3:
> +		factory = "NSC, National Semiconductor";
> +		break;
> +	case 4:
> +		factory = "NXP";
> +		break;
> +	case 5:
> +		factory = "TI, Texas Instrument";
> +		break;
> +	default:
> +		factory = "Unknown";
> +	}
> +
> +	dev_dbg(&client->dev, "Factory: %s(%d) Version: %d\n", factory, man,
> +		version);

Is that really a factor or is it the chip vendor --- which might
contract another factory to actually manufacture the chips?

> +	rval = as3645a_write(flash, AS_PASSWORD_REG, AS_PASSWORD_UNLOCK_VALUE);
> +	if (rval < 0)
> +		goto power_off;
> +
> +	rval = as3645a_write(flash, AS_BOOST_REG, AS_BOOST_CURRENT_DISABLE);
> +	if (rval < 0)
> +		goto power_off;
> +
> +	/* Setup default values. This makes sure that the chip is in a known
> +	 * state, in case the power rail can't be controlled.
> +	 */
> +	rval = as3645a_setup(flash);
> +
> +power_off:
> +	as3645a_set_power(&flash->subdev, 0);
> +
> +	return rval;
> +}
> +
> +static int as3645a_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return as3645a_set_power(sd, 1);
> +}
> +
> +static int as3645a_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	return as3645a_set_power(sd, 0);
> +}
> +
> +static const struct v4l2_subdev_core_ops as3645a_core_ops = {
> +	.s_power		= as3645a_set_power,
> +};
> +
> +static const struct v4l2_subdev_ops as3645a_ops = {
> +	.core = &as3645a_core_ops,
> +};
> +
> +static const struct v4l2_subdev_internal_ops as3645a_internal_ops = {
> +	.registered = as3645a_registered,
> +	.open = as3645a_open,
> +	.close = as3645a_close,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + *  I2C driver
> + */
> +#ifdef CONFIG_PM
> +
> +static int as3645a_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct as3645a *flash = to_as3645a(subdev);
> +	int rval;
> +
> +	if (flash->power_count == 0)
> +		return 0;
> +
> +	rval = __as3645a_set_power(flash, 0);
> +
> +	dev_dbg(&client->dev, "Suspend %s\n", rval < 0 ? "failed" : "ok");
> +
> +	return rval;
> +}
> +
> +static int as3645a_resume(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct as3645a *flash = to_as3645a(subdev);
> +	int rval;
> +
> +	if (flash->power_count == 0)
> +		return 0;
> +
> +	rval = __as3645a_set_power(flash, 1);
> +
> +	dev_dbg(&client->dev, "Resume %s\n", rval < 0 ? "fail" : "ok");
> +
> +	return rval;
> +}
> +
> +#else
> +
> +#define as3645a_suspend	NULL
> +#define as3645a_resume	NULL
> +
> +#endif /* CONFIG_PM */
> +
> +/*
> + * as3645a_init_controls - Create controls
> + * @flash: The flash
> + *
> + * The number of LEDs reported in platform data is used to compute default
> + * limits. Parameters passed through platform data can override those limits.
> + */
> +static int as3645a_init_controls(struct as3645a *flash)
> +{
> +	struct as3645a_flash_torch_parms *flash_params = NULL;
> +	bool use_ext_strobe = false;
> +	unsigned int leds = 2;
> +	struct v4l2_ctrl *ctrl;
> +	int minimum;
> +	int maximum;
> +
> +	if (flash->platform_data) {
> +		if (flash->platform_data->num_leds)
> +			leds = flash->platform_data->num_leds;
> +
> +		flash_params = flash->platform_data->flash_torch_limits;
> +		use_ext_strobe = flash->platform_data->use_ext_flash_strobe;
> +	}
> +
> +	v4l2_ctrl_handler_init(&flash->ctrls, 9);
> +
> +	/* V4L2_CID_FLASH_LED_MODE */
> +	v4l2_ctrl_new_std_menu(&flash->ctrls, &as3645a_ctrl_ops,
> +			       V4L2_CID_FLASH_LED_MODE, 2, ~7,
> +			       V4L2_FLASH_LED_MODE_NONE);
> +
> +	/* V4L2_CID_FLASH_STROBE_SOURCE */
> +	v4l2_ctrl_new_std_menu(&flash->ctrls, &as3645a_ctrl_ops,
> +			       V4L2_CID_FLASH_STROBE_SOURCE,
> +			       use_ext_strobe ? 1 : 0, use_ext_strobe ? ~3 : ~1,
> +			       V4L2_FLASH_STROBE_SOURCE_SOFTWARE);
> +
> +	flash->strobe_source = V4L2_FLASH_STROBE_SOURCE_SOFTWARE;
> +
> +	/* V4L2_CID_FLASH_STROBE */
> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +			  V4L2_CID_FLASH_STROBE, 0, 0, 0, 0);
> +
> +	/* V4L2_CID_FLASH_STROBE_STOP */
> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +			  V4L2_CID_FLASH_STROBE_STOP, 0, 0, 0, 0);
> +
> +	/* V4L2_CID_FLASH_TIMEOUT */
> +	if (flash_params) {

Shouldn't we require valid values for the flash parameters always?
Chances are very high the default ones for the flash controller won't
apply for the LED connected to it.

> +		minimum = flash_params->timeout_min;
> +		maximum = flash_params->timeout_max;
> +	} else {
> +		minimum = 1;
> +		maximum = AS3645A_FLASH_TIMEOUT_MAX;
> +	}
> +
> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +			  V4L2_CID_FLASH_TIMEOUT, minimum, maximum,
> +			  1, maximum);
> +
> +	flash->timeout = maximum;
> +
> +	/* V4L2_CID_FLASH_INTENSITY */
> +	if (flash_params) {
> +		minimum = flash_params->flash_min_current;
> +		maximum = flash_params->flash_max_current;
> +	} else {
> +		minimum = AS3645A_FLASH_INTENSITY_MIN;
> +		maximum = leds == 1 ? AS3645A_FLASH_INTENSITY_MAX_1LED
> +				    : AS3645A_FLASH_INTENSITY_MAX_2LEDS;
> +	}
> +
> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +			  V4L2_CID_FLASH_INTENSITY, minimum, maximum,
> +			  AS3645A_FLASH_INTENSITY_STEP, maximum);
> +
> +	flash->flash_current = (maximum - AS3645A_FLASH_INTENSITY_MIN)
> +			     / AS3645A_FLASH_INTENSITY_STEP;
> +
> +	/* V4L2_CID_FLASH_TORCH_INTENSITY */
> +	if (flash_params) {
> +		minimum = flash_params->torch_min_current;
> +		maximum = flash_params->torch_max_current;
> +	} else {
> +		minimum = AS3645A_TORCH_INTENSITY_MIN;
> +		maximum = AS3645A_TORCH_INTENSITY_MAX;
> +	}
> +
> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +			  V4L2_CID_FLASH_TORCH_INTENSITY, minimum, maximum,
> +			  AS3645A_TORCH_INTENSITY_STEP, minimum);
> +
> +	flash->assist_current = (minimum - AS3645A_TORCH_INTENSITY_MIN)
> +			      / AS3645A_TORCH_INTENSITY_STEP;
> +
> +	/* V4L2_CID_FLASH_INDICATOR_INTENSITY */
> +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +			  V4L2_CID_FLASH_INDICATOR_INTENSITY,
> +			  AS3645A_INDICATOR_INTENSITY_MIN,
> +			  AS3645A_INDICATOR_INTENSITY_MAX,
> +			  AS3645A_INDICATOR_INTENSITY_STEP,
> +			  AS3645A_INDICATOR_INTENSITY_MIN);
> +
> +	flash->indicator_current = 0;
> +
> +	/* V4L2_CID_FLASH_FAULT */
> +	ctrl = v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> +				 V4L2_CID_FLASH_FAULT, 0,
> +				 V4L2_FLASH_FAULT_OVER_VOLTAGE |
> +				 V4L2_FLASH_FAULT_TIMEOUT |
> +				 V4L2_FLASH_FAULT_OVER_TEMPERATURE |
> +				 V4L2_FLASH_FAULT_SHORT_CIRCUIT, 0, 0);
> +	if (ctrl != NULL)
> +		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
> +
> +	flash->subdev.ctrl_handler = &flash->ctrls;
> +
> +	return flash->ctrls.error;
> +}
> +
> +static int as3645a_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *devid)
> +{
> +	struct as3645a *flash;
> +	int ret;
> +
> +	flash = kzalloc(sizeof(*flash), GFP_KERNEL);
> +	if (flash == NULL)
> +		return -ENOMEM;
> +
> +	flash->platform_data = client->dev.platform_data;
> +
> +	v4l2_i2c_subdev_init(&flash->subdev, client, &as3645a_ops);
> +	flash->subdev.internal_ops = &as3645a_internal_ops;
> +	flash->subdev.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	ret = media_entity_init(&flash->subdev.entity, 0, NULL, 0);
> +	if (ret < 0) {
> +		kfree(flash);
> +		return ret;
> +	}

+
+ 	flash->subdev.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_FLASH;

> +
> +	mutex_init(&flash->power_lock);
> +
> +	/* FIXME: These are hard coded for now */
> +	flash->vref = 0;	/* 0V */
> +	flash->peak = 2;	/* 1.75A */

How about putting these to the platform data?

> +	flash->led_mode = V4L2_FLASH_LED_MODE_NONE;
> +
> +	ret = as3645a_init_controls(flash);
> +	if (ret < 0) {
> +		kfree(flash);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __exit as3645a_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
> +	struct as3645a *flash = to_as3645a(subdev);
> +
> +	v4l2_device_unregister_subdev(subdev);
> +	v4l2_ctrl_handler_free(&flash->ctrls);
> +
> +	kfree(flash);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id as3645a_id_table[] = {
> +	{ AS3645A_NAME, 0 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(i2c, as3645a_id_table);
> +
> +static struct i2c_driver as3645a_i2c_driver = {
> +	.driver	= {
> +		.name = AS3645A_NAME,
> +	},
> +	.probe	= as3645a_probe,
> +	.remove	= __exit_p(as3645a_remove),
> +	.suspend = as3645a_suspend,
> +	.resume = as3645a_resume,
> +	.id_table = as3645a_id_table,
> +};
> +
> +static int __init as3645a_init(void)
> +{
> +	int rval;
> +
> +	rval = i2c_add_driver(&as3645a_i2c_driver);
> +	if (rval)
> +		printk(KERN_ERR "Failed registering driver" AS3645A_NAME"\n");
> +
> +	return rval;
> +}
> +
> +static void __exit as3645a_exit(void)
> +{
> +	i2c_del_driver(&as3645a_i2c_driver);
> +}
> +
> +module_init(as3645a_init);
> +module_exit(as3645a_exit);
> +
> +MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
> +MODULE_DESCRIPTION("AS3645A Flash driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/as3645a.h b/include/media/as3645a.h
> new file mode 100644
> index 0000000..1556a97
> --- /dev/null
> +++ b/include/media/as3645a.h
> @@ -0,0 +1,69 @@
> +/*
> + * include/media/as3645a.h
> + *
> + * Copyright (C) 2008-2011 Nokia Corporation
> + *
> + * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
> + * 02110-1301 USA
> + *
> + */
> +
> +#ifndef __AS3645A_H__
> +#define __AS3645A_H__
> +
> +#include <media/v4l2-subdev.h>
> +
> +#define AS3645A_NAME				"as3645a"
> +#define AS3645A_I2C_ADDR			(0x60 >> 1) /* W:0x60, R:0x61 */
> +
> +/*
> + * as3645a_flash_torch_parms - Flash and torch currents and timeout limits
> + * @flash_min_current:	Min flash current (mA)
> + * @flash_max_current:	Max flash current (mA)
> + * @torch_min_current:	Min torch current (mA)
> + * @torch_max_current:	Max torch current (mA)
> + * @timeout_min:	Min flash timeout (us)
> + * @timeout_max:	Max flash timeout (us)
> + */
> +struct as3645a_flash_torch_parms {
> +	unsigned int flash_min_current;
> +	unsigned int flash_max_current;
> +	unsigned int torch_min_current;
> +	unsigned int torch_max_current;
> +	unsigned int timeout_min;
> +	unsigned int timeout_max;
> +};
> +
> +struct as3645a_platform_data {
> +	int (*set_power)(struct v4l2_subdev *subdev, int on);
> +	/* used to notify the entity which trigger external strobe signal */
> +	void (*setup_ext_strobe)(int enable);
> +	/* Sends the strobe width to the sensor strobe configuration */
> +	void (*set_strobe_width)(u32 width_in_us);

I don't think we should have the above two callbacks at all. This should
be controlled from the user space instead.

> +	/* positive value if Torch pin is used */
> +	int ext_torch;

ext_torch is unused.

> +	/* positive value if Flash Strobe pin is used for triggering
> +	 * the Flash light (no matter where is connected to, host processor or
> +	 * image sensor)
> +	 */
> +	int use_ext_flash_strobe;
> +	/* Number of attached LEDs, 1 or 2 */
> +	int num_leds;
> +	/* LED limitations with this flash chip */
> +	struct as3645a_flash_torch_parms *flash_torch_limits;

This struct could be part of the as3654a_platform_data struct directly.

> +};
> +
> +#endif /* __AS3645A_H__ */

Kind regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
