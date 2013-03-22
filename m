Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3226 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab3CVKf1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 06:35:27 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr9.xs4all.nl (8.13.8/8.13.8) with ESMTP id r2MAZI6W002152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 11:35:24 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
Received: from durdane.localnet (64-103-25-233.cisco.com [64.103.25.233])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 6D0C311E0151
	for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 11:35:18 +0100 (CET)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.10] v4l2: make arg of write-only ioctls const
Date: Fri, 22 Mar 2013 11:35:17 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303221135.17245.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This is the second and last phase of ensuring that the arguments of write-only
ioctls in V4L2 are const. The first phase was 4-5 months ago and added const
to s_crop, s_modulator, s_audio, s_audout, (un)subscribe_event, s_freq_hw_seek,
s_jpegcomp and s_fbuf.

This second phase adds const to s_frequency, s_tuner, s_std and s_register.
Actually, for s_std it doesn't add const but changes it to pass the std by
value which is more consistent in that particular case.

As a result drivers will be aware when they are implementing write-only ioctls
(and I saw a few drivers attempting to return data back to the user), and the
v4l2 core will know that drivers won't change the argument of a write-only
ioctls which simplifies the core debug code.

The changes have been compile-tested with the linux-media daily build but
I may have missed some more exotic architectures.

Ideally I would like to have this merged fairly early on so we have enough
time to shake out any remaining compile problems.

This pull request is identical to:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg59774.html and
http://www.mail-archive.com/linux-media@vger.kernel.org/msg59886.html with
this final change for radio-keene.c:

http://www.spinics.net/lists/linux-media/msg61339.html

Note that I will be making more pull requests based on top of this pull
request since you will get merge conflicts otherwise.

Regards,

        Hans

