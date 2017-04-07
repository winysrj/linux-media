Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45738 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754564AbdDGMhe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Apr 2017 08:37:34 -0400
Date: Fri, 7 Apr 2017 15:37:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>
Subject: Re: [RFC v2 07/11] vb2: dma-contig: Remove redundant sgt_base field
Message-ID: <20170407123728.GH4192@valkosipuli.retiisi.org.uk>
References: <20161216012425.11179-1-laurent.pinchart+renesas@ideasonboard.com>
 <20161216012425.11179-8-laurent.pinchart+renesas@ideasonboard.com>
 <CAKocOOPipHsPR-rhOzMOt=12c0nuQ=SpkAKCygjGzWbWki1P5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKocOOPipHsPR-rhOzMOt=12c0nuQ=SpkAKCygjGzWbWki1P5A@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Mon, Mar 27, 2017 at 04:51:40PM -0600, Shuah Khan wrote:
> On Thu, Dec 15, 2016 at 6:24 PM, Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> >
> > The struct vb2_dc_buf contains two struct sg_table fields: sgt_base and
> > dma_sgt. The former is used by DMA-BUF buffers whereas the latter is used
> > by USERPTR.
> >
> > Unify the two, leaving dma_sgt.
> 
> I think this patch should be split in two.
> 
> 1. Unifying dma_sgt and sgt_base
> 
> >
> > MMAP buffers do not need cache flushing since they have been allocated
> > using dma_alloc_coherent().
> 
> 2. That uses vec to check for checking for no flush needed condition.

I can split this, sure. A non-NULL vec indicates a USERPTR buffer. Before
this patch, non-NULL buf->dma_sgt did the same.

> 
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Changes since v1:
> >
> > - Test for MMAP or DMABUF type through the vec field instead of the now
> >   gone vma field.
> 
> What is this gone vma field? Did I miss a patch in the series that
> makes this change? This check that is changed used dma_sgt and
> db_attach vma
> 

The field existed on bc0195aad0daa2ad5b0d76cce22b167bc3435590, i.e. v4.2-rc2
from which the earlier version of this patch was rebased from.

> These comments don't agree with the code change.
> 
> > - Move the vec field to a USERPTR section in struct vb2_dc_buf, where
> >   the vma field was located.
> > ---
> >  drivers/media/v4l2-core/videobuf2-dma-contig.c | 25 +++++++++++++------------
> >  1 file changed, 13 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > index fb6a177be461..2a00d12ffee2 100644
> > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > @@ -30,12 +30,13 @@ struct vb2_dc_buf {
> >         unsigned long                   attrs;
> >         enum dma_data_direction         dma_dir;
> >         struct sg_table                 *dma_sgt;
> > -       struct frame_vector             *vec;
> >
> >         /* MMAP related */
> >         struct vb2_vmarea_handler       handler;
> >         atomic_t                        refcount;
> > -       struct sg_table                 *sgt_base;
> > +
> > +       /* USERPTR related */
> > +       struct frame_vector             *vec;
> >
> >         /* DMABUF related */
> >         struct dma_buf_attachment       *db_attach;
> > @@ -95,7 +96,7 @@ static void vb2_dc_prepare(void *buf_priv)
> >         struct sg_table *sgt = buf->dma_sgt;
> >
> >         /* DMABUF exporter will flush the cache for us */
> > -       if (!sgt || buf->db_attach)
> > +       if (!buf->vec)
> >                 return;
> 
> With the unification dma_sgt is valid for MMAP buffers after vb2_dma_sg_alloc()
> if dma_sgt is not null, sync happens - the patch description doesn't seem to be
> in sync with the change.

I'm not sure what you're referring to. The condition for sync is changed to
use buf->vec instead, i.e. the functionality is not affected.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
