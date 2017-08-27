Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:56351
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751342AbdH0WFz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 18:05:55 -0400
Date: Sun, 27 Aug 2017 19:05:46 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l: use struct v4l2_buffer explicitly instead of void
 *
Message-ID: <20170827190546.2c01463f@vento.lan>
In-Reply-To: <Pine.LNX.4.64.1707281439030.16637@axis700.grange>
References: <Pine.LNX.4.64.1707281439030.16637@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Jul 2017 14:45:37 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> A number of functions use void * for a struct v4l2_buffer parameter.
> Avoid that to improve compile-time checking.

Nack.

The videbuf2-core should be be independent of videobuf2-v4l2. The
plan is to use it for DVB too. There's a patch floating around,
lacking people to take a look.

I intend to review and merge it when I have some time along
the year.

> 
> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> ---
> 
> This probably was done on purpose, maybe to reuse the video buffers by 
> other than V4L2 users, but I haven't found any, and the code doesn't seem 
> very new...
> 
>  drivers/media/v4l2-core/videobuf2-core.c | 17 +++++++++--------
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 15 +++++++--------
>  include/media/videobuf2-core.h           | 19 ++++++++++++-------
>  3 files changed, 28 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 14f83cec..170a416 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -958,7 +958,7 @@ void vb2_discard_done(struct vb2_queue *q)
>  /**
>   * __prepare_mmap() - prepare an MMAP buffer
>   */
> -static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
> +static int __prepare_mmap(struct vb2_buffer *vb, const struct v4l2_buffer *pb)
>  {
>  	int ret = 0;
>  
> @@ -971,7 +971,7 @@ static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
>  /**
>   * __prepare_userptr() - prepare a USERPTR buffer
>   */
> -static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
> +static int __prepare_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *pb)
>  {
>  	struct vb2_plane planes[VB2_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
> @@ -1089,7 +1089,7 @@ static int __prepare_userptr(struct vb2_buffer *vb, const void *pb)
>  /**
>   * __prepare_dmabuf() - prepare a DMABUF buffer
>   */
> -static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
> +static int __prepare_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *pb)
>  {
>  	struct vb2_plane planes[VB2_MAX_PLANES];
>  	struct vb2_queue *q = vb->vb2_queue;
> @@ -1236,7 +1236,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
>  	call_void_vb_qop(vb, buf_queue, vb);
>  }
>  
> -static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
> +static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *pb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned int plane;
> @@ -1279,7 +1279,8 @@ static int __buf_prepare(struct vb2_buffer *vb, const void *pb)
>  	return 0;
>  }
>  
> -int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb)
> +int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index,
> +			 struct v4l2_buffer *pb)
>  {
>  	struct vb2_buffer *vb;
>  	int ret;
> @@ -1514,7 +1515,7 @@ static int __vb2_wait_for_done_vb(struct vb2_queue *q, int nonblocking)
>   * Will sleep if required for nonblocking == false.
>   */
>  static int __vb2_get_done_vb(struct vb2_queue *q, struct vb2_buffer **vb,
> -			     void *pb, int nonblocking)
> +			     struct v4l2_buffer *pb, int nonblocking)
>  {
>  	unsigned long flags;
>  	int ret = 0;
> @@ -1583,8 +1584,8 @@ static void __vb2_dqbuf(struct vb2_buffer *vb)
>  		}
>  }
>  
> -int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
> -		   bool nonblocking)
> +int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex,
> +		   struct v4l2_buffer *pb, bool nonblocking)
>  {
>  	struct vb2_buffer *vb = NULL;
>  	int ret;
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index 0c06699..3c425ea 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -53,7 +53,8 @@
>   * __verify_planes_array() - verify that the planes array passed in struct
>   * v4l2_buffer from userspace can be safely used
>   */
> -static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
> +static int __verify_planes_array(struct vb2_buffer *vb,
> +				 const struct v4l2_buffer *b)
>  {
>  	if (!V4L2_TYPE_IS_MULTIPLANAR(b->type))
>  		return 0;
> @@ -73,7 +74,8 @@ static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer
>  	return 0;
>  }
>  
> -static int __verify_planes_array_core(struct vb2_buffer *vb, const void *pb)
> +static int __verify_planes_array_core(struct vb2_buffer *vb,
> +				      const struct v4l2_buffer *pb)
>  {
>  	return __verify_planes_array(vb, pb);
>  }
> @@ -118,9 +120,8 @@ static int __verify_length(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  	return 0;
>  }
>  
> -static void __copy_timestamp(struct vb2_buffer *vb, const void *pb)
> +static void __copy_timestamp(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>  {
> -	const struct v4l2_buffer *b = pb;
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct vb2_queue *q = vb->vb2_queue;
>  
> @@ -185,9 +186,8 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
>   * __fill_v4l2_buffer() - fill in a struct v4l2_buffer with information to be
>   * returned to userspace
>   */
> -static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
> +static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>  {
> -	struct v4l2_buffer *b = pb;
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	struct vb2_queue *q = vb->vb2_queue;
>  	unsigned int plane;
> @@ -292,10 +292,9 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>   * v4l2_buffer has a valid number of planes.
>   */
>  static int __fill_vb2_buffer(struct vb2_buffer *vb,
> -		const void *pb, struct vb2_plane *planes)
> +		const struct v4l2_buffer *b, struct vb2_plane *planes)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	const struct v4l2_buffer *b = pb;
>  	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>  	unsigned int plane;
>  	int ret;
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index cb97c22..86e9605 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -395,6 +395,8 @@ struct vb2_ops {
>  	void (*buf_queue)(struct vb2_buffer *vb);
>  };
>  
> +struct v4l2_buffer;
> +
>  /**
>   * struct vb2_buf_ops - driver-specific callbacks
>   *
> @@ -410,11 +412,13 @@ struct vb2_ops {
>   *			the vb2_buffer struct.
>   */
>  struct vb2_buf_ops {
> -	int (*verify_planes_array)(struct vb2_buffer *vb, const void *pb);
> -	void (*fill_user_buffer)(struct vb2_buffer *vb, void *pb);
> -	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const void *pb,
> +	int (*verify_planes_array)(struct vb2_buffer *vb,
> +				const struct v4l2_buffer *pb);
> +	void (*fill_user_buffer)(struct vb2_buffer *vb, struct v4l2_buffer *b);
> +	int (*fill_vb2_buffer)(struct vb2_buffer *vb, const struct v4l2_buffer *pb,
>  				struct vb2_plane *planes);
> -	void (*copy_timestamp)(struct vb2_buffer *vb, const void *pb);
> +	void (*copy_timestamp)(struct vb2_buffer *vb,
> +				const struct v4l2_buffer *b);
>  };
>  
>  /**
> @@ -704,7 +708,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>   * The return values from this function are intended to be directly returned
>   * from vidioc_prepare_buf handler in driver.
>   */
> -int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index, void *pb);
> +int vb2_core_prepare_buf(struct vb2_queue *q, unsigned int index,
> +			 struct v4l2_buffer *pb);
>  
>  /**
>   * vb2_core_qbuf() - Queue a buffer from userspace
> @@ -753,8 +758,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>   * The return values from this function are intended to be directly returned
>   * from vidioc_dqbuf handler in driver.
>   */
> -int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex, void *pb,
> -		   bool nonblocking);
> +int vb2_core_dqbuf(struct vb2_queue *q, unsigned int *pindex,
> +		   struct v4l2_buffer *pb, bool nonblocking);
>  
>  int vb2_core_streamon(struct vb2_queue *q, unsigned int type);
>  int vb2_core_streamoff(struct vb2_queue *q, unsigned int type);



Thanks,
Mauro
