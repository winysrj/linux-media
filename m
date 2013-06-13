Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1469 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3FMG3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jun 2013 02:29:00 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr15.xs4all.nl (8.13.8/8.13.8) with ESMTP id r5D6SmmW053680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:28:50 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 9F18E35E005E
	for <linux-media@vger.kernel.org>; Thu, 13 Jun 2013 08:28:46 +0200 (CEST)
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.11] Updates Part 2
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Thu, 13 Jun 2013 08:28:47 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306130828.47780.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro prefers to have the original large pull request split up in smaller pieces.

So this is the second patch set.

Note that the pull requests need to be done in order since there are dependencies
between them.

Regards,

	Hans

The following changes since commit 59834c3c791a01d9b7e460bf90d7ec4b47aaeab8:

  media: i2c: ths7303: make the pdata as a constant pointer (2013-06-13 08:14:07 +0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v3.11b

for you to fetch changes up to 4cb7bf1ce4051911ae658f55e0d480246de9b727:

  v4l2-framework: replace g_chip_ident by g_std in the examples. (2013-06-13 08:15:20 +0200)

----------------------------------------------------------------
Hans Verkuil (30):
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

 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml |    3 +-
 Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml  |   15 ++-
 Documentation/video4linux/v4l2-framework.txt               |   13 ++-
 Documentation/zh_CN/video4linux/v4l2-framework.txt         |   13 ++-
 drivers/media/common/saa7146/saa7146_video.c               |   23 -----
 drivers/media/common/tveeprom.c                            |  142 +++++++++++++--------------
 drivers/media/dvb-frontends/au8522_decoder.c               |   17 ----
 drivers/media/i2c/ad9389b.c                                |   21 +---
 drivers/media/i2c/adv7170.c                                |   13 ---
 drivers/media/i2c/adv7175.c                                |    9 --
 drivers/media/i2c/adv7180.c                                |   10 --
 drivers/media/i2c/adv7183.c                                |   22 -----
 drivers/media/i2c/adv7343.c                                |   10 --
 drivers/media/i2c/adv7393.c                                |   10 --
 drivers/media/i2c/adv7604.c                                |   18 ----
 drivers/media/i2c/ak881x.c                                 |   35 +------
 drivers/media/i2c/bt819.c                                  |   14 ---
 drivers/media/i2c/bt856.c                                  |    9 --
 drivers/media/i2c/bt866.c                                  |   13 ---
 drivers/media/i2c/cs5345.c                                 |   17 ----
 drivers/media/i2c/cs53l32a.c                               |   10 --
 drivers/media/i2c/cx25840/cx25840-core.c                   |   64 +++++--------
 drivers/media/i2c/cx25840/cx25840-core.h                   |   34 ++++---
 drivers/media/i2c/ks0127.c                                 |   16 ----
 drivers/media/i2c/m52790.c                                 |   15 ---
 drivers/media/i2c/msp3400-driver.c                         |   10 --
 drivers/media/i2c/mt9m032.c                                |    9 +-
 drivers/media/i2c/mt9p031.c                                |    1 -
 drivers/media/i2c/mt9v011.c                                |   24 -----
 drivers/media/i2c/noon010pc30.c                            |    1 -
 drivers/media/i2c/ov7640.c                                 |    1 -
 drivers/media/i2c/ov7670.c                                 |   17 ----
 drivers/media/i2c/saa6588.c                                |    9 --
 drivers/media/i2c/saa7110.c                                |    9 --
 drivers/media/i2c/saa7115.c                                |  107 ++++++++++-----------
 drivers/media/i2c/saa7127.c                                |   47 ++++-----
 drivers/media/i2c/saa717x.c                                |    7 --
 drivers/media/i2c/saa7185.c                                |    9 --
 drivers/media/i2c/saa7191.c                                |   10 --
 drivers/media/i2c/soc_camera/imx074.c                      |   19 ----
 drivers/media/i2c/soc_camera/mt9m001.c                     |   33 +------
 drivers/media/i2c/soc_camera/mt9m111.c                     |   33 +------
 drivers/media/i2c/soc_camera/mt9t031.c                     |   33 +------
 drivers/media/i2c/soc_camera/mt9t112.c                     |   16 ----
 drivers/media/i2c/soc_camera/mt9v022.c                     |   47 +++------
 drivers/media/i2c/soc_camera/ov2640.c                      |   16 ----
 drivers/media/i2c/soc_camera/ov5642.c                      |   19 ----
 drivers/media/i2c/soc_camera/ov6650.c                      |   12 ---
 drivers/media/i2c/soc_camera/ov772x.c                      |   16 ----
 drivers/media/i2c/soc_camera/ov9640.c                      |   16 ----
 drivers/media/i2c/soc_camera/ov9740.c                      |   17 ----
 drivers/media/i2c/soc_camera/rj54n1cb0c.c                  |   31 +-----
 drivers/media/i2c/soc_camera/tw9910.c                      |   15 +--
 drivers/media/i2c/tda9840.c                                |   13 ---
 drivers/media/i2c/tea6415c.c                               |   13 ---
 drivers/media/i2c/tea6420.c                                |   13 ---
 drivers/media/i2c/ths7303.c                                |   25 +----
 drivers/media/i2c/tvaudio.c                                |    9 --
 drivers/media/i2c/tvp514x.c                                |    1 -
 drivers/media/i2c/tvp5150.c                                |   24 -----
 drivers/media/i2c/tvp7002.c                                |   35 +------
 drivers/media/i2c/tw2804.c                                 |    1 -
 drivers/media/i2c/upd64031a.c                              |   17 ----
 drivers/media/i2c/upd64083.c                               |   17 ----
 drivers/media/i2c/vp27smpx.c                               |    9 --
 drivers/media/i2c/vpx3220.c                                |   14 ---
 drivers/media/i2c/vs6624.c                                 |   22 -----
 drivers/media/i2c/wm8739.c                                 |    9 --
 drivers/media/i2c/wm8775.c                                 |    9 --
 drivers/media/pci/bt8xx/bttv-driver.c                      |   38 --------
 drivers/media/pci/cx18/cx18-av-core.c                      |   32 -------
 drivers/media/pci/cx18/cx18-av-core.h                      |    1 -
 drivers/media/pci/cx18/cx18-ioctl.c                        |   82 +++-------------
 drivers/media/pci/cx23885/cx23885-417.c                    |    2 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c                  |  139 +++++----------------------
 drivers/media/pci/cx23885/cx23885-ioctl.h                  |    4 +-
 drivers/media/pci/cx23885/cx23885-video.c                  |    2 +-
 drivers/media/pci/cx23885/cx23888-ir.c                     |   27 ------
 drivers/media/pci/ivtv/ivtv-driver.c                       |    8 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                        |   43 ++-------
 drivers/media/pci/saa7134/saa6752hs.c                      |   14 ---
 drivers/media/pci/saa7134/saa7134-empress.c                |   17 ----
 drivers/media/pci/saa7134/saa7134-video.c                  |    8 +-
 drivers/media/pci/saa7146/mxb.c                            |   19 ++--
 drivers/media/pci/saa7164/saa7164-encoder.c                |   37 -------
 drivers/media/pci/saa7164/saa7164-vbi.c                    |    9 --
 drivers/media/pci/saa7164/saa7164.h                        |    1 -
 drivers/media/platform/blackfin/bfin_capture.c             |   41 --------
 drivers/media/platform/davinci/vpbe_display.c              |   29 ------
 drivers/media/platform/davinci/vpif_capture.c              |   66 -------------
 drivers/media/platform/davinci/vpif_display.c              |   66 -------------
 drivers/media/platform/indycam.c                           |   12 ---
 drivers/media/platform/marvell-ccic/cafe-driver.c          |    4 +-
 drivers/media/platform/marvell-ccic/mcam-core.c            |   59 +++---------
 drivers/media/platform/marvell-ccic/mcam-core.h            |    9 +-
 drivers/media/platform/marvell-ccic/mmp-driver.c           |    4 +-
 drivers/media/platform/sh_vou.c                            |   31 ------
 drivers/media/platform/soc_camera/soc_camera.c             |   34 -------
 drivers/media/platform/via-camera.c                        |   16 ----
 drivers/media/radio/radio-si476x.c                         |   11 ---
 drivers/media/radio/saa7706h.c                             |   10 --
 drivers/media/radio/tef6862.c                              |   14 ---
 drivers/media/usb/au0828/au0828-video.c                    |   40 +-------
 drivers/media/usb/cx231xx/cx231xx-417.c                    |    1 -
 drivers/media/usb/cx231xx/cx231xx-avcore.c                 |    1 -
 drivers/media/usb/cx231xx/cx231xx-cards.c                  |    1 -
 drivers/media/usb/cx231xx/cx231xx-vbi.c                    |    1 -
 drivers/media/usb/cx231xx/cx231xx-video.c                  |  424 +++++++++++++++++++++------------------------------------------------------------
 drivers/media/usb/cx231xx/cx231xx.h                        |    2 +-
 drivers/media/usb/em28xx/em28xx-cards.c                    |    3 +-
 drivers/media/usb/em28xx/em28xx-video.c                    |   66 ++-----------
 drivers/media/usb/gspca/gspca.c                            |   32 +++----
 drivers/media/usb/gspca/gspca.h                            |    6 +-
 drivers/media/usb/gspca/pac7302.c                          |   19 +---
 drivers/media/usb/gspca/sn9c20x.c                          |   69 ++++----------
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                    |   36 -------
 drivers/media/usb/pvrusb2/pvrusb2-hdw.h                    |    9 --
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c                   |   34 -------
 drivers/media/usb/stk1160/stk1160-v4l.c                    |   41 --------
 drivers/media/v4l2-core/v4l2-ioctl.c                       |    6 +-
 include/media/tveeprom.h                                   |   11 +++
 121 files changed, 486 insertions(+), 2586 deletions(-)
