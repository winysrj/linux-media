Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f169.google.com ([209.85.213.169]:32944 "EHLO
        mail-yb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936424AbdEYPBG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 May 2017 11:01:06 -0400
Received: by mail-yb0-f169.google.com with SMTP id 187so46763232ybg.0
        for <linux-media@vger.kernel.org>; Thu, 25 May 2017 08:01:06 -0700 (PDT)
Received: from mail-yw0-f176.google.com (mail-yw0-f176.google.com. [209.85.161.176])
        by smtp.gmail.com with ESMTPSA id m21sm3454116ywh.2.2017.05.25.08.01.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 May 2017 08:01:03 -0700 (PDT)
Received: by mail-yw0-f176.google.com with SMTP id l14so104568306ywk.1
        for <linux-media@vger.kernel.org>; Thu, 25 May 2017 08:01:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com> <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 26 May 2017 00:00:41 +0900
Message-ID: <CAAFQd5A4d2oPRUYScYmOtG3RMvE9aZ0c+1uw_8F7-b-bBG-sSQ@mail.gmail.com>
Subject: Re: [PATCH v4] dw9714: Initial driver for dw9714 VCM
To: Rajmohan Mani <rajmohan.mani@intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Raj,

On Thu, May 11, 2017 at 3:30 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> Hi Raj,
>
> Thanks for re-spin. Still a bit more comments inline. (I missed few
> more before, sorry.)
>
> On Thu, May 11, 2017 at 1:00 PM, Rajmohan Mani <rajmohan.mani@intel.com> wrote:
>> DW9714 is a 10 bit DAC, designed for linear
>> control of voice coil motor.
> [snip]
>> +static int dw9714_i2c_write(struct i2c_client *client, u16 data)
>> +{
>> +       int ret;
>> +       u16 val = cpu_to_be16(data);
>> +       const int num_bytes = sizeof(val);
>> +
>> +       ret = i2c_master_send(client, (const char *) &val, sizeof(val));
>
> nit: No need for space between cast and casted value.
>
>> +
>> +       /*One retry */
>> +       if (ret != num_bytes)
>> +               ret = i2c_master_send(client, (const char *) &val, sizeof(val));
>
> Why do we need this retry?
>
>> +
>> +       if (ret != num_bytes) {
>> +               dev_err(&client->dev, "I2C write fail\n");
>> +               return -EIO;
>> +       }
>> +       return 0;
>> +}
>> +
>> +static int dw9714_t_focus_vcm(struct dw9714_device *dw9714_dev, u16 val)
>> +{
>> +       struct i2c_client *client = dw9714_dev->client;
>> +
>> +       dw9714_dev->current_val = val;
>> +
>> +       return dw9714_i2c_write(client, DW9714_VAL(val, DW9714_DEFAULT_S));
>
> This still doesn't seem to apply the control gradually as suspend and resume do.
>
>> +}
> [snip]
>> +static int dw9714_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +       struct dw9714_device *dw9714_dev = container_of(sd,
>> +                                                       struct dw9714_device,
>> +                                                       sd);
>> +       struct device *dev = &dw9714_dev->client->dev;
>> +       int rval;
>> +
>> +       rval = pm_runtime_get_sync(dev);
>> +       if (rval >= 0)
>> +               return 0;
>> +
>> +       pm_runtime_put(dev);
>> +       return rval;
>
> nit: The typical coding style is to return early in case of a special
> case and keep the common path linear, i.e.
>
>     rval = pm_runtime_get_sync(dev);
>     if (rval < 0) {
>         pm_runtime_put(dev);
>         return rval;
>     }
>
>     return 0;
>
>> +}
>> +
> [snip]
>> +static int dw9714_remove(struct i2c_client *client)
>> +{
>> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +       struct dw9714_device *dw9714_dev = container_of(sd,
>> +                                                       struct dw9714_device,
>> +                                                       sd);
>> +
>> +       pm_runtime_disable(&client->dev);
>> +       dw9714_subdev_cleanup(dw9714_dev);
>> +
>> +       return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>
> #if defined(CONFIG_PM) || defined(CONFIG_PM_SLEEP)
>
>> +
>> +/*
>> + * This function sets the vcm position, so it consumes least current
>> + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
>> + * to make the movements smoothly.
>> + */
>> +static int dw9714_vcm_suspend(struct device *dev)
>> +{
>> +       struct i2c_client *client = to_i2c_client(dev);
>> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +       struct dw9714_device *dw9714_dev = container_of(sd,
>> +                                                       struct dw9714_device,
>> +                                                       sd);
>> +       int ret, val;
>> +
>> +       for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
>> +            val >= 0; val -= DW9714_CTRL_STEPS) {
>> +               ret = dw9714_i2c_write(client,
>> +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
>
> DW9714_VAL() already contains such cast. Anyway, I still think they
> don't really give us anything and should be removed.
>
>> +               if (ret)
>> +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
>
> I think we should just return an error code here and fail the suspend.
>
>> +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
>> +       }
>> +       return 0;
>> +}
>> +
>> +/*
>> + * This function sets the vcm position to the value set by the user
>> + * through v4l2_ctrl_ops s_ctrl handler
>> + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
>> + * to make the movements smoothly.
>> + */
>> +static int dw9714_vcm_resume(struct device *dev)
>> +{
>> +       struct i2c_client *client = to_i2c_client(dev);
>> +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +       struct dw9714_device *dw9714_dev = container_of(sd,
>> +                                                       struct dw9714_device,
>> +                                                       sd);
>> +       int ret, val;
>> +
>> +       for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
>> +            val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
>> +            val += DW9714_CTRL_STEPS) {
>> +               ret = dw9714_i2c_write(client,
>> +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
>
> Ditto.
>
>> +               if (ret)
>> +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
>
> Ditto.
>
>> +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
>> +       }
>> +
>> +       /* restore v4l2 control values */
>> +       ret = v4l2_ctrl_handler_setup(&dw9714_dev->ctrls_vcm);
>> +       return ret;
>
> Hmm, actually I believe v4l2_ctrl_handler_setup() will call .s_ctrl()
> here and set the motor value again. If we just make .s_ctrl() do the
> adjustment in steps properly, we can simplify the resume to simply
> call v4l2_ctrl_handler_setup() alone.
>
>> +}
>
> #endif
>
> #ifdef CONFIG_PM
>
>> +
>> +static int dw9714_runtime_suspend(struct device *dev)
>> +{
>> +       return dw9714_vcm_suspend(dev);
>> +}
>> +
>> +static int dw9714_runtime_resume(struct device *dev)
>> +{
>> +       return dw9714_vcm_resume(dev);
>> +}
>
> #endif
>
> #ifdef CONFIG_PM_SLEEP
>
>> +
>> +static int dw9714_suspend(struct device *dev)
>> +{
>> +       return dw9714_vcm_suspend(dev);
>> +}
>> +
>> +static int dw9714_resume(struct device *dev)
>> +{
>> +       return dw9714_vcm_resume(dev);
>> +}
>
> #endif
>
> Or you could actually just use dw9714_vcm_{suspend,resume}() directly
> for the callbacks and avoid the duplicates above.
>
>> +
>> +#else
>> +
>> +#define dw9714_vcm_suspend     NULL
>> +#define dw9714_vcm_resume      NULL
>
> This #else block is not needed.
>
Any updates on this and other comments?

Best regards,
Tomasz
