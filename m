Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35988 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754884AbcK3IcU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 Nov 2016 03:32:20 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kevin Hilman <khilman@baylibre.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 1/4] [media] davinci: vpif_capture: don't lock over s_stream
Date: Wed, 30 Nov 2016 10:32:33 +0200
Message-ID: <4747860.QGGHSuFRpz@avalon>
In-Reply-To: <20161129235712.29846-2-khilman@baylibre.com>
References: <20161129235712.29846-1-khilman@baylibre.com> <20161129235712.29846-2-khilman@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kevin,

Thank you for the patch.

On Tuesday 29 Nov 2016 15:57:09 Kevin Hilman wrote:
> Video capture subdevs may be over I2C and may sleep during xfer, so we
> cannot do IRQ-disabled locking when calling the subdev.
> 
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> ---
>  drivers/media/platform/davinci/vpif_capture.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/media/platform/davinci/vpif_capture.c
> b/drivers/media/platform/davinci/vpif_capture.c index
> 5104cc0ee40e..9f8f41c0f251 100644
> --- a/drivers/media/platform/davinci/vpif_capture.c
> +++ b/drivers/media/platform/davinci/vpif_capture.c
> @@ -193,7 +193,10 @@ static int vpif_start_streaming(struct vb2_queue *vq,
> unsigned int count) }
>  	}
> 
> +	spin_unlock_irqrestore(&common->irqlock, flags);
>  	ret = v4l2_subdev_call(ch->sd, video, s_stream, 1);
> +	spin_lock_irqsave(&common->irqlock, flags);

I always get anxious when I see a spinlock being released randomly with an 
operation in the middle of a protected section. Looking at the code it looks 
like the spinlock is abused here. irqlock should only protect the dma_queue 
and should thus only be taken around the following code:

spin_lock_irqsave(&common->irqlock, flags);
/* Get the next frame from the buffer queue */
common->cur_frm = common->next_frm = list_entry(common->dma_queue.next,
                            struct vpif_cap_buffer, list);
/* Remove buffer from the buffer queue */
list_del(&common->cur_frm->list);
spin_unlock_irqrestore(&common->irqlock, flags);

The code that is currently protected by the lock in the start and stop 
streaming functions should be protected by a mutex instead.

> +
>  	if (ret && ret != -ENOIOCTLCMD && ret != -ENODEV) {
>  		vpif_dbg(1, debug, "stream on failed in subdev\n");
>  		goto err;

-- 
Regards,

Laurent Pinchart

