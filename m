Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2175 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2JOIjn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 04:39:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] videobuf2-core: Verify planes lengths for output buffers
Date: Mon, 15 Oct 2012 10:38:59 +0200
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1350079190-11640-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1350079190-11640-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210151038.59920.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri October 12 2012 23:59:50 Laurent Pinchart wrote:
> For output buffers application provide to the kernel the number of bytes
> they stored in each plane of the buffer. Verify that the value is
> smaller than or equal to the plane length.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c |   36 ++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> This patch has been compiled only as I don't have any video output hardware
> supported by a videobuf2 driver.
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 432df11..f59bf58 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -296,6 +296,38 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
>  }
>  
>  /**
> + * __verify_length() - Verify that the bytesused value for each plane fits in
> + * the plane length.
> + */
> +static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +{
> +	unsigned int length;
> +	unsigned int plane;
> +
> +	if (!V4L2_TYPE_IS_OUTPUT(b->type))
> +		return 0;
> +
> +	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> +		for (plane = 0; plane < vb->num_planes; ++plane) {
> +			length = (b->memory == V4L2_MEMORY_USERPTR)
> +			       ? b->m.planes[plane].length
> +			       : vb->v4l2_planes[plane].length;
> +
> +			if (b->m.planes[plane].bytesused > length)
> +				return -EINVAL;

You need another test here as well:

			if (b->m.planes[plane].data_offset >= b->m.planes[plane].bytesused)
				return -EINVAL;

With that addition:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> +		}
> +	} else {
> +		length = (b->memory == V4L2_MEMORY_USERPTR)
> +		       ? b->length : vb->v4l2_planes[0].length;
> +
> +		if (b->bytesused > length)
> +			return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
>   * __buffer_in_use() - return true if the buffer is in use and
>   * the queue cannot be freed (by the means of REQBUFS(0)) call
>   */
> @@ -975,6 +1007,10 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  	struct vb2_queue *q = vb->vb2_queue;
>  	int ret;
>  
> +	ret = __verify_length(vb, b);
> +	if (ret < 0)
> +		return ret;
> +
>  	switch (q->memory) {
>  	case V4L2_MEMORY_MMAP:
>  		ret = __qbuf_mmap(vb, b);
> 
