Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51830 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbaE3Xf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 May 2014 19:35:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L2: fix VIDIOC_CREATE_BUFS 32-bit compatibility mode data copy-back
Date: Sat, 31 May 2014 01:36:16 +0200
Message-ID: <1502861.x1mpGJtZG6@avalon>
In-Reply-To: <Pine.LNX.4.64.1405310125260.17582@axis700.grange>
References: <Pine.LNX.4.64.1405310125260.17582@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Saturday 31 May 2014 01:26:38 Guennadi Liakhovetski wrote:
> Similar to an earlier patch,

Could you please mention the commit ID in the commit message ?

> fixing reading user-space data for the
> VIDIOC_CREATE_BUFS ioctl() in 32-bit compatibility mode, this patch fixes
> writing back of the possibly modified struct to the user. However, unlike
> the former bug, this one is much less harmful, because it only results in
> the kernel failing to write the .type field back to the user, but in fact
> this is likely unneeded, because the kernel will hardly want to change
> that field. Therefore this bug is more of a theoretical nature.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
> Not tested yet, I'll (try not to forget to) test it next week.
> 
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index 7e2411c..c86a7e8
> 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -222,6 +222,9 @@ static int get_v4l2_create32(struct v4l2_create_buffers
> *kp, struct v4l2_create_
> 
>  static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32
> __user *up) {
> +	if (put_user(kp->type, &up->type))
> +		return -EFAULT;
> +
>  	switch (kp->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> @@ -248,8 +251,7 @@ static int __put_v4l2_format32(struct v4l2_format *kp,
> struct v4l2_format32 __us
> 
>  static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32
> __user *up) {
> -	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
> -		put_user(kp->type, &up->type))
> +	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)))
>  		return -EFAULT;
>  	return __put_v4l2_format32(kp, up);
>  }
> @@ -257,8 +259,8 @@ static int put_v4l2_format32(struct v4l2_format *kp,
> struct v4l2_format32 __user static int put_v4l2_create32(struct
> v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up) {
>  	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_create_buffers32)) ||
> -	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32,
> format.fmt)))
> -			return -EFAULT;
> +	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format)))
> +		return -EFAULT;
>  	return __put_v4l2_format32(&kp->format, &up->format);
>  }

-- 
Regards,

Laurent Pinchart

