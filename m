Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52957 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaCGOCm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 09:02:42 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, marbugge@cisco.com,
	Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: Re: [REVIEWv1 PATCH 1/5] v4l2-compat-ioctl32: fix wrong VIDIOC_SUBDEV_G/S_EDID32 support.
Date: Fri, 07 Mar 2014 15:04:13 +0100
Message-ID: <60619351.pvxbuytH99@avalon>
In-Reply-To: <1394187679-7345-2-git-send-email-hverkuil@xs4all.nl>
References: <1394187679-7345-1-git-send-email-hverkuil@xs4all.nl> <1394187679-7345-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 07 March 2014 11:21:15 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The wrong ioctl numbers were used due to a copy-and-paste error.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: stable@vger.kernel.org      # for v3.7 and up

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index 1b18616..7e23e19
> 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -787,8 +787,8 @@ static int put_v4l2_subdev_edid32(struct
> v4l2_subdev_edid *kp, struct v4l2_subde #define VIDIOC_DQBUF32		
_IOWR('V',
> 17, struct v4l2_buffer32)
>  #define VIDIOC_ENUMSTD32	_IOWR('V', 25, struct v4l2_standard32)
>  #define VIDIOC_ENUMINPUT32	_IOWR('V', 26, struct v4l2_input32)
> -#define VIDIOC_SUBDEV_G_EDID32	_IOWR('V', 63, struct v4l2_subdev_edid32)
> -#define VIDIOC_SUBDEV_S_EDID32	_IOWR('V', 64, struct v4l2_subdev_edid32)
> +#define VIDIOC_SUBDEV_G_EDID32	_IOWR('V', 40, struct v4l2_subdev_edid32)
> +#define VIDIOC_SUBDEV_S_EDID32	_IOWR('V', 41, struct v4l2_subdev_edid32)
>  #define VIDIOC_TRY_FMT32      	_IOWR('V', 64, struct v4l2_format32)
>  #define VIDIOC_G_EXT_CTRLS32    _IOWR('V', 71, struct v4l2_ext_controls32)
>  #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)

-- 
Regards,

Laurent Pinchart
