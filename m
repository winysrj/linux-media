Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:40123 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932484AbeEHImL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2018 04:42:11 -0400
Subject: Re: [bug report] [media] exynos4-is: Add the FIMC-IS ISP capture
 DMA driver
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <d42c210b-4c6d-4a19-e314-21576ebb7b46@samsung.com>
Date: Tue, 08 May 2018 10:42:05 +0200
MIME-version: 1.0
In-reply-to: <20180503114301.GA7576@mwanda>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20180503114314epcas2p3a468e807db4c04b2f42b904c530d8565@epcas2p3.samsung.com>
        <20180503114301.GA7576@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/03/2018 01:43 PM, Dan Carpenter wrote:
> [ This code is five years old now.  It's so weird to me that the warning
>   is showing up in my new warnings pile.  Perhaps this wasn't included
>   in my allmodconfig before?  - dan ]

Might be, the bug found is real. The module is normally disabled anyway 
for other reasons.

> Hello Sylwester Nawrocki,
> 
> The patch 34947b8aebe3: "[media] exynos4-is: Add the FIMC-IS ISP
> capture DMA driver" from Dec 20, 2013, leads to the following static
> checker warning:
> 
> 	drivers/media/platform/exynos4-is/fimc-isp-video.c:408 isp_video_try_fmt_mplane()
> 	error: NULL dereference inside function '__isp_video_try_fmt(isp, &f->fmt.pix_mp, (0))()'.
> 
> drivers/media/platform/exynos4-is/fimc-isp-video.c
>    383  static void __isp_video_try_fmt(struct fimc_isp *isp,
>    384                                  struct v4l2_pix_format_mplane *pixm,
>    385                                  const struct fimc_fmt **fmt)
>    386  {
>    387          *fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);
>                 ^^^^
> Unchecked dereference.  We're not allowed to pass a NULL "fmt".
> 
>    388  
>    389          pixm->colorspace = V4L2_COLORSPACE_SRGB;
>    390          pixm->field = V4L2_FIELD_NONE;
>    391          pixm->num_planes = (*fmt)->memplanes;
>    392          pixm->pixelformat = (*fmt)->fourcc;
>    393          /*
>    394           * TODO: double check with the docmentation these width/height
>    395           * constraints are correct.
>    396           */
>    397          v4l_bound_align_image(&pixm->width, FIMC_ISP_SOURCE_WIDTH_MIN,
>    398                                FIMC_ISP_SOURCE_WIDTH_MAX, 3,
>    399                                &pixm->height, FIMC_ISP_SOURCE_HEIGHT_MIN,
>    400                                FIMC_ISP_SOURCE_HEIGHT_MAX, 0, 0);
>    401  }
>    402  
>    403  static int isp_video_try_fmt_mplane(struct file *file, void *fh,
>    404                                          struct v4l2_format *f)
>    405  {
>    406          struct fimc_isp *isp = video_drvdata(file);
>    407  
>    408          __isp_video_try_fmt(isp, &f->fmt.pix_mp, NULL);
>                                                          ^^^^
> And yet here we are.
> 
>    409          return 0;
>    410  }

We may need something like:

----8<----
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index 55ba696b8cf4..a920164f53f1 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -384,12 +384,17 @@ static void __isp_video_try_fmt(struct fimc_isp *isp,
                                struct v4l2_pix_format_mplane *pixm,
                                const struct fimc_fmt **fmt)
 {
-       *fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);
+       const struct fimc_fmt *__fmt;
+
+       __fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);
+
+       if (fmt)
+               *fmt = __fmt;
 
        pixm->colorspace = V4L2_COLORSPACE_SRGB;
        pixm->field = V4L2_FIELD_NONE;
-       pixm->num_planes = (*fmt)->memplanes;
-       pixm->pixelformat = (*fmt)->fourcc;
+       pixm->num_planes = __fmt->memplanes;
+       pixm->pixelformat = __fmt->fourcc;
        /*
         * TODO: double check with the docmentation these width/height
         * constraints are correct.
----8<----

I will post the patch to clear the warning.

-- 
Thanks,
Sylwester
