Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53875 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab1LGNUi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 08:20:38 -0500
Received: from lancelot.localnet (unknown [91.178.3.157])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 49AF235A9B
	for <linux-media@vger.kernel.org>; Wed,  7 Dec 2011 13:20:37 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.3] uvcvideo: move to vb2, support UVC timestamps, and various fixes
Date: Wed, 7 Dec 2011 14:20:45 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112071420.46081.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 2a887d27708a4f9f3b5ad8258f9e19a150b58f03:

  [media] tm6000: fix OOPS at tm6000_ir_int_stop() and tm6000_ir_int_start() 
(2011-11-30 16:49:45 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Alexey Fisher (2):
      uvcvideo: Add debugfs support
      uvcvideo: Extract video stream statistics

Haogang Chen (1):
      uvcvideo: Fix integer overflow in uvc_ioctl_ctrl_map()

Laurent Pinchart (10):
      uvcvideo: Move fields from uvc_buffer::buf to uvc_buffer
      uvcvideo: Use videobuf2-vmalloc
      uvcvideo: Handle uvc_init_video() failure in uvc_video_enable()
      uvcvideo: Remove duplicate definitions of UVC_STREAM_* macros
      uvcvideo: Add support for LogiLink Wireless Webcam
      uvcvideo: Make uvc_commit_video() static
      uvcvideo: Don't skip erroneous payloads
      uvcvideo: Ignore GET_RES error for XU controls
      uvcvideo: Extract timestamp-related statistics
      uvcvideo: Add UVC timestamps support

 drivers/media/video/uvc/Kconfig       |    1 +
 drivers/media/video/uvc/Makefile      |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c    |   17 +-
 drivers/media/video/uvc/uvc_debugfs.c |  135 +++++++
 drivers/media/video/uvc/uvc_driver.c  |   30 ++-
 drivers/media/video/uvc/uvc_isight.c  |   10 +-
 drivers/media/video/uvc/uvc_queue.c   |  564 ++++++++----------------------
 drivers/media/video/uvc/uvc_v4l2.c    |   29 +-
 drivers/media/video/uvc/uvc_video.c   |  625 ++++++++++++++++++++++++++++++--
 drivers/media/video/uvc/uvcvideo.h    |  128 ++++++--
 10 files changed, 1039 insertions(+), 502 deletions(-)
 create mode 100644 drivers/media/video/uvc/uvc_debugfs.c

-- 
Regards,

Laurent Pinchart
