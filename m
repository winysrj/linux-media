Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4766 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaBQLKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 06:10:05 -0500
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id s1HBA1q1051536
	for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 12:10:03 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 6F4802A00A9
	for <linux-media@vger.kernel.org>; Mon, 17 Feb 2014 12:09:27 +0100 (CET)
Message-ID: <5301EDE7.6050202@xs4all.nl>
Date: Mon, 17 Feb 2014 12:09:27 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.15] Add support for complex controls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds support for complex controls to the control framework
and uses them in the go7007 and solo6x10 drivers. It is the first part of a
larger patch series that adds support for configuration stores and support
for 'Multiple Selections'.

An updated v4l2-ctl that can be used to test matrix controls can be found here:

http://git.linuxtv.org/hverkuil/v4l-utils.git/shortlog/refs/heads/propapi2

Regards,

	Hans

The following changes since commit 37e59f876bc710d67a30b660826a5e83e07101ce:

  [media, edac] Change my email address (2014-02-07 08:03:07 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git propapi-part2

for you to fetch changes up to 440a982d11981e84fd3f566bc9928673a8f0a567:

  go7007: add motion detection support. (2014-02-17 10:37:38 +0100)

----------------------------------------------------------------
Hans Verkuil (35):
      v4l2-ctrls: increase internal min/max/step/def to 64 bit
      v4l2-ctrls: add unit string.
      v4l2-ctrls: use pr_info/cont instead of printk.
      videodev2.h: add initial support for complex controls.
      videodev2.h: add struct v4l2_query_ext_ctrl and VIDIOC_QUERY_EXT_CTRL.
      v4l2-ctrls: add support for complex types.
      v4l2: integrate support for VIDIOC_QUERY_EXT_CTRL.
      v4l2-ctrls: create type_ops.
      v4l2-ctrls: rewrite copy routines to operate on union v4l2_ctrl_ptr.
      v4l2-ctrls: compare values only once.
      v4l2-ctrls: prepare for matrix support: add cols & rows fields.
      v4l2-ctrls: replace cur by a union v4l2_ctrl_ptr.
      v4l2-ctrls: use 'new' to access pointer controls
      v4l2-ctrls: prepare for matrix support.
      v4l2-ctrls: type_ops can handle matrix elements.
      v4l2-ctrls: add matrix support.
      v4l2-ctrls: return elem_size instead of strlen
      v4l2-ctrl: fix error return of copy_to/from_user.
      DocBook media: document VIDIOC_QUERY_EXT_CTRL.
      DocBook media: update VIDIOC_G/S/TRY_EXT_CTRLS.
      DocBook media: fix coding style in the control example code
      DocBook media: update control section.
      v4l2-controls.txt: update to the new way of accessing controls.
      v4l2-ctrls/videodev2.h: add u8 and u16 types.
      DocBook media: document new u8 and u16 control types.
      v4l2-ctrls: fix comments
      v4l2-ctrls/v4l2-controls.h: add MD controls
      DocBook media: document new motion detection controls.
      v4l2: add a motion detection event.
      DocBook: document new v4l motion detection event.
      solo6x10: implement the new motion detection controls.
      solo6x10: implement the motion detection event.
      solo6x10: fix 'dma from stack' warning.
      solo6x10: check dma_map_sg() return value
      go7007: add motion detection support.

 Documentation/DocBook/media/v4l/controls.xml               | 282 ++++++++++++++++-----
 Documentation/DocBook/media/v4l/vidioc-dqevent.xml         |  44 ++++
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml     |  57 ++++-
 Documentation/DocBook/media/v4l/vidioc-queryctrl.xml       | 244 +++++++++++++++---
 Documentation/DocBook/media/v4l/vidioc-subscribe-event.xml |   8 +
 Documentation/video4linux/v4l2-controls.txt                |  50 ++--
 drivers/media/common/cx2341x.c                             |   4 +-
 drivers/media/i2c/adp1653.c                                |  10 +-
 drivers/media/i2c/as3645a.c                                |  22 +-
 drivers/media/i2c/lm3560.c                                 |   2 +-
 drivers/media/i2c/m5mols/m5mols_controls.c                 |   6 +-
 drivers/media/i2c/msp3400-driver.c                         |   4 +-
 drivers/media/i2c/mt9p031.c                                |   4 +-
 drivers/media/i2c/mt9t001.c                                |   4 +-
 drivers/media/i2c/mt9v032.c                                |   2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-ctrls.c                  |   6 +-
 drivers/media/i2c/smiapp/smiapp-core.c                     |  12 +-
 drivers/media/pci/cx18/cx18-av-core.c                      |   2 +-
 drivers/media/pci/cx18/cx18-driver.c                       |  10 +-
 drivers/media/platform/exynos4-is/fimc-core.c              |   6 +-
 drivers/media/platform/vivi.c                              |  33 +--
 drivers/media/radio/radio-isa.c                            |   2 +-
 drivers/media/radio/radio-sf16fmr2.c                       |   4 +-
 drivers/media/radio/si4713/si4713.c                        |   4 +-
 drivers/media/usb/gspca/conex.c                            |   8 +-
 drivers/media/usb/gspca/sn9c20x.c                          |   4 +-
 drivers/media/usb/gspca/topro.c                            |   4 +-
 drivers/media/v4l2-core/v4l2-common.c                      |   9 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c              |   1 +
 drivers/media/v4l2-core/v4l2-ctrls.c                       | 870 ++++++++++++++++++++++++++++++++++++++++++++---------------------
 drivers/media/v4l2-core/v4l2-dev.c                         |   2 +
 drivers/media/v4l2-core/v4l2-ioctl.c                       |  31 +++
 drivers/media/v4l2-core/v4l2-subdev.c                      |   3 +
 drivers/staging/media/go7007/go7007-driver.c               | 127 +++++++---
 drivers/staging/media/go7007/go7007-fw.c                   |  28 ++-
 drivers/staging/media/go7007/go7007-priv.h                 |  16 ++
 drivers/staging/media/go7007/go7007-v4l2.c                 | 318 ++++++++++++++++--------
 drivers/staging/media/go7007/go7007.h                      |  40 ---
 drivers/staging/media/go7007/saa7134-go7007.c              |   1 -
 drivers/staging/media/msi3101/sdr-msi3101.c                |   2 +-
 drivers/staging/media/solo6x10/solo6x10-disp.c             |  14 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c         | 183 +++++++-------
 drivers/staging/media/solo6x10/solo6x10.h                  |  26 +-
 include/media/v4l2-ctrls.h                                 | 124 +++++++---
 include/media/v4l2-ioctl.h                                 |   2 +
 include/uapi/linux/v4l2-controls.h                         |  17 ++
 include/uapi/linux/videodev2.h                             |  63 ++++-
 47 files changed, 1909 insertions(+), 806 deletions(-)
 delete mode 100644 drivers/staging/media/go7007/go7007.h
