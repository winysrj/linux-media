Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40236 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754092AbcJYHjp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Oct 2016 03:39:45 -0400
Date: Tue, 25 Oct 2016 10:39:35 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v4] [media] vb2: Add support for
 capture_dma_bidirectional queue flag
Message-ID: <20161025073935.GK9460@valkosipuli.retiisi.org.uk>
References: <1477294221-10912-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1477294221-10912-1-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

On Mon, Oct 24, 2016 at 09:30:21AM +0200, Thierry Escande wrote:
...
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
> @@ -554,6 +558,26 @@ struct vb2_queue {
>  #endif
>  };
>  
> +/*
> + * Returns the corresponding DMA direction given the vb2_queue type (capture or
> + * output). Returns DMA_BIDIRECTIONAL for capture buffers if the vb2_queue field
> + * capture_dma_bidirectional is set by the driver.
> + */
> +#define VB2_DMA_DIR(q) (V4L2_TYPE_IS_OUTPUT((q)->type)   \

q->is_output is assigned in vb2_queue_init():

	q->is_output = V4L2_TYPE_IS_OUTPUT(q->type);

Could you use that instead?

With that changed,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +			? DMA_TO_DEVICE                  \
> +			: (q)->capture_dma_bidirectional \
> +			  ? DMA_BIDIRECTIONAL            \
> +			  : DMA_FROM_DEVICE)
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

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
