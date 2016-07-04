Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:49127 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbcGDUNm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 16:13:42 -0400
Date: Mon, 4 Jul 2016 21:13:38 +0100
From: Sean Young <sean@mess.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: nuvoton: decrease size of raw event fifo
Message-ID: <20160704201338.GA28620@gofer.mess.org>
References: <aa9c30cd-5364-f460-2967-8a028b1093db@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa9c30cd-5364-f460-2967-8a028b1093db@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 18, 2016 at 10:29:41PM +0200, Heiner Kallweit wrote:
> This chip has a 32 byte HW FIFO only. Therefore the default fifo size
> of 512 raw events is not needed and can be significantly decreased.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

The 32 byte hardware queue is read from an interrupt handler and added
to the kfifo. The kfifo is read by the decoders in a seperate kthread
(in ir_raw_event_thread). If we have a long IR (e.g. nec which has 
66 edges) and the kthread is not scheduled in time (e.g. high load), will
we not end up with an overflow in the kfifo and unable to decode it?


Sean

> ---
>  drivers/media/rc/nuvoton-cir.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
> index 99b303b..e98c955 100644
> --- a/drivers/media/rc/nuvoton-cir.c
> +++ b/drivers/media/rc/nuvoton-cir.c
> @@ -1186,6 +1186,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>  	rdev->priv = nvt;
>  	rdev->driver_type = RC_DRIVER_IR_RAW;
>  	rdev->allowed_protocols = RC_BIT_ALL;
> +	rdev->raw_fifo_size = RX_BUF_LEN;
>  	rdev->open = nvt_open;
>  	rdev->close = nvt_close;
>  	rdev->tx_ir = nvt_tx_ir;
> -- 
> 2.8.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
