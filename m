Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59814 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932811AbdKGIdz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Nov 2017 03:33:55 -0500
Date: Tue, 7 Nov 2017 06:33:45 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] v4l2: disable filesystem-dax mapping
 support
Message-ID: <20171107063345.22626a5d@vento.lan>
In-Reply-To: <151001624873.16354.2551756846133945335.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151001623063.16354.14661493921524115663.stgit@dwillia2-desk3.amr.corp.intel.com>
        <151001624873.16354.2551756846133945335.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 06 Nov 2017 16:57:28 -0800
Dan Williams <dan.j.williams@intel.com> escreveu:

> V4L2 memory registrations are incompatible with filesystem-dax that
> needs the ability to revoke dma access to a mapping at will, or
> otherwise allow the kernel to wait for completion of DMA. The
> filesystem-dax implementation breaks the traditional solution of
> truncate of active file backed mappings since there is no page-cache
> page we can orphan to sustain ongoing DMA.
> 
> If v4l2 wants to support long lived DMA mappings it needs to arrange to
> hold a file lease or use some other mechanism so that the kernel can
> coordinate revoking DMA access when the filesystem needs to truncate
> mappings.


Not sure if I understand this your comment here... what happens
if FS_DAX is enabled? The new err = get_user_pages_longterm()
would cause DMA allocation to fail? If so, that doesn't sound
right. Instead, mm should somehow mark this mapping to be out
of FS_DAX control range.

Also, it is not only videobuf-dma-sg.c that does long lived
DMA mappings. VB2 also does that (and videobuf-vmalloc).

Regards,
Mauro


> 
> Reported-by: Jan Kara <jack@suse.cz>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: linux-media@vger.kernel.org
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/media/v4l2-core/videobuf-dma-sg.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
> index 0b5c43f7e020..f412429cf5ba 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
> @@ -185,12 +185,13 @@ static int videobuf_dma_init_user_locked(struct videobuf_dmabuf *dma,
>  	dprintk(1, "init user [0x%lx+0x%lx => %d pages]\n",
>  		data, size, dma->nr_pages);
>  
> -	err = get_user_pages(data & PAGE_MASK, dma->nr_pages,
> +	err = get_user_pages_longterm(data & PAGE_MASK, dma->nr_pages,
>  			     flags, dma->pages, NULL);
>  
>  	if (err != dma->nr_pages) {
>  		dma->nr_pages = (err >= 0) ? err : 0;
> -		dprintk(1, "get_user_pages: err=%d [%d]\n", err, dma->nr_pages);
> +		dprintk(1, "get_user_pages_longterm: err=%d [%d]\n", err,
> +			dma->nr_pages);
>  		return err < 0 ? err : -EINVAL;
>  	}
>  	return 0;
> 



Thanks,
Mauro
