Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:63676 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaCXHfO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 03:35:14 -0400
Received: by mail-ig0-f173.google.com with SMTP id t19so7017605igi.0
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 00:35:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F53F33F7D@SC-VEXCH1.marvell.com>
References: <1395378261-17408-1-git-send-email-binw@marvell.com>
	<CAO_48GFPTn26szh8ffVuohGC_FZ+hdR=9V_YnS82t_UZ9nNMJw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430F53F33F7D@SC-VEXCH1.marvell.com>
Date: Mon, 24 Mar 2014 08:35:12 +0100
Message-ID: <CAKMK7uFNw=7zeMOyscx6J7K7oZVoG8XkNhgdjmeJUKEusPzNDg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add meta data attachment
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Bin Wang <binw@marvell.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Clark, Rob" <robdclark@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Adding piles more people.

For the first case of caching the iommu mapping there's different
answers, depening upon the exact case:

1) You need to fix your userspace to not constantly re-establish the sharing.

2) We need to add streaming dma support for real to dma-bufs so that
the mapping can be kept while we transfer ownership around. Thus far
no one really needed this though since usually you don't actually do
cpu access.

3) You need opportunistic caching of imported/exported buffer objects
and their mappings. For this you need a) subsystem import/export
support which guarantees you to hand out the same dma-buf/native
object again upon re-export or re-import (drm has it) b) some
opportunistic caching of buffer objects (pretty much are real gpu drm
drivers have it). No need of any metadata scheme, and given how much
fun I've had implemented this for drm I don't you can make your
metadata scheme work in a sane or correct way wrt lifetimes.

For caching the iommu mapping if the iommu is the same for multiple devices:

1) We need some way to figure out which iommu serves which devices.

2) The exporter needs to consult this and might just hand out the same
sg mapping out again if it wants to.

No need for importers to do fancy stuff, or attach any
importer-visible metadata to dma-bufs. Of course duplicating this code
all over the place is a but uncool, so I expect that eventually we'll
have a generic exporter implementation, at least for non-swappable
buffers. drm/gem is a bit special here ...

In general I don't like the idea of arbitrary metadata at all, sounds
prone to abuse with crazy lifetime/refcounting rules for the objects
involved. Also I think for a lot of your examples (like debugging) it
would be much better if we have a standardized piece of metadata so
that all drivers/platforms can use the same tooling.

And it feels like I'm writing such a mail every few months ...

Cheers, Daniel

