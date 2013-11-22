Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2455 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3KVJDT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Nov 2013 04:03:19 -0500
Message-ID: <528F1DB9.6030702@xs4all.nl>
Date: Fri, 22 Nov 2013 10:02:49 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, awalls@md.metrocast.net,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 1/8] vb2: push the mmap semaphore down to __buf_prepare()
References: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl> <1385047326-23099-2-git-send-email-hverkuil@xs4all.nl> <6539252.6X3kkSkupS@avalon>
In-Reply-To: <6539252.6X3kkSkupS@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/21/2013 08:04 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Thursday 21 November 2013 16:21:59 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Rather than taking the mmap semaphore at a relatively high-level function,
>> push it down to the place where it is really needed.
>>
>> It was placed in vb2_queue_or_prepare_buf() to prevent racing with other
>> vb2 calls, however, I see no way that any race can happen.
> 
> What about the following scenario ? Both QBUF calls are performed on the same 
> buffer.
> 
> 	CPU 0							CPU 1
> 	-------------------------------------------------------------------------
> 	QBUF								QBUF
> 		locks the queue mutex				waits for the queue mutex
> 	vb2_qbuf
> 	vb2_queue_or_prepare_buf
> 	__vb2_qbuf
> 		checks vb->state, calls
> 	__buf_prepare
> 	call_qop(q, wait_prepare, q);
> 		unlocks the queue mutex
> 										locks the queue mutex
> 									vb2_qbuf
> 									vb2_queue_or_prepare_buf
> 									__vb2_qbuf
> 										checks vb->state, calls
> 									__buf_prepare
> 									call_qop(q, wait_prepare, q);
> 										unlocks the queue mutex
> 
> 									queue the buffer, set buffer
> 									 state to queue
> 
> 	queue the buffer, set buffer
> 	 state to queue
> 
> 
> We would thus end up queueing the buffer twice. The vb->state check needs to 
> be performed after the brief release of the queue mutex.

Good point, I hadn't thought about that scenario. However, using mmap_sem to
introduce a large critical section just to protect against state changes is IMHO
not the right approach. Why not introduce a VB2_BUF_STATE_PREPARING state?

That's set at the start of __buf_prepare while the queue mutex is still held, and
which prevents other threads of queuing the same buffer again. If the prepare fails,
then the state is reverted back to DEQUEUED.

__fill_v4l2_buffer() will handle the PREPARING state as if it was the DEQUEUED state.

What do you think?

Regards,

	Hans
