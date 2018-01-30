Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45374 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752773AbeA3O2D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 09:28:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: Re: [PATCHv2 10/13] v4l2-compat-ioctl32.c: copy clip list in put_v4l2_window32
Date: Tue, 30 Jan 2018 16:28:17 +0200
Message-ID: <4863902.8Pkeng1b4R@avalon>
In-Reply-To: <20180130102701.13664-11-hverkuil@xs4all.nl>
References: <20180130102701.13664-1-hverkuil@xs4all.nl> <20180130102701.13664-11-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Tuesday, 30 January 2018 12:26:58 EET Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> put_v4l2_window32() didn't copy back the clip list to userspace.
> Drivers can update the clip rectangles, so this should be done.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: <stable@vger.kernel.org>      # for v4.15 and up
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 59
> ++++++++++++++++++--------- 1 file changed, 40 insertions(+), 19
> deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index
> 30c5be1f0549..0df941ca4d90 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -50,6 +50,11 @@ struct v4l2_window32 {
> 
>  static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32
> __user *up) {
> +	struct v4l2_clip32 __user *uclips;
> +	struct v4l2_clip __user *kclips;
> +	compat_caddr_t p;
> +	u32 n;
> +
>  	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
>  	    copy_from_user(&kp->w, &up->w, sizeof(up->w)) ||
>  	    get_user(kp->field, &up->field) ||
> @@ -59,38 +64,54 @@ static int get_v4l2_window32(struct v4l2_window *kp,
> struct v4l2_window32 __user return -EFAULT;
>  	if (kp->clipcount > 2048)
>  		return -EINVAL;
> -	if (kp->clipcount) {
> -		struct v4l2_clip32 __user *uclips;
> -		struct v4l2_clip __user *kclips;
> -		int n = kp->clipcount;
> -		compat_caddr_t p;
> +	if (!kp->clipcount) {
> +		kp->clips = NULL;
> +		return 0;
> +	}
> 
> -		if (get_user(p, &up->clips))
> +	n = kp->clipcount;
> +	if (get_user(p, &up->clips))
> +		return -EFAULT;
> +	uclips = compat_ptr(p);
> +	kclips = compat_alloc_user_space(n * sizeof(*kclips));
> +	kp->clips = kclips;
> +	while (n--) {
> +		if (copy_in_user(&kclips->c, &uclips->c, sizeof(uclips->c)))
>  			return -EFAULT;
> -		uclips = compat_ptr(p);
> -		kclips = compat_alloc_user_space(n * sizeof(*kclips));
> -		kp->clips = kclips;
> -		while (--n >= 0) {
> -			if (copy_in_user(&kclips->c, &uclips->c, sizeof(uclips->c)))
> -				return -EFAULT;
> -			if (put_user(n ? kclips + 1 : NULL, &kclips->next))
> -				return -EFAULT;
> -			uclips += 1;
> -			kclips += 1;
> -		}
> -	} else
> -		kp->clips = NULL;
> +		if (put_user(n ? kclips + 1 : NULL, &kclips->next))
> +			return -EFAULT;
> +		uclips++;
> +		kclips++;
> +	}
>  	return 0;
>  }
> 
>  static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32
> __user *up) {
> +	struct v4l2_clip __user *kclips = kp->clips;
> +	struct v4l2_clip32 __user *uclips;
> +	u32 n = kp->clipcount;
> +	compat_caddr_t p;
> +
>  	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
>  	    put_user(kp->field, &up->field) ||
>  	    put_user(kp->chromakey, &up->chromakey) ||
>  	    put_user(kp->clipcount, &up->clipcount) ||
>  	    put_user(kp->global_alpha, &up->global_alpha))
>  		return -EFAULT;
> +
> +	if (!kp->clipcount)
> +		return 0;
> +
> +	if (get_user(p, &up->clips))
> +		return -EFAULT;
> +	uclips = compat_ptr(p);

This is compat code so I don't care too much, but it would be more readable if 
you assigned both kclips and uclips here instead of assigning kclips at the 
beginning of the function.

> +	while (n--) {

Similarly a for loop would be easier to read.

> +		if (copy_in_user(&uclips->c, &kclips->c, sizeof(uclips->c)))
> +			return -EFAULT;
> +		uclips++;
> +		kclips++;
> +	}
>  	return 0;
>  }

-- 
Regards,

Laurent Pinchart
