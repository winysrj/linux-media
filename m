Return-path: <mchehab@pedra>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41228 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab1FMIgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2011 04:36:45 -0400
Date: Mon, 13 Jun 2011 10:36:40 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, kernel@pengutronix.de,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Subject: Re: vb2: about vb2_queue->queued_count
Message-ID: <20110613083640.GO15070@pengutronix.de>
References: <20110608204758.GA15070@pengutronix.de>
 <000b01cc2764$9cf53430$d6df9c90$%szyprowski@samsung.com>
 <20110610162849.GI15070@pengutronix.de>
 <006501cc2992$cb5633d0$62029b70$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <006501cc2992$cb5633d0$62029b70$%szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Mon, Jun 13, 2011 at 08:26:13AM +0200, Marek Szyprowski wrote:
> On Friday, June 10, 2011 6:29 PM Uwe Kleine-König wrote:
> 
> > On Fri, Jun 10, 2011 at 01:50:37PM +0200, Marek Szyprowski wrote:
> > > Hello,
> > >
> > > On Wednesday, June 08, 2011 10:48 PM Uwe Kleine-König wrote:
> > >
> > > > I'm still debugging my new video overlay device driver. The current
> > > > problem is again when playing back a second video.
> > > >
> > > > After streamoff is called at the end of the first video, I disable the
> > > > overlay and call vb2_buffer_done on the last buffer. This is exited
> > > > early because vb->state == VB2_BUF_STATE_DEQUEUED.
> > > > This results in vb->vb2_queue->queued_count being 1.
> > > >
> > > > Now if the new video starts I call vb2_queue_init in
> > the .vidioc_reqbufs
> > > > callback on my queue (that still has queued_count == 1). After
> > > > vb2_queue_init returns queued_count is still 1 though q->queued_list is
> > > > reset to be empty.
> > > >
> > > > __vb2_queue_cancel has a similar problem, &q->queued_list is reset, but
> > > > queued_count is not.
> > >
> > > Thanks again for finding the bug. You are right, __vb2_queue_cancel
> > should
> > > reset queued_count too. I will post a patch soon.
> > IMHO vb2_queue_init should reset queued_count, too. Not sure if you just
> > skipped to mention it here ....
> 
> vb2_queue_init assumes that the called allocated vb2_queue with kzalloc()
> or did memset(q, 0, sizeof(struct vb2_queue)), so it is not really required
> to explicitly set queued_count to zero.
Hmmm, I call vb2_queue_init in the callback .vidioc_reqbufs, because
AFAICT this is the only place where I get the needed info to set
q->type. As this looks wrong now, can you hint where to initialize the
queue instead?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
