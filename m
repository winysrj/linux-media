Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57840 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbeHNWgk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 18:36:40 -0400
Date: Tue, 14 Aug 2018 16:47:51 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv18 19/35] vb2: store userspace data in vb2_v4l2_buffer
Message-ID: <20180814164751.7b52c58d@coco.lan>
In-Reply-To: <20180814142047.93856-20-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
        <20180814142047.93856-20-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 16:20:31 +0200
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
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../media/common/videobuf2/videobuf2-core.c   | 43 ++++++-------
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 60 +++++++++++++++----
>  drivers/media/dvb-core/dvb_vb2.c              |  3 +-
>  include/media/videobuf2-core.h                |  3 +-
>  include/media/videobuf2-v4l2.h                |  2 +
>  5 files changed, 72 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
> index 5653e8eebe2b..7401a17c80ca 100644
> --- a/drivers/media/common/videobuf2/videobuf2-core.c
> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
> @@ -967,20 +967,19 @@ EXPORT_SYMBOL_GPL(vb2_discard_done);
>  /*
>   * __prepare_mmap() - prepare an MMAP buffer
>   */
> -static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
> +static int __prepare_mmap(struct vb2_buffer *vb)
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
>  /*
>   * __prepare_userptr() - prepare a USERPTR buffer
>   */
> -static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
> +static int __prepare_userptr(struct vb2_buffer *vb)
>  {
>  	struct vb2_plane planes[VB2_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
> @@ -991,12 +990,10 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
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
> @@ -1096,7 +1093,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
>  /*
>   * __prepare_dmabuf() - prepare a DMABUF buffer
>   */
> -static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
> +static int __prepare_dmabuf(struct vb2_buffer *vb)
>  {
>  	struct vb2_plane planes[VB2_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
> @@ -1107,12 +1104,10 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
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
> @@ -1241,7 +1236,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>  	call_void_vb_qop(vb, buf_queue, vb);
>  }
>  
> -static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> +static int __buf_prepare(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned int plane;
> @@ -1256,13 +1251,13 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
>  
>  	switch (q->memory) {
>  	case VB2_MEMORY_MMAP:
> -		ret = __prepare_mmap(vb, pb);
> +		ret = __prepare_mmap(vb);
>  		break;
>  	case VB2_MEMORY_USERPTR:
> -		ret = __prepare_userptr(vb, pb);
> +		ret = __prepare_userptr(vb);
>  		break;
>  	case VB2_MEMORY_DMABUF:
> -		ret = __prepare_dmabuf(vb, pb);
> +		ret = __prepare_dmabuf(vb);
>  		break;
>  	default:
>  		WARN(1, "Invalid queue type\n");
> @@ -1296,7 +1291,7 @@ int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
>  		return -EINVAL;
>  	}
>  
> -	ret = __buf_prepare(vb, pb);
> +	ret = __buf_prepare(vb);
>  	if (ret)
>  		return ret;
>  
> @@ -1386,7 +1381,7 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
>  
>  	switch (vb->state) {
>  	case VB2_BUF_STATE_DEQUEUED:
> -		ret = __buf_prepare(vb, pb);
> +		ret = __buf_prepare(vb);
>  		if (ret)
>  			return ret;
>  		break;
> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> index 57848ddc584f..360dc4e7d413 100644
> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> @@ -154,17 +154,11 @@ static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
>  		pr_warn("use the actual size instead.\n");
>  }
>  
> -/*
> - * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
> - * v4l2_buffer by the userspace. It also verifies that struct
> - * v4l2_buffer has a valid number of planes.
> - */
> -static int __fill_vb2_buffer(struct vb2_buffer *vb,
> -		const void *pb, struct vb2_plane *planes)
> +static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	const struct v4l2_buffer *b = pb;
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct vb2_plane *planes = vbuf->planes;
>  	unsigned int plane;
>  	int ret;
>  
> @@ -186,7 +180,6 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>  		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
>  		return -EINVAL;
>  	}
> -	vb->timestamp = 0;

See my note below about this removal. On a quick look, I guess we may have
a regression here for output buffers (non-m2m).

>  	vbuf->sequence = 0;
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> @@ -208,6 +201,12 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>  			}
>  			break;
>  		default:
> +			for (plane = 0; plane < vb->num_planes; ++plane) {
> +				planes[plane].m.offset =
> +					vb->planes[plane].m.offset;
> +				planes[plane].length =
> +					vb->planes[plane].length;
> +			}
>  			break;
>  		}
>  
> @@ -269,9 +268,12 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>  			planes[0].length = b->length;
>  			break;
>  		default:
> +			planes[0].m.offset = vb->planes[0].m.offset;
> +			planes[0].length = vb->planes[0].length;
>  			break;
>  		}
>  
> +		planes[0].data_offset = 0;
>  		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
>  			if (b->bytesused == 0)
>  				vb2_warn_zero_bytesused(vb);
> @@ -286,7 +288,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
>  
>  	}
>  
> -	/* Zero flags that the vb2 core handles */
> +	/* Zero flags that we handle */
>  	vbuf->flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
>  	if (!vb->vb2_queue->copy_timestamp || !V4L2_TYPE_IS_OUTPUT(b->type)) {
>  		/*
> @@ -319,6 +321,10 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb,
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
> @@ -340,7 +346,15 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
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
> @@ -448,6 +462,30 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>  		q->last_buffer_dequeued = true;
>  }
>  
> +/*
> + * __fill_vb2_buffer() - fill a vb2_buffer with information provided in a
> + * v4l2_buffer by the userspace. It also verifies that struct
> + * v4l2_buffer has a valid number of planes.
> + */
> +static int __fill_vb2_buffer(struct vb2_buffer *vb, struct vb2_plane *planes)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	unsigned int plane;
> +
> +	if (!vb->vb2_queue->is_output || !vb->vb2_queue->copy_timestamp)
> +		vb->timestamp = 0;

When vb->vb2_queue->copy_timestamp is not NULL, timestamp will be copied,
but how VB2 will fill it if is_output?

I suspect that the right logic here would be just:

	if (!vb->vb2_queue->copy_timestamp)
		vb->timestamp = 0;


> +
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		if (vb->vb2_queue->memory != VB2_MEMORY_MMAP) {
> +			planes[plane].m = vbuf->planes[plane].m;
> +			planes[plane].length = vbuf->planes[plane].length;
> +		}
> +		planes[plane].bytesused = vbuf->planes[plane].bytesused;
> +		planes[plane].data_offset = vbuf->planes[plane].data_offset;
> +	}
> +	return 0;
> +}
> +
>  static const struct vb2_buf_ops v4l2_buf_ops = {
>  	.verify_planes_array	= __verify_planes_array_core,
>  	.fill_user_buffer	= __fill_v4l2_buffer,
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
