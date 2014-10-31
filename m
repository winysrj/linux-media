Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51646 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759301AbaJaNyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:54:51 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 590222000F
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 14:52:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 00/11] uvcvideo: Move to video_ioctl2
Date: Fri, 31 Oct 2014 15:54:46 +0200
Message-Id: <1414763697-21166-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series moves the uvcvideo driver to video_ioctl2 and fixes vb2
usage to rely on the start_streaming and stop_streaming operations.

Please see individual patches for details.

Laurent Pinchart (11):
  v4l2: get/set prio using video_dev prio structure
  uvcvideo: Move to video_ioctl2
  uvcvideo: Add V4L2 debug module parameter
  uvcvideo: Set buffer field to V4L2_FIELD_NONE
  uvcvideo: Separate video and queue enable/disable operations
  uvcvideo: Add function to convert from queue to stream
  uvcvideo: Implement vb2 queue start and stop stream operations
  uvcvideo: Don't stop the stream twice at file handle release
  uvcvideo: Rename uvc_alloc_buffers to uvc_request_buffers
  uvcvideo: Rename and split uvc_queue_enable to
    uvc_queue_stream(on|off)
  uvcvideo: Give back all buffers to userspace when stopping the stream

 drivers/media/usb/uvc/uvc_driver.c   |   22 +-
 drivers/media/usb/uvc/uvc_queue.c    |  146 ++---
 drivers/media/usb/uvc/uvc_v4l2.c     | 1009 +++++++++++++++++++---------------
 drivers/media/usb/uvc/uvc_video.c    |   23 +-
 drivers/media/usb/uvc/uvcvideo.h     |   11 +-
 drivers/media/v4l2-core/v4l2-ioctl.c |    4 +-
 6 files changed, 664 insertions(+), 551 deletions(-)

-- 
Regards,

Laurent Pinchart

