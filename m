Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38243 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab0ELOEw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 May 2010 10:04:52 -0400
Received: by fxm15 with SMTP id 15so93812fxm.19
        for <linux-media@vger.kernel.org>; Wed, 12 May 2010 07:04:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273584994-14211-8-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
	 <1273584994-14211-8-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Wed, 12 May 2010 10:04:50 -0400
Message-ID: <AANLkTina3IBzJHLaStg-IMc32SMc7Qmt1H4nAyNJ_x-Q@mail.gmail.com>
Subject: Re: [PATCH 7/7] v4l: videobuf: Rename vmalloc fields to vaddr
From: David Ellingsworth <david@identd.dyndns.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, p.osciak@samsung.com,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 11, 2010 at 9:36 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> The videobuf_dmabuf and videobuf_vmalloc_memory fields have a vmalloc
> field to store the kernel virtual address of vmalloc'ed buffers. Rename
> the field to vaddr.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/cx88/cx88-alsa.c       |    2 +-
>  drivers/media/video/saa7134/saa7134-alsa.c |    2 +-
>  drivers/media/video/videobuf-dma-sg.c      |   18 ++++++++--------
>  drivers/media/video/videobuf-vmalloc.c     |   30 ++++++++++++++--------------
>  drivers/staging/cx25821/cx25821-alsa.c     |    2 +-
>  include/media/videobuf-dma-sg.h            |    2 +-
>  include/media/videobuf-vmalloc.h           |    2 +-
>  7 files changed, 29 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
> index ebeb9a6..771406f 100644
> --- a/drivers/media/video/cx88/cx88-alsa.c
> +++ b/drivers/media/video/cx88/cx88-alsa.c
> @@ -425,7 +425,7 @@ static int snd_cx88_hw_params(struct snd_pcm_substream * substream,
>        chip->buf = buf;
>        chip->dma_risc = dma;
>
> -       substream->runtime->dma_area = chip->dma_risc->vmalloc;
> +       substream->runtime->dma_area = chip->dma_risc->vaddr;
>        substream->runtime->dma_bytes = chip->dma_size;
>        substream->runtime->dma_addr = 0;
>        return 0;
> diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
> index 5bca2ab..68b7e8d 100644
> --- a/drivers/media/video/saa7134/saa7134-alsa.c
> +++ b/drivers/media/video/saa7134/saa7134-alsa.c
> @@ -669,7 +669,7 @@ static int snd_card_saa7134_hw_params(struct snd_pcm_substream * substream,
>           byte, but it doesn't work. So I allocate the DMA using the
>           V4L functions, and force ALSA to use that as the DMA area */
>
> -       substream->runtime->dma_area = dev->dmasound.dma.vmalloc;
> +       substream->runtime->dma_area = dev->dmasound.dma.vaddr;
>        substream->runtime->dma_bytes = dev->dmasound.bufsize;
>        substream->runtime->dma_addr = 0;
>
> diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
> index 2d64040..06f9a9c 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -211,17 +211,17 @@ int videobuf_dma_init_kernel(struct videobuf_dmabuf *dma, int direction,
>        dprintk(1, "init kernel [%d pages]\n", nr_pages);
>
>        dma->direction = direction;
> -       dma->vmalloc = vmalloc_32(nr_pages << PAGE_SHIFT);
> -       if (NULL == dma->vmalloc) {
> +       dma->vaddr = vmalloc_32(nr_pages << PAGE_SHIFT);
> +       if (NULL == dma->vaddr) {
>                dprintk(1, "vmalloc_32(%d pages) failed\n", nr_pages);
>                return -ENOMEM;
>        }
>
>        dprintk(1, "vmalloc is at addr 0x%08lx, size=%d\n",
> -                               (unsigned long)dma->vmalloc,
> +                               (unsigned long)dma->vaddr,
>                                nr_pages << PAGE_SHIFT);
>
> -       memset(dma->vmalloc, 0, nr_pages << PAGE_SHIFT);
> +       memset(dma->vaddr, 0, nr_pages << PAGE_SHIFT);
>        dma->nr_pages = nr_pages;
>
>        return 0;
> @@ -254,8 +254,8 @@ int videobuf_dma_map(struct device *dev, struct videobuf_dmabuf *dma)
>                dma->sglist = videobuf_pages_to_sg(dma->pages, dma->nr_pages,
>                                                   dma->offset);
>        }
> -       if (dma->vmalloc) {
> -               dma->sglist = videobuf_vmalloc_to_sg(dma->vmalloc,
> +       if (dma->vaddr) {
> +               dma->sglist = videobuf_vmalloc_to_sg(dma->vaddr,
>                                                     dma->nr_pages);
>        }
>        if (dma->bus_addr) {
> @@ -319,8 +319,8 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
>                dma->pages = NULL;
>        }
>
> -       vfree(dma->vmalloc);
> -       dma->vmalloc = NULL;
> +       vfree(dma->vaddr);
> +       dma->vaddr = NULL;
>
>        if (dma->bus_addr)
>                dma->bus_addr = 0;
> @@ -444,7 +444,7 @@ static void *__videobuf_to_vaddr(struct videobuf_buffer *buf)
>
>        MAGIC_CHECK(mem->magic, MAGIC_SG_MEM);
>
> -       return mem->dma.vmalloc;
> +       return mem->dma.vaddr;
>  }
>
>  static int __videobuf_iolock(struct videobuf_queue *q,
> diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
> index f0d7cb8..ea08b5d 100644
> --- a/drivers/media/video/videobuf-vmalloc.c
> +++ b/drivers/media/video/videobuf-vmalloc.c
> @@ -102,10 +102,10 @@ static void videobuf_vm_close(struct vm_area_struct *vma)
>                                   called with IRQ's disabled
>                                 */
>                                dprintk(1, "%s: buf[%d] freeing (%p)\n",
> -                                       __func__, i, mem->vmalloc);
> +                                       __func__, i, mem->vaddr);
>
> -                               vfree(mem->vmalloc);
> -                               mem->vmalloc = NULL;
> +                               vfree(mem->vaddr);
> +                               mem->vaddr = NULL;
>                        }
>
>                        q->bufs[i]->map   = NULL;
> @@ -170,7 +170,7 @@ static int __videobuf_iolock(struct videobuf_queue *q,
>                dprintk(1, "%s memory method MMAP\n", __func__);
>
>                /* All handling should be done by __videobuf_mmap_mapper() */
> -               if (!mem->vmalloc) {
> +               if (!mem->vaddr) {
>                        printk(KERN_ERR "memory is not alloced/mmapped.\n");
>                        return -EINVAL;
>                }
> @@ -189,13 +189,13 @@ static int __videobuf_iolock(struct videobuf_queue *q,
>                 * read() method.
>                 */
>
> -               mem->vmalloc = vmalloc_user(pages);
> -               if (!mem->vmalloc) {
> +               mem->vaddr = vmalloc_user(pages);
> +               if (!mem->vaddr) {
>                        printk(KERN_ERR "vmalloc (%d pages) failed\n", pages);
>                        return -ENOMEM;
>                }
>                dprintk(1, "vmalloc is at addr %p (%d pages)\n",
> -                       mem->vmalloc, pages);
> +                       mem->vaddr, pages);
>
>  #if 0
>                int rc;
> @@ -254,18 +254,18 @@ static int __videobuf_mmap_mapper(struct videobuf_queue *q,
>        MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
>
>        pages = PAGE_ALIGN(vma->vm_end - vma->vm_start);
> -       mem->vmalloc = vmalloc_user(pages);
> -       if (!mem->vmalloc) {
> +       mem->vaddr = vmalloc_user(pages);
> +       if (!mem->vaddr) {
>                printk(KERN_ERR "vmalloc (%d pages) failed\n", pages);
>                goto error;
>        }
> -       dprintk(1, "vmalloc is at addr %p (%d pages)\n", mem->vmalloc, pages);
> +       dprintk(1, "vmalloc is at addr %p (%d pages)\n", mem->vaddr, pages);
>
>        /* Try to remap memory */
> -       retval = remap_vmalloc_range(vma, mem->vmalloc, 0);
> +       retval = remap_vmalloc_range(vma, mem->vaddr, 0);
>        if (retval < 0) {
>                printk(KERN_ERR "mmap: remap failed with error %d. ", retval);
> -               vfree(mem->vmalloc);
> +               vfree(mem->vaddr);
>                goto error;
>        }
>
> @@ -317,7 +317,7 @@ void *videobuf_to_vmalloc(struct videobuf_buffer *buf)
>        BUG_ON(!mem);
>        MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
>
> -       return mem->vmalloc;
> +       return mem->vaddr;
>  }
>  EXPORT_SYMBOL_GPL(videobuf_to_vmalloc);
>
> @@ -339,8 +339,8 @@ void videobuf_vmalloc_free(struct videobuf_buffer *buf)
>
>        MAGIC_CHECK(mem->magic, MAGIC_VMAL_MEM);
>
> -       vfree(mem->vmalloc);
> -       mem->vmalloc = NULL;
> +       vfree(mem->addr);
Typo here.. should be vaddr not just addr.

> +       mem->vaddr = NULL;
>
>        return;
>  }
> diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
> index 14fd3cb..1a7ed9b 100644
> --- a/drivers/staging/cx25821/cx25821-alsa.c
> +++ b/drivers/staging/cx25821/cx25821-alsa.c
> @@ -491,7 +491,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
>        chip->buf = buf;
>        chip->dma_risc = dma;
>
> -       substream->runtime->dma_area = chip->dma_risc->vmalloc;
> +       substream->runtime->dma_area = chip->dma_risc->vaddr;
>        substream->runtime->dma_bytes = chip->dma_size;
>        substream->runtime->dma_addr = 0;
>
> diff --git a/include/media/videobuf-dma-sg.h b/include/media/videobuf-dma-sg.h
> index 913860e..97e07f4 100644
> --- a/include/media/videobuf-dma-sg.h
> +++ b/include/media/videobuf-dma-sg.h
> @@ -51,7 +51,7 @@ struct videobuf_dmabuf {
>        struct page         **pages;
>
>        /* for kernel buffers */
> -       void                *vmalloc;
> +       void                *vaddr;
>
>        /* for overlay buffers (pci-pci dma) */
>        dma_addr_t          bus_addr;
> diff --git a/include/media/videobuf-vmalloc.h b/include/media/videobuf-vmalloc.h
> index 851eb1a..e19403c 100644
> --- a/include/media/videobuf-vmalloc.h
> +++ b/include/media/videobuf-vmalloc.h
> @@ -22,7 +22,7 @@
>  struct videobuf_vmalloc_memory {
>        u32                 magic;
>
> -       void                *vmalloc;
> +       void                *vaddr;
>
>        /* remap_vmalloc_range seems to need to run
>         * after mmap() on some cases */
> --
> 1.6.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
