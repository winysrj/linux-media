Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:18178 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752570AbeEOH7t (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:49 -0400
Date: Tue, 15 May 2018 10:59:45 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
Cc: "Chen, JasonX Z" <jasonx.z.chen@intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Yeh, Andy" <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180515075945.xe56ax6quqw6rndt@paasikivi.fi.intel.com>
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5BYokHC7J8wEjT4twx7_bU1Yyv1LbN2PAK2tjmCrr2cig@mail.gmail.com>
 <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
 <20180509094259.w7woldhmhbm55vho@paasikivi.fi.intel.com>
 <FA6CF6692DF0B343ABE491A46A2CD0E76C65E546@SHSMSX101.ccr.corp.intel.com>
 <20180512124754.lvcspfqbbnogo6ee@kekkonen.localdomain>
 <FA6CF6692DF0B343ABE491A46A2CD0E76C6640FE@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA6CF6692DF0B343ABE491A46A2CD0E76C6640FE@SHSMSX101.ccr.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 15, 2018 at 03:46:37AM +0000, Zheng, Jian Xu wrote:
> Hi Sakari,
> 
> > -----Original Message-----
> > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > owner@vger.kernel.org] On Behalf Of Sakari Ailus
> > Sent: Saturday, May 12, 2018 8:48 PM
> > To: Zheng, Jian Xu <jian.xu.zheng@intel.com>
> > Cc: Chen, JasonX Z <jasonx.z.chen@intel.com>; Tomasz Figa
> > <tfiga@chromium.org>; Yeh, Andy <andy.yeh@intel.com>; Linux Media
> > Mailing List <linux-media@vger.kernel.org>; Chiang, AlanX
> > <alanx.chiang@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>
> > Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
> > 
> > On Thu, May 10, 2018 at 11:08:43AM +0000, Zheng, Jian Xu wrote:
> > > Hi Sakari & Jason,
> > >
> > > > -----Original Message-----
> > > > From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> > > > owner@vger.kernel.org] On Behalf Of Sakari Ailus
> > > > Sent: Wednesday, May 9, 2018 5:43 PM
> > > > To: Chen, JasonX Z <jasonx.z.chen@intel.com>
> > > > Cc: Tomasz Figa <tfiga@chromium.org>; Yeh, Andy
> > > > <andy.yeh@intel.com>; Linux Media Mailing List
> > > > <linux-media@vger.kernel.org>; Chiang, AlanX
> > > > <alanx.chiang@intel.com>
> > > > Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor
> > > > driver
> > > >
> > > > Hi Jason,
> > > >
> > > > On Wed, May 09, 2018 at 09:28:30AM +0000, Chen, JasonX Z wrote:
> > > > > Hello Tomasz
> > > > >
> > > > > >> +/* Test Pattern Control */
> > > > > >> +#define IMX258_REG_TEST_PATTERN                0x0600
> > > > > >> +#define IMX258_TEST_PATTERN_DISABLE    0
> > > > > >> +#define IMX258_TEST_PATTERN_SOLID_COLOR        1
> > > > > >> +#define IMX258_TEST_PATTERN_COLOR_BARS 2 #define
> > > > > >> +IMX258_TEST_PATTERN_GREY_COLOR 3
> > > > > >> +#define IMX258_TEST_PATTERN_PN9                4
> > >
> > > I suppose we only use IMX258_TEST_PATTERN_COLOR_BARS. I heard that
> > > we'd better remove the functions/code no one would use. Is that true? e.g.
> > > remove all h_flip and v_flip ioctls because it's not used by anyone.
> > 
> > HFLIP and VFLIP support were AFAIR removed as they were not supported
> > correctly by the driver --- they do affect the pixel order, i.e. the format.

> So you mean that if the sensor is RAW format, we should not implement
> HFLIP/VFLIP. Because it changes the pixel order? I don't quite follow the
> logic here. In the meantime, if the logic works here, we need some other
> kind of HFLIP/VFLIP ioctl because it's supported by HW.

You can implement it but the implementation needs to be correctly reflect
the flipping in the pixel order reported by the driver.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
