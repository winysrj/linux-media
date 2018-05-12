Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:44964 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbeELMwb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 08:52:31 -0400
Date: Sat, 12 May 2018 15:52:24 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alan Chiang <alanx.chiang@intel.com>, hverkuil@xs4all.nl
Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180512125223.wyknvodn775fknbd@kekkonen.localdomain>
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5BYokHC7J8wEjT4twx7_bU1Yyv1LbN2PAK2tjmCrr2cig@mail.gmail.com>
 <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
 <CAAFQd5CvPCfFx6Nxb26JdSAfD_YNe=-hvyJ=iKLcTA0LpxC4_g@mail.gmail.com>
 <FA6CF6692DF0B343ABE491A46A2CD0E76C65E22D@SHSMSX101.ccr.corp.intel.com>
 <CAAFQd5BKhXiZMZf9OscrHt+SNQNC2PCguKXcNcZNPhjmrgUxzQ@mail.gmail.com>
 <FA6CF6692DF0B343ABE491A46A2CD0E76C65E481@SHSMSX101.ccr.corp.intel.com>
 <CAAFQd5CEdwJ485RQEQ=aZRYtCO-HPE0NgudXKRjVDSbwpbiC5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CEdwJ485RQEQ=aZRYtCO-HPE0NgudXKRjVDSbwpbiC5w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 10, 2018 at 09:15:31AM +0000, Tomasz Figa wrote:
> On Thu, May 10, 2018 at 6:11 PM Zheng, Jian Xu <jian.xu.zheng@intel.com>
> wrote:
> 
> > Hi Tomasz,
> 
> > > -----Original Message-----
> > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > owner@vger.kernel.org] On Behalf Of Tomasz Figa
> > > Sent: Thursday, May 10, 2018 3:04 PM
> > > To: Zheng, Jian Xu <jian.xu.zheng@intel.com>
> > > Cc: Chen, JasonX Z <jasonx.z.chen@intel.com>; Yeh, Andy
> > > <andy.yeh@intel.com>; Linux Media Mailing List <linux-
> > > media@vger.kernel.org>; Sakari Ailus <sakari.ailus@linux.intel.com>;
> Chiang,
> > > AlanX <alanx.chiang@intel.com>
> > > Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
> > >
> > > On Thu, May 10, 2018 at 3:56 PM Zheng, Jian Xu <jian.xu.zheng@intel.com>
> > > wrote:
> > >
> > > > Hi Tomasz,
> > >
> > > > > -----Original Message-----
> > > > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > > > owner@vger.kernel.org] On Behalf Of Tomasz Figa
> > > > > Sent: Wednesday, May 9, 2018 6:05 PM
> > > > > To: Chen, JasonX Z <jasonx.z.chen@intel.com>
> > > > > Cc: Yeh, Andy <andy.yeh@intel.com>; Linux Media Mailing List <linux-
> > > > > media@vger.kernel.org>; Sakari Ailus <sakari.ailus@linux.intel.com>;
> > > Chiang,
> > > > > AlanX <alanx.chiang@intel.com>
> > > > > Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor
> > > > > driver
> > > > >
> > > > > Hi Jason,
> > > > >
> > > > > > IPU3 HAL has a handler to bind test_pattern mode.
> > > > > > The COLOR BAR MODE in HAL has been configured to 1 when APP
> > > > > > requests to
> > > > > output color bar image.
> > > > > > However Sony sensor's COLOR BAR MODE is designed as 2 in register
> > > table.
> > > > > (grey color bars as 1).
> > > > > > When HAL sends handler to driver to switch test pattern mode (to
> > > > > > COLOR
> > > > > BAR - val: 1), it will be grey color, since driver still set
> > > TEST_PATTERN_MODE
> > > > > reg value to 1, those it is not what we expected.
> > > > >
> > > > > > That is why we have to make an array with index to arrange the
> > > > > > order of
> > > > > the test pattern items, so driver will choose COLOR BAR correctly
> > > > > when
> > > HAL
> > > > > send test_pattern message (with 1).
> > > > > > The concept is the test_pattern_menu could be listed in driver per
> > > > > > real
> > > > > requirement, no matter how the sensor register is designed.
> > > > >
> > > > >
> > > > > V4L2 specification does not define any particular order of menu
> > > > > entries
> > > in
> > > > > V4L2_CID_TEST_PATTERN. The application should query the strings in
> > > > > the menu and determine the option it needs based on that. If it
> > > > > hardcodes particular index, it's a bug.
> > >
> > > > Is there any reason that there is no certain macro define for
> > > > different
> > > type of test pattern in v4l2?
> > > > So App will not depend on any strings where could be different on
> > > different sensor drivers.
> > >
> > > Yes. Available patterns differ significantly between one sensor and
> another,
> > > so the menu positions are considered hardware-specific.
> 
> > The problem is even App queries the strings in driver, it still doesn't
> look good enough.
> > Because different driver may have different strings even for same type,
> Color Bar, for example.
> > So it's the best v4l2 could have several standardize names for test
> pattern types.
> > In this case App doesn't need to hard code test pattern strings for
> different sensors.
> 
> > Do you think it makes sense?
> 
> It sounds quite sensible, assuming that we can find such standard subset.
> 
> IMHO a much more scale-able solution would be to have the test pattern
> strings configurable per platform.

What do you mean by a platform here?

I guess we could have standard names (as in strings you get through
QUERYMENU) for certain test patterns. That'd be an improvement; then you'd
be able to rely on these strings.

This control doesn't have any standardised values as what's supported tends
to be hardware specific.

Cc Hans.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
