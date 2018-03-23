Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:39102 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751491AbeCWO3u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 10:29:50 -0400
Date: Fri, 23 Mar 2018 16:29:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andy Yeh <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Subject: Re: [PATCH v9.1] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180323142948.texcmjflbgpk2ma7@valkosipuli.retiisi.org.uk>
References: <1521218319-14972-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5Cbn1sqRWq6A6xYthkHtFjHaa64URDiKDMXOpDPr1r5EA@mail.gmail.com>
 <20180323135024.qxd633qccv5rtid3@paasikivi.fi.intel.com>
 <CAAFQd5ATcV-kWCw+QQfA986G-gwSw2FUZ93Ox_m=fkjixtyuQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5ATcV-kWCw+QQfA986G-gwSw2FUZ93Ox_m=fkjixtyuQA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 23, 2018 at 11:08:11PM +0900, Tomasz Figa wrote:
> On Fri, Mar 23, 2018 at 10:50 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > Hi Tomasz,
> >
> > On Fri, Mar 23, 2018 at 08:43:50PM +0900, Tomasz Figa wrote:
> >> Hi Andy,
> >>
> >> Some issues found when reviewing cherry pick of this patch to Chrome
> >> OS kernel. Please see inline.
> >>
> >> On Sat, Mar 17, 2018 at 1:38 AM, Andy Yeh <andy.yeh@intel.com> wrote:
> >>
> >> [snip]
> >>
> >> > +       case V4L2_CID_VBLANK:
> >> > +               /*
> >> > +                * Auto Frame Length Line Control is enabled by default.
> >> > +                * Not need control Vblank Register.
> >> > +                */
> >>
> >> What is the meaning of this control then? Should it be read-only?
> >
> > The read-only flag is for the uAPI; the control framework still passes
> > through changes to the control value done using kAPI to the driver.
> 
> The read-only flag is not even set in current code.

Ah, you're right, it's just hblank... but if the driver doesn't support
setting this control, then it should most likely be read-only. It would
seem like that the driver just updates the control to convey the value to
the user.

> 
> Also, I'm not sure about the control framework setting read-only
> control. According to the code, it doesn't:
> https://elixir.bootlin.com/linux/latest/source/drivers/media/v4l2-core/v4l2-ctrls.c#L2477

If you set the control using e.g. v4l2_ctrl_s_ctrl(), it should end up to
the driver's s_ctrl callback.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
