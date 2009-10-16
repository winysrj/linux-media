Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:55690 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758574AbZJPMYm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 08:24:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: hvaibhav@ti.com
Subject: Re: [PATCH 1/4] V4L2: Added New V4L2 CIDs VIDIOC_S/G_COLOR_SPACE_CONV
Date: Fri, 16 Oct 2009 14:26:52 +0200
Cc: linux-media@vger.kernel.org
References: <hvaibhav@ti.com> <1255688360-6278-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1255688360-6278-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200910161426.52344.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Friday 16 October 2009 12:19:20 hvaibhav@ti.com wrote:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   19 +++++++++++++++++++
>  include/linux/videodev2.h        |   14 ++++++++++++++
>  include/media/v4l2-ioctl.h       |    4 ++++
>  3 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c
>  b/drivers/media/video/v4l2-ioctl.c index 30cc334..d3140e0 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -284,6 +284,8 @@ static const char *v4l2_ioctls[] = {
>  	[_IOC_NR(VIDIOC_DBG_G_CHIP_IDENT)] = "VIDIOC_DBG_G_CHIP_IDENT",
>  	[_IOC_NR(VIDIOC_S_HW_FREQ_SEEK)]   = "VIDIOC_S_HW_FREQ_SEEK",
>  #endif
> +	[_IOC_NR(VIDIOC_S_COLOR_SPACE_CONV)]   = "VIDIOC_S_COLOR_SPACE_CONV",
> +	[_IOC_NR(VIDIOC_G_COLOR_SPACE_CONV)]   = "VIDIOC_G_COLOR_SPACE_CONV",
>  };
>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>

This should go through a control, not an ioctl. Strings control have recently 
been introduced, it should be fairly easy to create binary controls for such 
cases.

-- 
Regards,

Laurent Pinchart
