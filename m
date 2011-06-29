Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:14909 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1F2L2o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 07:28:44 -0400
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ00KFRUJTND@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 12:28:41 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ00ACRUJSMM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 12:28:40 +0100 (BST)
Date: Wed, 29 Jun 2011 13:28:21 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH/RFC] media: vb2: change queue initialization order
In-reply-to: <201106291301.40548.hansverk@cisco.com>
To: 'Hans Verkuil' <hansverk@cisco.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
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
Message-id: <001f01cc364f$a6b52f30$f41f8d90$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1309340946-5658-1-git-send-email-m.szyprowski@samsung.com>
 <201106291244.48473.laurent.pinchart@ideasonboard.com>
 <201106291301.40548.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, June 29, 2011 1:02 PM Hans Verkuil wrote:

> On Wednesday, June 29, 2011 12:44:48 Laurent Pinchart wrote:
> > Hi Marek,
> >
> > On Wednesday 29 June 2011 11:49:06 Marek Szyprowski wrote:
> > > This patch introduces VB2_STREAMON_WITHOUT_BUFFERS io flag and changes
> > > the order of operations during stream on operation. Now the buffer are
> > > first queued to the driver and then the start_streaming method is
> called.
> > > This resolves the most common case when the driver needs to know buffer
> > > addresses to enable dma engine and start streaming. For drivers that
> can
> > > handle start_streaming without queued buffers (mem2mem and 'one shot'
> > > capture case) a new VB2_STREAMON_WITHOUT_BUFFERS io flag has been
> > > introduced. Driver can set it to let videobuf2 know that it support
> this
> > > mode.
> >
> > Is starting/stopping DMA engines that expensive on most hardware ?
> Several
> > mails mentioned that drivers should keep one buffer around to avoid
> stopping
> > the DMA engine in case of buffer underrun. The OMAP3 ISP driver just
> stops
> the
> > ISP when it runs out of buffers, and restart it when a new buffer is
> queued.
> 
> Yes, this can be expensive. For video capture (e.g. from HDMI) you never
> want
> to stop capturing when you run out of buffers. Starting it up again will
> lead
> to a 1 or 2 frame delay, which is unacceptable for e.g. video conferencing.
> 
> And when I start the DMA engine I'd like to know whether only one buffer is
> queued or if I have two or more. In the latter case I can setup both the
> 'current' and 'next' pointers in the DMA engine which will make the first
> frame available quicker (otherwise you will probably get an additional
> frame
> delay).
> 
> > Switching the order of the start_streaming and __enqueue_in_driver calls
> would
> > make my life more difficult on the OMAP3 because I will have to check if
> the
> > queue is streaming in the qbuf callback. Your s5p-fimc driver has to
> check
> for
> > that as well. I wonder if it really helps for other drivers.
> 
> Why not add a 'is_streaming' boolean argument to enqueue_in_driver?

Again, thanks for the idea!

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


