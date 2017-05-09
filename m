Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:33538 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750787AbdEIIoh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 04:44:37 -0400
Received: by mail-yw0-f170.google.com with SMTP id 203so41160070ywe.0
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 01:44:36 -0700 (PDT)
Received: from mail-yw0-f182.google.com (mail-yw0-f182.google.com. [209.85.161.182])
        by smtp.gmail.com with ESMTPSA id t9sm4180932ywc.19.2017.05.09.01.44.34
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2017 01:44:35 -0700 (PDT)
Received: by mail-yw0-f182.google.com with SMTP id b68so41281896ywe.3
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 01:44:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1494254208-30045-1-git-send-email-rajmohan.mani@intel.com>
References: <1494254208-30045-1-git-send-email-rajmohan.mani@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 May 2017 16:44:13 +0800
Message-ID: <CAAFQd5A34z8=uAAq-k+d-n0E+93dup1DuQZHsoaw+5YNaGqWPw@mail.gmail.com>
Subject: Re: [PATCH v2] dw9714: Initial driver for dw9714 VCM
To: Rajmohan Mani <rajmohan.mani@intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rajmohan,

Some comments below.

On Mon, May 8, 2017 at 10:36 PM, Rajmohan Mani <rajmohan.mani@intel.com> wrote:
> DW9714 is a 10 bit DAC, designed for linear
> control of voice coil motor.
>
> This driver creates a V4L2 subdevice and
> provides control to set the desired focus.
>
> Signed-off-by: Rajmohan Mani <rajmohan.mani@intel.com>
> ---
> Changes in v2:
>         - Addressed review comments from Hans Verkuil
>         - Fixed a debug message typo
>         - Got rid of a return variable
> ---
>  drivers/media/i2c/Kconfig  |   9 ++
>  drivers/media/i2c/Makefile |   1 +
>  drivers/media/i2c/dw9714.c | 320 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 330 insertions(+)
>  create mode 100644 drivers/media/i2c/dw9714.c
[snip]
> diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
> new file mode 100644
> index 0000000..cd6cde7
> --- /dev/null
> +++ b/drivers/media/i2c/dw9714.c
> @@ -0,0 +1,320 @@
> +/*
> + * Copyright (c) 2015--2017 Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/acpi.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/module.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +#define DW9714_NAME            "dw9714"
> +#define DW9714_MAX_FOCUS_POS   1023
> +#define DW9714_CTRL_STEPS      16      /* Keep this value power of 2 */

Because?

> +#define DW9714_CTRL_DELAY_US   1000
> +/*
> + * S[3:2] = 0x00, codes per step for "Linear Slope Control"
> + * S[1:0] = 0x00, step period
> + */
> +#define DW9714_DEFAULT_S 0x0
> +#define DW9714_VAL(data, s) (u16)((data) << 4 | (s))

Do we need this cast?

> +
> +/* dw9714 device structure */
> +struct dw9714_device {
> +       struct i2c_client *client;
> +       struct v4l2_ctrl_handler ctrls_vcm;
> +       struct v4l2_subdev sd;
> +       u16 current_val;
> +};
> +
> +#define to_dw9714_vcm(_ctrl)   \
> +       container_of(_ctrl->handler, struct dw9714_device, ctrls_vcm)

Please use a static inline function for type safety.

