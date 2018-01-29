Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36184 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751169AbeA2Jrp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 04:47:45 -0500
Date: Mon, 29 Jan 2018 11:47:42 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 09/12] v4l2-compat-ioctl32.c: copy clip list in
 put_v4l2_window32
Message-ID: <20180129094742.x7rofwpgr4yke37h@valkosipuli.retiisi.org.uk>
References: <20180126124327.16653-1-hverkuil@xs4all.nl>
 <20180126124327.16653-10-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180126124327.16653-10-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, Jan 26, 2018 at 01:43:24PM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> put_v4l2_window32() didn't copy back the clip list to userspace.
> Drivers can update the clip rectangles, so this should be done.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 58 ++++++++++++++++++---------
>  1 file changed, 39 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index cf3d4bfcd132..6e3fbbde2c9c 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -50,6 +50,11 @@ struct v4l2_window32 {
>  
>  static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
>  {
> +	struct v4l2_clip32 __user *uclips;
> +	struct v4l2_clip __user *kclips;
> +	compat_caddr_t p;
> +	u32 n;
> +
>  	if (!access_ok(VERIFY_READ, up, sizeof(*up)) ||
>  	    copy_from_user(&kp->w, &up->w, sizeof(up->w)) ||
>  	    get_user(kp->field, &up->field) ||
> @@ -59,38 +64,53 @@ static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
>  		return -EFAULT;
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
>  static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
>  {
> +	struct v4l2_clip __user *kclips = kp->clips;
> +	struct v4l2_clip32 __user *uclips;
> +	int n = kp->clipcount;

u32

> +	compat_caddr_t p;
> +
>  	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
>  	    put_user(kp->field, &up->field) ||
>  	    put_user(kp->chromakey, &up->chromakey) ||
>  	    put_user(kp->clipcount, &up->clipcount) ||
>  	    put_user(kp->global_alpha, &up->global_alpha))
>  		return -EFAULT;

One more newline here?

> +	if (!kp->clipcount)
> +		return 0;
> +
> +	if (get_user(p, &up->clips))
> +		return -EFAULT;
> +	uclips = compat_ptr(p);
> +	while (n--) {
> +		if (copy_in_user(&uclips->c, &kclips->c, sizeof(uclips->c)))
> +			return -EFAULT;
> +		uclips++;
> +		kclips++;
> +	}
>  	return 0;
>  }
>  

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
