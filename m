Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35887 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932247AbdDGLl7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Apr 2017 07:41:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
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
Subject: Re: [RFC, v2, 10/11] vb2: dma-contig: Let drivers decide DMA attrs of MMAP and USERPTR bufs
Date: Fri, 07 Apr 2017 14:42:46 +0300
Message-ID: <1650909.85IA3cvLDY@avalon>
In-Reply-To: <CAAJzSMep+qccM+UV+T-wgpqTNPYD3yHWqpjJbhH5v4NLxjqZ=w@mail.gmail.com>
References: <20161216012425.11179-11-laurent.pinchart+renesas@ideasonboard.com> <CAAJzSMep+qccM+UV+T-wgpqTNPYD3yHWqpjJbhH5v4NLxjqZ=w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricky,

On Monday 26 Dec 2016 15:58:07 Ricky Liang wrote:
> On Fri, Dec 16, 2016 at 9:24 AM, Laurent Pinchart wrote:
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
> > 
> >  drivers/media/v4l2-core/videobuf2-dma-contig.c | 66 +++++++++++++++++----
> >  1 file changed, 56 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > b/drivers/media/v4l2-core/videobuf2-dma-contig.c index
> > d503647ea522..a0e88ad93f07 100644
> > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c

[snip]

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

I don't think so. buf->vec indicates that the buffer is using USERPTR. The 
check would thus return immediately for everything that is not USERPTR. What 
we want to do is return for DMABUF, and for MMAP and USERPTR buffers that 
don't have the DMA_ATTR_NON_CONSISTENT attribute set. As DMABUF buffers never 
have that attribute set (because attrs is set in vb2_dc_alloc, which is not 
called for DMABUF buffers), we can check the flag only.

> >                 return;
> >         
> >         dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,

-- 
Regards,

Laurent Pinchart
