Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1127 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755965AbeEIJnC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 05:43:02 -0400
Date: Wed, 9 May 2018 12:42:59 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: "Chen, JasonX Z" <jasonx.z.chen@intel.com>
Cc: Tomasz Figa <tfiga@chromium.org>, "Yeh, Andy" <andy.yeh@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Chiang, AlanX" <alanx.chiang@intel.com>
Subject: Re: [PATCH v11] media: imx258: Add imx258 camera sensor driver
Message-ID: <20180509094259.w7woldhmhbm55vho@paasikivi.fi.intel.com>
References: <1525275968-17207-1-git-send-email-andy.yeh@intel.com>
 <CAAFQd5BYokHC7J8wEjT4twx7_bU1Yyv1LbN2PAK2tjmCrr2cig@mail.gmail.com>
 <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5881B549BE56034BB7E7D11D6EDEA2020678E62E@PGSMSX106.gar.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jason,

On Wed, May 09, 2018 at 09:28:30AM +0000, Chen, JasonX Z wrote:
> Hello Tomasz
> 
> >> +/* Test Pattern Control */
> >> +#define IMX258_REG_TEST_PATTERN                0x0600
> >> +#define IMX258_TEST_PATTERN_DISABLE    0
> >> +#define IMX258_TEST_PATTERN_SOLID_COLOR        1
> >> +#define IMX258_TEST_PATTERN_COLOR_BARS 2 #define 
> >> +IMX258_TEST_PATTERN_GREY_COLOR 3
> >> +#define IMX258_TEST_PATTERN_PN9                4
> >> +
> >> +/* Orientation */
> >> +#define REG_MIRROR_FLIP_CONTROL                0x0101
> >> +#define REG_CONFIG_MIRROR_FLIP         0x03
> >> +#define REG_CONFIG_FLIP_TEST_PATTERN   0x02
> >
> >The names are inconsistent here. All other register addresses start with IMX258_REG and values with IMX258_<field name> (no REG).
> >
> >[snip]
> 
> We will update at next patch.

Just to clarify: please send a patch on top of the earlier revision to
address the comments. A pull request containing it has already been sent:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=for-4.18-3>

Thanks.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
