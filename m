Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21379 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0DAO70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 10:59:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L0700BZQDMZXT80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 15:59:23 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L0700CJVDMZWY@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Apr 2010 15:59:23 +0100 (BST)
Date: Thu, 01 Apr 2010 16:57:24 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [RFC] Non-FIFO waiting on buffers in videobuf
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <004501cad1ab$a350ba30$e9f22e90$%osciak@samsung.com>
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

we would like to propose a change to how videobuf handles the process
of waking up buffers, to allow returning them to userspace in a different
order than FIFO, if a driver (device) so requires.

Currently, when poll() or dqbuf() is called, videobuf takes the first
(i.e. first qbuf()-ed) buffer from the stream queue and waits for it
to change its state (if it has not changed already).

In other words, it is assumed that buffers are consumed in FIFO order
and that they should be dequeued in that order as well.

It would be essential for some of our devices though, particularly video
codecs, to allow dequeuing buffers not only in FIFO order, but just any
buffer that has been consumed. Video codecs may need to hold some buffers
(usually keyframes) for longer periods of time than others.

Moreover, there is no way in V4L2 API to wait for a particular buffer.
According to it, buffer index in v4l2_buffer has and can only be filled
by a driver anyway. So switching to waiting for any buffer - instead of
for the first one - is not a breach of V4L2 API. 

And unless I am missing something, since videobuf always uses the first
buffer, why have separate queues in each? Drivers could use any other way
to indicate that they are finished with the particular buffer instead of
waking up their queues (actually, they are already - by marking them with
VIDEOBUF_ERROR or VIDEOBUF_DONE). So the current method seems superfluous.

I am not really fond of the way in which drivers have to finish operations
on buffers at the moment anyway. Normally, it is done in a way similar to:


/* buf points to the buffer to be returned */
spin_lock_irqsave(irqlock, ...);

/* take buf off of driver's queue */
list_del(&buf->vb.queue);

buf->vb.state = VIDEOBUF_DONE; /* or VIDEOBUF_ERROR */
wake_up(&buf->vb.done);

spin_unlock_irqrestore(irqlock, ...);


Wouldn't it be more clear if drivers called some kind of a finish()
function in videobuf instead, which would mark the buffers as DONE/ERROR
and wake them up? I am not convinced that drivers have to be aware of
the videobuf's internal buffer waking mechanism... I believe they normally
just want to signal that they are finished with this particular buffer
while optionally indicating an error. Wouldn't it be better to move the
actual waking logic to videobuf? Not only it would simplify the drivers,
but would allow to introduce changes/improvements to the whole process of
waking up more easily, without having to modify all the drivers.


Our first idea and a preliminary proposal is as follows:

1. Add one, additional, general buffer wait queue to a videobuf_queue,
on which poll and dqbuf would actually wait.

2. When a driver is to release a buffer, it could call a videobuf function
(instead of waking buffers manually), which could handle whatever would be
required to return this buffer to the userspace. That would include waking
up process(es) waiting on the main queue in dqbuf() or poll().


All the abovementioned arguments aside, I kind of feel that there may have
been a good reason for having separate queues in each buffer, instead of
just one, common queue. If so, is anybody able to point it out?


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center


