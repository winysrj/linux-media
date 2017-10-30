Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:48255 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751469AbdJ3KcE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Oct 2017 06:32:04 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.15] More fixes/cleanups
Message-ID: <e8409a3e-6f14-aaf2-9c25-594ed3a10658@xs4all.nl>
Date: Mon, 30 Oct 2017 11:31:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

A lot of timer_setup conversions. The other patches are all over the place.

Please note the CC to stable for 3.17 and up for the v4l2-ctrl patch from Ricardo:
I verified that it applies to that kernel.

It's a little bug that's been there from the beginning until Ricardo noticed it
and fixed it. Thanks Ricardo!

Regards,

	Hans

The following changes since commit bbae615636155fa43a9b0fe0ea31c678984be864:

  media: staging: atomisp2: cleanup null check on memory allocation (2017-10-27 17:33:39 +0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.15e

for you to fetch changes up to 6509fc8c8841033017358a001616c43edfb6693d:

  st-hva: hva-h264: use swap macro in hva_h264_encode (2017-10-30 11:18:48 +0100)

----------------------------------------------------------------
Adam Sampson (1):
      media: usbtv: fix brightness and contrast controls

Arnd Bergmann (1):
      rockchip/rga: annotate PM functions as __maybe_unused

Bhumika Goyal (4):
      cx231xx: make cx231xx_vbi_qops const
      radio-si470x: make si470x_viddev_template const
      davinci: make function arguments const
      davinci: make ccdc_hw_device structures const

Colin Ian King (4):
      radio-raremono: remove redundant initialization of freq
      mxl111sf: remove redundant assignment to index
      gspca: remove redundant assignment to variable j
      bdisp: remove redundant assignment to pix

Gustavo A. R. Silva (1):
      st-hva: hva-h264: use swap macro in hva_h264_encode

Hans Verkuil (3):
      cec-pin: use IS_ERR instead of PTR_ERR_OR_ZERO
      tegra-cec: fix messy probe() cleanup
      camss-video.c: drop unused header

Jaejoong Kim (1):
      media: usb: usbtv: remove duplicate & operation

Kees Cook (9):
      media/saa7146: Convert timers to use timer_setup()
      media: tc358743: Convert timers to use timer_setup()
      media: saa7146: Convert timers to use timer_setup()
      media: dvb-core: Convert timers to use timer_setup()
      media: tvaudio: Convert timers to use timer_setup()
      media: saa7134: Convert timers to use timer_setup()
      media: pci: Convert timers to use timer_setup()
      media: radio: Convert timers to use timer_setup()
      media: s2255: Convert timers to use timer_setup()

Markus Elfring (1):
      omap_vout: Fix a possible null pointer dereference in omap_vout_open()

Ricardo Ribalda Delgado (1):
      media: v4l2-ctrl: Fix flags field on Control events

Wenyou Yang (1):
      media: atmel-isc: Fix clock ID for clk_prepare/unprepare

 drivers/media/cec/cec-pin.c                          |  2 +-
 drivers/media/common/saa7146/saa7146_fops.c          |  6 +++---
 drivers/media/common/saa7146/saa7146_vbi.c           | 12 ++++++------
 drivers/media/common/saa7146/saa7146_video.c         |  3 +--
 drivers/media/dvb-core/dmxdev.c                      |  8 +++-----
 drivers/media/i2c/tc358743.c                         |  7 +++----
 drivers/media/i2c/tvaudio.c                          |  8 +++-----
 drivers/media/pci/bt8xx/bttv-driver.c                |  6 +++---
 drivers/media/pci/bt8xx/bttv-input.c                 | 19 ++++++++++---------
 drivers/media/pci/bt8xx/bttvp.h                      |  1 +
 drivers/media/pci/cx18/cx18-fileops.c                |  4 ++--
 drivers/media/pci/cx18/cx18-fileops.h                |  2 +-
 drivers/media/pci/cx18/cx18-streams.c                |  2 +-
 drivers/media/pci/ivtv/ivtv-driver.c                 |  3 +--
 drivers/media/pci/ivtv/ivtv-irq.c                    |  4 ++--
 drivers/media/pci/ivtv/ivtv-irq.h                    |  2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c   |  7 +++----
 drivers/media/pci/saa7134/saa7134-core.c             |  6 +++---
 drivers/media/pci/saa7134/saa7134-input.c            |  9 ++++-----
 drivers/media/pci/saa7134/saa7134-ts.c               |  3 +--
 drivers/media/pci/saa7134/saa7134-vbi.c              |  3 +--
 drivers/media/pci/saa7134/saa7134-video.c            |  3 +--
 drivers/media/pci/saa7134/saa7134.h                  |  2 +-
 drivers/media/pci/tw686x/tw686x-core.c               |  7 +++----
 drivers/media/platform/atmel/atmel-isc.c             |  8 ++++----
 drivers/media/platform/davinci/ccdc_hw_device.h      |  4 ++--
 drivers/media/platform/davinci/dm355_ccdc.c          |  2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c         |  2 +-
 drivers/media/platform/davinci/isif.c                |  2 +-
 drivers/media/platform/davinci/vpfe_capture.c        |  6 +++---
 drivers/media/platform/omap/omap_vout.c              |  3 ++-
 drivers/media/platform/qcom/camss-8x16/camss-video.c |  1 -
 drivers/media/platform/rockchip/rga/rga.c            |  6 ++----
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c        |  2 +-
 drivers/media/platform/sti/hva/hva-h264.c            |  5 +----
 drivers/media/platform/tegra-cec/tegra_cec.c         | 26 ++++++++++----------------
 drivers/media/radio/radio-cadet.c                    |  7 +++----
 drivers/media/radio/radio-raremono.c                 |  2 +-
 drivers/media/radio/si470x/radio-si470x-common.c     |  2 +-
 drivers/media/radio/si470x/radio-si470x.h            |  2 +-
 drivers/media/radio/wl128x/fmdrv_common.c            |  7 +++----
 drivers/media/usb/cx231xx/cx231xx-vbi.c              |  2 +-
 drivers/media/usb/cx231xx/cx231xx-vbi.h              |  2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c          |  1 -
 drivers/media/usb/gspca/gspca.c                      |  1 -
 drivers/media/usb/s2255/s2255drv.c                   |  7 ++++---
 drivers/media/usb/usbtv/usbtv-core.c                 |  2 +-
 drivers/media/usb/usbtv/usbtv-video.c                |  4 ++--
 drivers/media/v4l2-core/v4l2-ctrls.c                 | 16 ++++++++++++----
 include/media/drv-intf/saa7146_vv.h                  |  3 ++-
 50 files changed, 119 insertions(+), 135 deletions(-)
