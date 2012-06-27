Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab2F0UkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 16:40:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dima Zavin <dmitriyz@google.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv7 03/15] v4l: vb2: add support for shared buffer (dma_buf)
Date: Wed, 27 Jun 2012 22:40:25 +0200
Message-ID: <2867746.1nlzVAXyL8@avalon>
In-Reply-To: <CAPz4a6Cn9-f+nP6HeC94oiyJGqxesz40pWGp1ZxnA-gJZ4e=dQ@mail.gmail.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com> <201206261140.37666.hverkuil@xs4all.nl> <CAPz4a6Cn9-f+nP6HeC94oiyJGqxesz40pWGp1ZxnA-gJZ4e=dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dima,

On Tuesday 26 June 2012 13:53:34 Dima Zavin wrote:
> On Tue, Jun 26, 2012 at 2:40 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Tue 26 June 2012 11:11:06 Laurent Pinchart wrote:
> >> On Tuesday 26 June 2012 10:40:44 Tomasz Stanislawski wrote:
> >> > Hi Dima Zavin,
> >> > Thank you for the patch and for a ping remainder :).
> >> > 
> >> > You are right. The unmap is missing in __vb2_queue_cancel.
> >> > I will apply your fix into next version of V4L2 support for dmabuf.
> >> > 
> >> > Please refer to some comments below.
> >> > 
> >> > On 06/20/2012 08:12 AM, Dima Zavin wrote:
> >> > > Tomasz,
> >> > > 
> >> > > I've encountered an issue with this patch when userspace does several
> >> > > stream_on/stream_off cycles. When the user tries to qbuf a buffer
> >> > > after doing stream_off, we trigger the "dmabuf already pinned"
> >> > > warning since we didn't unmap the buffer as dqbuf was never called.
> >> > > 
> >> > > The below patch adds calls to unmap in queue_cancel, but my feeling
> >> > > is that we probably should be calling detach too (i.e. put_dmabuf).
> >> 
> >> According to the V4L2 specification, the "VIDIOC_STREAMOFF ioctl, apart
> >> of aborting or finishing any DMA in progress, unlocks any user pointer
> >> buffers locked in physical memory, and it removes all buffers from the
> >> incoming and outgoing queues".
> > 
> > Correct. And what that means in practice is that after a streamoff all
> > buffers are returned to the state they had just before STREAMON was
> > called.
>
> That can't be right. The buffers had to have been returned to the
> state just *after REQBUFS*, not just *before STREAMON*. You need to
> re-enqueue buffers before calling STREAMON. I assume that's what you
> meant?

Your interpretation is correct.

> > So after STREAMOFF you can immediately queue all buffers again with QBUF
> > and call STREAMON to restart streaming. No mmap or other operations
> > should be required. This behavior must be kept.
> > 
> > VIDIOC_REQBUFS() or a close() are the only two operations that will
> > actually free the buffers completely.
> > 
> > In practice, a STREAMOFF is either followed by a STREAMON at a later time,
> > or almost immediately followed by REQBUFS or close() to tear down the
> > buffers. So I don't think the buffers should be detached at streamoff.
> 
> I agree. I was leaning this way which is why I left it out of my patch
> and wanted to hear your guys' opinion as you are much more familiar
> with the intended behavior than I am.
> 
> Thanks!

You're welcome. Thank you for reporting the problem and providing a patch.

-- 
Regards,

Laurent Pinchart

