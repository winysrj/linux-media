Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0062.outbound.protection.outlook.com ([104.47.2.62]:63744
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755767AbeFOGcf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 02:32:35 -0400
Subject: Re: [PATCH v4 5/9] xen/gntdev: Allow mappings for DMA buffers
To: Oleksandr Andrushchenko <andr2000@gmail.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Cc: daniel.vetter@intel.com, dongwon.kim@intel.com,
        matthew.d.roper@intel.com
References: <20180615062753.9229-1-andr2000@gmail.com>
 <20180615062753.9229-6-andr2000@gmail.com>
From: Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
Message-ID: <e892748a-c268-9622-e568-4c361366bce1@epam.com>
Date: Fri, 15 Jun 2018 09:32:25 +0300
MIME-Version: 1.0
In-Reply-To: <20180615062753.9229-6-andr2000@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------F4451C5F6BC93CF3F350F4FA"
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------F4451C5F6BC93CF3F350F4FA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Please note, that this will need a change (attached) while
applying to the mainline kernel because of API changes [1].

Unfortunately, current Xen tip kernel tree is v4.17-rc5 based,
so I cannot make the change in this patch now.

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3d6ce86ee79465e1b1b6e287f8ea26b553fc768e

On 06/15/2018 09:27 AM, Oleksandr Andrushchenko wrote:
> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>
> Allow mappings for DMA backed  buffers if grant table module
> supports such: this extends grant device to not only map buffers
> made of balloon pages, but also from buffers allocated with
> dma_alloc_xxx.
>
> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
> Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> ---
>   drivers/xen/gntdev.c      | 99 ++++++++++++++++++++++++++++++++++++++-
>   include/uapi/xen/gntdev.h | 15 ++++++
>   2 files changed, 112 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
> index bd56653b9bbc..0ec670d1d4e7 100644
> --- a/drivers/xen/gntdev.c
> +++ b/drivers/xen/gntdev.c
> @@ -37,6 +37,9 @@
>   #include <linux/slab.h>
>   #include <linux/highmem.h>
>   #include <linux/refcount.h>
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +#include <linux/of_device.h>
> +#endif
>   
>   #include <xen/xen.h>
>   #include <xen/grant_table.h>
> @@ -72,6 +75,11 @@ struct gntdev_priv {
>   	struct mutex lock;
>   	struct mm_struct *mm;
>   	struct mmu_notifier mn;
> +
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +	/* Device for which DMA memory is allocated. */
> +	struct device *dma_dev;
> +#endif
>   };
>   
>   struct unmap_notify {
> @@ -96,10 +104,27 @@ struct grant_map {
>   	struct gnttab_unmap_grant_ref *kunmap_ops;
>   	struct page **pages;
>   	unsigned long pages_vm_start;
> +
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +	/*
> +	 * If dmabuf_vaddr is not NULL then this mapping is backed by DMA
> +	 * capable memory.
> +	 */
> +
> +	struct device *dma_dev;
> +	/* Flags used to create this DMA buffer: GNTDEV_DMA_FLAG_XXX. */
> +	int dma_flags;
> +	void *dma_vaddr;
> +	dma_addr_t dma_bus_addr;
> +	/* Needed to avoid allocation in gnttab_dma_free_pages(). */
> +	xen_pfn_t *frames;
> +#endif
>   };
>   
>   static int unmap_grant_pages(struct grant_map *map, int offset, int pages);
>   
> +static struct miscdevice gntdev_miscdev;
> +
>   /* ------------------------------------------------------------------ */
>   
>   static void gntdev_print_maps(struct gntdev_priv *priv,
> @@ -121,8 +146,27 @@ static void gntdev_free_map(struct grant_map *map)
>   	if (map == NULL)
>   		return;
>   
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +	if (map->dma_vaddr) {
> +		struct gnttab_dma_alloc_args args;
> +
> +		args.dev = map->dma_dev;
> +		args.coherent = !!(map->dma_flags & GNTDEV_DMA_FLAG_COHERENT);
> +		args.nr_pages = map->count;
> +		args.pages = map->pages;
> +		args.frames = map->frames;
> +		args.vaddr = map->dma_vaddr;
> +		args.dev_bus_addr = map->dma_bus_addr;
> +
> +		gnttab_dma_free_pages(&args);
> +	} else
> +#endif
>   	if (map->pages)
>   		gnttab_free_pages(map->count, map->pages);
> +
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +	kfree(map->frames);
> +#endif
>   	kfree(map->pages);
>   	kfree(map->grants);
>   	kfree(map->map_ops);
> @@ -132,7 +176,8 @@ static void gntdev_free_map(struct grant_map *map)
>   	kfree(map);
>   }
>   
> -static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
> +static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
> +					  int dma_flags)
>   {
>   	struct grant_map *add;
>   	int i;
> @@ -155,6 +200,37 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>   	    NULL == add->pages)
>   		goto err;
>   
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +	add->dma_flags = dma_flags;
> +
> +	/*
> +	 * Check if this mapping is requested to be backed
> +	 * by a DMA buffer.
> +	 */
> +	if (dma_flags & (GNTDEV_DMA_FLAG_WC | GNTDEV_DMA_FLAG_COHERENT)) {
> +		struct gnttab_dma_alloc_args args;
> +
> +		add->frames = kcalloc(count, sizeof(add->frames[0]),
> +				      GFP_KERNEL);
> +		if (!add->frames)
> +			goto err;
> +
> +		/* Remember the device, so we can free DMA memory. */
> +		add->dma_dev = priv->dma_dev;
> +
> +		args.dev = priv->dma_dev;
> +		args.coherent = !!(dma_flags & GNTDEV_DMA_FLAG_COHERENT);
> +		args.nr_pages = count;
> +		args.pages = add->pages;
> +		args.frames = add->frames;
> +
> +		if (gnttab_dma_alloc_pages(&args))
> +			goto err;
> +
> +		add->dma_vaddr = args.vaddr;
> +		add->dma_bus_addr = args.dev_bus_addr;
> +	} else
> +#endif
>   	if (gnttab_alloc_pages(count, add->pages))
>   		goto err;
>   
> @@ -325,6 +401,14 @@ static int map_grant_pages(struct grant_map *map)
>   		map->unmap_ops[i].handle = map->map_ops[i].handle;
>   		if (use_ptemod)
>   			map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +		else if (map->dma_vaddr) {
> +			unsigned long bfn;
> +
> +			bfn = pfn_to_bfn(page_to_pfn(map->pages[i]));
> +			map->unmap_ops[i].dev_bus_addr = __pfn_to_phys(bfn);
> +		}
> +#endif
>   	}
>   	return err;
>   }
> @@ -548,6 +632,17 @@ static int gntdev_open(struct inode *inode, struct file *flip)
>   	}
>   
>   	flip->private_data = priv;
> +#ifdef CONFIG_XEN_GRANT_DMA_ALLOC
> +	priv->dma_dev = gntdev_miscdev.this_device;
> +
> +	/*
> +	 * The device is not spawn from a device tree, so arch_setup_dma_ops
> +	 * is not called, thus leaving the device with dummy DMA ops.
> +	 * Fix this by calling of_dma_configure() with a NULL node to set
> +	 * default DMA ops.
> +	 */
> +	of_dma_configure(priv->dma_dev, NULL);
> +#endif
>   	pr_debug("priv %p\n", priv);
>   
>   	return 0;
> @@ -589,7 +684,7 @@ static long gntdev_ioctl_map_grant_ref(struct gntdev_priv *priv,
>   		return -EINVAL;
>   
>   	err = -ENOMEM;
> -	map = gntdev_alloc_map(priv, op.count);
> +	map = gntdev_alloc_map(priv, op.count, 0 /* This is not a dma-buf. */);
>   	if (!map)
>   		return err;
>   
> diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
> index 6d1163456c03..4b9d498a31d4 100644
> --- a/include/uapi/xen/gntdev.h
> +++ b/include/uapi/xen/gntdev.h
> @@ -200,4 +200,19 @@ struct ioctl_gntdev_grant_copy {
>   /* Send an interrupt on the indicated event channel */
>   #define UNMAP_NOTIFY_SEND_EVENT 0x2
>   
> +/*
> + * Flags to be used while requesting memory mapping's backing storage
> + * to be allocated with DMA API.
> + */
> +
> +/*
> + * The buffer is backed with memory allocated with dma_alloc_wc.
> + */
> +#define GNTDEV_DMA_FLAG_WC		(1 << 0)
> +
> +/*
> + * The buffer is backed with memory allocated with dma_alloc_coherent.
> + */
> +#define GNTDEV_DMA_FLAG_COHERENT	(1 << 1)
> +
>   #endif /* __LINUX_PUBLIC_GNTDEV_H__ */


--------------F4451C5F6BC93CF3F350F4FA
Content-Type: text/x-patch;
 name="0001-xen-gntdev-fix-of_dma_configure-API-change.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-xen-gntdev-fix-of_dma_configure-API-change.patch"

>From bd96819f5c3fd94b878698ec8c1579c7115ff293 Mon Sep 17 00:00:00 2001
From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Date: Fri, 15 Jun 2018 08:55:57 +0300
Subject: [PATCH] xen/gntdev: fix of_dma_configure API change

Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
---
 drivers/xen/gntdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 46cee32c2a37..fd680a8c8ece 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -604,7 +604,7 @@ static int gntdev_open(struct inode *inode, struct file *flip)
 	 * Fix this by calling of_dma_configure() with a NULL node to set
 	 * default DMA ops.
 	 */
-	of_dma_configure(priv->dma_dev, NULL);
+	of_dma_configure(priv->dma_dev, NULL, true);
 #endif
 	pr_debug("priv %p\n", priv);
 
-- 
2.17.1


--------------F4451C5F6BC93CF3F350F4FA--
