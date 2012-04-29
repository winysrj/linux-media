Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44318 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab2D2R6j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Apr 2012 13:58:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Subject: [GIT PULL for v3.5] Control events support for uvcvideo
Date: Sun, 29 Apr 2012 19:59:01 +0200
Message-ID: <3052114.LipUdaOlsN@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit bcb2cf6e0bf033d79821c89e5ccb328bfbd44907:

  [media] ngene: remove an unneeded condition (2012-04-26 15:29:23 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-events

Hans de Goede (10):
      media/radio: use v4l2_ctrl_subscribe_event where possible
      v4l2-event: Add v4l2_subscribed_event_ops
      v4l2-ctrls: Use v4l2_subscribed_event_ops
      uvcvideo: Fix a "ignoring return value of ‘__clear_user’" warning
      uvcvideo: Refactor uvc_ctrl_get and query
      uvcvideo: Move __uvc_ctrl_get() up
      uvcvideo: Add support for control events
      uvcvideo: Properly report the inactive flag for inactive controls
      uvcvideo: Send control change events for slave ctrls when the master changes
      uvcvideo: Drop unused ctrl member from struct uvc_control_mapping

 Documentation/video4linux/v4l2-framework.txt |   28 ++-
 drivers/media/radio/radio-isa.c              |   10 +-
 drivers/media/radio/radio-keene.c            |   14 +-
 drivers/media/video/ivtv/ivtv-ioctl.c        |    3 +-
 drivers/media/video/omap3isp/ispccdc.c       |    2 +-
 drivers/media/video/omap3isp/ispstat.c       |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c           |  320 +++++++++++++++++++++----
 drivers/media/video/uvc/uvc_v4l2.c           |   46 +++-
 drivers/media/video/uvc/uvcvideo.h           |   26 ++-
 drivers/media/video/v4l2-ctrls.c             |   58 ++++-
 drivers/media/video/v4l2-event.c             |   71 +++---
 drivers/usb/gadget/uvc_v4l2.c                |    2 +-
 include/media/v4l2-ctrls.h                   |    7 +-
 include/media/v4l2-event.h                   |   24 ++-
 14 files changed, 456 insertions(+), 157 deletions(-)

-- 
Regards,

Laurent Pinchart

