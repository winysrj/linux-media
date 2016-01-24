Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33598 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796AbcAYGVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 01:21:12 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v4] media: v4l2-compat-ioctl32: fix missing length copy in put_v4l2_buffer32
Date: Mon, 25 Jan 2016 00:10:12 +0200
Message-ID: <5599852.iRZxXXq57I@avalon>
In-Reply-To: <1453190210-49347-1-git-send-email-tiffany.lin@mediatek.com>
References: <1453190210-49347-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

Thank you for the patch.

On Tuesday 19 January 2016 15:56:50 Tiffany Lin wrote:
> In v4l2-compliance utility, test QUERYBUF required correct length
> value to go through each planar to check planar's length in
> multi-planar buffer type
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index 327e83a..f38c076
> 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -415,7 +415,8 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp,
> struct v4l2_buffer32 __user get_user(kp->index, &up->index) ||
>  		get_user(kp->type, &up->type) ||
>  		get_user(kp->flags, &up->flags) ||
> -		get_user(kp->memory, &up->memory))
> +		get_user(kp->memory, &up->memory) ||
> +		get_user(kp->length, &up->length))
>  			return -EFAULT;
> 
>  	if (V4L2_TYPE_IS_OUTPUT(kp->type))
> @@ -427,9 +428,6 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp,
> struct v4l2_buffer32 __user return -EFAULT;
> 
>  	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
> -		if (get_user(kp->length, &up->length))
> -			return -EFAULT;
> -
>  		num_planes = kp->length;
>  		if (num_planes == 0) {
>  			kp->m.planes = NULL;
> @@ -462,16 +460,14 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp,
> struct v4l2_buffer32 __user } else {
>  		switch (kp->memory) {
>  		case V4L2_MEMORY_MMAP:
> -			if (get_user(kp->length, &up->length) ||
> -				get_user(kp->m.offset, &up->m.offset))
> +			if (get_user(kp->m.offset, &up->m.offset))
>  				return -EFAULT;
>  			break;
>  		case V4L2_MEMORY_USERPTR:
>  			{
>  			compat_long_t tmp;
> 
> -			if (get_user(kp->length, &up->length) ||
> -			    get_user(tmp, &up->m.userptr))
> +			if (get_user(tmp, &up->m.userptr))
>  				return -EFAULT;
> 
>  			kp->m.userptr = (unsigned long)compat_ptr(tmp);
> @@ -513,7 +509,8 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp,
> struct v4l2_buffer32 __user copy_to_user(&up->timecode, &kp->timecode,
> sizeof(struct v4l2_timecode)) || put_user(kp->sequence, &up->sequence) ||
>  		put_user(kp->reserved2, &up->reserved2) ||
> -		put_user(kp->reserved, &up->reserved))
> +		put_user(kp->reserved, &up->reserved) ||
> +		put_user(kp->length, &up->length))
>  			return -EFAULT;
> 
>  	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
> @@ -536,13 +533,11 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp,
> struct v4l2_buffer32 __user } else {
>  		switch (kp->memory) {
>  		case V4L2_MEMORY_MMAP:
> -			if (put_user(kp->length, &up->length) ||
> -				put_user(kp->m.offset, &up->m.offset))
> +			if (put_user(kp->m.offset, &up->m.offset))
>  				return -EFAULT;
>  			break;
>  		case V4L2_MEMORY_USERPTR:
> -			if (put_user(kp->length, &up->length) ||
> -				put_user(kp->m.userptr, &up->m.userptr))
> +			if (put_user(kp->m.userptr, &up->m.userptr))
>  				return -EFAULT;
>  			break;
>  		case V4L2_MEMORY_OVERLAY:

-- 
Regards,

Laurent Pinchart

