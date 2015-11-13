Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:33236 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbbKMN26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2015 08:28:58 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CDDF4E3567
	for <linux-media@vger.kernel.org>; Fri, 13 Nov 2015 14:28:52 +0100 (CET)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.5] Various fixes/enhancements
Message-ID: <5645E594.4090905@xs4all.nl>
Date: Fri, 13 Nov 2015 14:28:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A large pile of various fixes and enhancements.

Regards,

	Hans

The following changes since commit 79f5b6ae960d380c829fb67d5dadcd1d025d2775:

  [media] c8sectpfe: Remove select on CONFIG_FW_LOADER_USER_HELPER_FALLBACK (2015-10-20 16:02:41 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.5a

for you to fetch changes up to 54adb10d0947478b3364640a131fff1f1ab190fa:

  v4l2-dv-timings: add new arg to v4l2_match_dv_timings (2015-11-13 14:15:55 +0100)

----------------------------------------------------------------
Antonio Ospite (1):
      gspca: ov534/topro: prevent a division by 0

Antti Palosaari (2):
      hackrf: move RF gain ctrl enable behind module parameter
      hackrf: fix possible null ptr on debug printing

Arnd Bergmann (1):
      sh-vou: clarify videobuf2 dependency

Dan Carpenter (2):
      av7110: don't allow negative volumes
      av7110: potential divide by zero

Hans Verkuil (6):
      DocBook media: s/input stream/capture stream/
      go7007: fix broken test
      vivid: fix compliance error
      vb2: fix a regression in poll() behavior for output,streams
      adv7511: fix incorrect bit offset
      v4l2-dv-timings: add new arg to v4l2_match_dv_timings

Julia Lawall (2):
      media: videobuf2: fix compare_const_fl.cocci warnings
      radio-shark2: constify radio_tea5777_ops structures

Kosuke Tatsukawa (1):
      media: fix waitqueue_active without memory barrier in cpia2 driver

Mats Randgaard (1):
      v4l2-dv-timings: Compare horizontal blanking

Oliver Neukum (1):
      usbvision fix overflow of interfaces array

Prashant Laddha (4):
      v4l2-dv-timings: add condition checks for reduced fps
      vivid: add support for reduced fps in video out
      vivid-capture: add control for reduced frame rate
      vivid: add support for reduced frame rate in video capture

Ricardo Ribalda Delgado (7):
      v4l2-core/v4l2-ctrls: Filter NOOP CH_RANGE events
      videodev2.h: Extend struct v4l2_ext_controls
      media/core: Replace ctrl_class with which
      media/v4l2-core: struct struct v4l2_ext_controls param which
      usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
      media/usb/pvrusb2: Support for V4L2_CTRL_WHICH_DEF_VAL
      Docbook: media: Document changes on struct v4l2_ext_controls

Terry Heo (1):
      cx231xx: fix bulk transfer mode

Tommi Franttila (1):
      v4l2-device: Don't unregister ACPI/Device Tree based devices

Ulrich Hecht (1):
      media: adv7180: increase delay after reset to 5ms

 Documentation/DocBook/media/v4l/io.xml                 | 10 ++++----
 Documentation/DocBook/media/v4l/v4l2.xml               | 10 ++++++++
 Documentation/DocBook/media/v4l/vidioc-g-ext-ctrls.xml | 28 ++++++++++++++++++---
 drivers/media/i2c/adv7180.c                            |  2 +-
 drivers/media/i2c/adv7511.c                            |  2 +-
 drivers/media/i2c/adv7604.c                            |  6 ++---
 drivers/media/i2c/adv7842.c                            |  6 ++---
 drivers/media/i2c/tc358743.c                           |  4 +--
 drivers/media/pci/cobalt/cobalt-v4l2.c                 |  2 +-
 drivers/media/pci/ttpci/av7110_av.c                    |  9 +++++--
 drivers/media/pci/ttpci/av7110_av.h                    |  3 ++-
 drivers/media/platform/Kconfig                         |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c           |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c           |  2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c               |  2 +-
 drivers/media/platform/vivid/vivid-core.h              |  1 +
 drivers/media/platform/vivid/vivid-ctrls.c             | 21 ++++++++++++++--
 drivers/media/platform/vivid/vivid-vid-cap.c           | 12 +++++++--
 drivers/media/platform/vivid/vivid-vid-out.c           | 11 ++++++--
 drivers/media/radio/radio-shark2.c                     |  2 +-
 drivers/media/radio/radio-tea5777.h                    |  2 +-
 drivers/media/usb/cpia2/cpia2_usb.c                    |  3 +--
 drivers/media/usb/cx231xx/cx231xx-core.c               | 15 ++++++++++-
 drivers/media/usb/go7007/go7007-usb.c                  |  2 +-
 drivers/media/usb/gspca/ov534.c                        |  9 +++++--
 drivers/media/usb/gspca/topro.c                        |  6 ++++-
 drivers/media/usb/hackrf/hackrf.c                      | 13 +++++++++-
 drivers/media/usb/hdpvr/hdpvr-video.c                  |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c               | 16 ++++++++++--
 drivers/media/usb/usbvision/usbvision-video.c          |  7 ++++++
 drivers/media/usb/uvc/uvc_v4l2.c                       | 20 +++++++++++++++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c          |  6 ++---
 drivers/media/v4l2-core/v4l2-ctrls.c                   | 77 ++++++++++++++++++++++++++++++++++++++------------------
 drivers/media/v4l2-core/v4l2-device.c                  | 21 +++++++++++-----
 drivers/media/v4l2-core/v4l2-dv-timings.c              | 16 ++++++++++--
 drivers/media/v4l2-core/v4l2-ioctl.c                   | 14 +++++------
 drivers/media/v4l2-core/videobuf2-v4l2.c               |  8 +++---
 include/media/v4l2-dv-timings.h                        | 25 +++++++++++++++++-
 include/uapi/linux/videodev2.h                         | 12 ++++++++-
 39 files changed, 318 insertions(+), 93 deletions(-)
