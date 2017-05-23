Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59914 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1758270AbdEWMfK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 08:35:10 -0400
Date: Tue, 23 May 2017 15:35:04 +0300
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
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Samu Onkalo <samu.onkalo@intel.com>
Subject: Re: [RFC v4 13/18] vb2: Don't sync cache for a buffer if so requested
Message-ID: <20170523123503.GC29527@valkosipuli.retiisi.org.uk>
References: <1494255810-12672-1-git-send-email-sakari.ailus@linux.intel.com>
 <1494255810-12672-14-git-send-email-sakari.ailus@linux.intel.com>
 <CAAFQd5CD_-754-xEXF7-r3SYWQoOn8FYVE_HXF_kuDfH2OtcYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5CD_-754-xEXF7-r3SYWQoOn8FYVE_HXF_kuDfH2OtcYQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Wed, May 10, 2017 at 07:00:10PM +0800, Tomasz Figa wrote:
> Hi Sakari,
> 
> Few comments inline.
> 
> On Mon, May 8, 2017 at 11:03 PM, Sakari Ailus
> <sakari.ailus@linux.intel.com> wrote:
> > From: Samu Onkalo <samu.onkalo@intel.com>
> >
> > The user may request to the driver (vb2) to skip the cache maintenance
> > operations in case the buffer does not need cache synchronisation, e.g. in
> > cases where the buffer is passed between hardware blocks without it being
> > touched by the CPU.
> [snip]
> > @@ -1199,6 +1236,11 @@ static int __prepare_dmabuf(struct vb2_buffer *vb, const void *pb)
> >                         dprintk(1, "buffer initialization failed\n");
> >                         goto err;
> >                 }
> > +
> > +               /* This is new buffer memory --- always synchronise cache. */
> > +               __mem_prepare_planes(vb);
> > +       } else if (!no_cache_sync) {
> > +               __mem_prepare_planes(vb);
> 
> Do we actually need this at all for DMABUF, given that respective
> callbacks in both vb2_dc and vb2_sg actually bail out if so?

I think the original purpose for the finish and prepare might have allowed
more than just cache synchronisation but that's all they've ever done. I
think the documentation should be changed to reflect this, and then we could
drop the call here.

There should be no need for this anyway.

> 
> >         }
> >
> >         ret = call_vb_qop(vb, buf_prepare, vb);
> [snip]
> > @@ -568,7 +571,11 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
> >         }
> >
> >         ret = vb2_queue_or_prepare_buf(q, b, "qbuf");
> > -       return ret ? ret : vb2_core_qbuf(q, b->index, b);
> > +       if (ret)
> > +               return ret;
> > +
> > +       return vb2_core_qbuf(q, b->index, b,
> > +                            b->flags & V4L2_BUF_FLAG_NO_CACHE_SYNC);
> 
> Can we really let the userspace alone control this? I believe there
> are drivers that need to do some fixup in OUTPUT buffers before
> sending to the hardware or in CAPTURE buffer after getting from the
> hardware, respectively in buf_prepare or buf_finish. I believe such
> driver needs to be able to override this behavior.

Good point.

> 
> Actually I'm wondering if we really need this buffer flag at all.
> Wouldn't the following work for typical use cases that we actually
> care about performance of?
> 
> buffer_needs_cache_sync = (buffer_type_is_MMAP &&
> buffer_is_non_coherent && (buffer_is_mmapped ||
> buffer_has_kernel_mapping)) || buffer_is_USERPTR

Not in general case. The information the driver does not have currently is
whether or not the user has accessed the buffer (written to it) at various
points. I don't think there's another way to handle this than let the user
tell this to the kernel.

Even now, V4L2 does not require the application not to write to CAPTURE
buffers which means that cache synchronisation operations will need to be
used even when queueing such a buffer. This is where the flag helps, too.

DMA-BUFs are a different matter, this is not really addressed by the
patchset.

> 
> The above should cover all the fast paths that are used only to
> exchange data between devices, without the CPU involved, assuming that
> drivers that don't need the fixups I mentioned before are properly
> updated to request no kernel mapping for allocated buffers.
> 
> I've added (buffer_is_USERPTR) to the equation as it's really hard to
> imagine a use case where there is no CPU access to the buffer, but
> USERPTR needs to be used (instead of DMABUF). I might be missing
> something, though.

If you have a USERPTR buffer the backed memory of which you use with two
devices and don't touch the buffer memory, no cache synchronisation will be
needed.

DMA-BUF would benefit from improvements in the same area.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
