Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:35824 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdEIIbD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 May 2017 04:31:03 -0400
Received: by mail-yw0-f179.google.com with SMTP id l135so40968111ywb.2
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 01:31:03 -0700 (PDT)
Received: from mail-yb0-f174.google.com (mail-yb0-f174.google.com. [209.85.213.174])
        by smtp.gmail.com with ESMTPSA id p133sm7349559ywb.73.2017.05.09.01.31.01
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 May 2017 01:31:01 -0700 (PDT)
Received: by mail-yb0-f174.google.com with SMTP id p143so17560990yba.2
        for <linux-media@vger.kernel.org>; Tue, 09 May 2017 01:31:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170508205503.GL7456@valkosipuli.retiisi.org.uk>
References: <1494156804-9784-1-git-send-email-rajmohan.mani@intel.com> <20170508205503.GL7456@valkosipuli.retiisi.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 9 May 2017 16:30:40 +0800
Message-ID: <CAAFQd5CVrrP5tK_LvDbvDT7F5ZjfO+u26T2ca4pOpPjggB6vxw@mail.gmail.com>
Subject: Re: [PATCH] dw9714: Initial driver for dw9714 VCM
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, May 9, 2017 at 4:55 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Rajmohan,
>
> A few comments below...
>
> On Sun, May 07, 2017 at 04:33:24AM -0700, rajmohan.mani@intel.com wrote:
[snip]
>> +     rval = v4l2_async_register_subdev(&dw9714_dev->sd);
>> +     if (rval < 0)
>> +             goto err_cleanup;
>> +
>> +     pm_runtime_enable(&client->dev);
>
> Getting PM runtime right doesn't seem to be easy. :-I
>
> pm_runtime_enable() alone doesn't do the trick. I wonder if adding
> pm_runtime_suspend() would do the trick.

Is this something specific for I2C devices? For platform devices,
typically pm_runtime_enable() is the only thing you would need to do.

>
>> +
>> +     return 0;
>> +
>> +err_cleanup:
>> +     dw9714_subdev_cleanup(dw9714_dev);
>> +     dev_err(&client->dev, "Probe failed: %d\n", rval);
>> +     return rval;
>> +}
>> +
>> +static int dw9714_remove(struct i2c_client *client)
>> +{
>> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +     struct dw9714_device *dw9714_dev = container_of(sd,
>> +                                                     struct dw9714_device,
>> +                                                     sd);
>> +
>> +     pm_runtime_disable(&client->dev);
>> +     dw9714_subdev_cleanup(dw9714_dev);
>> +
>> +     return 0;
>> +}
>> +
>> +#ifdef CONFIG_PM
>> +
>> +static int dw9714_runtime_suspend(struct device *dev)
>> +{
>> +     return 0;
>> +}
>> +
>> +static int dw9714_runtime_resume(struct device *dev)
>> +{
>> +     return 0;
>
> I think it'd be fine to remove empty callbacks.

It's actually a bit more complicated (if a PM domain is attached, the
callbacks must be present), however in case of external I2C devices it
should be fine indeed. However, AFAIK, pm_runtime_no_callbacks()
should be called.

>
>> +}
>> +
>> +/* This function sets the vcm position, so it consumes least current */
>> +static int dw9714_suspend(struct device *dev)
>> +{
>> +     struct i2c_client *client = to_i2c_client(dev);
>> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +     struct dw9714_device *dw9714_dev = container_of(sd,
>> +                                                     struct dw9714_device,
>> +                                                     sd);
>> +     int ret, val;
>> +
>> +     dev_dbg(dev, "%s\n", __func__);
>> +
>> +     for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
>> +          val >= 0; val -= DW9714_CTRL_STEPS) {
>> +             ret = dw9714_i2c_write(client,
>> +                                    DW9714_VAL((u16) val, DW9714_DEFAULT_S));
>> +             if (ret)
>> +                     dev_err(dev, "%s I2C failure: %d", __func__, ret);
>> +             usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
>> +     }
>> +     return 0;
>> +}
>> +
>> +/*
>> + * This function sets the vcm position, so the focus position is set
>> + * closer to the camera
>> + */
>> +static int dw9714_resume(struct device *dev)
>> +{
>> +     struct i2c_client *client = to_i2c_client(dev);
>> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
>> +     struct dw9714_device *dw9714_dev = container_of(sd,
>> +                                                     struct dw9714_device,
>> +                                                     sd);
>> +     int ret, val;
>> +
>> +     dev_dbg(dev, "%s\n", __func__);
>> +
>> +     for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
>> +          val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
>> +          val += DW9714_CTRL_STEPS) {
>> +             ret = dw9714_i2c_write(client,
>> +                                    DW9714_VAL((u16) val, DW9714_DEFAULT_S));
>> +             if (ret)
>> +                     dev_err(dev, "%s I2C failure: %d", __func__, ret);
>> +             usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
>> +     }
>> +
>> +     /* restore v4l2 control values */
>> +     ret = v4l2_ctrl_handler_setup(&dw9714_dev->ctrls_vcm);
>
> Doesn't this need to be done for runtime_resume as well?

This driver doesn't seem to be doing any physical power off in its
runtime_suspend and I don't expect an I2C device to be put in a PM
domain, so possibly no need for it.

Best regards,
Tomasz
