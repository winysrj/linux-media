Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2218 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087Ab0EPNTN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 May 2010 09:19:13 -0400
Message-Id: <cover.1274015084.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 16 May 2010 15:20:43 +0200
Subject: [PATCH 00/15] [RFCv2] [RFC] New control handling framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC patch series adds the control handling framework and implements
it in ivtv and all subdev drivers used by ivtv.

It is a bare-bones implementation, so no sysfs or debugfs enhancements.

It is the second version of this framework, incorporating comments from
Laurent.

Changes compared to the first version:

- Updated the documentation, hopefully making it easier to understand.
- v4l2_ctrl_new_custom now uses a new v4l2_ctrl_config struct instead of
  a long argument list.
- v4l2_ctrl_g/s is now renamed to v4l2_ctrl_g/s_ctrl.
- The v4l2_ctrl.h header now uses kernel doc comments.
- Removed the 'strict validation' feature.
- Added a new .init op that allows you to initialize many of the v4l2_ctrl
  fields on first use. Required by uvc.
- No longer needed to initialize ctrl_handler in struct video_device. It
  will copy the ctrl_handler from struct v4l2_device if needed.
- Renamed the v4l2_sd_* helper functions to v4l2_subdev_*.

I decided *not* to rename the v4l2_ctrl struct. What does the struct describe?
A control. Period. So I really don't know what else to call it. Every other
name I can think of is contrived. It really encapsulates all the data and info
that describes a control and its state. Yes, it is close to struct v4l2_control,
but on the other hand any driver that uses this framework will no longer use
v4l2_control (or v4l2_ext_controls for that matter). It will only use v4l2_ctrl.
So I do not think there will be much cause for confusion here.

Anyway, comments are welcome.

Once this is in then we can start migrating all subdev drivers to this
framework, followed by all bridge drivers. Converted subdev drivers can
still be used by unconverted bridge drivers. Once all bridge drivers are
converted the subdev backwards compatibility code can be removed.

The same is true for the cx2341x module: both converted and unconverted
bridge drivers are supported. Once all bridge drivers that use this module
are converted the compat code can be removed from cx2341x (and that will
save about 1060 lines of hard to understand code).

Regards,

        Hans

Hans Verkuil (15):
  v4l2: Add new control handling framework
  v4l2-ctrls: reorder 'case' statements to match order in header.
  Documentation: add v4l2-controls.txt documenting the new controls
    API.
  v4l2: hook up the new control framework into the core framework
  saa7115: convert to the new control framework
  msp3400: convert to the new control framework
  saa717x: convert to the new control framework
  cx25840/ivtv: replace ugly priv control with s_config
  cx25840: convert to the new control framework
  cx2341x: convert to the control framework
  wm8775: convert to the new control framework
  cs53l32a: convert to new control framework.
  wm8739: convert to the new control framework
  ivtv: convert gpio subdev to new control framework.
  ivtv: convert to the new control framework

 Documentation/video4linux/v4l2-controls.txt |  600 +++++++++
 drivers/media/video/Makefile                |    2 +-
 drivers/media/video/cs53l32a.c              |  107 +-
 drivers/media/video/cx2341x.c               |  734 +++++++++--
 drivers/media/video/cx25840/cx25840-audio.c |  144 +--
 drivers/media/video/cx25840/cx25840-core.c  |  201 ++--
 drivers/media/video/cx25840/cx25840-core.h  |   23 +-
 drivers/media/video/ivtv/ivtv-controls.c    |  275 +----
 drivers/media/video/ivtv/ivtv-controls.h    |    6 +-
 drivers/media/video/ivtv/ivtv-driver.c      |   26 +-
 drivers/media/video/ivtv/ivtv-driver.h      |    4 +-
 drivers/media/video/ivtv/ivtv-fileops.c     |   23 +-
 drivers/media/video/ivtv/ivtv-firmware.c    |    6 +-
 drivers/media/video/ivtv/ivtv-gpio.c        |   77 +-
 drivers/media/video/ivtv/ivtv-i2c.c         |    7 +
 drivers/media/video/ivtv/ivtv-ioctl.c       |   31 +-
 drivers/media/video/ivtv/ivtv-streams.c     |   20 +-
 drivers/media/video/msp3400-driver.c        |  248 ++---
 drivers/media/video/msp3400-driver.h        |   16 +-
 drivers/media/video/msp3400-kthreads.c      |   16 +-
 drivers/media/video/saa7115.c               |  180 ++--
 drivers/media/video/saa717x.c               |  323 ++----
 drivers/media/video/v4l2-common.c           |  479 +-------
 drivers/media/video/v4l2-ctrls.c            | 1844 +++++++++++++++++++++++++++
 drivers/media/video/v4l2-dev.c              |    8 +-
 drivers/media/video/v4l2-device.c           |    7 +
 drivers/media/video/v4l2-ioctl.c            |   46 +-
 drivers/media/video/wm8739.c                |  176 +--
 drivers/media/video/wm8775.c                |   79 +-
 include/media/cx2341x.h                     |   81 ++
 include/media/cx25840.h                     |   11 +
 include/media/v4l2-ctrls.h                  |  448 +++++++
 include/media/v4l2-dev.h                    |    4 +
 include/media/v4l2-device.h                 |    4 +
 include/media/v4l2-subdev.h                 |    3 +
 35 files changed, 4351 insertions(+), 1908 deletions(-)
 create mode 100644 Documentation/video4linux/v4l2-controls.txt
 create mode 100644 drivers/media/video/v4l2-ctrls.c
 create mode 100644 include/media/v4l2-ctrls.h

