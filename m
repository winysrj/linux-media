Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59558 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab1D0Khq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2011 06:37:46 -0400
Received: from lancelot.localnet (unknown [91.178.135.52])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 2C29135997
	for <linux-media@vger.kernel.org>; Wed, 27 Apr 2011 10:37:45 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PATCHES FOR 2.6.40] Make the UVC API public (and minor enhancements)
Date: Wed, 27 Apr 2011 12:38:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271238.03887.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

These patches move the uvcvideo.h header file from drivers/media/video/uvc
to include/linux, making the UVC API public. Support for the old API is kept
and will be removed in 2.6.42.

The following changes since commit a4761a092fd3b6bf8b5f9cfe361670c86cdcc8ca:

  [media] tm6000: fix vbuf may be used uninitialized (2011-04-19 21:13:59 -0300)

are available in the git repository at:
  git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next

Laurent Pinchart (5):
      uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
      uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
      uvcvideo: Make the API public
      uvcvideo: Add support for V4L2_PIX_FMT_RGB565
      uvcvideo: Add support for JMicron USB2.0 XGA WebCam

Martin Rubli (2):
      uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
      uvcvideo: Add driver documentation

 Documentation/feature-removal-schedule.txt |   23 ++
 Documentation/ioctl/ioctl-number.txt       |    2 +-
 Documentation/video4linux/uvcvideo.txt     |  239 ++++++++++++++++++++
 drivers/media/video/uvc/uvc_ctrl.c         |  332 +++++++++++++++++-----------
 drivers/media/video/uvc/uvc_driver.c       |   14 ++
 drivers/media/video/uvc/uvc_v4l2.c         |   51 ++++-
 drivers/media/video/uvc/uvcvideo.h         |   57 ++++--
 include/linux/Kbuild                       |    1 +
 include/linux/uvcvideo.h                   |   69 ++++++
 9 files changed, 625 insertions(+), 163 deletions(-)
 create mode 100644 Documentation/video4linux/uvcvideo.txt
 create mode 100644 include/linux/uvcvideo.h

-- 
Regards,

Laurent Pinchart
