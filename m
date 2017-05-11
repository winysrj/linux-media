Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37594 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755036AbdEKJDf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 05:03:35 -0400
Date: Thu, 11 May 2017 12:03:27 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Rajmohan Mani <rajmohan.mani@intel.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4] dw9714: Initial driver for dw9714 VCM
Message-ID: <20170511090326.GH3227@valkosipuli.retiisi.org.uk>
References: <1494478820-22199-1-git-send-email-rajmohan.mani@intel.com>
 <CAAFQd5Ck3CKp-JR8d3d1X9-2cRS0oZG9GPwcpunBq50EY7qCtg@mail.gmail.com>
 <20170511075511.GF3227@valkosipuli.retiisi.org.uk>
 <CAAFQd5BH17YofrbaZa07UFTR_qV_h_KgskGJm0bXhuf3sM6huw@mail.gmail.com>
 <20170511082441.GG3227@valkosipuli.retiisi.org.uk>
 <CAAFQd5CdJ4-cg-2s85=8sR4y7o45ybUXcD4buHiOiRuvD=+nWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CdJ4-cg-2s85=8sR4y7o45ybUXcD4buHiOiRuvD=+nWQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thu, May 11, 2017 at 04:37:08PM +0800, Tomasz Figa wrote:
> >> >> > +/*
> >> >> > + * This function sets the vcm position to the value set by the user
> >> >> > + * through v4l2_ctrl_ops s_ctrl handler
> >> >> > + * The lens position is gradually moved in units of DW9714_CTRL_STEPS,
> >> >> > + * to make the movements smoothly.
> >> >> > + */
> >> >> > +static int dw9714_vcm_resume(struct device *dev)
> >> >> > +{
> >> >> > +       struct i2c_client *client = to_i2c_client(dev);
> >> >> > +       struct v4l2_subdev *sd = i2c_get_clientdata(client);
> >> >> > +       struct dw9714_device *dw9714_dev = container_of(sd,
> >> >> > +                                                       struct dw9714_device,
> >> >> > +                                                       sd);
> >> >> > +       int ret, val;
> >> >> > +
> >> >> > +       for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
> >> >> > +            val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
> >> >> > +            val += DW9714_CTRL_STEPS) {
> >> >> > +               ret = dw9714_i2c_write(client,
> >> >> > +                                      DW9714_VAL((u16) val, DW9714_DEFAULT_S));
> >> >>
> >> >> Ditto.
> >> >>
> >> >> > +               if (ret)
> >> >> > +                       dev_err(dev, "%s I2C failure: %d", __func__, ret);
> >> >>
> >> >> Ditto.
> >> >>
> >> >> > +               usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
> >> >> > +       }
> >> >> > +
> >> >> > +       /* restore v4l2 control values */
> >> >> > +       ret = v4l2_ctrl_handler_setup(&dw9714_dev->ctrls_vcm);
> >> >> > +       return ret;
> >> >>
> >> >> Hmm, actually I believe v4l2_ctrl_handler_setup() will call .s_ctrl()
> >> >> here and set the motor value again. If we just make .s_ctrl() do the
> >> >> adjustment in steps properly, we can simplify the resume to simply
> >> >> call v4l2_ctrl_handler_setup() alone.
> >> >
> >> > Or drop the v4l2_ctrl_handler_setup() here.
> >> >
> >> > The reason is that the driver uses direct drive method for the lens and is
> >> > thus responsible for managing ringing compensation as well. Ringing
> >> > compensation support could be added to the driver later on; I think another
> >> > control will be needed to control the mode.
> >>
> >> Given that we already have some kind of ringing compensation in
> >> suspend and resume, can't we just reuse this in control handler? On
> >
> > The way it's done here is unlikely to be helpful for the user space that
> > needs to drive the lens to a new position as fast as possible. The code
> > above is presumably enough to prevent the lens from hitting the mechanical
> > stopper but I'd equally expect it to interfere badly with the user space
> > trying to control the lens.
> 
> Okay, fair enough. I assume then it's not unsafe for the hardware to
> allow userspace to control it over the full range and the worst thing
> that can happen is getting some sound effects? (Rather than some
> malicious userspace burning the motor or so.

Correct. It's a coil, and the dw9714 chip controls the current to the coil.
The higher is the current, the greater is the force that deviating the lens
from its resting position.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
