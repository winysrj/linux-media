Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:46771 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab0CRL7g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 07:59:36 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Arnout Vandecappelle <arnout@mind.be>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@infradead.org" <mchehab@infradead.org>
Date: Thu, 18 Mar 2010 06:58:56 -0500
Subject: RE: [PATCH 2/2] V4L/DVB: buf-dma-sg.c: support non-pageable
 user-allocated memory
Message-ID: <A24693684029E5489D1D202277BE8944541CC70F@dlee02.ent.ti.com>
References: <1268866385-15692-1-git-send-email-arnout@mind.be>
 <1268866385-15692-3-git-send-email-arnout@mind.be>
In-Reply-To: <1268866385-15692-3-git-send-email-arnout@mind.be>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnout,

Just a very minor style comment.

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Arnout Vandecappelle
> Sent: Wednesday, March 17, 2010 5:53 PM
> To: linux-media@vger.kernel.org; mchehab@infradead.org; arnout@mind.be
> Subject: [PATCH 2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-
> allocated memory
> 
> videobuf_dma_init_user_locked() uses get_user_pages() to get the
> virtual-to-physical address mapping for user-allocated memory.
> However, the user-allocated memory may be non-pageable because it
> is an I/O range or similar.  get_user_pages() fails with -EFAULT
> in that case.
> 
> If the user-allocated memory is physically contiguous, the approach
> of V4L2_MEMORY_OVERLAY can be used.  If it is not, -EFAULT is still
> returned.
> ---
>  drivers/media/video/videobuf-dma-sg.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c
> b/drivers/media/video/videobuf-dma-sg.c
> index 18aaf54..bd2d95d 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -136,6 +136,7 @@ static int videobuf_dma_init_user_locked(struct
> videobuf_dmabuf *dma,
>  {
>  	unsigned long first,last;
>  	int err, rw = 0;
> +	struct vm_area_struct *vma;
> 
>  	dma->direction = direction;
>  	switch (dma->direction) {
> @@ -153,6 +154,23 @@ static int videobuf_dma_init_user_locked(struct
> videobuf_dmabuf *dma,
>  	last  = ((data+size-1) & PAGE_MASK) >> PAGE_SHIFT;
>  	dma->offset   = data & ~PAGE_MASK;
>  	dma->nr_pages = last-first+1;
> +
> +	/* In case the buffer is user-allocated and is actually an IO buffer
> for
> +	   some other hardware, we cannot map pages for it.  It in fact
> behaves
> +	   the same as an overlay. */

> +	vma = find_vma (current->mm, data);

Remove space before parenthesis above, so it becomes:

	vma = find_vma(current->mm, data);

Regards,
Sergio

> +	if (vma && (vma->vm_flags & VM_IO)) {
> +		/* Only a single contiguous buffer is supported. */
> +		if (vma->vm_end < data + size) {
> +			dprintk(1, "init user: non-contiguous IO buffer.\n");
> +			return -EFAULT; /* same error that get_user_pages()
> would give */
> +		}
> +		dma->bus_addr = (vma->vm_pgoff << PAGE_SHIFT) +	(data - vma-
> >vm_start);
> +		dprintk(1,"init user IO [0x%lx+0x%lx => %d pages at 0x%x]\n",
> +			data, size, dma->nr_pages, dma->bus_addr);
> +		return 0;
> +	}
> +
>  	dma->pages = kmalloc(dma->nr_pages * sizeof(struct page*),
>  			     GFP_KERNEL);
>  	if (NULL == dma->pages)
> --
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
