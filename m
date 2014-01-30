Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4170 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbaA3Ov4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jan 2014 09:51:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com
Subject: [RFCv1 PATCH 0/9] vb2: fixes, balancing callbacks
Date: Thu, 30 Jan 2014 15:51:22 +0100
Message-Id: <1391093491-23077-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch series fixes a series of bugs in vb2. Recently I have been
converting the saa7134 driver to vb2 and as part of that work I discovered
that the op calls were not properly balanced, which caused saa7134 to
fail.

Based on that I did more debugging and I found lots of different issues
with vb2 when it comes to balancing ops. This patch series fixes them,
but I do need some additional feedback.

Patch 1 adds debugging code to check for unbalanced calls. I used this
when testing since without this it is very hard to verify correctness.
It is currently turned on when CONFIG_VIDEO_ADV_DEBUG is set, but perhaps
this should be placed under a vb2 specific debug option?

The next patch changes the buf_finish return type to void. It must not
fail, and you can't do anything useful if it does anyway.

Note that I really would like to do the same for stop_streaming. The
stop_streaming error is currently ignored, and there are some drivers
that can actually return an error (waiting for an interruptible mutex
for example). Opinions are welcome.

Patch 3 just improves some comments.

Patches 4 and 5 fix several unbalanced ops.

Patch 6 fixes a regression (must go to 3.14!).

Patch 7 is were things get interesting. There is a bug in the handling
of start_streaming: before that op is called any prequeued buffers are
handed over to the driver. But if start_streaming returns an error, then
those buffers are not reclaimed. Since start_streaming failed, q->streaming
is 0, so stop_streaming isn't called either.

This patch adds a reinit_streaming op to tell the driver to reinitialize
its internal buffer lists. This is called both after stop_streaming or
after a failed start_streaming call. In addition when the queue is freed
the vb2 core will call vb2_buffer_done for any buffers still in the
active state. This last action should be done regardless IMHO. I actually
found some drivers that do not call vb2_buffer_done in stop_streaming :-(
thus preventing the vb2 core from calling the finish() memop.

The question is if the reinit_streaming op is a good idea or not.

Alternatives are: requiring drivers to cleanup if start_streaming fails
(hard to check) or a buf_dequeue call that requires the driver to just
delete that buffer from the queue. I tried the last option, but it didn't
really work out: you expect that buf_queue and buf_dequeue would balance
but the only way to do that would be to call buf_dequeue from vb2_buffer_done,
which is not a great idea since that is called from interrupt context.

A queue-level reinit_streaming() op worked better in that regard.

Some drivers already do the cleanup if start_streaming fails, so that
is an option. However, it is hard to enforce in drivers. A reinit_streaming
op would make this explicit.

Patch 8 shows how a reinit_streaming looks in vivi.

The final patch attempts to fix another issue: I noticed that in the few
drivers that implement VIDIOC_CREATE_BUFS the v4l2_format is just used as-is,
i.e. no checks are done whether the contents of the struct makes sense or not.

This patch calls TRY_FMT (and WARNs if no TRY_FMT is defined) to check if the
format is valid/consistent. Again, I'm not certain whether this should be
applied or not.

I have been testing these vb2 changes with vivi (vmalloc based) and an
out-of-tree PCI driver (dma-sg based), with the mmap/userptr and read/write
streaming modes. I hope to test this also for a dma-contig based driver.
I have no way of testing with dmabuf, though. Does anyone know of a simple
way to obtain dmabufs from somewhere so they can be passed to a v4l driver?
It would be great to add a --stream-dmabuf option for v4l2-ctl.

I have to admit that I was a bit disappointed by all these vb2 issues...

Regards,

	Hans

