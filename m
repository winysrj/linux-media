Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34302 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbeIKOkk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 10:40:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] udmabuf: improve udmabuf_create error handling
Date: Tue, 11 Sep 2018 12:42:20 +0300
Message-ID: <1927005.QJR53qTIv0@avalon>
In-Reply-To: <20180911065921.23818-9-kraxel@redhat.com>
References: <20180911065921.23818-1-kraxel@redhat.com> <20180911065921.23818-9-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gerd,

Thank you for the patch.

On Tuesday, 11 September 2018 09:59:19 EEST Gerd Hoffmann wrote:
> Reported-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/dma-buf/udmabuf.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
> index cb99a7886a..ec46513a47 100644
> --- a/drivers/dma-buf/udmabuf.c
> +++ b/drivers/dma-buf/udmabuf.c
> @@ -126,7 +126,7 @@ static long udmabuf_create(struct const
> udmabuf_create_list *head, struct file *memfd = NULL;
>  	struct udmabuf *ubuf;
>  	struct dma_buf *buf;
> -	pgoff_t pgoff, pgcnt, pgidx, pgbuf, pglimit;
> +	pgoff_t pgoff, pgcnt, pgidx, pgbuf = 0, pglimit;
>  	struct page *page;
>  	int seals, ret = -EINVAL;
>  	u32 i, flags;
> @@ -138,32 +138,32 @@ static long udmabuf_create(struct const
> udmabuf_create_list *head, pglimit = (size_limit_mb * 1024 * 1024) >>
> PAGE_SHIFT;
>  	for (i = 0; i < head->count; i++) {
>  		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
> -			goto err_free_ubuf;
> +			goto err;
>  		if (!IS_ALIGNED(list[i].size, PAGE_SIZE))
> -			goto err_free_ubuf;
> +			goto err;
>  		ubuf->pagecount += list[i].size >> PAGE_SHIFT;
>  		if (ubuf->pagecount > pglimit)
> -			goto err_free_ubuf;
> +			goto err;
>  	}
>  	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(struct page *),
>  				    GFP_KERNEL);
>  	if (!ubuf->pages) {
>  		ret = -ENOMEM;
> -		goto err_free_ubuf;
> +		goto err;
>  	}
> 
>  	pgbuf = 0;
>  	for (i = 0; i < head->count; i++) {
>  		memfd = fget(list[i].memfd);
>  		if (!memfd)
> -			goto err_put_pages;
> +			goto err;
>  		if (!shmem_mapping(file_inode(memfd)->i_mapping))
> -			goto err_put_pages;
> +			goto err;
>  		seals = memfd_fcntl(memfd, F_GET_SEALS, 0);
>  		if (seals == -EINVAL ||
>  		    (seals & SEALS_WANTED) != SEALS_WANTED ||
>  		    (seals & SEALS_DENIED) != 0)
> -			goto err_put_pages;
> +			goto err;
>  		pgoff = list[i].offset >> PAGE_SHIFT;
>  		pgcnt = list[i].size   >> PAGE_SHIFT;
>  		for (pgidx = 0; pgidx < pgcnt; pgidx++) {
> @@ -171,13 +171,13 @@ static long udmabuf_create(struct const
> udmabuf_create_list *head, file_inode(memfd)->i_mapping, pgoff + pgidx);
>  			if (IS_ERR(page)) {
>  				ret = PTR_ERR(page);
> -				goto err_put_pages;
> +				goto err;
>  			}
>  			ubuf->pages[pgbuf++] = page;
>  		}
>  		fput(memfd);
> +		memfd = NULL;
>  	}
> -	memfd = NULL;
> 
>  	exp_info.ops  = &udmabuf_ops;
>  	exp_info.size = ubuf->pagecount << PAGE_SHIFT;
> @@ -186,7 +186,7 @@ static long udmabuf_create(struct const
> udmabuf_create_list *head, buf = dma_buf_export(&exp_info);
>  	if (IS_ERR(buf)) {
>  		ret = PTR_ERR(buf);
> -		goto err_put_pages;
> +		goto err;
>  	}
> 
>  	flags = 0;
> @@ -194,10 +194,9 @@ static long udmabuf_create(struct const
> udmabuf_create_list *head, flags |= O_CLOEXEC;
>  	return dma_buf_fd(buf, flags);
> 
> -err_put_pages:
> +err:
>  	while (pgbuf > 0)
>  		put_page(ubuf->pages[--pgbuf]);
> -err_free_ubuf:
>  	if (memfd)
>  		fput(memfd);
>  	kfree(ubuf->pages);


-- 
Regards,

Laurent Pinchart
