Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:52601 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756679AbeEJLIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 May 2018 07:08:46 -0400
From: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Chen, JasonX Z" <jasonx.z.chen@intel.com>
CC: Tomasz Figa <tfiga@chromium.org>, "Yeh, Andy" <andy.yeh@intel.com>,
        "Linux Media Mailing List" <linux-media@vger.kernel.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>
Subject: RE: [PATCH v11] media: imx258: Add imx258 camera sensor driver
Date: Thu, 10 May 2018 11:08:43 +0000
Message-ID: <FA6CF6692DF0B343ABE491A46A2CD0E76C65E546@SHSMSX101.ccr.corp.intel.com>
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5BYokHC7J8wEjT4twx7_bU1Yyv1LbN2PAK2tjmCrr2cig@mail.gmail.com>
 <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
 <20180509094259.w7woldhmhbm55vho@paasikivi.fi.intel.com>
In-Reply-To: <20180509094259.w7woldhmhbm55vho@paasikivi.fi.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari & Jason,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sakari Ailus
> Sent: Wednesday, May 9, 2018 5:43 PM
> To: Chen, JasonX Z <jasonx.z.chen@intel.com>
> Cc: Tomasz Figa <tfiga@chromium.org>; Yeh, Andy <andy.yeh@intel.com>;
> Linux Media Mailing List <linux-media@vger.kernel.org>; Chiang, AlanX
> <alanx.chiang@intel.com>
> Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
> 
> Hi Jason,
> 
> On Wed, May 09, 2018 at 09:28:30AM +0000, Chen, JasonX Z wrote:
> > Hello Tomasz
> >
> > >> +/* Test Pattern Control */
> > >> +#define IMX258_REG_TEST_PATTERN                0x0600
> > >> +#define IMX258_TEST_PATTERN_DISABLE    0
> > >> +#define IMX258_TEST_PATTERN_SOLID_COLOR        1
> > >> +#define IMX258_TEST_PATTERN_COLOR_BARS 2 #define
> > >> +IMX258_TEST_PATTERN_GREY_COLOR 3
> > >> +#define IMX258_TEST_PATTERN_PN9                4

I suppose we only use IMX258_TEST_PATTERN_COLOR_BARS. I heard that we'd better remove the functions/code no one would use. Is that true? e.g. remove all h_flip and v_flip ioctls because it's not used by anyone.

Best Regards,
Jianxu(Clive) Zheng
