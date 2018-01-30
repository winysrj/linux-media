Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50594 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751411AbeA3LqX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 06:46:23 -0500
Date: Tue, 30 Jan 2018 13:46:20 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2 13/13] v4l2-compat-ioctl32.c: refactor, fix security
 bug in compat ioctl32
Message-ID: <20180130114619.v55lvnto3wxnhygt@valkosipuli.retiisi.org.uk>
References: <20180130102701.13664-1-hverkuil@xs4all.nl>
 <20180130102701.13664-14-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180130102701.13664-14-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the update. Please see a few additional comments below.

On Tue, Jan 30, 2018 at 11:27:01AM +0100, Hans Verkuil wrote:
...
> @@ -891,30 +1057,53 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_STREAMOFF:
>  	case VIDIOC_S_INPUT:
>  	case VIDIOC_S_OUTPUT:
> -		err = get_user(karg.vi, (s32 __user *)up);
> +		err = alloc_userspace(sizeof(unsigned int), 0, &up_native);
> +		if (!err && assign_in_user((unsigned int __user *)up_native,
> +					   (compat_uint_t __user *)up))
> +			err = -EFAULT;
>  		compatible_arg = 0;
>  		break;
>  
>  	case VIDIOC_G_INPUT:
>  	case VIDIOC_G_OUTPUT:
> +		err = alloc_userspace(sizeof(unsigned int), 0,
> +				      &up_native);

Fits on a single line.

>  		compatible_arg = 0;
>  		break;
>  
>  	case VIDIOC_G_EDID:
>  	case VIDIOC_S_EDID:
> -		err = get_v4l2_edid32(&karg.v2edid, up);
> +		err = alloc_userspace(sizeof(struct v4l2_edid), 0, &up_native);
> +		if (!err)
> +			err = get_v4l2_edid32(up_native, up);
>  		compatible_arg = 0;
>  		break;
>  
>  	case VIDIOC_G_FMT:
>  	case VIDIOC_S_FMT:
>  	case VIDIOC_TRY_FMT:
> -		err = get_v4l2_format32(&karg.v2f, up);
> +		err = bufsize_v4l2_format(up, &aux_space);
> +		if (!err)
> +			err = alloc_userspace(sizeof(struct v4l2_format),
> +					      aux_space, &up_native);
> +		if (!err) {
> +			aux_buf = up_native + sizeof(struct v4l2_format);
> +			err = get_v4l2_format32(up_native, up,
> +						aux_buf, aux_space);
> +		}
>  		compatible_arg = 0;
>  		break;
>  
>  	case VIDIOC_CREATE_BUFS:
> -		err = get_v4l2_create32(&karg.v2crt, up);
> +		err = bufsize_v4l2_create(up, &aux_space);
> +		if (!err)
> +			err = alloc_userspace(sizeof(struct v4l2_create_buffers),
> +					    aux_space, &up_native);
> +		if (!err) {
> +			aux_buf = up_native + sizeof(struct v4l2_create_buffers);

A few lines over 80 characters. It's not a lot but I see no reason to avoid
wrapping them either.

> +			err = get_v4l2_create32(up_native, up,
> +						aux_buf, aux_space);
> +		}
>  		compatible_arg = 0;
>  		break;
>  

The above can be addressed later, right now this isn't a priority.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
