Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:41536
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab0ETTXC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 15:23:02 -0400
From: Arnout Vandecappelle <arnout@mind.be>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memory
Date: Thu, 20 May 2010 21:22:51 +0200
Cc: linux-media@vger.kernel.org
References: <1268866385-15692-1-git-send-email-arnout@mind.be> <1268866385-15692-3-git-send-email-arnout@mind.be> <4BE2403D.3080601@infradead.org>
In-Reply-To: <4BE2403D.3080601@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201005202122.52238.arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Thursday 06 May 2010 06:06:21, Mauro Carvalho Chehab wrote:
> Hi Arnout,
> 
> Arnout Vandecappelle wrote:
> > videobuf_dma_init_user_locked() uses get_user_pages() to get the
> > virtual-to-physical address mapping for user-allocated memory.
> > However, the user-allocated memory may be non-pageable because it
> > is an I/O range or similar.  get_user_pages() fails with -EFAULT
> > in that case.
> > 
> > If the user-allocated memory is physically contiguous, the approach
> > of V4L2_MEMORY_OVERLAY can be used.  If it is not, -EFAULT is still
> > returned.
> > ---
> > 
> >  drivers/media/video/videobuf-dma-sg.c |   18 ++++++++++++++++++
> >  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> Your patch looked sane to my eyes. I just noticed one warning at the
> dprintk, when compiled with 32 bits address space, and a few coding
> style issues. I needed to rebase it also, due to some changes at
> videobuf.
> 
> However, you missed your SOB. Could you please send it? I'm enclosing
> the version with my changes for you to sign.
> 
> ---
> 
> V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memory
> Date: Wed, 17 Mar 2010 22:53:05 -0000
> From: Arnout Vandecappelle <arnout@mind.be>
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
> 
> [mchehab@redhat.com: Fixed CodingStyle and warning at dprintk on i386]
> 
> ---
> drivers/media/video/videobuf-dma-sg.c |   18 ++++++++++++++++++
>  drivers/media/video/videobuf-dma-sg.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> --- work.orig/drivers/media/video/videobuf-dma-sg.c
> +++ work/drivers/media/video/videobuf-dma-sg.c
> @@ -145,6 +145,7 @@ static int videobuf_dma_init_user_locked
>  {
>  	unsigned long first, last;
>  	int err, rw = 0;
> +	struct vm_area_struct *vma;
> 
>  	dma->direction = direction;
>  	switch (dma->direction) {
> @@ -162,6 +163,25 @@ static int videobuf_dma_init_user_locked
>  	last  = ((data+size-1) & PAGE_MASK) >> PAGE_SHIFT;
>  	dma->offset   = data & ~PAGE_MASK;
>  	dma->nr_pages = last-first+1;
> +
> +	/* In case the buffer is user-allocated and is actually an IO buffer
> for +	   some other hardware, we cannot map pages for it.  It in fact
> behaves +	   the same as an overlay. */
> +	vma = find_vma(current->mm, data);
> +	if (vma && (vma->vm_flags & VM_IO)) {
> +		/* Only a single contiguous buffer is supported. */
> +		if (vma->vm_end < data + size) {
> +			dprintk(1, "init user: non-contiguous IO buffer.\n");
> +			/* same error that get_user_pages() would give */
> +			return -EFAULT;
> +		}
> +		dma->bus_addr = (vma->vm_pgoff << PAGE_SHIFT) +
> +				(data - vma->vm_start);
> +		dprintk(1, "init user IO [0x%lx+0x%lx => %d pages at 0x%llx]\n",
> +			data, size, dma->nr_pages, (long long)dma->bus_addr);
> +		return 0;
> +	}
> +
>  	dma->pages = kmalloc(dma->nr_pages * sizeof(struct page *),
> GFP_KERNEL); if (NULL == dma->pages)
>  		return -ENOMEM;

Signed-off-by: Arnout Vandecappelle <arnout@mind.be>

-- 
Arnout Vandecappelle                               arnout at mind be
Senior Embedded Software Architect                 +32-16-286540
Essensium/Mind                                     http://www.mind.be
G.Geenslaan 9, 3001 Leuven, Belgium                BE 872 984 063 RPR Leuven
LinkedIn profile: http://www.linkedin.com/in/arnoutvandecappelle
GPG fingerprint:  31BB CF53 8660 6F88 345D  54CC A836 5879 20D7 CF43
