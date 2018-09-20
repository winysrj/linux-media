Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42717 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbeIUDk6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 23:40:58 -0400
Received: by mail-lj1-f195.google.com with SMTP id f1-v6so9767410ljc.9
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2018 14:55:21 -0700 (PDT)
MIME-Version: 1.0
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com>
 <CAAFQd5D=ze1nSCXwUxOm58+oiWNwuZDS5PvuR+xtNH0=YhA7NQ@mail.gmail.com>
 <20180920205658.xv57qcmya7xubgyf@valkosipuli.retiisi.org.uk> <1961986.b6erRuqaPp@avalon>
In-Reply-To: <1961986.b6erRuqaPp@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Thu, 20 Sep 2018 23:55:03 +0200
Message-ID: <CAPybu_2pCy4EJnih+1pmr43gdh5J0BS_Z0Owb5qpJVkYcDHtyQ@mail.gmail.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, tfiga@chromium.org,
        ping-chung.chen@intel.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        sylwester.nawrocki@gmail.com,
        linux-media <linux-media@vger.kernel.org>, andy.yeh@intel.com,
        jim.lai@intel.com, grundler@chromium.org, rajmohan.mani@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI
On Thu, Sep 20, 2018 at 11:13 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Sakari,
>
> On Thursday, 20 September 2018 23:56:59 EEST Sakari Ailus wrote:
> > On Thu, Sep 20, 2018 at 05:51:55PM +0900, Tomasz Figa wrote:
> > > On Wed, Aug 8, 2018 at 4:08 PM Ping-chung Chen wrote:
> > > [snip]
> > >
> > > > +
> > > > +/* Digital gain control */
> > > > +#define IMX208_REG_GR_DIGITAL_GAIN     0x020e
> > > > +#define IMX208_REG_R_DIGITAL_GAIN      0x0210
> > > > +#define IMX208_REG_B_DIGITAL_GAIN      0x0212
> > > > +#define IMX208_REG_GB_DIGITAL_GAIN     0x0214
> > > > +#define IMX208_DGTL_GAIN_MIN           0
> > > > +#define IMX208_DGTL_GAIN_MAX           4096
> > > > +#define IMX208_DGTL_GAIN_DEFAULT       0x100
> > > > +#define IMX208_DGTL_GAIN_STEP           1
> > > > +
> > >
> > > [snip]
> > >
> > > > +/* Initialize control handlers */
> > > > +static int imx208_init_controls(struct imx208 *imx208)
> > > > +{
> > >
> > > [snip]
> > >
> > > > +       v4l2_ctrl_new_std(ctrl_hdlr, &imx208_ctrl_ops,
> > > > V4L2_CID_DIGITAL_GAIN, +                         IMX208_DGTL_GAIN_MIN,
> > > > IMX208_DGTL_GAIN_MAX, +                         IMX208_DGTL_GAIN_STEP,
> > > > +                         IMX208_DGTL_GAIN_DEFAULT);
> > >
> > > We have a problem here. The sensor supports only a discrete range of
> > > values here - {1, 2, 4, 8, 16} (multiplied by 256, since the value is
> > > fixed point). This makes it possible for the userspace to set values
> > > that are not allowed by the sensor specification and also leaves no
> > > way to enumerate the supported values.
> > >
> > > I can see two solutions here:
> > >
> > > 1) Define the control range from 0 to 4 and treat it as an exponent of
> > > 2, so that the value for the sensor becomes (1 << val) * 256.
> > > (Suggested by Sakari offline.)
> > >
> > > This approach has the problem of losing the original unit (and scale)
> > > of the value.
> >
> > I'd like to add that this is not a property of the proposed solution.
> >
> > Rather, the above needs to be accompanied by additional information
> > provided through VIDIOC_QUERY_EXT_CTRL, i.e. the unit, prefix as well as
> > other information such as whether the control is linear or exponential (as
> > in this case).
> >
> > > 2) Use an integer menu control, which reports only the supported
> > > discrete values - {1, 2, 4, 8, 16}.
> > >
> > > With this approach, userspace can enumerate the real gain values, but
> > > we would either need to introduce a new control (e.g.
> > > V4L2_CID_DIGITAL_GAIN_DISCRETE) or abuse the specification and
> > > register V4L2_CID_DIGITAL_GAIN as an integer menu.
> >
> > New controls in V4L2 are, for the most part, created when there's something
> > new to control. The documentation of some controls (similar to e.g. gain)
> > documents a unit as well as a prefix but that's the case only because
> > there's been no way to tell the unit or prefix otherwise in the API.
> >
> > An exception to this are EXPOSURE and EXPOSURE_ABSOLUTE. I'm not entirely
> > sure how they came to be though. An accident is a possibility as far as I
> > see.
>
> If I remember correctly I introduced the absolute variant for the UVC driver
> (even though git blame points to Brandon Philips). I don't really remember why
> though.
>
> > Controls that have a documented unit use that unit --- as long as that's
> > the unit used by the hardware. If it's not, it tends to be that another
> > unit is used but the user space has currently no way of knowing this. And
> > the digital gain control is no exception to this.
> >
> > So if we want to improve the user space's ability to be informed how the
> > control values reflect to device configuration, we do need to provide more
> > information to the user space. One way to do that would be through
> > VIDIOC_QUERY_EXT_CTRL. The IOCTL struct has plenty of reserved fields ---
> > just for purposes such as this one.
>
> I don't think we can come up with a good way to expose arbitrary mathematical
> formulas through an ioctl. In my opinion the question is how far we want to
> go, how precise we need to be.
>
> > > Any opinions or better ideas?

My 0.02 DKK.  On a similar situation, where userspace was running a
close loop calibration:

We have implemented two extra control: eposure_next exposure_pre that
tell us which one is the next value. Perhaps we could embebed such
functionality in QUERY_EXT_CTRL.

Cheers


>
> --
> Regards,
>
> Laurent Pinchart
>
>
>


-- 
Ricardo Ribalda
