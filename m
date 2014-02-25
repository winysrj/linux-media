Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4696 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaBYJsn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 04:48:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com
Subject: [REVIEWv1 PATCH 00/16] vb2: fixes, balancing callbacks (PART 1)
Date: Tue, 25 Feb 2014 10:48:13 +0100
Message-Id: <1393321707-9749-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series is the first REVIEW series as opposed to RFC.
It follows RFCv4:

http://www.spinics.net/lists/linux-media/msg73039.html

This is part 1 of vb2 changes. I will post a part 2 RFC series soon
for more vb2 fixes and enhancements.

Ignore patches 1-3: the first is already merged in 3.14, and 2 and 3
are pending to be merged in 3.14. But you need them for some follow-up
patches.

Patches 04-09 and 14 are unchanged from RFCv4.

Changelog since RFCv4:

- Dropped RFCv4 patch 08/11 as it was wrong. Instead, I added patch
  10/14. This fixes a bug in __vb2_queue_free() and improved the code
  that caused my misunderstanding with RFCv4 patch 08/11.
- In patch 11/14 I dropped the check against the minimum number of
  required buffers in create_bufs. Instead, check for this in streamon.
- Added patch 12: "vb2: properly clean up PREPARED and QUEUED buffers"
  This fixes one corner case that still produced 'Unbalanced' results.
- Added patch 13: "vb2: replace BUG by WARN_ON"
  Just a small change to be more gentle if the driver tries something
  it shouldn't.

This patch series fixes a series of bugs in vb2. Recently I have been
converting the saa7134 driver to vb2 and as part of that work I discovered
that the op calls were not properly balanced, which caused saa7134 to
fail.

Based on that I did more debugging and I found lots of different issues
with vb2 when it comes to balancing ops. This patch series fixes them.
Many thanks to Pawel Osciak for a good brainstorm session.

Patch 4 adds debugging code to check for unbalanced calls. I used this
when testing since without this it is very hard to verify correctness.
It is currently turned on when CONFIG_VIDEO_ADV_DEBUG is set, but perhaps
this should be placed under a vb2 specific debug option?

The next patch changes the buf_finish return type to void. It must not
fail, and you can't do anything useful if it does anyway.

Patch 6 just improves some comments.

Patches 7 and 8 fix several unbalanced ops.

Patch 9 just renames queue_count to owned_by_drv_count. The old name
suggests the number of buffers in the queue_list, but that's not what
it is. Since the next patch will actually add a real count for the
number of buffers in the queue_list I decided to just rename this,
thus freeing up the name 'queue_count'.

Patch 10 fixes a __vb2_queue_free() bug and makes __reqbufs and
__create_bufs code a bit more understandable.

Patch 11 fixes a bug in the handling of start_streaming: before that op
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

Patch 12 fixes another corner case introducing unbalanced ops.

Patch 13 replaces a BUG_ON by WARN_ON.

Patch 14 fixes vivi for this start_streaming issue. Note that there are
many drivers that do not clean up properly in case of an error during
start_streaming.

I have been testing these vb2 changes with vivi (vmalloc based), a patched
saa7134 (dma-contig based) and an out-of-tree PCI driver (dma-sg based),
with the mmap/userptr/dmabuf and read/write streaming modes.

Regards,

        Hans



