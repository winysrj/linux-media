Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2076 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3KUPWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 10:22:42 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	awalls@md.metrocast.net, laurent.pinchart@ideasonboard.com
Subject: [RFC PATCH 0/8] vb2: various cleanups and improvements
Date: Thu, 21 Nov 2013 16:21:58 +0100
Message-Id: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl>
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

The final two patches add vb2 thread support which is necessary
for both videobuf2-dvb (the vb2 replacement of videobuf-dvb) and for e.g.
alsa drivers where you use the same trick as with dvb.

The thread implementation has been tested with both alsa recording and
playback for an internal driver (sorry, I can't share the source yet).

Andy, your patch hasn't been added to this series yet, but the patch
I mailed you in reply to your patch will apply cleanly on top of this
series.

Regards,

	Hans

