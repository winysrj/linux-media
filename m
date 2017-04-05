Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44956 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755214AbdDENOW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 5 Apr 2017 09:14:22 -0400
Date: Wed, 5 Apr 2017 16:13:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ricky Liang <jcliang@chromium.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Laura Abbott <labbott@redhat.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [RFC, v2, 10/11] vb2: dma-contig: Let drivers decide DMA attrs
 of MMAP and USERPTR bufs
Message-ID: <20170405131345.GA3265@valkosipuli.retiisi.org.uk>
References: <20161216012425.11179-11-laurent.pinchart+renesas@ideasonboard.com>
 <CAAJzSMep+qccM+UV+T-wgpqTNPYD3yHWqpjJbhH5v4NLxjqZ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAJzSMep+qccM+UV+T-wgpqTNPYD3yHWqpjJbhH5v4NLxjqZ=w@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricky,

On Mon, Dec 26, 2016 at 03:58:07PM +0800, Ricky Liang wrote:
> Hi Laurent,
> 
> On Fri, Dec 16, 2016 at 9:24 AM, Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> wrote:
> > From: Sakari Ailus <sakari.ailus@linux.intel.com>
> >
> > The desirable DMA attributes are not generic for all devices using
> > Videobuf2 contiguous DMA ops. Let the drivers decide.
> >
> > This change also results in MMAP buffers always having an sg_table
> > (dma_sgt field).
> >
> > Also arrange the header files alphabetically.
> >
> > As a result, also the DMA-BUF exporter must provide ops for synchronising
> > the cache. This adds begin_cpu_access and end_cpu_access ops to
> > vb2_dc_dmabuf_ops.
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> >  drivers/media/v4l2-core/videobuf2-dma-contig.c | 66 ++++++++++++++++++++++----
> >  1 file changed, 56 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > index d503647ea522..a0e88ad93f07 100644
> > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > @@ -11,11 +11,11 @@
> >   */
> >
> >  #include <linux/dma-buf.h>
> > +#include <linux/dma-mapping.h>
> >  #include <linux/module.h>
> >  #include <linux/scatterlist.h>
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> > -#include <linux/dma-mapping.h>
> >
> >  #include <media/videobuf2-v4l2.h>
> >  #include <media/videobuf2-dma-contig.h>
> > @@ -115,8 +115,11 @@ static void vb2_dc_prepare(void *buf_priv)
> >         struct vb2_dc_buf *buf = buf_priv;
> >         struct sg_table *sgt = buf->dma_sgt;
> >
> > -       /* DMABUF exporter will flush the cache for us */
> > -       if (!buf->vec)
> > +       /*
> > +        * DMABUF exporter will flush the cache for us; only USERPTR
> > +        * and MMAP buffers with non-coherent memory will be flushed.
> > +        */
> > +       if (!(buf->attrs & DMA_ATTR_NON_CONSISTENT))
> 
> Should here be "if (!buf->vec || !(buf->attrs & DMA_ATTR_NON_CONSISTENT))" ?

The patch was originally using struct dma_attrs and I believe rebasing
changed how it it works. Thank you for pointing that out.

Using buf->vec for the purpose alone is not enough since also MMAP buffers
may require cache synchronisation from this patch onwards.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