> +
> +static int dw9714_i2c_write(struct i2c_client *client, u16 data)
> +{
> +       const int num_msg = 1;
> +       int ret;
> +       u16 val = cpu_to_be16(data);
> +       struct i2c_msg msg = {
> +               .addr = client->addr,
> +               .flags = 0,
> +               .len = sizeof(val),
> +               .buf = (u8 *) &val,
> +       };
> +
> +       ret = i2c_transfer(client->adapter, &msg, num_msg);
> +
> +       /*One retry */
> +       if (ret != num_msg)
> +               ret = i2c_transfer(client->adapter, &msg, num_msg);
> +
> +       if (ret != num_msg) {
> +               dev_err(&client->dev, "I2C write fail\n");
> +               return -EIO;
> +       }

I believe i2c_master_send() would simplify this function significantly.

> +       return 0;
> +}
> +
> +static int dw9714_t_focus_vcm(struct dw9714_device *dw9714_dev, u16 val)
> +{
> +       struct i2c_client *client = dw9714_dev->client;
> +
> +       dev_dbg(&client->dev, "Setting new value VCM: %d\n", val);
> +       dw9714_dev->current_val = val;
> +
> +       return dw9714_i2c_write(client, DW9714_VAL(val, DW9714_DEFAULT_S));
> +}
> +
> +static int dw9714_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       struct dw9714_device *dev_vcm = to_dw9714_vcm(ctrl);
> +
> +       if (ctrl->id == V4L2_CID_FOCUS_ABSOLUTE)
> +               return dw9714_t_focus_vcm(dev_vcm, ctrl->val);
> +
> +       return -EINVAL;
> +}
> +
> +static const struct v4l2_ctrl_ops dw9714_vcm_ctrl_ops = {
> +       .s_ctrl = dw9714_set_ctrl,
> +};
> +
> +static int dw9714_init_controls(struct dw9714_device *dev_vcm)
> +{
> +       struct v4l2_ctrl_handler *hdl = &dev_vcm->ctrls_vcm;
> +       const struct v4l2_ctrl_ops *ops = &dw9714_vcm_ctrl_ops;
> +       struct i2c_client *client = dev_vcm->client;
> +
> +       v4l2_ctrl_handler_init(hdl, 1);
> +
> +       v4l2_ctrl_new_std(hdl, ops, V4L2_CID_FOCUS_ABSOLUTE,
> +                         0, DW9714_MAX_FOCUS_POS, 1, 0);
> +
> +       if (hdl->error)
> +               dev_err(&client->dev, "dw9714_init_controls fail\n");
> +       dev_vcm->sd.ctrl_handler = hdl;
> +       return hdl->error;
> +}
> +
> +static void dw9714_subdev_cleanup(struct dw9714_device *dw9714_dev)
> +{
> +       v4l2_ctrl_handler_free(&dw9714_dev->ctrls_vcm);
> +       v4l2_async_unregister_subdev(&dw9714_dev->sd);
> +       v4l2_device_unregister_subdev(&dw9714_dev->sd);
> +       media_entity_cleanup(&dw9714_dev->sd.entity);
> +}
> +
> +static int dw9714_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +       struct dw9714_device *dw9714_dev = container_of(sd,
> +                                                       struct dw9714_device,
> +                                                       sd);
> +       struct device *dev = &dw9714_dev->client->dev;
> +
> +       return pm_runtime_get_sync(dev);

Need pm_runtime_put() if this fails.

