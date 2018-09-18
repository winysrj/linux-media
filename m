Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f67.google.com ([209.85.161.67]:38032 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbeIRPNh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:13:37 -0400
Received: by mail-yw1-f67.google.com with SMTP id n21-v6so507924ywh.5
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 02:41:48 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id e126-v6sm722807ywf.72.2018.09.18.02.41.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Sep 2018 02:41:47 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id o63-v6so535085yba.2
        for <linux-media@vger.kernel.org>; Tue, 18 Sep 2018 02:41:46 -0700 (PDT)
MIME-Version: 1.0
References: <1477471926-15796-1-git-send-email-thierry.escande@collabora.com>
 <1477471926-15796-3-git-send-email-thierry.escande@collabora.com> <89fe7216-d391-5a5c-424e-df1a2679f3cf@xs4all.nl>
In-Reply-To: <89fe7216-d391-5a5c-424e-df1a2679f3cf@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 18 Sep 2018 18:41:35 +0900
Message-ID: <CAAFQd5BdDbFvFA9iK45SA1jt-TyPTsOReayXWSn2enyOqQuReA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] [media] videobuf2-dc: Support cacheable MMAP
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Thierry Escande <thierry.escande@collabora.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Sep 17, 2018 at 11:41 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> I'm going through old patches in patchwork that fell through the
> cracks, and this is one of them.
>
> If this is still desired, please rebase and repost.
>
> I'm marking this series as Obsoleted in patchwork, since it no longer
> applies anyway.

The ability to have cached mappings of MMAP buffers is strongly
desired, but I'm afraid not the way this patch does it.

First of all, it's not a decision for the driver to make, but for the
user space, depending on the access pattern it does. It also isn't
something specific to vb2-dma-contig only.

I remember Sakari had a series that attempted to solve this in a more
comprehensive way[1]. I remember it had some minor problems when I
reviewed it, but generally the idea seemed sane.

Sakari, do you have any plans to revive that work?

[1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg112459.html

Best regards,
Tomasz

>
> Regards,
>
>         Hans
>
>
> On 10/26/2016 10:52 AM, Thierry Escande wrote:
> > From: Heng-Ruey Hsu <henryhsu@chromium.org>
> >
> > DMA allocations for MMAP type are uncached by default. But for
> > some cases, CPU has to access the buffers. ie: memcpy for format
> > converter. Supporting cacheable MMAP improves huge performance.
> >
> > This patch enables cacheable memory for DMA coherent allocator in mmap
> > buffer allocation if non-consistent DMA attribute is set and kernel
> > mapping is present. Even if userspace doesn't mmap the buffer, sync
> > still should be happening if kernel mapping is present.
> > If not done in allocation, it is enabled when memory is mapped from
> > userspace (if non-consistent DMA attribute is set).
> >
> > Signed-off-by: Heng-Ruey Hsu <henryhsu@chromium.org>
> > Tested-by: Heng-ruey Hsu <henryhsu@chromium.org>
> > Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> > Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-dma-contig.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > index 0d9665d..89b534a 100644
> > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > @@ -151,6 +151,10 @@ static void vb2_dc_put(void *buf_priv)
> >               sg_free_table(buf->sgt_base);
> >               kfree(buf->sgt_base);
> >       }
> > +     if (buf->dma_sgt) {
> > +             sg_free_table(buf->dma_sgt);
> > +             kfree(buf->dma_sgt);
> > +     }
> >       dma_free_attrs(buf->dev, buf->size, buf->cookie, buf->dma_addr,
> >                      buf->attrs);
> >       put_device(buf->dev);
> > @@ -192,6 +196,14 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
> >       buf->handler.put = vb2_dc_put;
> >       buf->handler.arg = buf;
> >
> > +     /*
> > +      * Enable cache maintenance. Even if userspace doesn't mmap the buffer,
> > +      * sync still should be happening if kernel mapping is present.
> > +      */
> > +     if (!(buf->attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
> > +         buf->attrs & DMA_ATTR_NON_CONSISTENT)
> > +             buf->dma_sgt = vb2_dc_get_base_sgt(buf);
> > +
> >       atomic_inc(&buf->refcount);
> >
> >       return buf;
> > @@ -227,6 +239,10 @@ static int vb2_dc_mmap(void *buf_priv, struct vm_area_struct *vma)
> >
> >       vma->vm_ops->open(vma);
> >
> > +     /* Enable cache maintenance if not enabled in allocation. */
> > +     if (!buf->dma_sgt && buf->attrs & DMA_ATTR_NON_CONSISTENT)
> > +             buf->dma_sgt = vb2_dc_get_base_sgt(buf);
> > +
> >       pr_debug("%s: mapped dma addr 0x%08lx at 0x%08lx, size %ld\n",
> >               __func__, (unsigned long)buf->dma_addr, vma->vm_start,
> >               buf->size);
> >
>
