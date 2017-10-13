Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57436 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753231AbdJMMh6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 08:37:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 08/17] media: v4l2-ioctl.h: convert debug macros into enum and document
Date: Fri, 13 Oct 2017 15:38:11 +0300
Message-ID: <75398545.O2kI4imJ1e@avalon>
In-Reply-To: <2f79939abf6bfba034fcf46e0d92624df2ea5308.1506548682.git.mchehab@s-opensource.com>
References: <cover.1506548682.git.mchehab@s-opensource.com> <2f79939abf6bfba034fcf46e0d92624df2ea5308.1506548682.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thank you for the patch.

On Thursday, 28 September 2017 00:46:51 EEST Mauro Carvalho Chehab wrote:
> Currently, there's no way to document #define foo <value>
> with kernel-doc. So, convert it to an enum, and document.

The documentation seems fine to me (except for one comment below). However, 
converting macros to an enum just to work around a defect of the documentation 
system doesn't seem like a good idea to me. I'd rather find a way to document 
macros.

> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
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

s/BUFF/BUF.

A regexp would use VIDIOC_(Q|DQ)BUF. You can also write VIDIOC_{QBUF,DQBUF} 
which seems clearer to me.

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


-- 
Regards,

Laurent Pinchart
