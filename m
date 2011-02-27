Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53202 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab1B0Rfy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Feb 2011 12:35:54 -0500
Received: from lancelot.localnet (unknown [91.178.64.100])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 046ED35995
	for <linux-media@vger.kernel.org>; Sun, 27 Feb 2011 17:35:54 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.39] Make the UVC API public (and bug fixes)
Date: Sun, 27 Feb 2011 18:36:01 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102271836.01888.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

These patches move the uvcvideo.h header file from drivers/media/video/uvc
to include/linux, making the UVC API public.

Martin Rubli has committed support for the public API to libwebcam, so
userspace support is up to date.

The following changes since commit 9e650fdb12171a5a5839152863eaab9426984317:

  [media] drivers:media:radio: Update Kconfig and Makefile for wl128x FM driver (2011-02-27 07:50:42 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Laurent Pinchart (6):
      uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
      uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
      uvcvideo: Include linux/types.h in uvcvideo.h
      uvcvideo: Move uvcvideo.h to include/linux
      uvcvideo: Fix descriptor parsing for video output devices
      v4l: videobuf2: Typo fix

Martin Rubli (2):
      uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
      uvcvideo: Add driver documentation

Stephan Lachowsky (1):
      uvcvideo: Fix uvc_fixup_video_ctrl() format search

 Documentation/feature-removal-schedule.txt         |   23 ++
 Documentation/ioctl/ioctl-number.txt               |    2 +-
 Documentation/video4linux/uvcvideo.txt             |  239 ++++++++++++++
 drivers/media/video/uvc/uvc_ctrl.c                 |  334 ++++++++++++--------
 drivers/media/video/uvc/uvc_driver.c               |   11 +-
 drivers/media/video/uvc/uvc_isight.c               |    3 +-
 drivers/media/video/uvc/uvc_queue.c                |    3 +-
 drivers/media/video/uvc/uvc_status.c               |    3 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   45 +++-
 drivers/media/video/uvc/uvc_video.c                |   17 +-
 include/linux/Kbuild                               |    1 +
 .../media/video/uvc => include/linux}/uvcvideo.h   |   43 ++-
 include/media/videobuf2-core.h                     |    2 +-
 13 files changed, 550 insertions(+), 176 deletions(-)
 create mode 100644 Documentation/video4linux/uvcvideo.txt
 rename {drivers/media/video/uvc => include/linux}/uvcvideo.h (95%)

-- 
Regards,

Laurent Pinchart
