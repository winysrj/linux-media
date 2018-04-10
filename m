Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:64446 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752845AbeDJNcJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Apr 2018 09:32:09 -0400
Date: Tue, 10 Apr 2018 10:32:04 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv11 PATCH 17/29] vb2: store userspace data in
 vb2_v4l2_buffer
Message-ID: <20180410103204.193cec54@vento.lan>
In-Reply-To: <20180409142026.19369-18-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
        <20180409142026.19369-18-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon,  9 Apr 2018 16:20:14 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The userspace-provided plane data needs to be stored in
> vb2_v4l2_buffer. Currently this information is applied by
> __fill_vb2_buffer() which is called by the core prepare_buf
> and qbuf functions, but when using requests these functions
> aren't called yet since the buffer won't be prepared until
> the media request is actually queued.
> 
> In the meantime this information has to be stored somewhere
> and vb2_v4l2_buffer is a good place for it.
> 
> The __fill_vb2_buffer callback now just copies the relevant
> information from vb2_v4l2_buffer into the planes array.

This patch is to hairy and do a lot more than what's
described. Please split it into one patch per change,
as otherwise we won't be able to properly review it.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/common/videobuf2/videobuf2-core.c |  25 +-
>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 324 +++++++++++++-----------
>  drivers/media/dvb-core/dvb_vb2.c                |   3 +-
>  include/media/videobuf2-core.h                  |   3 +-
>  include/media/videobuf2-v4l2.h                  |   2 +
>  5 files changed, 197 insertions(+), 160 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index d3f7bb33a54d..3d436ccb61f8 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -968,9 +968,8 @@ static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
>  {
>  	int ret = 0;
>  
> -	if (pb)
> -		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
> -				 vb, pb, vb->planes);
> +	ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
> +			 vb, vb->planes);
>  	return ret ? ret : call_vb_qop(vb, buf_prepare, vb);
>  }
>  
> @@ -988,12 +987,10 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
>  
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
>  	/* Copy relevant information provided by the userspace */
> -	if (pb) {
> -		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
> -				 vb, pb, planes);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
> +			 vb, planes);
> +	if (ret)
> +		return ret;
>  
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		/* Skip the plane if already verified */
> @@ -1104,12 +1101,10 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
>  
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
>  	/* Copy relevant information provided by the userspace */
> -	if (pb) {
> -		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
> -				 vb, pb, planes);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
> +			 vb, planes);
> +	if (ret)
> +		return ret;
>  
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
>  		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);

On all the above: why are you removing the check if (pb)? 
Stripping a check like that is really scary!

