Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750930AbeECLnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 07:43:13 -0400
Date: Thu, 3 May 2018 14:43:01 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: s.nawrocki@samsung.com
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: [bug report] [media] exynos4-is: Add the FIMC-IS ISP capture DMA
 driver
Message-ID: <20180503114301.GA7576@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[ This code is five years old now.  It's so weird to me that the warning
  is showing up in my new warnings pile.  Perhaps this wasn't included
  in my allmodconfig before?  - dan ]

Hello Sylwester Nawrocki,

The patch 34947b8aebe3: "[media] exynos4-is: Add the FIMC-IS ISP
capture DMA driver" from Dec 20, 2013, leads to the following static
checker warning:

	drivers/media/platform/exynos4-is/fimc-isp-video.c:408 isp_video_try_fmt_mplane()
	error: NULL dereference inside function '__isp_video_try_fmt(isp, &f->fmt.pix_mp, (0))()'.

drivers/media/platform/exynos4-is/fimc-isp-video.c
   383  static void __isp_video_try_fmt(struct fimc_isp *isp,
   384                                  struct v4l2_pix_format_mplane *pixm,
   385                                  const struct fimc_fmt **fmt)
   386  {
   387          *fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);
                ^^^^
Unchecked dereference.  We're not allowed to pass a NULL "fmt".

   388  
   389          pixm->colorspace = V4L2_COLORSPACE_SRGB;
   390          pixm->field = V4L2_FIELD_NONE;
   391          pixm->num_planes = (*fmt)->memplanes;
   392          pixm->pixelformat = (*fmt)->fourcc;
   393          /*
   394           * TODO: double check with the docmentation these width/height
   395           * constraints are correct.
   396           */
   397          v4l_bound_align_image(&pixm->width, FIMC_ISP_SOURCE_WIDTH_MIN,
   398                                FIMC_ISP_SOURCE_WIDTH_MAX, 3,
   399                                &pixm->height, FIMC_ISP_SOURCE_HEIGHT_MIN,
   400                                FIMC_ISP_SOURCE_HEIGHT_MAX, 0, 0);
   401  }
   402  
   403  static int isp_video_try_fmt_mplane(struct file *file, void *fh,
   404                                          struct v4l2_format *f)
   405  {
   406          struct fimc_isp *isp = video_drvdata(file);
   407  
   408          __isp_video_try_fmt(isp, &f->fmt.pix_mp, NULL);
                                                         ^^^^
And yet here we are.

   409          return 0;
   410  }

regards,
dan carpenter
