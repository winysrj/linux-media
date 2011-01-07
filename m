Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49386 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1AGQAA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 11:00:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] Make the UVC API public
Date: Fri,  7 Jan 2011 17:00:35 +0100
Message-Id: <1294416040-28371-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

This patch set moves the uvcvideo.h header file from drivers/media/video/uvc
to include/linux, making the UVC API public.

One last API cleanup is needed before making the API public. The
UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET} are now deprecated and scheduled for removal.

I'll work with Martin Rubli to make sure an up-to-date uvcdynctrl version will
be available by the time I send a pull request for those patches.

Laurent Pinchart (4):
  uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
  uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
  uvcvideo: Include linux/types.h in uvcvideo.h
  uvcvideo: Move uvcvideo.h to include/linux

Martin Rubli (1):
  uvcvideo: Add UVCIOC_CTRL_QUERY ioctl

 Documentation/feature-removal-schedule.txt |   23 +
 Documentation/ioctl/ioctl-number.txt       |    2 +-
 drivers/media/video/uvc/uvc_ctrl.c         |  334 +++++++++------
 drivers/media/video/uvc/uvc_driver.c       |    3 +-
 drivers/media/video/uvc/uvc_isight.c       |    3 +-
 drivers/media/video/uvc/uvc_queue.c        |    3 +-
 drivers/media/video/uvc/uvc_status.c       |    3 +-
 drivers/media/video/uvc/uvc_v4l2.c         |   36 ++-
 drivers/media/video/uvc/uvc_video.c        |    3 +-
 drivers/media/video/uvc/uvcvideo.h         |  658 ---------------------------
 include/linux/Kbuild                       |    1 +
 include/linux/uvcvideo.h                   |  667 ++++++++++++++++++++++++++++
 12 files changed, 927 insertions(+), 809 deletions(-)
 delete mode 100644 drivers/media/video/uvc/uvcvideo.h
 create mode 100644 include/linux/uvcvideo.h

-- 
Regards,

Laurent Pinchart

