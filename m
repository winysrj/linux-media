Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:62727 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752281AbeCWNu1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 09:50:27 -0400
Date: Fri, 23 Mar 2018 15:50:24 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Andy Yeh <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Alan Chiang <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Subject: Re: [PATCH v9.1] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180323135024.qxd633qccv5rtid3@paasikivi.fi.intel.com>
References: <1521218319-14972-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5Cbn1sqRWq6A6xYthkHtFjHaa64URDiKDMXOpDPr1r5EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5Cbn1sqRWq6A6xYthkHtFjHaa64URDiKDMXOpDPr1r5EA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Fri, Mar 23, 2018 at 08:43:50PM +0900, Tomasz Figa wrote:
> Hi Andy,
> 
> Some issues found when reviewing cherry pick of this patch to Chrome
> OS kernel. Please see inline.
> 
> On Sat, Mar 17, 2018 at 1:38 AM, Andy Yeh <andy.yeh@intel.com> wrote:
> 
> [snip]
> 
> > +       case V4L2_CID_VBLANK:
> > +               /*
> > +                * Auto Frame Length Line Control is enabled by default.
> > +                * Not need control Vblank Register.
> > +                */
> 
> What is the meaning of this control then? Should it be read-only?

The read-only flag is for the uAPI; the control framework still passes
through changes to the control value done using kAPI to the driver.

> 
> > +               break;
> > +       default:
> > +               dev_info(&client->dev,
> > +                        "ctrl(id:0x%x,val:0x%x) is not handled\n",
> > +                        ctrl->id, ctrl->val);
> > +               ret = -EINVAL;
> > +               break;
> > +       }
> > +
> > +       pm_runtime_put(&client->dev);
> > +
> > +       return ret;
> > +
> 
> [snip]
> 
> > +       v4l2_ctrl_new_std_menu_items(ctrl_hdlr, &imx258_ctrl_ops,
> > +                               V4L2_CID_TEST_PATTERN,
> > +                               ARRAY_SIZE(imx258_test_pattern_menu) - 1,
> > +                               0, 0, imx258_test_pattern_menu);
> 
> There is no code for handling this control in imx258_s_ctrl(). It's
> not a correct behavior to register a control, which isn't handled by
> the driver. Please either implement the control completely or remove
> it.

Indeed.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
