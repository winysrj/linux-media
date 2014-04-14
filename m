Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4071 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaDNKkr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 06:40:47 -0400
Received: from tschai.lan (173-38-208-169.cisco.com [173.38.208.169])
	(authenticated bits=0)
	by smtp-vbr5.xs4all.nl (8.13.8/8.13.8) with ESMTP id s3EAeiWx054026
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:40:46 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id 750492A0410
	for <linux-media@vger.kernel.org>; Mon, 14 Apr 2014 12:40:42 +0200 (CEST)
Message-ID: <534BBB2A.2080206@xs4all.nl>
Date: Mon, 14 Apr 2014 12:40:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.16] Various fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Various fixes, most notable are the vb2 fixes, saa7134 vb2 conversion and davinci
improvements.

This pull request supersedes https://patchwork.linuxtv.org/patch/23123/ and 
https://patchwork.linuxtv.org/patch/23596/. The saa7134 vb2 conversion patches
had to be rebased on top of the vb2 fixes, so I combined it all into one pull
request, ensuring a correct patch sequence.

Regards,

	Hans

The following changes since commit a83b93a7480441a47856dc9104bea970e84cda87:

  [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 08:02:16 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.16a

for you to fetch changes up to 2500543b19714d169aae8930cf4f719e2343c819:

  saa7134: convert to vb2 (2014-04-14 12:35:11 +0200)

----------------------------------------------------------------
Daniel Glöckner (1):
      bttv: Add support for PCI-8604PW

Hans Verkuil (22):
      v4l2-subdev.h: fix sparse error with v4l2_subdev_notify
      videobuf2-core: fix sparse errors.
      v4l2-common.h: remove __user annotation in struct v4l2_edid
      v4l2-ioctl.c: fix sparse __user-related warnings
      v4l2-dv-timings.h: add CEA-861-F 4K timings
      v4l2-dv-timings.c: add the new 4K timings to the list.
      vb2: stop_streaming should return void
      vb2: fix handling of data_offset and v4l2_plane.reserved[]
      vb2: if bytesused is 0, then fill with output buffer length
      vb2: use correct prefix
      vb2: move __qbuf_mmap before __qbuf_userptr
      vb2: set timestamp when using write()
      vb2: reject output buffers with V4L2_FIELD_ALTERNATE
      vb2: simplify a confusing condition.
      vb2: add vb2_fileio_is_active and check it more often
      vb2: allow read/write as long as the format is single planar
      vb2: start messages with a lower-case for consistency.
      DocBook media: update bytesused field description
      v4l2-pci-skeleton.c: fix alternate field handling.
      vb2: add thread support
      vb2: Add videobuf2-dvb support
      saa7134: convert to vb2

Ismael Luceno (1):
      gspca_gl860: Clean up idxdata structs

Lad, Prabhakar (4):
      media: davinci: vpbe: use v4l2_fh for priority handling
      media: davinci: vpfe: use v4l2_fh for priority handling
      staging: media: davinci: vpfe: use v4l2_fh for priority handling
      staging: media: davinci: vpfe: release buffers in case start_streaming call back fails

Martin Bugge (2):
      adv7842: update RGB quantization range on HDMI/DVI-D mode irq.
      adv7842: Disable access to EDID DDC lines before chip power up.

Mike Sampson (1):
      next-20140324 drivers/staging/media/sn9c102/sn9c102_hv7131r.c fix style warnings flagged by checkpatch.pl.

ileana@telecom-paristech.fr (1):
      staging: omap24xx: fix coding style

 Documentation/DocBook/media/v4l/io.xml                   |  13 +-
 Documentation/video4linux/v4l2-pci-skeleton.c            |  42 +++--
 drivers/media/i2c/adv7842.c                              |  10 +-
 drivers/media/pci/bt8xx/bttv-cards.c                     | 110 +++++++++++
 drivers/media/pci/bt8xx/bttv.h                           |   1 +
 drivers/media/pci/saa7134/Kconfig                        |   4 +-
 drivers/media/pci/saa7134/saa7134-alsa.c                 | 106 +++++++++--
 drivers/media/pci/saa7134/saa7134-core.c                 | 107 ++++++-----
 drivers/media/pci/saa7134/saa7134-dvb.c                  |  43 +++--
 drivers/media/pci/saa7134/saa7134-empress.c              | 179 +++++++-----------
 drivers/media/pci/saa7134/saa7134-ts.c                   | 184 ++++++++++--------
 drivers/media/pci/saa7134/saa7134-vbi.c                  | 170 ++++++++---------
 drivers/media/pci/saa7134/saa7134-video.c                | 658 +++++++++++++++++++++++----------------------------------------
 drivers/media/pci/saa7134/saa7134.h                      | 106 +++++------
 drivers/media/pci/sta2x11/sta2x11_vip.c                  |   3 +-
 drivers/media/platform/blackfin/bfin_capture.c           |   6 +-
 drivers/media/platform/coda.c                            |   4 +-
 drivers/media/platform/davinci/vpbe_display.c            |  45 +----
 drivers/media/platform/davinci/vpfe_capture.c            |  13 +-
 drivers/media/platform/davinci/vpif_capture.c            |   6 +-
 drivers/media/platform/davinci/vpif_display.c            |   6 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c              |   4 +-
 drivers/media/platform/exynos4-is/fimc-capture.c         |   6 +-
 drivers/media/platform/exynos4-is/fimc-lite.c            |   6 +-
 drivers/media/platform/exynos4-is/fimc-m2m.c             |   3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c          |   7 +-
 drivers/media/platform/mem2mem_testdev.c                 |   5 +-
 drivers/media/platform/s3c-camif/camif-capture.c         |   4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c              |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c             |   3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c             |   3 +-
 drivers/media/platform/s5p-tv/mixer_video.c              |   3 +-
 drivers/media/platform/soc_camera/atmel-isi.c            |   6 +-
 drivers/media/platform/soc_camera/mx2_camera.c           |   4 +-
 drivers/media/platform/soc_camera/mx3_camera.c           |   4 +-
 drivers/media/platform/soc_camera/rcar_vin.c             |   4 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c |   4 +-
 drivers/media/platform/vivi.c                            |   3 +-
 drivers/media/platform/vsp1/vsp1_video.c                 |   4 +-
 drivers/media/usb/em28xx/em28xx-v4l.h                    |   2 +-
 drivers/media/usb/em28xx/em28xx-video.c                  |   8 +-
 drivers/media/usb/gspca/gl860/gl860-mi2020.c             | 464 ++++++++++++++++++++++++++-------------------
 drivers/media/usb/pwc/pwc-if.c                           |   7 +-
 drivers/media/usb/s2255/s2255drv.c                       |   5 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                  |   4 +-
 drivers/media/usb/usbtv/usbtv-video.c                    |   9 +-
 drivers/media/v4l2-core/Kconfig                          |   4 +
 drivers/media/v4l2-core/Makefile                         |   1 +
 drivers/media/v4l2-core/v4l2-dv-timings.c                |  11 ++
 drivers/media/v4l2-core/v4l2-ioctl.c                     |  10 +-
 drivers/media/v4l2-core/videobuf2-core.c                 | 693 ++++++++++++++++++++++++++++++++++++++++++++++---------------------
 drivers/media/v4l2-core/videobuf2-dvb.c                  | 336 +++++++++++++++++++++++++++++++++
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h     |   2 -
 drivers/staging/media/davinci_vpfe/vpfe_video.c          |  23 ++-
 drivers/staging/media/davinci_vpfe/vpfe_video.h          |   2 -
 drivers/staging/media/dt3155v4l/dt3155v4l.c              |   3 +-
 drivers/staging/media/go7007/go7007-v4l2.c               |   3 +-
 drivers/staging/media/msi3101/sdr-msi3101.c              |   7 +-
 drivers/staging/media/omap24xx/tcm825x.h                 |   4 +-
 drivers/staging/media/rtl2832u_sdr/rtl2832_sdr.c         |   7 +-
 drivers/staging/media/sn9c102/sn9c102_hv7131r.c          |  23 +--
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c       |   3 +-
 drivers/staging/media/solo6x10/solo6x10-v4l2.c           |   3 +-
 include/media/davinci/vpbe_display.h                     |   6 +-
 include/media/davinci/vpfe_capture.h                     |   6 +-
 include/media/v4l2-device.h                              |   8 +
 include/media/v4l2-subdev.h                              |   5 -
 include/media/videobuf2-core.h                           |  51 ++++-
 include/media/videobuf2-dvb.h                            |  58 ++++++
 include/uapi/linux/v4l2-common.h                         |   2 +-
 include/uapi/linux/v4l2-dv-timings.h                     |  70 +++++++
 71 files changed, 2262 insertions(+), 1471 deletions(-)
 create mode 100644 drivers/media/v4l2-core/videobuf2-dvb.c
 create mode 100644 include/media/videobuf2-dvb.h
