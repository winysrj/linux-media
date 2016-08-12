Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:38019 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648AbcHLMGx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 08:06:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 12E281800A9
	for <linux-media@vger.kernel.org>; Fri, 12 Aug 2016 14:06:47 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Various fixes, enhancements
Message-ID: <fe61a147-a745-78a8-59ce-c6fcbb62c6d9@xs4all.nl>
Date: Fri, 12 Aug 2016 14:06:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mostly cleanup patches, a tw686x fix and a cobalt and adv7180 enhancement.

Regards,

	Hans

The following changes since commit b6aa39228966e0d3f0bc3306be1892f87792903a:

  Merge tag 'v4.8-rc1' into patchwork (2016-08-08 07:30:25 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.9a

for you to fetch changes up to d5e7733216643ae8f10e2bef33ba0edcc9cc11da:

  media: adv7180: add power pin control (2016-08-12 14:02:24 +0200)

----------------------------------------------------------------
Bhaktipriya Shridhar (6):
      pvrusb2: Remove deprecated create_singlethread_workqueue
      gspca: sonixj: Remove deprecated create_singlethread_workqueue
      gspca: vicam: Remove deprecated create_singlethread_workqueue
      gspca: jl2005bcd: Remove deprecated create_singlethread_workqueue
      gspca: finepix: Remove deprecated create_singlethread_workqueue
      ad9389b: Remove deprecated create_singlethread_workqueue

Ezequiel Garcia (1):
      media: tw686x: Rework initial hardware configuration

Hans Verkuil (1):
      cobalt: support reduced fps

Julia Lawall (1):
      mtk-vcodec: constify venc_common_if structures

Markus Elfring (3):
      cec: Delete an unnecessary check before the function call "rc_free_device"
      v4l2-common: Delete an unnecessary check before the function call "spi_unregister_device"
      tw686x: Delete an unnecessary check before the function call "video_unregister_device"

Steve Longerbeam (2):
      media: adv7180: define more registers
      media: adv7180: add power pin control

Wolfram Sang (28):
      media: dvb-frontends: rtl2832_sdr: don't print error when allocating urb fails
      media: radio: si470x: radio-si470x-usb: don't print error when allocating urb fails
      media: rc: imon: don't print error when allocating urb fails
      media: rc: redrat3: don't print error when allocating urb fails
      media: usb: airspy: airspy: don't print error when allocating urb fails
      media: usb: as102: as102_usb_drv: don't print error when allocating urb fails
      media: usb: au0828: au0828-video: don't print error when allocating urb fails
      media: usb: cpia2: cpia2_usb: don't print error when allocating urb fails
      media: usb: cx231xx: cx231xx-audio: don't print error when allocating urb fails
      media: usb: cx231xx: cx231xx-core: don't print error when allocating urb fails
      media: usb: cx231xx: cx231xx-vbi: don't print error when allocating urb fails
      media: usb: dvb-usb: dib0700_core: don't print error when allocating urb fails
      media: usb: em28xx: em28xx-audio: don't print error when allocating urb fails
      media: usb: em28xx: em28xx-core: don't print error when allocating urb fails
      media: usb: gspca: benq: don't print error when allocating urb fails
      media: usb: gspca: gspca: don't print error when allocating urb fails
      media: usb: gspca: konica: don't print error when allocating urb fails
      media: usb: hackrf: hackrf: don't print error when allocating urb fails
      media: usb: hdpvr: hdpvr-video: don't print error when allocating urb fails
      media: usb: msi2500: msi2500: don't print error when allocating urb fails
      media: usb: pwc: pwc-if: don't print error when allocating urb fails
      media: usb: s2255: s2255drv: don't print error when allocating urb fails
      media: usb: stk1160: stk1160-video: don't print error when allocating urb fails
      media: usb: stkwebcam: stk-webcam: don't print error when allocating urb fails
      media: usb: tm6000: tm6000-dvb: don't print error when allocating urb fails
      media: usb: tm6000: tm6000-video: don't print error when allocating urb fails
      media: usb: usbvision: usbvision-core: don't print error when allocating urb fails
      media: usb: zr364xx: zr364xx: don't print error when allocating urb fails

 Documentation/devicetree/bindings/media/i2c/adv7180.txt |   5 ++
 drivers/media/dvb-frontends/rtl2832_sdr.c               |   1 -
 drivers/media/i2c/Kconfig                               |   2 +-
 drivers/media/i2c/ad9389b.c                             |  22 ++-----
 drivers/media/i2c/adv7180.c                             | 100 +++++++++++++++++++++++--------
 drivers/media/pci/cobalt/cobalt-v4l2.c                  |   7 ++-
 drivers/media/pci/tw686x/tw686x-video.c                 | 142 +++++++++++++++++++++++++-------------------
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h      |   2 +-
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c   |   6 +-
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c    |   6 +-
 drivers/media/platform/mtk-vcodec/venc_drv_if.c         |   4 +-
 drivers/media/radio/si470x/radio-si470x-usb.c           |   1 -
 drivers/media/rc/imon.c                                 |  13 +---
 drivers/media/rc/redrat3.c                              |   4 +-
 drivers/media/usb/airspy/airspy.c                       |   1 -
 drivers/media/usb/as102/as102_usb_drv.c                 |   2 -
 drivers/media/usb/au0828/au0828-video.c                 |   1 -
 drivers/media/usb/cpia2/cpia2_usb.c                     |   1 -
 drivers/media/usb/cx231xx/cx231xx-audio.c               |   2 -
 drivers/media/usb/cx231xx/cx231xx-core.c                |   4 --
 drivers/media/usb/cx231xx/cx231xx-vbi.c                 |   2 -
 drivers/media/usb/dvb-usb/dib0700_core.c                |   4 +-
 drivers/media/usb/em28xx/em28xx-audio.c                 |   1 -
 drivers/media/usb/em28xx/em28xx-core.c                  |   1 -
 drivers/media/usb/gspca/benq.c                          |   4 +-
 drivers/media/usb/gspca/finepix.c                       |   8 +--
 drivers/media/usb/gspca/gspca.c                         |   4 +-
 drivers/media/usb/gspca/jl2005bcd.c                     |   8 +--
 drivers/media/usb/gspca/konica.c                        |   4 +-
 drivers/media/usb/gspca/sonixj.c                        |  13 ++--
 drivers/media/usb/gspca/vicam.c                         |   8 +--
 drivers/media/usb/hackrf/hackrf.c                       |   1 -
 drivers/media/usb/hdpvr/hdpvr-video.c                   |   4 +-
 drivers/media/usb/msi2500/msi2500.c                     |   1 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h        |   1 -
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                 |  23 +++----
 drivers/media/usb/pwc/pwc-if.c                          |   1 -
 drivers/media/usb/s2255/s2255drv.c                      |   9 +--
 drivers/media/usb/stk1160/stk1160-video.c               |   4 +-
 drivers/media/usb/stkwebcam/stk-webcam.c                |   4 +-
 drivers/media/usb/tm6000/tm6000-dvb.c                   |   4 +-
 drivers/media/usb/tm6000/tm6000-video.c                 |   1 -
 drivers/media/usb/usbvision/usbvision-core.c            |   5 +-
 drivers/media/usb/zr364xx/zr364xx.c                     |   4 +-
 drivers/media/v4l2-core/v4l2-common.c                   |   2 +-
 drivers/staging/media/cec/cec-core.c                    |   3 +-
 46 files changed, 217 insertions(+), 233 deletions(-)
