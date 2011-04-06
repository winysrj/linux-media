Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:42427 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab1DFHgx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2011 03:36:53 -0400
Received: from epmmp1 (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LJ70084FZTEJZ70@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 16:36:50 +0900 (KST)
Received: from AMDC159 ([106.116.37.153])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LJ7004VKZT6GK@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Apr 2011 16:36:50 +0900 (KST)
Date: Wed, 06 Apr 2011 09:36:41 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 1/5] [media] vb2: redesign the stop_streaming() callback
 and make it obligatory
In-reply-to: <BANLkTi=MJdNSXyQdX3gdQR=dU6Q0KQXQuQ@mail.gmail.com>
To: 'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	g.liakhovetski@gmx.de
Message-id: <000101cbf42d$6148fcb0$23daf610$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1301874670-14833-1-git-send-email-pawel@osciak.com>
 <1301874670-14833-2-git-send-email-pawel@osciak.com>
 <006401cbf28c$02105880$06310980$%szyprowski@samsung.com>
 <BANLkTi=MJdNSXyQdX3gdQR=dU6Q0KQXQuQ@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, April 06, 2011 5:03 AM Pawel Osciak wrote:

> On Sun, Apr 3, 2011 at 22:49, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> > Hello,
> >
> > On Monday, April 04, 2011 1:51 AM Pawel Osciak wrote:
> >
> >> Drivers are now required to implement the stop_streaming() callback
> >> to ensure that all ongoing hardware operations are finished and their
> >> ownership of buffers is ceded.
> >> Drivers do not have to call vb2_buffer_done() for each buffer they own
> >> anymore.
> >> Also remove the return value from the callback.
> >>
> >> Signed-off-by: Pawel Osciak <pawel@osciak.com>
> >> ---
> >>  drivers/media/video/videobuf2-core.c |   16 ++++++++++++++--
> >>  include/media/videobuf2-core.h       |   16 +++++++---------
> >>  2 files changed, 21 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> >> index 6e69584..59d5e8b 100644
> >> --- a/drivers/media/video/videobuf2-core.c
> >> +++ b/drivers/media/video/videobuf2-core.c
> >> @@ -640,6 +640,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
> >>       struct vb2_queue *q = vb->vb2_queue;
> >>       unsigned long flags;
> >>
> >> +     if (atomic_read(&q->queued_count) == 0)
> >> +             return;
> >> +
> >>       if (vb->state != VB2_BUF_STATE_ACTIVE)
> >>               return;
> >>
> >> @@ -1178,12 +1181,20 @@ static void __vb2_queue_cancel(struct vb2_queue *q)
> >>       unsigned int i;
> >>
> >>       /*
> >> -      * Tell driver to stop all transactions and release all queued
> >> +      * Tell the driver to stop all transactions and release all queued
> >>        * buffers.
> >>        */
> >>       if (q->streaming)
> >>               call_qop(q, stop_streaming, q);
> >> +
> >> +     /*
> >> +      * All buffers should now not be in use by the driver anymore, but we
> >> +      * have to manually set queued_count to 0, as the driver was not
> >> +      * required to call vb2_buffer_done() from stop_streaming() for all
> >> +      * buffers it had queued.
> >> +      */
> >>       q->streaming = 0;
> >> +     atomic_set(&q->queued_count, 0);
> >
> > If you removed the need to call vb2_buffer_done() then you must also call
> > wake_up_all(&q->done_wq) to wake any other threads/processes that might be
> > sleeping waiting for buffers.
> 
> You made me doubt myself for a second there, but the patch is correct.
> There is a call to wake_up_all a few lines below this.

Yes, I must have been blind or really tired that I've missed it. I'm sorry 
for the confusion.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