I don't remember why those checks are/were needed, but the patch
description doesn't give any hint why this change is required, and,
on a quick glance, pb can be NULL, for instance when this is called
while setting buffers for file io, at __vb2_init_fileio():

	ret = vb2_core_qbuf(q, i, NULL);


	int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
	{
	...
	        switch (vb->state) {
        	case VB2_BUF_STATE_DEQUEUED:
                	ret = __buf_prepare(vb, pb);

If this is really needed, please do such change on a separate patch,
in order to make easier to verify if everything is covered.

> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 4e9c77f21858..bf7a3ba9fed0 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -154,9 +154,177 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
>  		pr_warn("use the actual size instead.\n");
>  }
>  
> +static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
> +{
> +	struct vb2_queue *q = vb->vb2_queue;
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_plane *planes = vbuf->planes;
> +	unsigned int plane;
> +	int ret;
> +
> +	ret = __verify_length(vb, b);
> +	if (ret < 0) {
> +		dprintk(1, "plane parameters verification failed: %d\n", ret);
> +		return ret;
> +	}
> +	if (b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
> +		/*
> +		 * If the format's field is ALTERNATE, then the buffer's field
> +		 * should be either TOP or BOTTOM, not ALTERNATE since that
> +		 * makes no sense. The driver has to know whether the
> +		 * buffer represents a top or a bottom field in order to
> +		 * program any DMA correctly. Using ALTERNATE is wrong, since
> +		 * that just says that it is either a top or a bottom field,
> +		 * but not which of the two it is.
> +		 */
> +		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
> +		return -EINVAL;
> +	}
> +	vbuf->sequence = 0;
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> +		switch (b->memory) {
> +		case VB2_MEMORY_USERPTR:
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				planes[plane].m.userptr =
> +					b->m.planes[plane].m.userptr;
> +				planes[plane].length =
> +					b->m.planes[plane].length;
> +			}
> +			break;
> +		case VB2_MEMORY_DMABUF:
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				planes[plane].m.fd =
> +					b->m.planes[plane].m.fd;
> +				planes[plane].length =
> +					b->m.planes[plane].length;
> +			}
> +			break;
> +		default:
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				planes[plane].m.offset =
> +					vb->planes[plane].m.offset;
> +				planes[plane].length =
> +					vb->planes[plane].length;
> +			}
> +			break;
> +		}
> +
> +		/* Fill in driver-provided information for OUTPUT types */
> +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +			/*
> +			 * Will have to go up to b->length when API starts
> +			 * accepting variable number of planes.
> +			 *
> +			 * If bytesused == 0 for the output buffer, then fall
> +			 * back to the full buffer size. In that case
> +			 * userspace clearly never bothered to set it and
> +			 * it's a safe assumption that they really meant to
> +			 * use the full plane sizes.
> +			 *
> +			 * Some drivers, e.g. old codec drivers, use bytesused == 0
> +			 * as a way to indicate that streaming is finished.
> +			 * In that case, the driver should use the
> +			 * allow_zero_bytesused flag to keep old userspace
> +			 * applications working.
> +			 */
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				struct vb2_plane *pdst = &planes[plane];
> +				struct v4l2_plane *psrc = &b->m.planes[plane];
> +
> +				if (psrc->bytesused == 0)
> +					vb2_warn_zero_bytesused(vb);
> +
> +				if (vb->vb2_queue->allow_zero_bytesused)
> +					pdst->bytesused = psrc->bytesused;
> +				else
> +					pdst->bytesused = psrc->bytesused ?
> +						psrc->bytesused : pdst->length;
> +				pdst->data_offset = psrc->data_offset;
> +			}
> +		}
> +	} else {
> +		/*
> +		 * Single-planar buffers do not use planes array,
> +		 * so fill in relevant v4l2_buffer struct fields instead.
> +		 * In videobuf we use our internal V4l2_planes struct for
> +		 * single-planar buffers as well, for simplicity.
> +		 *
> +		 * If bytesused == 0 for the output buffer, then fall back
> +		 * to the full buffer size as that's a sensible default.
> +		 *
> +		 * Some drivers, e.g. old codec drivers, use bytesused == 0 as
> +		 * a way to indicate that streaming is finished. In that case,
> +		 * the driver should use the allow_zero_bytesused flag to keep
> +		 * old userspace applications working.
> +		 */
> +		switch (b->memory) {
> +		case VB2_MEMORY_USERPTR:
> +			planes[0].m.userptr = b->m.userptr;
> +			planes[0].length = b->length;
> +			break;
> +		case VB2_MEMORY_DMABUF:
> +			planes[0].m.fd = b->m.fd;
> +			planes[0].length = b->length;
> +			break;
> +		default:
> +			planes[0].m.offset = vb->planes[0].m.offset;
> +			planes[0].length = vb->planes[0].length;
> +			break;
> +		}
> +
> +		planes[0].data_offset = 0;
> +		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +			if (b->bytesused == 0)
> +				vb2_warn_zero_bytesused(vb);
> +
> +			if (vb->vb2_queue->allow_zero_bytesused)
> +				planes[0].bytesused = b->bytesused;
> +			else
> +				planes[0].bytesused = b->bytesused ?
> +					b->bytesused : planes[0].length;
> +		} else
> +			planes[0].bytesused = 0;
> +
> +	}
> +
> +	/* Zero flags that we handle */
> +	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
> +	if (!vb->vb2_queue->copy_timestamp || !V4L2_TYPE_IS_OUTPUT(b->type)) {
> +		/*
> +		 * Non-COPY timestamps and non-OUTPUT queues will get
> +		 * their timestamp and timestamp source flags from the
> +		 * queue.
> +		 */
> +		vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	}
> +
> +	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> +		/*
> +		 * For output buffers mask out the timecode flag:
> +		 * this will be handled later in vb2_qbuf().
> +		 * The 'field' is valid metadata for this output buffer
> +		 * and so that needs to be copied here.
> +		 */
> +		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
> +		vbuf->field = b->field;
> +	} else {
> +		/* Zero any output buffer flags as this is a capture buffer */
> +		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
> +		/* Zero last flag, this is a signal from driver to userspace */
> +		vbuf->flags &= ~V4L2_BUF_FLAG_LAST;
> +	}
> +
> +	return 0;
> +}
> +

As I said at the beginning, just this change, with apparently moves part of
the logic from __fill_vb2_buffer() into a separate function should be done
in a separate patch, and then a followup patch doing the required changes.

That would help us to check what changed in this part of the code 
were changed due to the request API needs.

