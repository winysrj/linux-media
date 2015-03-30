Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:59288 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752952AbbC3RCv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2015 13:02:51 -0400
Received: from [192.168.1.106] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 8B36D2A0099
	for <linux-media@vger.kernel.org>; Mon, 30 Mar 2015 19:02:24 +0200 (CEST)
Message-ID: <551981B6.2090401@xs4all.nl>
Date: Mon, 30 Mar 2015 19:02:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v4.1 v2] Various improvements
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Various fixes, more 'embed video_device' patches and change bytesperline in
v4l2_plane_pix_format to __u32 instead of __u16 (we discussed that in San Jose).

This replaces my previous pull request and adds the cx18 'embed video_device'
since I have now tested that patch, and it updates the 'ivtv: replace crop by selection'
by supporting TGT_CROP_DEFAULTS and BOUNDS as well. Otherwise CROPCAP would be
incomplete.

Regards,

	Hans

The following changes since commit 8a56b6b5fd6ff92b7e27d870b803b11b751660c2:

  [media] v4l2-subdev: remove enum_framesizes/intervals (2015-03-23 12:02:41 -0700)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.1o

for you to fetch changes up to 47eff5d13cc7c374cafd3c88622859b77e8d113c:

  cx18: embed video_device (2015-03-30 18:59:38 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      usbvision: fix leak of usb_dev on failure paths in usbvision_probe()

Hans Verkuil (18):
      ivtv: embed video_device
      vim2m: embed video_device
      saa7146: embed video_device
      radio-bcm2048: embed video_device
      dt3155v4l: embed video_device
      meye: embed video_device
      m2m-deinterlace: embed video_device
      wl128x: embed video_device
      gadget/uvc: embed video_device
      hdpvr: embed video_device
      tm6000: embed video_device
      usbvision: embed video_device
      cx231xx: embed video_device
      v4l2_plane_pix_format: use __u32 bytesperline instead of __u16
      sta2x11: embed video_device
      ivtv: replace crop by selection
      ivtv: disable fbuf support if ivtvfb isn't loaded
      cx18: embed video_device

Lad, Prabhakar (2):
      media: davinci: vpfe_capture: embed video_device
      media: sh_vou: embed video_device

 Documentation/DocBook/media/v4l/pixfmt.xml    |   4 +-
 drivers/media/common/saa7146/saa7146_fops.c   |  19 ++-----
 drivers/media/pci/cx18/cx18-alsa-main.c       |   2 +-
 drivers/media/pci/cx18/cx18-driver.h          |   2 +-
 drivers/media/pci/cx18/cx18-fileops.c         |   2 +-
 drivers/media/pci/cx18/cx18-ioctl.c           |   2 +-
 drivers/media/pci/cx18/cx18-streams.c         |  62 ++++++++--------------
 drivers/media/pci/cx18/cx18-streams.h         |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c       |   2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c        |   2 +-
 drivers/media/pci/ivtv/ivtv-driver.c          |   4 +-
 drivers/media/pci/ivtv/ivtv-driver.h          |   2 +-
 drivers/media/pci/ivtv/ivtv-fileops.c         |   2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c           | 159 ++++++++++++++++++++++++++++++++++---------------------
 drivers/media/pci/ivtv/ivtv-irq.c             |   8 +--
 drivers/media/pci/ivtv/ivtv-streams.c         | 113 +++++++++++++++++----------------------
 drivers/media/pci/ivtv/ivtv-streams.h         |   2 +-
 drivers/media/pci/meye/meye.c                 |  21 +++-----
 drivers/media/pci/meye/meye.h                 |   2 +-
 drivers/media/pci/saa7146/hexium_gemini.c     |   2 +-
 drivers/media/pci/saa7146/hexium_orion.c      |   2 +-
 drivers/media/pci/saa7146/mxb.c               |   4 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c       |  35 +++++-------
 drivers/media/pci/ttpci/av7110.h              |   4 +-
 drivers/media/pci/ttpci/budget-av.c           |   2 +-
 drivers/media/platform/davinci/vpfe_capture.c |  26 +++------
 drivers/media/platform/m2m-deinterlace.c      |  21 +++-----
 drivers/media/platform/s5p-tv/mixer_video.c   |   2 +-
 drivers/media/platform/sh_vou.c               |  21 +++-----
 drivers/media/platform/vim2m.c                |  23 +++-----
 drivers/media/radio/wl128x/fmdrv_v4l2.c       |  28 ++++------
 drivers/media/usb/cx231xx/cx231xx-417.c       |  33 ++++--------
 drivers/media/usb/cx231xx/cx231xx-cards.c     |   6 +--
 drivers/media/usb/cx231xx/cx231xx-video.c     |  94 +++++++++++---------------------
 drivers/media/usb/cx231xx/cx231xx.h           |   8 +--
 drivers/media/usb/hdpvr/hdpvr-core.c          |  10 ++--
 drivers/media/usb/hdpvr/hdpvr-video.c         |  19 +++----
 drivers/media/usb/hdpvr/hdpvr.h               |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |  59 ++++++---------------
 drivers/media/usb/tm6000/tm6000.h             |   4 +-
 drivers/media/usb/usbvision/usbvision-video.c |  94 +++++++++++++++-----------------
 drivers/media/usb/usbvision/usbvision.h       |   4 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c |  33 ++++--------
 drivers/staging/media/dt3155v4l/dt3155v4l.c   |  30 ++++-------
 drivers/staging/media/dt3155v4l/dt3155v4l.h   |   4 +-
 drivers/usb/gadget/function/f_uvc.c           |  44 +++++++--------
 drivers/usb/gadget/function/uvc.h             |   2 +-
 include/media/davinci/vpfe_capture.h          |   2 +-
 include/media/saa7146_vv.h                    |   4 +-
 include/uapi/linux/videodev2.h                |   4 +-
 50 files changed, 424 insertions(+), 614 deletions(-)
