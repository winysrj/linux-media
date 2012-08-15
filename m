Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45437 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314Ab2HOBMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 21:12:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Dima Zavin <dmitriyz@google.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, airlied@redhat.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv7 03/15] v4l: vb2: add support for shared buffer (dma_buf)
Date: Wed, 15 Aug 2012 03:13:01 +0200
Message-ID: <8969870.LBKalEQJ5u@avalon>
In-Reply-To: <501AAB51.5050408@samsung.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com> <2867746.1nlzVAXyL8@avalon> <501AAB51.5050408@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Thursday 02 August 2012 18:31:13 Tomasz Stanislawski wrote:
> On 06/27/2012 10:40 PM, Laurent Pinchart wrote:
> > On Tuesday 26 June 2012 13:53:34 Dima Zavin wrote:
> >> On Tue, Jun 26, 2012 at 2:40 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>> On Tue 26 June 2012 11:11:06 Laurent Pinchart wrote:
> >>>> On Tuesday 26 June 2012 10:40:44 Tomasz Stanislawski wrote:
> >>>>> Hi Dima Zavin,
> >>>>> Thank you for the patch and for a ping remainder :).
> >>>>> 
> >>>>> You are right. The unmap is missing in __vb2_queue_cancel.
> >>>>> I will apply your fix into next version of V4L2 support for dmabuf.
> >>>>> 
> >>>>> Please refer to some comments below.
> >>>>> 
> >>>>> On 06/20/2012 08:12 AM, Dima Zavin wrote:
> >>>>>> Tomasz,
> >>>>>> 
> >>>>>> I've encountered an issue with this patch when userspace does several
> >>>>>> stream_on/stream_off cycles. When the user tries to qbuf a buffer
> >>>>>> after doing stream_off, we trigger the "dmabuf already pinned"
> >>>>>> warning since we didn't unmap the buffer as dqbuf was never called.
> >>>>>> 
> >>>>>> The below patch adds calls to unmap in queue_cancel, but my feeling
> >>>>>> is that we probably should be calling detach too (i.e. put_dmabuf).
> >>>> 
> >>>> According to the V4L2 specification, the "VIDIOC_STREAMOFF ioctl, apart
> >>>> of aborting or finishing any DMA in progress, unlocks any user pointer
> >>>> buffers locked in physical memory, and it removes all buffers from the
> >>>> incoming and outgoing queues".
> >>> 
> >>> Correct. And what that means in practice is that after a streamoff all
> >>> buffers are returned to the state they had just before STREAMON was
> >>> called.
> >> 
> >> That can't be right. The buffers had to have been returned to the
> >> state just *after REQBUFS*, not just *before STREAMON*. You need to
> >> re-enqueue buffers before calling STREAMON. I assume that's what you
> >> meant?
> > 
> > Your interpretation is correct.
> 
> So now we should decide what should be changed: the spec or vb2 ?
> Bringing the queue state back to *after REQBUFS* may make the
> next (STREAMON + QBUFs) very costly operations.
> 
> Reattaching and mapping a DMABUF might trigger DMA allocation and
> *will* trigger creation of IOMMU mappings. In case of a user pointer,
> calling next get_user_pages may cause numerous fault events and
> will *create* new IOMMU mapping.
> 
> Is there any need to do such a cleanup if the destruction of buffers
> and all caches can be explicitly executed by REQBUFS(count = 0) ?

STREAMOFF needs to pass ownership of all buffers to the application. In 
practice this means that buffers must then be ready to be passed to other 
devices, requeued to the same device, or destroyed completely.

We can't keep the buffers in the V4L2 prepared state, as queueing them would 
then skip cache handling. Keeping the mapping around could be done though, but 
would not be compliant with the V4L2 spec as the DMABUF would then not be 
freed until we call REQBUFS(0).

Changing the spec might be possible. I'll need to think more about this, but 
I'm not very fond of the way we allow a new DMABUF fd (as well as USERPTR 
pointer) to be associated with an existing buffer, replacing the currently 
associated fd/pointer. This makes the API asymetrical: it provides an explicit 
way to associate an fd/pointer with a buffer, but no explicit way to break 
that association.

It's obviously too late to change this for USERPTR, but for DMABUF we could 
make the buffer/fd association immutable. This would require a way to 
selectively destroy buffers though, or at least to explicitly break the 
association.

> Maybe it would be easier to change the spec by removing
> "apart of ... in physical memory" part?
> 
> STREAMOFF should mean stopping streaming, and that resources are no
> longer used. DMABUFs are unmapped but unmapping does not mean releasing.
> The exporter may keep the resource in its caches.

If the DMABUF implementation follows the USERPTR spec, applications will 
expect a STREAMOFF call to release all DMABUF instances associated with the 
buffers. This means that a DMABUF that is only referenced by a V4L2 buffer 
will get destroyed by a STREAMOFF call. The more I think about it the more 
this sounds wrong to me. STREAMOFF has never been tasked with freeing 
resources. As we lack a way to selectively break the fd (or pointer) to buffer 
association created at buffer prepare or queue time, applications would have 
to call REQBUFS(0) to release all buffers, even if they will then want to 
start a new capture run. This might be costly (although probably not in the 
USERPTR and DMABUF cases), and doesn't allow to unmap DMABUF instances 
selectively.

Maybe an UNPREPARE ioctl would be needed ?

> Currently, vb2 does not follow the policy from the spec.
> The put_userptr ops is called on:
> - VIDIOC_REBUFS
> - VIDIOC_CREATE_BUFS
> - vb2_queue_release() which is usually called on close() syscall
> 
> The put_userptr is not called and streamoff therefore the user pages
> are locked after STREAMOFF.
> 
> BTW. What does 'buffer locked' mean?
> 
> Does it mean that a buffer is pinned or referenced by a driver/HW?

In this context I think it refers to pinning pages in memory.

-- 
Regards,

Laurent Pinchart

