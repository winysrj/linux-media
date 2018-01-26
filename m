Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41196 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752519AbeAZQPW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 11:15:22 -0500
Date: Fri, 26 Jan 2018 18:15:18 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 07/12] v4l2-compat-ioctl32.c: copy m.userptr in
 put_v4l2_plane32
Message-ID: <20180126161518.t4wuuuotoikpzrnz@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-8-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126124327.16653-8-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jan 26, 2018 at 01:43:22PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The struct v4l2_plane32 should set m.userptr as well. The same
> happens in v4l2_buffer32 and v4l2-compliance tests for this.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 47 ++++++++++++++++-----------
>  1 file changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 809448d1b7db..da8a56818a18 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -310,19 +310,24 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
>  			 sizeof(up->data_offset)))
>  		return -EFAULT;
>  
> -	if (memory == V4L2_MEMORY_USERPTR) {
> +	switch (memory) {
> +	case V4L2_MEMORY_MMAP:
> +	case V4L2_MEMORY_OVERLAY:
> +		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
> +				 sizeof(up32->m.mem_offset)))
> +			return -EFAULT;
> +		break;
> +	case V4L2_MEMORY_USERPTR:
>  		if (get_user(p, &up32->m.userptr))
>  			return -EFAULT;
>  		up_pln = compat_ptr(p);
>  		if (put_user((unsigned long)up_pln, &up->m.userptr))
>  			return -EFAULT;
> -	} else if (memory == V4L2_MEMORY_DMABUF) {
> +		break;
> +	case V4L2_MEMORY_DMABUF:
>  		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(up32->m.fd)))
>  			return -EFAULT;
> -	} else {
> -		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
> -				 sizeof(up32->m.mem_offset)))
> -			return -EFAULT;
> +		break;
>  	}
>  
>  	return 0;
> @@ -331,22 +336,32 @@ static int get_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __
>  static int put_v4l2_plane32(struct v4l2_plane __user *up, struct v4l2_plane32 __user *up32,
>  			    enum v4l2_memory memory)
>  {
> +	unsigned long p;
> +
>  	if (copy_in_user(up32, up, 2 * sizeof(__u32)) ||
>  	    copy_in_user(&up32->data_offset, &up->data_offset,
>  			 sizeof(up->data_offset)))
>  		return -EFAULT;
>  
> -	/* For MMAP, driver might've set up the offset, so copy it back.
> -	 * USERPTR stays the same (was userspace-provided), so no copying. */
> -	if (memory == V4L2_MEMORY_MMAP)
> +	switch (memory) {
> +	case V4L2_MEMORY_MMAP:
> +	case V4L2_MEMORY_OVERLAY:
>  		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
>  				 sizeof(up->m.mem_offset)))
>  			return -EFAULT;
> -	/* For DMABUF, driver might've set up the fd, so copy it back. */
> -	if (memory == V4L2_MEMORY_DMABUF)
> +		break;
> +	case V4L2_MEMORY_USERPTR:
> +		if (get_user(p, &up->m.userptr) ||
> +		    put_user((compat_long_t)ptr_to_compat((__force void *)p),

compat_ulong_t instead of compat_long_t?

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +			     &up32->m.userptr))
> +			return -EFAULT;
> +		break;
> +	case V4L2_MEMORY_DMABUF:
>  		if (copy_in_user(&up32->m.fd, &up->m.fd,
>  				 sizeof(up->m.fd)))
>  			return -EFAULT;
> +		break;
> +	}
>  
>  	return 0;
>  }
> @@ -408,6 +423,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  	} else {
>  		switch (kp->memory) {
>  		case V4L2_MEMORY_MMAP:
> +		case V4L2_MEMORY_OVERLAY:
>  			if (get_user(kp->m.offset, &up->m.offset))
>  				return -EFAULT;
>  			break;
> @@ -421,10 +437,6 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  				kp->m.userptr = (unsigned long)compat_ptr(tmp);
>  			}
>  			break;
> -		case V4L2_MEMORY_OVERLAY:
> -			if (get_user(kp->m.offset, &up->m.offset))
> -				return -EFAULT;
> -			break;
>  		case V4L2_MEMORY_DMABUF:
>  			if (get_user(kp->m.fd, &up->m.fd))
>  				return -EFAULT;
> @@ -481,6 +493,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  	} else {
>  		switch (kp->memory) {
>  		case V4L2_MEMORY_MMAP:
> +		case V4L2_MEMORY_OVERLAY:
>  			if (put_user(kp->m.offset, &up->m.offset))
>  				return -EFAULT;
>  			break;
> @@ -488,10 +501,6 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  			if (put_user(kp->m.userptr, &up->m.userptr))
>  				return -EFAULT;
>  			break;
> -		case V4L2_MEMORY_OVERLAY:
> -			if (put_user(kp->m.offset, &up->m.offset))
> -				return -EFAULT;
> -			break;
>  		case V4L2_MEMORY_DMABUF:
>  			if (put_user(kp->m.fd, &up->m.fd))
>  				return -EFAULT;
> -- 
> 2.15.1
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
