Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45324 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757463AbdJMPlg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 11:41:36 -0400
Subject: Re: [PATCH v2 08/17] media: v4l2-ioctl.h: convert debug macros into
 enum and document
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <cover.1506548682.git.mchehab@s-opensource.com>
 <2f79939abf6bfba034fcf46e0d92624df2ea5308.1506548682.git.mchehab@s-opensource.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3e677423-2b1f-83c9-afd5-f4c8991fe4de@xs4all.nl>
Date: Fri, 13 Oct 2017 17:41:30 +0200
MIME-Version: 1.0
In-Reply-To: <2f79939abf6bfba034fcf46e0d92624df2ea5308.1506548682.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/27/17 23:46, Mauro Carvalho Chehab wrote:
> Currently, there's no way to document #define foo <value>
> with kernel-doc. So, convert it to an enum, and document.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans

> ---
>  include/media/v4l2-ioctl.h | 33 +++++++++++++++++++--------------
>  1 file changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index bd5312118013..136e2cffcf9e 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -588,20 +588,25 @@ struct v4l2_ioctl_ops {
>  };
>  
>  
> -/* v4l debugging and diagnostics */
> -
> -/* Device debug flags to be used with the video device debug attribute */
> -
> -/* Just log the ioctl name + error code */
> -#define V4L2_DEV_DEBUG_IOCTL		0x01
> -/* Log the ioctl name arguments + error code */
> -#define V4L2_DEV_DEBUG_IOCTL_ARG	0x02
> -/* Log the file operations open, release, mmap and get_unmapped_area */
> -#define V4L2_DEV_DEBUG_FOP		0x04
> -/* Log the read and write file operations and the VIDIOC_(D)QBUF ioctls */
> -#define V4L2_DEV_DEBUG_STREAMING	0x08
> -/* Log poll() */
> -#define V4L2_DEV_DEBUG_POLL		0x10
> +/**
> + * enum v4l2_debug_flags - Device debug flags to be used with the video
> + *	device debug attribute
> + *
> + * @V4L2_DEV_DEBUG_IOCTL:	Just log the ioctl name + error code.
> + * @V4L2_DEV_DEBUG_IOCTL_ARG:	Log the ioctl name arguments + error code.
> + * @V4L2_DEV_DEBUG_FOP:		Log the file operations and open, release,
> + *				mmap and get_unmapped_area syscalls.
> + * @V4L2_DEV_DEBUG_STREAMING:	Log the read and write syscalls and
> + *				:c:ref:`VIDIOC_[Q|DQ]BUFF <VIDIOC_QBUF>` ioctls.
> + * @V4L2_DEV_DEBUG_POLL:	Log poll syscalls.
> + */
> +enum v4l2_debug_flags {
> +	V4L2_DEV_DEBUG_IOCTL		= 0x01,
> +	V4L2_DEV_DEBUG_IOCTL_ARG	= 0x02,
> +	V4L2_DEV_DEBUG_FOP		= 0x04,
> +	V4L2_DEV_DEBUG_STREAMING	= 0x08,
> +	V4L2_DEV_DEBUG_POLL		= 0x10,
> +};
>  
>  /*  Video standard functions  */
>  
> 
