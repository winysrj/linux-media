Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f51.google.com ([209.85.213.51]:42519 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652AbbBCI1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 03:27:43 -0500
MIME-Version: 1.0
In-Reply-To: <1421965128-10470-9-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
	<1421965128-10470-9-git-send-email-prabhakar.csengg@gmail.com>
Date: Tue, 3 Feb 2015 16:27:43 +0800
Message-ID: <CAHG8p1CrBaD_Rk8tkzXg6HucQQQQNmJ-_rvEa8nUOX3QhKKGxQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/15] media: blackfin: bfin_capture: use vb2_ioctl_* helpers
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	adi-buildroot-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lad,

2015-01-23 6:18 GMT+08:00 Lad, Prabhakar <prabhakar.csengg@gmail.com>:
> this patch adds support to vb2_ioctl_* helpers.
>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/platform/blackfin/bfin_capture.c | 108 ++++++-------------------
>  1 file changed, 23 insertions(+), 85 deletions(-)
>
> diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
> index b2eeace..04b85e3 100644
> --- a/drivers/media/platform/blackfin/bfin_capture.c
> +++ b/drivers/media/platform/blackfin/bfin_capture.c
> @@ -272,15 +272,26 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>         struct ppi_if *ppi = bcap_dev->ppi;
>         struct bcap_buffer *buf, *tmp;
>         struct ppi_params params;
> +       dma_addr_t addr;
>         int ret;
>
>         /* enable streamon on the sub device */
>         ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
>         if (ret && (ret != -ENOIOCTLCMD)) {
>                 v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
> +               bcap_dev->cur_frm = NULL;
>                 goto err;
>         }
>
> +       /* get the next frame from the dma queue */
> +       bcap_dev->cur_frm = list_entry(bcap_dev->dma_queue.next,
> +                                       struct bcap_buffer, list);
> +       /* remove buffer from the dma queue */
> +       list_del_init(&bcap_dev->cur_frm->list);
> +       addr = vb2_dma_contig_plane_dma_addr(&bcap_dev->cur_frm->vb, 0);
> +       /* update DMA address */
> +       ppi->ops->update_addr(ppi, (unsigned long)addr);
> +
>         /* set ppi params */
>         params.width = bcap_dev->fmt.width;
>         params.height = bcap_dev->fmt.height;
> @@ -320,6 +331,9 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>                 goto err;
>         }
>
> +       /* enable ppi */
> +       ppi->ops->start(ppi);
> +
Still wrong here. You can't start ppi before request dma and irq. Also
it's not good to update dma address before request dma. Please
strictly follow the initial sequence in bcap_streamon() because the
order is important. That means you should put all functions in
bcap_start_streaming() before those in bcap_streamon().
And it seems you removed dma buffer check in bcap_streamon(). Yes, in
vb2_internal_streamon() it will check q->queued_count >=
q->min_buffers_needed to start streaming. But if the user doesn't
queue enough buffer, it will return success and set q->streaming = 1.
Is it really right here?

>         /* attach ppi DMA irq handler */
>         ret = ppi->ops->attach_irq(ppi, bcap_isr);
>         if (ret < 0) {
> @@ -334,6 +348,9 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
>         return 0;
>
>
