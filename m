Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:20401 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753321AbeCYPPY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 11:15:24 -0400
From: "Yeh, Andy" <andy.yeh@intel.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>,
        Tomasz Figa <tfiga@chromium.org>
CC: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        "Chiang, AlanX" <alanx.chiang@intel.com>,
        "Lai, Jim" <jim.lai@intel.com>
Subject: RE: [PATCH v9.1] media: imx258: Add imx258 camera sensor driver
Date: Sun, 25 Mar 2018 15:15:18 +0000
Message-ID: <8E0971CCB6EA9D41AF58191A2D3978B61D556C05@PGSMSX111.gar.corp.intel.com>
References: <1521218319-14972-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5Cbn1sqRWq6A6xYthkHtFjHaa64URDiKDMXOpDPr1r5EA@mail.gmail.com>
 <20180323135024.qxd633qccv5rtid3@paasikivi.fi.intel.com>
 <CAAFQd5ATcV-kWCw+QQfA986G-gwSw2FUZ93Ox_m=fkjixtyuQA@mail.gmail.com>
 <20180323142948.texcmjflbgpk2ma7@valkosipuli.retiisi.org.uk>
In-Reply-To: <20180323142948.texcmjflbgpk2ma7@valkosipuli.retiisi.org.uk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz, Sakari,

Thanks for your kindly comments. We will have an internal discussion on VBLANK control implementation to let it be read-only. 

And for test pattern, we will definitely implement it but will remove the item from v4l2 menu first.
However, since in the early stage, we found an issue that if not register TEST_PATTERN V4L2 item in kernel, HAL will crash soon when open camera.
We would like to resolve the issue both in HAL and kernel (removing test pattern) first. 
For test pattern implementation on imx258, it must be needed due to cros-camera-test demands it. Will complete and submit it after full internal verification.


Regards, Andy

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@iki.fi] 
Sent: Friday, March 23, 2018 10:30 PM
To: Tomasz Figa <tfiga@chromium.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>; Yeh, Andy <andy.yeh@intel.com>; Linux Media Mailing List <linux-media@vger.kernel.org>; Chen, JasonX Z <jasonx.z.chen@intel.com>; Chiang, AlanX <alanx.chiang@intel.com>; Lai, Jim <jim.lai@intel.com>
Subject: Re: [PATCH v9.1] media: imx258: Add imx258 camera sensor driver

On Fri, Mar 23, 2018 at 11:08:11PM +0900, Tomasz Figa wrote:
> On Fri, Mar 23, 2018 at 10:50 PM, Sakari Ailus 
> <sakari.ailus@linux.intel.com> wrote:
> > Hi Tomasz,
> >
> > On Fri, Mar 23, 2018 at 08:43:50PM +0900, Tomasz Figa wrote:
> >> Hi Andy,
> >>
> >> Some issues found when reviewing cherry pick of this patch to 
> >> Chrome OS kernel. Please see inline.
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
> > The read-only flag is for the uAPI; the control framework still 
> > passes through changes to the control value done using kAPI to the driver.
> 
> The read-only flag is not even set in current code.

Ah, you're right, it's just hblank... but if the driver doesn't support setting this control, then it should most likely be read-only. It would seem like that the driver just updates the control to convey the value to the user.

> 
> Also, I'm not sure about the control framework setting read-only 
> control. According to the code, it doesn't:
> https://elixir.bootlin.com/linux/latest/source/drivers/media/v4l2-core
> /v4l2-ctrls.c#L2477

If you set the control using e.g. v4l2_ctrl_s_ctrl(), it should end up to the driver's s_ctrl callback.

--
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
