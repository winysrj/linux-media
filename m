Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4463 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3K2J7C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 04:59:02 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, awalls@md.metrocast.net
Subject: [RFCv2 PATCH 0/9] vb2: various cleanups and improvements
Date: Fri, 29 Nov 2013 10:58:35 +0100
Message-Id: <1385719124-11338-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series does some cleanups in the qbuf/prepare_buf handling
(the first two patches). The third patch removes the 'fileio = NULL'
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

The next two patches add vb2 thread support which is necessary
for both videobuf2-dvb (the vb2 replacement of videobuf-dvb) and for e.g.
alsa drivers where you use the same trick as with dvb.

The thread implementation has been tested with both alsa recording and
playback for an internal driver (sorry, I can't share the source yet).

The final patch adds a fix based on a patch from Andy that removes the
file I/O emulation assumption that buffers are dequeued in the same
order that they were enqueued.

Regards,

        Hans

