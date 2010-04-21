Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11588 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab0DUQKk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 12:10:40 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L18003JUI9PCW@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 17:10:37 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L180000KI9OKN@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 17:10:37 +0100 (BST)
Date: Wed, 21 Apr 2010 18:10:33 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH/RFC v1 0/2] Add support for out-of-order buffer dequeuing
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Message-id: <1271866235-14370-1-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

this patch adds support for dequeuing video buffers out-of-order, i.e. not
in a FIFO order.

It is closely related to my previous RFC, to which no responses were given
(much to my disappointment, as an insight into what others think of the "done"
 waitqueues in videobuf_buffer could potentially shed a new light on the issue):
http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/17904


==================
Current behavior
==================
Currently, videobuf stores all the buffers passed from the userspace
on its "stream" list. They are inserted to it in the same order as
they are queued by the userspace.
When dequeuing/polling, the next (i.e. first queued) buffer from that list
is always used. In result, it is not possible to dequeue other buffers from
the stream queue first. If an another buffer is marked as finished by the
driver, it is not returned before all the buffers that have been queued
earlier, even if it takes more time for them to finish.

The videobuf_buffer structure includes a "done" waitqueue, on which we are
expected to sleep while waiting for each particular buffer to finish being
processed. The usefulness of having a separate waitqueue for every buffer
has been questioned in my previous RFC. As there was no response, I am
beginning to assume that there is no one who would like to speak in favor
of keeping them, although I am not removing them in this patch.

Dequeuing
----------------------------
videobuf_dqbuf() takes the next (i.e. first) buffer from the stream list and
checks the "state" member of videobuf_buffer to determine whether it has
already been marked as done (VIDEOBUF_DONE) or an error has occurred
(indicated by VIDEOBUF_ERROR state). If neither is true, we go to sleep on
that buffer's waitqueue.

Drivers mark buffers as done by:
1. setting their state to one of those constants and
2. waking up all processes sleeping on the "done" waitqueue.

Polling
----------------------------
videobuf_poll_stream() also takes the first buffer (if available) from
the stream list and behaves in a similar fashion to dqbuf.


Both dqbuf and poll do not check or return buffers other than the first
one. Even if a driver marks other buffers as finished first, they will not be
used (polled/dequeued) before their predecessors.

V4L2 API
----------------------------
>From the point of view of V4L2 API, no particular order of buffers is
specified. Applications are expected to check the index in struct v4l2_buffer
in order to determine which buffer has been dequeued.


==================
This patch
==================

Rationale
----------------------------
Although FIFO is enough for most hardware, it is essential for some types of
devices, particularly video codecs, to allow dequeuing buffers in an arbitrary
order. Video codecs may need to hold some buffers (reference frames) for longer
periods of time than others.

Moreover, even if not required, introducing such an ability may improve
performance of applications that utilize devices which have different
processing times for different buffers.

A different matter is that, in my opinion, exposing the nuts and bolts of
waking up processes sleeping on done waitqueues to drivers is slightly
inelegant and a bit too verbose. The drivers should be marking the buffers
as done with a more abstract call and not be exposed to the inner workings of
videobuf.

Finally, current situation ties up drivers to videobuf behavior a bit too
much in my opinion, as indicated in the videobuf_has_consumers() example below.


Changes
----------------------------
This patch adds the ability to return any buffer that has already been marked
as finished. Buffers are dequeued in FIFO order, but not based on the order
in which they were queued, but in the order in which the driver has marked
them as done instead.

This results in two main advantages:
1. Buffers are returned to userspace as soon as drivers finish with them
   (although curretnly drivers usually do return them in the same order as
    queued).
2. Out-of-order dequeuing becomes possible for drivers that require such an
   ability.


Two exported functions are introduced in this patch:

1. videobuf_has_consumers()
----------------------------
Returns 1 when userspace is waiting for buffers.

To achieve this in the previous version, a driver had to take the first
buffer that has been queued and check whether its done waitqueue is active.
An example from vivi:

 627        spin_lock_irqsave(&dev->slock, flags);
 628        if (list_empty(&dma_q->active)) {
 629                dprintk(dev, 1, "No active queue to serve\n");
 630                goto unlock;
 631        }
 632
 633        buf = list_entry(dma_q->active.next,
 634                         struct vivi_buffer, vb.queue);
 635
 636        /* Nobody is waiting on this buffer, return */
 637        if (!waitqueue_active(&buf->vb.done))
 638                goto unlock;
(...)
 650unlock:
 651        spin_unlock_irqrestore(&dev->slock, flags);

This worked, but required the checked buffer (active.next) to be the same as
stream.next in videobuf. This ties up videobuf and driver tightly together,
resulting in unclear dependencies and may cause obscure bugs.

Moreover, there is no more need to pass a particular buffer. We could also
introduce a similar function for explicitly passed buffers though.


2. videobuf_buf_finish()
----------------------------
This function should simply replace wake_up() calls in drivers. irq spinlock
should not be held when calling.


Compatibility
----------------------------
For this patch to be backwards-compatible, similar changes as in the included
vivi patch would have to be introduced. These are very simple (practically one 
line per driver) and fully automatic and include replacement of wake_up calls
with videobuf_buf_finish() and waitqueue_active() on done waitqueues with
videobuf_has_consumers(). The "done" waitqueues will work as previously.


==================
Next steps
==================
The next step could actually include getting rid of the "done" waitqueues from
the videobuf_buffer completely. As waiting is performed on only one of them
at one time anyway, I see little reason to keep them. During my initial
investigation I found no drivers that would depend on the ability to wait on
a particular buffer (instead of waiting for any buffer in general).


Comments highly appreciated!


This series includes:
[PATCH v1 1/2] v4l: videobuf: Add support for out-of-order buffer dequeuing.
[PATCH v1 2/2] v4l: vivi: adapt to out-of-order buffer dequeuing in videobuf.


Best regards,
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center
