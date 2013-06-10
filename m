Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1976 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3FJJ72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jun 2013 05:59:28 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr10.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5A9xF8e034915
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 10 Jun 2013 11:59:17 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 4C9BA35E004A
	for <linux-media@vger.kernel.org>; Mon, 10 Jun 2013 11:59:15 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates for 3.11
Date: Mon, 10 Jun 2013 11:59:14 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306101159.14244.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Besides various fixes and two new drivers (ths8200, ML86V7667) this merges
also some long patch series of mine:

Control framework conversions:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg62772.html

QUERYSTD fixes (particularly in the case of 'no signal'):
http://www.spinics.net/lists/linux-media/msg64131.html

DBG_G_CHIP_IDENT removal:
http://www.spinics.net/lists/linux-media/msg64081.html

Note: patches 7, 13, 20-23, 25 and 36 are kept back. There is a pending cx88
fix for 3.10 (http://git.linuxtv.org/media_tree.git/commit/609c4c12af79b1ba5fd2d31727a95dd3a319c0ae)
that conflicts with this patch series, so once that fix is merged back from
3.10 I can finalize this patch series.

Removal of current_norm:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg62914.html

Note: patch 5 was dropped. It was 1) broken, and 2) not related to current_norm
anyway. A fixed version will be posted separately.

saa7134 cleanup:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg62863.html

Regards,

	Hans

