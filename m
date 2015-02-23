Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49230 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbbBWQ14 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 11:27:56 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 1/7] v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
Date: Mon, 23 Feb 2015 18:28:56 +0200
Message-ID: <2510510.zPxjXIyMcj@avalon>
In-Reply-To: <1423827006-32878-2-git-send-email-hverkuil@xs4all.nl>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl> <1423827006-32878-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 13 February 2015 12:30:00 Hans Verkuil wrote:
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
> I also took the opportunity to use the full name of the
> v4l2_subdev_get_try_* functions in the __V4L2_SUBDEV_MK_GET_TRY macro
> arguments: if you now do 'git grep v4l2_subdev_get_try_format' you will
> actually find the header where it is defined.
> 
> One remark regarding the drivers/staging/media/davinci_vpfe patches: the
> *_init_formats() functions assumed that fh could be NULL. However, that's
> not true for this driver, it's always set. This is almost certainly a copy
> and paste from the omap3isp driver. I've updated the code to reflect the
> fact that fh is never NULL.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>

For the subdev core, the Aptina sensor drivers and the OMAP3 ISP, VSP1 and 
OMAP4 ISS drivers,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/adv7180.c                        | 10 +--
>  drivers/media/i2c/adv7511.c                        | 16 +++--
>  drivers/media/i2c/adv7604.c                        | 12 ++--
>  drivers/media/i2c/m5mols/m5mols_core.c             | 16 ++---
>  drivers/media/i2c/mt9m032.c                        | 34 ++++-----
>  drivers/media/i2c/mt9p031.c                        | 36 +++++-----
>  drivers/media/i2c/mt9t001.c                        | 36 +++++-----
>  drivers/media/i2c/mt9v032.c                        | 36 +++++-----
>  drivers/media/i2c/noon010pc30.c                    | 17 ++---
>  drivers/media/i2c/ov9650.c                         | 16 ++---
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 51 +++++++-------
>  drivers/media/i2c/s5k4ecgx.c                       | 16 ++---
>  drivers/media/i2c/s5k5baf.c                        | 38 +++++-----
>  drivers/media/i2c/s5k6a3.c                         | 18 ++---
>  drivers/media/i2c/s5k6aa.c                         | 34 ++++-----
>  drivers/media/i2c/smiapp/smiapp-core.c             | 80  +++++++++---------
>  drivers/media/i2c/tvp514x.c                        | 12 ++--
>  drivers/media/i2c/tvp7002.c                        | 14 ++--
>  drivers/media/platform/exynos4-is/fimc-capture.c   | 22 +++---
>  drivers/media/platform/exynos4-is/fimc-isp.c       | 28 ++++----
>  drivers/media/platform/exynos4-is/fimc-lite.c      | 33 ++++-----
>  drivers/media/platform/exynos4-is/mipi-csis.c      | 16 ++---
>  drivers/media/platform/omap3isp/ispccdc.c          | 82 ++++++++++---------
>  drivers/media/platform/omap3isp/ispccp2.c          | 44 ++++++------
>  drivers/media/platform/omap3isp/ispcsi2.c          | 40 +++++------
>  drivers/media/platform/omap3isp/isppreview.c       | 70 +++++++++---------
>  drivers/media/platform/omap3isp/ispresizer.c       | 78 ++++++++++---------
>  drivers/media/platform/s3c-camif/camif-capture.c   | 18 ++---
>  drivers/media/platform/vsp1/vsp1_bru.c             | 40 +++++------
>  drivers/media/platform/vsp1/vsp1_entity.c          | 16 ++---
>  drivers/media/platform/vsp1/vsp1_entity.h          |  4 +-
>  drivers/media/platform/vsp1/vsp1_hsit.c            | 16 ++---
>  drivers/media/platform/vsp1/vsp1_lif.c             | 18 ++---
>  drivers/media/platform/vsp1/vsp1_lut.c             | 18 ++---
>  drivers/media/platform/vsp1/vsp1_rwpf.c            | 36 +++++-----
>  drivers/media/platform/vsp1/vsp1_rwpf.h            | 12 ++--
>  drivers/media/platform/vsp1/vsp1_sru.c             | 26 +++----
>  drivers/media/platform/vsp1/vsp1_uds.c             | 26 +++----
>  drivers/media/v4l2-core/v4l2-subdev.c              | 18 ++---
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 49 +++++++------
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 47 ++++++-------
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    | 79  +++++++++---------
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c | 57 ++++++++-------
>  drivers/staging/media/omap4iss/iss_csi2.c          | 40 +++++------
>  drivers/staging/media/omap4iss/iss_ipipe.c         | 42 +++++------
>  drivers/staging/media/omap4iss/iss_ipipeif.c       | 48 ++++++-------
>  drivers/staging/media/omap4iss/iss_resizer.c       | 42 +++++------
>  include/media/v4l2-subdev.h                        | 50 +++++++------
>  48 files changed, 810 insertions(+), 797 deletions(-)

-- 
Regards,

Laurent Pinchart

