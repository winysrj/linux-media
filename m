Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:60931 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751835AbeDLI5H (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 04:57:07 -0400
Date: Thu, 12 Apr 2018 10:57:01 +0200
From: jacopo mondi <jacopo@jmondi.org>
To: Andy Yeh <andy.yeh@intel.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@linux.intel.com,
        devicetree@vger.kernel.org, tfiga@chromium.org,
        Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [RESEND PATCH v7 2/2] media: dw9807: Add dw9807 vcm driver
Message-ID: <20180412085701.GJ20945@w540>
References: <1523375324-27856-1-git-send-email-andy.yeh@intel.com>
 <1523375324-27856-3-git-send-email-andy.yeh@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T3X/gqwmxfK0WLE8"
Content-Disposition: inline
In-Reply-To: <1523375324-27856-3-git-send-email-andy.yeh@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--T3X/gqwmxfK0WLE8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

HI Andy,
   thanks for addressing my comments on v6.
Some more questions below.

On Tue, Apr 10, 2018 at 11:48:44PM +0800, Andy Yeh wrote:
> From: Alan Chiang <alanx.chiang@intel.com>
>
> DW9807 is a 10 bit DAC from Dongwoon, designed for linear
> control of voice coil motor.
>
> This driver creates a V4L2 subdevice and
> provides control to set the desired focus.
>
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> ---
> since v1:
> - changed author.
> since v2:
> - addressed outstanding comments.
> - enabled sequential write to update 2 registers in a single transaction.
> since v3:
> - addressed comments for v3.
> - Remove redundant codes and declare some variables as constant variable.
> - separate DT binding to another patch
> since v4:
> - sent patchset included DT binding with cover page
> since v6:
> - change the return code of i2c_check
> - fix long cols exceed 80 chars
> - remove #define DW9807_NAME since only used once
>
>  MAINTAINERS                |   7 +
>  drivers/media/i2c/Kconfig  |  10 ++
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/dw9807.c | 335 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 353 insertions(+)
>  create mode 100644 drivers/media/i2c/dw9807.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 845fc25..a339bb5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4385,6 +4385,13 @@ T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>  F:	drivers/media/i2c/dw9714.c
>
> +DONGWOON DW9807 LENS VOICE COIL DRIVER
> +M:	Sakari Ailus <sakari.ailus@linux.intel.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	drivers/media/i2c/dw9807.c
> +
>  DOUBLETALK DRIVER
>  M:	"James R. Van Zandt" <jrv@vanzandt.mv.com>
>  L:	blinux-list@redhat.com
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index cb5d7ff..fd01842 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -325,6 +325,16 @@ config VIDEO_DW9714
>  	  capability. This is designed for linear control of
>  	  voice coil motors, controlled via I2C serial interface.
>
> +config VIDEO_DW9807
> +	tristate "DW9807 lens voice coil support"
> +	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	---help---

iirc checkpatch warned me multiple times to prefer 'help' on
'---help---' for newly introduced symbols. Could you check please
(maybe with using the --strict option?)

> +	  This is a driver for the DW9807 camera lens voice coil.
> +	  DW9807 is a 10 bit DAC with 100mA output current sink
> +	  capability. This is designed for linear control of
> +	  voice coil motors, controlled via I2C serial interface.
> +
>  config VIDEO_SAA7110
>  	tristate "Philips SAA7110 video decoder"
>  	depends on VIDEO_V4L2 && I2C
> diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
> index 548a9ef..1b62639 100644
> --- a/drivers/media/i2c/Makefile
> +++ b/drivers/media/i2c/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_VIDEO_SAA7185) += saa7185.o
>  obj-$(CONFIG_VIDEO_SAA6752HS) += saa6752hs.o
>  obj-$(CONFIG_VIDEO_AD5820)  += ad5820.o
>  obj-$(CONFIG_VIDEO_DW9714)  += dw9714.o
> +obj-$(CONFIG_VIDEO_DW9807)  += dw9807.o
>  obj-$(CONFIG_VIDEO_ADV7170) += adv7170.o
>  obj-$(CONFIG_VIDEO_ADV7175) += adv7175.o
>  obj-$(CONFIG_VIDEO_ADV7180) += adv7180.o
> diff --git a/drivers/media/i2c/dw9807.c b/drivers/media/i2c/dw9807.c
> new file mode 100644
> index 0000000..062c30f
> --- /dev/null
> +++ b/drivers/media/i2c/dw9807.c
> @@ -0,0 +1,335 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (C) 2018 Intel Corporation
> +
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define DW9807_MAX_FOCUS_POS	1023
> +/*
> + * This sets the minimum granularity for the focus positions.
> + * A value of 1 gives maximum accuracy for a desired focus position.
> + */
> +#define DW9807_FOCUS_STEPS	1
> +/*
> + * This acts as the minimum granularity of lens movement.
> + * Keep this value power of 2, so the control steps can be
> + * uniformly adjusted for gradual lens movement, with desired
> + * number of control steps.
> + */
> +#define DW9807_CTRL_STEPS	16
> +#define DW9807_CTRL_DELAY_US	1000
> +
> +#define DW9807_CTL_ADDR		0x02
> +/*
> + * DW9807 separates two registers to control the VCM position.
> + * One for MSB value, another is LSB value.
> + */
> +#define DW9807_MSB_ADDR		0x03
> +#define DW9807_LSB_ADDR		0x04
> +#define DW9807_STATUS_ADDR	0x05
> +#define DW9807_MODE_ADDR	0x06
> +#define DW9807_RESONANCE_ADDR	0x07
> +
> +#define MAX_RETRY		10
> +
> +struct dw9807_device {
> +	struct v4l2_ctrl_handler ctrls_vcm;
> +	struct v4l2_subdev sd;
> +	u16 current_val;
> +};
> +
> +static inline struct dw9807_device *sd_to_dw9807_vcm(
> +					struct v4l2_subdev *subdev)
> +{
> +	return container_of(subdev, struct dw9807_device, sd);
> +}
> +
> +static int dw9807_i2c_check(struct i2c_client *client)
> +{
> +	const char status_addr = DW9807_STATUS_ADDR;
> +	char status_result;
> +	int ret;
> +
> +	ret = i2c_master_send(client, (const char *)&status_addr,
> +		sizeof(status_addr));

As reported by checkpatch, please fix alignement to the first open
brace, and as per Tomasz comment remove the cast


> +	if (ret < 0) {
> +		dev_err(&client->dev, "I2C write STATUS address fail ret = %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret = i2c_master_recv(client, (char *)&status_result,
> +		sizeof(status_result));

Align the last argument to the first open brace.

	ret = i2c_master_recv(client, (char *)&status_result,
		              sizeof(status_result));

> +	if (ret != sizeof(status_result)) {

My comment on i2c functions return values applies to i2c_master_recv()
as well. Please just check for (ret < 0) here

> +		dev_err(&client->dev, "I2C read STATUS value fail ret=%d\n",

The previous errror message has spaces in between 'ret','=' and '%d'.
Please be consistent.

> +			ret);
> +		return ret;
> +	}
> +
> +	return status_result;
> +}
> +
> +static int dw9807_set_dac(struct i2c_client *client, u16 data)
> +{
> +	const char tx_data[3] = {
> +		DW9807_MSB_ADDR, ((data >> 8) & 0x03), (data & 0xff)
> +	};
> +	int ret, retry = 0;
> +
> +	/*
> +	 * According to the datasheet, need to check the bus status before we
> +	 * write VCM position. This ensure that we really write the value
> +	 * into the register
> +	 */
> +	while ((ret = dw9807_i2c_check(client)) != 0) {
> +		if (ret < 0)
> +			return ret;
> +
> +		if (MAX_RETRY == ++retry) {
> +			dev_err(&client->dev,
> +				"Cannot do the write operation because VCM is busy\n");

Nit: this is over 80 cols, it's fine, but I think you can really
shorten the error messag without losing context.

> +			return -EIO;
> +		}
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);

mmm, I wonder if a sleep range of 10usecs is really a strict
requirement. Have a look at Documentation/timers/timers-howto.txt.
With such a small range you're likely fire some unrequired interrupt.

If I got this right, here you're just polling a register every
1msec-ish (usleep_range(1000, 1010)). I think you can enlarge the
range safely (maybe lowering the number of retries if you wish to) and
give more space to coalesce your wakeup with others.

What is a good range? Good question. How effective is this to have
your wakeup coalesced with others? I think this greatly depends on the
system you're running on and its load at this specific time. So I
would reply to both questions with "not sure", but I let you consider
if you could enlarge your range to say 1000-1500 usec at least.


> +	}
> +
> +	/* Write VCM position to registers */
> +	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
> +	if (ret != sizeof(tx_data)) {

As per previous comments, check for ret < 0

> +		if (ret < 0) {
> +			dev_err(&client->dev,
> +				"I2C write MSB fail ret=%d\n", ret);
> +			return ret;
> +		} else {

There cannot be any else case here as i2c_master_send returns < 0  or
sizeof(tx_data) only.

> +			dev_err(&client->dev, "I2C write MSB fail, transmission size is not equal the size expected\n");
> +			return -EIO;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int dw9807_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct dw9807_device *dev_vcm = container_of(ctrl->handler,
> +		struct dw9807_device, ctrls_vcm);
> +
> +	if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE) {
> +		struct i2c_client *client = v4l2_get_subdevdata(&dev_vcm->sd);
> +
> +		dev_vcm->current_val = ctrl->val;
> +		return dw9807_set_dac(client, ctrl->val);
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static const struct v4l2_ctrl_ops dw9807_vcm_ctrl_ops = {
> +	.s_ctrl = dw9807_set_ctrl,
> +};
> +
> +static int dw9807_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	int rval;
> +
> +	rval = pm_runtime_get_sync(sd->dev);
> +	if (rval < 0) {
> +		pm_runtime_put_noidle(sd->dev);
> +		return rval;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dw9807_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +	pm_runtime_put(sd->dev);
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_internal_ops dw9807_int_ops = {
> +	.open = dw9807_open,
> +	.close = dw9807_close,
> +};
> +
> +static const struct v4l2_subdev_ops dw9807_ops = { };
> +
> +static void dw9807_subdev_cleanup(struct dw9807_device *dw9807_dev)
> +{
> +	v4l2_async_unregister_subdev(&dw9807_dev->sd);
> +	v4l2_ctrl_handler_free(&dw9807_dev->ctrls_vcm);
> +	media_entity_cleanup(&dw9807_dev->sd.entity);
> +}
> +
> +static int dw9807_init_controls(struct dw9807_device *dev_vcm)
> +{
> +	struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
> +	const struct v4l2_ctrl_ops *ops = &dw9807_vcm_ctrl_ops;
> +	struct i2c_client *client = v4l2_get_subdevdata(&dev_vcm->sd);
> +
> +	v4l2_ctrl_handler_init(hdl, 1);
> +
> +	v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
> +			  0, DW9807_MAX_FOCUS_POS, DW9807_FOCUS_STEPS, 0);
> +
> +	dev_vcm->sd.ctrl_handler = hdl;
> +	if (hdl->error) {
> +		dev_err(&client->dev, "%s fail error: 0x%x\n",
> +			__func__, hdl->error);
> +		return hdl->error;
> +	}
> +
> +	return 0;
> +}
> +
> +static int dw9807_probe(struct i2c_client *client)
> +{
> +	struct dw9807_device *dw9807_dev;
> +	int rval;
> +
> +	dw9807_dev = devm_kzalloc(&client->dev, sizeof(*dw9807_dev),
> +				  GFP_KERNEL);
> +	if (!dw9807_dev)
> +		return -ENOMEM;
> +
> +	v4l2_i2c_subdev_init(&dw9807_dev->sd, client, &dw9807_ops);
> +	dw9807_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +	dw9807_dev->sd.internal_ops = &dw9807_int_ops;
> +
> +	rval = dw9807_init_controls(dw9807_dev);
> +	if (rval)
> +		goto err_cleanup;
> +
> +	rval = media_entity_pads_init(&dw9807_dev->sd.entity, 0, NULL);
> +	if (rval < 0)
> +		goto err_cleanup;
> +
> +	dw9807_dev->sd.entity.function = MEDIA_ENT_F_LENS;

Not super sure here, Sakari may confirm or not, but you don't have
pads, you don't have pad operations, why are initializing entity pads
and depend on MEDIA_CONTROLLER in Kconfig? I -think- you can remove
these lines above here.

> +
> +	rval = v4l2_async_register_subdev(&dw9807_dev->sd);
> +	if (rval < 0)
> +		goto err_cleanup;
> +
> +	pm_runtime_set_active(&client->dev);
> +	pm_runtime_enable(&client->dev);
> +	pm_runtime_idle(&client->dev);
> +
> +	return 0;
> +
> +err_cleanup:
> +	dw9807_subdev_cleanup(dw9807_dev);
> +
> +	return rval;
> +}
> +
> +static int dw9807_remove(struct i2c_client *client)
> +{
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +
> +	pm_runtime_disable(&client->dev);
> +	pm_runtime_set_suspended(&client->dev);
> +
> +	dw9807_subdev_cleanup(dw9807_dev);
> +
> +	return 0;
> +}
> +
> +/*
> + * This function sets the vcm position, so it consumes least current
> + * The lens position is gradually moved in units of DW9807_CTRL_STEPS,
> + * to make the movements smoothly.
> + */
> +static int __maybe_unused dw9807_vcm_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +	const char tx_data[2] = { DW9807_CTL_ADDR, 0x01 };
> +	int ret, val;
> +
> +	for (val = dw9807_dev->current_val & ~(DW9807_CTRL_STEPS - 1);
> +	     val >= 0; val -= DW9807_CTRL_STEPS) {
> +		ret = dw9807_set_dac(client, val);
> +		if (ret)
> +			dev_err_once(dev, "%s I2C failure: %d", __func__, ret);
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);

ditto

> +	}
> +
> +	/* Power down */
> +	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
> +

ditch this empty line please

> +	if (ret != sizeof(tx_data)) {

ditto, check for ret < 0

> +		dev_err(&client->dev, "I2C write CTL fail\n");
> +		return -EIO;

consider returning ret to propagate i2c error

> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * This function sets the vcm position to the value set by the user
> + * through v4l2_ctrl_ops s_ctrl handler
> + * The lens position is gradually moved in units of DW9807_CTRL_STEPS,
> + * to make the movements smoothly.
> + */
> +static int  __maybe_unused dw9807_vcm_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +	struct dw9807_device *dw9807_dev = sd_to_dw9807_vcm(sd);
> +	const char tx_data[2] = { DW9807_CTL_ADDR, 0x00 };
> +	int ret, val;
> +
> +	/* Power on */
> +	ret = i2c_master_send(client, tx_data, sizeof(tx_data));
> +	if (ret != sizeof(tx_data)) {

ditto, check for ret < 0

> +		dev_err(&client->dev, "I2C write CTL fail\n");
> +		return -EIO;

consider returning ret to propagate i2c error


> +	}
> +
> +	for (val = dw9807_dev->current_val % DW9807_CTRL_STEPS;
> +	     val < dw9807_dev->current_val + DW9807_CTRL_STEPS - 1;
> +	     val += DW9807_CTRL_STEPS) {
> +		ret = dw9807_set_dac(client, val);
> +		if (ret)
> +			dev_err_ratelimited(dev, "%s I2C failure: %d",
> +						__func__, ret);
> +		usleep_range(DW9807_CTRL_DELAY_US, DW9807_CTRL_DELAY_US + 10);

ditto

> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id dw9807_of_table[] = {
> +	{ .compatible = "dongwoon,dw9807" },
> +	{ { 0 } }
> +};
> +MODULE_DEVICE_TABLE(of, dw9807_of_table);
> +
> +static const struct dev_pm_ops dw9807_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(dw9807_vcm_suspend, dw9807_vcm_resume)
> +	SET_RUNTIME_PM_OPS(dw9807_vcm_suspend, dw9807_vcm_resume, NULL)
> +};
> +
> +static struct i2c_driver dw9807_i2c_driver = {
> +	.driver = {
> +		.name = "dw9807",
> +		.pm = &dw9807_pm_ops,
> +		.of_match_table = dw9807_of_table,
> +	},
> +	.probe_new = dw9807_probe,
> +	.remove = dw9807_remove,
> +};
> +
> +module_i2c_driver(dw9807_i2c_driver);
> +
> +MODULE_AUTHOR("Chiang, Alan <alanx.chiang@intel.com>");
> +MODULE_DESCRIPTION("DW9807 VCM driver");
> +MODULE_LICENSE("GPL v2");
> --
> 2.7.4
>

--T3X/gqwmxfK0WLE8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJazx9cAAoJEHI0Bo8WoVY89fkP+gNH1QHXWTb+zgpKL0KvVNdg
6V2W1H0sS37VrEb6g0LD86onf4qtx8mpfQ/xlV83gv0llWZGO37VJ319PEdqyoA9
65uR7ykBzPkhq+mlO8v0pFZqS/qVoJZMMODD5tRMHpVkmOSxb3Zn9u9pPPGhxoGV
7GDbTQRhrPIEB729ndnyCG1aGP9nSy+2quaynqMuH59fGDWiHehwAnh6JdH0akjs
+5X/6LqXI2YNMVolqlBtHPmanvqWmCpGjrz+cE9YX+HbMqaL8M6YmjX0ZX2DEXZv
W6gOnrnya+9YyRvXSiAh40iGTU0zYs8mXB+v1p2zZSQNXE26gget11Uf+/E5t6bp
TS+WbCaOhKfNGUMX31214NH0kwtr3pd9M3A2i8bN4KbHej/IcbnGvVh2LjVvg1vH
ZpM90lCaqfXe91RZ1Ei+Keidnt9rOL+bRb68iEtVjRq8foxd8a9+j0BoYg114CC+
OAFXwcbrZgn67RzrxgFdSeVc84qkWX90zehHG3OclT1x8pU77DzI9/EvkJUORNcn
zhYSd5RLEPwjor33+08bJYDpgurh/utXR3+HSsMhtibFDQCZAAOfRyfuN3EySqAB
wLHRVvrFkcWqakJEDnD0OLLrZmHjKlkvsPE4MTT4Z9JR78LJFmKjr8+GjE8ilRgQ
AOzNeiZC88OmHdJtuAyx
=t/L9
-----END PGP SIGNATURE-----

--T3X/gqwmxfK0WLE8--
