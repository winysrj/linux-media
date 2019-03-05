Return-Path: <SRS0=h5dj=RI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71732C43381
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 00:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4549D206DD
	for <linux-media@archiver.kernel.org>; Tue,  5 Mar 2019 00:25:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfCEAZx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 19:25:53 -0500
Received: from mga04.intel.com ([192.55.52.120]:58216 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfCEAZw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Mar 2019 19:25:52 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Mar 2019 16:25:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,441,1544515200"; 
   d="scan'208";a="148586669"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga002.fm.intel.com with ESMTP; 04 Mar 2019 16:25:52 -0800
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 4 Mar 2019 16:25:51 -0800
Received: from shsmsx151.ccr.corp.intel.com (10.239.6.50) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 4 Mar 2019 16:25:51 -0800
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.74]) by
 SHSMSX151.ccr.corp.intel.com ([169.254.3.26]) with mapi id 14.03.0415.000;
 Tue, 5 Mar 2019 08:25:19 +0800
From:   "Cao, Bingbu" <bingbu.cao@intel.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "Zhi, Yong" <yong.zhi@intel.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] media: staging/intel-ipu3: reduce kernel stack usage
Thread-Topic: [PATCH] media: staging/intel-ipu3: reduce kernel stack usage
Thread-Index: AQHU0sjI/9ys7oMm70KxNpya8bdOOaX8LDeg
Date:   Tue, 5 Mar 2019 00:25:18 +0000
Message-ID: <EE45BB6704246A4E914B70E8B61FB42A15C131D5@SHSMSX104.ccr.corp.intel.com>
References: <20190304202758.1802417-1-arnd@arndb.de>
In-Reply-To: <20190304202758.1802417-1-arnd@arndb.de>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzM2ZjM5Y2ItNmNhOC00ZTFmLWFmMGQtMzUwOTZkMzUyZDcyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVVBTMHBvVGdaN1F4ZVpxM0JBRWxDeGcwR1l4VmVzczNoOVQ3MGI4K2lMeDZ2eTdVVnMzMXdzVEYrVTQ2bkd2SiJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



__________________________
BRs,
Cao, Bingbu



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, March 5, 2019 4:28 AM
> To: Sakari Ailus <sakari.ailus@linux.intel.com>; Mauro Carvalho Chehab
> <mchehab@kernel.org>; Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arnd Bergmann <arnd@arndb.de>; Zhi, Yong <yong.zhi@intel.com>; Cao,
> Bingbu <bingbu.cao@intel.com>; linux-media@vger.kernel.org;
> devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] media: staging/intel-ipu3: reduce kernel stack usage
> 
> The imgu_css_queue structure is too large to be put on the kernel stack,
> as we can see in 32-bit builds:
> 
> drivers/staging/media/ipu3/ipu3-css.c: In function 'imgu_css_fmt_try':
> drivers/staging/media/ipu3/ipu3-css.c:1863:1: error: the frame size of
> 1172 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> By dynamically allocating this array, the stack usage goes down to an
> acceptable 140 bytes for the same x86-32 configuration.
> 
> Fixes: f5f2e4273518 ("media: staging/intel-ipu3: Add css pipeline
> programming")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/media/ipu3/ipu3-css.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/media/ipu3/ipu3-css.c
> b/drivers/staging/media/ipu3/ipu3-css.c
> index 15ab77e4b766..664c14b7a518 100644
> --- a/drivers/staging/media/ipu3/ipu3-css.c
> +++ b/drivers/staging/media/ipu3/ipu3-css.c
> @@ -3,6 +3,7 @@
> 
>  #include <linux/device.h>
>  #include <linux/iopoll.h>
> +#include <linux/slab.h>
> 
>  #include "ipu3-css.h"
>  #include "ipu3-css-fw.h"
> @@ -1744,7 +1745,7 @@ int imgu_css_fmt_try(struct imgu_css *css,
>  	struct v4l2_rect *const bds = &r[IPU3_CSS_RECT_BDS];
>  	struct v4l2_rect *const env = &r[IPU3_CSS_RECT_ENVELOPE];
>  	struct v4l2_rect *const gdc = &r[IPU3_CSS_RECT_GDC];
> -	struct imgu_css_queue q[IPU3_CSS_QUEUES];
> +	struct imgu_css_queue *q = kcalloc(IPU3_CSS_QUEUES, sizeof(struct
> +imgu_css_queue), GFP_KERNEL);

Could you use the devm_kcalloc()? 
>  	struct v4l2_pix_format_mplane *const in =
>  					&q[IPU3_CSS_QUEUE_IN].fmt.mpix;
>  	struct v4l2_pix_format_mplane *const out = @@ -1753,6 +1754,11 @@
> int imgu_css_fmt_try(struct imgu_css *css,
>  					&q[IPU3_CSS_QUEUE_VF].fmt.mpix;
>  	int i, s, ret;
> 
> +	if (!q) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
[Cao, Bingbu] 
The goto here is wrong, you can just report an error, and I prefer it is next to the alloc.
> +
>  	/* Adjust all formats, get statistics buffer sizes and formats */
>  	for (i = 0; i < IPU3_CSS_QUEUES; i++) {
>  		if (fmts[i])
> @@ -1766,7 +1772,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
>  					IPU3_CSS_QUEUE_TO_FLAGS(i))) {
>  			dev_notice(css->dev, "can not initialize queue %s\n",
>  				   qnames[i]);
> -			return -EINVAL;
> +			ret = -EINVAL;
> +			goto out;
>  		}
>  	}
>  	for (i = 0; i < IPU3_CSS_RECTS; i++) { @@ -1788,7 +1795,8 @@ int
> imgu_css_fmt_try(struct imgu_css *css,
>  	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_IN]) ||
>  	    !imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) {
>  		dev_warn(css->dev, "required queues are disabled\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out;
>  	}
> 
>  	if (!imgu_css_queue_enabled(&q[IPU3_CSS_QUEUE_OUT])) { @@ -1829,7
> +1837,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
>  	ret = imgu_css_find_binary(css, pipe, q, r);
>  	if (ret < 0) {
>  		dev_err(css->dev, "failed to find suitable binary\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out;
>  	}
>  	css->pipes[pipe].bindex = ret;
> 
> @@ -1843,7 +1852,8 @@ int imgu_css_fmt_try(struct imgu_css *css,
>  						IPU3_CSS_QUEUE_TO_FLAGS(i))) {
>  				dev_err(css->dev,
>  					"final resolution adjustment failed\n");
> -				return -EINVAL;
> +				ret = -EINVAL;
> +				goto out;
>  			}
>  			*fmts[i] = q[i].fmt.mpix;
>  		}
> @@ -1859,7 +1869,10 @@ int imgu_css_fmt_try(struct imgu_css *css,
>  		 bds->width, bds->height, gdc->width, gdc->height,
>  		 out->width, out->height, vf->width, vf->height);
> 
> -	return 0;
> +	ret = 0;
> +out:
> +	kfree(q);
> +	return ret;
>  }
> 
>  int imgu_css_fmt_set(struct imgu_css *css,
> --
> 2.20.0

