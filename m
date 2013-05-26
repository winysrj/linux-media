Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4933 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3EZN13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 May 2013 09:27:29 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166] (may be forged))
	(authenticated bits=0)
	by smtp-vbr6.xs4all.nl (8.13.8/8.13.8) with ESMTP id r4QDRPhI014140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Sun, 26 May 2013 15:27:27 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.lan (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id E409D35E0034
	for <linux-media@vger.kernel.org>; Sun, 26 May 2013 15:27:24 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFC PATCH 00/24] Remove VIDIOC_DBG_G_CHIP_IDENT
Date: Sun, 26 May 2013 15:26:55 +0200
Message-Id: <1369574839-6687-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With the introduction in 3.10 of the new superior VIDIOC_DBG_G_CHIP_INFO
ioctl there is no longer any need for the DBG_G_CHIP_IDENT ioctl or the
v4l2-chip-ident.h header.

This patch series removes all code related to this ioctl and the
v4l2-chip-ident.h header.

This patch series simplifies drivers substantially and deletes over 2800
lines in total.

Regards,

	Hans

 Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-ident.xml  |  271 -------
 b/Documentation/DocBook/media/v4l/compat.xml                 |   14 
 b/Documentation/DocBook/media/v4l/v4l2.xml                   |   11 
 b/Documentation/DocBook/media/v4l/vidioc-dbg-g-chip-info.xml |   17 
 b/Documentation/DocBook/media/v4l/vidioc-dbg-g-register.xml  |   40 -
 b/Documentation/video4linux/v4l2-framework.txt               |   13 
 b/Documentation/zh_CN/video4linux/v4l2-framework.txt         |   13 
 b/drivers/media/common/saa7146/saa7146_video.c               |   23 
 b/drivers/media/common/tveeprom.c                            |  142 +--
 b/drivers/media/dvb-frontends/au8522_decoder.c               |   17 
 b/drivers/media/i2c/ad9389b.c                                |   21 
 b/drivers/media/i2c/adv7170.c                                |   13 
 b/drivers/media/i2c/adv7175.c                                |    9 
 b/drivers/media/i2c/adv7180.c                                |   10 
 b/drivers/media/i2c/adv7183.c                                |   22 
 b/drivers/media/i2c/adv7343.c                                |   10 
 b/drivers/media/i2c/adv7393.c                                |   10 
 b/drivers/media/i2c/adv7604.c                                |   18 
 b/drivers/media/i2c/ak881x.c                                 |   34 
 b/drivers/media/i2c/bt819.c                                  |   14 
 b/drivers/media/i2c/bt856.c                                  |    9 
 b/drivers/media/i2c/bt866.c                                  |   13 
 b/drivers/media/i2c/cs5345.c                                 |   17 
 b/drivers/media/i2c/cs53l32a.c                               |   10 
 b/drivers/media/i2c/cx25840/cx25840-core.c                   |   64 -
 b/drivers/media/i2c/cx25840/cx25840-core.h                   |   34 
 b/drivers/media/i2c/ks0127.c                                 |   16 
 b/drivers/media/i2c/m52790.c                                 |   15 
 b/drivers/media/i2c/msp3400-driver.c                         |   10 
 b/drivers/media/i2c/mt9m032.c                                |    9 
 b/drivers/media/i2c/mt9p031.c                                |    1 
 b/drivers/media/i2c/mt9v011.c                                |   24 
 b/drivers/media/i2c/noon010pc30.c                            |    1 
 b/drivers/media/i2c/ov7640.c                                 |    1 
 b/drivers/media/i2c/ov7670.c                                 |   17 
 b/drivers/media/i2c/saa6588.c                                |    9 
 b/drivers/media/i2c/saa7110.c                                |    9 
 b/drivers/media/i2c/saa7115.c                                |  107 +-
 b/drivers/media/i2c/saa7127.c                                |   47 -                                                                               
 b/drivers/media/i2c/saa717x.c                                |    7                                                                                 
 b/drivers/media/i2c/saa7185.c                                |    9                                                                                 
 b/drivers/media/i2c/saa7191.c                                |   10                                                                                 
 b/drivers/media/i2c/soc_camera/imx074.c                      |   19                                                                                 
 b/drivers/media/i2c/soc_camera/mt9m001.c                     |   33                                                                                 
 b/drivers/media/i2c/soc_camera/mt9m111.c                     |   33                                                                                 
 b/drivers/media/i2c/soc_camera/mt9t031.c                     |   32                                                                                 
 b/drivers/media/i2c/soc_camera/mt9t112.c                     |   16                                                                                 
 b/drivers/media/i2c/soc_camera/mt9v022.c                     |   47 -                                                                               
 b/drivers/media/i2c/soc_camera/ov2640.c                      |   16                                                                                 
 b/drivers/media/i2c/soc_camera/ov5642.c                      |   19                                                                                 
 b/drivers/media/i2c/soc_camera/ov6650.c                      |   12                                                                                 
 b/drivers/media/i2c/soc_camera/ov772x.c                      |   16                                                                                 
 b/drivers/media/i2c/soc_camera/ov9640.c                      |   16                                                                                 
 b/drivers/media/i2c/soc_camera/ov9740.c                      |   17                                                                                 
 b/drivers/media/i2c/soc_camera/rj54n1cb0c.c                  |   31                                                                                 
 b/drivers/media/i2c/soc_camera/tw9910.c                      |   14                                                                                 
 b/drivers/media/i2c/tda9840.c                                |   13                                                                                 
 b/drivers/media/i2c/tea6415c.c                               |   13                                                                                 
 b/drivers/media/i2c/tea6420.c                                |   13                                                                                 
 b/drivers/media/i2c/ths7303.c                                |   25                                                                                 
 b/drivers/media/i2c/tvaudio.c                                |    9                                                                                 
 b/drivers/media/i2c/tvp514x.c                                |    1                                                                                 
 b/drivers/media/i2c/tvp5150.c                                |   24                                                                                 
 b/drivers/media/i2c/tvp7002.c                                |   34                                                                                 
 b/drivers/media/i2c/tw2804.c                                 |    1                                                                                 
 b/drivers/media/i2c/upd64031a.c                              |   17                                                                                 
 b/drivers/media/i2c/upd64083.c                               |   17                                                                                 
 b/drivers/media/i2c/vp27smpx.c                               |    9                                                                                 
 b/drivers/media/i2c/vpx3220.c                                |   14                                                                                 
 b/drivers/media/i2c/vs6624.c                                 |   22                                                                                 
 b/drivers/media/i2c/wm8739.c                                 |    9 
 b/drivers/media/i2c/wm8775.c                                 |    9 
 b/drivers/media/pci/bt8xx/bttv-driver.c                      |   38 -
 b/drivers/media/pci/cx18/cx18-av-core.c                      |   32 
 b/drivers/media/pci/cx18/cx18-av-core.h                      |    1 
 b/drivers/media/pci/cx18/cx18-ioctl.c                        |   78 --
 b/drivers/media/pci/cx23885/cx23885-417.c                    |    2 
 b/drivers/media/pci/cx23885/cx23885-ioctl.c                  |  139 ---
 b/drivers/media/pci/cx23885/cx23885-ioctl.h                  |    4 
 b/drivers/media/pci/cx23885/cx23885-video.c                  |    2 
 b/drivers/media/pci/cx23885/cx23888-ir.c                     |   27 
 b/drivers/media/pci/cx88/cx88-alsa.c                         |    6 
 b/drivers/media/pci/cx88/cx88-cards.c                        |   12 
 b/drivers/media/pci/cx88/cx88-video.c                        |   27 
 b/drivers/media/pci/cx88/cx88.h                              |    8 
 b/drivers/media/pci/ivtv/ivtv-driver.c                       |    8 
 b/drivers/media/pci/ivtv/ivtv-ioctl.c                        |   41 -
 b/drivers/media/pci/saa7134/saa6752hs.c                      |   14 
 b/drivers/media/pci/saa7134/saa7134-empress.c                |   17 
 b/drivers/media/pci/saa7134/saa7134-video.c                  |    4 
 b/drivers/media/pci/saa7146/mxb.c                            |   15 
 b/drivers/media/pci/saa7164/saa7164-encoder.c                |   37 
 b/drivers/media/pci/saa7164/saa7164-vbi.c                    |    9 
 b/drivers/media/pci/saa7164/saa7164.h                        |    1 
 b/drivers/media/platform/blackfin/bfin_capture.c             |   41 -
 b/drivers/media/platform/davinci/vpif_capture.c              |   66 -
 b/drivers/media/platform/davinci/vpif_display.c              |   66 -
 b/drivers/media/platform/indycam.c                           |   12 
 b/drivers/media/platform/marvell-ccic/cafe-driver.c          |    3 
 b/drivers/media/platform/marvell-ccic/mcam-core.c            |   55 -
 b/drivers/media/platform/marvell-ccic/mcam-core.h            |    8 
 b/drivers/media/platform/marvell-ccic/mmp-driver.c           |    3 
 b/drivers/media/platform/sh_vou.c                            |   31 
 b/drivers/media/platform/soc_camera/soc_camera.c             |   34 
 b/drivers/media/platform/via-camera.c                        |   16 
 b/drivers/media/radio/radio-si476x.c                         |   11 
 b/drivers/media/radio/saa7706h.c                             |   10 
 b/drivers/media/radio/tef6862.c                              |   14 
 b/drivers/media/usb/au0828/au0828-video.c                    |   39 -
 b/drivers/media/usb/cx231xx/cx231xx-417.c                    |    1 
 b/drivers/media/usb/cx231xx/cx231xx-avcore.c                 |    1 
 b/drivers/media/usb/cx231xx/cx231xx-cards.c                  |    1 
 b/drivers/media/usb/cx231xx/cx231xx-vbi.c                    |    1 
 b/drivers/media/usb/cx231xx/cx231xx-video.c                  |  417 ++---------
 b/drivers/media/usb/cx231xx/cx231xx.h                        |    2 
 b/drivers/media/usb/em28xx/em28xx-cards.c                    |    3 
 b/drivers/media/usb/em28xx/em28xx-video.c                    |   66 -
 b/drivers/media/usb/gspca/gspca.c                            |   32 
 b/drivers/media/usb/gspca/gspca.h                            |    6 
 b/drivers/media/usb/gspca/pac7302.c                          |   19 
 b/drivers/media/usb/gspca/sn9c20x.c                          |   67 -
 b/drivers/media/usb/stk1160/stk1160-v4l.c                    |   41 -
 b/drivers/media/usb/usbvision/usbvision-video.c              |    4 
 b/drivers/media/v4l2-core/v4l2-common.c                      |   58 -
 b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c              |    1 
 b/drivers/media/v4l2-core/v4l2-dev.c                         |    1 
 b/drivers/media/v4l2-core/v4l2-ioctl.c                       |   34 
 b/include/media/tveeprom.h                                   |   11 
 b/include/media/v4l2-common.h                                |   10 
 b/include/media/v4l2-int-device.h                            |    3 
 b/include/media/v4l2-ioctl.h                                 |    2 
 b/include/media/v4l2-subdev.h                                |    4 
 b/include/uapi/linux/videodev2.h                             |   17 
 include/media/v4l2-chip-ident.h                              |  354 ---------
 134 files changed, 491 insertions(+), 3308 deletions(-)

