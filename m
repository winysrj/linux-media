Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46428 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756518Ab3KZPma (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Nov 2013 10:42:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/8] vb2: push the mmap semaphore down to __buf_prepare()
Date: Tue, 26 Nov 2013 16:42:32 +0100
Message-ID: <6105887.nidGlvWj4k@avalon>
In-Reply-To: <528F1DB9.6030702@xs4all.nl>
References: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl> <6539252.6X3kkSkupS@avalon> <528F1DB9.6030702@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 22 November 2013 10:02:49 Hans Verkuil wrote:
> On 11/21/2013 08:04 PM, Laurent Pinchart wrote:
> > On Thursday 21 November 2013 16:21:59 Hans Verkuil wrote:
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >> 
> >> Rather than taking the mmap semaphore at a relatively high-level
> >> function, push it down to the place where it is really needed.
> >> 
> >> It was placed in vb2_queue_or_prepare_buf() to prevent racing with other
> >> vb2 calls, however, I see no way that any race can happen.
> > 
> > What about the following scenario ? Both QBUF calls are performed on the
> > same buffer.
> > 
> > 	CPU 0							CPU 1
> > 	-------------------------------------------------------------------------
> > 	QBUF								QBUF
> > 		locks the queue mutex				waits for the queue mutex
> > 	vb2_qbuf
> > 	vb2_queue_or_prepare_buf
> > 	__vb2_qbuf
> > 		checks vb->state, calls
> > 	__buf_prepare
> > 	call_qop(q, wait_prepare, q);
> > 		unlocks the queue mutex
> > 		
> > 										locks the queue mutex
> > 									vb2_qbuf
> > 									vb2_queue_or_prepare_buf
> > 									__vb2_qbuf
> > 										checks vb->state, calls
> > 									__buf_prepare
> > 									call_qop(q, wait_prepare, q);
> > 										unlocks the queue mutex
> > 									queue the buffer, set buffer
> > 									 state to queue
> > 	
> > 	queue the buffer, set buffer
> > 	 state to queue
> > 
> > We would thus end up queueing the buffer twice. The vb->state check needs
> > to be performed after the brief release of the queue mutex.
> 
> Good point, I hadn't thought about that scenario. However, using mmap_sem to
> introduce a large critical section just to protect against state changes is
> IMHO not the right approach. Why not introduce a VB2_BUF_STATE_PREPARING
> state?

Note that we use the queue mutex to do so, not mmap_sem. The problem is that 
we can't release the queue mutex in the middle of a critical section without 
risking being preempted by another task. Introducing a new state might be 
possible if it effectively breaks the critical section in two independent 
parts.

> That's set at the start of __buf_prepare while the queue mutex is still
> held, and which prevents other threads of queuing the same buffer again. If
> the prepare fails, then the state is reverted back to DEQUEUED.
> 
> __fill_v4l2_buffer() will handle the PREPARING state as if it was the
> DEQUEUED state.
> 
> What do you think?

I'll have to review that in details given the potential complexity of locking 
issues :-) I'm not opposed to the idea, if it works I believe we should do it.

-- 
Regards,

Laurent Pinchart

