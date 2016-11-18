Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57617
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752430AbcKRTAB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 14:00:01 -0500
Date: Fri, 18 Nov 2016 16:59:51 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v5] [media] vb2: Add support for
 capture_dma_bidirectional queue flag
Message-ID: <20161118165951.5940e21a@vento.lan>
In-Reply-To: <1477383749-16208-1-git-send-email-thierry.escande@collabora.com>
References: <1477383749-16208-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Oct 2016 10:22:29 +0200
Thierry Escande <thierry.escande@collabora.com> escreveu:

> From: Pawel Osciak <posciak@chromium.org>
> 
> When this flag is set for CAPTURE queues by the driver on calling
> vb2_queue_init(), it forces the buffers on the queue to be
> allocated/mapped with DMA_BIDIRECTIONAL direction flag instead of
> DMA_FROM_DEVICE. This allows the device not only to write to the
> buffers, but also read out from them. This may be useful e.g. for codec
> hardware which may be using CAPTURE buffers as reference to decode
> other buffers.
> 
> This flag is ignored for OUTPUT queues as we don't want to allow HW to
> be able to write to OUTPUT buffers.
> 
> This patch introduces 2 macros:
> VB2_DMA_DIR(q) returns the corresponding dma_dir for the passed queue
> type, tanking care of the capture_dma_birectional flag.
> 
> VB2_DMA_DIR_CAPTURE(d) is a test macro returning true if the passed DMA
> direction refers to a capture buffer. This test is used to map virtual
> addresses for writing and to mark pages as dirty.

Why to add it? There's no other patch on this series with would
justify its needs...

> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Tested-by: Pawel Osciak <posciak@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
> 
> Changes in v2:
> - Renamed use_dma_bidirectional field as capture_dma_bidirectional
> - Added a VB2_DMA_DIR() macro
> 
> Changes in v3:
> - Get rid of dma_dir field and therefore squashed the previous patch
> 
> Changes in v4:
> - Fixed typos in include/media/videobuf2-core.h
> - Added VB2_DMA_DIR_CAPTURE() test macro
> 
> Changes in v5:
> - Use is_output queue field in VB2_DMA_DIR() macro
> 
>  drivers/media/v4l2-core/videobuf2-core.c       |  9 +++------
>  drivers/media/v4l2-core/videobuf2-dma-contig.c |  2 +-
>  drivers/media/v4l2-core/videobuf2-dma-sg.c     |  5 +++--
>  drivers/media/v4l2-core/videobuf2-vmalloc.c    |  4 ++--
>  include/media/videobuf2-core.h                 | 23 +++++++++++++++++++++++
>  5 files changed, 32 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
> index 21900202..22d6105 100644
> --- a/drivers/media/v4l2-core/videobuf2-core.c
> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> @@ -194,8 +194,7 @@ static void __enqueue_in_driver(struct vb2_buffer *vb);
>  static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
>  {
>  	struct vb2_queue *q = vb->vb2_queue;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
>  	void *mem_priv;
>  	int plane;
>  	int ret = -ENOMEM;
> @@ -978,8 +977,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
>  	void *mem_priv;
>  	unsigned int plane;
>  	int ret = 0;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
>  
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> @@ -1096,8 +1094,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
>  	void *mem_priv;
>  	unsigned int plane;
>  	int ret = 0;
> -	enum dma_data_direction dma_dir =
> -		q->is_output ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	enum dma_data_direction dma_dir = VB2_DMA_DIR(q);
>  	bool reacquired = vb->planes[0].mem_priv == NULL;
>  
>  	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> index fb6a177..a44e383 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> @@ -507,7 +507,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
>  	buf->dma_dir = dma_dir;
>  
>  	offset = vaddr & ~PAGE_MASK;
> -	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
> +	vec = vb2_create_framevec(vaddr, size, VB2_DMA_DIR_CAPTURE(dma_dir));
>  	if (IS_ERR(vec)) {
>  		ret = PTR_ERR(vec);
>  		goto fail_buf;
> diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> index ecff8f49..51c98f6 100644
> --- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
> @@ -238,7 +238,8 @@ static void *vb2_dma_sg_get_userptr(struct device *dev, unsigned long vaddr,
>  	buf->offset = vaddr & ~PAGE_MASK;
>  	buf->size = size;
>  	buf->dma_sgt = &buf->sg_table;
> -	vec = vb2_create_framevec(vaddr, size, buf->dma_dir == DMA_FROM_DEVICE);
> +	vec = vb2_create_framevec(vaddr, size,
> +				  VB2_DMA_DIR_CAPTURE(buf->dma_dir));
>  	if (IS_ERR(vec))
>  		goto userptr_fail_pfnvec;
>  	buf->vec = vec;
> @@ -291,7 +292,7 @@ static void vb2_dma_sg_put_userptr(void *buf_priv)
>  		vm_unmap_ram(buf->vaddr, buf->num_pages);
>  	sg_free_table(buf->dma_sgt);
>  	while (--i >= 0) {
> -		if (buf->dma_dir == DMA_FROM_DEVICE)
> +		if (VB2_DMA_DIR_CAPTURE(buf->dma_dir))
>  			set_page_dirty_lock(buf->pages[i]);
>  	}
>  	vb2_destroy_framevec(buf->vec);
> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index ab3227b..76649bd 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -86,7 +86,7 @@ static void *vb2_vmalloc_get_userptr(struct device *dev, unsigned long vaddr,
>  	buf->dma_dir = dma_dir;
>  	offset = vaddr & ~PAGE_MASK;
>  	buf->size = size;
> -	vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
> +	vec = vb2_create_framevec(vaddr, size, VB2_DMA_DIR_CAPTURE(dma_dir));
>  	if (IS_ERR(vec)) {
>  		ret = PTR_ERR(vec);
>  		goto fail_pfnvec_create;
> @@ -136,7 +136,7 @@ static void vb2_vmalloc_put_userptr(void *buf_priv)
>  		pages = frame_vector_pages(buf->vec);
>  		if (vaddr)
>  			vm_unmap_ram((void *)vaddr, n_pages);
> -		if (buf->dma_dir == DMA_FROM_DEVICE)
> +		if (VB2_DMA_DIR_CAPTURE(buf->dma_dir))
>  			for (i = 0; i < n_pages; i++)
>  				set_page_dirty_lock(pages[i]);
>  	} else {
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index ac5898a..11d2e51 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -433,6 +433,9 @@ struct vb2_buf_ops {
>   * @quirk_poll_must_check_waiting_for_buffers: Return POLLERR at poll when QBUF
>   *              has not been called. This is a vb1 idiom that has been adopted
>   *              also by vb2.
> + * @capture_dma_bidirectional:	use DMA_BIDIRECTIONAL for CAPTURE buffers; this
> + *				allows HW to read from the CAPTURE buffers in
> + *				addition to writing; ignored for OUTPUT queues.
>   * @lock:	pointer to a mutex that protects the vb2_queue struct. The
>   *		driver can set this to a mutex to let the v4l2 core serialize
>   *		the queuing ioctls. If the driver wants to handle locking
> @@ -499,6 +502,7 @@ struct vb2_queue {
>  	unsigned			fileio_write_immediately:1;
>  	unsigned			allow_zero_bytesused:1;
>  	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
> +	unsigned			capture_dma_bidirectional:1;
>  
>  	struct mutex			*lock;
>  	void				*owner;
> @@ -554,6 +558,25 @@ struct vb2_queue {
>  #endif
>  };
>  
> +/*
> + * Returns the corresponding DMA direction given the vb2_queue type (capture or
> + * output). Returns DMA_BIDIRECTIONAL for capture buffers if the vb2_queue field
> + * capture_dma_bidirectional is set by the driver.
> + */
> +#define VB2_DMA_DIR(q) ((q)->is_output ? DMA_TO_DEVICE                  \
> +				       : (q)->capture_dma_bidirectional \
> +					 ? DMA_BIDIRECTIONAL            \
> +					 : DMA_FROM_DEVICE)
> +
> +/*
> + * Returns true if the DMA direction passed as parameter refers to a capture
> + * buffer as capture buffers allow both FROM_DEVICE and BIDIRECTIONAL DMA
> + * direction. This test is used to map virtual addresses for writing and to mark
> + * pages as dirty.
> + */
> +#define VB2_DMA_DIR_CAPTURE(d) \
> +			((d) == DMA_FROM_DEVICE || (d) == DMA_BIDIRECTIONAL)
> +
>  /**
>   * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
>   * @vb:		vb2_buffer to which the plane in question belongs to


Thanks,
Mauro
