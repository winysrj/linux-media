Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48222 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752689AbdEIKyt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 06:54:49 -0400
Date: Tue, 9 May 2017 13:54:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170509105413.GP7456@valkosipuli.retiisi.org.uk>
References: <1494254208-30045-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5A34z8=uAAq-k+d-n0E+93dup1DuQZHsoaw+5YNaGqWPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5A34z8=uAAq-k+d-n0E+93dup1DuQZHsoaw+5YNaGqWPw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Tue, May 09, 2017 at 04:44:13PM +0800, Tomasz Figa wrote:
...
> > +/* This function sets the vcm position, so it consumes least current */
> > +static int dw9714_suspend(struct device *dev)
> > +{
> > +       struct i2c_client *client = to_i2c_client(dev);
> > +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> > +       struct dw9714_device *dw9714_dev = container_of(sd,
> > +                                                       struct dw9714_device,
> > +                                                       sd);
> > +       int ret, val;
> > +
> > +       dev_dbg(dev, "%s\n", __func__);
> > +
> > +       for (val = dw9714_dev->current_val & ~(DW9714_CTRL_STEPS - 1);
> > +            val >= 0; val -= DW9714_CTRL_STEPS) {
> > +               ret = dw9714_i2c_write(client,
> > +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
> > +               if (ret)
> > +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
> > +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
> 
> Is it necessary to change the value in such steps? If so, shouldn't
> the control handler behave in the same way, making sure that userspace
> does not request changes in bigger steps?

I believe the reason for this is to gradually move the lens to the resting
position in order to avoid an audible click that results from the lens
hitting the mechanical stopper.

That said, this chip should have ringing compensation so I wonder if
gradually setting the desired value necessary. I let Rajmohan to comment on
that.

What still might be needed is to delay powering the device off by a small
amount of time.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
