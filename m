Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:44943 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756350AbeEJIjl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 04:39:41 -0400
Received: by mail-vk0-f49.google.com with SMTP id x66-v6so726285vka.11
        for <linux-media@vger.kernel.org>; Thu, 10 May 2018 01:39:41 -0700 (PDT)
Received: from mail-ua0-f178.google.com (mail-ua0-f178.google.com. [209.85.217.178])
        by smtp.gmail.com with ESMTPSA id u1-v6sm49890vkf.37.2018.05.10.01.39.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 May 2018 01:39:38 -0700 (PDT)
Received: by mail-ua0-f178.google.com with SMTP id f22-v6so820599uam.1
        for <linux-media@vger.kernel.org>; Thu, 10 May 2018 01:39:38 -0700 (PDT)
MIME-Version: 1.0
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5BYokHC7J8wEjT4twx7_bU1Yyv1LbN2PAK2tjmCrr2cig@mail.gmail.com>
 <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
 <CAAFQd5CvPCfFx6Nxb26JdSAfD_YNe=-hvyJ=iKLcTA0LpxC4_g@mail.gmail.com>
 <FA6CF6692DF0B343ABE491A46A2CD0E76C65E22D@SHSMSX101.ccr.corp.intel.com>
 <CAAFQd5BKhXiZMZf9OscrHt+SNQNC2PCguKXcNcZNPhjmrgUxzQ@mail.gmail.com> <8E0971CCB6EA9D41AF58191A2D3978B61D598D9C@PGSMSX111.gar.corp.intel.com>
In-Reply-To: <8E0971CCB6EA9D41AF58191A2D3978B61D598D9C@PGSMSX111.gar.corp.intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 10 May 2018 08:39:27 +0000
Message-ID: <CAAFQd5C3VP2=pQjSGD08-47a=iDM7ttuLLwExKRTcmmZXHACyQ@mail.gmail.com>
Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
To: "Yeh, Andy" <andy.yeh@intel.com>
Cc: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Alan Chiang <alanx.chiang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 10, 2018 at 5:33 PM Yeh, Andy <andy.yeh@intel.com> wrote:

> Hi Tomasz,



> -----Original Message-----
> From: Tomasz Figa [mailto:tfiga@chromium.org]
> Sent: Thursday, May 10, 2018 3:04 PM
> To: Zheng, Jian Xu <jian.xu.zheng@intel.com>
> Cc: Chen, JasonX Z <jasonx.z.chen@intel.com>; Yeh, Andy <
andy.yeh@intel.com>; Linux Media Mailing List <linux-media@vger.kernel.org>;
Sakari Ailus <sakari.ailus@linux.intel.com>; Chiang, AlanX <
alanx.chiang@intel.com>
> Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver

> On Thu, May 10, 2018 at 3:56 PM Zheng, Jian Xu <jian.xu.zheng@intel.com>
> wrote:

> > Hi Tomasz,

> > > -----Original Message-----
> > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > owner@vger.kernel.org] On Behalf Of Tomasz Figa
> > > Sent: Wednesday, May 9, 2018 6:05 PM
> > > To: Chen, JasonX Z <jasonx.z.chen@intel.com>
> > > Cc: Yeh, Andy <andy.yeh@intel.com>; Linux Media Mailing List <linux-
> > > media@vger.kernel.org>; Sakari Ailus <sakari.ailus@linux.intel.com>;
> Chiang,
> > > AlanX <alanx.chiang@intel.com>
> > > Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor
> > > driver
> > >
> > > Hi Jason,
> > >
> > > > IPU3 HAL has a handler to bind test_pattern mode.
> > > > The COLOR BAR MODE in HAL has been configured to 1 when APP
> > > > requests to
> > > output color bar image.
> > > > However Sony sensor's COLOR BAR MODE is designed as 2 in register
> table.
> > > (grey color bars as 1).
> > > > When HAL sends handler to driver to switch test pattern mode (to
> > > > COLOR
> > > BAR - val: 1), it will be grey color, since driver still set
> TEST_PATTERN_MODE
> > > reg value to 1, those it is not what we expected.
> > >
> > > > That is why we have to make an array with index to arrange the
> > > > order of
> > > the test pattern items, so driver will choose COLOR BAR correctly
> > > when
> HAL
> > > send test_pattern message (with 1).
> > > > The concept is the test_pattern_menu could be listed in driver per
> > > > real
> > > requirement, no matter how the sensor register is designed.
> > >
> > >
> > > V4L2 specification does not define any particular order of menu
> > > entries
> in
> > > V4L2_CID_TEST_PATTERN. The application should query the strings in
> > > the menu and determine the option it needs based on that. If it
> > > hardcodes particular index, it's a bug.

> > Is there any reason that there is no certain macro define for
> > different
> type of test pattern in v4l2?
> > So App will not depend on any strings where could be different on
> different sensor drivers.

> > Yes. Available patterns differ significantly between one sensor and
another, so the menu positions are considered hardware-specific.

> In current design, application can still query the available patterns and
select per their needs. Although the menu position doesn't exactly the same
as the datasheet, it still complies with the V4L2 rule. Because it will not
introduce bug for any application, we think it is a feasible approach.

I tend to disagree. When we add another sensor that has a different subset
of test patterns, HAL will break. Please fix it. We can't rely on behavior
that is not guaranteed.

Best regards,
Tomasz
