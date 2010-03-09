Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab0CIPD1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 10:03:27 -0500
Message-ID: <4B966335.5060101@redhat.com>
Date: Tue, 09 Mar 2010 12:03:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl
Subject: Re: [PATCH v2 1/3] v4l: Add support for multi-plane buffers to V4L2
 API.
References: <1268146183-2018-1-git-send-email-p.osciak@samsung.com> <1268146183-2018-2-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1268146183-2018-2-git-send-email-p.osciak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pawel Osciak wrote:
> Current V4L2 API assumes that each video buffer contains exactly one,
> contiguous memory buffer for video data. Even in case of planar video
> formats, e.g. YCbCr with each component residing in a separate area
> of memory, it is specified that each of those planes immediately follows
> the previous one in memory.
> 
> There exist hardware video devices that handle, or even require, each of
> the planes to reside in a separate, arbitrary memory area. Some even
> require different planes to be placed in different, physical memory banks.
> 
> This patch introduces a backward-compatible extension of V4L2 API, which
> allows passing additional, per-plane info in the video buffer structure.
> 
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>
> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |   97 ++++++++++++++++++++++++++-----------
>  include/linux/videodev2.h        |   33 ++++++++++++-
>  2 files changed, 99 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 4b11257..b89b73f 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -172,6 +172,8 @@ static const char *v4l2_memory_names[] = {
>  	[V4L2_MEMORY_MMAP]    = "mmap",
>  	[V4L2_MEMORY_USERPTR] = "userptr",
>  	[V4L2_MEMORY_OVERLAY] = "overlay",
> +	[V4L2_MEMORY_MULTI_USERPTR]	= "multi-userptr",
> +	[V4L2_MEMORY_MULTI_MMAP]	= "multi-mmap",
>  };
>  
>  #define prt_names(a, arr) ((((a) >= 0) && ((a) < ARRAY_SIZE(arr))) ? \
> @@ -1975,7 +1977,7 @@ static unsigned long cmd_input_size(unsigned int cmd)
>  	switch (cmd) {
>  		CMDINSIZE(ENUM_FMT,		fmtdesc,	type);
>  		CMDINSIZE(G_FMT,		format,		type);
> -		CMDINSIZE(QUERYBUF,		buffer,		type);
> +		CMDINSIZE(QUERYBUF,		buffer,		length);
>  		CMDINSIZE(G_PARM,		streamparm,	type);
>  		CMDINSIZE(ENUMSTD,		standard,	index);
>  		CMDINSIZE(ENUMINPUT,		input,		index);
> @@ -2000,6 +2002,46 @@ static unsigned long cmd_input_size(unsigned int cmd)
>  	}
>  }
>  
> +static int check_array_args(unsigned int cmd, void *parg, size_t *array_size,
> +			    void * __user *user_ptr, void ***kernel_ptr)
> +{
> +	int ret = 0;
> +
> +	switch(cmd) {
> +	case VIDIOC_QUERYBUF:
> +	case VIDIOC_QBUF:
> +	case VIDIOC_DQBUF: {
> +		struct v4l2_buffer *buf = parg;
> +
> +		if ((buf->memory == V4L2_MEMORY_MULTI_USERPTR
> +		     || buf->memory == V4L2_MEMORY_MULTI_MMAP)) {
> +			*user_ptr = (void __user *)buf->m.planes;
> +			*kernel_ptr = (void **)&buf->m.planes;
> +			*array_size = sizeof(struct v4l2_plane) * buf->length;
> +			ret = 1;
> +		}
> +		break;
> +	}
> +
> +	case VIDIOC_S_EXT_CTRLS:
> +	case VIDIOC_G_EXT_CTRLS:
> +	case VIDIOC_TRY_EXT_CTRLS: {
> +		struct v4l2_ext_controls *ctrls = parg;
> +
> +		if (ctrls->count != 0) {
> +			*user_ptr = (void __user *)ctrls->controls;
> +			*kernel_ptr = (void **)&ctrls->controls;
> +			*array_size = sizeof(struct v4l2_ext_control)
> +				    * ctrls->count;
> +			ret = 1;
> +		}
> +		break;
> +	}
> +	}
> +
> +	return ret;
> +}
> +
>  long video_ioctl2(struct file *file,
>  	       unsigned int cmd, unsigned long arg)
>  {
> @@ -2007,15 +2049,16 @@ long video_ioctl2(struct file *file,
>  	void    *mbuf = NULL;
>  	void	*parg = NULL;
>  	long	err  = -EINVAL;
> -	int     is_ext_ctrl;
> -	size_t  ctrls_size = 0;
> +	int	has_array_args;
> +	size_t  array_size = 0;
>  	void __user *user_ptr = NULL;
> +	void	**kernel_ptr = NULL;
>  
>  #ifdef __OLD_VIDIOC_
>  	cmd = video_fix_command(cmd);
>  #endif
> -	is_ext_ctrl = (cmd == VIDIOC_S_EXT_CTRLS || cmd == VIDIOC_G_EXT_CTRLS ||
> -		       cmd == VIDIOC_TRY_EXT_CTRLS);
> +	/*is_ext_ctrl = (cmd == VIDIOC_S_EXT_CTRLS || cmd == VIDIOC_G_EXT_CTRLS ||
> +		       cmd == VIDIOC_TRY_EXT_CTRLS);*/

Just drop it if not used anymore.

>  
>  	/*  Copy arguments into temp kernel buffer  */
>  	if (_IOC_DIR(cmd) != _IOC_NONE) {
> @@ -2045,43 +2088,39 @@ long video_ioctl2(struct file *file,
>  		}
>  	}
>  
> -	if (is_ext_ctrl) {
> -		struct v4l2_ext_controls *p = parg;
> +	has_array_args = check_array_args(cmd, parg, &array_size,
> +					  &user_ptr, &kernel_ptr);
>  
> -		/* In case of an error, tell the caller that it wasn't
> -		   a specific control that caused it. */
> -		p->error_idx = p->count;
> -		user_ptr = (void __user *)p->controls;
> -		if (p->count) {
> -			ctrls_size = sizeof(struct v4l2_ext_control) * p->count;
> -			/* Note: v4l2_ext_controls fits in sbuf[] so mbuf is still NULL. */
> -			mbuf = kmalloc(ctrls_size, GFP_KERNEL);
> -			err = -ENOMEM;
> -			if (NULL == mbuf)
> -				goto out_ext_ctrl;
> -			err = -EFAULT;
> -			if (copy_from_user(mbuf, user_ptr, ctrls_size))
> -				goto out_ext_ctrl;
> -			p->controls = mbuf;
> -		}
> +	if (has_array_args) {
> +		/* When adding new types of array args, make sure that the
> +		 * parent argument to ioctl, which contains the array, fits into
> +		 * sbuf (so that mbuf will still remain unused up to here).
> +		 */
> +		mbuf = kmalloc(array_size, GFP_KERNEL);
> +		err = -ENOMEM;
> +		if (NULL == mbuf)
> +			goto out_array_args;
> +		err = -EFAULT;
> +		if (copy_from_user(mbuf, user_ptr, array_size))
> +			goto out_array_args;
> +		*kernel_ptr = mbuf;

You probably need something similar to this at v4l2-compat-ioctl32.c.

>  	}
>  
>  	/* Handles IOCTL */
>  	err = __video_do_ioctl(file, cmd, parg);
>  	if (err == -ENOIOCTLCMD)
>  		err = -EINVAL;
> -	if (is_ext_ctrl) {
> -		struct v4l2_ext_controls *p = parg;
>  
> -		p->controls = (void *)user_ptr;
> -		if (p->count && err == 0 && copy_to_user(user_ptr, mbuf, ctrls_size))
> +	if (has_array_args) {
> +		*kernel_ptr = user_ptr;
> +		if (copy_to_user(user_ptr, mbuf, array_size))
>  			err = -EFAULT;
> -		goto out_ext_ctrl;
> +		goto out_array_args;
>  	}
>  	if (err < 0)
>  		goto out;
>  
> -out_ext_ctrl:
> +out_array_args:
>  	/*  Copy results into user buffer  */
>  	switch (_IOC_DIR(cmd)) {
>  	case _IOC_READ:
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index d4962a7..bf3f33d 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -70,6 +70,7 @@
>   * Moved from videodev.h
>   */
>  #define VIDEO_MAX_FRAME               32
> +#define VIDEO_MAX_PLANES		3
>  
>  #ifndef __KERNEL__
>  
> @@ -180,6 +181,10 @@ enum v4l2_memory {
>  	V4L2_MEMORY_MMAP             = 1,
>  	V4L2_MEMORY_USERPTR          = 2,
>  	V4L2_MEMORY_OVERLAY          = 3,
> +
> +	/* Discontiguous buffer types */
> +	V4L2_MEMORY_MULTI_USERPTR    = 4,
> +	V4L2_MEMORY_MULTI_MMAP       = 5,
>  };
>  
>  /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
> @@ -519,6 +524,29 @@ struct v4l2_requestbuffers {
>  	__u32			reserved[2];
>  };
>  
> +/* struct v4l2_plane - a multi-plane buffer plane.
> + *
> + * Multi-plane buffers consist of two or more planes, e.g. an YCbCr buffer
> + * with two planes has one plane for Y, and another for interleaved CbCr
> + * components. Each plane can reside in a separate memory buffer, or in
> + * a completely separate memory chip even (e.g. in embedded devices).
> + */
> +struct v4l2_plane {
> +	__u32			bytesused;
> +
> +	union {
> +		__u32		offset;
> +		unsigned long	userptr;
> +	} m;
> +	__u32			length;
> +	__u32			reserved[5];
> +};
> +
> +/* struct v4l2_buffer - a video buffer (frame)
> + * @length:	size of the buffer (not its payload) for single-plane buffers,
> + * 		number of planes (and number of elements in planes array)
> + * 		for multi-plane
> + */
>  struct v4l2_buffer {
>  	__u32			index;
>  	enum v4l2_buf_type      type;
> @@ -532,8 +560,9 @@ struct v4l2_buffer {
>  	/* memory location */
>  	enum v4l2_memory        memory;
>  	union {
> -		__u32           offset;
> -		unsigned long   userptr;
> +		__u32			offset;
> +		unsigned long		userptr;
> +		struct v4l2_plane	*planes;
>  	} m;
>  	__u32			length;
>  	__u32			input;


-- 

Cheers,
Mauro
