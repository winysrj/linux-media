Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40820 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2FRLOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 07:14:21 -0400
Received: from eusync4.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5T00K0F8KV7P80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jun 2012 12:14:55 +0100 (BST)
Received: from [106.116.48.223] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M5T009R58JT8820@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 18 Jun 2012 12:14:19 +0100 (BST)
Message-id: <4FDF0D88.2040801@samsung.com>
Date: Mon, 18 Jun 2012 13:14:16 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, airlied@redhat.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	hverkuil@xs4all.nl, remi@remlab.net, subashrp@gmail.com,
	mchehab@redhat.com, g.liakhovetski@gmx.de,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv7 01/15] v4l: Add DMABUF as a memory type
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
 <1339681069-8483-2-git-send-email-t.stanislaws@samsung.com>
In-reply-to: <1339681069-8483-2-git-send-email-t.stanislaws@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,
The automatic build system informed me that
there is a shameful error in this patch.

The declarations of fd fields in v4l2_plane32 and
v4l2_buffer32 are missing. It breaks build process
for 64-bit architectures. I am deeply sorry for
posting a patch without testing it enough.

The build-break will be fixed in the next version of
the patchset.

Regards,
Tomasz Stanislawski


On 06/14/2012 03:37 PM, Tomasz Stanislawski wrote:
> From: Sumit Semwal <sumit.semwal@ti.com>
> 
> Adds DMABUF memory type to v4l framework. Also adds the related file
> descriptor in v4l2_plane and v4l2_buffer.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>    [original work in the PoC for buffer sharing]
> Signed-off-by: Sumit Semwal <sumit.semwal@ti.com>
> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/v4l2-compat-ioctl32.c |   16 ++++++++++++++++
>  drivers/media/video/v4l2-ioctl.c          |    1 +
>  include/linux/videodev2.h                 |    7 +++++++
>  3 files changed, 24 insertions(+)
> 
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index 5327ad3..d33ab18 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -348,6 +348,9 @@ static int get_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
>  		up_pln = compat_ptr(p);
>  		if (put_user((unsigned long)up_pln, &up->m.userptr))
>  			return -EFAULT;
> +	} else if (memory == V4L2_MEMORY_DMABUF) {
> +		if (copy_in_user(&up->m.fd, &up32->m.fd, sizeof(int)))
> +			return -EFAULT;
>  	} else {
>  		if (copy_in_user(&up->m.mem_offset, &up32->m.mem_offset,
>  					sizeof(__u32)))
> @@ -371,6 +374,11 @@ static int put_v4l2_plane32(struct v4l2_plane *up, struct v4l2_plane32 *up32,
>  		if (copy_in_user(&up32->m.mem_offset, &up->m.mem_offset,
>  					sizeof(__u32)))
>  			return -EFAULT;
> +	/* For DMABUF, driver might've set up the fd, so copy it back. */
> +	if (memory == V4L2_MEMORY_DMABUF)
> +		if (copy_in_user(&up32->m.fd, &up->m.fd,
> +					sizeof(int)))
> +			return -EFAULT;
>  
>  	return 0;
>  }
> @@ -454,6 +462,10 @@ static int get_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  			if (get_user(kp->m.offset, &up->m.offset))
>  				return -EFAULT;
>  			break;
> +		case V4L2_MEMORY_DMABUF:
> +			if (get_user(kp->m.fd, &up->m.fd))
> +				return -EFAULT;
> +			break;
>  		}
>  	}
>  
> @@ -518,6 +530,10 @@ static int put_v4l2_buffer32(struct v4l2_buffer *kp, struct v4l2_buffer32 __user
>  			if (put_user(kp->m.offset, &up->m.offset))
>  				return -EFAULT;
>  			break;
> +		case V4L2_MEMORY_DMABUF:
> +			if (put_user(kp->m.fd, &up->m.fd))
> +				return -EFAULT;
> +			break;
>  		}
>  	}
>  
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 91be4e8..31fc2ad 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -175,6 +175,7 @@ static const char *v4l2_memory_names[] = {
>  	[V4L2_MEMORY_MMAP]    = "mmap",
>  	[V4L2_MEMORY_USERPTR] = "userptr",
>  	[V4L2_MEMORY_OVERLAY] = "overlay",
> +	[V4L2_MEMORY_DMABUF] = "dmabuf",
>  };
>  
>  #define prt_names(a, arr) ((((a) >= 0) && ((a) < ARRAY_SIZE(arr))) ? \
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 370d111..51b20f4 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -185,6 +185,7 @@ enum v4l2_memory {
>  	V4L2_MEMORY_MMAP             = 1,
>  	V4L2_MEMORY_USERPTR          = 2,
>  	V4L2_MEMORY_OVERLAY          = 3,
> +	V4L2_MEMORY_DMABUF           = 4,
>  };
>  
>  /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
> @@ -591,6 +592,8 @@ struct v4l2_requestbuffers {
>   *			should be passed to mmap() called on the video node)
>   * @userptr:		when memory is V4L2_MEMORY_USERPTR, a userspace pointer
>   *			pointing to this plane
> + * @fd:			when memory is V4L2_MEMORY_DMABUF, a userspace file
> + *			descriptor associated with this plane
>   * @data_offset:	offset in the plane to the start of data; usually 0,
>   *			unless there is a header in front of the data
>   *
> @@ -605,6 +608,7 @@ struct v4l2_plane {
>  	union {
>  		__u32		mem_offset;
>  		unsigned long	userptr;
> +		int		fd;
>  	} m;
>  	__u32			data_offset;
>  	__u32			reserved[11];
> @@ -629,6 +633,8 @@ struct v4l2_plane {
>   *		(or a "cookie" that should be passed to mmap() as offset)
>   * @userptr:	for non-multiplanar buffers with memory == V4L2_MEMORY_USERPTR;
>   *		a userspace pointer pointing to this buffer
> + * @fd:		for non-multiplanar buffers with memory == V4L2_MEMORY_DMABUF;
> + *		a userspace file descriptor associated with this buffer
>   * @planes:	for multiplanar buffers; userspace pointer to the array of plane
>   *		info structs for this buffer
>   * @length:	size in bytes of the buffer (NOT its payload) for single-plane
> @@ -655,6 +661,7 @@ struct v4l2_buffer {
>  		__u32           offset;
>  		unsigned long   userptr;
>  		struct v4l2_plane *planes;
> +		int		fd;
>  	} m;
>  	__u32			length;
>  	__u32			input;

