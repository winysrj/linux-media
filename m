Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39093 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1HZO5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Aug 2011 10:57:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 1/5] [media] v4l: add support for selection api
Date: Fri, 26 Aug 2011 16:57:55 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
References: <1314363967-6448-1-git-send-email-t.stanislaws@samsung.com> <1314363967-6448-2-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1314363967-6448-2-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108261657.55635.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Friday 26 August 2011 15:06:03 Tomasz Stanislawski wrote:
> This patch introduces new api for a precise control of cropping and
> composing features for video devices. The new ioctls are
> VIDIOC_S_SELECTION and VIDIOC_G_SELECTION.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-compat-ioctl32.c |    2 ++
>  drivers/media/video/v4l2-ioctl.c          |   28
> ++++++++++++++++++++++++++++ include/linux/videodev2.h                 |  
> 27 +++++++++++++++++++++++++++ include/media/v4l2-ioctl.h                |
>    4 ++++
>  4 files changed, 61 insertions(+), 0 deletions(-)

[snip]

> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index fca24cc..fad4fb3 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -738,6 +738,29 @@ struct v4l2_crop {
>  	struct v4l2_rect        c;
>  };
> 
> +/* Hints for adjustments of selection rectangle */
> +#define V4L2_SEL_SIZE_GE	0x00000001
> +#define V4L2_SEL_SIZE_LE	0x00000002
> +
> +enum v4l2_sel_target {
> +	V4L2_SEL_CROP_ACTIVE  = 0,
> +	V4L2_SEL_CROP_DEFAULT = 1,
> +	V4L2_SEL_CROP_BOUNDS  = 2,
> +	V4L2_SEL_COMPOSE_ACTIVE  = 256 + 0,
> +	V4L2_SEL_COMPOSE_DEFAULT = 256 + 1,
> +	V4L2_SEL_COMPOSE_BOUNDS  = 256 + 2,
> +	V4L2_SEL_COMPOSE_PADDED  = 256 + 3,
> +};
> +
> +struct v4l2_selection {
> +	enum v4l2_buf_type      type;
> +	enum v4l2_sel_target	target;

You should avoid using enums in public APIs, as their size will depend on the 
ABI version on some platforms.

> +	__u32                   flags;
> +	struct v4l2_rect        r;
> +	__u32                   reserved[9];
> +};
> +
> +
>  /*
>   *      A N A L O G   V I D E O   S T A N D A R D
>   */

-- 
Regards,

Laurent Pinchart
