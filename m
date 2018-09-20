Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:43704 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730936AbeITWdg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Sep 2018 18:33:36 -0400
Received: by mail-io1-f67.google.com with SMTP id y10-v6so8168719ioa.10
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2018 09:49:14 -0700 (PDT)
MIME-Version: 1.0
References: <1533712560-17357-1-git-send-email-ping-chung.chen@intel.com> <CAAFQd5D=ze1nSCXwUxOm58+oiWNwuZDS5PvuR+xtNH0=YhA7NQ@mail.gmail.com>
In-Reply-To: <CAAFQd5D=ze1nSCXwUxOm58+oiWNwuZDS5PvuR+xtNH0=YhA7NQ@mail.gmail.com>
From: Grant Grundler <grundler@chromium.org>
Date: Thu, 20 Sep 2018 09:49:02 -0700
Message-ID: <CANEJEGvZn7oSdtYcwb4qxqiys1_y6GPh+1fZUfdejg2ztSsRmw@mail.gmail.com>
Subject: Re: [PATCH v5] media: imx208: Add imx208 camera sensor driver
To: tfiga@chromium.org
Cc: ping-chung.chen@intel.com, sakari.ailus@linux.intel.com,
        laurent.pinchart@ideasonboard.com, sylwester.nawrocki@gmail.com,
        linux-media@vger.kernel.org, andy.yeh@intel.com, jim.lai@intel.com,
        Grant Grundler <grundler@chromium.org>,
        Rajmohan Mani <rajmohan.mani@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[resend in plain text - sorry!]

On Thu, Sep 20, 2018 at 1:52 AM Tomasz Figa <tfiga@chromium.org> wrote:
>
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

Exactly - will users be confused by this? If we have to explain it,
probably not the best choice.

>
> 2) Use an integer menu control, which reports only the supported
> discrete values - {1, 2, 4, 8, 16}.
>
> With this approach, userspace can enumerate the real gain values, but
> we would either need to introduce a new control (e.g.
> V4L2_CID_DIGITAL_GAIN_DISCRETE) or abuse the specification and
> register V4L2_CID_DIGITAL_GAIN as an integer menu.
>
> Any opinions or better ideas?

My $0.02: leave the user UI alone - let users specify/select anything
in the range the normal API or UI allows. But have sensor specific
code map all values in that range to values the sensor supports. Users
will notice how it works when they play with it.  One can "adjust" the
mapping so it "feels right".

cheers,
grant
>
> Best regards,
> Tomasz
