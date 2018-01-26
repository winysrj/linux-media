Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40576 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751406AbeAZPUu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 10:20:50 -0500
Date: Fri, 26 Jan 2018 17:20:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 05/12] v4l2-compat-ioctl32.c: move 'helper' functions to
 __get/put_v4l2_format32
Message-ID: <20180126152047.qoelntpxjptuf32a@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-6-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126124327.16653-6-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jan 26, 2018 at 01:43:20PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> These helper functions do not really help. Move the code to the
> __get/put_v4l2_format32 functions.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 124 +++++---------------------
>  1 file changed, 24 insertions(+), 100 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 83066b21b0b2..2dd9b42d5859 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -92,92 +92,6 @@ static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
>  	return 0;
>  }
>  
> -static inline int get_v4l2_pix_format(struct v4l2_pix_format *kp, struct v4l2_pix_format __user *up)
> -{
> -	if (copy_from_user(kp, up, sizeof(struct v4l2_pix_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int get_v4l2_pix_format_mplane(struct v4l2_pix_format_mplane *kp,
> -					     struct v4l2_pix_format_mplane __user *up)
> -{
> -	if (copy_from_user(kp, up, sizeof(struct v4l2_pix_format_mplane)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int put_v4l2_pix_format(struct v4l2_pix_format *kp, struct v4l2_pix_format __user *up)
> -{
> -	if (copy_to_user(up, kp, sizeof(struct v4l2_pix_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int put_v4l2_pix_format_mplane(struct v4l2_pix_format_mplane *kp,
> -					     struct v4l2_pix_format_mplane __user *up)
> -{
> -	if (copy_to_user(up, kp, sizeof(struct v4l2_pix_format_mplane)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int get_v4l2_vbi_format(struct v4l2_vbi_format *kp, struct v4l2_vbi_format __user *up)
> -{
> -	if (copy_from_user(kp, up, sizeof(struct v4l2_vbi_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int put_v4l2_vbi_format(struct v4l2_vbi_format *kp, struct v4l2_vbi_format __user *up)
> -{
> -	if (copy_to_user(up, kp, sizeof(struct v4l2_vbi_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int get_v4l2_sliced_vbi_format(struct v4l2_sliced_vbi_format *kp, struct v4l2_sliced_vbi_format __user *up)
> -{
> -	if (copy_from_user(kp, up, sizeof(struct v4l2_sliced_vbi_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int put_v4l2_sliced_vbi_format(struct v4l2_sliced_vbi_format *kp, struct v4l2_sliced_vbi_format __user *up)
> -{
> -	if (copy_to_user(up, kp, sizeof(struct v4l2_sliced_vbi_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int get_v4l2_sdr_format(struct v4l2_sdr_format *kp, struct v4l2_sdr_format __user *up)
> -{
> -	if (copy_from_user(kp, up, sizeof(struct v4l2_sdr_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int put_v4l2_sdr_format(struct v4l2_sdr_format *kp, struct v4l2_sdr_format __user *up)
> -{
> -	if (copy_to_user(up, kp, sizeof(struct v4l2_sdr_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int get_v4l2_meta_format(struct v4l2_meta_format *kp, struct v4l2_meta_format __user *up)
> -{
> -	if (copy_from_user(kp, up, sizeof(struct v4l2_meta_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
> -static inline int put_v4l2_meta_format(struct v4l2_meta_format *kp, struct v4l2_meta_format __user *up)
> -{
> -	if (copy_to_user(up, kp, sizeof(struct v4l2_meta_format)))
> -		return -EFAULT;
> -	return 0;
> -}
> -
>  struct v4l2_format32 {
>  	__u32	type;	/* enum v4l2_buf_type */
>  	union {
> @@ -217,25 +131,30 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
>  	switch (kp->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		return get_v4l2_pix_format(&kp->fmt.pix, &up->fmt.pix);
> +		return copy_from_user(&kp->fmt.pix, &up->fmt.pix,
> +				      sizeof(kp->fmt.pix)) ? -EFAULT : 0;
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -		return get_v4l2_pix_format_mplane(&kp->fmt.pix_mp,
> -						  &up->fmt.pix_mp);
> +		return copy_from_user(&kp->fmt.pix_mp, &up->fmt.pix_mp,
> +				      sizeof(kp->fmt.pix_mp)) ? -EFAULT : 0;
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		return get_v4l2_window32(&kp->fmt.win, &up->fmt.win);
>  	case V4L2_BUF_TYPE_VBI_CAPTURE:
>  	case V4L2_BUF_TYPE_VBI_OUTPUT:
> -		return get_v4l2_vbi_format(&kp->fmt.vbi, &up->fmt.vbi);
> +		return copy_from_user(&kp->fmt.vbi, &up->fmt.vbi,
> +				      sizeof(kp->fmt.vbi)) ? -EFAULT : 0;
>  	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
>  	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> -		return get_v4l2_sliced_vbi_format(&kp->fmt.sliced, &up->fmt.sliced);
> +		return copy_from_user(&kp->fmt.sliced, &up->fmt.sliced,
> +				      sizeof(kp->fmt.sliced)) ? -EFAULT : 0;
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
> -		return get_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
> +		return copy_from_user(&kp->fmt.sdr, &up->fmt.sdr,
> +				      sizeof(kp->fmt.sdr)) ? -EFAULT : 0;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> -		return get_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
> +		return copy_from_user(&kp->fmt.meta, &up->fmt.meta,
> +				      sizeof(kp->fmt.meta)) ? -EFAULT : 0;
>  	default:
>  		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
>  			kp->type);
> @@ -266,25 +185,30 @@ static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
>  	switch (kp->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> -		return put_v4l2_pix_format(&kp->fmt.pix, &up->fmt.pix);
> +		return copy_to_user(&up->fmt.pix, &kp->fmt.pix,
> +				    sizeof(kp->fmt.pix)) ?  -EFAULT : 0;

Two spaces after "?". Same below. Just one would be nice.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> -		return put_v4l2_pix_format_mplane(&kp->fmt.pix_mp,
> -						  &up->fmt.pix_mp);
> +		return copy_to_user(&up->fmt.pix_mp, &kp->fmt.pix_mp,
> +				    sizeof(kp->fmt.pix_mp)) ?  -EFAULT : 0;
>  	case V4L2_BUF_TYPE_VIDEO_OVERLAY:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY:
>  		return put_v4l2_window32(&kp->fmt.win, &up->fmt.win);
>  	case V4L2_BUF_TYPE_VBI_CAPTURE:
>  	case V4L2_BUF_TYPE_VBI_OUTPUT:
> -		return put_v4l2_vbi_format(&kp->fmt.vbi, &up->fmt.vbi);
> +		return copy_to_user(&up->fmt.vbi, &kp->fmt.vbi,
> +				    sizeof(kp->fmt.vbi)) ?  -EFAULT : 0;
>  	case V4L2_BUF_TYPE_SLICED_VBI_CAPTURE:
>  	case V4L2_BUF_TYPE_SLICED_VBI_OUTPUT:
> -		return put_v4l2_sliced_vbi_format(&kp->fmt.sliced, &up->fmt.sliced);
> +		return copy_to_user(&up->fmt.sliced, &kp->fmt.sliced,
> +				    sizeof(kp->fmt.sliced)) ?  -EFAULT : 0;
>  	case V4L2_BUF_TYPE_SDR_CAPTURE:
>  	case V4L2_BUF_TYPE_SDR_OUTPUT:
> -		return put_v4l2_sdr_format(&kp->fmt.sdr, &up->fmt.sdr);
> +		return copy_to_user(&up->fmt.sdr, &kp->fmt.sdr,
> +				    sizeof(kp->fmt.sdr)) ?  -EFAULT : 0;
>  	case V4L2_BUF_TYPE_META_CAPTURE:
> -		return put_v4l2_meta_format(&kp->fmt.meta, &up->fmt.meta);
> +		return copy_to_user(&up->fmt.meta, &kp->fmt.meta,
> +				    sizeof(kp->fmt.meta)) ?  -EFAULT : 0;
>  	default:
>  		pr_info("compat_ioctl32: unexpected VIDIOC_FMT type %d\n",
>  			kp->type);

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
