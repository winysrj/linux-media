Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23025 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab1F2L1B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 07:27:01 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ00LU9UH0W4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 12:27:00 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ00A7VUGYMM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 12:26:59 +0100 (BST)
Date: Wed, 29 Jun 2011 13:26:39 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC] media: vb2: change queue initialization order
In-reply-to: <201106291315.10611.hansverk@cisco.com>
To: 'Hans Verkuil' <hansverk@cisco.com>
Cc: linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Jonathan Corbet' <corbet@lwn.net>,
	=?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	'Marin Mitov' <mitov@issp.bas.bg>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <001e01cc364f$6a1b6bc0$3e524340$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
 <201106291315.10611.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, June 29, 2011 1:15 PM Hans Verkuil wrote:

> On Wednesday, June 29, 2011 11:49:06 Marek Szyprowski wrote:
> > This patch introduces VB2_STREAMON_WITHOUT_BUFFERS io flag and changes
> > the order of operations during stream on operation. Now the buffer are
> > first queued to the driver and then the start_streaming method is called.
> > This resolves the most common case when the driver needs to know buffer
> > addresses to enable dma engine and start streaming. For drivers that can
> > handle start_streaming without queued buffers (mem2mem and 'one shot'
> > capture case) a new VB2_STREAMON_WITHOUT_BUFFERS io flag has been
> > introduced. Driver can set it to let videobuf2 know that it support this
> > mode.
> >
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
> ++++++++++++++++----------
> >  drivers/media/video/s5p-fimc/fimc-core.c    |    4 +-
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
> >
> 
> <snip>
> 
> > diff --git a/drivers/media/video/videobuf2-core.c
> b/drivers/media/video/videobuf2-core.c
> > index 5517913..911e2eb 100644
> > --- a/drivers/media/video/videobuf2-core.c
> > +++ b/drivers/media/video/videobuf2-core.c
> > @@ -1136,17 +1136,23 @@ int vb2_streamon(struct vb2_queue *q, enum
> v4l2_buf_type type)
> >  	}
> >
> >  	/*
> > -	 * Cannot start streaming on an OUTPUT device if no buffers have
> > -	 * been queued yet.
> > +	 * Cannot start streaming if driver requires queued buffers.
> >  	 */
> > -	if (V4L2_TYPE_IS_OUTPUT(q->type)) {
> > +	if (!(q->io_flags & VB2_STREAMON_WITHOUT_BUFFERS)) {
> >  		if (list_empty(&q->queued_list)) {
> > -			dprintk(1, "streamon: no output buffers queued\n");
> > +			dprintk(1, "streamon: no buffers queued\n");
> >  			return -EINVAL;
> >  		}
> >  	}
> >
> >  	/*
> > +	 * If any buffers were queued before streamon,
> > +	 * we can now pass them to driver for processing.
> > +	 */
> > +	list_for_each_entry(vb, &q->queued_list, queued_entry)
> > +		__enqueue_in_driver(vb);
> > +
> > +	/*
> >  	 * Let driver notice that streaming state has been enabled.
> >  	 */
> >  	ret = call_qop(q, start_streaming, q);
> 
> Am I missing something? What is the purpose of this flag? Why not let the
> driver check in start_streaming whether any buffers have been queued and
> return -EINVAL if there aren't any? Between setting a flag or just doing
> the test in start_streaming I would prefer just doing the test.
> 
> To make it even easier you can perhaps add an extra argument to
> start_streaming with the number of buffers that are already queued.

Ok, this sounds reasonable, it looks that I over-engineered it again...

> I can't help thinking that this is made more difficult than it really is.

Thanks for the idea!

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


