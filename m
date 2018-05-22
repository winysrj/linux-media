Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:43760 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbeEVF5z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 01:57:55 -0400
Subject: Re: [Xen-devel][RFC 3/3] xen/gntdev: Add support for Linux dma
 buffers
To: Dongwon Kim <dongwon.kim@intel.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, daniel.vetter@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180517082604.14828-1-andr2000@gmail.com>
 <20180517082604.14828-4-andr2000@gmail.com>
 <20180521213102.GA9515@downor-Z87X-UD5H>
From: Oleksandr Andrushchenko <andr2000@gmail.com>
Message-ID: <30c2af3d-eb78-b8d5-7686-073b11e40cf7@gmail.com>
Date: Tue, 22 May 2018 08:57:50 +0300
MIME-Version: 1.0
In-Reply-To: <20180521213102.GA9515@downor-Z87X-UD5H>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/22/2018 12:31 AM, Dongwon Kim wrote:
> Still need more time to review the whole code changes
Take your time, I just wanted to make sure that all interested parties
are in the discussion, so we all finally have what we all want, not
a thing covering only my use-cases
>   but I noticed one thing.
>
> We've been using the term "hyper_dmabuf" for hypervisor-agnostic linux dmabuf
> solution and we are planning to call any of our future solution for other
> hypervisors the same name. So having same name for this xen-specific structure
> or functions you implemented is confusing. Would you change it to something
> else like... "xen_...."?
Np, will rename
>
> On Thu, May 17, 2018 at 11:26:04AM +0300, Oleksandr Andrushchenko wrote:
>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>
>> Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>> ---
>>   drivers/xen/gntdev.c      | 954 +++++++++++++++++++++++++++++++++++++-
>>   include/uapi/xen/gntdev.h | 101 ++++
>>   include/xen/gntdev_exp.h  |  23 +
>>   3 files changed, 1066 insertions(+), 12 deletions(-)
>>   create mode 100644 include/xen/gntdev_exp.h
>>
>> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
>> index 9510f228efe9..0ee88e193362 100644
>> --- a/drivers/xen/gntdev.c
>> +++ b/drivers/xen/gntdev.c
>> @@ -4,6 +4,8 @@
>>    * Device for accessing (in user-space) pages that have been granted by other
>>    * domains.
>>    *
>> + * DMA buffer implementation is based on drivers/gpu/drm/drm_prime.c.
>> + *
>>    * Copyright (c) 2006-2007, D G Murray.
>>    *           (c) 2009 Gerd Hoffmann <kraxel@redhat.com>
>>    *
>> @@ -37,6 +39,9 @@
>>   #include <linux/highmem.h>
>>   #include <linux/refcount.h>
>>   
>> +#include <linux/dma-buf.h>
>> +#include <linux/of_device.h>
>> +
>>   #include <xen/xen.h>
>>   #include <xen/grant_table.h>
>>   #include <xen/balloon.h>
>> @@ -61,16 +66,39 @@ static atomic_t pages_mapped = ATOMIC_INIT(0);
>>   static int use_ptemod;
>>   #define populate_freeable_maps use_ptemod
>>   
>> +#ifndef GRANT_INVALID_REF
>> +/*
>> + * Note on usage of grant reference 0 as invalid grant reference:
>> + * grant reference 0 is valid, but never exposed to a driver,
>> + * because of the fact it is already in use/reserved by the PV console.
>> + */
>> +#define GRANT_INVALID_REF	0
>> +#endif
>> +
>>   struct gntdev_priv {
>>   	/* maps with visible offsets in the file descriptor */
>>   	struct list_head maps;
>>   	/* maps that are not visible; will be freed on munmap.
>>   	 * Only populated if populate_freeable_maps == 1 */
>>   	struct list_head freeable_maps;
>> +	/* List of dma-bufs. */
>> +	struct list_head dma_bufs;
>>   	/* lock protects maps and freeable_maps */
>>   	struct mutex lock;
>>   	struct mm_struct *mm;
>>   	struct mmu_notifier mn;
>> +
>> +	/* Private data of the hyper DMA buffers. */
>> +
>> +	struct device *dev;
>> +	/* List of exported DMA buffers. */
>> +	struct list_head dmabuf_exp_list;
>> +	/* List of wait objects. */
>> +	struct list_head dmabuf_exp_wait_list;
>> +	/* List of imported DMA buffers. */
>> +	struct list_head dmabuf_imp_list;
>> +	/* This is the lock which protects dma_buf_xxx lists. */
>> +	struct mutex dmabuf_lock;
>>   };
>>   
>>   struct unmap_notify {
>> @@ -95,10 +123,65 @@ struct grant_map {
>>   	struct gnttab_unmap_grant_ref *kunmap_ops;
>>   	struct page **pages;
>>   	unsigned long pages_vm_start;
>> +
>> +	/*
>> +	 * All the fields starting with dmabuf_ are only valid if this
>> +	 * mapping is used for exporting a DMA buffer.
>> +	 * If dmabuf_vaddr is not NULL then this mapping is backed by DMA
>> +	 * capable memory.
>> +	 */
>> +
>> +	/* Flags used to create this DMA buffer: GNTDEV_DMABUF_FLAG_XXX. */
>> +	bool dmabuf_flags;
>> +	/* Virtual/CPU address of the DMA buffer. */
>> +	void *dmabuf_vaddr;
>> +	/* Bus address of the DMA buffer. */
>> +	dma_addr_t dmabuf_bus_addr;
>> +};
>> +
>> +struct hyper_dmabuf {
>> +	struct gntdev_priv *priv;
>> +	struct dma_buf *dmabuf;
>> +	struct list_head next;
>> +	int fd;
>> +
>> +	union {
>> +		struct {
>> +			/* Exported buffers are reference counted. */
>> +			struct kref refcount;
>> +			struct grant_map *map;
>> +		} exp;
>> +		struct {
>> +			/* Granted references of the imported buffer. */
>> +			grant_ref_t *refs;
>> +			/* Scatter-gather table of the imported buffer. */
>> +			struct sg_table *sgt;
>> +			/* dma-buf attachment of the imported buffer. */
>> +			struct dma_buf_attachment *attach;
>> +		} imp;
>> +	} u;
>> +
>> +	/* Number of pages this buffer has. */
>> +	int nr_pages;
>> +	/* Pages of this buffer. */
>> +	struct page **pages;
>> +};
>> +
>> +struct hyper_dmabuf_wait_obj {
>> +	struct list_head next;
>> +	struct hyper_dmabuf *hyper_dmabuf;
>> +	struct completion completion;
>> +};
>> +
>> +struct hyper_dambuf_attachment {
> minor typo: dam->dma (same thing in other places as well.)
sure, thanks
>
>> +	struct sg_table *sgt;
>> +	enum dma_data_direction dir;
>>   };
>>   
>>   static int unmap_grant_pages(struct grant_map *map, int offset, int pages);
>>   
>> +static struct miscdevice gntdev_miscdev;
>> +
>>   /* ------------------------------------------------------------------ */
>>   
>>   static void gntdev_print_maps(struct gntdev_priv *priv,
>> @@ -120,8 +203,17 @@ static void gntdev_free_map(struct grant_map *map)
>>   	if (map == NULL)
>>   		return;
>>   
>> -	if (map->pages)
>> +	if (map->dmabuf_vaddr) {
>> +		bool coherent = map->dmabuf_flags &
>> +			GNTDEV_DMABUF_FLAG_DMA_COHERENT;
>> +
>> +		gnttab_dma_free_pages(gntdev_miscdev.this_device,
>> +				      coherent, map->count, map->pages,
>> +				      map->dmabuf_vaddr, map->dmabuf_bus_addr);
>> +	} else if (map->pages) {
>>   		gnttab_free_pages(map->count, map->pages);
>> +	}
>> +
>>   	kfree(map->pages);
>>   	kfree(map->grants);
>>   	kfree(map->map_ops);
>> @@ -131,7 +223,7 @@ static void gntdev_free_map(struct grant_map *map)
>>   	kfree(map);
>>   }
>>   
>> -static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>> +static struct grant_map *gntdev_alloc_map(int count, int dmabuf_flags)
>>   {
>>   	struct grant_map *add;
>>   	int i;
>> @@ -154,8 +246,26 @@ static struct grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count)
>>   	    NULL == add->pages)
>>   		goto err;
>>   
>> -	if (gnttab_alloc_pages(count, add->pages))
>> -		goto err;
>> +	add->dmabuf_flags = dmabuf_flags;
>> +
>> +	/*
>> +	 * Check if this mapping is requested to be backed
>> +	 * by a DMA buffer.
>> +	 */
>> +	if (dmabuf_flags & (GNTDEV_DMABUF_FLAG_DMA_WC |
>> +		     GNTDEV_DMABUF_FLAG_DMA_COHERENT)) {
>> +		bool coherent = dmabuf_flags & GNTDEV_DMABUF_FLAG_DMA_COHERENT;
>> +
>> +		if (gnttab_dma_alloc_pages(gntdev_miscdev.this_device,
>> +					   coherent,
>> +					   count, add->pages,
>> +					   &add->dmabuf_vaddr,
>> +					   &add->dmabuf_bus_addr))
>> +			goto err;
>> +	} else {
>> +		if (gnttab_alloc_pages(count, add->pages))
>> +			goto err;
>> +	}
>>   
>>   	for (i = 0; i < count; i++) {
>>   		add->map_ops[i].handle = -1;
>> @@ -233,6 +343,15 @@ static void gntdev_put_map(struct gntdev_priv *priv, struct grant_map *map)
>>   	gntdev_free_map(map);
>>   }
>>   
>> +static void gntdev_put_map_unlink(struct gntdev_priv *priv,
>> +				  struct grant_map *map)
>> +{
>> +	mutex_lock(&priv->lock);
>> +	list_del(&map->next);
>> +	gntdev_put_map(NULL /* already removed */, map);
>> +	mutex_unlock(&priv->lock);
>> +}
>> +
>>   /* ------------------------------------------------------------------ */
>>   
>>   static int find_grant_ptes(pte_t *pte, pgtable_t token,
>> @@ -324,6 +443,12 @@ static int map_grant_pages(struct grant_map *map)
>>   		map->unmap_ops[i].handle = map->map_ops[i].handle;
>>   		if (use_ptemod)
>>   			map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
>> +		else if (map->dmabuf_vaddr) {
>> +			unsigned long mfn;
>> +
>> +			mfn = __pfn_to_mfn(page_to_pfn(map->pages[i]));
>> +			map->unmap_ops[i].dev_bus_addr = __pfn_to_phys(mfn);
>> +		}
>>   	}
>>   	return err;
>>   }
>> @@ -527,19 +652,48 @@ static const struct mmu_notifier_ops gntdev_mmu_ops = {
>>   
>>   /* ------------------------------------------------------------------ */
>>   
>> -static int gntdev_open(struct inode *inode, struct file *flip)
>> +struct gntdev_priv *gntdev_alloc_context(struct device *dev)
>>   {
>>   	struct gntdev_priv *priv;
>> -	int ret = 0;
>>   
>>   	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
>>   	if (!priv)
>> -		return -ENOMEM;
>> +		return ERR_PTR(-ENOMEM);
>>   
>>   	INIT_LIST_HEAD(&priv->maps);
>>   	INIT_LIST_HEAD(&priv->freeable_maps);
>>   	mutex_init(&priv->lock);
>>   
>> +	priv->dev = dev;
>> +	mutex_init(&priv->dmabuf_lock);
>> +	INIT_LIST_HEAD(&priv->dmabuf_exp_list);
>> +	INIT_LIST_HEAD(&priv->dmabuf_exp_wait_list);
>> +	INIT_LIST_HEAD(&priv->dmabuf_imp_list);
>> +
>> +	/*
>> +	 * The device is not spawn from a device tree, so arch_setup_dma_ops
>> +	 * is not called, thus leaving the device with dummy DMA ops.
>> +	 * This makes the device return error on PRIME buffer import, which
>> +	 * is not correct: to fix this call of_dma_configure() with a NULL
>> +	 * node to set default DMA ops.
>> +	 */
>> +	of_dma_configure(dev, NULL);
>> +
>> +	pr_debug("priv %p\n", priv);
>> +
>> +	return priv;
>> +}
>> +EXPORT_SYMBOL(gntdev_alloc_context);
>> +
>> +static int gntdev_open(struct inode *inode, struct file *flip)
>> +{
>> +	struct gntdev_priv *priv;
>> +	int ret = 0;
>> +
>> +	priv = gntdev_alloc_context(gntdev_miscdev.this_device);
>> +	if (IS_ERR(priv))
>> +		return PTR_ERR(priv);
>> +
>>   	if (use_ptemod) {
>>   		priv->mm = get_task_mm(current);
>>   		if (!priv->mm) {
>> @@ -557,14 +711,12 @@ static int gntdev_open(struct inode *inode, struct file *flip)
>>   	}
>>   
>>   	flip->private_data = priv;
>> -	pr_debug("priv %p\n", priv);
>>   
>>   	return 0;
>>   }
>>   
>> -static int gntdev_release(struct inode *inode, struct file *flip)
>> +void gntdev_free_context(struct gntdev_priv *priv)
>>   {
>> -	struct gntdev_priv *priv = flip->private_data;
>>   	struct grant_map *map;
>>   
>>   	pr_debug("priv %p\n", priv);
>> @@ -576,11 +728,28 @@ static int gntdev_release(struct inode *inode, struct file *flip)
>>   		gntdev_put_map(NULL /* already removed */, map);
>>   	}
>>   	WARN_ON(!list_empty(&priv->freeable_maps));
>> +
>>   	mutex_unlock(&priv->lock);
>>   
>> +	WARN(!list_empty(&priv->dmabuf_exp_list),
>> +	     "Removing with non-empty exported DMA buffer list!\n");
>> +	WARN(!list_empty(&priv->dmabuf_exp_wait_list),
>> +	     "Removing with pending wait objects!\n");
>> +	WARN(!list_empty(&priv->dmabuf_imp_list),
>> +	     "Removing with non-empty imported DMA buffer list!\n");
>> +
>> +	kfree(priv);
>> +}
>> +EXPORT_SYMBOL(gntdev_free_context);
>> +
>> +static int gntdev_release(struct inode *inode, struct file *flip)
>> +{
>> +	struct gntdev_priv *priv = flip->private_data;
>> +
>>   	if (use_ptemod)
>>   		mmu_notifier_unregister(&priv->mn, priv->mm);
>> -	kfree(priv);
>> +
>> +	gntdev_free_context(priv);
>>   	return 0;
>>   }
>>   
>> @@ -598,7 +767,7 @@ static long gntdev_ioctl_map_grant_ref(struct gntdev_priv *priv,
>>   		return -EINVAL;
>>   
>>   	err = -ENOMEM;
>> -	map = gntdev_alloc_map(priv, op.count);
>> +	map = gntdev_alloc_map(op.count, 0 /* this is not a dma-buf */);
>>   	if (!map)
>>   		return err;
>>   
>> @@ -949,6 +1118,755 @@ static long gntdev_ioctl_grant_copy(struct gntdev_priv *priv, void __user *u)
>>   	return ret;
>>   }
>>   
>> +/* ------------------------------------------------------------------ */
>> +/* DMA buffer support.                                                */
>> +/* ------------------------------------------------------------------ */
>> +
>> +/* ------------------------------------------------------------------ */
>> +/* Implementation of wait for exported DMA buffer released.           */
>> +/* ------------------------------------------------------------------ */
>> +
>> +static void dmabuf_exp_release(struct kref *kref);
>> +
>> +static struct hyper_dmabuf_wait_obj *
>> +dmabuf_exp_wait_obj_new(struct gntdev_priv *priv,
>> +			struct hyper_dmabuf *hyper_dmabuf)
>> +{
>> +	struct hyper_dmabuf_wait_obj *obj;
>> +
>> +	obj = kzalloc(sizeof(*obj), GFP_KERNEL);
>> +	if (!obj)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	init_completion(&obj->completion);
>> +	obj->hyper_dmabuf = hyper_dmabuf;
>> +
>> +	mutex_lock(&priv->dmabuf_lock);
>> +	list_add(&obj->next, &priv->dmabuf_exp_wait_list);
>> +	/* Put our reference and wait for hyper_dmabuf's release to fire. */
>> +	kref_put(&hyper_dmabuf->u.exp.refcount, dmabuf_exp_release);
>> +	mutex_unlock(&priv->dmabuf_lock);
>> +	return obj;
>> +}
>> +
>> +static void dmabuf_exp_wait_obj_free(struct gntdev_priv *priv,
>> +				     struct hyper_dmabuf_wait_obj *obj)
>> +{
>> +	struct hyper_dmabuf_wait_obj *cur_obj, *q;
>> +
>> +	mutex_lock(&priv->dmabuf_lock);
>> +	list_for_each_entry_safe(cur_obj, q, &priv->dmabuf_exp_wait_list, next)
>> +		if (cur_obj == obj) {
>> +			list_del(&obj->next);
>> +			kfree(obj);
>> +			break;
>> +		}
>> +	mutex_unlock(&priv->dmabuf_lock);
>> +}
>> +
>> +static int dmabuf_exp_wait_obj_wait(struct hyper_dmabuf_wait_obj *obj,
>> +				    u32 wait_to_ms)
>> +{
>> +	if (wait_for_completion_timeout(&obj->completion,
>> +			msecs_to_jiffies(wait_to_ms)) <= 0)
>> +		return -ETIMEDOUT;
>> +
>> +	return 0;
>> +}
>> +
>> +static void dmabuf_exp_wait_obj_signal(struct gntdev_priv *priv,
>> +				       struct hyper_dmabuf *hyper_dmabuf)
>> +{
>> +	struct hyper_dmabuf_wait_obj *obj, *q;
>> +
>> +	list_for_each_entry_safe(obj, q, &priv->dmabuf_exp_wait_list, next)
>> +		if (obj->hyper_dmabuf == hyper_dmabuf) {
>> +			pr_debug("Found hyper_dmabuf in the wait list, wake\n");
>> +			complete_all(&obj->completion);
>> +		}
>> +}
>> +
>> +static struct hyper_dmabuf *
>> +dmabuf_exp_wait_obj_get_by_fd(struct gntdev_priv *priv, int fd)
>> +{
>> +	struct hyper_dmabuf *q, *hyper_dmabuf, *ret = ERR_PTR(-ENOENT);
>> +
>> +	mutex_lock(&priv->dmabuf_lock);
>> +	list_for_each_entry_safe(hyper_dmabuf, q, &priv->dmabuf_exp_list, next)
>> +		if (hyper_dmabuf->fd == fd) {
>> +			pr_debug("Found hyper_dmabuf in the wait list\n");
>> +			kref_get(&hyper_dmabuf->u.exp.refcount);
>> +			ret = hyper_dmabuf;
>> +			break;
>> +		}
>> +	mutex_unlock(&priv->dmabuf_lock);
>> +	return ret;
>> +}
>> +
>> +static int dmabuf_exp_wait_released(struct gntdev_priv *priv, int fd,
>> +				    int wait_to_ms)
>> +{
>> +	struct hyper_dmabuf *hyper_dmabuf;
>> +	struct hyper_dmabuf_wait_obj *obj;
>> +	int ret;
>> +
>> +	pr_debug("Will wait for dma-buf with fd %d\n", fd);
>> +	/*
>> +	 * Try to find the DMA buffer: if not found means that
>> +	 * either the buffer has already been released or file descriptor
>> +	 * provided is wrong.
>> +	 */
>> +	hyper_dmabuf = dmabuf_exp_wait_obj_get_by_fd(priv, fd);
>> +	if (IS_ERR(hyper_dmabuf))
>> +		return PTR_ERR(hyper_dmabuf);
>> +
>> +	/*
>> +	 * hyper_dmabuf still exists and is reference count locked by us now,
>> +	 * so prepare to wait: allocate wait object and add it to the wait list,
>> +	 * so we can find it on release.
>> +	 */
>> +	obj = dmabuf_exp_wait_obj_new(priv, hyper_dmabuf);
>> +	if (IS_ERR(obj)) {
>> +		pr_err("Failed to setup wait object, ret %ld\n", PTR_ERR(obj));
>> +		return PTR_ERR(obj);
>> +	}
>> +
>> +	ret = dmabuf_exp_wait_obj_wait(obj, wait_to_ms);
>> +	dmabuf_exp_wait_obj_free(priv, obj);
>> +	return ret;
>> +}
>> +
>> +/* ------------------------------------------------------------------ */
>> +/* DMA buffer export support.                                         */
>> +/* ------------------------------------------------------------------ */
>> +
>> +static struct sg_table *
>> +dmabuf_pages_to_sgt(struct page **pages, unsigned int nr_pages)
>> +{
>> +	struct sg_table *sgt;
>> +	int ret;
>> +
>> +	sgt = kmalloc(sizeof(struct sg_table), GFP_KERNEL);
>> +	if (!sgt) {
>> +		ret = -ENOMEM;
>> +		goto out;
>> +	}
>> +
>> +	ret = sg_alloc_table_from_pages(sgt, pages, nr_pages, 0,
>> +					nr_pages << PAGE_SHIFT,
>> +					GFP_KERNEL);
>> +	if (ret)
>> +		goto out;
>> +
>> +	return sgt;
>> +
>> +out:
>> +	kfree(sgt);
>> +	return ERR_PTR(ret);
>> +}
>> +
>> +static int dmabuf_exp_ops_attach(struct dma_buf *dma_buf,
>> +				 struct device *target_dev,
>> +				 struct dma_buf_attachment *attach)
>> +{
>> +	struct hyper_dambuf_attachment *hyper_dambuf_attach;
>> +
>> +	hyper_dambuf_attach = kzalloc(sizeof(*hyper_dambuf_attach), GFP_KERNEL);
>> +	if (!hyper_dambuf_attach)
>> +		return -ENOMEM;
>> +
>> +	hyper_dambuf_attach->dir = DMA_NONE;
>> +	attach->priv = hyper_dambuf_attach;
>> +	/* Might need to pin the pages of the buffer now. */
>> +	return 0;
>> +}
>> +
>> +static void dmabuf_exp_ops_detach(struct dma_buf *dma_buf,
>> +				  struct dma_buf_attachment *attach)
>> +{
>> +	struct hyper_dambuf_attachment *hyper_dambuf_attach = attach->priv;
>> +
>> +	if (hyper_dambuf_attach) {
>> +		struct sg_table *sgt = hyper_dambuf_attach->sgt;
>> +
>> +		if (sgt) {
>> +			if (hyper_dambuf_attach->dir != DMA_NONE)
>> +				dma_unmap_sg_attrs(attach->dev, sgt->sgl,
>> +						   sgt->nents,
>> +						   hyper_dambuf_attach->dir,
>> +						   DMA_ATTR_SKIP_CPU_SYNC);
>> +			sg_free_table(sgt);
>> +		}
>> +
>> +		kfree(sgt);
>> +		kfree(hyper_dambuf_attach);
>> +		attach->priv = NULL;
>> +	}
>> +	/* Might need to unpin the pages of the buffer now. */
>> +}
>> +
>> +static struct sg_table *
>> +dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
>> +			   enum dma_data_direction dir)
>> +{
>> +	struct hyper_dambuf_attachment *hyper_dambuf_attach = attach->priv;
>> +	struct hyper_dmabuf *hyper_dmabuf = attach->dmabuf->priv;
>> +	struct sg_table *sgt;
>> +
>> +	pr_debug("Mapping %d pages for dev %p\n", hyper_dmabuf->nr_pages,
>> +		 attach->dev);
>> +
>> +	if (WARN_ON(dir == DMA_NONE || !hyper_dambuf_attach))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	/* Return the cached mapping when possible. */
>> +	if (hyper_dambuf_attach->dir == dir)
>> +		return hyper_dambuf_attach->sgt;
>> +
>> +	/*
>> +	 * Two mappings with different directions for the same attachment are
>> +	 * not allowed.
>> +	 */
>> +	if (WARN_ON(hyper_dambuf_attach->dir != DMA_NONE))
>> +		return ERR_PTR(-EBUSY);
>> +
>> +	sgt = dmabuf_pages_to_sgt(hyper_dmabuf->pages, hyper_dmabuf->nr_pages);
>> +	if (!IS_ERR(sgt)) {
>> +		if (!dma_map_sg_attrs(attach->dev, sgt->sgl, sgt->nents, dir,
>> +				      DMA_ATTR_SKIP_CPU_SYNC)) {
>> +			sg_free_table(sgt);
>> +			kfree(sgt);
>> +			sgt = ERR_PTR(-ENOMEM);
>> +		} else {
>> +			hyper_dambuf_attach->sgt = sgt;
>> +			hyper_dambuf_attach->dir = dir;
>> +		}
>> +	}
>> +	if (IS_ERR(sgt)
>> +		pr_err("Failed to map sg table for dev %p\n", attach->dev);
>> +	return sgt;
>> +}
>> +
>> +static void dmabuf_exp_ops_unmap_dma_buf(struct dma_buf_attachment *attach,
>> +					 struct sg_table *sgt,
>> +					 enum dma_data_direction dir)
>> +{
>> +	/* Not implemented. The unmap is done at dmabuf_exp_ops_detach(). */
>> +}
>> +
>> +static void dmabuf_exp_release(struct kref *kref)
>> +{
>> +	struct hyper_dmabuf *hyper_dmabuf =
>> +		container_of(kref, struct hyper_dmabuf,
>> +			     u.exp.refcount);
>> +
>> +	dmabuf_exp_wait_obj_signal(hyper_dmabuf->priv, hyper_dmabuf);
>> +	list_del(&hyper_dmabuf->next);
>> +	kfree(hyper_dmabuf);
>> +}
>> +
>> +static void dmabuf_exp_ops_release(struct dma_buf *dma_buf)
>> +{
>> +	struct hyper_dmabuf *hyper_dmabuf = dma_buf->priv;
>> +	struct gntdev_priv *priv = hyper_dmabuf->priv;
>> +
>> +	gntdev_put_map_unlink(priv, hyper_dmabuf->u.exp.map);
>> +	mutex_lock(&priv->dmabuf_lock);
>> +	kref_put(&hyper_dmabuf->u.exp.refcount, dmabuf_exp_release);
>> +	mutex_unlock(&priv->dmabuf_lock);
>> +}
>> +
>> +static void *dmabuf_exp_ops_kmap_atomic(struct dma_buf *dma_buf,
>> +					unsigned long page_num)
>> +{
>> +	/* Not implemented. */
>> +	return NULL;
>> +}
>> +
>> +static void *dmabuf_exp_ops_kmap(struct dma_buf *dma_buf,
>> +				 unsigned long page_num)
>> +{
>> +	/* Not implemented. */
>> +	return NULL;
>> +}
>> +
>> +static int dmabuf_exp_ops_mmap(struct dma_buf *dma_buf,
>> +			       struct vm_area_struct *vma)
>> +{
>> +	/* Not implemented. */
>> +	return 0;
>> +}
>> +
>> +static const struct dma_buf_ops dmabuf_exp_ops =  {
>> +	.attach = dmabuf_exp_ops_attach,
>> +	.detach = dmabuf_exp_ops_detach,
>> +	.map_dma_buf = dmabuf_exp_ops_map_dma_buf,
>> +	.unmap_dma_buf = dmabuf_exp_ops_unmap_dma_buf,
>> +	.release = dmabuf_exp_ops_release,
>> +	.kmap = dmabuf_exp_ops_kmap,
>> +	.kmap_atomic = dmabuf_exp_ops_kmap_atomic,
>> +	.mmap = dmabuf_exp_ops_mmap,
>> +};
>> +
>> +static int dmabuf_export(struct gntdev_priv *priv, struct grant_map *map,
>> +			 int *fd)
>> +{
>> +	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>> +	struct hyper_dmabuf *hyper_dmabuf;
>> +	int ret = 0;
>> +
>> +	hyper_dmabuf = kzalloc(sizeof(*hyper_dmabuf), GFP_KERNEL);
>> +	if (!hyper_dmabuf)
>> +		return -ENOMEM;
>> +
>> +	kref_init(&hyper_dmabuf->u.exp.refcount);
>> +
>> +	hyper_dmabuf->priv = priv;
>> +	hyper_dmabuf->nr_pages = map->count;
>> +	hyper_dmabuf->pages = map->pages;
>> +	hyper_dmabuf->u.exp.map = map;
>> +
>> +	exp_info.exp_name = KBUILD_MODNAME;
>> +	exp_info.ops = &dmabuf_exp_ops;
>> +	exp_info.size = map->count << PAGE_SHIFT;
>> +	exp_info.flags = O_RDWR;
>> +	exp_info.priv = hyper_dmabuf;
>> +
>> +	hyper_dmabuf->dmabuf = dma_buf_export(&exp_info);
>> +	if (IS_ERR(hyper_dmabuf->dmabuf)) {
>> +		ret = PTR_ERR(hyper_dmabuf->dmabuf);
>> +		hyper_dmabuf->dmabuf = NULL;
>> +		goto fail;
>> +	}
>> +
>> +	ret = dma_buf_fd(hyper_dmabuf->dmabuf, O_CLOEXEC);
>> +	if (ret < 0)
>> +		goto fail;
>> +
>> +	hyper_dmabuf->fd = ret;
>> +	*fd = ret;
>> +
>> +	pr_debug("Exporting DMA buffer with fd %d\n", ret);
>> +
>> +	mutex_lock(&priv->dmabuf_lock);
>> +	list_add(&hyper_dmabuf->next, &priv->dmabuf_exp_list);
>> +	mutex_unlock(&priv->dmabuf_lock);
>> +	return 0;
>> +
>> +fail:
>> +	if (hyper_dmabuf->dmabuf)
>> +		dma_buf_put(hyper_dmabuf->dmabuf);
>> +	kfree(hyper_dmabuf);
>> +	return ret;
>> +}
>> +
>> +static struct grant_map *
>> +dmabuf_exp_alloc_backing_storage(int dmabuf_flags, int count)
>> +{
>> +	struct grant_map *map;
>> +
>> +	if (unlikely(count <= 0))
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	if ((dmabuf_flags & GNTDEV_DMABUF_FLAG_DMA_WC) &&
>> +	    (dmabuf_flags & GNTDEV_DMABUF_FLAG_DMA_COHERENT)) {
>> +		pr_err("Wrong dma-buf flags: either WC or coherent, not both\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	map = gntdev_alloc_map(count, dmabuf_flags);
>> +	if (!map)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	if (unlikely(atomic_add_return(count, &pages_mapped) > limit)) {
>> +		pr_err("can't map: over limit\n");
>> +		gntdev_put_map(NULL, map);
>> +		return ERR_PTR(-ENOMEM);
>> +	}
>> +	return map;
>> +}
>> +
>> +int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
>> +				int count, u32 domid, u32 *refs, u32 *fd)
>> +{
>> +	struct grant_map *map;
>> +	int i, ret;
>> +
>> +	*fd = -1;
>> +
>> +	if (use_ptemod) {
>> +		pr_err("Cannot provide dma-buf: use_ptemode %d\n",
>> +		       use_ptemod);
>> +		return -EINVAL;
>> +	}
>> +
>> +	map = dmabuf_exp_alloc_backing_storage(flags, count);
>> +	if (IS_ERR(map))
>> +		return PTR_ERR(map);
>> +
>> +	for (i = 0; i < count; i++) {
>> +		map->grants[i].domid = domid;
>> +		map->grants[i].ref = refs[i];
>> +	}
>> +
>> +	mutex_lock(&priv->lock);
>> +	gntdev_add_map(priv, map);
>> +	mutex_unlock(&priv->lock);
>> +
>> +	map->flags |= GNTMAP_host_map;
>> +#if defined(CONFIG_X86)
>> +	map->flags |= GNTMAP_device_map;
>> +#endif
>> +
>> +	ret = map_grant_pages(map);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	ret = dmabuf_export(priv, map, fd);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	return 0;
>> +
>> +out:
>> +	gntdev_put_map_unlink(priv, map);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(gntdev_dmabuf_exp_from_refs);
>> +
>> +static long
>> +gntdev_ioctl_dmabuf_exp_from_refs(struct gntdev_priv *priv,
>> +				  struct ioctl_gntdev_dmabuf_exp_from_refs __user *u)
>> +{
>> +	struct ioctl_gntdev_dmabuf_exp_from_refs op;
>> +	u32 *refs;
>> +	long ret;
>> +
>> +	if (copy_from_user(&op, u, sizeof(op)) != 0)
>> +		return -EFAULT;
>> +
>> +	refs = kcalloc(op.count, sizeof(*refs), GFP_KERNEL);
>> +	if (!refs)
>> +		return -ENOMEM;
>> +
>> +	if (copy_from_user(refs, u->refs, sizeof(*refs) * op.count) != 0) {
>> +		ret = -EFAULT;
>> +		goto out;
>> +	}
>> +
>> +	ret = gntdev_dmabuf_exp_from_refs(priv, op.flags, op.count,
>> +					  op.domid, refs, &op.fd);
>> +	if (ret)
>> +		goto out;
>> +
>> +	if (copy_to_user(u, &op, sizeof(op)) != 0)
>> +		ret = -EFAULT;
>> +
>> +out:
>> +	kfree(refs);
>> +	return ret;
>> +}
>> +
>> +static long
>> +gntdev_ioctl_dmabuf_exp_wait_released(struct gntdev_priv *priv,
>> +				      struct ioctl_gntdev_dmabuf_exp_wait_released __user *u)
>> +{
>> +	struct ioctl_gntdev_dmabuf_exp_wait_released op;
>> +
>> +	if (copy_from_user(&op, u, sizeof(op)) != 0)
>> +		return -EFAULT;
>> +
>> +	return dmabuf_exp_wait_released(priv, op.fd, op.wait_to_ms);
>> +}
>> +
>> +int gntdev_dmabuf_exp_wait_released(struct gntdev_priv *priv, u32 fd,
>> +				    int wait_to_ms)
>> +{
>> +	return dmabuf_exp_wait_released(priv, fd, wait_to_ms);
>> +}
>> +EXPORT_SYMBOL(gntdev_dmabuf_exp_wait_released);
>> +
>> +/* ------------------------------------------------------------------ */
>> +/* DMA buffer import support.                                         */
>> +/* ------------------------------------------------------------------ */
>> +
>> +static int
>> +dmabuf_imp_grant_foreign_access(struct page **pages, u32 *refs,
>> +				int count, int domid)
>> +{
>> +	grant_ref_t priv_gref_head;
>> +	int i, ret;
>> +
>> +	ret = gnttab_alloc_grant_references(count, &priv_gref_head);
>> +	if (ret < 0) {
>> +		pr_err("Cannot allocate grant references, ret %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	for (i = 0; i < count; i++) {
>> +		int cur_ref;
>> +
>> +		cur_ref = gnttab_claim_grant_reference(&priv_gref_head);
>> +		if (cur_ref < 0) {
>> +			ret = cur_ref;
>> +			pr_err("Cannot claim grant reference, ret %d\n", ret);
>> +			goto out;
>> +		}
>> +
>> +		gnttab_grant_foreign_access_ref(cur_ref, domid,
>> +						xen_page_to_gfn(pages[i]), 0);
>> +		refs[i] = cur_ref;
>> +	}
>> +
>> +	ret = 0;
>> +
>> +out:
>> +	gnttab_free_grant_references(priv_gref_head);
>> +	return ret;
>> +}
>> +
>> +static void dmabuf_imp_end_foreign_access(u32 *refs, int count)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < count; i++)
>> +		if (refs[i] != GRANT_INVALID_REF)
>> +			gnttab_end_foreign_access(refs[i], 0, 0UL);
>> +}
>> +
>> +static void dmabuf_imp_free_storage(struct hyper_dmabuf *hyper_dmabuf)
>> +{
>> +	kfree(hyper_dmabuf->pages);
>> +	kfree(hyper_dmabuf->u.imp.refs);
>> +	kfree(hyper_dmabuf);
>> +}
>> +
>> +static struct hyper_dmabuf *dmabuf_imp_alloc_storage(int count)
>> +{
>> +	struct hyper_dmabuf *hyper_dmabuf;
>> +	int i;
>> +
>> +	hyper_dmabuf = kzalloc(sizeof(*hyper_dmabuf), GFP_KERNEL);
>> +	if (!hyper_dmabuf)
>> +		goto fail;
>> +
>> +	hyper_dmabuf->u.imp.refs = kcalloc(count,
>> +					   sizeof(hyper_dmabuf->u.imp.refs[0]),
>> +					   GFP_KERNEL);
>> +	if (!hyper_dmabuf->u.imp.refs)
>> +		goto fail;
>> +
>> +	hyper_dmabuf->pages = kcalloc(count,
>> +				      sizeof(hyper_dmabuf->pages[0]),
>> +				      GFP_KERNEL);
>> +	if (!hyper_dmabuf->pages)
>> +		goto fail;
>> +
>> +	hyper_dmabuf->nr_pages = count;
>> +
>> +	for (i = 0; i < count; i++)
>> +	     hyper_dmabuf->u.imp.refs[i] = GRANT_INVALID_REF;
>> +
>> +	return hyper_dmabuf;
>> +
>> +fail:
>> +	dmabuf_imp_free_storage(hyper_dmabuf);
>> +	return ERR_PTR(-ENOMEM);
>> +}
>> +
>> +static struct hyper_dmabuf *
>> +dmabuf_import(struct gntdev_priv *priv, int fd, int count, int domid)
>> +{
>> +	struct hyper_dmabuf *hyper_dmabuf, *ret;
>> +	struct dma_buf *dma_buf;
>> +	struct dma_buf_attachment *attach;
>> +	struct sg_table *sgt;
>> +	struct sg_page_iter sg_iter;
>> +	int i;
>> +
>> +	dma_buf = dma_buf_get(fd);
>> +	if (IS_ERR(dma_buf))
>> +		return ERR_CAST(dma_buf);
>> +
>> +	hyper_dmabuf = dmabuf_imp_alloc_storage(count);
>> +	if (IS_ERR(hyper_dmabuf)) {
>> +		ret = hyper_dmabuf;
>> +		goto fail_put;
>> +	}
>> +
>> +	hyper_dmabuf->priv = priv;
>> +	hyper_dmabuf->fd = fd;
>> +
>> +	attach = dma_buf_attach(dma_buf, priv->dev);
>> +	if (IS_ERR(attach)) {
>> +		ret = ERR_CAST(attach);
>> +		goto fail_free_obj;
>> +	}
>> +
>> +	hyper_dmabuf->u.imp.attach = attach;
>> +
>> +	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
>> +	if (IS_ERR(sgt)) {
>> +		ret = ERR_CAST(sgt);
>> +		goto fail_detach;
>> +	}
>> +
>> +	/* Check number of pages that imported buffer has. */
>> +	if (attach->dmabuf->size != hyper_dmabuf->nr_pages << PAGE_SHIFT) {
>> +		ret = ERR_PTR(-EINVAL);
>> +		pr_err("DMA buffer has %zu pages, user-space expects %d\n",
>> +		       attach->dmabuf->size, hyper_dmabuf->nr_pages);
>> +		goto fail_unmap;
>> +	}
>> +
>> +	hyper_dmabuf->u.imp.sgt = sgt;
>> +
>> +	/* Now convert sgt to array of pages and check for page validity. */
>> +	i = 0;
>> +	for_each_sg_page(sgt->sgl, &sg_iter, sgt->nents, 0) {
>> +		struct page *page = sg_page_iter_page(&sg_iter);
>> +		/*
>> +		 * Check if page is valid: this can happen if we are given
>> +		 * a page from VRAM or other resources which are not backed
>> +		 * by a struct page.
>> +		 */
>> +		if (!pfn_valid(page_to_pfn(page))) {
>> +			ret = ERR_PTR(-EINVAL);
>> +			goto fail_unmap;
>> +		}
>> +
>> +		hyper_dmabuf->pages[i++] = page;
>> +	}
>> +
>> +	ret = ERR_PTR(dmabuf_imp_grant_foreign_access(hyper_dmabuf->pages,
>> +						      hyper_dmabuf->u.imp.refs,
>> +						      count, domid));
>> +	if (IS_ERR(ret))
>> +		goto fail_end_access;
>> +
>> +	pr_debug("Imported DMA buffer with fd %d\n", fd);
>> +
>> +	mutex_lock(&priv->dmabuf_lock);
>> +	list_add(&hyper_dmabuf->next, &priv->dmabuf_imp_list);
>> +	mutex_unlock(&priv->dmabuf_lock);
>> +
>> +	return hyper_dmabuf;
>> +
>> +fail_end_access:
>> +	dmabuf_imp_end_foreign_access(hyper_dmabuf->u.imp.refs, count);
>> +fail_unmap:
>> +	dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
>> +fail_detach:
>> +	dma_buf_detach(dma_buf, attach);
>> +fail_free_obj:
>> +	dmabuf_imp_free_storage(hyper_dmabuf);
>> +fail_put:
>> +	dma_buf_put(dma_buf);
>> +	return ret;
>> +}
>> +
>> +/*
>> + * Find the hyper dma-buf by its file descriptor and remove
>> + * it from the buffer's list.
>> + */
>> +static struct hyper_dmabuf *
>> +dmabuf_imp_find_unlink(struct gntdev_priv *priv, int fd)
>> +{
>> +	struct hyper_dmabuf *q, *hyper_dmabuf, *ret = ERR_PTR(-ENOENT);
>> +
>> +	mutex_lock(&priv->dmabuf_lock);
>> +	list_for_each_entry_safe(hyper_dmabuf, q, &priv->dmabuf_imp_list, next) {
>> +		if (hyper_dmabuf->fd == fd) {
>> +			pr_debug("Found hyper_dmabuf in the import list\n");
>> +			ret = hyper_dmabuf;
>> +			list_del(&hyper_dmabuf->next);
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&priv->dmabuf_lock);
>> +	return ret;
>> +}
>> +
>> +int gntdev_dmabuf_imp_release(struct gntdev_priv *priv, u32 fd)
>> +{
>> +	struct hyper_dmabuf *hyper_dmabuf;
>> +	struct dma_buf_attachment *attach;
>> +	struct dma_buf *dma_buf;
>> +
>> +	hyper_dmabuf = dmabuf_imp_find_unlink(priv, fd);
>> +	if (IS_ERR(hyper_dmabuf))
>> +		return PTR_ERR(hyper_dmabuf);
>> +
>> +	pr_debug("Releasing DMA buffer with fd %d\n", fd);
>> +
>> +	attach = hyper_dmabuf->u.imp.attach;
>> +
>> +	if (hyper_dmabuf->u.imp.sgt)
>> +		dma_buf_unmap_attachment(attach, hyper_dmabuf->u.imp.sgt,
>> +					 DMA_BIDIRECTIONAL);
>> +	dma_buf = attach->dmabuf;
>> +	dma_buf_detach(attach->dmabuf, attach);
>> +	dma_buf_put(dma_buf);
>> +
>> +	dmabuf_imp_end_foreign_access(hyper_dmabuf->u.imp.refs,
>> +				      hyper_dmabuf->nr_pages);
>> +	dmabuf_imp_free_storage(hyper_dmabuf);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(gntdev_dmabuf_imp_release);
>> +
>> +static long
>> +gntdev_ioctl_dmabuf_imp_release(struct gntdev_priv *priv,
>> +				struct ioctl_gntdev_dmabuf_imp_release __user *u)
>> +{
>> +	struct ioctl_gntdev_dmabuf_imp_release op;
>> +
>> +	if (copy_from_user(&op, u, sizeof(op)) != 0)
>> +		return -EFAULT;
>> +
>> +	return gntdev_dmabuf_imp_release(priv, op.fd);
>> +}
>> +
>> +static long
>> +gntdev_ioctl_dmabuf_imp_to_refs(struct gntdev_priv *priv,
>> +				struct ioctl_gntdev_dmabuf_imp_to_refs __user *u)
>> +{
>> +	struct ioctl_gntdev_dmabuf_imp_to_refs op;
>> +	struct hyper_dmabuf *hyper_dmabuf;
>> +	long ret;
>> +
>> +	if (copy_from_user(&op, u, sizeof(op)) != 0)
>> +		return -EFAULT;
>> +
>> +	hyper_dmabuf = dmabuf_import(priv, op.fd, op.count, op.domid);
>> +	if (IS_ERR(hyper_dmabuf))
>> +		return PTR_ERR(hyper_dmabuf);
>> +
>> +	if (copy_to_user(u->refs, hyper_dmabuf->u.imp.refs,
>> +			 sizeof(*u->refs) * op.count) != 0) {
>> +		ret = -EFAULT;
>> +		goto out_release;
>> +	}
>> +	return 0;
>> +
>> +out_release:
>> +	gntdev_dmabuf_imp_release(priv, op.fd);
>> +	return ret;
>> +}
>> +
>> +u32 *gntdev_dmabuf_imp_to_refs(struct gntdev_priv *priv, int fd,
>> +			      int count, int domid, u32 **refs)
>> +{
>> +	struct hyper_dmabuf *hyper_dmabuf;
>> +
>> +	hyper_dmabuf = dmabuf_import(priv, fd, count, domid);
>> +	if (IS_ERR(hyper_dmabuf))
>> +		return ERR_CAST(hyper_dmabuf);
>> +
>> +	return hyper_dmabuf->u.imp.refs;
>> +}
>> +EXPORT_SYMBOL(gntdev_dmabuf_imp_to_refs);
>> +
>>   static long gntdev_ioctl(struct file *flip,
>>   			 unsigned int cmd, unsigned long arg)
>>   {
>> @@ -971,6 +1889,18 @@ static long gntdev_ioctl(struct file *flip,
>>   	case IOCTL_GNTDEV_GRANT_COPY:
>>   		return gntdev_ioctl_grant_copy(priv, ptr);
>>   
>> +	case IOCTL_GNTDEV_DMABUF_EXP_FROM_REFS:
>> +		return gntdev_ioctl_dmabuf_exp_from_refs(priv, ptr);
>> +
>> +	case IOCTL_GNTDEV_DMABUF_EXP_WAIT_RELEASED:
>> +		return gntdev_ioctl_dmabuf_exp_wait_released(priv, ptr);
>> +
>> +	case IOCTL_GNTDEV_DMABUF_IMP_TO_REFS:
>> +		return gntdev_ioctl_dmabuf_imp_to_refs(priv, ptr);
>> +
>> +	case IOCTL_GNTDEV_DMABUF_IMP_RELEASE:
>> +		return gntdev_ioctl_dmabuf_imp_release(priv, ptr);
>> +
>>   	default:
>>   		pr_debug("priv %p, unknown cmd %x\n", priv, cmd);
>>   		return -ENOIOCTLCMD;
>> diff --git a/include/uapi/xen/gntdev.h b/include/uapi/xen/gntdev.h
>> index d0661977667e..7cf7ca31db21 100644
>> --- a/include/uapi/xen/gntdev.h
>> +++ b/include/uapi/xen/gntdev.h
>> @@ -199,4 +199,105 @@ struct ioctl_gntdev_grant_copy {
>>   /* Send an interrupt on the indicated event channel */
>>   #define UNMAP_NOTIFY_SEND_EVENT 0x2
>>   
>> +/*
>> + * Create a dma-buf [1] from grant references @refs of count @count provided
>> + * by the foreign domain @domid with flags @flags.
>> + *
>> + * By default dma-buf is backed by system memory pages, but by providing
>> + * GNTDEV_DMABUF_FLAG_DMA flag it can also be created as a DMA write-combine
>> + * buffer, e.g. allocated with dma_alloc_wc.
>> + *
>> + * Returns 0 if dma-buf was successfully created and the corresponding
>> + * dma-buf's file descriptor is returned in @fd.
>> + *
>> + * [1] https://elixir.bootlin.com/linux/latest/source/Documentation/driver-api/dma-buf.rst
>> + */
>> +
>> +/*
>> + * Request dma-buf backing storage to be allocated with DMA API:
>> + * the buffer is backed with memory allocated with dma_alloc_wc.
>> + */
>> +#define GNTDEV_DMABUF_FLAG_DMA_WC	(1 << 1)
>> +
>> +/*
>> + * Request dma-buf backing storage to be allocated with DMA API:
>> + * the buffer is backed with memory allocated with dma_alloc_coherent.
>> + */
>> +#define GNTDEV_DMABUF_FLAG_DMA_COHERENT	(1 << 2)
>> +
>> +#define IOCTL_GNTDEV_DMABUF_EXP_FROM_REFS \
>> +	_IOC(_IOC_NONE, 'G', 9, \
>> +	     sizeof(struct ioctl_gntdev_dmabuf_exp_from_refs))
>> +struct ioctl_gntdev_dmabuf_exp_from_refs {
>> +	/* IN parameters. */
>> +	/* Specific options for this dma-buf: see GNTDEV_DMABUF_FLAG_XXX. */
>> +	__u32 flags;
>> +	/* Number of grant references in @refs array. */
>> +	__u32 count;
>> +	/* OUT parameters. */
>> +	/* File descriptor of the dma-buf. */
>> +	__u32 fd;
>> +	/* The domain ID of the grant references to be mapped. */
>> +	__u32 domid;
>> +	/* Variable IN parameter. */
>> +	/* Array of grant references of size @count. */
>> +	__u32 refs[1];
>> +};
>> +
>> +/*
>> + * This will block until the dma-buf with the file descriptor @fd is
>> + * released. This is only valid for buffers created with
>> + * IOCTL_GNTDEV_DMABUF_EXP_FROM_REFS.
>> + *
>> + * If withing @wait_to_ms milliseconds the buffer is not released
>> + * then -ETIMEDOUT error is returned.
>> + * If the buffer with file descriptor @fd does not exist or has already
>> + * been released, then -ENOENT is returned. For valid file descriptors
>> + * this must not be treated as error.
>> + */
>> +#define IOCTL_GNTDEV_DMABUF_EXP_WAIT_RELEASED \
>> +	_IOC(_IOC_NONE, 'G', 10, \
>> +	     sizeof(struct ioctl_gntdev_dmabuf_exp_wait_released))
>> +struct ioctl_gntdev_dmabuf_exp_wait_released {
>> +	/* IN parameters */
>> +	__u32 fd;
>> +	__u32 wait_to_ms;
>> +};
>> +
>> +/*
>> + * Import a dma-buf with file descriptor @fd and export granted references
>> + * to the pages of that dma-buf into array @refs of size @count.
>> + */
>> +#define IOCTL_GNTDEV_DMABUF_IMP_TO_REFS \
>> +	_IOC(_IOC_NONE, 'G', 11, \
>> +	     sizeof(struct ioctl_gntdev_dmabuf_imp_to_refs))
>> +struct ioctl_gntdev_dmabuf_imp_to_refs {
>> +	/* IN parameters. */
>> +	/* File descriptor of the dma-buf. */
>> +	__u32 fd;
>> +	/* Number of grant references in @refs array. */
>> +	__u32 count;
>> +	/* The domain ID for which references to be granted. */
>> +	__u32 domid;
>> +	/* Reserved - must be zero. */
>> +	__u32 reserved;
>> +	/* OUT parameters. */
>> +	/* Array of grant references of size @count. */
>> +	__u32 refs[1];
>> +};
>> +
>> +/*
>> + * This will close all references to an imported buffer, so it can be
>> + * released by the owner. This is only valid for buffers created with
>> + * IOCTL_GNTDEV_DMABUF_IMP_TO_REFS.
>> + */
>> +#define IOCTL_GNTDEV_DMABUF_IMP_RELEASE \
>> +	_IOC(_IOC_NONE, 'G', 12, \
>> +	     sizeof(struct ioctl_gntdev_dmabuf_imp_release))
>> +struct ioctl_gntdev_dmabuf_imp_release {
>> +	/* IN parameters */
>> +	__u32 fd;
>> +	__u32 reserved;
>> +};
>> +
>>   #endif /* __LINUX_PUBLIC_GNTDEV_H__ */
>> diff --git a/include/xen/gntdev_exp.h b/include/xen/gntdev_exp.h
>> new file mode 100644
>> index 000000000000..aaf45bda30ac
>> --- /dev/null
>> +++ b/include/xen/gntdev_exp.h
>> @@ -0,0 +1,23 @@
>> +/******************************************************************************
>> + * Xen grant device exported functionality
>> + */
>> +
>> +#ifndef _XEN_GNTDEV_EXP_H
>> +#define _XEN_GNTDEV_EXP_H
>> +
>> +struct gntdev_priv *gntdev_alloc_context(struct device *dev);
>> +
>> +void gntdev_free_context(struct gntdev_priv *priv);
>> +
>> +int gntdev_dmabuf_exp_from_refs(struct gntdev_priv *priv, int flags,
>> +				int count, u32 domid, u32 *refs, u32 *fd);
>> +
>> +int gntdev_dmabuf_exp_wait_released(struct gntdev_priv *priv, u32 fd,
>> +				    int wait_to_ms);
>> +
>> +int gntdev_dmabuf_imp_release(struct gntdev_priv *priv, u32 fd);
>> +
>> +u32 *gntdev_dmabuf_imp_to_refs(struct gntdev_priv *priv, int fd,
>> +			      int count, int domid, u32 **refs);
>> +
>> +#endif
>> -- 
>> 2.17.0
>>
