Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60757 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753619AbeE3Wbh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 18:31:37 -0400
From: "Mani, Rajmohan" <rajmohan.mani@intel.com>
To: "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>
CC: "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Qiu, Tian Shu" <tian.shu.qiu@intel.com>,
        "Cao, Bingbu" <bingbu.cao@intel.com>
Subject: RE: [PATCH v2] [media] MAINTAINERS: Update entry for Intel IPU3
 cio2 driver
Date: Wed, 30 May 2018 22:31:35 +0000
Message-ID: <6F87890CF0F5204F892DEA1EF0D77A59730879A8@FMSMSX114.amr.corp.intel.com>
References: <1527718216-826-1-git-send-email-yong.zhi@intel.com>
In-Reply-To: <1527718216-826-1-git-send-email-yong.zhi@intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

> -----Original Message-----
> From: Zhi, Yong
> Sent: Wednesday, May 30, 2018 3:10 PM
> To: linux-media@vger.kernel.org; sakari.ailus@linux.intel.com
> Cc: Mani, Rajmohan <rajmohan.mani@intel.com>; Zheng, Jian Xu
> <jian.xu.zheng@intel.com>; Qiu, Tian Shu <tian.shu.qiu@intel.com>; Cao,
> Bingbu <bingbu.cao@intel.com>; Zhi, Yong <yong.zhi@intel.com>
> Subject: [PATCH v2] [media] MAINTAINERS: Update entry for Intel IPU3 cio2
> driver
> 
> This patch adds three more maintainers to the IPU3 CIO2 driver.

nit:  The above line should be changed to reflect this v2 patch.

> 
> Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a38e24a..3dd530e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7157,6 +7157,9 @@ F:	drivers/dma/iop-adma.c
>  INTEL IPU3 CSI-2 CIO2 DRIVER
>  M:	Yong Zhi <yong.zhi@intel.com>
>  M:	Sakari Ailus <sakari.ailus@linux.intel.com>
> +M:	Bingbu Cao <bingbu.cao@intel.com>
> +R:	Tian Shu Qiu <tian.shu.qiu@intel.com>
> +R:	Jian Xu Zheng <jian.xu.zheng@intel.com>
>  L:	linux-media@vger.kernel.org
>  S:	Maintained
>  F:	drivers/media/pci/intel/ipu3/
> --
> 2.7.4
