Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30189 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbaEHNQh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 May 2014 09:16:37 -0400
Date: Thu, 8 May 2014 16:16:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: s.nawrocki@samsung.com
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Subject: re: [media] exynos4-is: Add the FIMC-IS ISP capture DMA driver
Message-ID: <20140508131620.GA7606@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sylwester Nawrocki,

The patch 34947b8aebe3: "[media] exynos4-is: Add the FIMC-IS ISP
capture DMA driver" from Dec 20, 2013, leads to the following static
checker warning:

	drivers/media/platform/exynos4-is/fimc-isp-video.c:415 isp_video_try_fmt_mplane()
	error: XXX NULL dereference inside function. '()' '0'

drivers/media/platform/exynos4-is/fimc-isp-video.c
   390  static void __isp_video_try_fmt(struct fimc_isp *isp,
   391                                  struct v4l2_pix_format_mplane *pixm,
   392                                  const struct fimc_fmt **fmt)
   393  {
   394          *fmt = fimc_isp_find_format(&pixm->pixelformat, NULL, 2);
   395  
   396          pixm->colorspace = V4L2_COLORSPACE_SRGB;
   397          pixm->field = V4L2_FIELD_NONE;
   398          pixm->num_planes = (*fmt)->memplanes;
   399          pixm->pixelformat = (*fmt)->fourcc;
   400          /*
   401           * TODO: double check with the docmentation these width/height
   402           * constraints are correct.
   403           */
   404          v4l_bound_align_image(&pixm->width, FIMC_ISP_SOURCE_WIDTH_MIN,
   405                                FIMC_ISP_SOURCE_WIDTH_MAX, 3,
   406                                &pixm->height, FIMC_ISP_SOURCE_HEIGHT_MIN,
   407                                FIMC_ISP_SOURCE_HEIGHT_MAX, 0, 0);
   408  }
   409  
   410  static int isp_video_try_fmt_mplane(struct file *file, void *fh,
   411                                          struct v4l2_format *f)
   412  {
   413          struct fimc_isp *isp = video_drvdata(file);
   414  
   415          __isp_video_try_fmt(isp, &f->fmt.pix_mp, NULL);
                                                         ^^^^
This will just NULL deref.  What was intended?

   416          return 0;
   417  }

regards,
dan carpenter
