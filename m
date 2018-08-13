Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36030 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728455AbeHMOXM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Aug 2018 10:23:12 -0400
Date: Mon, 13 Aug 2018 08:41:14 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 20/34] videodev2.h: Add request_fd field to
 v4l2_buffer
Message-ID: <20180813084114.1b15f56b@coco.lan>
In-Reply-To: <20180804124526.46206-21-hverkuil@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-21-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  4 Aug 2018 14:45:12 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When queuing buffers allow for passing the request that should
> be associated with this buffer.
> 
> If V4L2_BUF_FLAG_REQUEST_FD is set, then request_fd is used as
> the file descriptor.
> 
> If a buffer is stored in a request, but not yet queued to the
> driver, then V4L2_BUF_FLAG_IN_REQUEST is set.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
>  drivers/media/common/videobuf2/videobuf2-v4l2.c |  2 +-
>  drivers/media/usb/cpia2/cpia2_v4l.c             |  2 +-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c   |  9 ++++++---
>  drivers/media/v4l2-core/v4l2-ioctl.c            |  4 ++--
>  include/uapi/linux/videodev2.h                  | 10 +++++++++-
>  5 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index a677e2c26247..64905d87465c 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -384,7 +384,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  	b->timecode = vbuf->timecode;
>  	b->sequence = vbuf->sequence;
>  	b->reserved2 = 0;
> -	b->reserved = 0;
> +	b->request_fd = 0;
>  
>  	if (q->is_multiplanar) {
>  		/*
> diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
> index 99f106b13280..13aee9f67d05 100644
> --- a/drivers/media/usb/cpia2/cpia2_v4l.c
> +++ b/drivers/media/usb/cpia2/cpia2_v4l.c
> @@ -949,7 +949,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
>  	buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
>  	buf->length = cam->frame_size;
>  	buf->reserved2 = 0;
> -	buf->reserved = 0;
> +	buf->request_fd = 0;
>  	memset(&buf->timecode, 0, sizeof(buf->timecode));
>  
>  	DBG("DQBUF #%d status:%d seq:%d length:%d\n", buf->index,
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> index dcce86c1fe40..633465d21d04 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -482,7 +482,7 @@ struct v4l2_buffer32 {
>  	} m;
>  	__u32			length;
>  	__u32			reserved2;
> -	__u32			reserved;
> +	__s32			request_fd;
>  };
>  
>  static int get_v4l2_plane32(struct v4l2_plane __user *p64,
> @@ -581,6 +581,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *p64,
>  {
>  	u32 type;
>  	u32 length;
> +	s32 request_fd;
>  	enum v4l2_memory memory;
>  	struct v4l2_plane32 __user *uplane32;
>  	struct v4l2_plane __user *uplane;
> @@ -595,7 +596,9 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *p64,
>  	    get_user(memory, &p32->memory) ||
>  	    put_user(memory, &p64->memory) ||
>  	    get_user(length, &p32->length) ||
> -	    put_user(length, &p64->length))
> +	    put_user(length, &p64->length) ||
> +	    get_user(request_fd, &p32->request_fd) ||
> +	    put_user(request_fd, &p64->request_fd))
>  		return -EFAULT;
>  
>  	if (V4L2_TYPE_IS_OUTPUT(type))
> @@ -699,7 +702,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *p64,
>  	    copy_in_user(&p32->timecode, &p64->timecode, sizeof(p64->timecode)) ||
>  	    assign_in_user(&p32->sequence, &p64->sequence) ||
>  	    assign_in_user(&p32->reserved2, &p64->reserved2) ||
> -	    assign_in_user(&p32->reserved, &p64->reserved) ||
> +	    assign_in_user(&p32->request_fd, &p64->request_fd) ||
>  	    get_user(length, &p64->length) ||
>  	    put_user(length, &p32->length))
>  		return -EFAULT;
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 20b5145a5254..2a84ca9e328a 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -474,13 +474,13 @@ static void v4l_print_buffer(const void *arg, bool write_only)
>  	const struct v4l2_plane *plane;
>  	int i;
>  
> -	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, flags=0x%08x, field=%s, sequence=%d, memory=%s",
> +	pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, request_fd=%d, flags=0x%08x, field=%s, sequence=%d, memory=%s",
>  			p->timestamp.tv_sec / 3600,
>  			(int)(p->timestamp.tv_sec / 60) % 60,
>  			(int)(p->timestamp.tv_sec % 60),
>  			(long)p->timestamp.tv_usec,
>  			p->index,
> -			prt_names(p->type, v4l2_type_names),
> +			prt_names(p->type, v4l2_type_names), p->request_fd,
>  			p->flags, prt_names(p->field, v4l2_field_names),
>  			p->sequence, prt_names(p->memory, v4l2_memory_names));
>  
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 1df0fa983db6..91126b7312f8 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -917,6 +917,7 @@ struct v4l2_plane {
>   * @length:	size in bytes of the buffer (NOT its payload) for single-plane
>   *		buffers (when type != *_MPLANE); number of elements in the
>   *		planes array for multi-plane buffers
> + * @request_fd: fd of the request that this buffer should use
>   *
>   * Contains data exchanged by application and driver using one of the Streaming
>   * I/O methods.
> @@ -941,7 +942,10 @@ struct v4l2_buffer {
>  	} m;
>  	__u32			length;
>  	__u32			reserved2;
> -	__u32			reserved;
> +	union {
> +		__s32		request_fd;
> +		__u32		reserved;
> +	};
>  };
>  
>  /*  Flags for 'flags' field */
> @@ -959,6 +963,8 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_BFRAME			0x00000020
>  /* Buffer is ready, but the data contained within is corrupted. */
>  #define V4L2_BUF_FLAG_ERROR			0x00000040
> +/* Buffer is added to an unqueued request */
> +#define V4L2_BUF_FLAG_IN_REQUEST		0x00000080
>  /* timecode field is valid */
>  #define V4L2_BUF_FLAG_TIMECODE			0x00000100
>  /* Buffer is prepared for queuing */
> @@ -977,6 +983,8 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_TSTAMP_SRC_SOE		0x00010000
>  /* mem2mem encoder/decoder */
>  #define V4L2_BUF_FLAG_LAST			0x00100000
> +/* request_fd is valid */
> +#define V4L2_BUF_FLAG_REQUEST_FD		0x00800000
>  
>  /**
>   * struct v4l2_exportbuffer - export of video buffer as DMABUF file descriptor



Thanks,
Mauro
