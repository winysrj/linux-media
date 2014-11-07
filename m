Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58116 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaKGGQP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Nov 2014 01:16:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v3.19] uvcvideo changes
Date: Fri, 07 Nov 2014 08:16:28 +0200
Message-ID: <1524049.TLSF8qZEUD@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 4895cc47a072dcb32d3300d0a46a251a8c6db5f1:

  [media] s5p-mfc: fix sparse error (2014-11-05 08:29:27 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git remotes/media/uvc/next

for you to fetch changes up to a1bee5f9f606f89ff30171658a82bf532cca7f3d:

  uvcvideo: Return all buffers to vb2 at stream stop and start failure 
(2014-11-07 08:13:21 +0200)

The "v4l2: get/set prio using video_dev prio structure" patch hasn't been 
acked yet. I'm leaving now for two weeks of holidays and I would like to avoid 
missing the merge window, so I'd appreciate if someone (Hans ? :-)) could 
review it in my absence and ack the pull request. If it needs to be delayed 
for some reason, could the first two patches (from Philipp and Takashi) still 
get in ?

----------------------------------------------------------------
Laurent Pinchart (10):
      v4l2: get/set prio using video_dev prio structure
      uvcvideo: Move to video_ioctl2
      uvcvideo: Set buffer field to V4L2_FIELD_NONE
      uvcvideo: Separate video and queue enable/disable operations
      uvcvideo: Add function to convert from queue to stream
      uvcvideo: Implement vb2 queue start and stop stream operations
      uvcvideo: Don't stop the stream twice at file handle release
      uvcvideo: Rename uvc_alloc_buffers to uvc_request_buffers
      uvcvideo: Rename and split uvc_queue_enable to uvc_queue_stream(on|off)
      uvcvideo: Return all buffers to vb2 at stream stop and start failure

Philipp Zabel (1):
      uvcvideo: Add quirk to force the Oculus DK2 IR tracker to grayscale

Takashi Iwai (1):
      uvcvideo: Fix destruction order in uvc_delete()

 drivers/media/usb/uvc/uvc_driver.c   |   51 ++-
 drivers/media/usb/uvc/uvc_queue.c    |  161 ++++---
 drivers/media/usb/uvc/uvc_v4l2.c     | 1009 +++++++++++++++++++--------------
 drivers/media/usb/uvc/uvc_video.c    |   23 +-
 drivers/media/usb/uvc/uvcvideo.h     |   12 +-
 drivers/media/v4l2-core/v4l2-ioctl.c |    4 +-
 6 files changed, 705 insertions(+), 555 deletions(-)

-- 
Regards,

Laurent Pinchart

