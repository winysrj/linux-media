Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:54927 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab1HXLAa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Aug 2011 07:00:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] media: vb2: fix handling MAPPED buffer flag
Date: Wed, 24 Aug 2011 13:00:33 +0200
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1314179663-8512-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1314179663-8512-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108241300.33674.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, August 24, 2011 11:54:23 Marek Szyprowski wrote:
> MAPPED flag was set for the buffer only if all it's planes were mapped and
> relied on a simple mapping counter. This assumption is really bogus,
> especially because the buffers may be mapped multiple times. Also the
> meaning of this flag for muliplane buffers was not really useful. This
> patch fixes this issue by setting the MAPPED flag for the buffer if any of
> it's planes is in use (what means that has been mapped at least once), so
> MAPPED flag can be used as 'in_use' indicator.

Looks good!

Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

This makes much more sense...

Regards,

	Hans

> 
> Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/videobuf2-core.c |   67 
++++++++++++++++++----------------
>  include/media/videobuf2-core.h       |    3 --
>  2 files changed, 36 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c 
b/drivers/media/video/videobuf2-core.c
> index c360627..e89fd53 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -277,6 +277,41 @@ static int __verify_planes_array(struct vb2_buffer *vb, 
struct v4l2_buffer *b)
>  }
>  
>  /**
> + * __buffer_in_use() - return true if the buffer is in use and
> + * the queue cannot be freed (by the means of REQBUFS(0)) call
> + */
> +static bool __buffer_in_use(struct vb2_queue *q, struct vb2_buffer *vb)
> +{
> +	unsigned int plane;
> +	for (plane = 0; plane < vb->num_planes; ++plane) {
> +		/*
> +		 * If num_users() has not been provided, call_memop
> +		 * will return 0, apparently nobody cares about this
> +		 * case anyway. If num_users() returns more than 1,
> +		 * we are not the only user of the plane's memory.
> +		 */
> +		if (call_memop(q, plane, num_users,
> +				vb->planes[plane].mem_priv) > 1)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/**
> + * __buffers_in_use() - return true if any buffers on the queue are in use 
and
> + * the queue cannot be freed (by the means of REQBUFS(0)) call
> + */
> +static bool __buffers_in_use(struct vb2_queue *q)
> +{
> +	unsigned int buffer;
> +	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> +		if (__buffer_in_use(q, q->bufs[buffer]))
> +			return true;
> +	}
> +	return false;
> +}
> +
> +/**
>   * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to 
be
>   * returned to userspace
>   */
> @@ -335,7 +370,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, 
struct v4l2_buffer *b)
>  		break;
>  	}
>  
> -	if (vb->num_planes_mapped == vb->num_planes)
> +	if (__buffer_in_use(q, vb))
>  		b->flags |= V4L2_BUF_FLAG_MAPPED;
>  
>  	return ret;
> @@ -400,33 +435,6 @@ static int __verify_mmap_ops(struct vb2_queue *q)
>  }
>  
>  /**
> - * __buffers_in_use() - return true if any buffers on the queue are in use 
and
> - * the queue cannot be freed (by the means of REQBUFS(0)) call
> - */
> -static bool __buffers_in_use(struct vb2_queue *q)
> -{
> -	unsigned int buffer, plane;
> -	struct vb2_buffer *vb;
> -
> -	for (buffer = 0; buffer < q->num_buffers; ++buffer) {
> -		vb = q->bufs[buffer];
> -		for (plane = 0; plane < vb->num_planes; ++plane) {
> -			/*
> -			 * If num_users() has not been provided, call_memop
> -			 * will return 0, apparently nobody cares about this
> -			 * case anyway. If num_users() returns more than 1,
> -			 * we are not the only user of the plane's memory.
> -			 */
> -			if (call_memop(q, plane, num_users,
> -					vb->planes[plane].mem_priv) > 1)
> -				return true;
> -		}
> -	}
> -
> -	return false;
> -}
> -
> -/**
>   * vb2_reqbufs() - Initiate streaming
>   * @q:		videobuf2 queue
>   * @req:	struct passed from userspace to vidioc_reqbufs handler in driver
> @@ -1343,9 +1351,6 @@ int vb2_mmap(struct vb2_queue *q, struct 
vm_area_struct *vma)
>  	if (ret)
>  		return ret;
>  
> -	vb_plane->mapped = 1;
> -	vb->num_planes_mapped++;
> -
>  	dprintk(3, "Buffer %d, plane %d successfully mapped\n", buffer, plane);
>  	return 0;
>  }
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 496d6e5..984f2ba 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -75,7 +75,6 @@ struct vb2_mem_ops {
>  
>  struct vb2_plane {
>  	void			*mem_priv;
> -	int			mapped:1;
>  };
>  
>  /**
> @@ -147,7 +146,6 @@ struct vb2_queue;
>   * @done_entry:		entry on the list that stores all buffers ready to
>   *			be dequeued to userspace
>   * @planes:		private per-plane information; do not change
> - * @num_planes_mapped:	number of mapped planes; do not change
>   */
>  struct vb2_buffer {
>  	struct v4l2_buffer	v4l2_buf;
> @@ -164,7 +162,6 @@ struct vb2_buffer {
>  	struct list_head	done_entry;
>  
>  	struct vb2_plane	planes[VIDEO_MAX_PLANES];
> -	unsigned int		num_planes_mapped;
>  };
>  
>  /**
> -- 
> 1.7.1.569.g6f426
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
