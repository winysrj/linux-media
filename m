Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41574 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752295AbeCMQtt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 12:49:49 -0400
Subject: Re: [PATCH 2/3] rcar-vin: allocate a scratch buffer at stream start
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com
References: <20180310000953.25366-1-niklas.soderlund+renesas@ragnatech.se>
 <20180310000953.25366-3-niklas.soderlund+renesas@ragnatech.se>
Reply-To: kieran.bingham@ideasonboard.com
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <5c59e8af-5082-e55f-5fae-997cff931160@ideasonboard.com>
Date: Tue, 13 Mar 2018 17:49:44 +0100
MIME-Version: 1.0
In-Reply-To: <20180310000953.25366-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 10/03/18 01:09, Niklas Söderlund wrote:
> Before starting capturing allocate a scratch buffer which can be used by

"Before starting a capture, allocate a..."
  (two 'ings' together doesn't sound right)

> the driver to give to the hardware if no buffers are available from
> userspace. The buffer is not used in this patch but prepares for future
> refactoring where the scratch buffer can be used to avoid the need to
> fallback on single capture mode if userspace don't queue buffers as fast

s/don't/doesn't/ or alternatively s/don't/can't/

> as the VIN driver consumes them.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

With minor comments attended to:

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-dma.c | 19 +++++++++++++++++++
>  drivers/media/platform/rcar-vin/rcar-vin.h |  4 ++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index b4be75d5009080f7..8ea73cdc9a720abe 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1070,6 +1070,17 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  	unsigned long flags;
>  	int ret;
>  
> +	/* Allocate scratch buffer. */
> +	vin->scratch = dma_alloc_coherent(vin->dev, vin->format.sizeimage,
> +					  &vin->scratch_phys, GFP_KERNEL);
> +	if (!vin->scratch) {
> +		spin_lock_irqsave(&vin->qlock, flags);
> +		return_all_buffers(vin, VB2_BUF_STATE_QUEUED);
> +		spin_unlock_irqrestore(&vin->qlock, flags);
> +		vin_err(vin, "Failed to allocate scratch buffer\n");
> +		return -ENOMEM;
> +	}
> +
>  	sd = vin_to_source(vin);
>  	v4l2_subdev_call(sd, video, s_stream, 1);
>  
> @@ -1085,6 +1096,10 @@ static int rvin_start_streaming(struct vb2_queue *vq, unsigned int count)
>  
>  	spin_unlock_irqrestore(&vin->qlock, flags);
>  
> +	if (ret)
> +		dma_free_coherent(vin->dev, vin->format.sizeimage, vin->scratch,
> +				  vin->scratch_phys);
> +
>  	return ret;
>  }
>  
> @@ -1135,6 +1150,10 @@ static void rvin_stop_streaming(struct vb2_queue *vq)
>  
>  	/* disable interrupts */
>  	rvin_disable_interrupts(vin);
> +
> +	/* Free scratch buffer. */
> +	dma_free_coherent(vin->dev, vin->format.sizeimage, vin->scratch,
> +			  vin->scratch_phys);
>  }
>  
>  static const struct vb2_ops rvin_qops = {
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 5382078143fb3869..11a981d707c7ca47 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -102,6 +102,8 @@ struct rvin_graph_entity {
>   *
>   * @lock:		protects @queue
>   * @queue:		vb2 buffers queue
> + * @scratch:		cpu address for scratch buffer
> + * @scratch_phys:	pysical address of the scratch buffer

s/pysical/physical/


>   *
>   * @qlock:		protects @queue_buf, @buf_list, @continuous, @sequence
>   *			@state
> @@ -130,6 +132,8 @@ struct rvin_dev {
>  
>  	struct mutex lock;
>  	struct vb2_queue queue;
> +	void *scratch;
> +	dma_addr_t scratch_phys;
>  
>  	spinlock_t qlock;
>  	struct vb2_v4l2_buffer *queue_buf[HW_BUFFER_NUM];
> 
