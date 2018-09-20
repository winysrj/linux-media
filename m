Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36438 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727680AbeIUCmX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 22:42:23 -0400
Date: Thu, 20 Sep 2018 23:56:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: ping-chung.chen@intel.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        sylwester.nawrocki@gmail.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Yeh, Andy" <andy.yeh@intel.com>, "Lai, Jim" <jim.lai@intel.com>,
        Grant Grundler <grundler@chromium.org>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
Message-ID: <20180920205658.xv57qcmya7xubgyf@valkosipuli.retiisi.org.uk>
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5D=ze1nSCXwUxOm58+oiWNwuZDS5PvuR+xtNH0=YhA7NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5D=ze1nSCXwUxOm58+oiWNwuZDS5PvuR+xtNH0=YhA7NQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thu, Sep 20, 2018 at 05:51:55PM +0900, Tomasz Figa wrote:
> [+Laurent and Sylwester]
> 
> On Wed, Aug 8, 2018 at 4:08 PM Ping-chung Chen
> <ping-chung.chen@intel.com> wrote:
> [snip]
> > +
> > +/* Digital gain control */
> > +#define IMX208_REG_GR_DIGITAL_GAIN     0x020e
> > +#define IMX208_REG_R_DIGITAL_GAIN      0x0210
> > +#define IMX208_REG_B_DIGITAL_GAIN      0x0212
> > +#define IMX208_REG_GB_DIGITAL_GAIN     0x0214
> > +#define IMX208_DGTL_GAIN_MIN           0
> > +#define IMX208_DGTL_GAIN_MAX           4096
> > +#define IMX208_DGTL_GAIN_DEFAULT       0x100
> > +#define IMX208_DGTL_GAIN_STEP           1
> > +
> [snip]
> > +/* Initialize control handlers */
> > +static int imx208_init_controls(struct imx208 *imx208)
> > +{
> [snip]
> > +       v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops, V4L2_CID_DIGITAL_GAIN,
> > +                         IMX208_DGTL_GAIN_MIN, IMX208_DGTL_GAIN_MAX,
> > +                         IMX208_DGTL_GAIN_STEP,
> > +                         IMX208_DGTL_GAIN_DEFAULT);
> 
> We have a problem here. The sensor supports only a discrete range of
> values here - {1, 2, 4, 8, 16} (multiplied by 256, since the value is
> fixed point). This makes it possible for the userspace to set values
> that are not allowed by the sensor specification and also leaves no
> way to enumerate the supported values.
> 
> I can see two solutions here:
> 
> 1) Define the control range from 0 to 4 and treat it as an exponent of
> 2, so that the value for the sensor becomes (1 << val) * 256.
> (Suggested by Sakari offline.)
> 
> This approach has the problem of losing the original unit (and scale)
> of the value.

I'd like to add that this is not a property of the proposed solution.

Rather, the above needs to be accompanied by additional information
provided through VIDIOC_QUERY_EXT_CTRL, i.e. the unit, prefix as well as
other information such as whether the control is linear or exponential (as
in this case).

> 
> 2) Use an integer menu control, which reports only the supported
> discrete values - {1, 2, 4, 8, 16}.
> 
> With this approach, userspace can enumerate the real gain values, but
> we would either need to introduce a new control (e.g.
> V4L2_CID_DIGITAL_GAIN_DISCRETE) or abuse the specification and
> register V4L2_CID_DIGITAL_GAIN as an integer menu.

New controls in V4L2 are, for the most part, created when there's something
new to control. The documentation of some controls (similar to e.g. gain)
documents a unit as well as a prefix but that's the case only because
there's been no way to tell the unit or prefix otherwise in the API.

An exception to this are EXPOSURE and EXPOSURE_ABSOLUTE. I'm not entirely
sure how they came to be though. An accident is a possibility as far as I
see.

Controls that have a documented unit use that unit --- as long as that's
the unit used by the hardware. If it's not, it tends to be that another
unit is used but the user space has currently no way of knowing this. And
the digital gain control is no exception to this.

So if we want to improve the user space's ability to be informed how the
control values reflect to device configuration, we do need to provide more
information to the user space. One way to do that would be through
VIDIOC_QUERY_EXT_CTRL. The IOCTL struct has plenty of reserved fields ---
just for purposes such as this one.

> 
> Any opinions or better ideas?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