The following changes since commit ab5060cdb8829c0503b7be2b239b52e9a25063b4:

  [media] drxk_hard: Remove most 80-cols checkpatch warnings (2013-06-08 22:11:39 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11

for you to fetch changes up to 569160288c5eddddc9c1a615325ecb5bac265705:

  ths8200: fix two compiler warnings (2013-06-10 11:57:19 +0200)

----------------------------------------------------------------
Antti Palosaari (1):
      radio-keene: add delay in order to settle hardware

Hans Verkuil (101):
      mxl111sf: don't redefine pr_err/info/debug
      hdpvr: fix querystd 'unknown format' return.
      hdpvr: code cleanup
      hdpvr: improve error handling
      ml86v7667: fix the querystd implementation
      radio-keene: set initial frequency.
      v4l2-ioctl: dbg_g/s_register: only match BRIDGE and SUBDEV types.
      v4l2: remove g_chip_ident from bridge drivers where it is easy to do so.
      cx18: remove g_chip_ident support.
      saa7115: add back the dropped 'found' message.
      ivtv: remove g_chip_ident
      cx23885: remove g_chip_ident.
      saa6752hs: drop obsolete g_chip_ident.
      gspca: remove g_chip_ident
      cx231xx: remove g_chip_ident.
      marvell-ccic: remove g_chip_ident.
      tveeprom: remove v4l2-chip-ident.h include.
      au8522_decoder: remove g_chip_ident op.
      radio: remove g_chip_ident op.
      indycam: remove g_chip_ident op.
      soc_camera sensors: remove g_chip_ident op.
      media/i2c: remove g_chip_ident op.
      cx25840: remove the v4l2-chip-ident.h include
      saa7134: check register address in g_register.
      mxb: check register address when reading/writing a register.
      vpbe_display: drop g/s_register ioctls.
      marvell-ccic: check register address.
      au0828: set reg->size.
      cx231xx: the reg->size field wasn't filled in.
      sn9c20x: the reg->size field wasn't filled in.
      pvrusb2: drop g/s_register ioctls.
      media/i2c: fill in missing reg->size fields.
      cx18: fix register range check
      ivtv: fix register range check
      DocBook/media/v4l: update VIDIOC_DBG_ documentation
      v4l2-framework: replace g_chip_ident by g_std in the examples.
      saa7706h: convert to the control framework.
      sr030pc30: convert to the control framework.
      saa6752hs: convert to the control framework.
      radio-tea5764: add support for struct v4l2_device.
      radio-tea5764: embed struct video_device.
      radio-tea5764: convert to the control framework.
      radio-tea5764: audio and input ioctls do not apply to radio devices.
      radio-tea5764: add device_caps support.
      radio-tea5764: add prio and control event support.
      radio-tea5764: some cleanups and clamp frequency when out-of-range
      radio-timb: add device_caps support, remove input/audio ioctls.
      radio-timb: convert to the control framework.
      radio-timb: actually load the requested subdevs
      radio-timb: add control events and prio support.
      tef6862: clamp frequency.
      timblogiw: fix querycap.
      radio-sf16fmi: remove audio/input ioctls.
      radio-sf16fmi: add device_caps support to querycap.
      radio-sf16fmi: clamp frequency.
      radio-sf16fmi: convert to the control framework.
      radio-sf16fmi: add control event and prio support.
      mcam-core: replace current_norm by g_std.
      via-camera: replace current_norm by g_std.
      sh_vou: remove current_norm
      soc_camera: remove use of current_norm.
      fsl-viu: remove current_norm.
      tm6000: remove deprecated current_norm
      saa7164: replace current_norm by g_std
      cx23885: remove use of deprecated current_norm
      usbvision: replace current_norm by g_std.
      saa7134: drop deprecated current_norm.
      dt3155v4l: remove deprecated current_norm
      v4l2: remove deprecated current_norm support completely.
      adv7183: fix querystd
      bt819: fix querystd
      ks0127: fix querystd
      saa7110: fix querystd
      saa7115: fix querystd
      saa7191: fix querystd
      tvp514x: fix querystd
      vpx3220: fix querystd
      bttv: fix querystd
      zoran: remove bogus autodetect mode in set_norm
      v4l2-ioctl: clarify querystd comment.
      DocBook/media/v4l: clarify the QUERYSTD documentation.
      tvp5150: fix s_std support
      media: i2c: ths8200: driver for TI video encoder.
      saa7134: remove radio/type field from saa7134_fh
      saa7134: move the overlay fields from saa7134_fh to saa7134_dev.
      saa7134: move fmt/width/height from saa7134_fh to saa7134_dev
      saa7134: move qos_request from saa7134_fh to saa7134_dev.
      saa7134: move the queue data from saa7134_fh to saa7134_dev.
      saa7134: fix format-related compliance issues.
      saa7134: convert to the control framework.
      saa7134: cleanup radio/video/empress ioctl handling
      saa7134: fix empress format compliance bugs.
      saa7134: remove dev from saa7134_fh, use saa7134_fh for empress node
      saa7134: share resource management between normal and empress nodes.
      saa7134: add support for control events.
      saa7134: use V4L2_IN_ST_NO_SIGNAL instead of NO_SYNC
      saa6752hs: drop compat control code.
      saa6752hs: move to media/i2c
      saa6752hs.h: drop empty header.
      saa7134: drop log_status for radio.
      ths8200: fix two compiler warnings

Ismael Luceno (1):
      solo6x10: reimplement SAA712x setup routine

Lad, Prabhakar (4):
      ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
      media: i2c: ths7303: remove init_enable option from pdata
      media: i2c: ths7303: remove unnecessary function ths7303_setup()
      media: i2c: ths7303: make the pdata as a constant pointer

Vladimir Barinov (2):
      adv7180: add more subdev video ops
      ML86V7667: new video decoder driver

 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml |    3 +-
 Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml  |   15 +-
 Documentation/DocBook/media/v4l/vidioc-querystd.xml        |    3 +-
 Documentation/video4linux/v4l2-framework.txt               |   13 +-
 Documentation/zh_CN/video4linux/v4l2-framework.txt         |   13 +-
 arch/arm/mach-davinci/board-dm365-evm.c                    |    1 -
 drivers/media/common/saa7146/saa7146_video.c               |   23 --
 drivers/media/common/tveeprom.c                            |  142 ++++++------
 drivers/media/dvb-frontends/au8522_decoder.c               |   17 --
 drivers/media/i2c/Kconfig                                  |   32 ++-
 drivers/media/i2c/Makefile                                 |    3 +
 drivers/media/i2c/ad9389b.c                                |   21 +-
 drivers/media/i2c/adv7170.c                                |   13 --
 drivers/media/i2c/adv7175.c                                |    9 -
 drivers/media/i2c/adv7180.c                                |   56 ++++-
 drivers/media/i2c/adv7183.c                                |   38 +--
 drivers/media/i2c/adv7343.c                                |   10 -
 drivers/media/i2c/adv7393.c                                |   10 -
 drivers/media/i2c/adv7604.c                                |   18 --
 drivers/media/i2c/ak881x.c                                 |   35 +--
 drivers/media/i2c/bt819.c                                  |   22 +-
 drivers/media/i2c/bt856.c                                  |    9 -
 drivers/media/i2c/bt866.c                                  |   13 --
 drivers/media/i2c/cs5345.c                                 |   17 --
 drivers/media/i2c/cs53l32a.c                               |   10 -
 drivers/media/i2c/cx25840/cx25840-core.c                   |   64 ++----
 drivers/media/i2c/cx25840/cx25840-core.h                   |   34 ++-
 drivers/media/i2c/ks0127.c                                 |   33 +--
 drivers/media/i2c/m52790.c                                 |   15 --
 drivers/media/i2c/ml86v7667.c                              |  431 ++++++++++++++++++++++++++++++++++
 drivers/media/i2c/msp3400-driver.c                         |   10 -
 drivers/media/i2c/mt9m032.c                                |    9 +-
 drivers/media/i2c/mt9p031.c                                |    1 -
 drivers/media/i2c/mt9v011.c                                |   24 --
 drivers/media/i2c/noon010pc30.c                            |    1 -
 drivers/media/i2c/ov7640.c                                 |    1 -
 drivers/media/i2c/ov7670.c                                 |   17 --
 drivers/media/i2c/saa6588.c                                |    9 -
 drivers/media/{pci/saa7134 => i2c}/saa6752hs.c             |  530 +++++++++++++-----------------------------
 drivers/media/i2c/saa7110.c                                |   13 +-
 drivers/media/i2c/saa7115.c                                |  112 +++++----
 drivers/media/i2c/saa7127.c                                |   47 ++--
 drivers/media/i2c/saa717x.c                                |    7 -
 drivers/media/i2c/saa7185.c                                |    9 -
 drivers/media/i2c/saa7191.c                                |   24 +-
 drivers/media/i2c/soc_camera/imx074.c                      |   19 --
 drivers/media/i2c/soc_camera/mt9m001.c                     |   33 +--
 drivers/media/i2c/soc_camera/mt9m111.c                     |   33 +--
 drivers/media/i2c/soc_camera/mt9t031.c                     |   33 +--
 drivers/media/i2c/soc_camera/mt9t112.c                     |   16 --
 drivers/media/i2c/soc_camera/mt9v022.c                     |   47 ++--
 drivers/media/i2c/soc_camera/ov2640.c                      |   16 --
 drivers/media/i2c/soc_camera/ov5642.c                      |   19 --
 drivers/media/i2c/soc_camera/ov6650.c                      |   12 -
 drivers/media/i2c/soc_camera/ov772x.c                      |   16 --
 drivers/media/i2c/soc_camera/ov9640.c                      |   16 --
 drivers/media/i2c/soc_camera/ov9740.c                      |   17 --
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                  |   31 +--
 drivers/media/i2c/soc_camera/tw9910.c                      |   15 +-
 drivers/media/i2c/sr030pc30.c                              |  276 +++++++---------------
 drivers/media/i2c/tda9840.c                                |   13 --
 drivers/media/i2c/tea6415c.c                               |   13 --
 drivers/media/i2c/tea6420.c                                |   13 --
 drivers/media/i2c/ths7303.c                                |   73 ++----
 drivers/media/i2c/ths8200.c                                |  556 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/i2c/ths8200_regs.h                           |  161 +++++++++++++
 drivers/media/i2c/tvaudio.c                                |    9 -
 drivers/media/i2c/tvp514x.c                                |   13 +-
 drivers/media/i2c/tvp5150.c                                |   32 +--
 drivers/media/i2c/tvp7002.c                                |   35 +--
 drivers/media/i2c/tw2804.c                                 |    1 -
 drivers/media/i2c/upd64031a.c                              |   17 --
 drivers/media/i2c/upd64083.c                               |   17 --
 drivers/media/i2c/vp27smpx.c                               |    9 -
 drivers/media/i2c/vpx3220.c                                |   24 +-
 drivers/media/i2c/vs6624.c                                 |   22 --
 drivers/media/i2c/wm8739.c                                 |    9 -
 drivers/media/i2c/wm8775.c                                 |    9 -
 drivers/media/pci/bt8xx/bttv-driver.c                      |   42 +---
 drivers/media/pci/cx18/cx18-av-core.c                      |   32 ---
 drivers/media/pci/cx18/cx18-av-core.h                      |    1 -
 drivers/media/pci/cx18/cx18-ioctl.c                        |   82 +------
 drivers/media/pci/cx23885/cx23885-417.c                    |    7 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c                  |  139 ++---------
 drivers/media/pci/cx23885/cx23885-ioctl.h                  |    4 +-
 drivers/media/pci/cx23885/cx23885-video.c                  |    9 +-
 drivers/media/pci/cx23885/cx23888-ir.c                     |   27 ---
 drivers/media/pci/ivtv/ivtv-driver.c                       |    8 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                        |   43 +---
 drivers/media/pci/saa7134/Kconfig                          |    1 +
 drivers/media/pci/saa7134/Makefile                         |    2 +-
 drivers/media/pci/saa7134/saa7134-core.c                   |   10 +-
 drivers/media/pci/saa7134/saa7134-empress.c                |  392 +++++++++----------------------
 drivers/media/pci/saa7134/saa7134-vbi.c                    |   11 +-
 drivers/media/pci/saa7134/saa7134-video.c                  | 1024 +++++++++++++++++++++++++++++++++------------------------------------------------
 drivers/media/pci/saa7134/saa7134.h                        |   83 +++++--
 drivers/media/pci/saa7146/mxb.c                            |   19 +-
 drivers/media/pci/saa7164/saa7164-encoder.c                |   50 +---
 drivers/media/pci/saa7164/saa7164-vbi.c                    |   22 +-
 drivers/media/pci/saa7164/saa7164.h                        |    2 +-
 drivers/media/pci/zoran/zoran_driver.c                     |   23 --
 drivers/media/platform/blackfin/bfin_capture.c             |   41 ----
 drivers/media/platform/davinci/vpbe_display.c              |   29 ---
 drivers/media/platform/davinci/vpif_capture.c              |   66 ------
 drivers/media/platform/davinci/vpif_display.c              |   66 ------
 drivers/media/platform/fsl-viu.c                           |    2 +-
 drivers/media/platform/indycam.c                           |   12 -
 drivers/media/platform/marvell-ccic/cafe-driver.c          |    4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c            |   67 ++----
 drivers/media/platform/marvell-ccic/mcam-core.h            |    9 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c           |    4 +-
 drivers/media/platform/sh_vou.c                            |   34 +--
 drivers/media/platform/soc_camera/soc_camera.c             |   37 ---
 drivers/media/platform/timblogiw.c                         |    7 +-
 drivers/media/platform/via-camera.c                        |   24 +-
 drivers/media/radio/radio-keene.c                          |    7 +-
 drivers/media/radio/radio-sf16fmi.c                        |  106 ++++-----
 drivers/media/radio/radio-si476x.c                         |   11 -
 drivers/media/radio/radio-tea5764.c                        |  190 ++++++---------
 drivers/media/radio/radio-timb.c                           |   81 ++-----
 drivers/media/radio/saa7706h.c                             |   66 +++---
 drivers/media/radio/tef6862.c                              |   24 +-
 drivers/media/usb/au0828/au0828-video.c                    |   40 +---
 drivers/media/usb/cx231xx/cx231xx-417.c                    |    1 -
 drivers/media/usb/cx231xx/cx231xx-avcore.c                 |    1 -
 drivers/media/usb/cx231xx/cx231xx-cards.c                  |    1 -
 drivers/media/usb/cx231xx/cx231xx-vbi.c                    |    1 -
 drivers/media/usb/cx231xx/cx231xx-video.c                  |  424 +++++++++-------------------------
 drivers/media/usb/cx231xx/cx231xx.h                        |    2 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.c              |    8 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c                    |   90 ++++----
 drivers/media/usb/em28xx/em28xx-cards.c                    |    3 +-
 drivers/media/usb/em28xx/em28xx-video.c                    |   66 +-----
 drivers/media/usb/gspca/gspca.c                            |   32 ++-
 drivers/media/usb/gspca/gspca.h                            |    6 +-
 drivers/media/usb/gspca/pac7302.c                          |   19 +-
 drivers/media/usb/gspca/sn9c20x.c                          |   69 ++----
 drivers/media/usb/hdpvr/hdpvr-control.c                    |   21 +-
 drivers/media/usb/hdpvr/hdpvr-video.c                      |   72 +++---
 drivers/media/usb/hdpvr/hdpvr.h                            |    1 +
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                    |   36 ---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h                    |    9 -
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                   |   34 ---
 drivers/media/usb/stk1160/stk1160-v4l.c                    |   41 ----
 drivers/media/usb/tm6000/tm6000-cards.c                    |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c                    |   13 +-
 drivers/media/usb/usbvision/usbvision-video.c              |   13 +-
 drivers/media/v4l2-core/v4l2-dev.c                         |    5 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                       |   48 +---
 drivers/staging/media/dt3155v4l/dt3155v4l.c                |    1 -
 drivers/staging/media/solo6x10/solo6x10-tw28.c             |  112 +++++----
 include/media/saa6752hs.h                                  |   26 ---
 include/media/ths7303.h                                    |    2 -
 include/media/tveeprom.h                                   |   11 +
 include/media/v4l2-dev.h                                   |    1 -
 include/uapi/linux/v4l2-controls.h                         |    4 +
 156 files changed, 3021 insertions(+), 4676 deletions(-)
 create mode 100644 drivers/media/i2c/ml86v7667.c
 rename drivers/media/{pci/saa7134 => i2c}/saa6752hs.c (62%)
 create mode 100644 drivers/media/i2c/ths8200.c
 create mode 100644 drivers/media/i2c/ths8200_regs.h
 delete mode 100644 include/media/saa6752hs.h
