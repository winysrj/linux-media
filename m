Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20307 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab1F2Kzu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 06:55:50 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ00JC2T11J4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 11:55:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ002E2T0ZZK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 11:55:47 +0100 (BST)
Date: Wed, 29 Jun 2011 12:55:27 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC] media: vb2: change queue initialization order
In-reply-to: <201106291244.48473.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Jonathan Corbet' <corbet@lwn.net>,
	=?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Marin Mitov' <mitov@issp.bas.bg>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <001d01cc364b$0e5106a0$2af313e0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
 <201106291244.48473.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, June 29, 2011 12:45 PM Laurent Pinchart wrote:

> On Wednesday 29 June 2011 11:49:06 Marek Szyprowski wrote:
> > This patch introduces VB2_STREAMON_WITHOUT_BUFFERS io flag and changes
> > the order of operations during stream on operation. Now the buffer are
> > first queued to the driver and then the start_streaming method is called.
> > This resolves the most common case when the driver needs to know buffer
> > addresses to enable dma engine and start streaming. For drivers that can
> > handle start_streaming without queued buffers (mem2mem and 'one shot'
> > capture case) a new VB2_STREAMON_WITHOUT_BUFFERS io flag has been
> > introduced. Driver can set it to let videobuf2 know that it support this
> > mode.
> 
> Is starting/stopping DMA engines that expensive on most hardware ?
> Several
> mails mentioned that drivers should keep one buffer around to avoid
> stopping
> the DMA engine in case of buffer underrun. The OMAP3 ISP driver just stops
> the
> ISP when it runs out of buffers, and restart it when a new buffer is queued.
> Switching the order of the start_streaming and __enqueue_in_driver calls
> would
> make my life more difficult on the OMAP3 because I will have to check if
> the
> queue is streaming in the qbuf callback. Your s5p-fimc driver has to check
> for
> that as well. I wonder if it really helps for other drivers.

I'm not an expert, but it looks that most drivers for consumer cards doesn't
stop/suspend dma engine until streamoff is called. I would also like to get
some more feedback on this issue.

> > This patch also updates videobuf2 clients (s5p-fimc, mem2mem_testdev and
> > vivi) to work properly with the changed order of operations and enables
> > use of the newly introduced flag.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > CC: Pawel Osciak <pawel@osciak.com>
> > ---
> >
> >  drivers/media/video/mem2mem_testdev.c       |    4 +-
> >  drivers/media/video/s5p-fimc/fimc-capture.c |   65
> > ++++++++++++++++----------
> > drivers/media/video/s5p-fimc/fimc-core.c    |    4 +-
> >  drivers/media/video/videobuf2-core.c        |   21 ++++-----
> >  drivers/media/video/vivi.c                  |    2 +-
> >  include/media/videobuf2-core.h              |   11 +++--
> >  6 files changed, 62 insertions(+), 45 deletions(-)
> >
> >
> > ---
> >
> > Hello,
> >
> > This patch introduces significant changes in the vb2 streamon operation,
> > so all vb2 clients need to be checked and updated. Right now I didn't
> > update mx3_camera and sh_mobile_ceu_camera drivers. Once we agree that
> > this patch can be merged, I will update it to include all the required
> > changes to these two drivers as well.
> >
> > Best regards
> > --
> > Marek Szyprowski
> > Samsung Poland R&D Center
> 
> [snip]
> 
> > diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> > index 2238a61..e740a44 100644
> > --- a/drivers/media/video/vivi.c
> > +++ b/drivers/media/video/vivi.c
> > @@ -1232,7 +1232,7 @@ static int __init vivi_create_instance(int inst)
> >         q = &dev->vb_vidq;
> >         memset(q, 0, sizeof(dev->vb_vidq));
> >         q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > -       q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_READ;
> > +       q->io_modes = VB2_MMAP | VB2_READ | VB2_STREAMON_WITHOUT_BUFFERS;
> 
> Why do you remove VB2_USERPTR support from vivi ?

Huh, this should go as a separate patch. vmalloc allocator still lacks support
for user pointer mode so there is no point advertising that vivi supports it.

> 
> >         q->drv_priv = dev;
> >         q->buf_struct_size = sizeof(struct vivi_buffer);
> >         q->ops = &vivi_video_qops;

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


