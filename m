Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43304 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab2AXLHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 06:07:50 -0500
Received: by iacb35 with SMTP id b35so5221998iac.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 03:07:49 -0800 (PST)
Message-ID: <4F1E9100.90306@gmail.com>
Date: Tue, 24 Jan 2012 16:37:44 +0530
From: Subash Patel <subashrp@gmail.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	pawel@osciak.com, sumit.semwal@ti.com, jesse.barker@linaro.org,
	kyungmin.park@samsung.com, daniel@ffwll.ch
Subject: Re: [Linaro-mm-sig] [PATCH 05/10] v4l: add buffer exporting via dmabuf
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1327326675-8431-6-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Thomasz,

Instead of adding another IOCTL to query the file-descriptor in 
user-space, why dont we extend the existing ones in v4l2/vb2?

When the memory type set is V4L2_MEMORY_DMABUF, call to VIDIOC_REQBUFS 
/VIDIOC_QUERYBUF from driver can take/return the fd. We will need to add 
another attribute to struct v4l2_requestbuffers for this.

struct v4l2_requestbuffers {
	...
	__u32 buf_fd;
};

The application requesting buffer would set it to -1, and will receive 
the fd's when it calls the vb2_querybuf. In the same way, application 
which is trying to attach to already allocated buffer will set this to 
valid fd when it calls vidioc_reqbuf, and in vb2_reqbuf depending on the 
memory type, this can be checked and used to attach with the dma_buf for 
the respective buffer.

Ofcourse, this requires changes in vb2_reqbufs and vb2_querybuf similar 
to what you did in vb2_expbufs.

Will there be any issues in such an approach?

Regards,
Subash

On 01/23/2012 07:21 PM, Tomasz Stanislawski wrote:
> This patch adds extension to V4L2 api. It allow to export a mmap buffer as file
> descriptor. New ioctl VIDIOC_EXPBUF is added. It takes a buffer offset used by
> mmap and return a file descriptor on success.
>
> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> ---
>   drivers/media/video/v4l2-compat-ioctl32.c |    1 +
>   drivers/media/video/v4l2-ioctl.c          |   11 +++++++++++
>   include/linux/videodev2.h                 |    1 +
>   include/media/v4l2-ioctl.h                |    1 +
>   4 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index c68531b..0f18b5e 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -954,6 +954,7 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>   	case VIDIOC_S_FBUF32:
>   	case VIDIOC_OVERLAY32:
>   	case VIDIOC_QBUF32:
> +	case VIDIOC_EXPBUF:
>   	case VIDIOC_DQBUF32:
>   	case VIDIOC_STREAMON32:
>   	case VIDIOC_STREAMOFF32:
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index e1da8fc..cb29e00 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -207,6 +207,7 @@ static const char *v4l2_ioctls[] = {
>   	[_IOC_NR(VIDIOC_S_FBUF)]           = "VIDIOC_S_FBUF",
>   	[_IOC_NR(VIDIOC_OVERLAY)]          = "VIDIOC_OVERLAY",
>   	[_IOC_NR(VIDIOC_QBUF)]             = "VIDIOC_QBUF",
> +	[_IOC_NR(VIDIOC_EXPBUF)]           = "VIDIOC_EXPBUF",
>   	[_IOC_NR(VIDIOC_DQBUF)]            = "VIDIOC_DQBUF",
>   	[_IOC_NR(VIDIOC_STREAMON)]         = "VIDIOC_STREAMON",
>   	[_IOC_NR(VIDIOC_STREAMOFF)]        = "VIDIOC_STREAMOFF",
> @@ -932,6 +933,16 @@ static long __video_do_ioctl(struct file *file,
>   			dbgbuf(cmd, vfd, p);
>   		break;
>   	}
> +	case VIDIOC_EXPBUF:
> +	{
> +		unsigned int *p = arg;
> +
> +		if (!ops->vidioc_expbuf)
> +			break;
> +
> +		ret = ops->vidioc_expbuf(file, fh, *p);
> +		break;
> +	}
>   	case VIDIOC_DQBUF:
>   	{
>   		struct v4l2_buffer *p = arg;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 3c0ade1..448fbed 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -2183,6 +2183,7 @@ struct v4l2_create_buffers {
>   #define VIDIOC_S_FBUF		 _IOW('V', 11, struct v4l2_framebuffer)
>   #define VIDIOC_OVERLAY		 _IOW('V', 14, int)
>   #define VIDIOC_QBUF		_IOWR('V', 15, struct v4l2_buffer)
> +#define VIDIOC_EXPBUF		_IOWR('V', 16, __u32)
>   #define VIDIOC_DQBUF		_IOWR('V', 17, struct v4l2_buffer)
>   #define VIDIOC_STREAMON		 _IOW('V', 18, int)
>   #define VIDIOC_STREAMOFF	 _IOW('V', 19, int)
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index 4d1c74a..8201546 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -120,6 +120,7 @@ struct v4l2_ioctl_ops {
>   	int (*vidioc_reqbufs) (struct file *file, void *fh, struct v4l2_requestbuffers *b);
>   	int (*vidioc_querybuf)(struct file *file, void *fh, struct v4l2_buffer *b);
>   	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
> +	int (*vidioc_expbuf)  (struct file *file, void *fh, __u32 offset);
>   	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
>
>   	int (*vidioc_create_bufs)(struct file *file, void *fh, struct v4l2_create_buffers *b);
