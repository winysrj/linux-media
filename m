Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40254 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751052AbdCHOvv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Mar 2017 09:51:51 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] Fixes, small improvements, coda
Message-ID: <b70f50cd-cc96-a4d2-f1d7-c264161ec74f@xs4all.nl>
Date: Wed, 8 Mar 2017 15:51:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes, improvements.

Also a fair number of coda fixes.

Regards,

	Hans

The following changes since commit 700ea5e0e0dd70420a04e703ff264cc133834cba:

  Merge tag 'v4.11-rc1' into patchwork (2017-03-06 06:49:34 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.12b

for you to fetch changes up to 76ba73c6af740a4d87364da8423b3992079d2051:

  vivid: fix try_fmt behavior (2017-03-08 15:23:36 +0100)

----------------------------------------------------------------
Arnd Bergmann (1):
      tw5864: use dev_warn instead of WARN to shut up warning

Dmitry Torokhov (2):
      ad5820: remove incorrect __exit markups
      Staging: media: radio-bcm2048: remove incorrect __exit markups

Gustavo Padovan (6):
      vb2: only check ret if we assigned it
      ivtv: improve subscribe_event handling
      solo6x10: improve subscribe event handling
      tw5864: improve subscribe event handling
      vivid: improve subscribe event handling
      go7007: improve subscribe event handling

Hans Verkuil (3):
      coda: enable with COMPILE_TEST
      videodev2.h: map xvYCC601/709 to limited range quantization
      vivid: fix try_fmt behavior

Michael Tretter (1):
      coda: Use && instead of & for non-bitfield conditions

Philipp Zabel (7):
      tc358743: put lanes in STOP state before starting streaming
      coda: implement encoder stop command
      coda: disable BWB for all codecs on CODA 960
      coda: keep queued buffers on a temporary list during start_streaming
      coda: pad first h.264 buffer to 512 bytes
      coda: disable reordering for baseline profile h.264 streams
      coda: restore original firmware locations

 Documentation/media/uapi/v4l/pixfmt-007.rst    |  13 ++++--
 drivers/media/i2c/ad5820.c                     |   4 +-
 drivers/media/i2c/tc358743.c                   |   4 ++
 drivers/media/pci/ivtv/ivtv-ioctl.c            |   4 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c |   5 +--
 drivers/media/pci/tw5864/tw5864-video.c        |  11 +++---
 drivers/media/platform/Kconfig                 |   3 +-
 drivers/media/platform/coda/coda-bit.c         | 100 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/media/platform/coda/coda-common.c      | 120 +++++++++++++++++++++++++++++++++++++++++++++++---------
 drivers/media/platform/coda/coda-h264.c        |  87 +++++++++++++++++++++++++++++++++++++---
 drivers/media/platform/coda/coda.h             |   8 +++-
 drivers/media/platform/coda/coda_regs.h        |   1 +
 drivers/media/platform/vivid/vivid-vid-cap.c   |  13 ++++--
 drivers/media/platform/vivid/vivid-vid-out.c   |  26 ++++++------
 drivers/media/usb/go7007/go7007-v4l2.c         |   5 +--
 drivers/media/v4l2-core/videobuf2-core.c       |  14 ++++---
 drivers/staging/media/bcm2048/radio-bcm2048.c  |   4 +-
 include/uapi/linux/videodev2.h                 |   3 +-
 18 files changed, 345 insertions(+), 80 deletions(-)
