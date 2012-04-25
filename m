Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:51730 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2DYCb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 22:31:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120424170244.GD2017@phenom.ffwll.local>
References: <1335258532-20739-1-git-send-email-daniel.vetter@ffwll.ch>
	<CAAQKjZMgcxWc44xknM+eZhon4QgvWd92Ci4snwBv2Ziyw1Recw@mail.gmail.com>
	<20120424170244.GD2017@phenom.ffwll.local>
Date: Wed, 25 Apr 2012 11:31:57 +0900
Message-ID: <CAAQKjZOtTySp6nOzkfjkrgzsaapTWv9okVdDjSV_hmKJwjVOUg@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: mmap support
From: InKi Dae <daeinki@gmail.com>
To: InKi Dae <daeinki@gmail.com>, linaro-mm-sig@lists.linaro.org,
	LKML <linux-kernel@vger.kernel.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Rob Clark <rob.clark@linaro.org>,
	Rebecca Schultz Zavin <rebecca@android.com>,
	linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/4/25, Daniel Vetter <daniel@ffwll.ch>:
> On Wed, Apr 25, 2012 at 01:37:51AM +0900, InKi Dae wrote:
>> Hi,
>>
>> >
>> > +static int dma_buf_mmap_internal(struct file *file, struct
>> > vm_area_struct *vma)
>> > +{
>> > +       struct dma_buf *dmabuf;
>> > +
>> > +       if (!is_dma_buf_file(file))
>> > +               return -EINVAL;
>> > +
>> > +       dmabuf = file->private_data;
>> > +
>> > +       /* check for overflowing the buffer's size */
>> > +       if (vma->vm_pgoff + ((vma->vm_end - vma->vm_start) >>
>> > PAGE_SHIFT) >
>> > +           dmabuf->size >> PAGE_SHIFT)
>>
>> is this condition right? your intention is for checking buffer's size
>> is valid or not. by the way why is vma->vm_pgoff added to vm region
>> size?
>
> This check here is to ensure that userspace cannot mmap beyong the end of
> the dma_buf object. vm_pgoff is the offset userspace passed in at mmap
> time and hence needs to be added. Note that vm_end and vm_start are in
> bytes, wheres vm_pgoff is in pages.
>

You're right, vma area region would be decided by user-desired size
that this is passed by mmap syscall so user should set size and
vm_pgoff appropriately. it's my missing point. well if any part of
dmabuf buffer region had already been mmaped and after that user
requested mmap for another region of the dmabuf buffer region again
then isn't there any problem? I mean that dmabuf->size would always
have same value since any memory region allocated by any allocators
such as gem, ump and so on have been exported to dmabuf. so at second
mmap request, dmabuf->size wouldn't have reasonable value because with
first mmap request, any part of the dmabuf buffer region had already
beem mmaped. for example, dmabuf size is 1MB and 512Kb region of the
dmabuf was mmaped by first mmap request and then with second mmap
request, your code would check whether user-desired size is valid or
not with dmabuf->size but dmabuf->size would still have 1MB it means
at second mmap request, any size between 512KB ~ 1MB would be ok. it's
just my concern and there could be my missing point.

Thanks,
Inki Dae.

>> > +               return -EINVAL;
>> > +
>> > +       return dmabuf->ops->mmap(dmabuf, vma);
>> > +}
>> > +
>> >  static const struct file_operations dma_buf_fops = {
>> >        .release        = dma_buf_release,
>> > +       .mmap           = dma_buf_mmap_internal,
>> >  };
>> >
>> >  /*
>> > @@ -82,7 +100,8 @@ struct dma_buf *dma_buf_export(void *priv, const
>> > struct dma_buf_ops *ops,
>> >                          || !ops->unmap_dma_buf
>> >                          || !ops->release
>> >                          || !ops->kmap_atomic
>> > -                         || !ops->kmap)) {
>> > +                         || !ops->kmap
>> > +                         || !ops->mmap)) {
>> >                return ERR_PTR(-EINVAL);
>> >        }
>> >
>> > @@ -406,3 +425,46 @@ void dma_buf_kunmap(struct dma_buf *dmabuf,
>> > unsigned long page_num,
>> >                dmabuf->ops->kunmap(dmabuf, page_num, vaddr);
>> >  }
>> >  EXPORT_SYMBOL_GPL(dma_buf_kunmap);
>> > +
>> > +
>> > +/**
>> > + * dma_buf_mmap - Setup up a userspace mmap with the given vma
>> > + * @dma_buf:   [in]    buffer that should back the vma
>> > + * @vma:       [in]    vma for the mmap
>> > + * @pgoff:     [in]    offset in pages where this mmap should start
>> > within the
>> > + *                     dma-buf buffer.
>> > + *
>> > + * This function adjusts the passed in vma so that it points at the
>> > file of the
>> > + * dma_buf operation. It alsog adjusts the starting pgoff and does
>> > bounds
>> > + * checking on the size of the vma. Then it calls the exporters mmap
>> > function to
>> > + * set up the mapping.
>> > + *
>> > + * Can return negative error values, returns 0 on success.
>> > + */
>> > +int dma_buf_mmap(struct dma_buf *dmabuf, struct vm_area_struct *vma,
>> > +                unsigned long pgoff)
>> > +{
>> > +       if (WARN_ON(!dmabuf || !vma))
>> > +               return -EINVAL;
>> > +
>> > +       /* check for offset overflow */
>> > +       if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) <
>> > pgoff)
>>
>> ditto. isn't it checked whether page offset to be mmaped is placed
>> within vm region or not with the condition, if ((vma->vm_end -
>> vma->vm_start) >> PAGE_SHIFT) < pgoff)?
>
> Nope, this check only checks for overflow. The pgoff is the offset within
> the dma_buf object. E.g. a drm driver splits up it mmap space into pieces,
> which map to individual buffers. If userspace just mmaps parts of such a
> buffer, the importer can pass the offset in pgoff. But I expect this to be
> 0 for almost all cases.
>
> Note that we don't need this overflow check in the internal mmap function
> because do_mmap will do it for us. But here the importer potentially sets
> a completely different pgoff, so we need to do it. dma_buf documentation
> also mentions this (and that importers do not have to do these checks).
>
> Yours, Daniel
>
>>
>> > +               return -EOVERFLOW;
>> > +
>> > +       /* check for overflowing the buffer's size */
>> > +       if (pgoff + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) >
>> > +           dmabuf->size >> PAGE_SHIFT)
>> > +               return -EINVAL;
>> > +
>> > +       /* readjust the vma */
>> > +       if (vma->vm_file)
>> > +               fput(vma->vm_file);
>> > +
>> > +       vma->vm_file = dmabuf->file;
>> > +       get_file(vma->vm_file);
>> > +
>> > +       vma->vm_pgoff = pgoff;
>> > +
>> > +       return dmabuf->ops->mmap(dmabuf, vma);
>> > +}
>> > +EXPORT_SYMBOL_GPL(dma_buf_mmap);
>> > diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
>> > index 3efbfc2..1f78d15 100644
>> > --- a/include/linux/dma-buf.h
>> > +++ b/include/linux/dma-buf.h
>> > @@ -61,6 +61,10 @@ struct dma_buf_attachment;
>> >  *                This Callback must not sleep.
>> >  * @kmap: maps a page from the buffer into kernel address space.
>> >  * @kunmap: [optional] unmaps a page from the buffer.
>> > + * @mmap: used to expose the backing storage to userspace. Note that
>> > the
>> > + *       mapping needs to be coherent - if the exporter doesn't
>> > directly
>> > + *       support this, it needs to fake coherency by shooting down any
>> > ptes
>> > + *       when transitioning away from the cpu domain.
>> >  */
>> >  struct dma_buf_ops {
>> >        int (*attach)(struct dma_buf *, struct device *,
>> > @@ -92,6 +96,8 @@ struct dma_buf_ops {
>> >        void (*kunmap_atomic)(struct dma_buf *, unsigned long, void *);
>> >        void *(*kmap)(struct dma_buf *, unsigned long);
>> >        void (*kunmap)(struct dma_buf *, unsigned long, void *);
>> > +
>> > +       int (*mmap)(struct dma_buf *, struct vm_area_struct *vma);
>> >  };
>> >
>> >  /**
>> > @@ -167,6 +173,9 @@ void *dma_buf_kmap_atomic(struct dma_buf *, unsigned
>> > long);
>> >  void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
>> >  void *dma_buf_kmap(struct dma_buf *, unsigned long);
>> >  void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
>> > +
>> > +int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
>> > +                unsigned long);
>> >  #else
>> >
>> >  static inline struct dma_buf_attachment *dma_buf_attach(struct dma_buf
>> > *dmabuf,
>> > @@ -248,6 +257,13 @@ static inline void dma_buf_kunmap(struct dma_buf
>> > *dmabuf,
>> >                                  unsigned long pnum, void *vaddr)
>> >  {
>> >  }
>> > +
>> > +static inline int dma_buf_mmap(struct dma_buf *dmabuf,
>> > +                              struct vm_area_struct *vma,
>> > +                              unsigned long pgoff)
>> > +{
>> > +       return -ENODEV;
>> > +}
>> >  #endif /* CONFIG_DMA_SHARED_BUFFER */
>> >
>> >  #endif /* __DMA_BUF_H__ */
>> > --
>> > 1.7.10
>> >
>> > _______________________________________________
>> > dri-devel mailing list
>> > dri-devel@lists.freedesktop.org
>> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
> --
> Daniel Vetter
> Mail: daniel@ffwll.ch
> Mobile: +41 (0)79 365 57 48
>
