Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41702 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753953AbcARKQY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 05:16:24 -0500
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Lee Jones <lee.jones@linaro.org>, Arnd Bergmann <arnd@arndb.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: timblogiw: protect desc
Message-ID: <569CBB71.9080305@xs4all.nl>
Date: Mon, 18 Jan 2016 11:16:17 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> As sparse complains:
>         drivers/media/platform/timblogiw.c:562:22: warning: context imbalance in 'buffer_queue' - unexpected unlock
> 
> there's something weird at the logic there. The semaphore seems
> to be protecting changes at the desc struct, however, the
> callback logic is not protected.
> 
> Compile-tested only.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  drivers/media/platform/timblogiw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
> index 113c9f3c0b3e..a5d2607cc396 100644
> --- a/drivers/media/platform/timblogiw.c
> +++ b/drivers/media/platform/timblogiw.c
> @@ -566,8 +566,8 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
>         desc = dmaengine_prep_slave_sg(fh->chan,
>                 buf->sg, sg_elems, DMA_DEV_TO_MEM,
>                 DMA_PREP_INTERRUPT);
> +       spin_lock_irq(&fh->queue_lock);
>         if (!desc) {
> -               spin_lock_irq(&fh->queue_lock);
>                 list_del_init(&vb->queue);
>                 vb->state = VIDEOBUF_PREPARED;
>                 return;
> @@ -576,8 +576,8 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
>         desc->callback_param = buf;
>         desc->callback = timblogiw_dma_cb;
> 
> +       spin_unlock_irq(&fh->queue_lock);

This is wrong: the videobuf core will take the queue_lock before calling buffer_queue,
so you are now locking it twice. (A pointer to queue_lock is passed in via
videobuf_queue_dma_contig_init()).

The sparse warning is because sparse doesn't know that the lock is taking when this
function is called, and it gets confused by the 'unlock - lock' sequence.

I've no idea how to tell sparse about that.

To be honest, as far as I am concerned the best approach would be to remove this
driver completely. It's for an old genivi devkit that's obsolete for a long time
now.

Regards,

	Hans

>         buf->cookie = desc->tx_submit(desc);
> -
>         spin_lock_irq(&fh->queue_lock);
>  }