>  static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>  				    const char *opname)
>  {
> +	struct vb2_v4l2_buffer *vbuf;
> +	struct vb2_buffer *vb;
> +	int ret;
> +
>  	if (b->type != q->type) {
>  		dprintk(1, "%s: invalid buffer type\n", opname);
>  		return -EINVAL;
> @@ -178,7 +346,15 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>  		return -EINVAL;
>  	}
>  
> -	return __verify_planes_array(q->bufs[b->index], b);
> +	vb = q->bufs[b->index];
> +	vbuf = to_vb2_v4l2_buffer(vb);
> +	ret = __verify_planes_array(vb, b);
> +	if (ret)
> +		return ret;
> +
> +	/* Copy relevant information provided by the userspace */
> +	memset(vbuf->planes, 0, sizeof(vbuf->planes[0]) * vb->num_planes);
> +	return vb2_fill_vb2_v4l2_buffer(vb, b);
>  }
>  
>  /*
> @@ -291,153 +467,19 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>   * v4l2_buffer by the userspace. It also verifies that struct
>   * v4l2_buffer has a valid number of planes.
>   */
> -static int __fill_vb2_buffer(struct vb2_buffer *vb,
> -		const void *pb, struct vb2_plane *planes)
> +static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
>  {
> -	struct vb2_queue *q = vb->vb2_queue;
> -	const struct v4l2_buffer *b = pb;
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	unsigned int plane;
> -	int ret;
>  
> -	ret = __verify_length(vb, b);
> -	if (ret < 0) {
> -		dprintk(1, "plane parameters verification failed: %d\n", ret);
> -		return ret;
> -	}
> -	if (b->field == V4L2_FIELD_ALTERNATE && q->is_output) {
> -		/*
> -		 * If the format's field is ALTERNATE, then the buffer's field
> -		 * should be either TOP or BOTTOM, not ALTERNATE since that
> -		 * makes no sense. The driver has to know whether the
> -		 * buffer represents a top or a bottom field in order to
> -		 * program any DMA correctly. Using ALTERNATE is wrong, since
> -		 * that just says that it is either a top or a bottom field,
> -		 * but not which of the two it is.
> -		 */
> -		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
> -		return -EINVAL;
> -	}
>  	vb->timestamp = 0;
> -	vbuf->sequence = 0;
> -
> -	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> -		if (b->memory == VB2_MEMORY_USERPTR) {
> -			for (plane = 0; plane < vb->num_planes; ++plane) {
> -				planes[plane].m.userptr =
> -					b->m.planes[plane].m.userptr;
> -				planes[plane].length =
> -					b->m.planes[plane].length;
> -			}
> -		}
> -		if (b->memory == VB2_MEMORY_DMABUF) {
> -			for (plane = 0; plane < vb->num_planes; ++plane) {
> -				planes[plane].m.fd =
> -					b->m.planes[plane].m.fd;
> -				planes[plane].length =
> -					b->m.planes[plane].length;
> -			}
> -		}
> -
> -		/* Fill in driver-provided information for OUTPUT types */
> -		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> -			/*
> -			 * Will have to go up to b->length when API starts
> -			 * accepting variable number of planes.
> -			 *
> -			 * If bytesused == 0 for the output buffer, then fall
> -			 * back to the full buffer size. In that case
> -			 * userspace clearly never bothered to set it and
> -			 * it's a safe assumption that they really meant to
> -			 * use the full plane sizes.
> -			 *
> -			 * Some drivers, e.g. old codec drivers, use bytesused == 0
> -			 * as a way to indicate that streaming is finished.
> -			 * In that case, the driver should use the
> -			 * allow_zero_bytesused flag to keep old userspace
> -			 * applications working.
> -			 */
> -			for (plane = 0; plane < vb->num_planes; ++plane) {
> -				struct vb2_plane *pdst = &planes[plane];
> -				struct v4l2_plane *psrc = &b->m.planes[plane];
> -
> -				if (psrc->bytesused == 0)
> -					vb2_warn_zero_bytesused(vb);
>  
> -				if (vb->vb2_queue->allow_zero_bytesused)
> -					pdst->bytesused = psrc->bytesused;
> -				else
> -					pdst->bytesused = psrc->bytesused ?
> -						psrc->bytesused : pdst->length;
> -				pdst->data_offset = psrc->data_offset;
> -			}
> -		}
> -	} else {
> -		/*
> -		 * Single-planar buffers do not use planes array,
> -		 * so fill in relevant v4l2_buffer struct fields instead.
> -		 * In videobuf we use our internal V4l2_planes struct for
> -		 * single-planar buffers as well, for simplicity.
> -		 *
> -		 * If bytesused == 0 for the output buffer, then fall back
> -		 * to the full buffer size as that's a sensible default.
> -		 *
> -		 * Some drivers, e.g. old codec drivers, use bytesused == 0 as
> -		 * a way to indicate that streaming is finished. In that case,
> -		 * the driver should use the allow_zero_bytesused flag to keep
> -		 * old userspace applications working.
> -		 */
> -		if (b->memory == VB2_MEMORY_USERPTR) {
> -			planes[0].m.userptr = b->m.userptr;
> -			planes[0].length = b->length;
> -		}
> -
> -		if (b->memory == VB2_MEMORY_DMABUF) {
> -			planes[0].m.fd = b->m.fd;
> -			planes[0].length = b->length;
> -		}
> -
> -		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> -			if (b->bytesused == 0)
> -				vb2_warn_zero_bytesused(vb);
> -
> -			if (vb->vb2_queue->allow_zero_bytesused)
> -				planes[0].bytesused = b->bytesused;
> -			else
> -				planes[0].bytesused = b->bytesused ?
> -					b->bytesused : planes[0].length;
> -		} else
> -			planes[0].bytesused = 0;
> -
> -	}
> -
> -	/* Zero flags that the vb2 core handles */
> -	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
> -	if (!vb->vb2_queue->copy_timestamp || !V4L2_TYPE_IS_OUTPUT(b->type)) {
> -		/*
> -		 * Non-COPY timestamps and non-OUTPUT queues will get
> -		 * their timestamp and timestamp source flags from the
> -		 * queue.
> -		 */
> -		vbuf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		planes[plane].m = vbuf->planes[plane].m;
> +		planes[plane].length = vbuf->planes[plane].length;
> +		planes[plane].bytesused = vbuf->planes[plane].bytesused;
> +		planes[plane].data_offset = vbuf->planes[plane].data_offset;
>  	}
> -
> -	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> -		/*
> -		 * For output buffers mask out the timecode flag:
> -		 * this will be handled later in vb2_qbuf().
> -		 * The 'field' is valid metadata for this output buffer
> -		 * and so that needs to be copied here.
> -		 */
> -		vbuf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
> -		vbuf->field = b->field;
> -	} else {
> -		/* Zero any output buffer flags as this is a capture buffer */
> -		vbuf->flags &= ~V4L2_BUFFER_OUT_FLAGS;
> -		/* Zero last flag, this is a signal from driver to userspace */
> -		vbuf->flags &= ~V4L2_BUF_FLAG_LAST;
> -	}
> -
>  	return 0;
>  }

