Return-path: <mchehab@pedra>
Received: from rtp-iport-1.cisco.com ([64.102.122.148]:29467 "EHLO
	rtp-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab1F2LBy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 07:01:54 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH/RFC] media: vb2: change queue initialization order
Date: Wed, 29 Jun 2011 13:01:40 +0200
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Uwe =?iso-8859-15?q?Kleine-K=F6nig?="
	<u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marin Mitov <mitov@issp.bas.bg>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com> <201106291244.48473.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106291244.48473.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291301.40548.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 29, 2011 12:44:48 Laurent Pinchart wrote:
> Hi Marek,
> 
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
> Is starting/stopping DMA engines that expensive on most hardware ? Several 
> mails mentioned that drivers should keep one buffer around to avoid stopping 
> the DMA engine in case of buffer underrun. The OMAP3 ISP driver just stops 
the 
> ISP when it runs out of buffers, and restart it when a new buffer is queued. 

Yes, this can be expensive. For video capture (e.g. from HDMI) you never want 
to stop capturing when you run out of buffers. Starting it up again will lead 
to a 1 or 2 frame delay, which is unacceptable for e.g. video conferencing.

And when I start the DMA engine I'd like to know whether only one buffer is 
queued or if I have two or more. In the latter case I can setup both the 
'current' and 'next' pointers in the DMA engine which will make the first 
frame available quicker (otherwise you will probably get an additional frame 
delay).

> Switching the order of the start_streaming and __enqueue_in_driver calls 
would 
> make my life more difficult on the OMAP3 because I will have to check if the 
> queue is streaming in the qbuf callback. Your s5p-fimc driver has to check 
for 
> that as well. I wonder if it really helps for other drivers.

Why not add a 'is_streaming' boolean argument to enqueue_in_driver?

Regards,

	Hans

> 
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
> 
> >         q->drv_priv = dev;
> >         q->buf_struct_size = sizeof(struct vivi_buffer);
> >         q->ops = &vivi_video_qops;
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
