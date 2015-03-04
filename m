Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36444 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbbCDLSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 06:18:36 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKO004NMQ9S1G60@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Mar 2015 11:22:40 +0000 (GMT)
Message-id: <54F6E9FB.3010101@samsung.com>
Date: Wed, 04 Mar 2015 12:18:19 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/8] v4l2-subdev: replace v4l2_subdev_fh by
 v4l2_subdev_pad_config
References: <1425462481-8200-1-git-send-email-hverkuil@xs4all.nl>
 <1425462481-8200-2-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1425462481-8200-2-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/15 10:47, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> If a subdevice pad op is called from a bridge driver, then there is
> no v4l2_subdev_fh struct that can be passed to the subdevice. This
> made it hard to use such subdevs from a bridge driver.
> 
> This patch replaces the v4l2_subdev_fh pointer by a v4l2_subdev_pad_config
> pointer in the pad ops. This allows bridge drivers to use the various
> try_ pad ops by creating a v4l2_subdev_pad_config struct and passing it
> along to the pad op.
> 
> The v4l2_subdev_get_try_* macros had to be changed because of this, so
> I also took the opportunity to use the full name of the v4l2_subdev_get_try_*
> functions in the __V4L2_SUBDEV_MK_GET_TRY macro arguments: if you now do
> 'git grep v4l2_subdev_get_try_format' you will actually find the header
> where it is defined.
> 
> One remark regarding the drivers/staging/media/davinci_vpfe patches: the
> *_init_formats() functions assumed that fh could be NULL. However, that's
> not true for this driver, it's always set. This is almost certainly a copy
> and paste from the omap3isp driver. I've updated the code to reflect the
> fact that fh is never NULL.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

For:

>  drivers/media/i2c/m5mols/m5mols_core.c             | 16 ++---
>  drivers/media/i2c/noon010pc30.c                    | 17 ++---
>  drivers/media/i2c/ov9650.c                         | 16 ++---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 51 +++++++-------
>  drivers/media/i2c/s5k4ecgx.c                       | 16 ++---
>  drivers/media/i2c/s5k5baf.c                        | 38 +++++-----
>  drivers/media/i2c/s5k6a3.c                         | 18 ++---
>  drivers/media/i2c/s5k6aa.c                         | 34 ++++-----
>  drivers/media/platform/exynos4-is/fimc-capture.c   | 22 +++---
>  drivers/media/platform/exynos4-is/fimc-isp.c       | 28 ++++----
>  drivers/media/platform/exynos4-is/fimc-lite.c      | 33 ++++-----
>  drivers/media/platform/exynos4-is/mipi-csis.c      | 16 ++---
>  drivers/media/platform/s3c-camif/camif-capture.c   | 18 ++---
>  drivers/media/v4l2-core/v4l2-subdev.c              | 18 ++---
>  include/media/v4l2-subdev.h                        | 53 ++++++++------

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>


-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
