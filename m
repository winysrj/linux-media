Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.zeus03.de ([194.117.254.33]:56177 "EHLO mail.zeus03.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbcHKVLN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 17:11:13 -0400
From: Wolfram Sang <wsa-dev@sang-engineering.com>
To: linux-usb@vger.kernel.org
Cc: Wolfram Sang <wsa-dev@sang-engineering.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 00/28] media: don't print error when allocating urb fails
Date: Thu, 11 Aug 2016 23:03:36 +0200
Message-Id: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This per-subsystem series is part of a tree wide cleanup. usb_alloc_urb() uses
kmalloc which already prints enough information on failure. So, let's simply
remove those "allocation failed" messages from drivers like we did already for
other -ENOMEM cases. gkh acked this approach when we talked about it at LCJ in
Tokyo a few weeks ago.


Wolfram Sang (28):
  media: dvb-frontends: rtl2832_sdr: don't print error when allocating
    urb fails
  media: radio: si470x: radio-si470x-usb: don't print error when
    allocating urb fails
  media: rc: imon: don't print error when allocating urb fails
  media: rc: redrat3: don't print error when allocating urb fails
  media: usb: airspy: airspy: don't print error when allocating urb
    fails
  media: usb: as102: as102_usb_drv: don't print error when allocating
    urb fails
  media: usb: au0828: au0828-video: don't print error when allocating
    urb fails
  media: usb: cpia2: cpia2_usb: don't print error when allocating urb
    fails
  media: usb: cx231xx: cx231xx-audio: don't print error when allocating
    urb fails
  media: usb: cx231xx: cx231xx-core: don't print error when allocating
    urb fails
  media: usb: cx231xx: cx231xx-vbi: don't print error when allocating
    urb fails
  media: usb: dvb-usb: dib0700_core: don't print error when allocating
    urb fails
  media: usb: em28xx: em28xx-audio: don't print error when allocating
    urb fails
  media: usb: em28xx: em28xx-core: don't print error when allocating urb
    fails
  media: usb: gspca: benq: don't print error when allocating urb fails
  media: usb: gspca: gspca: don't print error when allocating urb fails
  media: usb: gspca: konica: don't print error when allocating urb fails
  media: usb: hackrf: hackrf: don't print error when allocating urb
    fails
  media: usb: hdpvr: hdpvr-video: don't print error when allocating urb
    fails
  media: usb: msi2500: msi2500: don't print error when allocating urb
    fails
  media: usb: pwc: pwc-if: don't print error when allocating urb fails
  media: usb: s2255: s2255drv: don't print error when allocating urb
    fails
  media: usb: stk1160: stk1160-video: don't print error when allocating
    urb fails
  media: usb: stkwebcam: stk-webcam: don't print error when allocating
    urb fails
  media: usb: tm6000: tm6000-dvb: don't print error when allocating urb
    fails
  media: usb: tm6000: tm6000-video: don't print error when allocating
    urb fails
  media: usb: usbvision: usbvision-core: don't print error when
    allocating urb fails
  media: usb: zr364xx: zr364xx: don't print error when allocating urb
    fails

 drivers/media/dvb-frontends/rtl2832_sdr.c     |  1 -
 drivers/media/radio/si470x/radio-si470x-usb.c |  1 -
 drivers/media/rc/imon.c                       | 13 +++----------
 drivers/media/rc/redrat3.c                    |  4 +---
 drivers/media/usb/airspy/airspy.c             |  1 -
 drivers/media/usb/as102/as102_usb_drv.c       |  2 --
 drivers/media/usb/au0828/au0828-video.c       |  1 -
 drivers/media/usb/cpia2/cpia2_usb.c           |  1 -
 drivers/media/usb/cx231xx/cx231xx-audio.c     |  2 --
 drivers/media/usb/cx231xx/cx231xx-core.c      |  4 ----
 drivers/media/usb/cx231xx/cx231xx-vbi.c       |  2 --
 drivers/media/usb/dvb-usb/dib0700_core.c      |  4 +---
 drivers/media/usb/em28xx/em28xx-audio.c       |  1 -
 drivers/media/usb/em28xx/em28xx-core.c        |  1 -
 drivers/media/usb/gspca/benq.c                |  4 +---
 drivers/media/usb/gspca/gspca.c               |  4 +---
 drivers/media/usb/gspca/konica.c              |  4 +---
 drivers/media/usb/hackrf/hackrf.c             |  1 -
 drivers/media/usb/hdpvr/hdpvr-video.c         |  4 +---
 drivers/media/usb/msi2500/msi2500.c           |  1 -
 drivers/media/usb/pwc/pwc-if.c                |  1 -
 drivers/media/usb/s2255/s2255drv.c            |  9 ++-------
 drivers/media/usb/stk1160/stk1160-video.c     |  4 +---
 drivers/media/usb/stkwebcam/stk-webcam.c      |  4 +---
 drivers/media/usb/tm6000/tm6000-dvb.c         |  4 +---
 drivers/media/usb/tm6000/tm6000-video.c       |  1 -
 drivers/media/usb/usbvision/usbvision-core.c  |  5 +----
 drivers/media/usb/zr364xx/zr364xx.c           |  4 +---
 28 files changed, 16 insertions(+), 72 deletions(-)

-- 
2.8.1

