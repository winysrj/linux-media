Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1195 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab0E2OoA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 10:44:00 -0400
Message-Id: <cover.1275143672.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sat, 29 May 2010 16:45:50 +0200
Subject: [PATCH 00/15] [RFCv4] New control handling framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC patch series adds the control handling framework and implements
it in ivtv and all subdev drivers used by ivtv.

It is a bare-bones implementation, so no sysfs or debugfs enhancements.

It is the fourth version of this framework, incorporating comments from
Laurent.

Changes compared to the second version (the third version was never posted):

- Replaced 'bridge driver' by 'V4L2 driver'.
- Added is_volatile and is_uninitialized flags (to control whether g_volatile_ctrl or
  init should be called).
- Added is_volatile, is_uninitialized and is_private flags to v4l2_ctrl_config.
- If the name field in struct v4l2_ctrl_config is NULL, then assume it is a standard
  control and fill in the defaults accordingly.

These last two changes together make it possible to make a const array of
struct v4l2_ctrl_config to create all controls.

- v4l2_ctrl_new_std_menu now has a 'max' argument.
- v4l2_ctrl_new_std can no longer be used to create a standard menu control.
  This should prevent confusion regarding step and skip_mask.
- v4l2_ctrl_active and v4l2_ctrl_grab set the flag atomically, so can be called
  from anywhere.
- The init op can now return an error code.
- Extended the section on control initialization in the documentation.
- Added v4l2_ctrl_init_disable to give drivers the option to disable controls
  that failed to initialize.
- Added two new proposals to the doc to extend the spec:

------ start excerpt -------------
3) Trying to set volatile inactive controls should result in -EACCESS.

4) Add a new flag to mark volatile controls. Any application that wants
to store the state of the controls can then skip volatile inactive controls.
Currently it is not possible to detect such controls.
------- end excerpt --------------

This version incorporates all comments I have received.

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

 Documentation/video4linux/v4l2-controls.txt |  694 ++++++++++
 drivers/media/video/Makefile                |    2 +-
 drivers/media/video/cs53l32a.c              |  107 +-
 drivers/media/video/cx2341x.c               |  747 +++++++++--
 drivers/media/video/cx25840/cx25840-audio.c |  144 +--
 drivers/media/video/cx25840/cx25840-core.c  |  201 ++--
 drivers/media/video/cx25840/cx25840-core.h  |   26 +-
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
 drivers/media/video/msp3400-driver.h        |   18 +-
 drivers/media/video/msp3400-kthreads.c      |   16 +-
 drivers/media/video/saa7115.c               |  183 ++--
 drivers/media/video/saa717x.c               |  323 ++----
 drivers/media/video/v4l2-common.c           |  479 +-------
 drivers/media/video/v4l2-ctrls.c            | 1935 +++++++++++++++++++++++++++
 drivers/media/video/v4l2-dev.c              |    8 +-
 drivers/media/video/v4l2-device.c           |    7 +
 drivers/media/video/v4l2-ioctl.c            |   46 +-
 drivers/media/video/wm8739.c                |  179 +--
 drivers/media/video/wm8775.c                |   79 +-
 include/media/cx2341x.h                     |   97 ++
 include/media/cx25840.h                     |   11 +
 include/media/v4l2-ctrls.h                  |  495 +++++++
 include/media/v4l2-dev.h                    |    4 +
 include/media/v4l2-device.h                 |    4 +
 include/media/v4l2-subdev.h                 |    3 +
 35 files changed, 4623 insertions(+), 1908 deletions(-)
 create mode 100644 Documentation/video4linux/v4l2-controls.txt
 create mode 100644 drivers/media/video/v4l2-ctrls.c
 create mode 100644 include/media/v4l2-ctrls.h

