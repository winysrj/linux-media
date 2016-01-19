Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:38038 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751786AbcASH75 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 02:59:57 -0500
Subject: Re: [PATCH v4] media: v4l2-compat-ioctl32: fix missing length copy in
 put_v4l2_buffer32
To: Tiffany Lin <tiffany.lin@mediatek.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1453190210-49347-1-git-send-email-tiffany.lin@mediatek.com>
Cc: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569DECF4.6020203@xs4all.nl>
Date: Tue, 19 Jan 2016 08:59:48 +0100
MIME-Version: 1.0
In-Reply-To: <1453190210-49347-1-git-send-email-tiffany.lin@mediatek.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2016 08:56 AM, Tiffany Lin wrote:
> In v4l2-compliance utility, test QUERYBUF required correct length
> value to go through each planar to check planar's length in
> multi-planar buffer type
> 
> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>

Looks good!

I'll merge this.

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 327e83a..f38c076 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -415,7 +415,8 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		get_user(kp->index, &up->index) ||
>  		get_user(kp->type, &up->type) ||
>  		get_user(kp->flags, &up->flags) ||
> -		get_user(kp->memory, &up->memory))
> +		get_user(kp->memory, &up->memory) ||
> +		get_user(kp->length, &up->length))
>  			return -EFAULT;
>  
>  	if (V4L2_TYPE_IS_OUTPUT(kp->type))
> @@ -427,9 +428,6 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  			return -EFAULT;
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
> -		if (get_user(kp->length, &up->length))
> -			return -EFAULT;
> -
>  		num_planes = kp->length;
>  		if (num_planes == 0) {
>  			kp->m.planes = NULL;
> @@ -462,16 +460,14 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  	} else {
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
> @@ -513,7 +509,8 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
>  		put_user(kp->sequence, &up->sequence) ||
>  		put_user(kp->reserved2, &up->reserved2) ||
> -		put_user(kp->reserved, &up->reserved))
> +		put_user(kp->reserved, &up->reserved) ||
> +		put_user(kp->length, &up->length))
>  			return -EFAULT;
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(kp->type)) {
> @@ -536,13 +533,11 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  	} else {
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
> 