I got lost with that huge code churn that started with the addition of
a new vb2_fill_vb2_v4l2_buffer() function. Is it replacing __fill_vb2_buffer()?
Why?

Please rework on it in order to minimize the diffstat, as it is very hard
to see if the code is an exact copy or if something else got changed.

> diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
> index b811adf88afa..da6a8cec7d42 100644
> --- a/drivers/media/dvb-core/dvb_vb2.c
> +++ b/drivers/media/dvb-core/dvb_vb2.c
> @@ -146,8 +146,7 @@ static void _fill_dmx_buffer(struct vb2_buffer *vb, void *pb)
>  	dprintk(3, "[%s]\n", ctx->name);
>  }
>  
> -static int _fill_vb2_buffer(struct vb2_buffer *vb,
> -			    const void *pb, struct vb2_plane *planes)
> +static int _fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
>  {
>  	struct dvb_vb2_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
>  
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index f6818f732f34..224c4820a044 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -417,8 +417,7 @@ struct vb2_ops {
>  struct vb2_buf_ops {
>  	int (*verify_planes_array)(struct vb2_buffer *vb, const void *pb);
>  	void (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
> -	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const void *pb,
> -				struct vb2_plane *planes);
> +	int (*fill_vb2_buffer)(struct vb2_buffer *vb, struct vb2_plane *planes);

Hmm... what happens if pb is NULL - with can happen for read()?

>  	void (*copy_timestamp)(struct vb2_buffer *vb, const void *pb);
>  };
>  
> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> index 3d5e2d739f05..097bf3e6951d 100644
> --- a/include/media/videobuf2-v4l2.h
> +++ b/include/media/videobuf2-v4l2.h
> @@ -32,6 +32,7 @@
>   *		&enum v4l2_field.
>   * @timecode:	frame timecode.
>   * @sequence:	sequence count of this frame.
> + * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
>   *
>   * Should contain enough information to be able to cover all the fields
>   * of &struct v4l2_buffer at ``videodev2.h``.
> @@ -43,6 +44,7 @@ struct vb2_v4l2_buffer {
>  	__u32			field;
>  	struct v4l2_timecode	timecode;
>  	__u32			sequence;
> +	struct vb2_plane	planes[VB2_MAX_PLANES];
>  };
>  
>  /*



Thanks,
Mauro
