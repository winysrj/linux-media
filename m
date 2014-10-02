Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16583 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaJBMQm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 08:16:42 -0400
Date: Thu, 2 Oct 2014 15:16:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: s.nawrocki@samsung.com
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: re: [media] exynos4-is: Add the FIMC-IS ISP capture DMA driver
Message-ID: <20141002121626.GA689@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sylwester Nawrocki,

The patch 34947b8aebe3: "[media] exynos4-is: Add the FIMC-IS ISP
capture DMA driver" from Dec 20, 2013, leads to the following static
checker warning:

	drivers/media/platform/exynos4-is/fimc-isp-video.c:413 isp_video_try_fmt_mplane()
	error: NULL dereference inside function.

drivers/media/platform/exynos4-is/fimc-isp-video.c
   388  static void __isp_video_try_fmt(struct fimc_isp *isp,
   389                                  struct v4l2_pix_format_mplane *pixm,
   390                                  const struct fimc_fmt **fmt)
   391  {
   392          *fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);

"fmt" isn't allowed to be NULL.

   393  
   394          pixm->colorspace = V4L2_COLORSPACE_SRGB;
   395          pixm->field = V4L2_FIELD_NONE;
   396          pixm->num_planes = (*fmt)->memplanes;
   397          pixm->pixelformat = (*fmt)->fourcc;
   398          /*
   399           * TODO: double check with the docmentation these width/height
   400           * constraints are correct.
   401           */
   402          v4l_bound_align_image(&pixm->width, FIMC_ISP_SOURCE_WIDTH_MIN,
   403                                FIMC_ISP_SOURCE_WIDTH_MAX, 3,
   404                                &pixm->height, FIMC_ISP_SOURCE_HEIGHT_MIN,
   405                                FIMC_ISP_SOURCE_HEIGHT_MAX, 0, 0);
   406  }
   407  
   408  static int isp_video_try_fmt_mplane(struct file *file, void *fh,
   409                                          struct v4l2_format *f)
   410  {
   411          struct fimc_isp *isp = video_drvdata(file);
   412  
   413          __isp_video_try_fmt(isp, &f->fmt.pix_mp, NULL);
                                                         ^^^^
NULL dereference here.

   414          return 0;
   415  }

regards,
dan carpenter
