Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59262 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935831AbdEWMHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 08:07:39 -0400
Date: Tue, 23 May 2017 15:07:20 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org,
        dri-devel <dri-devel@lists.freedesktop.org>,
        posciak@chromium.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, sumit.semwal@linaro.org,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, labbott@redhat.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC v4 10/18] vb2: dma-contig: Fix DMA attribute and cache
 management
Message-ID: <20170523120720.GB29527@valkosipuli.retiisi.org.uk>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
 <1494255810-12672-11-git-send-email-sakari.ailus@linux.intel.com>
 <CAAFQd5Dh=TndYq+2=Z4CvPJodqi98ZhSRgrgypYivhFxrYzFtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5Dh=TndYq+2=Z4CvPJodqi98ZhSRgrgypYivhFxrYzFtQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the review!

Considering where things currently stand, I thing getting the three first
patches merged in the near future would make sense. The rest will need a bit
more work, and adding buffer flags that aren't used wouldn't really make
sense either. See below.

On Wed, May 10, 2017 at 06:32:43PM +0800, Tomasz Figa wrote:
> Hi Sakari,
> 
> Some comments inline.
> 
> On Mon, May 8, 2017 at 11:03 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > Patch ccc66e73 ("ARM: 8508/2: videobuf2-dc: Let drivers specify DMA
> > attrs") added support for driver specific DMA attributes to
> > videobuf2-dma-contig but it had several issues in it.
> >
> > In particular,
> >
> > - cache operations were only performed on USERPTR buffers,
> >
> > - DMA attributes were set only for MMAP buffers and
> >
> > - it did not provide begin_cpu_access() and end_cpu_access() dma_buf_ops
> >   callbacks for cache syncronisation on exported MMAP buffers.
> >
> > This patch corrects these issues.
> 
> I think the above are not really issues for the use cases the original
> commit added the support for, i.e. disabling kernel mapping. There was
> no intention of allowing cached MMAP buffers. Although I guess the
> code added by it was not strict enough and didn't check the flags for
> allowed ones.

Now that I've learned about the particularities of ARM DMA API
implementation, it seems that the exact implementation on ARM is well
reflected in videobuf2 mem ops. Videobuf2 isn't specific to ARM however.

> 
> >
> > Also arrange the header files alphabetically.
> >
> > Fixes: ccc66e73 ("ARM: 8508/2: videobuf2-dc: Let drivers specify DMA attrs")
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-dma-contig.c | 94 ++++++++++++++++++++------
> >  1 file changed, 72 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > index 0afc3da..8b0298a 100644
> > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > @@ -11,12 +11,12 @@
> >   */
> >
> >  #include <linux/dma-buf.h>
> > +#include <linux/dma-mapping.h>
> >  #include <linux/module.h>
> >  #include <linux/refcount.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> > -#include <linux/dma-mapping.h>
> >
> >  #include <media/videobuf2-v4l2.h>
> >  #include <media/videobuf2-dma-contig.h>
> > @@ -97,12 +97,13 @@ static void vb2_dc_prepare(void *buf_priv)
> >         struct vb2_dc_buf *buf = buf_priv;
> >         struct sg_table *sgt = buf->dma_sgt;
> >
> > -       /* DMABUF exporter will flush the cache for us */
> 
> Ah, this annoying comment goes away here! Thanks and sorry for the
> noise in previous patch.
> 
> > -       if (!buf->vec)
> > -               return;
> > -
> > -       dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
> > -                              buf->dma_dir);
> > +       /*
> > +        * DMABUF exporter will flush the cache for us; only USERPTR
> > +        * and MMAP buffers with non-coherent memory will be flushed.
> > +        */
> 
> Sounds much better.
> 
> > +       if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
> 
> Hmm, we change it for USERPTR to rely on presence of
> DMA_ATTR_NON_CONSISTENT in buf->attrs, but I don't see it being set
> for such anywhere by previous patches.

When writing this patch, I assumed that all drivers that are expected to
work with non-coherent memory would specify that flag. They do not.

A workable approach could be to start with specifying that flag on ARM based
on the buffer type. The DMA API is a bit confusing though, as it assumes
that the DMA API implementation will have nop implementations of cache
synchronisation functions. At least the ARM implementation does not, but it
expects the user rather not call these functions to begin with. Probably
because there's no enough infomation available to figure that out.

