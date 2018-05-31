Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:43652 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755297AbeEaOcp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 10:32:45 -0400
Subject: Re: [PATCH 6/8] xen/gntdev: Implement dma-buf export functionality
From: Oleksandr Andrushchenko <andr2000@gmail.com>
To: Dongwon Kim <dongwon.kim@intel.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, daniel.vetter@intel.com,
        matthew.d.roper@intel.com,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
References: <20180525153331.31188-1-andr2000@gmail.com>
 <20180525153331.31188-7-andr2000@gmail.com>
 <20180530231006.GA2929@downor-Z87X-UD5H>
 <072fb651-52db-05bd-d110-ada904bcac3d@gmail.com>
Message-ID: <ec8b6c06-fc47-4ffa-56ce-9e4e2ab6f265@gmail.com>
Date: Thu, 31 May 2018 17:32:41 +0300
MIME-Version: 1.0
In-Reply-To: <072fb651-52db-05bd-d110-ada904bcac3d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2018 08:55 AM, Oleksandr Andrushchenko wrote:
> On 05/31/2018 02:10 AM, Dongwon Kim wrote:
>> On Fri, May 25, 2018 at 06:33:29PM +0300, Oleksandr Andrushchenko wrote:
>>> From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
>>>
>>> 1. Create a dma-buf from grant references provided by the foreign
>>>     domain. By default dma-buf is backed by system memory pages, but
>>>     by providing GNTDEV_DMA_FLAG_XXX flags it can also be created
>>>     as a DMA write-combine/coherent buffer, e.g. allocated with
>>>     corresponding dma_alloc_xxx API.
>>>     Export the resulting buffer as a new dma-buf.
>>>
>>> 2. Implement waiting for the dma-buf to be released: block until the
>>>     dma-buf with the file descriptor provided is released.
>>>     If within the time-out provided the buffer is not released then
>>>     -ETIMEDOUT error is returned. If the buffer with the file 
>>> descriptor
>>>     does not exist or has already been released, then -ENOENT is 
>>> returned.
>>>     For valid file descriptors this must not be treated as error.
>>>
>>> Signed-off-by: Oleksandr Andrushchenko 
>>> <oleksandr_andrushchenko@epam.com>
>>> ---
>>>   drivers/xen/gntdev.c | 478 
>>> ++++++++++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 476 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
>>> index 9e450622af1a..52abc6cd5846 100644
>>> --- a/drivers/xen/gntdev.c
>>> +++ b/drivers/xen/gntdev.c
>>> @@ -4,6 +4,8 @@
>>>    * Device for accessing (in user-space) pages that have been 
>>> granted by other
>>>    * domains.
>>>    *
>>> + * DMA buffer implementation is based on drivers/gpu/drm/drm_prime.c.
>>> + *
>>>    * Copyright (c) 2006-2007, D G Murray.
>>>    *           (c) 2009 Gerd Hoffmann <kraxel@redhat.com>
>>>    *           (c) 2018 Oleksandr Andrushchenko, EPAM Systems Inc.
>>> @@ -41,6 +43,9 @@
>>>   #ifdef CONFIG_XEN_GRANT_DMA_ALLOC
>>>   #include <linux/of_device.h>
>>>   #endif
>>> +#ifdef CONFIG_XEN_GNTDEV_DMABUF
>>> +#include <linux/dma-buf.h>
>>> +#endif
>>>     #include <xen/xen.h>
>>>   #include <xen/grant_table.h>
>>> @@ -81,6 +86,17 @@ struct gntdev_priv {
>>>       /* Device for which DMA memory is allocated. */
>>>       struct device *dma_dev;
>>>   #endif
>>> +
>>> +#ifdef CONFIG_XEN_GNTDEV_DMABUF
>>> +    /* Private data of the hyper DMA buffers. */
>>> +
>>> +    /* List of exported DMA buffers. */
>>> +    struct list_head dmabuf_exp_list;
>>> +    /* List of wait objects. */
>>> +    struct list_head dmabuf_exp_wait_list;
>>> +    /* This is the lock which protects dma_buf_xxx lists. */
>>> +    struct mutex dmabuf_lock;
>>> +#endif
>>>   };
>>>     struct unmap_notify {
>>> @@ -125,12 +141,38 @@ struct grant_map {
>>>     #ifdef CONFIG_XEN_GNTDEV_DMABUF
>>>   struct xen_dmabuf {
>>> +    struct gntdev_priv *priv;
>>> +    struct dma_buf *dmabuf;
>>> +    struct list_head next;
>>> +    int fd;
>>> +
>>>       union {
>>> +        struct {
>>> +            /* Exported buffers are reference counted. */
>>> +            struct kref refcount;
>>> +            struct grant_map *map;
>>> +        } exp;
>>>           struct {
>>>               /* Granted references of the imported buffer. */
>>>               grant_ref_t *refs;
>>>           } imp;
>>>       } u;
>>> +
>>> +    /* Number of pages this buffer has. */
>>> +    int nr_pages;
>>> +    /* Pages of this buffer. */
>>> +    struct page **pages;
>>> +};
>>> +
>>> +struct xen_dmabuf_wait_obj {
>>> +    struct list_head next;
>>> +    struct xen_dmabuf *xen_dmabuf;
>>> +    struct completion completion;
>>> +};
>>> +
>>> +struct xen_dmabuf_attachment {
>>> +    struct sg_table *sgt;
>>> +    enum dma_data_direction dir;
>>>   };
>>>   #endif
>>>   @@ -320,6 +362,16 @@ static void gntdev_put_map(struct gntdev_priv 
>>> *priv, struct grant_map *map)
>>>       gntdev_free_map(map);
>>>   }
>>>   +#ifdef CONFIG_XEN_GNTDEV_DMABUF
>>> +static void gntdev_remove_map(struct gntdev_priv *priv, struct 
>>> grant_map *map)
>>> +{
>>> +    mutex_lock(&priv->lock);
>>> +    list_del(&map->next);
>>> +    gntdev_put_map(NULL /* already removed */, map);
>>> +    mutex_unlock(&priv->lock);
>>> +}
>>> +#endif
>>> +
>>>   /* 
>>> ------------------------------------------------------------------ */
>>>     static int find_grant_ptes(pte_t *pte, pgtable_t token,
>>> @@ -628,6 +680,12 @@ static int gntdev_open(struct inode *inode, 
>>> struct file *flip)
>>>       INIT_LIST_HEAD(&priv->freeable_maps);
>>>       mutex_init(&priv->lock);
>>>   +#ifdef CONFIG_XEN_GNTDEV_DMABUF
>>> +    mutex_init(&priv->dmabuf_lock);
>>> +    INIT_LIST_HEAD(&priv->dmabuf_exp_list);
>>> +    INIT_LIST_HEAD(&priv->dmabuf_exp_wait_list);
>>> +#endif
>>> +
>>>       if (use_ptemod) {
>>>           priv->mm = get_task_mm(current);
>>>           if (!priv->mm) {
>>> @@ -1053,17 +1111,433 @@ static long gntdev_ioctl_grant_copy(struct 
>>> gntdev_priv *priv, void __user *u)
>>>   /* DMA buffer export 
>>> support.                                         */
>>>   /* 
>>> ------------------------------------------------------------------ */
>>>   +/* 
>>> ------------------------------------------------------------------ */
>>> +/* Implementation of wait for exported DMA buffer to be 
>>> released.     */
>>> +/* 
>>> ------------------------------------------------------------------ */
>>> +
>>> +static void dmabuf_exp_release(struct kref *kref);
>>> +
>>> +static struct xen_dmabuf_wait_obj *
>>> +dmabuf_exp_wait_obj_new(struct gntdev_priv *priv,
>>> +            struct xen_dmabuf *xen_dmabuf)
>>> +{
>>> +    struct xen_dmabuf_wait_obj *obj;
>>> +
>>> +    obj = kzalloc(sizeof(*obj), GFP_KERNEL);
>>> +    if (!obj)
>>> +        return ERR_PTR(-ENOMEM);
>>> +
>>> +    init_completion(&obj->completion);
>>> +    obj->xen_dmabuf = xen_dmabuf;
>>> +
>>> +    mutex_lock(&priv->dmabuf_lock);
>>> +    list_add(&obj->next, &priv->dmabuf_exp_wait_list);
>>> +    /* Put our reference and wait for xen_dmabuf's release to fire. */
>>> +    kref_put(&xen_dmabuf->u.exp.refcount, dmabuf_exp_release);
>>> +    mutex_unlock(&priv->dmabuf_lock);
>>> +    return obj;
>>> +}
>>> +
>>> +static void dmabuf_exp_wait_obj_free(struct gntdev_priv *priv,
>>> +                     struct xen_dmabuf_wait_obj *obj)
>>> +{
>>> +    struct xen_dmabuf_wait_obj *cur_obj, *q;
>>> +
>>> +    mutex_lock(&priv->dmabuf_lock);
>>> +    list_for_each_entry_safe(cur_obj, q, 
>>> &priv->dmabuf_exp_wait_list, next)
>>> +        if (cur_obj == obj) {
>>> +            list_del(&obj->next);
>>> +            kfree(obj);
>>> +            break;
>>> +        }
>>> +    mutex_unlock(&priv->dmabuf_lock);
>>> +}
>>> +
>>> +static int dmabuf_exp_wait_obj_wait(struct xen_dmabuf_wait_obj *obj,
>>> +                    u32 wait_to_ms)
>>> +{
>>> +    if (wait_for_completion_timeout(&obj->completion,
>>> +            msecs_to_jiffies(wait_to_ms)) <= 0)
>>> +        return -ETIMEDOUT;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static void dmabuf_exp_wait_obj_signal(struct gntdev_priv *priv,
>>> +                       struct xen_dmabuf *xen_dmabuf)
>>> +{
>>> +    struct xen_dmabuf_wait_obj *obj, *q;
>>> +
>>> +    list_for_each_entry_safe(obj, q, &priv->dmabuf_exp_wait_list, 
>>> next)
>>> +        if (obj->xen_dmabuf == xen_dmabuf) {
>>> +            pr_debug("Found xen_dmabuf in the wait list, wake\n");
>>> +            complete_all(&obj->completion);
>>> +        }
>>> +}
>>> +
>>> +static struct xen_dmabuf *
>>> +dmabuf_exp_wait_obj_get_by_fd(struct gntdev_priv *priv, int fd)
>>> +{
>>> +    struct xen_dmabuf *q, *xen_dmabuf, *ret = ERR_PTR(-ENOENT);
>>> +
>>> +    mutex_lock(&priv->dmabuf_lock);
>>> +    list_for_each_entry_safe(xen_dmabuf, q, &priv->dmabuf_exp_list, 
>>> next)
>>> +        if (xen_dmabuf->fd == fd) {
>>> +            pr_debug("Found xen_dmabuf in the wait list\n");
>>> +            kref_get(&xen_dmabuf->u.exp.refcount);
>>> +            ret = xen_dmabuf;
>>> +            break;
>>> +        }
>>> +    mutex_unlock(&priv->dmabuf_lock);
>>> +    return ret;
>>> +}
>>> +
>>>   static int dmabuf_exp_wait_released(struct gntdev_priv *priv, int fd,
>>>                       int wait_to_ms)
>>>   {
>>> -    return -ETIMEDOUT;
>>> +    struct xen_dmabuf *xen_dmabuf;
>>> +    struct xen_dmabuf_wait_obj *obj;
>>> +    int ret;
>>> +
>>> +    pr_debug("Will wait for dma-buf with fd %d\n", fd);
>>> +    /*
>>> +     * Try to find the DMA buffer: if not found means that
>>> +     * either the buffer has already been released or file descriptor
>>> +     * provided is wrong.
>>> +     */
>>> +    xen_dmabuf = dmabuf_exp_wait_obj_get_by_fd(priv, fd);
>>> +    if (IS_ERR(xen_dmabuf))
>>> +        return PTR_ERR(xen_dmabuf);
>>> +
>>> +    /*
>>> +     * xen_dmabuf still exists and is reference count locked by us 
>>> now,
>>> +     * so prepare to wait: allocate wait object and add it to the 
>>> wait list,
>>> +     * so we can find it on release.
>>> +     */
>>> +    obj = dmabuf_exp_wait_obj_new(priv, xen_dmabuf);
>>> +    if (IS_ERR(obj)) {
>>> +        pr_err("Failed to setup wait object, ret %ld\n", 
>>> PTR_ERR(obj));
>>> +        return PTR_ERR(obj);
>>> +    }
>>> +
>>> +    ret = dmabuf_exp_wait_obj_wait(obj, wait_to_ms);
>>> +    dmabuf_exp_wait_obj_free(priv, obj);
>>> +    return ret;
>>> +}
>>> +
>>> +/* 
>>> ------------------------------------------------------------------ */
>>> +/* DMA buffer export 
>>> support.                                         */
>>> +/* 
>>> ------------------------------------------------------------------ */
>>> +
>>> +static struct sg_table *
>>> +dmabuf_pages_to_sgt(struct page **pages, unsigned int nr_pages)
>>> +{
>>> +    struct sg_table *sgt;
>>> +    int ret;
>>> +
>>> +    sgt = kmalloc(sizeof(*sgt), GFP_KERNEL);
>>> +    if (!sgt) {
>>> +        ret = -ENOMEM;
>>> +        goto out;
>>> +    }
>>> +
>>> +    ret = sg_alloc_table_from_pages(sgt, pages, nr_pages, 0,
>>> +                    nr_pages << PAGE_SHIFT,
>>> +                    GFP_KERNEL);
>>> +    if (ret)
>>> +        goto out;
>>> +
>>> +    return sgt;
>>> +
>>> +out:
>>> +    kfree(sgt);
>>> +    return ERR_PTR(ret);
>>> +}
>>> +
>>> +static int dmabuf_exp_ops_attach(struct dma_buf *dma_buf,
>>> +                 struct device *target_dev,
>>> +                 struct dma_buf_attachment *attach)
>>> +{
>>> +    struct xen_dmabuf_attachment *xen_dmabuf_attach;
>>> +
>>> +    xen_dmabuf_attach = kzalloc(sizeof(*xen_dmabuf_attach), 
>>> GFP_KERNEL);
>>> +    if (!xen_dmabuf_attach)
>>> +        return -ENOMEM;
>>> +
>>> +    xen_dmabuf_attach->dir = DMA_NONE;
>>> +    attach->priv = xen_dmabuf_attach;
>>> +    /* Might need to pin the pages of the buffer now. */
>>> +    return 0;
>>> +}
>>> +
>>> +static void dmabuf_exp_ops_detach(struct dma_buf *dma_buf,
>>> +                  struct dma_buf_attachment *attach)
>>> +{
>>> +    struct xen_dmabuf_attachment *xen_dmabuf_attach = attach->priv;
>>> +
>>> +    if (xen_dmabuf_attach) {
>>> +        struct sg_table *sgt = xen_dmabuf_attach->sgt;
>>> +
>>> +        if (sgt) {
>>> +            if (xen_dmabuf_attach->dir != DMA_NONE)
>>> +                dma_unmap_sg_attrs(attach->dev, sgt->sgl,
>>> +                           sgt->nents,
>>> +                           xen_dmabuf_attach->dir,
>>> +                           DMA_ATTR_SKIP_CPU_SYNC);
>>> +            sg_free_table(sgt);
>>> +        }
>>> +
>>> +        kfree(sgt);
>>> +        kfree(xen_dmabuf_attach);
>>> +        attach->priv = NULL;
>>> +    }
>>> +    /* Might need to unpin the pages of the buffer now. */
>>> +}
>>> +
>>> +static struct sg_table *
>>> +dmabuf_exp_ops_map_dma_buf(struct dma_buf_attachment *attach,
>>> +               enum dma_data_direction dir)
>>> +{
>>> +    struct xen_dmabuf_attachment *xen_dmabuf_attach = attach->priv;
>>> +    struct xen_dmabuf *xen_dmabuf = attach->dmabuf->priv;
>>> +    struct sg_table *sgt;
>>> +
>>> +    pr_debug("Mapping %d pages for dev %p\n", xen_dmabuf->nr_pages,
>>> +         attach->dev);
>>> +
>>> +    if (WARN_ON(dir == DMA_NONE || !xen_dmabuf_attach))
>>> +        return ERR_PTR(-EINVAL);
>>> +
>>> +    /* Return the cached mapping when possible. */
>>> +    if (xen_dmabuf_attach->dir == dir)
>>> +        return xen_dmabuf_attach->sgt;
>> may need to check xen_dmabuf_attach->sgt == NULL (i.e. first time 
>> mapping)?
>> Also, I am not sure if this mechanism of reusing previously generated 
>> sgt
>> for other mappings is universally ok for any use-cases... I don't 
>> know if
>> it is acceptable as per the specification.
> Well, I was not sure about this piece of code as well,
> so I'll probably allocate a new sgt each time and do not reuse it
> as now
The sgt returned for the same attachment, so it is ok to return this 
cached one
as we also check that the direction has not changed
So, I'll leave it as is
>>> +
>>> +    /*
>>> +     * Two mappings with different directions for the same 
>>> attachment are
>>> +     * not allowed.
>>> +     */
>>> +    if (WARN_ON(xen_dmabuf_attach->dir != DMA_NONE))
>>> +        return ERR_PTR(-EBUSY);
>>> +
>>> +    sgt = dmabuf_pages_to_sgt(xen_dmabuf->pages, 
>>> xen_dmabuf->nr_pages);
>>> +    if (!IS_ERR(sgt)) {
>>> +        if (!dma_map_sg_attrs(attach->dev, sgt->sgl, sgt->nents, dir,
>>> +                      DMA_ATTR_SKIP_CPU_SYNC)) {
>>> +            sg_free_table(sgt);
>>> +            kfree(sgt);
>>> +            sgt = ERR_PTR(-ENOMEM);
>>> +        } else {
>>> +            xen_dmabuf_attach->sgt = sgt;
>>> +            xen_dmabuf_attach->dir = dir;
>>> +        }
>>> +    }
>>> +    if (IS_ERR(sgt))
>>> +        pr_err("Failed to map sg table for dev %p\n", attach->dev);
>>> +    return sgt;
>>> +}
>>> +
>>> +static void dmabuf_exp_ops_unmap_dma_buf(struct dma_buf_attachment 
>>> *attach,
>>> +                     struct sg_table *sgt,
>>> +                     enum dma_data_direction dir)
>>> +{
>>> +    /* Not implemented. The unmap is done at 
>>> dmabuf_exp_ops_detach(). */
>> Not sure if it's ok to do nothing here because the spec says this 
>> function is
>> mandatory and it should unmap and "release" &sg_table associated with 
>> it.
>>
>>     /**
>>      * @unmap_dma_buf:
>>      *
>>      * This is called by dma_buf_unmap_attachment() and should unmap and
>>      * release the &sg_table allocated in @map_dma_buf, and it is 
>> mandatory.
>>      * It should also unpin the backing storage if this is the last 
>> mapping
>>      * of the DMA buffer, it the exporter supports backing storage
>>      * migration.
>>      */
> Yes, as I say at the top of the file dma-buf handling is DRM PRIME
> based, so I have the workflow just like in there.
> Do you think we have to be more strict and rework this?
>
> Daniel, what do you think?
I see other drivers in the kernel do the same. I think that *should*
in the dma-buf documentation does allow that.
So, I'll leave it as is for now
>>> +}
>>> +
>>> +static void dmabuf_exp_release(struct kref *kref)
>>> +{
>>> +    struct xen_dmabuf *xen_dmabuf =
>>> +        container_of(kref, struct xen_dmabuf, u.exp.refcount);
>>> +
>>> +    dmabuf_exp_wait_obj_signal(xen_dmabuf->priv, xen_dmabuf);
>>> +    list_del(&xen_dmabuf->next);
>>> +    kfree(xen_dmabuf);
>>> +}
>>> +
>>> +static void dmabuf_exp_ops_release(struct dma_buf *dma_buf)
>>> +{
>>> +    struct xen_dmabuf *xen_dmabuf = dma_buf->priv;
>>> +    struct gntdev_priv *priv = xen_dmabuf->priv;
>>> +
>>> +    gntdev_remove_map(priv, xen_dmabuf->u.exp.map);
>>> +    mutex_lock(&priv->dmabuf_lock);
>>> +    kref_put(&xen_dmabuf->u.exp.refcount, dmabuf_exp_release);
>>> +    mutex_unlock(&priv->dmabuf_lock);
>>> +}
>>> +
>>> +static void *dmabuf_exp_ops_kmap_atomic(struct dma_buf *dma_buf,
>>> +                    unsigned long page_num)
>>> +{
>>> +    /* Not implemented. */
>>> +    return NULL;
>>> +}
>>> +
>>> +static void dmabuf_exp_ops_kunmap_atomic(struct dma_buf *dma_buf,
>>> +                     unsigned long page_num, void *addr)
>>> +{
>>> +    /* Not implemented. */
>>> +}
>>> +
>>> +static void *dmabuf_exp_ops_kmap(struct dma_buf *dma_buf,
>>> +                 unsigned long page_num)
>>> +{
>>> +    /* Not implemented. */
>>> +    return NULL;
>>> +}
>>> +
>>> +static void dmabuf_exp_ops_kunmap(struct dma_buf *dma_buf,
>>> +                  unsigned long page_num, void *addr)
>>> +{
>>> +    /* Not implemented. */
>>> +}
>>> +
>>> +static int dmabuf_exp_ops_mmap(struct dma_buf *dma_buf,
>>> +                   struct vm_area_struct *vma)
>>> +{
>>> +    /* Not implemented. */
>>> +    return 0;
>>> +}
>>> +
>>> +static const struct dma_buf_ops dmabuf_exp_ops =  {
>>> +    .attach = dmabuf_exp_ops_attach,
>>> +    .detach = dmabuf_exp_ops_detach,
>>> +    .map_dma_buf = dmabuf_exp_ops_map_dma_buf,
>>> +    .unmap_dma_buf = dmabuf_exp_ops_unmap_dma_buf,
>>> +    .release = dmabuf_exp_ops_release,
>>> +    .map = dmabuf_exp_ops_kmap,
>>> +    .map_atomic = dmabuf_exp_ops_kmap_atomic,
>>> +    .unmap = dmabuf_exp_ops_kunmap,
>>> +    .unmap_atomic = dmabuf_exp_ops_kunmap_atomic,
>>> +    .mmap = dmabuf_exp_ops_mmap,
>>> +};
>>> +
>>> +static int dmabuf_export(struct gntdev_priv *priv, struct grant_map 
>>> *map,
>>> +             int *fd)
>>> +{
>>> +    DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>>> +    struct xen_dmabuf *xen_dmabuf;
>>> +    int ret = 0;
>>> +
>>> +    xen_dmabuf = kzalloc(sizeof(*xen_dmabuf), GFP_KERNEL);
>>> +    if (!xen_dmabuf)
>>> +        return -ENOMEM;
>>> +
>>> +    kref_init(&xen_dmabuf->u.exp.refcount);
>>> +
>>> +    xen_dmabuf->priv = priv;
>>> +    xen_dmabuf->nr_pages = map->count;
>>> +    xen_dmabuf->pages = map->pages;
>>> +    xen_dmabuf->u.exp.map = map;
>>> +
>>> +    exp_info.exp_name = KBUILD_MODNAME;
>>> +    if (map->dma_dev->driver && map->dma_dev->driver->owner)
>>> +        exp_info.owner = map->dma_dev->driver->owner;
>>> +    else
>>> +        exp_info.owner = THIS_MODULE;
>>> +    exp_info.ops = &dmabuf_exp_ops;
>>> +    exp_info.size = map->count << PAGE_SHIFT;
>>> +    exp_info.flags = O_RDWR;
>>> +    exp_info.priv = xen_dmabuf;
>>> +
>>> +    xen_dmabuf->dmabuf = dma_buf_export(&exp_info);
>>> +    if (IS_ERR(xen_dmabuf->dmabuf)) {
>>> +        ret = PTR_ERR(xen_dmabuf->dmabuf);
>>> +        xen_dmabuf->dmabuf = NULL;
>>> +        goto fail;
>>> +    }
>>> +
>>> +    ret = dma_buf_fd(xen_dmabuf->dmabuf, O_CLOEXEC);
>>> +    if (ret < 0)
>>> +        goto fail;
>>> +
>>> +    xen_dmabuf->fd = ret;
>>> +    *fd = ret;
>>> +
>>> +    pr_debug("Exporting DMA buffer with fd %d\n", ret);
>>> +
>>> +    mutex_lock(&priv->dmabuf_lock);
>>> +    list_add(&xen_dmabuf->next, &priv->dmabuf_exp_list);
>>> +    mutex_unlock(&priv->dmabuf_lock);
>>> +    return 0;
>>> +
>>> +fail:
>>> +    if (xen_dmabuf->dmabuf)
>>> +        dma_buf_put(xen_dmabuf->dmabuf);
>>> +    kfree(xen_dmabuf);
>>> +    return ret;
>>> +}
>>> +
>>> +static struct grant_map *
>>> +dmabuf_exp_alloc_backing_storage(struct gntdev_priv *priv, int 
>>> dmabuf_flags,
>>> +                 int count)
>>> +{
>>> +    struct grant_map *map;
>>> +
>>> +    if (unlikely(count <= 0))
>>> +        return ERR_PTR(-EINVAL);
>>> +
>>> +    if ((dmabuf_flags & GNTDEV_DMA_FLAG_WC) &&
>>> +        (dmabuf_flags & GNTDEV_DMA_FLAG_COHERENT)) {
>>> +        pr_err("Wrong dma-buf flags: either WC or coherent, not 
>>> both\n");
>>> +        return ERR_PTR(-EINVAL);
>>> +    }
>>> +
>>> +    map = gntdev_alloc_map(priv, count, dmabuf_flags);
>>> +    if (!map)
>>> +        return ERR_PTR(-ENOMEM);
>>> +
>>> +    if (unlikely(atomic_add_return(count, &pages_mapped) > limit)) {
>>> +        pr_err("can't map: over limit\n");
>>> +        gntdev_put_map(NULL, map);
>>> +        return ERR_PTR(-ENOMEM);
>>> +    }
>>> +    return map;
>>>   }
>> When and how would this allocation be freed? I don't see any ioctl 
>> for freeing up
>> shared pages.
> on xen_dmabuf.release callback which is refcounted
>>>     static int dmabuf_exp_from_refs(struct gntdev_priv *priv, int 
>>> flags,
>>>                   int count, u32 domid, u32 *refs, u32 *fd)
>>>   {
>>> +    struct grant_map *map;
>>> +    int i, ret;
>>> +
>>>       *fd = -1;
>>> -    return -EINVAL;
>>> +
>>> +    if (use_ptemod) {
>>> +        pr_err("Cannot provide dma-buf: use_ptemode %d\n",
>>> +               use_ptemod);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    map = dmabuf_exp_alloc_backing_storage(priv, flags, count);
>>> +    if (IS_ERR(map))
>>> +        return PTR_ERR(map);
>>> +
>>> +    for (i = 0; i < count; i++) {
>>> +        map->grants[i].domid = domid;
>>> +        map->grants[i].ref = refs[i];
>>> +    }
>>> +
>>> +    mutex_lock(&priv->lock);
>>> +    gntdev_add_map(priv, map);
>>> +    mutex_unlock(&priv->lock);
>>> +
>>> +    map->flags |= GNTMAP_host_map;
>>> +#if defined(CONFIG_X86)
>>> +    map->flags |= GNTMAP_device_map;
>>> +#endif
>>> +
>>> +    ret = map_grant_pages(map);
>>> +    if (ret < 0)
>>> +        goto out;
>>> +
>>> +    ret = dmabuf_export(priv, map, fd);
>>> +    if (ret < 0)
>>> +        goto out;
>>> +
>>> +    return 0;
>>> +
>>> +out:
>>> +    gntdev_remove_map(priv, map);
>>> +    return ret;
>>>   }
>>>     /* 
>>> ------------------------------------------------------------------ */
>>> -- 
>>> 2.17.0
>>>
>
