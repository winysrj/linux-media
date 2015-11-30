Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:34549 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754080AbbK3OPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 09:15:51 -0500
Subject: Re: [PATCHv11 15/15] videobuf2-core: fix plane_sizes handling in
 VIDIOC_CREATE_BUFS
To: linux-media@vger.kernel.org
References: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
 <1448037948-36820-16-git-send-email-hverkuil@xs4all.nl>
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <565C5A10.2090105@xs4all.nl>
Date: Mon, 30 Nov 2015 15:15:44 +0100
MIME-Version: 1.0
In-Reply-To: <1448037948-36820-16-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

There was some confusion about min_length, so let me try to explain it again.

When buffers are allocated in __vb2_queue_alloc() the queue_setup() op has been
called and that function filled in (for VIDIOC_REQBUFS) or accepted (for CREATE_BUFS)
the number of planes and plane sizes for these new buffers.

That means that the memory associated with each allocated buffer has to be at least
that size.

For MEMORY_MMAP that always true since we allocate the buffer memory, but for
USERPTR and DMABUF we need to check if the buffer we get is at least min_length in
size. Note that min_length is associated with a buffer (or more precise, buffer index).
So different buffers may have different min_length values.

When the application calls CREATE_BUFS the plane sizes that are specified are the
contract that the application makes with vb2: the created buffers will always have
at least the given size. This is true for MEMORY_MMAP and should be enforced for
USERPTR/DMABUF.

Now, it would be possible to just drop the whole min_length and have buf_prepare
call and check vb2_plane_size(). However, there are a few reasons why I don't
think that's a good idea:

1) a lot of drivers don't do this check in buf_prepare because it can't happen that
it is too small in the current setup: this can only happen if you can change the
format on the fly, and nobody allows that today.

2) I think it makes sense that if you create a buffer for a certain size, you
should have the guarantee that it always really is of at least that size, regardless
of whether MMAP or USERPTR or DMABUF is used.

3) When we do have a driver that can reconfigure on the fly, then buf_prepare is
not be the right place anyway since when it is called you still have the old format.

4) I don't want to change the way this is handled, instead I just want to fix the
bugs. So sue me :-)

I hope this helps. If there are no further comments, then I want to make a pull
request for this on Friday.

Regards,

	Hans

