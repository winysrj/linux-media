Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:46964 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753430AbbBTJBH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 04:01:07 -0500
Message-ID: <54E6F7B9.7050304@xs4all.nl>
Date: Fri, 20 Feb 2015 10:00:41 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com
Subject: Re: [PATCH v4 1/4] vb2: split the io_flags member of vb2_queue into
 a bit field
References: <1424360450-13048-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1424360450-13048-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/2015 04:40 PM, Kamil Debski wrote:
> This patch splits the io_flags member of vb2_queue into a bit field.
> Instead of an enum with flags separate bit fields were introduced.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/v4l2-core/videobuf2-core.c |   17 +++++++++--------
>  include/media/videobuf2-core.h           |   18 +++++-------------
>  2 files changed, 14 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index bc08a82..5cd60bf 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -2760,7 +2760,8 @@ struct vb2_fileio_data {
>  	unsigned int initial_index;
>  	unsigned int q_count;
>  	unsigned int dq_count;
> -	unsigned int flags;
> +	unsigned read_once:1;
> +	unsigned write_immediately:1;
>  };
>  
>  /**
> @@ -2798,14 +2799,16 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>  	 */
>  	count = 1;
>  
> -	dprintk(3, "setting up file io: mode %s, count %d, flags %08x\n",
> -		(read) ? "read" : "write", count, q->io_flags);
> +	dprintk(3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
> +		(read) ? "read" : "write", count, q->fileio_read_once,
> +		q->fileio_write_immediately);
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
> @@ -3028,13 +3031,11 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>  	/*
>  	 * Queue next buffer if required.
>  	 */
> -	if (buf->pos == buf->size ||
> -	   (!read && (fileio->flags & VB2_FILEIO_WRITE_IMMEDIATELY))) {
> +	if (buf->pos == buf->size || (!read && fileio->write_immediately)) {
>  		/*
>  		 * Check if this is the last buffer to read.
>  		 */
> -		if (read && (fileio->flags & VB2_FILEIO_READ_ONCE) &&
> -		    fileio->dq_count == 1) {
> +		if (read && fileio->read_once && fileio->dq_count == 1) {
>  			dprintk(3, "read limit reached\n");
>  			return __vb2_cleanup_fileio(q);
>  		}
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index bd2cec2..e49dc6b 100644
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
> @@ -346,7 +335,8 @@ struct v4l2_fh;
>   *
>   * @type:	queue type (see V4L2_BUF_TYPE_* in linux/videodev2.h
>   * @io_modes:	supported io methods (see vb2_io_modes enum)
> - * @io_flags:	additional io flags (see vb2_fileio_flags enum)
> + * @fileio_read_once:		report EOF after reading the first buffer
> + * @fileio_write_immediately:	queue buffer after each write() call
>   * @lock:	pointer to a mutex that protects the vb2_queue struct. The
>   *		driver can set this to a mutex to let the v4l2 core serialize
>   *		the queuing ioctls. If the driver wants to handle locking
> @@ -396,7 +386,9 @@ struct v4l2_fh;
>  struct vb2_queue {
>  	enum v4l2_buf_type		type;
>  	unsigned int			io_modes;
> -	unsigned int			io_flags;
> +	unsigned			fileio_read_once:1;
> +	unsigned			fileio_write_immediately:1;
> +
>  	struct mutex			*lock;
>  	struct v4l2_fh			*owner;
>  
> 

