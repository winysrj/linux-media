Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45400 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbbBTQwc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Feb 2015 11:52:32 -0500
Message-ID: <54E76637.3030007@xs4all.nl>
Date: Fri, 20 Feb 2015 17:52:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
CC: m.szyprowski@samsung.com
Subject: Re: [PATCH v5 2/4] vb2: add allow_zero_bytesused flag to the vb2_queue
 struct
References: <1424450288-26444-1-git-send-email-k.debski@samsung.com> <1424450288-26444-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1424450288-26444-2-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

One question and one typo below...

On 02/20/2015 05:38 PM, Kamil Debski wrote:
> The vb2: fix bytesused == 0 handling (8a75ffb) patch changed the behavior
> of __fill_vb2_buffer function, so that if bytesused is 0 it is set to the
> size of the buffer. However, bytesused set to 0 is used by older codec
> drivers as as indication used to mark the end of stream.
> 
> To keep backward compatibility, this patch adds a flag passed to the
> vb2_queue_init function - allow_zero_bytesused. If the flag is set upon
> initialization of the queue, the videobuf2 keeps the value of bytesused
> intact in the OUTPUT queue and passes it to the driver.
> 
> Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |   39 +++++++++++++++++++++++++-----
>  include/media/videobuf2-core.h           |    2 ++
>  2 files changed, 35 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 5cd60bf..5d77670 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -1247,6 +1247,16 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  {
>  	unsigned int plane;
>  
> +	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +		if (WARN_ON_ONCE(b->bytesused == 0)) {
> +			pr_warn_once("use of bytesused == 0 is deprecated and will be removed in 2017,\n");

I wonder if we should give a specific year, or just say 'in the future'.

What do you think?

> +			if (vb->vb2_queue->allow_zero_bytesused)
> +				pr_warn_once("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.\n");
> +			else
> +				pr_warn_once("use the actual size instead.\n");
> +		}
> +	}
> +
>  	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
>  		if (b->memory == V4L2_MEMORY_USERPTR) {
>  			for (plane = 0; plane < vb->num_planes; ++plane) {
> @@ -1276,13 +1286,22 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
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
> @@ -1295,6 +1314,11 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>  		 *
>  		 * If bytesused == 0 for the output buffer, then fall back
>  		 * to the full buffer size as that's a sensible default.
> +		 *
> +		 * Some drivers, e.g. old codec drivers, use bytesused * == 0 as

Small typo:

s/bytesused * == 0/bytesused == 0/

> +		 * a way to indicate that streaming is finished. In that case,
> +		 * the driver should use the allow_zero_bytesused flag to keep
> +		 * old userspace applications working.
>  		 */
>  		if (b->memory == V4L2_MEMORY_USERPTR) {
>  			v4l2_planes[0].m.userptr = b->m.userptr;
> @@ -1306,10 +1330,13 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
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
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index e49dc6b..a5790fd 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -337,6 +337,7 @@ struct v4l2_fh;
>   * @io_modes:	supported io methods (see vb2_io_modes enum)
>   * @fileio_read_once:		report EOF after reading the first buffer
>   * @fileio_write_immediately:	queue buffer after each write() call
> + * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
>   * @lock:	pointer to a mutex that protects the vb2_queue struct. The
>   *		driver can set this to a mutex to let the v4l2 core serialize
>   *		the queuing ioctls. If the driver wants to handle locking
> @@ -388,6 +389,7 @@ struct vb2_queue {
>  	unsigned int			io_modes;
>  	unsigned			fileio_read_once:1;
>  	unsigned			fileio_write_immediately:1;
> +	unsigned			allow_zero_bytesused:1;
>  
>  	struct mutex			*lock;
>  	struct v4l2_fh			*owner;
> 

Regards,

	Hans
