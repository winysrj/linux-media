Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:49756 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbbGMLO3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 07:14:29 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id A66BE2A066F
	for <linux-media@vger.kernel.org>; Mon, 13 Jul 2015 13:13:33 +0200 (CEST)
Message-ID: <55A39D5D.4060802@xs4all.nl>
Date: Mon, 13 Jul 2015 13:13:33 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.3] Various fixes/enhancements: v2
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Nothing spectacular here, just a bunch of fixes and enhancements.

It's v2 because I managed to drop one chunk of Geert's patch in v1.

Regards,

	Hans

The following changes since commit 8783b9c50400c6279d7c3b716637b98e83d3c933:

  [media] SMI PCIe IR driver for DVBSky cards (2015-07-06 08:26:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.3a

for you to fetch changes up to 0d35c715e351e2983b6256b3c04e3c835567c891:

  bdisp: fix debug info memory access (2015-07-13 13:11:28 +0200)

----------------------------------------------------------------
Benoit Parrot (1):
      media: am437x-vpfe: Requested frame size and fmt overwritten by current sensor setting

Ezequiel Garcia (2):
      stk1160: Reduce driver verbosity
      stk1160: Add frame scaling support

Fabien Dessenne (3):
      bdisp: composing support
      bdisp: add debug info for RGB24 format
      bdisp: fix debug info memory access

Geert Uytterhoeven (1):
      adv7604/cobalt: Allow compile test if !GPIOLIB

Hans Verkuil (3):
      v4l2-event: v4l2_event_queue: do nothing if vdev == NULL
      DocBook: fix media-ioc-device-info.xml type
      DocBook media: fix typo in V4L2_CTRL_FLAG_EXECUTE_ON_WRITE

Lars-Peter Clausen (5):
      adv7604: Add support for control event notifications
      adv7842: Add support for control event notifications
      Add helper function for subdev event notifications
      adv7604: Deliver resolution change events to userspace
      adv7842: Deliver resolution change events to userspace

 Documentation/DocBook/media/v4l/media-ioc-device-info.xml |   2 +-
 Documentation/DocBook/media/v4l/vidioc-queryctrl.xml      |   2 +-
 drivers/media/i2c/Kconfig                                 |   3 +-
 drivers/media/i2c/adv7604.c                               |  26 ++++++--
 drivers/media/i2c/adv7842.c                               |  25 ++++++--
 drivers/media/pci/cobalt/Kconfig                          |   3 +-
 drivers/media/platform/am437x/am437x-vpfe.c               |   2 +-
 drivers/media/platform/sti/bdisp/bdisp-debug.c            |   8 +++
 drivers/media/platform/sti/bdisp/bdisp-hw.c               |  12 ++--
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c             |  76 +++++++++++++++--------
 drivers/media/usb/stk1160/stk1160-core.c                  |   5 +-
 drivers/media/usb/stk1160/stk1160-reg.h                   |  34 +++++++++++
 drivers/media/usb/stk1160/stk1160-v4l.c                   | 217 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 drivers/media/usb/stk1160/stk1160.h                       |   1 -
 drivers/media/v4l2-core/v4l2-event.c                      |   3 +
 drivers/media/v4l2-core/v4l2-subdev.c                     |  18 ++++++
 include/media/v4l2-subdev.h                               |   4 ++
 17 files changed, 354 insertions(+), 87 deletions(-)
