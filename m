Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4023 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaBNKlg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Feb 2014 05:41:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com
Subject: [RFCv4 PATCH 00/11] vb2: fixes, balancing callbacks
Date: Fri, 14 Feb 2014 11:41:01 +0100
Message-Id: <1392374472-18393-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is v4 of the previous series:

http://www.spinics.net/lists/linux-media/msg73005.html

Changelog:

- Fixed a number of typos as pointed out by Pawel Osciak
- Added better documentation and renamed the index fields in patch 6
  (fix read/write regression)
- added patch 8/11 to fix a bug in updating q->num_buffers
- incorporated suggestions from Pawel for patch 9/11 (was 8/10 in RFCv3).
  The main change is that reqbufs and createbufs check if at least
  'min_buffers_needed' buffers could be allocated. If not, then return
  -ENOMEM.

This patch series fixes a series of bugs in vb2. Recently I have been
converting the saa7134 driver to vb2 and as part of that work I discovered
that the op calls were not properly balanced, which caused saa7134 to
fail.

Based on that I did more debugging and I found lots of different issues
with vb2 when it comes to balancing ops. This patch series fixes them.
Many thanks to Pawel Osciak for a good brainstorm session.

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

Patch 7 just renames queue_count to owned_by_drv_count. The old name
suggests the number of buffers in the queue_list, but that's not what
it is. Since the next patch will actually add a real count for the
number of buffers in the queue_list I decided to just rename this,
thus freeing up the name 'queue_count'.

Patch 8 fixes a bug in when q->num_buffers is updated after allocating
new buffers. It should be moved after a final error check.

Patch 9 fixes a bug in the handling of start_streaming: before that op
is called any prequeued buffers are handed over to the driver. But if
start_streaming returns an error, then those buffers are not reclaimed.
Since start_streaming failed, q->streaming is 0, so stop_streaming isn't
called either.

There are two reasons for an error in start_streaming: either a real
error when setting up the DMA engine occurred or there were not enough
buffers queued for the DMA engine to start (start_streaming returns
-ENOBUFS in that case). It makes sense to require that drivers return
queued buffers back to vb2 in case of an error, but not if they also 
have to do that in case of insufficient buffers. So this patch replaces
the -ENOBUFS mechanism by a vb2_queue field that tells vb2 what the
minimum number of buffers is.

Now if start_streaming returns an error the vb2 core will check if there
are still buffers owned by the driver and if so produce a warning and
reclaim those buffers. The same is done when the vb2_queue is freed.

This ensures that the prepare/finish memops are correctly called and
the state of all the buffers is consistent.

Patch 10 fixes vivi for this start_streaming issue. Note that there are
many drivers that do not clean up properly in case of an error during
start_streaming.

The final patch attempts to fix another issue: I noticed that in the few
drivers that implement VIDIOC_CREATE_BUFS the v4l2_format is just used as-is,
i.e. no checks are done whether the contents of the struct makes sense or not.

This patch adds a number of sanity check to see if the buffer size related
values make sense.

I have been testing these vb2 changes with vivi (vmalloc based), saa7134 and
an out-of-tree PCI driver (dma-sg based), with the mmap/userptr and read/write
streaming modes. I hope to test this also for a dma-contig based driver.
I have no way of testing with dmabuf, though. Does anyone know of a simple
way to obtain dmabufs from somewhere so they can be passed to a v4l driver?
It would be great to add a --stream-dmabuf option for v4l2-ctl.

I have to admit that I was a bit disappointed by all these vb2 issues...

Regards,

	Hans

