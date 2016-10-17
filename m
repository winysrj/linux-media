Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:32992 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S964828AbcJQKOP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 06:14:15 -0400
Date: Mon, 17 Oct 2016 13:06:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Thierry Escande <thierry.escande@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] [media] vb2: Add support for use_dma_bidirectional
 queue flag
Message-ID: <20161017100632.GM9460@valkosipuli.retiisi.org.uk>
References: <1476446894-4220-1-git-send-email-thierry.escande@collabora.com>
 <1476446894-4220-3-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1476446894-4220-3-git-send-email-thierry.escande@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thierry,

Thanks for the set. A few comments below.

On Fri, Oct 14, 2016 at 02:08:14PM +0200, Thierry Escande wrote:
> From: Pawel Osciak <posciak@chromium.org>
> 
> When this flag is set for CAPTURE queues by the driver on calling
> vb2_queue_init(), it forces the buffers on the queue to be
> allocated/mapped with DMA_BIDIRECTIONAL direction flag, instead of
> DMA_FROM_DEVICE. This allows the device not only to write to the
> buffers, but also read out from them. This may be useful e.g. for codec
> hardware, which may be using CAPTURE buffers as reference to decode
> other buffers.

Just out of curiosity --- when do you return these buffers back to the user?
Once they're no longer needed as reference frames?

> 
> This flag is ignored for OUTPUT queues, as we don't want to allow HW to
> be able to write to OUTPUT buffers.
> 
> Signed-off-by: Pawel Osciak <posciak@chromium.org>
> Tested-by: Pawel Osciak <posciak@chromium.org>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> ---
>  drivers/media/v4l2-core/videobuf2-v4l2.c | 8 ++++++--
>  include/media/videobuf2-core.h           | 4 ++++
>  2 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
> index fde1e2d..9255291 100644
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -659,8 +659,12 @@ int vb2_queue_init(struct vb2_queue *q)
>  	 * queues will always initialize waiting_for_buffers to false.
>  	 */
>  	q->quirk_poll_must_check_waiting_for_buffers = true;
> -	q->dma_dir = V4L2_TYPE_IS_OUTPUT(q->type)
> -		   ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(q->type))
> +		q->dma_dir = DMA_TO_DEVICE;
> +	else
> +		q->dma_dir = q->use_dma_bidirectional
> +			   ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
>  
>  	return vb2_core_queue_init(q);
>  }
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 38410dd..e613c74 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -433,6 +433,9 @@ struct vb2_buf_ops {
>   * @quirk_poll_must_check_waiting_for_buffers: Return POLLERR at poll when QBUF
>   *              has not been called. This is a vb1 idiom that has been adopted
>   *              also by vb2.
> + * @use_dma_bidirectional:	use DMA_BIDIRECTIONAL for CAPTURE buffers; this
> + *				allows HW to read from the CAPTURE buffers in
> + *				addition to writing; ignored for OUTPUT queues
>   * @lock:	pointer to a mutex that protects the vb2_queue struct. The
>   *		driver can set this to a mutex to let the v4l2 core serialize
>   *		the queuing ioctls. If the driver wants to handle locking
> @@ -500,6 +503,7 @@ struct vb2_queue {
>  	unsigned			fileio_write_immediately:1;
>  	unsigned			allow_zero_bytesused:1;
>  	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
> +	unsigned			use_dma_bidirectional:1;

This field is in the same struct as dma_dir which it directly affects.

How about adding a macro instead to give you the queue DMA direction
instead?

E.g.

#define vb2_dma_dir(q) \
	(V4L2_TYPE_IS_OUTPUT((q)->type) ? DMA_TO_DEVICE : \
	 (q)->use_dma_bidirectional ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE)

I would call this capture_dma_bidirectional as it only affects capture. Or
simply choose DMA_BIDIRECTIONAL whenever the flag is set.

I wonder what others think.

>  
>  	struct mutex			*lock;
>  	void				*owner;

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
