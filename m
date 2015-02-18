Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54350 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbbBRRaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 12:30:17 -0500
Message-ID: <54E4CC12.3020104@xs4all.nl>
Date: Wed, 18 Feb 2015 18:29:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com
Subject: Re: [PATCH v2 1/3] vb2: split the io_flags member of vb2_queue, add
 allow_zero_bytesused flag
References: <1424279226-23548-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1424279226-23548-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/18/2015 06:07 PM, Kamil Debski wrote:
> The vb2: fix bytesused == 0 handling (8a75ffb) patch changed the behavior
> of __fill_vb2_buffer function, so that if bytesused is 0 it is set to the
> size of the buffer. However, bytesused set to 0 is used by older codec
> drivers as as indication used to mark the end of stream.
> 
> This patch splits the io_flags member of vb2_queue into a bit field.
> To keep backward compatibility, this patch adds a flag passed to the
> vb2_queue_init function - allow_zero_bytesused. If the flag is set upon
> initialization of the queue, the videobuf2 keeps the value of bytesused
> intact in the OUTPUT queue and passes it to the driver.

Can you do this in two patches? One that changes io_flags to a bitfield,
and one adding the new flag.

See more remarks in videobuf2-core.h below.

> 
> Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |   44 ++++++++++++++++++++++--------
>  include/media/videobuf2-core.h           |   17 ++++--------
>  2 files changed, 37 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index bc08a82..e7e8ce5 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1276,13 +1276,22 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  			 * userspace clearly never bothered to set it and
>  			 * it's a safe assumption that they really meant to
>  			 * use the full plane sizes.
> +			 *
> +			 * Some drivers, e.g. old codec drivers, use bytesused
> +			 * == 0 as a way to indicate that streaming is finished.
> +			 * In that case, the driver should use the
> +			 * allow_zero_bytesused flag to keep old userspace
> +			 * applications working.
>  			 */
>  			for (plane = 0; plane < vb->num_planes; ++plane) {
>  				struct v4l2_plane *pdst = &v4l2_planes[plane];
>  				struct v4l2_plane *psrc = &b->m.planes[plane];
>  
> -				pdst->bytesused = psrc->bytesused ?
> -					psrc->bytesused : pdst->length;
> +				if (vb->vb2_queue->allow_zero_bytesused)
> +					pdst->bytesused = psrc->bytesused;
> +				else
> +					pdst->bytesused = psrc->bytesused ?
> +						psrc->bytesused : pdst->length;
>  				pdst->data_offset = psrc->data_offset;
>  			}
>  		}
> @@ -1295,6 +1304,11 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  		 *
>  		 * If bytesused == 0 for the output buffer, then fall back
>  		 * to the full buffer size as that's a sensible default.
> +		 *
> +		 * Some drivers, e.g. old codec drivers, use bytesused * == 0 as
> +		 * a way to indicate that streaming is finished. In that case,
> +		 * the driver should use the allow_zero_bytesused flag to keep
> +		 * old userspace applications working.
>  		 */
>  		if (b->memory == V4L2_MEMORY_USERPTR) {
>  			v4l2_planes[0].m.userptr = b->m.userptr;
> @@ -1306,10 +1320,13 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  			v4l2_planes[0].length = b->length;
>  		}
>  
> -		if (V4L2_TYPE_IS_OUTPUT(b->type))
> -			v4l2_planes[0].bytesused = b->bytesused ?
> -				b->bytesused : v4l2_planes[0].length;
> -		else
> +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +			if (vb->vb2_queue->allow_zero_bytesused)
> +				v4l2_planes[0].bytesused = b->bytesused;
> +			else
> +				v4l2_planes[0].bytesused = b->bytesused ?
> +					b->bytesused : v4l2_planes[0].length;
> +		} else
>  			v4l2_planes[0].bytesused = 0;
>  
>  	}
> @@ -2760,7 +2777,8 @@ struct vb2_fileio_data {
>  	unsigned int initial_index;
>  	unsigned int q_count;
>  	unsigned int dq_count;
> -	unsigned int flags;
> +	unsigned read_once:1;
> +	unsigned write_immediately:1;
>  };
>  
>  /**
> @@ -2798,14 +2816,16 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>  	 */
>  	count = 1;
>  
> -	dprintk(3, "setting up file io: mode %s, count %d, flags %08x\n",
> -		(read) ? "read" : "write", count, q->io_flags);
> +	dprintk(3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d, allow_zero_bytesused %d\n",
> +		(read) ? "read" : "write", count, q->fileio_read_once,
> +		q->fileio_write_immediately, q->allow_zero_bytesused);
>  
>  	fileio = kzalloc(sizeof(struct vb2_fileio_data), GFP_KERNEL);
>  	if (fileio == NULL)
>  		return -ENOMEM;
>  
> -	fileio->flags = q->io_flags;
> +	fileio->read_once = q->fileio_read_once;
> +	fileio->write_immediately = q->fileio_write_immediately;
>  
>  	/*
>  	 * Request buffers and use MMAP type to force driver
> @@ -3029,11 +3049,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>  	 * Queue next buffer if required.
>  	 */
>  	if (buf->pos == buf->size ||
> -	   (!read && (fileio->flags & VB2_FILEIO_WRITE_IMMEDIATELY))) {
> +	   (!read && (fileio->write_immediately))) {
>  		/*
>  		 * Check if this is the last buffer to read.
>  		 */
> -		if (read && (fileio->flags & VB2_FILEIO_READ_ONCE) &&
> +		if (read && (fileio->read_once) &&
>  		    fileio->dq_count == 1) {
>  			dprintk(3, "read limit reached\n");
>  			return __vb2_cleanup_fileio(q);
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index bd2cec2..50111bd573 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -134,17 +134,6 @@ enum vb2_io_modes {
>  };
>  
>  /**
> - * enum vb2_fileio_flags - flags for selecting a mode of the file io emulator,
> - * by default the 'streaming' style is used by the file io emulator
> - * @VB2_FILEIO_READ_ONCE:	report EOF after reading the first buffer
> - * @VB2_FILEIO_WRITE_IMMEDIATELY:	queue buffer after each write() call
> - */
> -enum vb2_fileio_flags {
> -	VB2_FILEIO_READ_ONCE		= (1 << 0),
> -	VB2_FILEIO_WRITE_IMMEDIATELY	= (1 << 1),
> -};
> -
> -/**
>   * enum vb2_buffer_state - current video buffer state
>   * @VB2_BUF_STATE_DEQUEUED:	buffer under userspace control
>   * @VB2_BUF_STATE_PREPARING:	buffer is being prepared in videobuf
> @@ -347,6 +336,7 @@ struct v4l2_fh;
>   * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
>   * @io_modes:	supported io methods (see vb2_io_modes enum)
>   * @io_flags:	additional io flags (see vb2_fileio_flags enum)

io_flags no longer exists.

> + * XXX

???

I assume you intended to move the enum vb2_fileio_flags comments here.

>   * @lock:	pointer to a mutex that protects the vb2_queue struct. The
>   *		driver can set this to a mutex to let the v4l2 core serialize
>   *		the queuing ioctls. If the driver wants to handle locking
> @@ -396,7 +386,10 @@ struct v4l2_fh;
>  struct vb2_queue {
>  	enum v4l2_buf_type		type;
>  	unsigned int			io_modes;
> -	unsigned int			io_flags;
> +	unsigned			fileio_read_once:1;
> +	unsigned			fileio_write_immediately:1;
> +	unsigned			allow_zero_bytesused:1;
> +
>  	struct mutex			*lock;
>  	struct v4l2_fh			*owner;
>  
> 

Regards,

	Hans
