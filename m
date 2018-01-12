Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:40059 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932705AbeALMQC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 12 Jan 2018 07:16:02 -0500
Subject: Re: [PATCH v7 3/6] [media] vb2: add explicit fence user API
To: Gustavo Padovan <gustavo@padovan.org>, linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
References: <20180110160732.7722-1-gustavo@padovan.org>
 <20180110160732.7722-4-gustavo@padovan.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a3fc1b74-f82b-c643-8a85-594ff95c9585@xs4all.nl>
Date: Fri, 12 Jan 2018 13:15:54 +0100
MIME-Version: 1.0
In-Reply-To: <20180110160732.7722-4-gustavo@padovan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/18 17:07, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Turn the reserved2 field into fence_fd that we will use to send
> an in-fence to the kernel and return an out-fence from the kernel to

s/and/or/

> userspace.
> 
> Two new flags were added, V4L2_BUF_FLAG_IN_FENCE, that should be used
> when sending a fence to the kernel to be waited on, and
> V4L2_BUF_FLAG_OUT_FENCE, to ask the kernel to give back an out-fence.
> 
> v5:
> 	- keep using reserved2 field for cpia2
> 	- set fence_fd to 0 for now, for compat with userspace(Mauro)
> 
> v4:
> 	- make it a union with reserved2 and fence_fd (Hans Verkuil)
> 
> v3:
> 	- make the out_fence refer to the current buffer (Hans Verkuil)
> 
> v2: add documentation
> 
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
> ---
>  Documentation/media/uapi/v4l/buffer.rst        | 15 +++++++++++++++
>  drivers/media/common/videobuf/videobuf2-v4l2.c |  2 +-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c  |  4 ++--
>  include/uapi/linux/videodev2.h                 |  7 ++++++-
>  4 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
> index ae6ee73f151c..eeefbd2547e7 100644
> --- a/Documentation/media/uapi/v4l/buffer.rst
> +++ b/Documentation/media/uapi/v4l/buffer.rst

I'm missing documentation for the new fence_fd field in struct v4l2_buffer.
Make sure to mention what value should be used if you don't set the IN_FENCE
flag.

> @@ -648,6 +648,21 @@ Buffer Flags
>        - Start Of Exposure. The buffer timestamp has been taken when the
>  	exposure of the frame has begun. This is only valid for the
>  	``V4L2_BUF_TYPE_VIDEO_CAPTURE`` buffer type.
> +    * .. _`V4L2-BUF-FLAG-IN-FENCE`:
> +
> +      - ``V4L2_BUF_FLAG_IN_FENCE``
> +      - 0x00200000
> +      - Ask V4L2 to wait on fence passed in ``fence_fd`` field. The buffer

s/fence/the fence/
s/in/in the/

> +	won't be queued to the driver until the fence signals.
> +
> +    * .. _`V4L2-BUF-FLAG-OUT-FENCE`:
> +
> +      - ``V4L2_BUF_FLAG_OUT_FENCE``
> +      - 0x00400000
> +      - Request a fence to be attached to the buffer. The ``fence_fd``

s/Request/Request for/

> +	field on

This very short line looks weird.

> +	:ref:`VIDIOC_QBUF` is used as a return argument to send the out-fence
> +	fd to userspace.

I'd rephrase this:

"The driver will fill in the out-fence fd in the ``fence_fd`` field when
:ref:`VIDIOC_QBUF` returns."

For both flags you also need to be explicit in mentioning that the application
sets these flags before calling VIDIOC_QBUF. For other ioctls the driver just
reports these flags.

Also mention what happens if the fence can't be found or can't be created.

Regards,

	Hans

>  
>  
>  
> diff --git a/drivers/media/common/videobuf/videobuf2-v4l2.c b/drivers/media/common/videobuf/videobuf2-v4l2.c
> index fac3cd6f901d..d838524a459e 100644
> --- a/drivers/media/common/videobuf/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf/videobuf2-v4l2.c
> @@ -203,7 +203,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	b->timestamp = ns_to_timeval(vb->timestamp);
>  	b->timecode = vbuf->timecode;
>  	b->sequence = vbuf->sequence;
> -	b->reserved2 = 0;
> +	b->fence_fd = 0;
>  	b->reserved = 0;
>  
>  	if (q->is_multiplanar) {
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index e48d59046086..a11a0a2bed47 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -370,7 +370,7 @@ struct v4l2_buffer32 {
>  		__s32		fd;
>  	} m;
>  	__u32			length;
> -	__u32			reserved2;
> +	__s32			fence_fd;
>  	__u32			reserved;
>  };
>  
> @@ -533,7 +533,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  		put_user(kp->timestamp.tv_usec, &up->timestamp.tv_usec) ||
>  		copy_to_user(&up->timecode, &kp->timecode, sizeof(struct v4l2_timecode)) ||
>  		put_user(kp->sequence, &up->sequence) ||
> -		put_user(kp->reserved2, &up->reserved2) ||
> +		put_user(kp->fence_fd, &up->fence_fd) ||
>  		put_user(kp->reserved, &up->reserved) ||
>  		put_user(kp->length, &up->length))
>  			return -EFAULT;
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 58894cfe9479..2d424aebdd1e 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -933,7 +933,10 @@ struct v4l2_buffer {
>  		__s32		fd;
>  	} m;
>  	__u32			length;
> -	__u32			reserved2;
> +	union {
> +		__s32		fence_fd;
> +		__u32		reserved2;
> +	};
>  	__u32			reserved;
>  };
>  
> @@ -970,6 +973,8 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
>  /* mem2mem encoder/decoder */
>  #define V4L2_BUF_FLAG_LAST			0x00100000
> +#define V4L2_BUF_FLAG_IN_FENCE			0x00200000
> +#define V4L2_BUF_FLAG_OUT_FENCE			0x00400000
>  
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor
> 
