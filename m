Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47728 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751653AbdEIKku (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 06:40:50 -0400
Date: Tue, 9 May 2017 13:40:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170509104045.GO7456@valkosipuli.retiisi.org.uk>
References: <1494156804-9784-1-git-send-email-rajmohan.mani@intel.com>
 <20170508205503.GL7456@valkosipuli.retiisi.org.uk>
 <CAAFQd5CVrrP5tK_LvDbvDT7F5ZjfO+u26T2ca4pOpPjggB6vxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CVrrP5tK_LvDbvDT7F5ZjfO+u26T2ca4pOpPjggB6vxw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Tue, May 09, 2017 at 04:30:40PM +0800, Tomasz Figa wrote:
> Hi Sakari,
> 
> On Tue, May 9, 2017 at 4:55 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Rajmohan,
> >
> > A few comments below...
> >
> > On Sun, May 07, 2017 at 04:33:24AM -0700, rajmohan.mani@intel.com wrote:
> [snip]
> >> +     rval = v4l2_async_register_subdev(&dw9714_dev->sd);
> >> +     if (rval < 0)
> >> +             goto err_cleanup;
> >> +
> >> +     pm_runtime_enable(&client->dev);
> >
> > Getting PM runtime right doesn't seem to be easy. :-I
> >
> > pm_runtime_enable() alone doesn't do the trick. I wonder if adding
> > pm_runtime_suspend() would do the trick.
> 
> Is this something specific for I2C devices? For platform devices,
> typically pm_runtime_enable() is the only thing you would need to do.

I think you're right --- driver_probe_device() will call pm_request_idle()
to the device right after probe. So indeed calling pm_runtime_enable() is
enough.

> >> +
> >> +     return 0;
> >> +
> >> +err_cleanup:
> >> +     dw9714_subdev_cleanup(dw9714_dev);
> >> +     dev_err(&client->dev, "Probe failed: %d\n", rval);
> >> +     return rval;
> >> +}
> >> +
> >> +static int dw9714_remove(struct i2c_client *client)
> >> +{
> >> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >> +     struct dw9714_device *dw9714_dev = container_of(sd,
> >> +                                                     struct dw9714_device,
> >> +                                                     sd);
> >> +
> >> +     pm_runtime_disable(&client->dev);
> >> +     dw9714_subdev_cleanup(dw9714_dev);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +#ifdef CONFIG_PM
> >> +
> >> +static int dw9714_runtime_suspend(struct device *dev)
> >> +{
> >> +     return 0;
> >> +}
> >> +
> >> +static int dw9714_runtime_resume(struct device *dev)
> >> +{
> >> +     return 0;
> >
> > I think it'd be fine to remove empty callbacks.
> 
> It's actually a bit more complicated (if a PM domain is attached, the
> callbacks must be present), however in case of external I2C devices it
> should be fine indeed. However, AFAIK, pm_runtime_no_callbacks()
> should be called.

I wonder if I'm missing something --- acpi_subsys_runtime_resume() first
calls acpi_dev_runtime_resume() and if all goes well, the proceeds to call
pm_generic_runtime_resume() which calls device's runtime_resume() if it's
non-NULL.

In other words, having a runtime_resume() and runtime_suspend() callbacks
that return zero is equivalent of having neither of the callbacks.

> 
> >
> >> +}
> >> +
> >> +/* This function sets the vcm position, so it consumes least current */
> >> +static int dw9714_suspend(struct device *dev)
> >> +{
> >> +     struct i2c_client *client = to_i2c_client(dev);
> >> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >> +     struct dw9714_device *dw9714_dev = container_of(sd,
> >> +                                                     struct dw9714_device,
> >> +                                                     sd);
> >> +     int ret, val;
> >> +
> >> +     dev_dbg(dev, "%s\n", __func__);
> >> +
> >> +     for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
> >> +          val >= 0; val -= DW9714_CTRL_STEPS) {
> >> +             ret = dw9714_i2c_write(client,
> >> +                                    DW9714_VAL((u16) val, DW9714_DEFAULT_S));
> >> +             if (ret)
> >> +                     dev_err(dev, "%s I2C failure: %d", __func__, ret);
> >> +             usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
> >> +     }
> >> +     return 0;
> >> +}
> >> +
> >> +/*
> >> + * This function sets the vcm position, so the focus position is set
> >> + * closer to the camera
> >> + */
> >> +static int dw9714_resume(struct device *dev)
> >> +{
> >> +     struct i2c_client *client = to_i2c_client(dev);
> >> +     struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >> +     struct dw9714_device *dw9714_dev = container_of(sd,
> >> +                                                     struct dw9714_device,
> >> +                                                     sd);
> >> +     int ret, val;
> >> +
> >> +     dev_dbg(dev, "%s\n", __func__);
> >> +
> >> +     for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
> >> +          val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
> >> +          val += DW9714_CTRL_STEPS) {
> >> +             ret = dw9714_i2c_write(client,
> >> +                                    DW9714_VAL((u16) val, DW9714_DEFAULT_S));
> >> +             if (ret)
> >> +                     dev_err(dev, "%s I2C failure: %d", __func__, ret);
> >> +             usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
> >> +     }
> >> +
> >> +     /* restore v4l2 control values */
> >> +     ret = v4l2_ctrl_handler_setup(&dw9714_dev->ctrls_vcm);
> >
> > Doesn't this need to be done for runtime_resume as well?
> 
> This driver doesn't seem to be doing any physical power off in its
> runtime_suspend and I don't expect an I2C device to be put in a PM
> domain, so possibly no need for it.

I'd expect runtime PM suspend callback to power the device off through ACPI
PM. For this reason the device state must be restored when it's powered on,
i.e. its runtime_resume callback.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
