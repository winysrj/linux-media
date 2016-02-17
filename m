Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:57957 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161157AbcBQLVh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 06:21:37 -0500
Subject: Re: [PATCH] [media] media/core: copy user v4l2_buffer.length in
 DMABUF case
To: Kevin Grandemange <grandemange.kevin@gmail.com>,
	linux-media@vger.kernel.org
References: <1455706043-7160-1-git-send-email-grandemange.kevin@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C457BA.6000202@xs4all.nl>
Date: Wed, 17 Feb 2016 12:21:30 +0100
MIME-Version: 1.0
In-Reply-To: <1455706043-7160-1-git-send-email-grandemange.kevin@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Has already been fixed.

But thanks anyway :-)

Regards,

	Hans

On 02/17/16 11:47, Kevin Grandemange wrote:
> in __qbuf_dmabuf, we check the dmabuf size against the plane size.
> 
> In the monoplanar case, this length was not copied from the userspace
> and we were getting a random value.
> 
> Signed-off-by: Kevin Grandemange <grandemange.kevin@gmail.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 8fd84a6..af0e01c 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -482,7 +482,8 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  				return -EFAULT;
>  			break;
>  		case V4L2_MEMORY_DMABUF:
> -			if (get_user(kp->m.fd, &up->m.fd))
> +			if (get_user(kp->length, &up->length) ||
> +			    get_user(kp->m.fd, &up->m.fd))
>  				return -EFAULT;
>  			break;
>  		}
> 
