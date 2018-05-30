Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43799 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750708AbeE3EYz (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 00:24:55 -0400
Subject: Re: [PATCH 1/8] xen/grant-table: Make set/clear page private code
 shared
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-2-andr2000@gmail.com>
From: Juergen Gross <jgross@suse.com>
Message-ID: <a43d9dd4-c826-1dab-e397-d60796de3a76@suse.com>
Date: Wed, 30 May 2018 06:24:52 +0200
MIME-Version: 1.0
In-Reply-To: <20180525153331.31188-2-andr2000@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/05/18 17:33, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> 
> Make set/clear page private code shared and accessible to
> other kernel modules which can re-use these instead of open-coding.
> 
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> ---
>  drivers/xen/grant-table.c | 54 +++++++++++++++++++++++++--------------
>  include/xen/grant_table.h |  3 +++
>  2 files changed, 38 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 27be107d6480..d7488226e1f2 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -769,29 +769,18 @@ void gnttab_free_auto_xlat_frames(void)
>  }
>  EXPORT_SYMBOL_GPL(gnttab_free_auto_xlat_frames);
>  
> -/**
> - * gnttab_alloc_pages - alloc pages suitable for grant mapping into
> - * @nr_pages: number of pages to alloc
> - * @pages: returns the pages
> - */
> -int gnttab_alloc_pages(int nr_pages, struct page **pages)
> +int gnttab_pages_set_private(int nr_pages, struct page **pages)
>  {
>  	int i;
> -	int ret;
> -
> -	ret = alloc_xenballooned_pages(nr_pages, pages);
> -	if (ret < 0)
> -		return ret;
>  
>  	for (i = 0; i < nr_pages; i++) {
>  #if BITS_PER_LONG < 64
>  		struct xen_page_foreign *foreign;
>  
>  		foreign = kzalloc(sizeof(*foreign), GFP_KERNEL);
> -		if (!foreign) {
> -			gnttab_free_pages(nr_pages, pages);
> +		if (!foreign)
>  			return -ENOMEM;
> -		}
> +
>  		set_page_private(pages[i], (unsigned long)foreign);
>  #endif
>  		SetPagePrivate(pages[i]);
> @@ -799,14 +788,30 @@ int gnttab_alloc_pages(int nr_pages, struct page **pages)
>  
>  	return 0;
>  }
> -EXPORT_SYMBOL(gnttab_alloc_pages);
> +EXPORT_SYMBOL(gnttab_pages_set_private);

EXPORT_SYMBOL_GPL()

>  
>  /**
> - * gnttab_free_pages - free pages allocated by gnttab_alloc_pages()
> - * @nr_pages; number of pages to free
> - * @pages: the pages
> + * gnttab_alloc_pages - alloc pages suitable for grant mapping into
> + * @nr_pages: number of pages to alloc
> + * @pages: returns the pages
>   */
> -void gnttab_free_pages(int nr_pages, struct page **pages)
> +int gnttab_alloc_pages(int nr_pages, struct page **pages)
> +{
> +	int ret;
> +
> +	ret = alloc_xenballooned_pages(nr_pages, pages);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = gnttab_pages_set_private(nr_pages, pages);
> +	if (ret < 0)
> +		gnttab_free_pages(nr_pages, pages);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(gnttab_alloc_pages);
> +
> +void gnttab_pages_clear_private(int nr_pages, struct page **pages)
>  {
>  	int i;
>  
> @@ -818,6 +823,17 @@ void gnttab_free_pages(int nr_pages, struct page **pages)
>  			ClearPagePrivate(pages[i]);
>  		}
>  	}
> +}
> +EXPORT_SYMBOL(gnttab_pages_clear_private);

EXPORT_SYMBOL_GPL()


Juergen
