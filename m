Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36582 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754536AbdEKHzs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 03:55:48 -0400
Date: Thu, 11 May 2017 10:55:12 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170511075511.GF3227@valkosipuli.retiisi.org.uk>
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thu, May 11, 2017 at 02:30:31PM +0800, Tomasz Figa wrote:
...
> > +
> > +/*
> > + * This function sets the vcm position, so it consumes least current
> > + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
> > + * to make the movements smoothly.
> > + */
> > +static int dw9714_vcm_suspend(struct device *dev)
> > +{
> > +       struct i2c_client *client = to_i2c_client(dev);
> > +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +       struct dw9714_device *dw9714_dev = container_of(sd,
> > +                                                       struct dw9714_device,
> > +                                                       sd);
> > +       int ret, val;
> > +
> > +       for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
> > +            val >= 0; val -= DW9714_CTRL_STEPS) {
> > +               ret = dw9714_i2c_write(client,
> > +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
> 
> DW9714_VAL() already contains such cast. Anyway, I still think they
> don't really give us anything and should be removed.
> 
> > +               if (ret)
> > +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
> 
> I think we should just return an error code here and fail the suspend.

The result from an error here is that the user would hear an audible click.
I don't think it's worth failing system suspend. :-)

But as no action is taken based on the error code, there could be quite a
few of these messages. How about dev_err_once()? For resume I might use
dev_err_ratelimited().

> 
> > +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
> > +       }
> > +       return 0;
> > +}
> > +
> > +/*
> > + * This function sets the vcm position to the value set by the user
> > + * through v4l2_ctrl_ops s_ctrl handler
> > + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
> > + * to make the movements smoothly.
> > + */
> > +static int dw9714_vcm_resume(struct device *dev)
> > +{
> > +       struct i2c_client *client = to_i2c_client(dev);
> > +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +       struct dw9714_device *dw9714_dev = container_of(sd,
> > +                                                       struct dw9714_device,
> > +                                                       sd);
> > +       int ret, val;
> > +
> > +       for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
> > +            val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
> > +            val += DW9714_CTRL_STEPS) {
> > +               ret = dw9714_i2c_write(client,
> > +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
> 
> Ditto.
> 
> > +               if (ret)
> > +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
> 
> Ditto.
> 
> > +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
> > +       }
> > +
> > +       /* restore v4l2 control values */
> > +       ret = v4l2_ctrl_handler_setup(&dw9714_dev->ctrls_vcm);
> > +       return ret;
> 
> Hmm, actually I believe v4l2_ctrl_handler_setup() will call .s_ctrl()
> here and set the motor value again. If we just make .s_ctrl() do the
> adjustment in steps properly, we can simplify the resume to simply
> call v4l2_ctrl_handler_setup() alone.

Or drop the v4l2_ctrl_handler_setup() here.

The reason is that the driver uses direct drive method for the lens and is
thus responsible for managing ringing compensation as well. Ringing
compensation support could be added to the driver later on; I think another
control will be needed to control the mode.

> 
> > +}
> 
> #endif
> 
> #ifdef CONFIG_PM
> 
> > +
> > +static int dw9714_runtime_suspend(struct device *dev)
> > +{
> > +       return dw9714_vcm_suspend(dev);
> > +}
> > +
> > +static int dw9714_runtime_resume(struct device *dev)
> > +{
> > +       return dw9714_vcm_resume(dev);
> > +}
> 
> #endif
> 
> #ifdef CONFIG_PM_SLEEP

It's hard to get these right, and in 99 % of the cases you'll have them
anyway. __maybe_unused is quite useful in such cases.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
