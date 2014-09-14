Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:63262 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaINDgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Sep 2014 23:36:38 -0400
Received: by mail-lb0-f172.google.com with SMTP id w7so2833139lbi.31
        for <linux-media@vger.kernel.org>; Sat, 13 Sep 2014 20:36:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410526803-25887-3-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl> <1410526803-25887-3-git-send-email-hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Sun, 14 Sep 2014 11:29:46 +0800
Message-ID: <CAMm-=zBj6Azt5gxP3-kfq0VRjpL+GSohqG8p=e81K0x9Jv4-8A@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 02/14] vb2-dma-sg: add allocation context to dma-sg
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thank you for working on this!

On Fri, Sep 12, 2014 at 8:59 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Require that dma-sg also uses an allocation context. This is in preparation
> for adding prepare/finish memops to sync the memory between DMA and CPU.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

[...]

> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
> index cb94366b..8a36fcd 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> @@ -1997,9 +1997,14 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
>         if (!pci_dma_supported(pci_dev, 0xffffffff)) {
>                 printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
>                 err = -EIO;
> -               goto fail_irq;
> +               goto fail_context;
>         }
>
> +       dev->alloc_ctx = vb2_dma_sg_init_ctx(&pci_dev->dev);
> +       if (IS_ERR(dev->alloc_ctx)) {
> +               err = -ENOMEM;

err = PTR_ERR(dev->alloc_ctx) ?

> +               goto fail_context;
> +       }
>         err = request_irq(pci_dev->irq, cx23885_irq,
>                           IRQF_SHARED, dev->name, dev);
>         if (err < 0) {
> @@ -2028,6 +2033,8 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
>         return 0;
>
>  fail_irq:
> +       vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
> +fail_context:
>         cx23885_dev_unregister(dev);
>  fail_ctrl:
>         v4l2_ctrl_handler_free(hdl);
> @@ -2053,6 +2060,7 @@ static void cx23885_finidev(struct pci_dev *pci_dev)
>         free_irq(pci_dev->irq, dev);
>
>         cx23885_dev_unregister(dev);
> +       vb2_dma_sg_cleanup_ctx(dev->alloc_ctx);
>         v4l2_ctrl_handler_free(&dev->ctrl_handler);
>         v4l2_device_unregister(v4l2_dev);
>         kfree(dev);

[...]

> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
> index e0e628c..7b8c201 100644
> --- a/drivers/media/platform/marvell-ccic/mcam-core.h
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.h
> @@ -176,6 +176,7 @@ struct mcam_camera {
>         /* DMA buffers - DMA modes */
>         struct mcam_vb_buffer *vb_bufs[MAX_DMA_BUFS];
>         struct vb2_alloc_ctx *vb_alloc_ctx;
> +       struct vb2_alloc_ctx *vb_alloc_ctx_sg;

Should this be under #ifdef MCAM_MODE_DMA_SG?

>
>         /* Mode-specific ops, set at open time */
>         void (*dma_setup)(struct mcam_camera *cam);

[...]

> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> index 313d977..d77e397 100644
> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
> @@ -35,7 +35,8 @@ struct vb2_vmalloc_buf {
>
>  static void vb2_vmalloc_put(void *buf_priv);
>
> -static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, gfp_t gfp_flags)
> +static void *vb2_vmalloc_alloc(void *alloc_ctx, unsigned long size, int write,
> +                              gfp_t gfp_flags)

I agree with Laurent that "write" is confusing, this could be a
direction flag, but the dma direction allows bidirectional, which we
would not be using. So I would personally prefer a binary flag or
enum. So perhaps we should keep this, only documenting it please.

-- 
Best regards,
Pawel Osciak