On Mon, Mar 24, 2014 at 7:20 AM, Bin Wang <binw@marvell.com> wrote:
> Hi Sumit,
>
> On 03/21/2014 07:26 PM, Sumit Semwal wrote:
>> Hi Bin Wang,
>>
>> On 21 March 2014 10:34, Bin Wang <binw@marvell.com> wrote:
>>> we found there'd be varied specific data connected to a dmabuf, like
>>> the iommu mapping of buffer, the dma descriptors (that can be shared
>>> between several components). Though these info might be able to be
>>> generated every time before dma operations, for performance sake,
>>> it's better to be kept before really invalid.
>> Thanks for your patch!
>> I think we'd need to have more specific details on what does 'meta
>> data' mean here; more specific comments inline.
>>> Change-Id: I89d43dc3fe1ee3da91c42074da5df71b968e6d3c
>>> Signed-off-by: Bin Wang <binw@marvell.com>
>>> ---
>>>   drivers/base/dma-buf.c  |  100 +++++++++++++++++++++++++++++++++++++++++++++++
>>>   include/linux/dma-buf.h |   22 ++++++++++
>>>   2 files changed, 122 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/base/dma-buf.c b/drivers/base/dma-buf.c
>>> index 08fe897..5c82e60 100644
>>> --- a/drivers/base/dma-buf.c
>>> +++ b/drivers/base/dma-buf.c
>>> @@ -50,6 +50,7 @@ static int dma_buf_release(struct inode *inode, struct file *file)
>>>
>>>          BUG_ON(dmabuf->vmapping_counter);
>>>
>>> +       dma_buf_meta_release(dmabuf);
>>>          dmabuf->ops->release(dmabuf);
>>>
>>>          mutex_lock(&db_list.lock);
>>> @@ -138,6 +139,7 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
>>>
>>>          mutex_init(&dmabuf->lock);
>>>          INIT_LIST_HEAD(&dmabuf->attachments);
>>> +       INIT_LIST_HEAD(&dmabuf->metas);
>>>
>> I am not sure I understand the relationship of 'meta data' with
>> 'dma-buf', or 'attachments' - do you mean to have a list of some
>> meta-data that is unrelated to the attachments to the dma-buf? I think
>> it'd help to explain whether meta-data is specific to each dma-buf,
>> and there's a list of them, or this meta-data is related to each
>> importer device attachment?
>> If it's related to each importer, it should really be added as part of
>> the dma_buf_attachment, and not separately.
> The "meta-data" here can be any kind of data related to the dmabuf, , it's specific
> for each dmabuf.
>
> For example, we have iommu for a VPU device, VPU driver has
> to map the dmabuf to get an IOVA address before it can access the buffer. This
> dmabuf would be reused many times during the video playback, for performance
> concern we don't want this dmabuf be map/unmaped by iommu driver every time
> of VPU HW data transfer, since the physical pages not changed and iommu IOVA
> plenty.
>
> Another example, in our SoC, device A and device B use the same dma chain format,
> and these drivers share dmabuf between each other, thus the "dma chain"
> array doesn't need to be generated every timer for each device.
>
> So here, with the help from the "meta-data", only the "first time" we need to generate
> the "meta-data" from scratch, and later we can just reuse it until the buffer freed.
>
> The "meta-data" is related to the importer, or importers. However, the "dma_buf_attachment"
> is per "devices", holding device specific attributes, while "meta-data" is per "dmabuf',
> holding buffer specific attributes, like the example above.
>>>          mutex_lock(&db_list.lock);
>>>          list_add(&dmabuf->list_node, &db_list.head);
>>> @@ -570,6 +572,104 @@ void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
>>>   }
>>>   EXPORT_SYMBOL_GPL(dma_buf_vunmap);
>>>
>>> +/**
>>> + * dma_buf_meta_attach - Attach additional meta data to the dmabuf
>>> + * @dmabuf:    [in]    the dmabuf to attach to
>>> + * @id:                [in]    the id of the meta data
>>> + * @pdata:     [in]    the raw data to be attached
>>> + * @release:   [in]    the callback to release the meta data
>>> + */
>>> +int dma_buf_meta_attach(struct dma_buf *dmabuf, int id, void *pdata,
>>> +       int (*release)(void *))
>>> +{
>>> +       struct dma_buf_meta *pmeta;
>>> +
>>> +       pmeta = kmalloc(sizeof(struct dma_buf_meta), GFP_KERNEL);
>>> +       if (pmeta == NULL)
>>> +               return -ENOMEM;
>>> +
>>> +       pmeta->id = id;
>> What does 'id' mean here? Also there is no check on any duplicity on
>> the 'id', so if any device adds more meta data with the same ID, you
>> would always work only on the first one? It would also help if you
>> could explain the relevance of id.
> The "id" here means a kind of specific "meta-data", for example we use
> "#define VPU_DMABUF_META_ID    0x10000" for the VPU iommu related
> data.
>
> Each importer would try to "dma_buf_meta_fetch()" the "meta-data" first, if
> not found, it would generate and attach it. If found, it would just reuse it.
>
> I agree with you that it's better to add the check of id in this function as well.
>>> +       pmeta->pdata = pdata;
>>> +       pmeta->release = release;
>>> +
>>> +       mutex_lock(&dmabuf->lock);
>>> +       list_add(&pmeta->node, &dmabuf->metas);
>>> +       mutex_unlock(&dmabuf->lock);
>>> +
>>> +       return 0;
>>> +}
>>> +EXPORT_SYMBOL_GPL(dma_buf_meta_attach);
>>> +
>>> +/**
>>> + * dma_buf_meta_dettach - Dettach the meta data from dmabuf by id
>>> + * @dmabuf:    [in]    the dmabuf including the meta data
>>> + * @id:                [in]    the id of the meta data
>>> + */
>>> +int dma_buf_meta_dettach(struct dma_buf *dmabuf, int id)
>>> +{
>>> +       struct dma_buf_meta *pmeta, *tmp;
>>> +       int ret = -ENOENT;
>>> +
>>> +       mutex_lock(&dmabuf->lock);
>>> +       list_for_each_entry_safe(pmeta, tmp, &dmabuf->metas, node) {
>>> +               if (pmeta->id == id) {
>>> +                       if (pmeta->release)
>>> +                               pmeta->release(pmeta->pdata);
>>> +                       list_del(&pmeta->node);
>>> +                       kfree(pmeta);
>>> +                       ret = 0;
>>> +                       break;
>>> +               }
>>> +       }
>>> +       mutex_unlock(&dmabuf->lock);
>>> +
>>> +       return ret;
>>> +}
>>> +EXPORT_SYMBOL_GPL(dma_buf_meta_dettach);
>>> +
>>> +/**
>>> + * dma_buf_meta_fetch - Get the meta data from dmabuf by id
>>> + * @dmabuf:    [in]    the dmabuf including the meta data
>>> + * @id:                [in]    the id of the meta data
>>> + */
>>> +void *dma_buf_meta_fetch(struct dma_buf *dmabuf, int id)
>>> +{
>>> +       struct dma_buf_meta *pmeta;
>>> +       void *pdata = NULL;
>>> +
>>> +       mutex_lock(&dmabuf->lock);
>>> +       list_for_each_entry(pmeta, &dmabuf->metas, node) {
>>> +               if (pmeta->id == id) {
>>> +                       pdata = pmeta->pdata;
>>> +                       break;
>>> +               }
>>> +       }
>>> +       mutex_unlock(&dmabuf->lock);
>>> +
>>> +       return pdata;
>>> +}
>>> +EXPORT_SYMBOL_GPL(dma_buf_meta_fetch);
>>> +
>>> +/**
>>> + * dma_buf_meta_release - Release all the meta data attached to the dmabuf
>>> + * @dmabuf:    [in]    the dmabuf including the meta data
>>> + */
>>> +void dma_buf_meta_release(struct dma_buf *dmabuf)
>>> +{
>>> +       struct dma_buf_meta *pmeta, *tmp;
>>> +
>>> +       mutex_lock(&dmabuf->lock);
>>> +       list_for_each_entry_safe(pmeta, tmp, &dmabuf->metas, node) {
>>> +               if (pmeta->release)
>>> +                       pmeta->release(pmeta->pdata);
>>> +               list_del(&pmeta->node);
>>> +               kfree(pmeta);
>>> +       }
>>> +       mutex_unlock(&dmabuf->lock);
>>> +
>>> +       return;
>>> +}
>>> +
>>>   #ifdef CONFIG_DEBUG_FS
>>>   static int dma_buf_describe(struct seq_file *s)
>>>   {
>>> diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>>> index dfac5ed..369d032 100644
>>> --- a/include/linux/dma-buf.h
>>> +++ b/include/linux/dma-buf.h
>>> @@ -120,6 +120,7 @@ struct dma_buf {
>>>          size_t size;
>>>          struct file *file;
>>>          struct list_head attachments;
>>> +       struct list_head metas;
>>>          const struct dma_buf_ops *ops;
>>>          /* mutex to serialize list manipulation, attach/detach and vmap/unmap */
>>>          struct mutex lock;
>>> @@ -149,6 +150,20 @@ struct dma_buf_attachment {
>>>   };
>>>
>> Like I said above, I don't think I completely understand the need of
>> 'a list of metas' - a sample usage would be most helpful to realise
>> the relevance here.
> As the examples above, in the list of "metas", there can be, VPU iommu mapping info,
> camera/display dma chain info, or other debugging/tracking info etc.
>>>   /**
>>> + * struct dma_buf_meta - holds varied meta data attached to the buffer
>>> + * @id: the identification of the meta data
>>> + * @dmabuf: buffer for this attachment.
>>> + * @node: list of dma_buf_meta.
>>> + * @pdata: specific meta data.
>>> + */
>>> +struct dma_buf_meta {
>>> +       int id;
>>> +       struct list_head node;
>>> +       int (*release)(void *pdata);
>>> +       void *pdata;
>>> +};
>>> +
>>> +/**
>>>    * get_dma_buf - convenience wrapper for get_file.
>>>    * @dmabuf:    [in]    pointer to dma_buf
>>>    *
>>> @@ -194,6 +209,13 @@ int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
>>>                   unsigned long);
>>>   void *dma_buf_vmap(struct dma_buf *);
>>>   void dma_buf_vunmap(struct dma_buf *, void *vaddr);
>>> +
>>> +int dma_buf_meta_attach(struct dma_buf *dmabuf, int id, void *pdata,
>>> +       int (*release)(void *));
>>> +int dma_buf_meta_dettach(struct dma_buf *dmabuf, int id);
>>> +void *dma_buf_meta_fetch(struct dma_buf *dmabuf, int id);
>>> +void dma_buf_meta_release(struct dma_buf *dmabuf);
>>> +
>>>   int dma_buf_debugfs_create_file(const char *name,
>>>                                  int (*write)(struct seq_file *));
>>>   #endif /* __DMA_BUF_H__ */
>>> --
>>> 1.7.0.4
>>>
>>>
>>> _______________________________________________
>>> Linaro-mm-sig mailing list
>>> Linaro-mm-sig@lists.linaro.org
>>> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig
>>
>>
> The purpose of this extension mainly is:
> 1. Try to reuse the first generated specific data in the buffer's life time, to avoid redundant map/unmap, or generate/free.
> 2. Try to share the "reusable" data between devices, if the devices support compatible formats.
>
> Regards,
> Bin Wang
> _______________________________________________
> Linaro-mm-sig mailing list
> Linaro-mm-sig@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-mm-sig



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
