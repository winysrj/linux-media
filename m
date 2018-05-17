Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:58305 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751047AbeEQIEj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 04:04:39 -0400
Subject: Re: [PATCH] v4l: Add support for STD ioctls on subdev nodes
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180517020057.14423-1-niklas.soderlund+renesas@ragnatech.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <26eb8720-f0a9-44f0-4f61-5bf3d1130493@xs4all.nl>
Date: Thu, 17 May 2018 10:04:35 +0200
MIME-Version: 1.0
In-Reply-To: <20180517020057.14423-1-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/05/18 04:00, Niklas Söderlund wrote:

Missing commit log.

> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  Documentation/media/uapi/v4l/vidioc-g-std.rst    | 14 ++++++++++----
>  Documentation/media/uapi/v4l/vidioc-querystd.rst | 11 +++++++----

What about ENUMSTD?

Regards,

	Hans

>  drivers/media/v4l2-core/v4l2-subdev.c            | 12 ++++++++++++
>  include/uapi/linux/v4l2-subdev.h                 |  3 +++
>  4 files changed, 32 insertions(+), 8 deletions(-)
> 
> ---
> 
> Hi Hans,
> 
> I have tested this on Renesas Gen3 Salvator-XS M3-N using the AFE 
> subdevice from the adv748x driver together with the R-Car VIN and CSI-2 
> pipeline.  
> 
> I wrote a prototype patch for v4l2-ctl which adds three new options 
> (--get-subdev-standard, --set-subdev-standard and 
> --get-subdev-detected-standard) to ease testing which I plan to submit 
> after some cleanup if this patch receives positive feedback.
> 
> If you or anyone else is interested in testing this patch the v4l2-utils 
> prototype patches are available at
> 
> git://git.ragnatech.se/v4l-utils#subdev-std
> 
> Regards,
> // Niklas
> 
> diff --git a/Documentation/media/uapi/v4l/vidioc-g-std.rst b/Documentation/media/uapi/v4l/vidioc-g-std.rst
> index 90791ab51a5371b8..8d94f0404df270db 100644
> --- a/Documentation/media/uapi/v4l/vidioc-g-std.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-g-std.rst
> @@ -2,14 +2,14 @@
>  
>  .. _VIDIOC_G_STD:
>  
> -********************************
> -ioctl VIDIOC_G_STD, VIDIOC_S_STD
> -********************************
> +**************************************************************************
> +ioctl VIDIOC_G_STD, VIDIOC_S_STD, VIDIOC_SUBDEV_G_STD, VIDIOC_SUBDEV_S_STD
> +**************************************************************************
>  
>  Name
>  ====
>  
> -VIDIOC_G_STD - VIDIOC_S_STD - Query or select the video standard of the current input
> +VIDIOC_G_STD - VIDIOC_S_STD - VIDIOC_SUBDEV_G_STD - VIDIOC_SUBDEV_S_STD - Query or select the video standard of the current input
>  
>  
>  Synopsis
> @@ -21,6 +21,12 @@ Synopsis
>  .. c:function:: int ioctl( int fd, VIDIOC_S_STD, const v4l2_std_id *argp )
>      :name: VIDIOC_S_STD
>  
> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_G_STD, v4l2_std_id *argp )
> +    :name: VIDIOC_SUBDEV_G_STD
> +
> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_S_STD, const v4l2_std_id *argp )
> +    :name: VIDIOC_SUBDEV_S_STD
> +
>  
>  Arguments
>  =========
> diff --git a/Documentation/media/uapi/v4l/vidioc-querystd.rst b/Documentation/media/uapi/v4l/vidioc-querystd.rst
> index cf40bca19b9f8665..a8385cc7481869dd 100644
> --- a/Documentation/media/uapi/v4l/vidioc-querystd.rst
> +++ b/Documentation/media/uapi/v4l/vidioc-querystd.rst
> @@ -2,14 +2,14 @@
>  
>  .. _VIDIOC_QUERYSTD:
>  
> -*********************
> -ioctl VIDIOC_QUERYSTD
> -*********************
> +*********************************************
> +ioctl VIDIOC_QUERYSTD, VIDIOC_SUBDEV_QUERYSTD
> +*********************************************
>  
>  Name
>  ====
>  
> -VIDIOC_QUERYSTD - Sense the video standard received by the current input
> +VIDIOC_QUERYSTD - VIDIOC_SUBDEV_QUERYSTD - Sense the video standard received by the current input
>  
>  
>  Synopsis
> @@ -18,6 +18,9 @@ Synopsis
>  .. c:function:: int ioctl( int fd, VIDIOC_QUERYSTD, v4l2_std_id *argp )
>      :name: VIDIOC_QUERYSTD
>  
> +.. c:function:: int ioctl( int fd, VIDIOC_SUBDEV_QUERYSTD, v4l2_std_id *argp )
> +    :name: VIDIOC_SUBDEV_QUERYSTD
> +
>  
>  Arguments
>  =========
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index f9eed938d3480b74..a156b1812e923721 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -494,6 +494,18 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  
>  	case VIDIOC_SUBDEV_S_DV_TIMINGS:
>  		return v4l2_subdev_call(sd, video, s_dv_timings, arg);
> +
> +	case VIDIOC_SUBDEV_G_STD:
> +		return v4l2_subdev_call(sd, video, g_std, arg);
> +
> +	case VIDIOC_SUBDEV_S_STD: {
> +		v4l2_std_id *std = arg;
> +
> +		return v4l2_subdev_call(sd, video, s_std, *std);
> +	}
> +
> +	case VIDIOC_SUBDEV_QUERYSTD:
> +		return v4l2_subdev_call(sd, video, querystd, arg);
>  #endif
>  	default:
>  		return v4l2_subdev_call(sd, core, ioctl, cmd, arg);
> diff --git a/include/uapi/linux/v4l2-subdev.h b/include/uapi/linux/v4l2-subdev.h
> index c95a53e6743cb040..133696a1f324ffdc 100644
> --- a/include/uapi/linux/v4l2-subdev.h
> +++ b/include/uapi/linux/v4l2-subdev.h
> @@ -170,8 +170,11 @@ struct v4l2_subdev_selection {
>  #define VIDIOC_SUBDEV_G_SELECTION		_IOWR('V', 61, struct v4l2_subdev_selection)
>  #define VIDIOC_SUBDEV_S_SELECTION		_IOWR('V', 62, struct v4l2_subdev_selection)
>  /* The following ioctls are identical to the ioctls in videodev2.h */
> +#define VIDIOC_SUBDEV_G_STD			_IOR('V', 23, v4l2_std_id)
> +#define VIDIOC_SUBDEV_S_STD			_IOW('V', 24, v4l2_std_id)
>  #define VIDIOC_SUBDEV_G_EDID			_IOWR('V', 40, struct v4l2_edid)
>  #define VIDIOC_SUBDEV_S_EDID			_IOWR('V', 41, struct v4l2_edid)
> +#define VIDIOC_SUBDEV_QUERYSTD			_IOR('V', 63, v4l2_std_id)
>  #define VIDIOC_SUBDEV_S_DV_TIMINGS		_IOWR('V', 87, struct v4l2_dv_timings)
>  #define VIDIOC_SUBDEV_G_DV_TIMINGS		_IOWR('V', 88, struct v4l2_dv_timings)
>  #define VIDIOC_SUBDEV_ENUM_DV_TIMINGS		_IOWR('V', 98, struct v4l2_enum_dv_timings)
> 
