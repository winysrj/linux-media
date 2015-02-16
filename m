Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:58503 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754049AbbBPNb4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 08:31:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id E867D2A0080
	for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 14:31:36 +0100 (CET)
Message-ID: <54E1F138.3020508@xs4all.nl>
Date: Mon, 16 Feb 2015 14:31:36 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.21] Various fixes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Just a bunch of various fixes for 3.21.

Regards,

	Hans

The following changes since commit 135f9be9194cf7778eb73594aa55791b229cf27c:

  [media] dvb_frontend: start media pipeline while thread is running (2015-02-13 21:10:17 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.21a

for you to fetch changes up to 4c75339d0238da17f5d28311373b6335d9f290b1:

  media: radio: handle timeouts (2015-02-16 12:24:16 +0100)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      sh_vou: fix memory leak on error paths in sh_vou_open()

Christian Engelmayer (1):
      cx88: Fix possible leak in cx8802_probe()

Geert Uytterhoeven (2):
      am437x: VIDEO_AM437X_VPFE should depend on HAS_DMA
      timberdale: VIDEO_TIMBERDALE should depend on HAS_DMA

Hans Verkuil (1):
      DocBook media: fix validation error

Kiran Padwal (1):
      staging: dt3155v4l: Switch to using managed resource with devm_

Luis de Bethencourt (1):
      media: bcm2048: remove unused return of function

Markus Elfring (2):
      stk-webcam: Delete an unnecessary check before the function call "vfree"
      au0828: Delete unnecessary checks before the function call "video_unregister_device"

Mauro Carvalho Chehab (1):
      fixp-arith: replace sin/cos table by a better precision one

Nicholas Mc Guire (4):
      cx231xx: drop condition with no effect
      si470x: fixup wait_for_completion_timeout return handling
      media: radio: assign wait_for_completion_timeout to appropriately typed var
      media: radio: handle timeouts

Prashant Laddha (2):
      vivid sdr: Use LUT based implementation for sin/cos()
      vivid sdr: fix broken sine tone generated for sdr FM

jean-michel.hautbois@vodalys.com (2):
      media: i2c: ADV7604: In free run mode, signal is locked
      media: adv7604: CP CSC uses a different register on adv7604 and adv7611

 Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml |   2 +-
 drivers/input/ff-memless.c                          |  18 +++++++--
 drivers/media/i2c/adv7604.c                         |  17 +++++++--
 drivers/media/pci/cx88/cx88-mpeg.c                  |   3 +-
 drivers/media/platform/Kconfig                      |   2 +-
 drivers/media/platform/am437x/Kconfig               |   2 +-
 drivers/media/platform/sh_vou.c                     |   9 +++--
 drivers/media/platform/vivid/vivid-sdr-cap.c        |  66 ++++++++++++++-------------------
 drivers/media/radio/radio-wl1273.c                  |  27 +++++++++-----
 drivers/media/radio/si470x/radio-si470x-common.c    |  14 ++++---
 drivers/media/usb/au0828/au0828-video.c             |   8 +---
 drivers/media/usb/cx231xx/cx231xx-core.c            |  13 ++-----
 drivers/media/usb/gspca/ov534.c                     |  11 ++----
 drivers/media/usb/stkwebcam/stk-webcam.c            |   6 +--
 drivers/staging/media/bcm2048/radio-bcm2048.c       |   4 +-
 drivers/staging/media/dt3155v4l/dt3155v4l.c         |  13 +++----
 include/linux/fixp-arith.h                          | 145 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------
 17 files changed, 214 insertions(+), 146 deletions(-)
