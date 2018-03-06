Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:27406 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750836AbeCFJSR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 04:18:17 -0500
Date: Tue, 6 Mar 2018 11:18:14 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Andy Yeh <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Subject: Re: [PATCH v6] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180306091814.rd3coopexzlmrhhf@paasikivi.fi.intel.com>
References: <1520002549-6564-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5D1a1Wd0ns85rkg8cJwK+y9uYzaS=c46efOniuGhvFk+w@mail.gmail.com>
 <20180306084045.gabhdrsjks5m7htq@paasikivi.fi.intel.com>
 <CAAFQd5AhfZRKM3sjO3vtbmfOV4RHSEL_AM8AS3FLZdYySiZhPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5AhfZRKM3sjO3vtbmfOV4RHSEL_AM8AS3FLZdYySiZhPg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 06, 2018 at 05:51:36PM +0900, Tomasz Figa wrote:
> On Tue, Mar 6, 2018 at 5:40 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > Hi Tomasz and Andy,
> >
> > On Sat, Mar 03, 2018 at 12:43:59AM +0900, Tomasz Figa wrote:
> > ...
> >> > +static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
> >> > +{
> >> > +       struct imx258 *imx258 =
> >> > +               container_of(ctrl->handler, struct imx258, ctrl_handler);
> >> > +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> >> > +       int ret = 0;
> >> > +       /*
> >> > +        * Applying V4L2 control value only happens
> >> > +        * when power is up for streaming
> >> > +        */
> >> > +       if (pm_runtime_get_if_in_use(&client->dev) <= 0)
> >> > +               return 0;
> >>
> >> I thought we decided to fix this to handle disabled runtime PM properly.
> >
> > Good point. I bet this is a problem in a few other drivers, too. How would
> > you fix that? Check for zero only?
> >
> 
> bool need_runtime_put;
> 
> ret = pm_runtime_get_if_in_use(&client->dev);
> if (ret <= 0 && ret != -EINVAL)
>         return ret;
> need_runtime_put = ret > 0;
> 
> // Do stuff ...
> 
> if (need_runtime_put)
>        pm_runtime_put(&client->dev);
> 
> I don't like how ugly it is, but it appears to be the only way to
> handle this correctly.

The driver enables runtime PM so if runtime PM is enabled in kernel
configuration, it is enabled here. In that case pm_runtime_get_if_in_use()
will return either 0 or 1. So as far as I can see, changing the lines to:

	if (!pm_runtime_get_if_in_use(&client->dev))
		return 0;

is enough.

> >> > +       ret = v4l2_ctrl_handler_init(ctrl_hdlr, 8);
> >> > +       if (ret)
> >>
> >> Missing error message.

Same for this actually, printing an error message here isn't useful. It'd
be just waiting for someone to clean it up. :-)

> >>
> >> > +               return ret;
> >> > +
> >> > +       mutex_init(&imx258->mutex);
> >> > +       ctrl_hdlr->lock = &imx258->mutex;
> >> > +       imx258->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
> >> > +                               &imx258_ctrl_ops,
> >> > +                               V4L2_CID_LINK_FREQ,
> >> > +                               ARRAY_SIZE(link_freq_menu_items) - 1,
> >> > +                               0,
> >> > +                               link_freq_menu_items);
> >> > +
> >> > +       if (!imx258->link_freq) {
> >> > +               ret = -EINVAL;
> >>
> >> Missing error message.
> >
> > I wouldn't add an error message here. Typically you'd need that information
> > at development time only, never after that. v4l2_ctrl_new_int_menu(), as
> > other control framework functions creating new controls, can fail due to
> > memory allocation failure (which is already vocally reported) or due to bad
> > parameters (that are constants).
> >
> > I'd rather do:
> >
> > if (!imx258->link_freq)
> >         ... |= ...;
> >
> > It simplifies error handling and removes the need for goto.
> 
> Hmm, I'm not sure I understand your suggestion. Do you perhaps mean
> 
> if (imx258->link_freq) {
>         // Do stuff that dereferences imx258->link_freq
> }
> 
> // ...
> 
> if (ctrl_hdlr->error) {
>         // Check for error only here, at the end of control initialization.
> }
> 
> then it would be better indeed.

Yes, indeed.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
