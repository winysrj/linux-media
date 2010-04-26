Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1600 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab0DZHda (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:33:30 -0400
Message-Id: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:33:24 +0200
Subject: [PATCH 00/15] [RFC] New control handling framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This RFC patch series adds the control handling framework and implements
it in ivtv and all subdev drivers used by ivtv.

It is a bare-bones implementation, so no sysfs or debugfs enhancements.

Any comments are welcome.

Once this is in then we can start migrating all subdev drivers to this
framework, followed by all bridge drivers. Converted subdev drivers can
still be used by unconverted bridge drivers. Once all bridge drivers are
converted the subdev backwards compatibility code can be removed.

The same is true for the cx2341x module: both converted and unconverted
bridge drivers are supported. Once all bridge drivers that use this module
are converted the compat code can be removed from cx2341x (and that will
save about 1060 lines of hard to understand code).

Before this can be merged Laurent Pinchart will have to verify that this
new framework can be used with UVC. Note to Laurent: v4l2_ctrl_new_custom()
allows you to pass a 'void *priv' pointer when creating the control. I'm
pretty sure you need this to associate a V4L control with a UVC data struct.
Should you need it, then it will be trivial to add a flag that will cause
the driver to kfree the priv pointer when the control is freed.

Regards,

	Hans

Hans Verkuil (15):
  v4l: Add new control handling framework
  v4l2-ctrls: reorder 'case' statements to match order in header.
  Documentation: add v4l2-controls.txt documenting the new controls
    API.
  v4l: hook up the new control framework into the core framework
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

 Documentation/video4linux/v4l2-controls.txt |  543 ++++++++
 drivers/media/video/Makefile                |    2 +-
 drivers/media/video/cs53l32a.c              |  107 +-
 drivers/media/video/cx2341x.c               |  725 +++++++++--
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
 drivers/media/video/v4l2-common.c           |  472 +-------
 drivers/media/video/v4l2-ctrls.c            | 1793 +++++++++++++++++++++++++++
 drivers/media/video/v4l2-device.c           |    7 +
 drivers/media/video/v4l2-ioctl.c            |   46 +-
 drivers/media/video/wm8739.c                |  176 +--
 drivers/media/video/wm8775.c                |   79 +-
 include/media/cx2341x.h                     |   81 ++
 include/media/cx25840.h                     |   11 +
 include/media/v4l2-ctrls.h                  |  271 ++++
 include/media/v4l2-dev.h                    |    4 +
 include/media/v4l2-device.h                 |    4 +
 include/media/v4l2-subdev.h                 |    3 +
 34 files changed, 4051 insertions(+), 1899 deletions(-)
 create mode 100644 Documentation/video4linux/v4l2-controls.txt
 create mode 100644 drivers/media/video/v4l2-ctrls.c
 create mode 100644 include/media/v4l2-ctrls.h

