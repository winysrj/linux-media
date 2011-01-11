Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44771 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab1AKOaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 09:30:14 -0500
Received: from lancelot.localnet (unknown [91.178.71.55])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 98F2735B4B
	for <linux-media@vger.kernel.org>; Tue, 11 Jan 2011 14:30:13 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.38] Make the UVC API public
Date: Tue, 11 Jan 2011 15:31:04 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101111531.05674.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

These patches move the uvcvideo.h header file from drivers/media/video/uvc
to include/linux, making the UVC API public.

Martin Rubli has committed support for the public API to libwebcam, so
userspace support is up to date.

The following changes since commit 0a97a683049d83deaf636d18316358065417d87b:

  [media] cpia2: convert .ioctl to .unlocked_ioctl (2011-01-06 11:34:41 -0200)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Laurent Pinchart (4):
      uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
      uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
      uvcvideo: Include linux/types.h in uvcvideo.h
      uvcvideo: Move uvcvideo.h to include/linux

Martin Rubli (2):
      uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
      uvcvideo: Add driver documentation

 Documentation/feature-removal-schedule.txt         |   23 ++
 Documentation/ioctl/ioctl-number.txt               |    2 +-
 Documentation/video4linux/uvcvideo.txt             |  239 ++++++++++++++
 drivers/media/video/uvc/uvc_ctrl.c                 |  334 ++++++++++++--------
 drivers/media/video/uvc/uvc_driver.c               |    3 +-
 drivers/media/video/uvc/uvc_isight.c               |    3 +-
 drivers/media/video/uvc/uvc_queue.c                |    3 +-
 drivers/media/video/uvc/uvc_status.c               |    3 +-
 drivers/media/video/uvc/uvc_v4l2.c                 |   45 +++-
 drivers/media/video/uvc/uvc_video.c                |    3 +-
 include/linux/Kbuild                               |    1 +
 .../media/video/uvc => include/linux}/uvcvideo.h   |   39 ++-
 12 files changed, 530 insertions(+), 168 deletions(-)
 create mode 100644 Documentation/video4linux/uvcvideo.txt
 rename {drivers/media/video/uvc => include/linux}/uvcvideo.h (95%)

-- 
Regards,

Laurent Pinchart
