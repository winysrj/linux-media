Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45189 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbcDOMpL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 08:45:11 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E8A1A180436
	for <linux-media@vger.kernel.org>; Fri, 15 Apr 2016 14:45:05 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.7] Various fixes
Message-ID: <5710E251.7050203@xs4all.nl>
Date: Fri, 15 Apr 2016 14:45:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


The following changes since commit ecb7b0183a89613c154d1bea48b494907efbf8f9:

  [media] m88ds3103: fix undefined division (2016-04-13 19:17:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.7b

for you to fetch changes up to 7a707cf621e9c299f3b07a059cabaed164d807b4:

  tpg: Export the tpg code from vivid as a module (2016-04-15 13:33:00 +0200)

----------------------------------------------------------------
Claudiu Beznea (1):
      Staging: media: bcm2048: defined region_configs[] array as const array

Hans Verkuil (8):
      tc358743: zero the reserved array
      vidioc-g-edid.xml: be explicit about zeroing the reserved array
      vidioc-enum-dv-timings.xml: explicitly state that pad and reserved should be zeroed
      vidioc-dv-timings-cap.xml: explicitly state that pad and reserved should be zeroed
      v4l2-device.h: add v4l2_device_mask_ variants
      ivtv/cx18: use the new mask variants of the v4l2_device_call_* defines
      v4l2-rect.h: new header with struct v4l2_rect helper functions.
      vivid: use new v4l2-rect.h header

Helen Mae Koike Fornazier (1):
      tpg: Export the tpg code from vivid as a module

Niklas Söderlund (3):
      adv7180: Add g_std operation
      adv7180: Add cropcap operation
      adv7180: Add g_tvnorms operation

Vladis Dronov (1):
      usbvision: revert commit 588afcc1

 Documentation/DocBook/device-drivers.tmpl                            |   1 +
 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml            |  12 ++-
 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml           |   5 +-
 Documentation/DocBook/media/v4l/vidioc-g-edid.xml                    |  10 +-
 drivers/media/common/Kconfig                                         |   1 +
 drivers/media/common/Makefile                                        |   2 +-
 drivers/media/common/v4l2-tpg/Kconfig                                |   2 +
 drivers/media/common/v4l2-tpg/Makefile                               |   3 +
 .../vivid/vivid-tpg-colors.c => common/v4l2-tpg/v4l2-tpg-colors.c}   |   7 +-
 .../{platform/vivid/vivid-tpg.c => common/v4l2-tpg/v4l2-tpg-core.c}  |  25 ++++-
 drivers/media/i2c/adv7180.c                                          |  34 +++++-
 drivers/media/i2c/tc358743.c                                         |   4 +
 drivers/media/pci/cx18/cx18-driver.h                                 |  13 +--
 drivers/media/pci/ivtv/ivtv-driver.h                                 |  13 +--
 drivers/media/platform/vivid/Kconfig                                 |   1 +
 drivers/media/platform/vivid/Makefile                                |   2 +-
 drivers/media/platform/vivid/vivid-core.h                            |   2 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c                     |  13 +--
 drivers/media/platform/vivid/vivid-vid-cap.c                         | 101 +++++++++---------
 drivers/media/platform/vivid/vivid-vid-common.c                      |  97 -----------------
 drivers/media/platform/vivid/vivid-vid-common.h                      |   9 --
 drivers/media/platform/vivid/vivid-vid-out.c                         | 103 +++++++++---------
 drivers/media/usb/go7007/go7007-v4l2.c                               |   2 +-
 drivers/media/usb/usbvision/usbvision-video.c                        |   7 --
 drivers/staging/media/bcm2048/radio-bcm2048.c                        |   2 +-
 include/media/v4l2-device.h                                          |  55 +++++++++-
 include/media/v4l2-rect.h                                            | 173 +++++++++++++++++++++++++++++++
 .../vivid/vivid-tpg-colors.h => include/media/v4l2-tpg-colors.h      |   6 +-
 drivers/media/platform/vivid/vivid-tpg.h => include/media/v4l2-tpg.h |   9 +-
 29 files changed, 440 insertions(+), 274 deletions(-)
 create mode 100644 drivers/media/common/v4l2-tpg/Kconfig
 create mode 100644 drivers/media/common/v4l2-tpg/Makefile
 rename drivers/media/{platform/vivid/vivid-tpg-colors.c => common/v4l2-tpg/v4l2-tpg-colors.c} (99%)
 rename drivers/media/{platform/vivid/vivid-tpg.c => common/v4l2-tpg/v4l2-tpg-core.c} (98%)
 create mode 100644 include/media/v4l2-rect.h
 rename drivers/media/platform/vivid/vivid-tpg-colors.h => include/media/v4l2-tpg-colors.h (93%)
 rename drivers/media/platform/vivid/vivid-tpg.h => include/media/v4l2-tpg.h (99%)
