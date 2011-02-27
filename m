Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34568 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1B0SM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 13:12:28 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com, hverkuil@xs4all.nl
Subject: [RFC/PATCH 0/2] Convert uvcvideo to videobuf2
Date: Sun, 27 Feb 2011 19:12:31 +0100
Message-Id: <1298830353-9797-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Those two RFC patches convert the uvcvideo driver to videobuf2.

The transition was pretty smooth, except for an issue with videobuf2 and
hot-pluggable devices. When a hot-pluggable device is disconnected, all pending
video buffers must be marked as erroneous and waiters must be woken up. Drivers
(and/or videobuf2) must then not allow new buffers to be queued, otherwise
applications would wait forever on VIDIOC_DQBUF (side note: maybe it's time for
V4L2 to explictly state what should happen in that case, and what error codes
must be returned).

This isn't a big issue in itself, except that handling the disconnection event
in QBUF introduces a race condition. Fixing it can only be done with the help
of a spinlock which must be held across the disconnection check and the
list_add_tail call in buf_queue. Unfortunately, buf_queue returns void, which
prevents checking for the disconnection event there.

There are multiple ways to solve this problem. the one I've implemented in this
RFC modifies buf_queue to return an error code, and lets drivers implement
buffers queue cancellation on disconnect. As this could be a tricky problem, a
better solution might be to move disconnection handling inside videobuf2. The
downside is that a new spinlock will be needed in videobuf2.

Yet another solution would be to let QBUF succeed, but marking the buffer as
erroneous and waking up userspace immediately. I don't like this though, as the
error flag on buffers is meant to indicate transcient errors, and device
disconnection is more on the fatal error side :-)

Laurent Pinchart (2):
  v4l: videobuf2: Handle buf_queue errors
  uvcvideo: Use videobuf2

 drivers/media/video/uvc/Kconfig      |    1 +
 drivers/media/video/uvc/uvc_isight.c |   10 +-
 drivers/media/video/uvc/uvc_queue.c  |  494 ++++++++++------------------------
 drivers/media/video/uvc/uvc_v4l2.c   |   19 +--
 drivers/media/video/uvc/uvc_video.c  |   30 +-
 drivers/media/video/videobuf2-core.c |   32 ++-
 drivers/usb/gadget/uvc.h             |    2 +-
 include/linux/uvcvideo.h             |   37 ++--
 include/media/videobuf2-core.h       |    2 +-
 9 files changed, 203 insertions(+), 424 deletions(-)

-- 
Regards,

Laurent Pinchart

