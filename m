Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:52371 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750992AbdFTLUi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 07:20:38 -0400
Subject: Re: [PATCH v2 10/19] media: camss: Enable building
To: kbuild test robot <lkp@intel.com>,
        Todor Tomov <todor.tomov@linaro.org>
Cc: kbuild-all@01.org, mchehab@kernel.org, hans.verkuil@cisco.com,
        javier@osg.samsung.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <201706201805.AMRC0n7s%fengguang.wu@intel.com>
From: Todor Tomov <ttomov@mm-sol.com>
Message-ID: <9c93c0ab-5c84-9c72-b033-22b0c953cd1d@mm-sol.com>
Date: Tue, 20 Jun 2017 14:20:33 +0300
MIME-Version: 1.0
In-Reply-To: <201706201805.AMRC0n7s%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

(for everyone's information:)

This error is caused by a missing patch [1] which is needed by this patchset.

The relevant patch has been reviewed and accepted but merging was delayed
until there is a driver actually using the formats which the patch adds.

I'll include the relevant patch in my next version of the patchset so we
will avoid this error next time.

[1] https://git.linuxtv.org/sailus/media_tree.git/commit/?h=packed12-postponed&id=549c02da6eed8dc4566632a9af9233bf99ba99d8

Best regards,
Todor

On 06/20/2017 01:30 PM, kbuild test robot wrote:
> Hi Todor,
> 
> [auto build test ERROR on linuxtv-media/master]
> [also build test ERROR on v4.12-rc6 next-20170620]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Todor-Tomov/Qualcomm-8x16-Camera-Subsystem-driver/20170620-132806
> base:   git://linuxtv.org/media_tree.git master
> config: ia64-allmodconfig (attached as .config)
> compiler: ia64-linux-gcc (GCC) 6.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=ia64 
> 
> All errors (new ones prefixed by >>):
> 
>>> drivers/media/platform/qcom/camss-8x16/video.c:53:32: error: 'V4L2_PIX_FMT_SRGGB12P' undeclared here (not in a function)
>      { MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SRGGB12P, 12 },
>                                    ^~~~~~~~~~~~~~~~~~~~~
>>> drivers/media/platform/qcom/camss-8x16/video.c:54:32: error: 'V4L2_PIX_FMT_SGBRG12P' undeclared here (not in a function)
>      { MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 12 },
>                                    ^~~~~~~~~~~~~~~~~~~~~
>>> drivers/media/platform/qcom/camss-8x16/video.c:55:32: error: 'V4L2_PIX_FMT_SGRBG12P' undeclared here (not in a function)
>      { MEDIA_BUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12P, 12 },
>                                    ^~~~~~~~~~~~~~~~~~~~~
> 
> vim +/V4L2_PIX_FMT_SRGGB12P +53 drivers/media/platform/qcom/camss-8x16/video.c
> 
> 58991044 Todor Tomov 2017-06-19  47  	{ MEDIA_BUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 8 },
> 58991044 Todor Tomov 2017-06-19  48  	{ MEDIA_BUS_FMT_SRGGB8_1X8, V4L2_PIX_FMT_SRGGB8, 8 },
> 58991044 Todor Tomov 2017-06-19  49  	{ MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10P, 10 },
> 58991044 Todor Tomov 2017-06-19  50  	{ MEDIA_BUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10P, 10 },
> 58991044 Todor Tomov 2017-06-19  51  	{ MEDIA_BUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10P, 10 },
> 58991044 Todor Tomov 2017-06-19  52  	{ MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10P, 10 },
> 58991044 Todor Tomov 2017-06-19 @53  	{ MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SRGGB12P, 12 },
> 58991044 Todor Tomov 2017-06-19 @54  	{ MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 12 },
> 58991044 Todor Tomov 2017-06-19 @55  	{ MEDIA_BUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12P, 12 },
> 58991044 Todor Tomov 2017-06-19  56  	{ MEDIA_BUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12P, 12 }
> 58991044 Todor Tomov 2017-06-19  57  };
> 58991044 Todor Tomov 2017-06-19  58  
> 
> :::::: The code at line 53 was first introduced by commit
> :::::: 589910444c8d657c5d9992f6ebf1c0bf5a75e68a media: camss: Add files which handle the video device nodes
> 
> :::::: TO: Todor Tomov <todor.tomov@linaro.org>
> :::::: CC: 0day robot <fengguang.wu@intel.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 

-- 
Best regards,
Todor Tomov
