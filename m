Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:43785 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757613AbdEVJVp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 05:21:45 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Various fixes
Message-ID: <008757f0-238d-94fd-b16f-73e143bf6699@xs4all.nl>
Date: Mon, 22 May 2017 11:21:40 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various fixes for 4.13.

The following changes since commit 36bcba973ad478042d1ffc6e89afd92e8bd17030:

  [media] mtk_vcodec_dec: return error at mtk_vdec_pic_info_update() (2017-05-19 07:12:05 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.13a

for you to fetch changes up to 196cb7e2b8becf9f4e81457d4335a1c2beee41bc:

  em28xx: fix spelling mistake: "missdetected" -> "misdetected" (2017-05-22 11:18:41 +0200)

----------------------------------------------------------------
Benjamin Gaignard (2):
      cec: stih: allow to use max CEC logical addresses
      cec: stih: fix typos in comments

Colin Ian King (2):
      cx18: fix spelling mistake: "demodualtor" -> "demodulator"
      em28xx: fix spelling mistake: "missdetected" -> "misdetected"

Daniel Roschka (1):
      uvcvideo: Quirk for webcam in MacBook Pro 2016

Devin Heitmueller (12):
      cx88: Fix regression in initial video standard setting
      mxl111sf: Fix driver to use heap allocate buffers for USB messages
      au8522: don't attempt to configure unsupported VBI slicer
      au8522: don't touch i2c master registers on au8522
      au8522: rework setup of audio routing
      au8522: remove note about VBI not being implemented
      au8522: remove leading bit for register writes
      au8522 Remove 0x4 bit for register reads
      au8522: fix lock detection to be more reliable.
      xc5000: Don't spin waiting for analog lock
      au8522: Set the initial modulation
      au0828: Add timer to restart TS stream if no data arrives on bulk endpoint

Frank Schaefer (1):
      em28xx: fix+improve the register (usb control message) debugging

Gustavo A. R. Silva (2):
      media: platform: coda: remove variable self assignment
      media: i2c: initialize scalar variables

Hans Verkuil (1):
      v4l2-ioctl.c: always copy G/S_EDID result

Johan Hovold (1):
      usbvision: add missing USB-descriptor endianness conversions

Oleh Kravchenko (1):
      cx231xx: Initial support Astrometa T2hybrid

Pan Bian (3):
      m5602_s5k83a: check return value of kthread_create
      cobalt: fix unchecked return values
      cx25840: fix unchecked return values

Peter Boström (1):
      uvcvideo: Add iFunction or iInterface to device names.

Petr Cvek (4):
      pxa_camera: Add remaining Bayer 8 formats
      pxa_camera: Fix incorrect test in the image size generation
      pxa_camera: Add (un)subscribe_event ioctl
      pxa_camera: Fix a call with an uninitialized device pointer

Philipp Zabel (1):
      coda: simplify optional reset handling

Rene Hickersberger (1):
      media: s5p-cec: Fixed spelling mistake

Songjun Wu (1):
      atmel-isc: Set the default DMA memory burst size

Thomas Hollstegge (1):
      em28xx: support for Sundtek MediaTV Digital Home

 drivers/media/dvb-frontends/au8522_common.c   |   1 +
 drivers/media/dvb-frontends/au8522_decoder.c  |  74 +++++--------------
 drivers/media/dvb-frontends/au8522_dig.c      | 215 +++++++++++++++++++++++++++---------------------------
 drivers/media/i2c/cx25840/cx25840-core.c      |  36 +++++----
 drivers/media/i2c/ov2659.c                    |   3 +-
 drivers/media/pci/cobalt/cobalt-driver.c      |   2 +
 drivers/media/pci/cx18/cx18-dvb.c             |   2 +-
 drivers/media/pci/cx88/cx88-cards.c           |   9 ++-
 drivers/media/pci/cx88/cx88-video.c           |   2 +-
 drivers/media/platform/atmel/atmel-isc.c      |  23 +++---
 drivers/media/platform/coda/coda-common.c     |  13 +---
 drivers/media/platform/pxa_camera.c           |  51 ++++++++++---
 drivers/media/platform/s5p-cec/s5p_cec.c      |   2 +-
 drivers/media/platform/sti/cec/stih-cec.c     |   7 +-
 drivers/media/tuners/xc5000.c                 |  26 +------
 drivers/media/usb/au0828/au0828-dvb.c         |  30 ++++++++
 drivers/media/usb/au0828/au0828.h             |   2 +
 drivers/media/usb/cx231xx/Kconfig             |   2 +
 drivers/media/usb/cx231xx/cx231xx-cards.c     |  34 +++++++++
 drivers/media/usb/cx231xx/cx231xx-dvb.c       |  49 +++++++++++++
 drivers/media/usb/cx231xx/cx231xx.h           |   1 +
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c   |   4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c       |  32 ++++----
 drivers/media/usb/dvb-usb-v2/mxl111sf.h       |   8 +-
 drivers/media/usb/em28xx/em28xx-cards.c       |  19 ++++-
 drivers/media/usb/em28xx/em28xx-core.c        |  35 ++++-----
 drivers/media/usb/em28xx/em28xx-dvb.c         |   1 +
 drivers/media/usb/em28xx/em28xx.h             |   1 +
 drivers/media/usb/gspca/m5602/m5602_s5k83a.c  |   5 ++
 drivers/media/usb/usbvision/usbvision-video.c |   4 +-
 drivers/media/usb/uvc/uvc_driver.c            |  34 ++++++++-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  31 +++++---
 32 files changed, 462 insertions(+), 296 deletions(-)
