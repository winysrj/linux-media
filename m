Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58608
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751722AbdF3LNI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Jun 2017 07:13:08 -0400
Date: Fri, 30 Jun 2017 08:12:58 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [PATCH 01/12] [media] vb2: add explicit fence user API
Message-ID: <20170630081258.1abb8e78@vento.lan>
In-Reply-To: <20170616073915.5027-2-gustavo@padovan.org>
References: <20170616073915.5027-1-gustavo@padovan.org>
        <20170616073915.5027-2-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 16 Jun 2017 16:39:04 +0900
Gustavo Padovan <gustavo@padovan.org> escreveu:

> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Turn the reserved2 field into fence_fd that we will use to send
> an in-fence to the kernel and return an out-fence from the kernel to
> userspace.
> 
> Two new flags were added, V4L2_BUF_FLAG_IN_FENCE, that should be used
> when sending a fence to the kernel to be waited on, and
> V4L2_BUF_FLAG_OUT_FENCE, to ask the kernel to give back an out-fence.
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 4 ++--
>  drivers/media/v4l2-core/videobuf2-v4l2.c      | 2 +-
>  include/uapi/linux/videodev2.h                | 4 +++-
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index 6f52970..8f6ab85 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -367,7 +367,7 @@ struct v4l2_buffer32 {
>  		__s32		fd;
>  	} m;
>  	__u32			length;
> -	__u32			reserved2;
> +	__s32			fence_fd;
>  	__u32			reserved;
>  };
>  
> @@ -530,7 +530,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
>  		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
>  		put_user(kp->sequence, &up->sequence) ||
> -		put_user(kp->reserved2, &up->reserved2) ||
> +		put_user(kp->fence_fd, &up->fence_fd) ||
>  		put_user(kp->reserved, &up->reserved) ||
>  		put_user(kp->length, &up->length))
>  			return -EFAULT;
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 0c06699..110fb45 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -203,7 +203,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	b->timestamp = ns_to_timeval(vb->timestamp);
>  	b->timecode = vbuf->timecode;
>  	b->sequence = vbuf->sequence;
> -	b->reserved2 = 0;
> +	b->fence_fd = -1;
>  	b->reserved = 0;
>  
>  	if (q->is_multiplanar) {
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 2b8feb8..750d511 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -916,7 +916,7 @@ struct v4l2_buffer {
>  		__s32		fd;
>  	} m;
>  	__u32			length;
> -	__u32			reserved2;
> +	__s32			fence_fd;
>  	__u32			reserved;
>  };
>  
> @@ -953,6 +953,8 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
>  /* mem2mem encoder/decoder */
>  #define V4L2_BUF_FLAG_LAST			0x00100000

> +#define V4L2_BUF_FLAG_IN_FENCE			0x00200000
> +#define V4L2_BUF_FLAG_OUT_FENCE			0x00400000

Please document them at Documentation/media/uapi/v4l/buffer.rst.

We'll also need a new chapter at the documentation, describing the
explicit fences mechanism.

>  
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor


-- 
Thanks,
Mauro