The following changes since commit d7104bffcfb7a1a7f1dbb1274443e339588c2cb3:

  [media] MAINTAINERS: add drivers/media/tuners/it913x* (2013-03-21 19:06:43 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git const2

for you to fetch changes up to 0b03adbbaef3e6ec164ba7647dd1f53f48ef76c5:

  v4l2-ioctl: add precision when printing names. (2013-03-22 09:31:28 +0100)

----------------------------------------------------------------
Hans Verkuil (6):
      v4l2: add const to argument of write-only s_frequency ioctl.
      v4l2: add const to argument of write-only s_tuner ioctl.
      v4l2: pass std by value to the write-only s_std ioctl.
      v4l2: add const to argument of write-only s_register ioctl.
      v4l2-ioctl: simplify debug code.
      v4l2-ioctl: add precision when printing names.

 drivers/media/common/saa7146/saa7146_video.c     |    4 +--
 drivers/media/dvb-frontends/au8522_decoder.c     |    2 +-
 drivers/media/i2c/ad9389b.c                      |    2 +-
 drivers/media/i2c/adv7183.c                      |    2 +-
 drivers/media/i2c/adv7604.c                      |    2 +-
 drivers/media/i2c/ak881x.c                       |    2 +-
 drivers/media/i2c/cs5345.c                       |    2 +-
 drivers/media/i2c/cx25840/cx25840-core.c         |    6 ++--
 drivers/media/i2c/m52790.c                       |    2 +-
 drivers/media/i2c/msp3400-driver.c               |    4 +--
 drivers/media/i2c/mt9m032.c                      |    2 +-
 drivers/media/i2c/mt9v011.c                      |    2 +-
 drivers/media/i2c/ov7670.c                       |    2 +-
 drivers/media/i2c/saa6588.c                      |    2 +-
 drivers/media/i2c/saa7115.c                      |    2 +-
 drivers/media/i2c/saa7127.c                      |    2 +-
 drivers/media/i2c/saa717x.c                      |    4 +--
 drivers/media/i2c/soc_camera/mt9m001.c           |    2 +-
 drivers/media/i2c/soc_camera/mt9m111.c           |    2 +-
 drivers/media/i2c/soc_camera/mt9t031.c           |    2 +-
 drivers/media/i2c/soc_camera/mt9t112.c           |    2 +-
 drivers/media/i2c/soc_camera/mt9v022.c           |    2 +-
 drivers/media/i2c/soc_camera/ov2640.c            |    2 +-
 drivers/media/i2c/soc_camera/ov5642.c            |    2 +-
 drivers/media/i2c/soc_camera/ov6650.c            |    2 +-
 drivers/media/i2c/soc_camera/ov772x.c            |    2 +-
 drivers/media/i2c/soc_camera/ov9640.c            |    2 +-
 drivers/media/i2c/soc_camera/ov9740.c            |    2 +-
 drivers/media/i2c/soc_camera/rj54n1cb0c.c        |    2 +-
 drivers/media/i2c/soc_camera/tw9910.c            |    2 +-
 drivers/media/i2c/tda9840.c                      |    2 +-
 drivers/media/i2c/tvaudio.c                      |    4 +--
 drivers/media/i2c/tvp5150.c                      |    2 +-
 drivers/media/i2c/tvp7002.c                      |    2 +-
 drivers/media/i2c/upd64031a.c                    |    4 +--
 drivers/media/i2c/upd64083.c                     |    2 +-
 drivers/media/i2c/vp27smpx.c                     |    2 +-
 drivers/media/i2c/vs6624.c                       |    2 +-
 drivers/media/i2c/wm8775.c                       |    2 +-
 drivers/media/parport/pms.c                      |    4 +--
 drivers/media/pci/bt8xx/bttv-driver.c            |   36 +++++++++++++-----------
 drivers/media/pci/cx18/cx18-av-core.c            |    6 ++--
 drivers/media/pci/cx18/cx18-driver.c             |    2 +-
 drivers/media/pci/cx18/cx18-ioctl.c              |   50 ++++++++++++++-------------------
 drivers/media/pci/cx18/cx18-ioctl.h              |    4 +--
 drivers/media/pci/cx23885/cx23885-417.c          |   10 +++----
 drivers/media/pci/cx23885/cx23885-ioctl.c        |    9 ++----
 drivers/media/pci/cx23885/cx23885-ioctl.h        |    2 +-
 drivers/media/pci/cx23885/cx23885-video.c        |   14 +++++-----
 drivers/media/pci/cx23885/cx23885.h              |    2 +-
 drivers/media/pci/cx23885/cx23888-ir.c           |    2 +-
 drivers/media/pci/cx25821/cx25821-video.c        |   14 +++++-----
 drivers/media/pci/cx25821/cx25821-video.h        |   10 +++----
 drivers/media/pci/cx88/cx88-blackbird.c          |    8 +++---
 drivers/media/pci/cx88/cx88-video.c              |   25 ++++++++---------
 drivers/media/pci/cx88/cx88.h                    |    2 +-
 drivers/media/pci/ivtv/ivtv-driver.c             |    4 +--
 drivers/media/pci/ivtv/ivtv-firmware.c           |    4 +--
 drivers/media/pci/ivtv/ivtv-gpio.c               |    2 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c              |   73 ++++++++++++++++++++++++------------------------
 drivers/media/pci/ivtv/ivtv-ioctl.h              |    6 ++--
 drivers/media/pci/saa7134/saa7134-empress.c      |    2 +-
 drivers/media/pci/saa7134/saa7134-video.c        |   22 +++++++--------
 drivers/media/pci/saa7134/saa7134.h              |    2 +-
 drivers/media/pci/saa7146/mxb.c                  |    9 +++---
 drivers/media/pci/saa7164/saa7164-encoder.c      |   14 +++++-----
 drivers/media/pci/saa7164/saa7164-vbi.c          |   12 ++++----
 drivers/media/pci/sta2x11/sta2x11_vip.c          |   18 ++++++------
 drivers/media/pci/ttpci/av7110_v4l.c             |    4 +--
 drivers/media/pci/zoran/zoran_driver.c           |    4 +--
 drivers/media/platform/blackfin/bfin_capture.c   |    8 +++---
 drivers/media/platform/davinci/vpbe.c            |    8 +++---
 drivers/media/platform/davinci/vpbe_display.c    |    4 +--
 drivers/media/platform/davinci/vpfe_capture.c    |   12 ++++----
 drivers/media/platform/davinci/vpif_capture.c    |    9 +++---
 drivers/media/platform/davinci/vpif_display.c    |   13 +++++----
 drivers/media/platform/fsl-viu.c                 |    6 ++--
 drivers/media/platform/marvell-ccic/mcam-core.c  |    4 +--
 drivers/media/platform/s5p-tv/mixer_video.c      |    4 +--
 drivers/media/platform/sh_vou.c                  |   14 +++++-----
 drivers/media/platform/soc_camera/soc_camera.c   |    6 ++--
 drivers/media/platform/timblogiw.c               |    6 ++--
 drivers/media/platform/via-camera.c              |    2 +-
 drivers/media/platform/vino.c                    |   10 +++----
 drivers/media/radio/dsbr100.c                    |    4 +--
 drivers/media/radio/radio-cadet.c                |   48 ++++++++++++++++----------------
 drivers/media/radio/radio-isa.c                  |   11 ++++----
 drivers/media/radio/radio-keene.c                |    8 +++---
 drivers/media/radio/radio-ma901.c                |    4 +--
 drivers/media/radio/radio-miropcm20.c            |   12 ++++----
 drivers/media/radio/radio-mr800.c                |    4 +--
 drivers/media/radio/radio-sf16fmi.c              |    4 +--
 drivers/media/radio/radio-si4713.c               |    2 +-
 drivers/media/radio/radio-tea5764.c              |    4 +--
 drivers/media/radio/radio-tea5777.c              |    9 +++---
 drivers/media/radio/radio-timb.c                 |    4 +--
 drivers/media/radio/radio-wl1273.c               |    4 +--
 drivers/media/radio/si470x/radio-si470x-common.c |    4 +--
 drivers/media/radio/si4713-i2c.c                 |    5 ++--
 drivers/media/radio/tef6862.c                    |    4 +--
 drivers/media/radio/wl128x/fmdrv_v4l2.c          |    8 ++----
 drivers/media/usb/au0828/au0828-video.c          |   12 ++++----
 drivers/media/usb/cx231xx/cx231xx-417.c          |    4 +--
 drivers/media/usb/cx231xx/cx231xx-video.c        |   19 +++++++------
 drivers/media/usb/cx231xx/cx231xx.h              |    6 ++--
 drivers/media/usb/em28xx/em28xx-video.c          |   21 +++++++-------
 drivers/media/usb/gspca/gspca.c                  |    2 +-
 drivers/media/usb/gspca/gspca.h                  |    8 ++++--
 drivers/media/usb/gspca/pac7302.c                |    2 +-
 drivers/media/usb/gspca/sn9c20x.c                |    2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c            |    4 +--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c          |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h          |    2 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c         |   10 +++----
 drivers/media/usb/s2255/s2255drv.c               |    8 +++---
 drivers/media/usb/stk1160/stk1160-v4l.c          |    6 ++--
 drivers/media/usb/tlg2300/pd-radio.c             |    4 +--
 drivers/media/usb/tlg2300/pd-video.c             |   15 +++++-----
 drivers/media/usb/tm6000/tm6000-video.c          |   16 ++++-------
 drivers/media/usb/usbvision/usbvision-video.c    |   10 +++----
 drivers/media/v4l2-core/tuner-core.c             |    4 +--
 drivers/media/v4l2-core/v4l2-ioctl.c             |   85 +++++++++++++++++++++++++++-----------------------------
 drivers/staging/media/davinci_vpfe/vpfe_video.c  |    6 ++--
 drivers/staging/media/dt3155v4l/dt3155v4l.c      |    4 +--
 drivers/staging/media/go7007/go7007-v4l2.c       |   20 ++++++-------
 drivers/staging/media/solo6x10/v4l2-enc.c        |    2 +-
 drivers/staging/media/solo6x10/v4l2.c            |    2 +-
 include/media/davinci/vpbe.h                     |    2 +-
 include/media/v4l2-ioctl.h                       |    8 +++---
 include/media/v4l2-subdev.h                      |    6 ++--
 sound/i2c/other/tea575x-tuner.c                  |    6 ++--
 131 files changed, 499 insertions(+), 512 deletions(-)