> 
> > +               dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
> > +                                      buf->dma_dir);
> >  }
> >
> >  static void vb2_dc_finish(void *buf_priv)
> > @@ -110,11 +111,13 @@ static void vb2_dc_finish(void *buf_priv)
> >         struct vb2_dc_buf *buf = buf_priv;
> >         struct sg_table *sgt = buf->dma_sgt;
> >
> > -       /* DMABUF exporter will flush the cache for us */
> > -       if (!buf->vec)
> > -               return;
> > -
> > -       dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
> > +       /*
> > +        * DMABUF exporter will flush the cache for us; only USERPTR
> > +        * and MMAP buffers with non-coherent memory will be flushed.
> > +        */
> > +       if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
> 
> Ditto.
> 
> > +               dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
> > +                                   buf->dma_dir);
> >  }
> >
> >  /*********************************************/
> > @@ -142,6 +145,7 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
> >                           gfp_t gfp_flags)
> >  {
> >         struct vb2_dc_buf *buf;
> > +       int ret;
> >
> >         if (WARN_ON(!dev))
> >                 return ERR_PTR(-EINVAL);
> > @@ -152,9 +156,9 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
> >
> >         buf->attrs = attrs;
> >         buf->cookie = dma_alloc_attrs(dev, size, &buf->dma_addr,
> > -                                       GFP_KERNEL | gfp_flags, buf->attrs);
> > +                                     GFP_KERNEL | gfp_flags, buf->attrs);
> 
> White space change, not sure if intended.

Well, partially. A whitespace fix a day keeps indent(1) away? :-)

