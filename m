Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12722 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab1FMG0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 02:26:45 -0400
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-2
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LMP00F87TWIWW70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jun 2011 07:26:43 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMP00I1RTWHNV@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Jun 2011 07:26:42 +0100 (BST)
Date: Mon, 13 Jun 2011 08:26:13 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: vb2: about vb2_queue->queued_count
In-reply-to: <20110610162849.GI15070@pengutronix.de>
To: =?iso-8859-2?Q?'Uwe_Kleine-K=F6nig'?=
	<u.kleine-koenig@pengutronix.de>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Message-id: <006501cc2992$cb5633d0$62029b70$%szyprowski@samsung.com>
Content-language: pl
Content-transfer-encoding: 8BIT
References: <20110608204758.GA15070@pengutronix.de>
 <000b01cc2764$9cf53430$d6df9c90$%szyprowski@samsung.com>
 <20110610162849.GI15070@pengutronix.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Friday, June 10, 2011 6:29 PM Uwe Kleine-König wrote:

> On Fri, Jun 10, 2011 at 01:50:37PM +0200, Marek Szyprowski wrote:
> > Hello,
> >
> > On Wednesday, June 08, 2011 10:48 PM Uwe Kleine-König wrote:
> >
> > > I'm still debugging my new video overlay device driver. The current
> > > problem is again when playing back a second video.
> > >
> > > After streamoff is called at the end of the first video, I disable the
> > > overlay and call vb2_buffer_done on the last buffer. This is exited
> > > early because vb->state == VB2_BUF_STATE_DEQUEUED.
> > > This results in vb->vb2_queue->queued_count being 1.
> > >
> > > Now if the new video starts I call vb2_queue_init in
> the .vidioc_reqbufs
> > > callback on my queue (that still has queued_count == 1). After
> > > vb2_queue_init returns queued_count is still 1 though q->queued_list is
> > > reset to be empty.
> > >
> > > __vb2_queue_cancel has a similar problem, &q->queued_list is reset, but
> > > queued_count is not.
> >
> > Thanks again for finding the bug. You are right, __vb2_queue_cancel
> should
> > reset queued_count too. I will post a patch soon.
> IMHO vb2_queue_init should reset queued_count, too. Not sure if you just
> skipped to mention it here ....

vb2_queue_init assumes that the called allocated vb2_queue with kzalloc()
or did memset(q, 0, sizeof(struct vb2_queue)), so it is not really required
to explicitly set queued_count to zero.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