> +}
> +
> +static int dw9714_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
> +{
> +       struct dw9714_device *dw9714_dev = container_of(sd,
> +                                                       struct dw9714_device,
> +                                                       sd);
> +       struct device *dev = &dw9714_dev->client->dev;
> +
> +       pm_runtime_put(dev);
> +
> +       return 0;
> +}
> +
> +static const struct v4l2_subdev_internal_ops dw9714_int_ops = {
> +       .open = dw9714_open,
> +       .close = dw9714_close,
> +};
> +
> +static const struct v4l2_subdev_ops dw9714_ops = { };
> +
> +static int dw9714_probe(struct i2c_client *client,
> +                       const struct i2c_device_id *devid)
> +{
> +       struct dw9714_device *dw9714_dev;
> +       int rval;
> +
> +       dw9714_dev = devm_kzalloc(&client->dev, sizeof(*dw9714_dev),
> +                                 GFP_KERNEL);
> +
> +       if (dw9714_dev == NULL)
> +               return -ENOMEM;
> +
> +       dw9714_dev->client = client;
> +
> +       v4l2_i2c_subdev_init(&dw9714_dev->sd, client, &dw9714_ops);
> +       dw9714_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
> +       dw9714_dev->sd.internal_ops = &dw9714_int_ops;
> +
> +       rval = dw9714_init_controls(dw9714_dev);
> +       if (rval)
> +               goto err_cleanup;
> +
> +       rval = media_entity_pads_init(&dw9714_dev->sd.entity, 0, NULL);
> +       if (rval < 0)
> +               goto err_cleanup;
> +
> +       dw9714_dev->sd.entity.function = MEDIA_ENT_F_LENS;
> +
> +       rval = v4l2_async_register_subdev(&dw9714_dev->sd);
> +       if (rval < 0)
> +               goto err_cleanup;
> +
> +       pm_runtime_enable(&client->dev);
> +
> +       return 0;
> +
> +err_cleanup:
> +       dw9714_subdev_cleanup(dw9714_dev);
> +       dev_err(&client->dev, "Probe failed: %d\n", rval);
> +       return rval;
> +}
> +
> +static int dw9714_remove(struct i2c_client *client)
> +{
> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +       struct dw9714_device *dw9714_dev = container_of(sd,
> +                                                       struct dw9714_device,
> +                                                       sd);
> +
> +       pm_runtime_disable(&client->dev);
> +       dw9714_subdev_cleanup(dw9714_dev);
> +
> +       return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +
> +static int dw9714_runtime_suspend(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +static int dw9714_runtime_resume(struct device *dev)
> +{
> +       return 0;
> +}
> +
> +/* This function sets the vcm position, so it consumes least current */
> +static int dw9714_suspend(struct device *dev)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +       struct dw9714_device *dw9714_dev = container_of(sd,
> +                                                       struct dw9714_device,
> +                                                       sd);
> +       int ret, val;
> +
> +       dev_dbg(dev, "%s\n", __func__);
> +
> +       for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
> +            val >= 0; val -= DW9714_CTRL_STEPS) {
> +               ret = dw9714_i2c_write(client,
> +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
> +               if (ret)
> +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
> +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);

Is it necessary to change the value in such steps? If so, shouldn't
the control handler behave in the same way, making sure that userspace
does not request changes in bigger steps?

> +       }
> +       return 0;
> +}
> +
> +/*
> + * This function sets the vcm position, so the focus position is set
> + * closer to the camera

I think it should only set the VCM position to the value as set before
the suspend.

> + */
> +static int dw9714_resume(struct device *dev)
> +{
> +       struct i2c_client *client = to_i2c_client(dev);
> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> +       struct dw9714_device *dw9714_dev = container_of(sd,
> +                                                       struct dw9714_device,
> +                                                       sd);
> +       int ret, val;
> +
> +       dev_dbg(dev, "%s\n", __func__);
> +
> +       for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
> +            val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
> +            val += DW9714_CTRL_STEPS) {
> +               ret = dw9714_i2c_write(client,
> +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
> +               if (ret)
> +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
> +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
> +       }
> +
> +       /* restore v4l2 control values */
> +       ret = v4l2_ctrl_handler_setup(&dw9714_dev->ctrls_vcm);
> +       dev_dbg(dev, "%s ret = %d\n", __func__, ret);
> +       return ret;
> +}
> +
> +#else
> +
> +#define dw9714_suspend NULL
> +#define dw9714_resume  NULL
> +#define dw9714_runtime_suspend NULL
> +#define dw9714_runtime_resume  NULL

This #define trickery shouldn't be necessary. Please see below.
(#ifndef/#endif around the functions themselves is still necessary.)

> +
> +#endif /* CONFIG_PM */
> +
> +#ifdef CONFIG_ACPI
> +static const struct acpi_device_id dw9714_acpi_match[] = {
> +       {"DW9714", 0},
> +       {},
> +};
> +MODULE_DEVICE_TABLE(acpi, dw9714_acpi_match);
> +#endif
> +
> +static const struct i2c_device_id dw9714_id_table[] = {
> +       {DW9714_NAME, 0},
> +       {}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, dw9714_id_table);
> +
> +static const struct dev_pm_ops dw9714_pm_ops = {
> +       .suspend = dw9714_suspend,
> +       .resume = dw9714_resume,
> +       .runtime_suspend = dw9714_runtime_suspend,
> +       .runtime_resume = dw9714_runtime_resume,

You can (and probably should) use SET_SYSTEM_SLEEP_PM_OPS() for global
suspend/resume handlers and SET_RUNTIME_PM_OPS() for runtime ones.
This also takes care of functions being undefined if !CONFIG_PM.

> +};
> +
> +static struct i2c_driver dw9714_i2c_driver = {
> +       .driver = {
> +               .name = DW9714_NAME,
> +               .pm = &dw9714_pm_ops,
> +#ifdef CONFIG_ACPI
> +               .acpi_match_table = ACPI_PTR(dw9714_acpi_match),
> +#endif

No need for #ifdef CONFIG_ACPI, as .acpi_match_table is always present
in the struct and ACPI_PTR() takes care of dw9714_acpi_match being
undefined if !CONFIG_ACPI.

Best regards,
Tomasz
