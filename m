Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48024 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752044AbeERWQC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 18:16:02 -0400
Subject: Re: [Xen-devel][RFC 2/3] xen/grant-table: Extend API to work with DMA
 buffers
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180517082604.14828-1-andr2000@gmail.com>
 <20180517082604.14828-3-andr2000@gmail.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <28532709-6c87-f048-be6a-3c4ba02ae56f@oracle.com>
Date: Fri, 18 May 2018 18:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <20180517082604.14828-3-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/17/2018 04:26 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> ---
>  drivers/xen/grant-table.c | 49 +++++++++++++++++++++++++++++++++++++++
>  include/xen/grant_table.h |  7 ++++++
>  2 files changed, 56 insertions(+)
>
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index bb36b1e1dbcc..c27bcc420575 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -729,6 +729,55 @@ void gnttab_free_pages(int nr_pages, struct page **pages)
>  }
>  EXPORT_SYMBOL(gnttab_free_pages);
>  
> +int gnttab_dma_alloc_pages(struct device *dev, bool coherent,
> +			   int nr_pages, struct page **pages,
> +			   void **vaddr, dma_addr_t *dev_bus_addr)
> +{
> +	int i;
> +	int ret;
> +
> +	ret = alloc_dma_xenballooned_pages(dev, coherent, nr_pages, pages,
> +					   vaddr, dev_bus_addr);
> +	if (ret < 0)
> +		return ret;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +#if BITS_PER_LONG < 64
> +		struct xen_page_foreign *foreign;
> +
> +		foreign = kzalloc(sizeof(*foreign), GFP_KERNEL);
> +		if (!foreign) {
> +			gnttab_dma_free_pages(dev, flags, nr_pages, pages,
> +					      *vaddr, *dev_bus_addr);
> +			return -ENOMEM;
> +		}
> +		set_page_private(pages[i], (unsigned long)foreign);
> +#endif
> +		SetPagePrivate(pages[i]);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL(gnttab_dma_alloc_pages);
> +
> +void gnttab_dma_free_pages(struct device *dev, bool coherent,
> +			   int nr_pages, struct page **pages,
> +			   void *vaddr, dma_addr_t dev_bus_addr)
> +{
> +	int i;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		if (PagePrivate(pages[i])) {
> +#if BITS_PER_LONG < 64
> +			kfree((void *)page_private(pages[i]));
> +#endif
> +			ClearPagePrivate(pages[i]);
> +		}
> +	}
> +	free_dma_xenballooned_pages(dev, coherent, nr_pages, pages,
> +				    vaddr, dev_bus_addr);
> +}
> +EXPORT_SYMBOL(gnttab_dma_free_pages);


Given that these routines look almost exactly like their non-dma
counterparts I wonder whether common code could be factored out.

-boris




> +
>  /* Handling of paged out grant targets (GNTST_eagain) */
>  #define MAX_DELAY 256
>  static inline void
> diff --git a/include/xen/grant_table.h b/include/xen/grant_table.h
> index 34b1379f9777..20ee2b5ba965 100644
> --- a/include/xen/grant_table.h
> +++ b/include/xen/grant_table.h
> @@ -195,6 +195,13 @@ void gnttab_free_auto_xlat_frames(void);
>  int gnttab_alloc_pages(int nr_pages, struct page **pages);
>  void gnttab_free_pages(int nr_pages, struct page **pages);
>  
> +int gnttab_dma_alloc_pages(struct device *dev, bool coherent,
> +			   int nr_pages, struct page **pages,
> +			   void **vaddr, dma_addr_t *dev_bus_addr);
> +void gnttab_dma_free_pages(struct device *dev, bool coherent,
> +			   int nr_pages, struct page **pages,
> +			   void *vaddr, dma_addr_t dev_bus_addr);
> +
>  int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  		    struct gnttab_map_grant_ref *kmap_ops,
>  		    struct page **pages, unsigned int count);
