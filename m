Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:44514 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754114AbbCIQeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Mar 2015 12:34:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 00/19] embed video_device struct
Date: Mon,  9 Mar 2015 17:33:54 +0100
Message-Id: <1425918853-12371-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series converts 19 drivers so that they embed struct video_device
in their main struct. That simplifies the error handling since there is no
longer any need to call video_device_alloc or video_device_release.

Eventually (13 drivers still to go) all drivers should do this and we can
get rid of the ugly video_device_alloc/release/release_empty functions.

Regards,

	Hans

Hans Verkuil (19):
  ivtv: embed video_device
  vim2m: embed video_device
  saa7146: embed video_device
  radio-bcm2048: embed video_device
  dt3155v4l: embed video_device
  cx88: embed video_device
  meye: embed video_device
  bttv: embed video_device
  cx18: embed video_device
  sta2x11: embed video_device
  m2m-deinterlace: embed video_device
  em28xx: embed video_device
  wl128x: embed video_device
  gadget/uvc: embed video_device
  hdpvr: embed video_device
  tm6000: embed video_device
  uvc: embed video_device
  usbvision: embed video_device
  cx231xx: embed video_device

 drivers/media/common/saa7146/saa7146_fops.c   |  19 +---
 drivers/media/pci/bt8xx/bttv-driver.c         |  73 +++++-----------
 drivers/media/pci/bt8xx/bttvp.h               |   6 +-
 drivers/media/pci/cx18/cx18-alsa-main.c       |   2 +-
 drivers/media/pci/cx18/cx18-driver.h          |   2 +-
 drivers/media/pci/cx18/cx18-fileops.c         |   2 +-
 drivers/media/pci/cx18/cx18-ioctl.c           |   2 +-
 drivers/media/pci/cx18/cx18-streams.c         |  62 +++++---------
 drivers/media/pci/cx18/cx18-streams.h         |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c       |  22 ++---
 drivers/media/pci/cx88/cx88-core.c            |  18 ++--
 drivers/media/pci/cx88/cx88-video.c           |  61 +++++--------
 drivers/media/pci/cx88/cx88.h                 |  17 ++--
 drivers/media/pci/ivtv/ivtv-alsa-main.c       |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c        |   2 +-
 drivers/media/pci/ivtv/ivtv-driver.c          |   4 +-
 drivers/media/pci/ivtv/ivtv-driver.h          |   2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c         |   2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c           |   8 +-
 drivers/media/pci/ivtv/ivtv-irq.c             |   8 +-
 drivers/media/pci/ivtv/ivtv-streams.c         | 107 ++++++++++-------------
 drivers/media/pci/ivtv/ivtv-streams.h         |   2 +-
 drivers/media/pci/meye/meye.c                 |  19 ++--
 drivers/media/pci/meye/meye.h                 |   2 +-
 drivers/media/pci/saa7146/hexium_gemini.c     |   2 +-
 drivers/media/pci/saa7146/hexium_orion.c      |   2 +-
 drivers/media/pci/saa7146/mxb.c               |   4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c       |  34 +++-----
 drivers/media/pci/ttpci/av7110.h              |   4 +-
 drivers/media/pci/ttpci/budget-av.c           |   2 +-
 drivers/media/platform/m2m-deinterlace.c      |  21 ++---
 drivers/media/platform/vim2m.c                |  23 ++---
 drivers/media/radio/wl128x/fmdrv_v4l2.c       |  28 +++---
 drivers/media/usb/cx231xx/cx231xx-417.c       |  33 +++----
 drivers/media/usb/cx231xx/cx231xx-cards.c     |   6 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |  94 +++++++-------------
 drivers/media/usb/cx231xx/cx231xx.h           |   8 +-
 drivers/media/usb/em28xx/em28xx-video.c       | 119 +++++++++++---------------
 drivers/media/usb/em28xx/em28xx.h             |   6 +-
 drivers/media/usb/hdpvr/hdpvr-core.c          |  10 +--
 drivers/media/usb/hdpvr/hdpvr-video.c         |  19 ++--
 drivers/media/usb/hdpvr/hdpvr.h               |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |  59 ++++---------
 drivers/media/usb/tm6000/tm6000.h             |   4 +-
 drivers/media/usb/usbvision/usbvision-video.c |  70 ++++++---------
 drivers/media/usb/usbvision/usbvision.h       |   4 +-
 drivers/media/usb/uvc/uvc_driver.c            |  22 +----
 drivers/media/usb/uvc/uvc_v4l2.c              |   2 +-
 drivers/media/usb/uvc/uvcvideo.h              |   2 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c |  33 ++-----
 drivers/staging/media/dt3155v4l/dt3155v4l.c   |  30 +++----
 drivers/staging/media/dt3155v4l/dt3155v4l.h   |   4 +-
 drivers/usb/gadget/function/f_uvc.c           |  44 ++++------
 drivers/usb/gadget/function/uvc.h             |   2 +-
 include/media/saa7146_vv.h                    |   4 +-
 55 files changed, 419 insertions(+), 724 deletions(-)

-- 
2.1.4

