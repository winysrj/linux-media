Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3852 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933531Ab3LINnd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Dec 2013 08:43:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, awalls@md.metrocast.net,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	s.nawrocki@samsung.com, g.liakhovetski@gmx.de
Subject: [RFCv4 PATCH 0/8] vb2: various cleanups and improvements
Date: Mon,  9 Dec 2013 14:43:04 +0100
Message-Id: <1386596592-48678-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series does some cleanups in the qbuf/prepare_buf handling
(the first three patches). The fourth patch removes the 'fileio = NULL'
hack. That hack no longer works when dealing with asynchronous calls
from a kernel thread so it had to be fixed.

The next three patches implement retrying start_streaming() if there are
not enough buffers queued for the DMA engine to start. I know that there
are more drivers that can be simplified with this feature available in
the core. Those drivers do the retry of start_streaming in the buf_queue
op which frankly defeats the purpose of having a central start_streaming
op. But I leave it to the driver developers to decide whether or not to
cleanup their drivers.

The big advantage is that apps can just call STREAMON first, then start
queuing buffers without having to know the minimum number of buffers that
have to be queued before the DMA engine will kick in. It always annoyed
me that vb2 didn't take care of that for me as it is easy enough to do.

The final patch adds a fix based on a patch from Andy that removes the
file I/O emulation assumption that buffers are dequeued in the same
order that they were enqueued.

With regards to patch 7/8 I would appreciate some Acks. See patch 5
how ENODATA is used to implement retrying start_streaming in vb2.

Regards,

        Hans

New in v4:

- Reorder the patches
- Drop the thread/DVB support: postpone until at least one driver will
  need this.

New in v3:

- Added a comment to the thread_start function making it explicit that
  it is for use with videobuf2-dvb only.
- Added patch 10/10 to address yet another race condition.

New in v2:

- Added a PREPARING state in patch 1 to prevent a race condition that Laurent
  mentioned (two QBUF calls with the same index number at the same time).
- Changed some minor issues in patch 4 that Laurent mentioned in his review.
- Added the reworked version of Andy's original patch to remove the order
  assumption in the file I/O emulation.