On 11/20/2015 05:45 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The handling of q->plane_sizes was wrong in vb2_core_create_bufs().
> The q->plane_sizes array was global and it was overwritten by create_bufs.
> So if reqbufs was called with e.g. size 100000 then q->plane_sizes[0] would
> be set to 100000. If create_bufs was called afterwards with size 200000,
> then q->plane_sizes[0] would be overwritten with the new value. Calling
> create_bufs again for size 100000 would cause an error since 100000 is now
> less than q->plane_sizes[0].
> 
> This patch fixes this problem by 1) removing q->plane_sizes and using the
> vb->planes[].length field instead, and 2) by introducing a min_length field
> in struct vb2_plane. This field is set to the plane size as returned by
> the queue_setup op and is the minimum required plane size. So user pointers
> or dmabufs should all be at least this size.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  drivers/media/v4l2-core/videobuf2-core.c | 39 +++++++++++++++++---------------
>  include/media/videobuf2-core.h           |  4 +++-
>  2 files changed, 24 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 26ba9e4..e6890d4 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -203,7 +203,7 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  	 * NOTE: mmapped areas should be page aligned
>  	 */
>  	for (plane = 0; plane < vb->num_planes; ++plane) {
> -		unsigned long size = PAGE_ALIGN(q->plane_sizes[plane]);
> +		unsigned long size = PAGE_ALIGN(vb->planes[plane].length);
>  
>  		mem_priv = call_ptr_memop(vb, alloc, q->alloc_ctx[plane],
>  				      size, dma_dir, q->gfp_flags);
> @@ -212,7 +212,6 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  
>  		/* Associate allocator private data with this plane */
>  		vb->planes[plane].mem_priv = mem_priv;
> -		vb->planes[plane].length = q->plane_sizes[plane];
>  	}
>  
>  	return 0;
> @@ -322,7 +321,8 @@ static void __setup_offsets(struct vb2_buffer *vb)
>   * Returns the number of buffers successfully allocated.
>   */
>  static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
> -			     unsigned int num_buffers, unsigned int num_planes)
> +			     unsigned int num_buffers, unsigned int num_planes,
> +			     const unsigned plane_sizes[VB2_MAX_PLANES])
>  {
>  	unsigned int buffer, plane;
>  	struct vb2_buffer *vb;
> @@ -342,8 +342,10 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>  		vb->index = q->num_buffers + buffer;
>  		vb->type = q->type;
>  		vb->memory = memory;
> -		for (plane = 0; plane < num_planes; ++plane)
> -			vb->planes[plane].length = q->plane_sizes[plane];
> +		for (plane = 0; plane < num_planes; ++plane) {
> +			vb->planes[plane].length = plane_sizes[plane];
> +			vb->planes[plane].min_length = plane_sizes[plane];
> +		}
>  		q->bufs[vb->index] = vb;
>  
>  		/* Allocate video buffer memory for the MMAP type */
> @@ -352,8 +354,8 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
>  			if (ret) {
>  				dprintk(1, "failed allocating memory for "
>  						"buffer %d\n", buffer);
> -				kfree(vb);
>  				q->bufs[vb->index] = NULL;
> +				kfree(vb);
>  				break;
>  			}
>  			__setup_offsets(vb);
> @@ -690,6 +692,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  		unsigned int *count)
>  {
>  	unsigned int num_buffers, allocated_buffers, num_planes = 0;
> +	unsigned plane_sizes[VB2_MAX_PLANES] = { };
>  	int ret;
>  
>  	if (q->streaming) {
> @@ -733,7 +736,6 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  	 */
>  	num_buffers = min_t(unsigned int, *count, VB2_MAX_FRAME);
>  	num_buffers = max_t(unsigned int, num_buffers, q->min_buffers_needed);
> -	memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
>  	memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
>  	q->memory = memory;
>  
> @@ -742,13 +744,13 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  	 * Driver also sets the size and allocator context for each plane.
>  	 */
>  	ret = call_qop(q, queue_setup, q, &num_buffers, &num_planes,
> -		       q->plane_sizes, q->alloc_ctx);
> +		       plane_sizes, q->alloc_ctx);
>  	if (ret)
>  		return ret;
>  
>  	/* Finally, allocate buffers and video memory */
>  	allocated_buffers =
> -		__vb2_queue_alloc(q, memory, num_buffers, num_planes);
> +		__vb2_queue_alloc(q, memory, num_buffers, num_planes, plane_sizes);
>  	if (allocated_buffers == 0) {
>  		dprintk(1, "memory allocation failed\n");
>  		return -ENOMEM;
> @@ -775,7 +777,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
>  		num_planes = 0;
>  
>  		ret = call_qop(q, queue_setup, q, &num_buffers,
> -			       &num_planes, q->plane_sizes, q->alloc_ctx);
> +			       &num_planes, plane_sizes, q->alloc_ctx);
>  
>  		if (!ret && allocated_buffers < num_buffers)
>  			ret = -ENOMEM;
> @@ -832,6 +834,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>  		const unsigned requested_sizes[])
>  {
>  	unsigned int num_planes = 0, num_buffers, allocated_buffers;
> +	unsigned plane_sizes[VB2_MAX_PLANES] = { };
>  	int ret;
>  
>  	if (q->num_buffers == VB2_MAX_FRAME) {
> @@ -840,7 +843,6 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>  	}
>  
>  	if (!q->num_buffers) {
> -		memset(q->plane_sizes, 0, sizeof(q->plane_sizes));
>  		memset(q->alloc_ctx, 0, sizeof(q->alloc_ctx));
>  		q->memory = memory;
>  		q->waiting_for_buffers = !q->is_output;
> @@ -850,7 +852,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>  
>  	if (requested_planes && requested_sizes) {
>  		num_planes = requested_planes;
> -		memcpy(q->plane_sizes, requested_sizes, sizeof(q->plane_sizes));
> +		memcpy(plane_sizes, requested_sizes, sizeof(plane_sizes));
>  	}
>  
>  	/*
> @@ -858,13 +860,13 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>  	 * buffer and their sizes are acceptable
>  	 */
>  	ret = call_qop(q, queue_setup, q, &num_buffers,
> -		       &num_planes, q->plane_sizes, q->alloc_ctx);
> +		       &num_planes, plane_sizes, q->alloc_ctx);
>  	if (ret)
>  		return ret;
>  
>  	/* Finally, allocate buffers and video memory */
>  	allocated_buffers = __vb2_queue_alloc(q, memory, num_buffers,
> -				num_planes);
> +				num_planes, plane_sizes);
>  	if (allocated_buffers == 0) {
>  		dprintk(1, "memory allocation failed\n");
>  		return -ENOMEM;
> @@ -881,7 +883,7 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
>  		 * queue driver has set up
>  		 */
>  		ret = call_qop(q, queue_setup, q, &num_buffers,
> -			       &num_planes, q->plane_sizes, q->alloc_ctx);
> +			       &num_planes, plane_sizes, q->alloc_ctx);
>  
>  		if (!ret && allocated_buffers < num_buffers)
>  			ret = -ENOMEM;
> @@ -1097,11 +1099,12 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
>  				"reacquiring memory\n", plane);
>  
>  		/* Check if the provided plane buffer is large enough */
> -		if (planes[plane].length < q->plane_sizes[plane]) {
> +		if (planes[plane].length < vb->planes[plane].min_length) {
>  			dprintk(1, "provided buffer size %u is less than "
>  						"setup size %u for plane %d\n",
>  						planes[plane].length,
> -						q->plane_sizes[plane], plane);
> +						vb->planes[plane].min_length,
> +						plane);
>  			ret = -EINVAL;
>  			goto err;
>  		}
> @@ -1214,7 +1217,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>  		if (planes[plane].length == 0)
>  			planes[plane].length = dbuf->size;
>  
> -		if (planes[plane].length < q->plane_sizes[plane]) {
> +		if (planes[plane].length < vb->planes[plane].min_length) {
>  			dprintk(1, "invalid dmabuf length for plane %d\n",
>  				plane);
>  			ret = -EINVAL;
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index b88dbba..ef03ae5 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -129,6 +129,8 @@ struct vb2_mem_ops {
>   * @dbuf_mapped:	flag to show whether dbuf is mapped or not
>   * @bytesused:	number of bytes occupied by data in the plane (payload)
>   * @length:	size of this plane (NOT the payload) in bytes
> + * @min_length:	minimum required size of this plane (NOT the payload) in bytes.
> + *		@length is always greater or equal to @min_length.
>   * @offset:	when memory in the associated struct vb2_buffer is
>   *		VB2_MEMORY_MMAP, equals the offset from the start of
>   *		the device memory for this plane (or is a "cookie" that
> @@ -150,6 +152,7 @@ struct vb2_plane {
>  	unsigned int		dbuf_mapped;
>  	unsigned int		bytesused;
>  	unsigned int		length;
> +	unsigned int		min_length;
>  	union {
>  		unsigned int	offset;
>  		unsigned long	userptr;
> @@ -489,7 +492,6 @@ struct vb2_queue {
>  	wait_queue_head_t		done_wq;
>  
>  	void				*alloc_ctx[VB2_MAX_PLANES];
> -	unsigned int			plane_sizes[VB2_MAX_PLANES];
>  
>  	unsigned int			streaming:1;
>  	unsigned int			start_streaming_called:1;
> 