> 
> >         if (!buf->cookie) {
> > -               dev_err(dev, "dma_alloc_coherent of size %ld failed\n", size);
> > +               dev_err(dev, "dma_alloc_attrs of size %ld failed\n", size);
> >                 kfree(buf);
> >                 return ERR_PTR(-ENOMEM);
> >         }
> > @@ -167,6 +171,16 @@ static void *vb2_dc_alloc(struct device *dev, unsigned long attrs,
> >         buf->size = size;
> >         buf->dma_dir = dma_dir;
> >
> > +       ret = dma_get_sgtable_attrs(buf->dev, &buf->__dma_sgt, buf->cookie,
> > +                                   buf->dma_addr, buf->size, buf->attrs);
> > +       if (ret < 0) {
> > +               dma_free_attrs(dev, size, buf->cookie, buf->dma_addr,
> > +                              buf->attrs);
> > +               put_device(dev);
> > +               return ERR_PTR(-ENOMEM);
> > +       }
> 
> Is this okay to always get this sgtable even for coherent MMAP
> buffers? It will add some unnecessary memory overhead, which could be
> simply avoided by checking for DMA_ATTR_NON_CONSISTENT in buf->attrs.

Good point. I guess this can be dropped if DMA_ATTR_NON_CONSISTENT is not
set (assuming it is set for devices that need it).

As per DMA API documentation, explicit cache synchronisation is needed but I
presume the appropriate change would be to change the documentation.

> 
> > +
> > +       buf->dma_sgt = &buf->__dma_sgt;
> >         buf->handler.refcount = &buf->refcount;
> >         buf->handler.put = vb2_dc_put;
> >         buf->handler.arg = buf;
> > @@ -339,6 +353,40 @@ static void *vb2_dc_dmabuf_ops_kmap(struct dma_buf *dbuf, unsigned long pgnum)
> >         return buf->vaddr ? buf->vaddr + pgnum * PAGE_SIZE : NULL;
> >  }
> >
> > +static int vb2_dc_dmabuf_ops_begin_cpu_access(struct dma_buf *dbuf,
> > +                                             enum dma_data_direction direction)
> > +{
> > +       struct vb2_dc_buf *buf = dbuf->priv;
> > +       struct sg_table *sgt = buf->dma_sgt;
> > +
> > +       /*
> > +        * DMABUF exporter will flush the cache for us; only USERPTR
> 
 > Hmm, I think we can't end up in this function for a DMA-buf that was
> exported by another exporter, but I might be missing something. In any
> case, this comment is a bit confusing, as it's a part of DMABUF
> exporter implementation. Also can we even export USERPTR buffers?

The comment needs to be revised, it has been copied from the finish and
prepare mem ops.

> 
> > +        * and MMAP buffers with non-coherent memory will be flushed.
> > +        */
> > +       if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
> 
> Ditto.
> 
> > +               dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents,
> > +                                   buf->dma_dir);
> > +
> > +       return 0;
> > +}
> > +
> > +static int vb2_dc_dmabuf_ops_end_cpu_access(struct dma_buf *dbuf,
> > +                                           enum dma_data_direction direction)
> > +{
> > +       struct vb2_dc_buf *buf = dbuf->priv;
> > +       struct sg_table *sgt = buf->dma_sgt;
> > +
> > +       /*
> > +        * DMABUF exporter will flush the cache for us; only USERPTR
> > +        * and MMAP buffers with non-coherent memory will be flushed.
> > +        */
> 
> Ditto.
> 
> > +       if (buf->attrs & DMA_ATTR_NON_CONSISTENT)
> 
> Ditto.
> 
> > +               dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents,
> > +                                      buf->dma_dir);
> > +
> > +       return 0;
> > +}
> > +
> >  static void *vb2_dc_dmabuf_ops_vmap(struct dma_buf *dbuf)
> >  {
> >         struct vb2_dc_buf *buf = dbuf->priv;
> > @@ -359,6 +407,8 @@ static struct dma_buf_ops vb2_dc_dmabuf_ops = {
> >         .unmap_dma_buf = vb2_dc_dmabuf_ops_unmap,
> >         .kmap = vb2_dc_dmabuf_ops_kmap,
> >         .kmap_atomic = vb2_dc_dmabuf_ops_kmap,
> > +       .begin_cpu_access = vb2_dc_dmabuf_ops_begin_cpu_access,
> > +       .end_cpu_access = vb2_dc_dmabuf_ops_end_cpu_access,
> >         .vmap = vb2_dc_dmabuf_ops_vmap,
> >         .mmap = vb2_dc_dmabuf_ops_mmap,
> >         .release = vb2_dc_dmabuf_ops_release,
> > @@ -412,11 +462,12 @@ static void vb2_dc_put_userptr(void *buf_priv)
> >
> >         if (sgt) {
> >                 /*
> > -                * No need to sync to CPU, it's already synced to the CPU
> > -                * since the finish() memop will have been called before this.
> > +                * Don't ask to skip cache sync in case if the user
> > +                * did ask to skip cache flush the last time the
> > +                * buffer was dequeued.
> >                  */
> >                 dma_unmap_sg_attrs(buf->dev, sgt->sgl, sgt->orig_nents,
> > -                                  buf->dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> > +                                  buf->dma_dir, buf->attrs);
> 
> Hmm, what is "the user"?

The user space. I'll change the comment accordingly.

> 
> Regardless of that, we need to set DMA_ATTR_SKIP_CPU_SYNC by default
> for USERPTR to keep current behavior, but I don't see code doing that
> anywhere in this or previous patches.

Correct. We need to do that on ARM at least.

> 
> >                 pages = frame_vector_pages(buf->vec);
> >                 /* sgt should exist only if vector contains pages... */
> >                 BUG_ON(IS_ERR(pages));
> > @@ -491,6 +542,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
> >
> >         buf->dev = dev;
> >         buf->dma_dir = dma_dir;
> > +       buf->attrs = attrs;
> >
> >         offset = vaddr & ~PAGE_MASK;
> >         vec = vb2_create_framevec(vaddr, size, dma_dir == DMA_FROM_DEVICE);
> > @@ -526,13 +578,11 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
> >         buf->dma_sgt = &buf->__dma_sgt;
> >
> >         /*
> > -        * No need to sync to the device, this will happen later when the
> > -        * prepare() memop is called.
> > +        * Sync the cache now; the user might not ever ask for it.
> 
> Ditto.
> 
> >          */
> >         buf->dma_sgt->nents = dma_map_sg_attrs(buf->dev, buf->dma_sgt->sgl,
> >                                                buf->dma_sgt->orig_nents,
> > -                                              buf->dma_dir,
> > -                                              DMA_ATTR_SKIP_CPU_SYNC);
> > +                                              buf->dma_dir, buf->attrs);
> >         if (buf->dma_sgt->nents <= 0) {
> >                 pr_err("failed to map scatterlist\n");
> >                 ret = -EIO;
> > @@ -556,7 +606,7 @@ static void *vb2_dc_get_userptr(struct device *dev, unsigned long vaddr,
> >  fail_map_sg:
> >         dma_unmap_sg_attrs(buf->dev, buf->dma_sgt->sgl,
> >                            buf->dma_sgt->orig_nents, buf->dma_dir,
> > -                          DMA_ATTR_SKIP_CPU_SYNC);
> > +                          buf->attrs);
> 
> Ditto.
> 

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
