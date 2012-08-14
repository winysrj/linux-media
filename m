Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab2HNEMw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 00:12:52 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7E4CqHn030630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 00:12:52 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 2/3] [media] rename most media/video usb drivers to media/usb
Date: Tue, 14 Aug 2012 01:12:44 -0300
Message-Id: <1344917565-22396-3-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344917565-22396-1-git-send-email-mchehab@redhat.com>
References: <1344917565-22396-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename all USB drivers with their own directory under
drivers/media/video into drivers/media/usb and update the
building system.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 MAINTAINERS                                        | 22 ++++++------
 drivers/media/usb/Kconfig                          | 41 +++++++++++++++++++---
 drivers/media/usb/Makefile                         | 14 ++++++++
 drivers/media/{video => usb}/au0828/Kconfig        |  0
 drivers/media/{video => usb}/au0828/Makefile       |  0
 drivers/media/{video => usb}/au0828/au0828-cards.c |  0
 drivers/media/{video => usb}/au0828/au0828-cards.h |  0
 drivers/media/{video => usb}/au0828/au0828-core.c  |  0
 drivers/media/{video => usb}/au0828/au0828-dvb.c   |  0
 drivers/media/{video => usb}/au0828/au0828-i2c.c   |  0
 drivers/media/{video => usb}/au0828/au0828-reg.h   |  0
 drivers/media/{video => usb}/au0828/au0828-vbi.c   |  0
 drivers/media/{video => usb}/au0828/au0828-video.c |  0
 drivers/media/{video => usb}/au0828/au0828.h       |  0
 drivers/media/{video => usb}/cpia2/Kconfig         |  0
 drivers/media/{video => usb}/cpia2/Makefile        |  0
 drivers/media/{video => usb}/cpia2/cpia2.h         |  0
 drivers/media/{video => usb}/cpia2/cpia2_core.c    |  0
 .../media/{video => usb}/cpia2/cpia2_registers.h   |  0
 drivers/media/{video => usb}/cpia2/cpia2_usb.c     |  0
 drivers/media/{video => usb}/cpia2/cpia2_v4l.c     |  0
 drivers/media/{video => usb}/cx231xx/Kconfig       |  0
 drivers/media/{video => usb}/cx231xx/Makefile      |  0
 drivers/media/{video => usb}/cx231xx/cx231xx-417.c |  0
 .../media/{video => usb}/cx231xx/cx231xx-audio.c   |  0
 .../media/{video => usb}/cx231xx/cx231xx-avcore.c  |  0
 .../media/{video => usb}/cx231xx/cx231xx-cards.c   |  0
 .../{video => usb}/cx231xx/cx231xx-conf-reg.h      |  0
 .../media/{video => usb}/cx231xx/cx231xx-core.c    |  0
 drivers/media/{video => usb}/cx231xx/cx231xx-dif.h |  0
 drivers/media/{video => usb}/cx231xx/cx231xx-dvb.c |  0
 drivers/media/{video => usb}/cx231xx/cx231xx-i2c.c |  0
 .../media/{video => usb}/cx231xx/cx231xx-input.c   |  0
 .../media/{video => usb}/cx231xx/cx231xx-pcb-cfg.c |  0
 .../media/{video => usb}/cx231xx/cx231xx-pcb-cfg.h |  0
 drivers/media/{video => usb}/cx231xx/cx231xx-reg.h |  0
 drivers/media/{video => usb}/cx231xx/cx231xx-vbi.c |  0
 drivers/media/{video => usb}/cx231xx/cx231xx-vbi.h |  0
 .../media/{video => usb}/cx231xx/cx231xx-video.c   |  0
 drivers/media/{video => usb}/cx231xx/cx231xx.h     |  0
 drivers/media/{video => usb}/em28xx/Kconfig        |  0
 drivers/media/{video => usb}/em28xx/Makefile       |  0
 drivers/media/{video => usb}/em28xx/em28xx-audio.c |  0
 drivers/media/{video => usb}/em28xx/em28xx-cards.c |  0
 drivers/media/{video => usb}/em28xx/em28xx-core.c  |  0
 drivers/media/{video => usb}/em28xx/em28xx-dvb.c   |  0
 drivers/media/{video => usb}/em28xx/em28xx-i2c.c   |  0
 drivers/media/{video => usb}/em28xx/em28xx-input.c |  0
 drivers/media/{video => usb}/em28xx/em28xx-reg.h   |  0
 drivers/media/{video => usb}/em28xx/em28xx-vbi.c   |  0
 drivers/media/{video => usb}/em28xx/em28xx-video.c |  0
 drivers/media/{video => usb}/em28xx/em28xx.h       |  0
 drivers/media/{video => usb}/gspca/Kconfig         |  6 ++--
 drivers/media/{video => usb}/gspca/Makefile        |  0
 .../{video => usb}/gspca/autogain_functions.c      |  0
 .../{video => usb}/gspca/autogain_functions.h      |  0
 drivers/media/{video => usb}/gspca/benq.c          |  0
 drivers/media/{video => usb}/gspca/conex.c         |  0
 drivers/media/{video => usb}/gspca/cpia1.c         |  0
 drivers/media/{video => usb}/gspca/etoms.c         |  0
 drivers/media/{video => usb}/gspca/finepix.c       |  0
 drivers/media/{video => usb}/gspca/gl860/Kconfig   |  0
 drivers/media/{video => usb}/gspca/gl860/Makefile  |  2 +-
 .../{video => usb}/gspca/gl860/gl860-mi1320.c      |  0
 .../{video => usb}/gspca/gl860/gl860-mi2020.c      |  0
 .../{video => usb}/gspca/gl860/gl860-ov2640.c      |  0
 .../{video => usb}/gspca/gl860/gl860-ov9655.c      |  0
 drivers/media/{video => usb}/gspca/gl860/gl860.c   |  0
 drivers/media/{video => usb}/gspca/gl860/gl860.h   |  0
 drivers/media/{video => usb}/gspca/gspca.c         |  0
 drivers/media/{video => usb}/gspca/gspca.h         |  0
 drivers/media/{video => usb}/gspca/jeilinj.c       |  0
 drivers/media/{video => usb}/gspca/jl2005bcd.c     |  0
 drivers/media/{video => usb}/gspca/jpeg.h          |  0
 drivers/media/{video => usb}/gspca/kinect.c        |  0
 drivers/media/{video => usb}/gspca/konica.c        |  0
 drivers/media/{video => usb}/gspca/m5602/Kconfig   |  0
 drivers/media/{video => usb}/gspca/m5602/Makefile  |  2 +-
 .../{video => usb}/gspca/m5602/m5602_bridge.h      |  0
 .../media/{video => usb}/gspca/m5602/m5602_core.c  |  0
 .../{video => usb}/gspca/m5602/m5602_mt9m111.c     |  0
 .../{video => usb}/gspca/m5602/m5602_mt9m111.h     |  0
 .../{video => usb}/gspca/m5602/m5602_ov7660.c      |  0
 .../{video => usb}/gspca/m5602/m5602_ov7660.h      |  0
 .../{video => usb}/gspca/m5602/m5602_ov9650.c      |  0
 .../{video => usb}/gspca/m5602/m5602_ov9650.h      |  0
 .../{video => usb}/gspca/m5602/m5602_po1030.c      |  0
 .../{video => usb}/gspca/m5602/m5602_po1030.h      |  0
 .../{video => usb}/gspca/m5602/m5602_s5k4aa.c      |  0
 .../{video => usb}/gspca/m5602/m5602_s5k4aa.h      |  0
 .../{video => usb}/gspca/m5602/m5602_s5k83a.c      |  0
 .../{video => usb}/gspca/m5602/m5602_s5k83a.h      |  0
 .../{video => usb}/gspca/m5602/m5602_sensor.h      |  0
 drivers/media/{video => usb}/gspca/mars.c          |  0
 drivers/media/{video => usb}/gspca/mr97310a.c      |  0
 drivers/media/{video => usb}/gspca/nw80x.c         |  0
 drivers/media/{video => usb}/gspca/ov519.c         |  0
 drivers/media/{video => usb}/gspca/ov534.c         |  0
 drivers/media/{video => usb}/gspca/ov534_9.c       |  0
 drivers/media/{video => usb}/gspca/pac207.c        |  0
 drivers/media/{video => usb}/gspca/pac7302.c       |  0
 drivers/media/{video => usb}/gspca/pac7311.c       |  0
 drivers/media/{video => usb}/gspca/pac_common.h    |  0
 drivers/media/{video => usb}/gspca/se401.c         |  0
 drivers/media/{video => usb}/gspca/se401.h         |  0
 drivers/media/{video => usb}/gspca/sn9c2028.c      |  0
 drivers/media/{video => usb}/gspca/sn9c2028.h      |  0
 drivers/media/{video => usb}/gspca/sn9c20x.c       |  0
 drivers/media/{video => usb}/gspca/sonixb.c        |  0
 drivers/media/{video => usb}/gspca/sonixj.c        |  0
 drivers/media/{video => usb}/gspca/spca1528.c      |  0
 drivers/media/{video => usb}/gspca/spca500.c       |  0
 drivers/media/{video => usb}/gspca/spca501.c       |  0
 drivers/media/{video => usb}/gspca/spca505.c       |  0
 drivers/media/{video => usb}/gspca/spca506.c       |  0
 drivers/media/{video => usb}/gspca/spca508.c       |  0
 drivers/media/{video => usb}/gspca/spca561.c       |  0
 drivers/media/{video => usb}/gspca/sq905.c         |  0
 drivers/media/{video => usb}/gspca/sq905c.c        |  0
 drivers/media/{video => usb}/gspca/sq930x.c        |  0
 drivers/media/{video => usb}/gspca/stk014.c        |  0
 drivers/media/{video => usb}/gspca/stv0680.c       |  0
 drivers/media/{video => usb}/gspca/stv06xx/Kconfig |  0
 .../media/{video => usb}/gspca/stv06xx/Makefile    |  2 +-
 .../media/{video => usb}/gspca/stv06xx/stv06xx.c   |  0
 .../media/{video => usb}/gspca/stv06xx/stv06xx.h   |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_hdcs.c    |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_hdcs.h    |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_pb0100.c  |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_pb0100.h  |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_sensor.h  |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_st6422.c  |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_st6422.h  |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_vv6410.c  |  0
 .../{video => usb}/gspca/stv06xx/stv06xx_vv6410.h  |  0
 drivers/media/{video => usb}/gspca/sunplus.c       |  0
 drivers/media/{video => usb}/gspca/t613.c          |  0
 drivers/media/{video => usb}/gspca/topro.c         |  0
 drivers/media/{video => usb}/gspca/tv8532.c        |  0
 drivers/media/{video => usb}/gspca/vc032x.c        |  0
 drivers/media/{video => usb}/gspca/vicam.c         |  0
 drivers/media/{video => usb}/gspca/w996Xcf.c       |  0
 drivers/media/{video => usb}/gspca/xirlink_cit.c   |  0
 drivers/media/{video => usb}/gspca/zc3xx-reg.h     |  0
 drivers/media/{video => usb}/gspca/zc3xx.c         |  0
 drivers/media/{video => usb}/hdpvr/Kconfig         |  0
 drivers/media/{video => usb}/hdpvr/Makefile        |  0
 drivers/media/{video => usb}/hdpvr/hdpvr-control.c |  0
 drivers/media/{video => usb}/hdpvr/hdpvr-core.c    |  0
 drivers/media/{video => usb}/hdpvr/hdpvr-i2c.c     |  0
 drivers/media/{video => usb}/hdpvr/hdpvr-video.c   |  0
 drivers/media/{video => usb}/hdpvr/hdpvr.h         |  0
 drivers/media/{video => usb}/pvrusb2/Kconfig       |  0
 drivers/media/{video => usb}/pvrusb2/Makefile      |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-audio.c   |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-audio.h   |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-context.c |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-context.h |  0
 .../{video => usb}/pvrusb2/pvrusb2-cs53l32a.c      |  0
 .../{video => usb}/pvrusb2/pvrusb2-cs53l32a.h      |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-ctrl.c    |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-ctrl.h    |  0
 .../{video => usb}/pvrusb2/pvrusb2-cx2584x-v4l.c   |  0
 .../{video => usb}/pvrusb2/pvrusb2-cx2584x-v4l.h   |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-debug.h   |  0
 .../{video => usb}/pvrusb2/pvrusb2-debugifc.c      |  0
 .../{video => usb}/pvrusb2/pvrusb2-debugifc.h      |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-devattr.c |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-devattr.h |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-dvb.c |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-dvb.h |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-eeprom.c  |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-eeprom.h  |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-encoder.c |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-encoder.h |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-fx2-cmd.h |  0
 .../{video => usb}/pvrusb2/pvrusb2-hdw-internal.h  |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw.c |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw.h |  0
 .../{video => usb}/pvrusb2/pvrusb2-i2c-core.c      |  0
 .../{video => usb}/pvrusb2/pvrusb2-i2c-core.h      |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-io.c  |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-io.h  |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-ioread.c  |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-ioread.h  |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-main.c    |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-std.c |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2-std.h |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-sysfs.c   |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-sysfs.h   |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-util.h    |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-v4l2.c    |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-v4l2.h    |  0
 .../{video => usb}/pvrusb2/pvrusb2-video-v4l.c     |  0
 .../{video => usb}/pvrusb2/pvrusb2-video-v4l.h     |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-wm8775.c  |  0
 .../media/{video => usb}/pvrusb2/pvrusb2-wm8775.h  |  0
 drivers/media/{video => usb}/pvrusb2/pvrusb2.h     |  0
 drivers/media/{video => usb}/pwc/Kconfig           |  0
 drivers/media/{video => usb}/pwc/Makefile          |  0
 drivers/media/{video => usb}/pwc/philips.txt       |  0
 drivers/media/{video => usb}/pwc/pwc-ctrl.c        |  0
 drivers/media/{video => usb}/pwc/pwc-dec1.c        |  0
 drivers/media/{video => usb}/pwc/pwc-dec1.h        |  0
 drivers/media/{video => usb}/pwc/pwc-dec23.c       |  0
 drivers/media/{video => usb}/pwc/pwc-dec23.h       |  0
 drivers/media/{video => usb}/pwc/pwc-if.c          |  0
 drivers/media/{video => usb}/pwc/pwc-kiara.c       |  0
 drivers/media/{video => usb}/pwc/pwc-kiara.h       |  0
 drivers/media/{video => usb}/pwc/pwc-misc.c        |  0
 drivers/media/{video => usb}/pwc/pwc-nala.h        |  0
 drivers/media/{video => usb}/pwc/pwc-timon.c       |  0
 drivers/media/{video => usb}/pwc/pwc-timon.h       |  0
 drivers/media/{video => usb}/pwc/pwc-uncompress.c  |  0
 drivers/media/{video => usb}/pwc/pwc-v4l.c         |  0
 drivers/media/{video => usb}/pwc/pwc.h             |  0
 drivers/media/{video => usb}/sn9c102/Kconfig       |  0
 drivers/media/{video => usb}/sn9c102/Makefile      |  0
 drivers/media/{video => usb}/sn9c102/sn9c102.h     |  0
 .../media/{video => usb}/sn9c102/sn9c102_config.h  |  0
 .../media/{video => usb}/sn9c102/sn9c102_core.c    |  0
 .../{video => usb}/sn9c102/sn9c102_devtable.h      |  0
 .../media/{video => usb}/sn9c102/sn9c102_hv7131d.c |  0
 .../media/{video => usb}/sn9c102/sn9c102_hv7131r.c |  0
 .../media/{video => usb}/sn9c102/sn9c102_mi0343.c  |  0
 .../media/{video => usb}/sn9c102/sn9c102_mi0360.c  |  0
 .../media/{video => usb}/sn9c102/sn9c102_mt9v111.c |  0
 .../media/{video => usb}/sn9c102/sn9c102_ov7630.c  |  0
 .../media/{video => usb}/sn9c102/sn9c102_ov7660.c  |  0
 .../media/{video => usb}/sn9c102/sn9c102_pas106b.c |  0
 .../{video => usb}/sn9c102/sn9c102_pas202bcb.c     |  0
 .../media/{video => usb}/sn9c102/sn9c102_sensor.h  |  0
 .../{video => usb}/sn9c102/sn9c102_tas5110c1b.c    |  0
 .../{video => usb}/sn9c102/sn9c102_tas5110d.c      |  0
 .../{video => usb}/sn9c102/sn9c102_tas5130d1b.c    |  0
 drivers/media/{video => usb}/stk1160/Kconfig       |  0
 drivers/media/{video => usb}/stk1160/Makefile      |  0
 .../media/{video => usb}/stk1160/stk1160-ac97.c    |  0
 .../media/{video => usb}/stk1160/stk1160-core.c    |  0
 drivers/media/{video => usb}/stk1160/stk1160-i2c.c |  0
 drivers/media/{video => usb}/stk1160/stk1160-reg.h |  0
 drivers/media/{video => usb}/stk1160/stk1160-v4l.c |  0
 .../media/{video => usb}/stk1160/stk1160-video.c   |  0
 drivers/media/{video => usb}/stk1160/stk1160.h     |  0
 drivers/media/{video => usb}/tlg2300/Kconfig       |  0
 drivers/media/{video => usb}/tlg2300/Makefile      |  0
 drivers/media/{video => usb}/tlg2300/pd-alsa.c     |  0
 drivers/media/{video => usb}/tlg2300/pd-common.h   |  0
 drivers/media/{video => usb}/tlg2300/pd-dvb.c      |  0
 drivers/media/{video => usb}/tlg2300/pd-main.c     |  0
 drivers/media/{video => usb}/tlg2300/pd-radio.c    |  0
 drivers/media/{video => usb}/tlg2300/pd-video.c    |  0
 drivers/media/{video => usb}/tlg2300/vendorcmds.h  |  0
 drivers/media/{video => usb}/tm6000/Kconfig        |  0
 drivers/media/{video => usb}/tm6000/Makefile       |  0
 drivers/media/{video => usb}/tm6000/tm6000-alsa.c  |  0
 drivers/media/{video => usb}/tm6000/tm6000-cards.c |  0
 drivers/media/{video => usb}/tm6000/tm6000-core.c  |  0
 drivers/media/{video => usb}/tm6000/tm6000-dvb.c   |  0
 drivers/media/{video => usb}/tm6000/tm6000-i2c.c   |  0
 drivers/media/{video => usb}/tm6000/tm6000-input.c |  0
 drivers/media/{video => usb}/tm6000/tm6000-regs.h  |  0
 drivers/media/{video => usb}/tm6000/tm6000-stds.c  |  0
 .../media/{video => usb}/tm6000/tm6000-usb-isoc.h  |  0
 drivers/media/{video => usb}/tm6000/tm6000-video.c |  0
 drivers/media/{video => usb}/tm6000/tm6000.h       |  0
 drivers/media/{video => usb}/usbvision/Kconfig     |  0
 drivers/media/{video => usb}/usbvision/Makefile    |  0
 .../{video => usb}/usbvision/usbvision-cards.c     |  0
 .../{video => usb}/usbvision/usbvision-cards.h     |  0
 .../{video => usb}/usbvision/usbvision-core.c      |  0
 .../media/{video => usb}/usbvision/usbvision-i2c.c |  0
 .../{video => usb}/usbvision/usbvision-video.c     |  0
 drivers/media/{video => usb}/usbvision/usbvision.h |  0
 drivers/media/{video => usb}/uvc/Kconfig           |  0
 drivers/media/{video => usb}/uvc/Makefile          |  0
 drivers/media/{video => usb}/uvc/uvc_ctrl.c        |  0
 drivers/media/{video => usb}/uvc/uvc_debugfs.c     |  0
 drivers/media/{video => usb}/uvc/uvc_driver.c      |  0
 drivers/media/{video => usb}/uvc/uvc_entity.c      |  0
 drivers/media/{video => usb}/uvc/uvc_isight.c      |  0
 drivers/media/{video => usb}/uvc/uvc_queue.c       |  0
 drivers/media/{video => usb}/uvc/uvc_status.c      |  0
 drivers/media/{video => usb}/uvc/uvc_v4l2.c        |  0
 drivers/media/{video => usb}/uvc/uvc_video.c       |  0
 drivers/media/{video => usb}/uvc/uvcvideo.h        |  0
 drivers/media/video/Kconfig                        | 41 ----------------------
 drivers/media/video/Makefile                       | 16 ---------
 288 files changed, 67 insertions(+), 79 deletions(-)
 rename drivers/media/{video => usb}/au0828/Kconfig (100%)
 rename drivers/media/{video => usb}/au0828/Makefile (100%)
 rename drivers/media/{video => usb}/au0828/au0828-cards.c (100%)
 rename drivers/media/{video => usb}/au0828/au0828-cards.h (100%)
 rename drivers/media/{video => usb}/au0828/au0828-core.c (100%)
 rename drivers/media/{video => usb}/au0828/au0828-dvb.c (100%)
 rename drivers/media/{video => usb}/au0828/au0828-i2c.c (100%)
 rename drivers/media/{video => usb}/au0828/au0828-reg.h (100%)
 rename drivers/media/{video => usb}/au0828/au0828-vbi.c (100%)
 rename drivers/media/{video => usb}/au0828/au0828-video.c (100%)
 rename drivers/media/{video => usb}/au0828/au0828.h (100%)
 rename drivers/media/{video => usb}/cpia2/Kconfig (100%)
 rename drivers/media/{video => usb}/cpia2/Makefile (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2.h (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2_core.c (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2_registers.h (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2_usb.c (100%)
 rename drivers/media/{video => usb}/cpia2/cpia2_v4l.c (100%)
 rename drivers/media/{video => usb}/cx231xx/Kconfig (100%)
 rename drivers/media/{video => usb}/cx231xx/Makefile (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-417.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-audio.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-avcore.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-cards.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-conf-reg.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-core.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-dif.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-dvb.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-i2c.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-input.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-pcb-cfg.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-pcb-cfg.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-reg.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-vbi.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-vbi.h (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx-video.c (100%)
 rename drivers/media/{video => usb}/cx231xx/cx231xx.h (100%)
 rename drivers/media/{video => usb}/em28xx/Kconfig (100%)
 rename drivers/media/{video => usb}/em28xx/Makefile (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-audio.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-cards.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-core.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-dvb.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-i2c.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-input.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-reg.h (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-vbi.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx-video.c (100%)
 rename drivers/media/{video => usb}/em28xx/em28xx.h (100%)
 rename drivers/media/{video => usb}/gspca/Kconfig (98%)
 rename drivers/media/{video => usb}/gspca/Makefile (100%)
 rename drivers/media/{video => usb}/gspca/autogain_functions.c (100%)
 rename drivers/media/{video => usb}/gspca/autogain_functions.h (100%)
 rename drivers/media/{video => usb}/gspca/benq.c (100%)
 rename drivers/media/{video => usb}/gspca/conex.c (100%)
 rename drivers/media/{video => usb}/gspca/cpia1.c (100%)
 rename drivers/media/{video => usb}/gspca/etoms.c (100%)
 rename drivers/media/{video => usb}/gspca/finepix.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/Kconfig (100%)
 rename drivers/media/{video => usb}/gspca/gl860/Makefile (75%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860-mi1320.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860-mi2020.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860-ov2640.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860-ov9655.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860.c (100%)
 rename drivers/media/{video => usb}/gspca/gl860/gl860.h (100%)
 rename drivers/media/{video => usb}/gspca/gspca.c (100%)
 rename drivers/media/{video => usb}/gspca/gspca.h (100%)
 rename drivers/media/{video => usb}/gspca/jeilinj.c (100%)
 rename drivers/media/{video => usb}/gspca/jl2005bcd.c (100%)
 rename drivers/media/{video => usb}/gspca/jpeg.h (100%)
 rename drivers/media/{video => usb}/gspca/kinect.c (100%)
 rename drivers/media/{video => usb}/gspca/konica.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/Kconfig (100%)
 rename drivers/media/{video => usb}/gspca/m5602/Makefile (80%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_bridge.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_core.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_mt9m111.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_mt9m111.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_ov7660.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_ov7660.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_ov9650.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_ov9650.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_po1030.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_po1030.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_s5k4aa.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_s5k4aa.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_s5k83a.c (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_s5k83a.h (100%)
 rename drivers/media/{video => usb}/gspca/m5602/m5602_sensor.h (100%)
 rename drivers/media/{video => usb}/gspca/mars.c (100%)
 rename drivers/media/{video => usb}/gspca/mr97310a.c (100%)
 rename drivers/media/{video => usb}/gspca/nw80x.c (100%)
 rename drivers/media/{video => usb}/gspca/ov519.c (100%)
 rename drivers/media/{video => usb}/gspca/ov534.c (100%)
 rename drivers/media/{video => usb}/gspca/ov534_9.c (100%)
 rename drivers/media/{video => usb}/gspca/pac207.c (100%)
 rename drivers/media/{video => usb}/gspca/pac7302.c (100%)
 rename drivers/media/{video => usb}/gspca/pac7311.c (100%)
 rename drivers/media/{video => usb}/gspca/pac_common.h (100%)
 rename drivers/media/{video => usb}/gspca/se401.c (100%)
 rename drivers/media/{video => usb}/gspca/se401.h (100%)
 rename drivers/media/{video => usb}/gspca/sn9c2028.c (100%)
 rename drivers/media/{video => usb}/gspca/sn9c2028.h (100%)
 rename drivers/media/{video => usb}/gspca/sn9c20x.c (100%)
 rename drivers/media/{video => usb}/gspca/sonixb.c (100%)
 rename drivers/media/{video => usb}/gspca/sonixj.c (100%)
 rename drivers/media/{video => usb}/gspca/spca1528.c (100%)
 rename drivers/media/{video => usb}/gspca/spca500.c (100%)
 rename drivers/media/{video => usb}/gspca/spca501.c (100%)
 rename drivers/media/{video => usb}/gspca/spca505.c (100%)
 rename drivers/media/{video => usb}/gspca/spca506.c (100%)
 rename drivers/media/{video => usb}/gspca/spca508.c (100%)
 rename drivers/media/{video => usb}/gspca/spca561.c (100%)
 rename drivers/media/{video => usb}/gspca/sq905.c (100%)
 rename drivers/media/{video => usb}/gspca/sq905c.c (100%)
 rename drivers/media/{video => usb}/gspca/sq930x.c (100%)
 rename drivers/media/{video => usb}/gspca/stk014.c (100%)
 rename drivers/media/{video => usb}/gspca/stv0680.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/Kconfig (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/Makefile (78%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_hdcs.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_hdcs.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_pb0100.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_pb0100.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_sensor.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_st6422.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_st6422.h (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_vv6410.c (100%)
 rename drivers/media/{video => usb}/gspca/stv06xx/stv06xx_vv6410.h (100%)
 rename drivers/media/{video => usb}/gspca/sunplus.c (100%)
 rename drivers/media/{video => usb}/gspca/t613.c (100%)
 rename drivers/media/{video => usb}/gspca/topro.c (100%)
 rename drivers/media/{video => usb}/gspca/tv8532.c (100%)
 rename drivers/media/{video => usb}/gspca/vc032x.c (100%)
 rename drivers/media/{video => usb}/gspca/vicam.c (100%)
 rename drivers/media/{video => usb}/gspca/w996Xcf.c (100%)
 rename drivers/media/{video => usb}/gspca/xirlink_cit.c (100%)
 rename drivers/media/{video => usb}/gspca/zc3xx-reg.h (100%)
 rename drivers/media/{video => usb}/gspca/zc3xx.c (100%)
 rename drivers/media/{video => usb}/hdpvr/Kconfig (100%)
 rename drivers/media/{video => usb}/hdpvr/Makefile (100%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr-control.c (100%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr-core.c (100%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr-i2c.c (100%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr-video.c (100%)
 rename drivers/media/{video => usb}/hdpvr/hdpvr.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/Kconfig (100%)
 rename drivers/media/{video => usb}/pvrusb2/Makefile (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-audio.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-audio.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-context.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-context.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-cs53l32a.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-cs53l32a.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-ctrl.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-ctrl.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-cx2584x-v4l.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-cx2584x-v4l.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-debug.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-debugifc.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-debugifc.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-devattr.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-devattr.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-dvb.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-dvb.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-eeprom.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-eeprom.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-encoder.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-encoder.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-fx2-cmd.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw-internal.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-hdw.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-i2c-core.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-i2c-core.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-io.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-io.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-ioread.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-ioread.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-main.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-std.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-std.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-sysfs.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-sysfs.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-util.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-v4l2.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-v4l2.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-video-v4l.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-video-v4l.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-wm8775.c (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2-wm8775.h (100%)
 rename drivers/media/{video => usb}/pvrusb2/pvrusb2.h (100%)
 rename drivers/media/{video => usb}/pwc/Kconfig (100%)
 rename drivers/media/{video => usb}/pwc/Makefile (100%)
 rename drivers/media/{video => usb}/pwc/philips.txt (100%)
 rename drivers/media/{video => usb}/pwc/pwc-ctrl.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-dec1.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-dec1.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-dec23.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-dec23.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-if.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-kiara.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-kiara.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-misc.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-nala.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-timon.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-timon.h (100%)
 rename drivers/media/{video => usb}/pwc/pwc-uncompress.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc-v4l.c (100%)
 rename drivers/media/{video => usb}/pwc/pwc.h (100%)
 rename drivers/media/{video => usb}/sn9c102/Kconfig (100%)
 rename drivers/media/{video => usb}/sn9c102/Makefile (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102.h (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_config.h (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_core.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_devtable.h (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_hv7131d.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_hv7131r.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_mi0343.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_mi0360.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_mt9v111.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_ov7630.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_ov7660.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_pas106b.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_pas202bcb.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_sensor.h (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_tas5110c1b.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_tas5110d.c (100%)
 rename drivers/media/{video => usb}/sn9c102/sn9c102_tas5130d1b.c (100%)
 rename drivers/media/{video => usb}/stk1160/Kconfig (100%)
 rename drivers/media/{video => usb}/stk1160/Makefile (100%)
 rename drivers/media/{video => usb}/stk1160/stk1160-ac97.c (100%)
 rename drivers/media/{video => usb}/stk1160/stk1160-core.c (100%)
 rename drivers/media/{video => usb}/stk1160/stk1160-i2c.c (100%)
 rename drivers/media/{video => usb}/stk1160/stk1160-reg.h (100%)
 rename drivers/media/{video => usb}/stk1160/stk1160-v4l.c (100%)
 rename drivers/media/{video => usb}/stk1160/stk1160-video.c (100%)
 rename drivers/media/{video => usb}/stk1160/stk1160.h (100%)
 rename drivers/media/{video => usb}/tlg2300/Kconfig (100%)
 rename drivers/media/{video => usb}/tlg2300/Makefile (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-alsa.c (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-common.h (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-dvb.c (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-main.c (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-radio.c (100%)
 rename drivers/media/{video => usb}/tlg2300/pd-video.c (100%)
 rename drivers/media/{video => usb}/tlg2300/vendorcmds.h (100%)
 rename drivers/media/{video => usb}/tm6000/Kconfig (100%)
 rename drivers/media/{video => usb}/tm6000/Makefile (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-alsa.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-cards.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-core.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-dvb.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-i2c.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-input.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-regs.h (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-stds.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-usb-isoc.h (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000-video.c (100%)
 rename drivers/media/{video => usb}/tm6000/tm6000.h (100%)
 rename drivers/media/{video => usb}/usbvision/Kconfig (100%)
 rename drivers/media/{video => usb}/usbvision/Makefile (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-cards.c (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-cards.h (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-core.c (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-i2c.c (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision-video.c (100%)
 rename drivers/media/{video => usb}/usbvision/usbvision.h (100%)
 rename drivers/media/{video => usb}/uvc/Kconfig (100%)
 rename drivers/media/{video => usb}/uvc/Makefile (100%)
 rename drivers/media/{video => usb}/uvc/uvc_ctrl.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_debugfs.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_driver.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_entity.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_isight.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_queue.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_status.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_v4l2.c (100%)
 rename drivers/media/{video => usb}/uvc/uvc_video.c (100%)
 rename drivers/media/{video => usb}/uvc/uvcvideo.h (100%)

diff --git a/MAINTAINERS b/MAINTAINERS
index ceb5b55..13fd97f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3119,49 +3119,49 @@ M:	Frank Zago <frank@zago.net>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	drivers/media/video/gspca/finepix.c
+F:	drivers/media/usb/gspca/finepix.c
 
 GSPCA GL860 SUBDRIVER
 M:	Olivier Lorin <o.lorin@laposte.net>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	drivers/media/video/gspca/gl860/
+F:	drivers/media/usb/gspca/gl860/
 
 GSPCA M5602 SUBDRIVER
 M:	Erik Andren <erik.andren@gmail.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	drivers/media/video/gspca/m5602/
+F:	drivers/media/usb/gspca/m5602/
 
 GSPCA PAC207 SONIXB SUBDRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	drivers/media/video/gspca/pac207.c
+F:	drivers/media/usb/gspca/pac207.c
 
 GSPCA SN9C20X SUBDRIVER
 M:	Brian Johnson <brijohn@gmail.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	drivers/media/video/gspca/sn9c20x.c
+F:	drivers/media/usb/gspca/sn9c20x.c
 
 GSPCA T613 SUBDRIVER
 M:	Leandro Costantino <lcostantino@gmail.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	drivers/media/video/gspca/t613.c
+F:	drivers/media/usb/gspca/t613.c
 
 GSPCA USB WEBCAM DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
-F:	drivers/media/video/gspca/
+F:	drivers/media/usb/gspca/
 
 HARD DRIVE ACTIVE PROTECTION SYSTEM (HDAPS) DRIVER
 M:	Frank Seidel <frank@f-seidel.de>
@@ -5525,7 +5525,7 @@ W:	http://www.isely.net/pvrusb2/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 S:	Maintained
 F:	Documentation/video4linux/README.pvrusb2
-F:	drivers/media/video/pvrusb2/
+F:	drivers/media/usb/pvrusb2/
 
 PWM SUBSYSTEM
 M:	Thierry Reding <thierry.reding@avionic-design.de>
@@ -5956,7 +5956,7 @@ M:	Huang Shijie <shijie8@gmail.com>
 M:	Kang Yong <kangyong@telegent.com>
 M:	Zhang Xiaobing <xbzhang@telegent.com>
 S:	Supported
-F:	drivers/media/video/tlg2300
+F:	drivers/media/usb/tlg2300
 
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
@@ -7297,7 +7297,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.linux-projects.org
 S:	Maintained
 F:	Documentation/video4linux/sn9c102.txt
-F:	drivers/media/video/sn9c102/
+F:	drivers/media/usb/sn9c102/
 
 USB SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
@@ -7332,7 +7332,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media.git
 W:	http://www.ideasonboard.org/uvc/
 S:	Maintained
-F:	drivers/media/video/uvc/
+F:	drivers/media/usb/uvc/
 
 USB W996[87]CF DRIVER
 M:	Luca Risolia <luca.risolia@studio.unibo.it>
diff --git a/drivers/media/usb/Kconfig b/drivers/media/usb/Kconfig
index 53664b3..e1cb51f 100644
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -2,18 +2,49 @@
 # USB media device configuration
 #
 
-menuconfig MEDIA_USB_DRIVERS
-	bool "Supported DVB USB Adapters"
-        depends on USB
-        default y
+menu "Media USB Adapters"
+	visible if USB && MEDIA_SUPPORT
 
-if MEDIA_USB_DRIVERS && DVB_CORE && I2C
+if MEDIA_CAMERA_SUPPORT
+	comment "Webcam devices"
+source "drivers/media/usb/uvc/Kconfig"
+source "drivers/media/usb/gspca/Kconfig"
+source "drivers/media/usb/pwc/Kconfig"
+source "drivers/media/usb/cpia2/Kconfig"
+source "drivers/media/usb/sn9c102/Kconfig"
+endif
+
+if MEDIA_ANALOG_TV_SUPPORT
+	comment "Analog TV USB devices"
+source "drivers/media/usb/au0828/Kconfig"
+source "drivers/media/usb/pvrusb2/Kconfig"
+source "drivers/media/usb/hdpvr/Kconfig"
+source "drivers/media/usb/tlg2300/Kconfig"
+source "drivers/media/usb/usbvision/Kconfig"
+source "drivers/media/usb/stk1160/Kconfig"
 
+endif
+
+if (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
+	comment "Analog/digital TV USB devices"
+source "drivers/media/usb/cx231xx/Kconfig"
+source "drivers/media/usb/tm6000/Kconfig"
+endif
+
+
+if MEDIA_USB_DRIVERS && I2C && MEDIA_DIGITAL_TV_SUPPORT
+	comment "Digital TV USB devices"
 source "drivers/media/usb/dvb-usb/Kconfig"
 source "drivers/media/usb/dvb-usb-v2/Kconfig"
 source "drivers/media/usb/ttusb-budget/Kconfig"
 source "drivers/media/usb/ttusb-dec/Kconfig"
 source "drivers/media/usb/siano/Kconfig"
 source "drivers/media/usb/b2c2/Kconfig"
+endif
 
+if (MEDIA_CAMERA_SUPPORT || MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT)
+	comment "Webcam, TV (analog/digital) USB devices"
+source "drivers/media/usb/em28xx/Kconfig"
 endif
+
+endmenu
diff --git a/drivers/media/usb/Makefile b/drivers/media/usb/Makefile
index 6b30ad1..428827a 100644
--- a/drivers/media/usb/Makefile
+++ b/drivers/media/usb/Makefile
@@ -4,3 +4,17 @@
 
 # DVB USB-only drivers
 obj-y := ttusb-dec/ ttusb-budget/ dvb-usb/ dvb-usb-v2/ siano/ b2c2/
+obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
+obj-$(CONFIG_USB_GSPCA)         += gspca/
+obj-$(CONFIG_USB_PWC)           += pwc/
+obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
+obj-$(CONFIG_USB_SN9C102)       += sn9c102/
+obj-$(CONFIG_VIDEO_AU0828) += au0828/
+obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
+obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
+obj-$(CONFIG_VIDEO_TLG2300) += tlg2300/
+obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
+obj-$(CONFIG_VIDEO_STK1160) += stk1160/
+obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
+obj-$(CONFIG_VIDEO_TM6000) += tm6000/
+obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
diff --git a/drivers/media/video/au0828/Kconfig b/drivers/media/usb/au0828/Kconfig
similarity index 100%
rename from drivers/media/video/au0828/Kconfig
rename to drivers/media/usb/au0828/Kconfig
diff --git a/drivers/media/video/au0828/Makefile b/drivers/media/usb/au0828/Makefile
similarity index 100%
rename from drivers/media/video/au0828/Makefile
rename to drivers/media/usb/au0828/Makefile
diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-cards.c
rename to drivers/media/usb/au0828/au0828-cards.c
diff --git a/drivers/media/video/au0828/au0828-cards.h b/drivers/media/usb/au0828/au0828-cards.h
similarity index 100%
rename from drivers/media/video/au0828/au0828-cards.h
rename to drivers/media/usb/au0828/au0828-cards.h
diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-core.c
rename to drivers/media/usb/au0828/au0828-core.c
diff --git a/drivers/media/video/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-dvb.c
rename to drivers/media/usb/au0828/au0828-dvb.c
diff --git a/drivers/media/video/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-i2c.c
rename to drivers/media/usb/au0828/au0828-i2c.c
diff --git a/drivers/media/video/au0828/au0828-reg.h b/drivers/media/usb/au0828/au0828-reg.h
similarity index 100%
rename from drivers/media/video/au0828/au0828-reg.h
rename to drivers/media/usb/au0828/au0828-reg.h
diff --git a/drivers/media/video/au0828/au0828-vbi.c b/drivers/media/usb/au0828/au0828-vbi.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-vbi.c
rename to drivers/media/usb/au0828/au0828-vbi.c
diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
similarity index 100%
rename from drivers/media/video/au0828/au0828-video.c
rename to drivers/media/usb/au0828/au0828-video.c
diff --git a/drivers/media/video/au0828/au0828.h b/drivers/media/usb/au0828/au0828.h
similarity index 100%
rename from drivers/media/video/au0828/au0828.h
rename to drivers/media/usb/au0828/au0828.h
diff --git a/drivers/media/video/cpia2/Kconfig b/drivers/media/usb/cpia2/Kconfig
similarity index 100%
rename from drivers/media/video/cpia2/Kconfig
rename to drivers/media/usb/cpia2/Kconfig
diff --git a/drivers/media/video/cpia2/Makefile b/drivers/media/usb/cpia2/Makefile
similarity index 100%
rename from drivers/media/video/cpia2/Makefile
rename to drivers/media/usb/cpia2/Makefile
diff --git a/drivers/media/video/cpia2/cpia2.h b/drivers/media/usb/cpia2/cpia2.h
similarity index 100%
rename from drivers/media/video/cpia2/cpia2.h
rename to drivers/media/usb/cpia2/cpia2.h
diff --git a/drivers/media/video/cpia2/cpia2_core.c b/drivers/media/usb/cpia2/cpia2_core.c
similarity index 100%
rename from drivers/media/video/cpia2/cpia2_core.c
rename to drivers/media/usb/cpia2/cpia2_core.c
diff --git a/drivers/media/video/cpia2/cpia2_registers.h b/drivers/media/usb/cpia2/cpia2_registers.h
similarity index 100%
rename from drivers/media/video/cpia2/cpia2_registers.h
rename to drivers/media/usb/cpia2/cpia2_registers.h
diff --git a/drivers/media/video/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
similarity index 100%
rename from drivers/media/video/cpia2/cpia2_usb.c
rename to drivers/media/usb/cpia2/cpia2_usb.c
diff --git a/drivers/media/video/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
similarity index 100%
rename from drivers/media/video/cpia2/cpia2_v4l.c
rename to drivers/media/usb/cpia2/cpia2_v4l.c
diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
similarity index 100%
rename from drivers/media/video/cx231xx/Kconfig
rename to drivers/media/usb/cx231xx/Kconfig
diff --git a/drivers/media/video/cx231xx/Makefile b/drivers/media/usb/cx231xx/Makefile
similarity index 100%
rename from drivers/media/video/cx231xx/Makefile
rename to drivers/media/usb/cx231xx/Makefile
diff --git a/drivers/media/video/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-417.c
rename to drivers/media/usb/cx231xx/cx231xx-417.c
diff --git a/drivers/media/video/cx231xx/cx231xx-audio.c b/drivers/media/usb/cx231xx/cx231xx-audio.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-audio.c
rename to drivers/media/usb/cx231xx/cx231xx-audio.c
diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c b/drivers/media/usb/cx231xx/cx231xx-avcore.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-avcore.c
rename to drivers/media/usb/cx231xx/cx231xx-avcore.c
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-cards.c
rename to drivers/media/usb/cx231xx/cx231xx-cards.c
diff --git a/drivers/media/video/cx231xx/cx231xx-conf-reg.h b/drivers/media/usb/cx231xx/cx231xx-conf-reg.h
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-conf-reg.h
rename to drivers/media/usb/cx231xx/cx231xx-conf-reg.h
diff --git a/drivers/media/video/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-core.c
rename to drivers/media/usb/cx231xx/cx231xx-core.c
diff --git a/drivers/media/video/cx231xx/cx231xx-dif.h b/drivers/media/usb/cx231xx/cx231xx-dif.h
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-dif.h
rename to drivers/media/usb/cx231xx/cx231xx-dif.h
diff --git a/drivers/media/video/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-dvb.c
rename to drivers/media/usb/cx231xx/cx231xx-dvb.c
diff --git a/drivers/media/video/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-i2c.c
rename to drivers/media/usb/cx231xx/cx231xx-i2c.c
diff --git a/drivers/media/video/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-input.c
rename to drivers/media/usb/cx231xx/cx231xx-input.c
diff --git a/drivers/media/video/cx231xx/cx231xx-pcb-cfg.c b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-pcb-cfg.c
rename to drivers/media/usb/cx231xx/cx231xx-pcb-cfg.c
diff --git a/drivers/media/video/cx231xx/cx231xx-pcb-cfg.h b/drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-pcb-cfg.h
rename to drivers/media/usb/cx231xx/cx231xx-pcb-cfg.h
diff --git a/drivers/media/video/cx231xx/cx231xx-reg.h b/drivers/media/usb/cx231xx/cx231xx-reg.h
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-reg.h
rename to drivers/media/usb/cx231xx/cx231xx-reg.h
diff --git a/drivers/media/video/cx231xx/cx231xx-vbi.c b/drivers/media/usb/cx231xx/cx231xx-vbi.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-vbi.c
rename to drivers/media/usb/cx231xx/cx231xx-vbi.c
diff --git a/drivers/media/video/cx231xx/cx231xx-vbi.h b/drivers/media/usb/cx231xx/cx231xx-vbi.h
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-vbi.h
rename to drivers/media/usb/cx231xx/cx231xx-vbi.h
diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx-video.c
rename to drivers/media/usb/cx231xx/cx231xx-video.c
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
similarity index 100%
rename from drivers/media/video/cx231xx/cx231xx.h
rename to drivers/media/usb/cx231xx/cx231xx.h
diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/usb/em28xx/Kconfig
similarity index 100%
rename from drivers/media/video/em28xx/Kconfig
rename to drivers/media/usb/em28xx/Kconfig
diff --git a/drivers/media/video/em28xx/Makefile b/drivers/media/usb/em28xx/Makefile
similarity index 100%
rename from drivers/media/video/em28xx/Makefile
rename to drivers/media/usb/em28xx/Makefile
diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-audio.c
rename to drivers/media/usb/em28xx/em28xx-audio.c
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-cards.c
rename to drivers/media/usb/em28xx/em28xx-cards.c
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-core.c
rename to drivers/media/usb/em28xx/em28xx-core.c
diff --git a/drivers/media/video/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-dvb.c
rename to drivers/media/usb/em28xx/em28xx-dvb.c
diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-i2c.c
rename to drivers/media/usb/em28xx/em28xx-i2c.c
diff --git a/drivers/media/video/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-input.c
rename to drivers/media/usb/em28xx/em28xx-input.c
diff --git a/drivers/media/video/em28xx/em28xx-reg.h b/drivers/media/usb/em28xx/em28xx-reg.h
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-reg.h
rename to drivers/media/usb/em28xx/em28xx-reg.h
diff --git a/drivers/media/video/em28xx/em28xx-vbi.c b/drivers/media/usb/em28xx/em28xx-vbi.c
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-vbi.c
rename to drivers/media/usb/em28xx/em28xx-vbi.c
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
similarity index 100%
rename from drivers/media/video/em28xx/em28xx-video.c
rename to drivers/media/usb/em28xx/em28xx-video.c
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
similarity index 100%
rename from drivers/media/video/em28xx/em28xx.h
rename to drivers/media/usb/em28xx/em28xx.h
diff --git a/drivers/media/video/gspca/Kconfig b/drivers/media/usb/gspca/Kconfig
similarity index 98%
rename from drivers/media/video/gspca/Kconfig
rename to drivers/media/usb/gspca/Kconfig
index dfe268b..6345f93 100644
--- a/drivers/media/video/gspca/Kconfig
+++ b/drivers/media/usb/gspca/Kconfig
@@ -17,9 +17,9 @@ menuconfig USB_GSPCA
 
 if USB_GSPCA && VIDEO_V4L2
 
-source "drivers/media/video/gspca/m5602/Kconfig"
-source "drivers/media/video/gspca/stv06xx/Kconfig"
-source "drivers/media/video/gspca/gl860/Kconfig"
+source "drivers/media/usb/gspca/m5602/Kconfig"
+source "drivers/media/usb/gspca/stv06xx/Kconfig"
+source "drivers/media/usb/gspca/gl860/Kconfig"
 
 config USB_GSPCA_BENQ
 	tristate "Benq USB Camera Driver"
diff --git a/drivers/media/video/gspca/Makefile b/drivers/media/usb/gspca/Makefile
similarity index 100%
rename from drivers/media/video/gspca/Makefile
rename to drivers/media/usb/gspca/Makefile
diff --git a/drivers/media/video/gspca/autogain_functions.c b/drivers/media/usb/gspca/autogain_functions.c
similarity index 100%
rename from drivers/media/video/gspca/autogain_functions.c
rename to drivers/media/usb/gspca/autogain_functions.c
diff --git a/drivers/media/video/gspca/autogain_functions.h b/drivers/media/usb/gspca/autogain_functions.h
similarity index 100%
rename from drivers/media/video/gspca/autogain_functions.h
rename to drivers/media/usb/gspca/autogain_functions.h
diff --git a/drivers/media/video/gspca/benq.c b/drivers/media/usb/gspca/benq.c
similarity index 100%
rename from drivers/media/video/gspca/benq.c
rename to drivers/media/usb/gspca/benq.c
diff --git a/drivers/media/video/gspca/conex.c b/drivers/media/usb/gspca/conex.c
similarity index 100%
rename from drivers/media/video/gspca/conex.c
rename to drivers/media/usb/gspca/conex.c
diff --git a/drivers/media/video/gspca/cpia1.c b/drivers/media/usb/gspca/cpia1.c
similarity index 100%
rename from drivers/media/video/gspca/cpia1.c
rename to drivers/media/usb/gspca/cpia1.c
diff --git a/drivers/media/video/gspca/etoms.c b/drivers/media/usb/gspca/etoms.c
similarity index 100%
rename from drivers/media/video/gspca/etoms.c
rename to drivers/media/usb/gspca/etoms.c
diff --git a/drivers/media/video/gspca/finepix.c b/drivers/media/usb/gspca/finepix.c
similarity index 100%
rename from drivers/media/video/gspca/finepix.c
rename to drivers/media/usb/gspca/finepix.c
diff --git a/drivers/media/video/gspca/gl860/Kconfig b/drivers/media/usb/gspca/gl860/Kconfig
similarity index 100%
rename from drivers/media/video/gspca/gl860/Kconfig
rename to drivers/media/usb/gspca/gl860/Kconfig
diff --git a/drivers/media/video/gspca/gl860/Makefile b/drivers/media/usb/gspca/gl860/Makefile
similarity index 75%
rename from drivers/media/video/gspca/gl860/Makefile
rename to drivers/media/usb/gspca/gl860/Makefile
index 773ea34..cf63974 100644
--- a/drivers/media/video/gspca/gl860/Makefile
+++ b/drivers/media/usb/gspca/gl860/Makefile
@@ -6,5 +6,5 @@ gspca_gl860-objs := gl860.o \
 		    gl860-ov9655.o \
 		    gl860-mi2020.o
 
-ccflags-y += -I$(srctree)/drivers/media/video/gspca
+ccflags-y += -I$(srctree)/drivers/media/usb/gspca
 
diff --git a/drivers/media/video/gspca/gl860/gl860-mi1320.c b/drivers/media/usb/gspca/gl860/gl860-mi1320.c
similarity index 100%
rename from drivers/media/video/gspca/gl860/gl860-mi1320.c
rename to drivers/media/usb/gspca/gl860/gl860-mi1320.c
diff --git a/drivers/media/video/gspca/gl860/gl860-mi2020.c b/drivers/media/usb/gspca/gl860/gl860-mi2020.c
similarity index 100%
rename from drivers/media/video/gspca/gl860/gl860-mi2020.c
rename to drivers/media/usb/gspca/gl860/gl860-mi2020.c
diff --git a/drivers/media/video/gspca/gl860/gl860-ov2640.c b/drivers/media/usb/gspca/gl860/gl860-ov2640.c
similarity index 100%
rename from drivers/media/video/gspca/gl860/gl860-ov2640.c
rename to drivers/media/usb/gspca/gl860/gl860-ov2640.c
diff --git a/drivers/media/video/gspca/gl860/gl860-ov9655.c b/drivers/media/usb/gspca/gl860/gl860-ov9655.c
similarity index 100%
rename from drivers/media/video/gspca/gl860/gl860-ov9655.c
rename to drivers/media/usb/gspca/gl860/gl860-ov9655.c
diff --git a/drivers/media/video/gspca/gl860/gl860.c b/drivers/media/usb/gspca/gl860/gl860.c
similarity index 100%
rename from drivers/media/video/gspca/gl860/gl860.c
rename to drivers/media/usb/gspca/gl860/gl860.c
diff --git a/drivers/media/video/gspca/gl860/gl860.h b/drivers/media/usb/gspca/gl860/gl860.h
similarity index 100%
rename from drivers/media/video/gspca/gl860/gl860.h
rename to drivers/media/usb/gspca/gl860/gl860.h
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
similarity index 100%
rename from drivers/media/video/gspca/gspca.c
rename to drivers/media/usb/gspca/gspca.c
diff --git a/drivers/media/video/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
similarity index 100%
rename from drivers/media/video/gspca/gspca.h
rename to drivers/media/usb/gspca/gspca.h
diff --git a/drivers/media/video/gspca/jeilinj.c b/drivers/media/usb/gspca/jeilinj.c
similarity index 100%
rename from drivers/media/video/gspca/jeilinj.c
rename to drivers/media/usb/gspca/jeilinj.c
diff --git a/drivers/media/video/gspca/jl2005bcd.c b/drivers/media/usb/gspca/jl2005bcd.c
similarity index 100%
rename from drivers/media/video/gspca/jl2005bcd.c
rename to drivers/media/usb/gspca/jl2005bcd.c
diff --git a/drivers/media/video/gspca/jpeg.h b/drivers/media/usb/gspca/jpeg.h
similarity index 100%
rename from drivers/media/video/gspca/jpeg.h
rename to drivers/media/usb/gspca/jpeg.h
diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
similarity index 100%
rename from drivers/media/video/gspca/kinect.c
rename to drivers/media/usb/gspca/kinect.c
diff --git a/drivers/media/video/gspca/konica.c b/drivers/media/usb/gspca/konica.c
similarity index 100%
rename from drivers/media/video/gspca/konica.c
rename to drivers/media/usb/gspca/konica.c
diff --git a/drivers/media/video/gspca/m5602/Kconfig b/drivers/media/usb/gspca/m5602/Kconfig
similarity index 100%
rename from drivers/media/video/gspca/m5602/Kconfig
rename to drivers/media/usb/gspca/m5602/Kconfig
diff --git a/drivers/media/video/gspca/m5602/Makefile b/drivers/media/usb/gspca/m5602/Makefile
similarity index 80%
rename from drivers/media/video/gspca/m5602/Makefile
rename to drivers/media/usb/gspca/m5602/Makefile
index 575b75b..8e1fb5a 100644
--- a/drivers/media/video/gspca/m5602/Makefile
+++ b/drivers/media/usb/gspca/m5602/Makefile
@@ -8,4 +8,4 @@ gspca_m5602-objs := m5602_core.o \
 		    m5602_s5k83a.o \
 		    m5602_s5k4aa.o
 
-ccflags-y += -I$(srctree)/drivers/media/video/gspca
+ccflags-y += -I$(srctree)/drivers/media/usb/gspca
diff --git a/drivers/media/video/gspca/m5602/m5602_bridge.h b/drivers/media/usb/gspca/m5602/m5602_bridge.h
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_bridge.h
rename to drivers/media/usb/gspca/m5602/m5602_bridge.h
diff --git a/drivers/media/video/gspca/m5602/m5602_core.c b/drivers/media/usb/gspca/m5602/m5602_core.c
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_core.c
rename to drivers/media/usb/gspca/m5602/m5602_core.c
diff --git a/drivers/media/video/gspca/m5602/m5602_mt9m111.c b/drivers/media/usb/gspca/m5602/m5602_mt9m111.c
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_mt9m111.c
rename to drivers/media/usb/gspca/m5602/m5602_mt9m111.c
diff --git a/drivers/media/video/gspca/m5602/m5602_mt9m111.h b/drivers/media/usb/gspca/m5602/m5602_mt9m111.h
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_mt9m111.h
rename to drivers/media/usb/gspca/m5602/m5602_mt9m111.h
diff --git a/drivers/media/video/gspca/m5602/m5602_ov7660.c b/drivers/media/usb/gspca/m5602/m5602_ov7660.c
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_ov7660.c
rename to drivers/media/usb/gspca/m5602/m5602_ov7660.c
diff --git a/drivers/media/video/gspca/m5602/m5602_ov7660.h b/drivers/media/usb/gspca/m5602/m5602_ov7660.h
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_ov7660.h
rename to drivers/media/usb/gspca/m5602/m5602_ov7660.h
diff --git a/drivers/media/video/gspca/m5602/m5602_ov9650.c b/drivers/media/usb/gspca/m5602/m5602_ov9650.c
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_ov9650.c
rename to drivers/media/usb/gspca/m5602/m5602_ov9650.c
diff --git a/drivers/media/video/gspca/m5602/m5602_ov9650.h b/drivers/media/usb/gspca/m5602/m5602_ov9650.h
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_ov9650.h
rename to drivers/media/usb/gspca/m5602/m5602_ov9650.h
diff --git a/drivers/media/video/gspca/m5602/m5602_po1030.c b/drivers/media/usb/gspca/m5602/m5602_po1030.c
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_po1030.c
rename to drivers/media/usb/gspca/m5602/m5602_po1030.c
diff --git a/drivers/media/video/gspca/m5602/m5602_po1030.h b/drivers/media/usb/gspca/m5602/m5602_po1030.h
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_po1030.h
rename to drivers/media/usb/gspca/m5602/m5602_po1030.h
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.c b/drivers/media/usb/gspca/m5602/m5602_s5k4aa.c
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_s5k4aa.c
rename to drivers/media/usb/gspca/m5602/m5602_s5k4aa.c
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k4aa.h b/drivers/media/usb/gspca/m5602/m5602_s5k4aa.h
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_s5k4aa.h
rename to drivers/media/usb/gspca/m5602/m5602_s5k4aa.h
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k83a.c b/drivers/media/usb/gspca/m5602/m5602_s5k83a.c
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_s5k83a.c
rename to drivers/media/usb/gspca/m5602/m5602_s5k83a.c
diff --git a/drivers/media/video/gspca/m5602/m5602_s5k83a.h b/drivers/media/usb/gspca/m5602/m5602_s5k83a.h
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_s5k83a.h
rename to drivers/media/usb/gspca/m5602/m5602_s5k83a.h
diff --git a/drivers/media/video/gspca/m5602/m5602_sensor.h b/drivers/media/usb/gspca/m5602/m5602_sensor.h
similarity index 100%
rename from drivers/media/video/gspca/m5602/m5602_sensor.h
rename to drivers/media/usb/gspca/m5602/m5602_sensor.h
diff --git a/drivers/media/video/gspca/mars.c b/drivers/media/usb/gspca/mars.c
similarity index 100%
rename from drivers/media/video/gspca/mars.c
rename to drivers/media/usb/gspca/mars.c
diff --git a/drivers/media/video/gspca/mr97310a.c b/drivers/media/usb/gspca/mr97310a.c
similarity index 100%
rename from drivers/media/video/gspca/mr97310a.c
rename to drivers/media/usb/gspca/mr97310a.c
diff --git a/drivers/media/video/gspca/nw80x.c b/drivers/media/usb/gspca/nw80x.c
similarity index 100%
rename from drivers/media/video/gspca/nw80x.c
rename to drivers/media/usb/gspca/nw80x.c
diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
similarity index 100%
rename from drivers/media/video/gspca/ov519.c
rename to drivers/media/usb/gspca/ov519.c
diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/usb/gspca/ov534.c
similarity index 100%
rename from drivers/media/video/gspca/ov534.c
rename to drivers/media/usb/gspca/ov534.c
diff --git a/drivers/media/video/gspca/ov534_9.c b/drivers/media/usb/gspca/ov534_9.c
similarity index 100%
rename from drivers/media/video/gspca/ov534_9.c
rename to drivers/media/usb/gspca/ov534_9.c
diff --git a/drivers/media/video/gspca/pac207.c b/drivers/media/usb/gspca/pac207.c
similarity index 100%
rename from drivers/media/video/gspca/pac207.c
rename to drivers/media/usb/gspca/pac207.c
diff --git a/drivers/media/video/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
similarity index 100%
rename from drivers/media/video/gspca/pac7302.c
rename to drivers/media/usb/gspca/pac7302.c
diff --git a/drivers/media/video/gspca/pac7311.c b/drivers/media/usb/gspca/pac7311.c
similarity index 100%
rename from drivers/media/video/gspca/pac7311.c
rename to drivers/media/usb/gspca/pac7311.c
diff --git a/drivers/media/video/gspca/pac_common.h b/drivers/media/usb/gspca/pac_common.h
similarity index 100%
rename from drivers/media/video/gspca/pac_common.h
rename to drivers/media/usb/gspca/pac_common.h
diff --git a/drivers/media/video/gspca/se401.c b/drivers/media/usb/gspca/se401.c
similarity index 100%
rename from drivers/media/video/gspca/se401.c
rename to drivers/media/usb/gspca/se401.c
diff --git a/drivers/media/video/gspca/se401.h b/drivers/media/usb/gspca/se401.h
similarity index 100%
rename from drivers/media/video/gspca/se401.h
rename to drivers/media/usb/gspca/se401.h
diff --git a/drivers/media/video/gspca/sn9c2028.c b/drivers/media/usb/gspca/sn9c2028.c
similarity index 100%
rename from drivers/media/video/gspca/sn9c2028.c
rename to drivers/media/usb/gspca/sn9c2028.c
diff --git a/drivers/media/video/gspca/sn9c2028.h b/drivers/media/usb/gspca/sn9c2028.h
similarity index 100%
rename from drivers/media/video/gspca/sn9c2028.h
rename to drivers/media/usb/gspca/sn9c2028.h
diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
similarity index 100%
rename from drivers/media/video/gspca/sn9c20x.c
rename to drivers/media/usb/gspca/sn9c20x.c
diff --git a/drivers/media/video/gspca/sonixb.c b/drivers/media/usb/gspca/sonixb.c
similarity index 100%
rename from drivers/media/video/gspca/sonixb.c
rename to drivers/media/usb/gspca/sonixb.c
diff --git a/drivers/media/video/gspca/sonixj.c b/drivers/media/usb/gspca/sonixj.c
similarity index 100%
rename from drivers/media/video/gspca/sonixj.c
rename to drivers/media/usb/gspca/sonixj.c
diff --git a/drivers/media/video/gspca/spca1528.c b/drivers/media/usb/gspca/spca1528.c
similarity index 100%
rename from drivers/media/video/gspca/spca1528.c
rename to drivers/media/usb/gspca/spca1528.c
diff --git a/drivers/media/video/gspca/spca500.c b/drivers/media/usb/gspca/spca500.c
similarity index 100%
rename from drivers/media/video/gspca/spca500.c
rename to drivers/media/usb/gspca/spca500.c
diff --git a/drivers/media/video/gspca/spca501.c b/drivers/media/usb/gspca/spca501.c
similarity index 100%
rename from drivers/media/video/gspca/spca501.c
rename to drivers/media/usb/gspca/spca501.c
diff --git a/drivers/media/video/gspca/spca505.c b/drivers/media/usb/gspca/spca505.c
similarity index 100%
rename from drivers/media/video/gspca/spca505.c
rename to drivers/media/usb/gspca/spca505.c
diff --git a/drivers/media/video/gspca/spca506.c b/drivers/media/usb/gspca/spca506.c
similarity index 100%
rename from drivers/media/video/gspca/spca506.c
rename to drivers/media/usb/gspca/spca506.c
diff --git a/drivers/media/video/gspca/spca508.c b/drivers/media/usb/gspca/spca508.c
similarity index 100%
rename from drivers/media/video/gspca/spca508.c
rename to drivers/media/usb/gspca/spca508.c
diff --git a/drivers/media/video/gspca/spca561.c b/drivers/media/usb/gspca/spca561.c
similarity index 100%
rename from drivers/media/video/gspca/spca561.c
rename to drivers/media/usb/gspca/spca561.c
diff --git a/drivers/media/video/gspca/sq905.c b/drivers/media/usb/gspca/sq905.c
similarity index 100%
rename from drivers/media/video/gspca/sq905.c
rename to drivers/media/usb/gspca/sq905.c
diff --git a/drivers/media/video/gspca/sq905c.c b/drivers/media/usb/gspca/sq905c.c
similarity index 100%
rename from drivers/media/video/gspca/sq905c.c
rename to drivers/media/usb/gspca/sq905c.c
diff --git a/drivers/media/video/gspca/sq930x.c b/drivers/media/usb/gspca/sq930x.c
similarity index 100%
rename from drivers/media/video/gspca/sq930x.c
rename to drivers/media/usb/gspca/sq930x.c
diff --git a/drivers/media/video/gspca/stk014.c b/drivers/media/usb/gspca/stk014.c
similarity index 100%
rename from drivers/media/video/gspca/stk014.c
rename to drivers/media/usb/gspca/stk014.c
diff --git a/drivers/media/video/gspca/stv0680.c b/drivers/media/usb/gspca/stv0680.c
similarity index 100%
rename from drivers/media/video/gspca/stv0680.c
rename to drivers/media/usb/gspca/stv0680.c
diff --git a/drivers/media/video/gspca/stv06xx/Kconfig b/drivers/media/usb/gspca/stv06xx/Kconfig
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/Kconfig
rename to drivers/media/usb/gspca/stv06xx/Kconfig
diff --git a/drivers/media/video/gspca/stv06xx/Makefile b/drivers/media/usb/gspca/stv06xx/Makefile
similarity index 78%
rename from drivers/media/video/gspca/stv06xx/Makefile
rename to drivers/media/usb/gspca/stv06xx/Makefile
index 38bc410..3a4b2f8 100644
--- a/drivers/media/video/gspca/stv06xx/Makefile
+++ b/drivers/media/usb/gspca/stv06xx/Makefile
@@ -6,5 +6,5 @@ gspca_stv06xx-objs := stv06xx.o \
 		      stv06xx_pb0100.o \
 		      stv06xx_st6422.o
 
-ccflags-y += -I$(srctree)/drivers/media/video/gspca
+ccflags-y += -I$(srctree)/drivers/media/usb/gspca
 
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx.c
rename to drivers/media/usb/gspca/stv06xx/stv06xx.c
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx.h b/drivers/media/usb/gspca/stv06xx/stv06xx.h
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx.h
rename to drivers/media/usb/gspca/stv06xx/stv06xx.h
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c
rename to drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_hdcs.h
rename to drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_pb0100.c
rename to drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_pb0100.h
rename to drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_sensor.h b/drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_sensor.h
rename to drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.c b/drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_st6422.c
rename to drivers/media/usb/gspca/stv06xx/stv06xx_st6422.c
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_st6422.h b/drivers/media/usb/gspca/stv06xx/stv06xx_st6422.h
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_st6422.h
rename to drivers/media/usb/gspca/stv06xx/stv06xx_st6422.h
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_vv6410.c
rename to drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.c
diff --git a/drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h b/drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.h
similarity index 100%
rename from drivers/media/video/gspca/stv06xx/stv06xx_vv6410.h
rename to drivers/media/usb/gspca/stv06xx/stv06xx_vv6410.h
diff --git a/drivers/media/video/gspca/sunplus.c b/drivers/media/usb/gspca/sunplus.c
similarity index 100%
rename from drivers/media/video/gspca/sunplus.c
rename to drivers/media/usb/gspca/sunplus.c
diff --git a/drivers/media/video/gspca/t613.c b/drivers/media/usb/gspca/t613.c
similarity index 100%
rename from drivers/media/video/gspca/t613.c
rename to drivers/media/usb/gspca/t613.c
diff --git a/drivers/media/video/gspca/topro.c b/drivers/media/usb/gspca/topro.c
similarity index 100%
rename from drivers/media/video/gspca/topro.c
rename to drivers/media/usb/gspca/topro.c
diff --git a/drivers/media/video/gspca/tv8532.c b/drivers/media/usb/gspca/tv8532.c
similarity index 100%
rename from drivers/media/video/gspca/tv8532.c
rename to drivers/media/usb/gspca/tv8532.c
diff --git a/drivers/media/video/gspca/vc032x.c b/drivers/media/usb/gspca/vc032x.c
similarity index 100%
rename from drivers/media/video/gspca/vc032x.c
rename to drivers/media/usb/gspca/vc032x.c
diff --git a/drivers/media/video/gspca/vicam.c b/drivers/media/usb/gspca/vicam.c
similarity index 100%
rename from drivers/media/video/gspca/vicam.c
rename to drivers/media/usb/gspca/vicam.c
diff --git a/drivers/media/video/gspca/w996Xcf.c b/drivers/media/usb/gspca/w996Xcf.c
similarity index 100%
rename from drivers/media/video/gspca/w996Xcf.c
rename to drivers/media/usb/gspca/w996Xcf.c
diff --git a/drivers/media/video/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
similarity index 100%
rename from drivers/media/video/gspca/xirlink_cit.c
rename to drivers/media/usb/gspca/xirlink_cit.c
diff --git a/drivers/media/video/gspca/zc3xx-reg.h b/drivers/media/usb/gspca/zc3xx-reg.h
similarity index 100%
rename from drivers/media/video/gspca/zc3xx-reg.h
rename to drivers/media/usb/gspca/zc3xx-reg.h
diff --git a/drivers/media/video/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
similarity index 100%
rename from drivers/media/video/gspca/zc3xx.c
rename to drivers/media/usb/gspca/zc3xx.c
diff --git a/drivers/media/video/hdpvr/Kconfig b/drivers/media/usb/hdpvr/Kconfig
similarity index 100%
rename from drivers/media/video/hdpvr/Kconfig
rename to drivers/media/usb/hdpvr/Kconfig
diff --git a/drivers/media/video/hdpvr/Makefile b/drivers/media/usb/hdpvr/Makefile
similarity index 100%
rename from drivers/media/video/hdpvr/Makefile
rename to drivers/media/usb/hdpvr/Makefile
diff --git a/drivers/media/video/hdpvr/hdpvr-control.c b/drivers/media/usb/hdpvr/hdpvr-control.c
similarity index 100%
rename from drivers/media/video/hdpvr/hdpvr-control.c
rename to drivers/media/usb/hdpvr/hdpvr-control.c
diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
similarity index 100%
rename from drivers/media/video/hdpvr/hdpvr-core.c
rename to drivers/media/usb/hdpvr/hdpvr-core.c
diff --git a/drivers/media/video/hdpvr/hdpvr-i2c.c b/drivers/media/usb/hdpvr/hdpvr-i2c.c
similarity index 100%
rename from drivers/media/video/hdpvr/hdpvr-i2c.c
rename to drivers/media/usb/hdpvr/hdpvr-i2c.c
diff --git a/drivers/media/video/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
similarity index 100%
rename from drivers/media/video/hdpvr/hdpvr-video.c
rename to drivers/media/usb/hdpvr/hdpvr-video.c
diff --git a/drivers/media/video/hdpvr/hdpvr.h b/drivers/media/usb/hdpvr/hdpvr.h
similarity index 100%
rename from drivers/media/video/hdpvr/hdpvr.h
rename to drivers/media/usb/hdpvr/hdpvr.h
diff --git a/drivers/media/video/pvrusb2/Kconfig b/drivers/media/usb/pvrusb2/Kconfig
similarity index 100%
rename from drivers/media/video/pvrusb2/Kconfig
rename to drivers/media/usb/pvrusb2/Kconfig
diff --git a/drivers/media/video/pvrusb2/Makefile b/drivers/media/usb/pvrusb2/Makefile
similarity index 100%
rename from drivers/media/video/pvrusb2/Makefile
rename to drivers/media/usb/pvrusb2/Makefile
diff --git a/drivers/media/video/pvrusb2/pvrusb2-audio.c b/drivers/media/usb/pvrusb2/pvrusb2-audio.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-audio.c
rename to drivers/media/usb/pvrusb2/pvrusb2-audio.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-audio.h b/drivers/media/usb/pvrusb2/pvrusb2-audio.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-audio.h
rename to drivers/media/usb/pvrusb2/pvrusb2-audio.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-context.c b/drivers/media/usb/pvrusb2/pvrusb2-context.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-context.c
rename to drivers/media/usb/pvrusb2/pvrusb2-context.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-context.h b/drivers/media/usb/pvrusb2/pvrusb2-context.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-context.h
rename to drivers/media/usb/pvrusb2/pvrusb2-context.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c b/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-cs53l32a.c
rename to drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-cs53l32a.h b/drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-cs53l32a.h
rename to drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.c b/drivers/media/usb/pvrusb2/pvrusb2-ctrl.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-ctrl.c
rename to drivers/media/usb/pvrusb2/pvrusb2-ctrl.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ctrl.h b/drivers/media/usb/pvrusb2/pvrusb2-ctrl.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-ctrl.h
rename to drivers/media/usb/pvrusb2/pvrusb2-ctrl.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c
rename to drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h b/drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.h
rename to drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-debug.h b/drivers/media/usb/pvrusb2/pvrusb2-debug.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-debug.h
rename to drivers/media/usb/pvrusb2/pvrusb2-debug.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-debugifc.c b/drivers/media/usb/pvrusb2/pvrusb2-debugifc.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-debugifc.c
rename to drivers/media/usb/pvrusb2/pvrusb2-debugifc.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-debugifc.h b/drivers/media/usb/pvrusb2/pvrusb2-debugifc.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-debugifc.h
rename to drivers/media/usb/pvrusb2/pvrusb2-debugifc.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.c b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-devattr.c
rename to drivers/media/usb/pvrusb2/pvrusb2-devattr.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-devattr.h b/drivers/media/usb/pvrusb2/pvrusb2-devattr.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-devattr.h
rename to drivers/media/usb/pvrusb2/pvrusb2-devattr.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-dvb.c b/drivers/media/usb/pvrusb2/pvrusb2-dvb.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-dvb.c
rename to drivers/media/usb/pvrusb2/pvrusb2-dvb.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-dvb.h b/drivers/media/usb/pvrusb2/pvrusb2-dvb.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-dvb.h
rename to drivers/media/usb/pvrusb2/pvrusb2-dvb.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-eeprom.c b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-eeprom.c
rename to drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-eeprom.h b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-eeprom.h
rename to drivers/media/usb/pvrusb2/pvrusb2-eeprom.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-encoder.c b/drivers/media/usb/pvrusb2/pvrusb2-encoder.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-encoder.c
rename to drivers/media/usb/pvrusb2/pvrusb2-encoder.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-encoder.h b/drivers/media/usb/pvrusb2/pvrusb2-encoder.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-encoder.h
rename to drivers/media/usb/pvrusb2/pvrusb2-encoder.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h b/drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-fx2-cmd.h
rename to drivers/media/usb/pvrusb2/pvrusb2-fx2-cmd.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
rename to drivers/media/usb/pvrusb2/pvrusb2-hdw-internal.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-hdw.c
rename to drivers/media/usb/pvrusb2/pvrusb2-hdw.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.h b/drivers/media/usb/pvrusb2/pvrusb2-hdw.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-hdw.h
rename to drivers/media/usb/pvrusb2/pvrusb2-hdw.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-i2c-core.c
rename to drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-i2c-core.h b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-i2c-core.h
rename to drivers/media/usb/pvrusb2/pvrusb2-i2c-core.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-io.c b/drivers/media/usb/pvrusb2/pvrusb2-io.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-io.c
rename to drivers/media/usb/pvrusb2/pvrusb2-io.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-io.h b/drivers/media/usb/pvrusb2/pvrusb2-io.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-io.h
rename to drivers/media/usb/pvrusb2/pvrusb2-io.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ioread.c b/drivers/media/usb/pvrusb2/pvrusb2-ioread.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-ioread.c
rename to drivers/media/usb/pvrusb2/pvrusb2-ioread.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-ioread.h b/drivers/media/usb/pvrusb2/pvrusb2-ioread.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-ioread.h
rename to drivers/media/usb/pvrusb2/pvrusb2-ioread.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-main.c b/drivers/media/usb/pvrusb2/pvrusb2-main.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-main.c
rename to drivers/media/usb/pvrusb2/pvrusb2-main.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.c b/drivers/media/usb/pvrusb2/pvrusb2-std.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-std.c
rename to drivers/media/usb/pvrusb2/pvrusb2-std.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-std.h b/drivers/media/usb/pvrusb2/pvrusb2-std.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-std.h
rename to drivers/media/usb/pvrusb2/pvrusb2-std.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-sysfs.c
rename to drivers/media/usb/pvrusb2/pvrusb2-sysfs.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.h b/drivers/media/usb/pvrusb2/pvrusb2-sysfs.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-sysfs.h
rename to drivers/media/usb/pvrusb2/pvrusb2-sysfs.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-util.h b/drivers/media/usb/pvrusb2/pvrusb2-util.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-util.h
rename to drivers/media/usb/pvrusb2/pvrusb2-util.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-v4l2.c
rename to drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.h b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-v4l2.h
rename to drivers/media/usb/pvrusb2/pvrusb2-v4l2.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-video-v4l.c b/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-video-v4l.c
rename to drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-video-v4l.h b/drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-video-v4l.h
rename to drivers/media/usb/pvrusb2/pvrusb2-video-v4l.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2-wm8775.c b/drivers/media/usb/pvrusb2/pvrusb2-wm8775.c
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-wm8775.c
rename to drivers/media/usb/pvrusb2/pvrusb2-wm8775.c
diff --git a/drivers/media/video/pvrusb2/pvrusb2-wm8775.h b/drivers/media/usb/pvrusb2/pvrusb2-wm8775.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2-wm8775.h
rename to drivers/media/usb/pvrusb2/pvrusb2-wm8775.h
diff --git a/drivers/media/video/pvrusb2/pvrusb2.h b/drivers/media/usb/pvrusb2/pvrusb2.h
similarity index 100%
rename from drivers/media/video/pvrusb2/pvrusb2.h
rename to drivers/media/usb/pvrusb2/pvrusb2.h
diff --git a/drivers/media/video/pwc/Kconfig b/drivers/media/usb/pwc/Kconfig
similarity index 100%
rename from drivers/media/video/pwc/Kconfig
rename to drivers/media/usb/pwc/Kconfig
diff --git a/drivers/media/video/pwc/Makefile b/drivers/media/usb/pwc/Makefile
similarity index 100%
rename from drivers/media/video/pwc/Makefile
rename to drivers/media/usb/pwc/Makefile
diff --git a/drivers/media/video/pwc/philips.txt b/drivers/media/usb/pwc/philips.txt
similarity index 100%
rename from drivers/media/video/pwc/philips.txt
rename to drivers/media/usb/pwc/philips.txt
diff --git a/drivers/media/video/pwc/pwc-ctrl.c b/drivers/media/usb/pwc/pwc-ctrl.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-ctrl.c
rename to drivers/media/usb/pwc/pwc-ctrl.c
diff --git a/drivers/media/video/pwc/pwc-dec1.c b/drivers/media/usb/pwc/pwc-dec1.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-dec1.c
rename to drivers/media/usb/pwc/pwc-dec1.c
diff --git a/drivers/media/video/pwc/pwc-dec1.h b/drivers/media/usb/pwc/pwc-dec1.h
similarity index 100%
rename from drivers/media/video/pwc/pwc-dec1.h
rename to drivers/media/usb/pwc/pwc-dec1.h
diff --git a/drivers/media/video/pwc/pwc-dec23.c b/drivers/media/usb/pwc/pwc-dec23.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-dec23.c
rename to drivers/media/usb/pwc/pwc-dec23.c
diff --git a/drivers/media/video/pwc/pwc-dec23.h b/drivers/media/usb/pwc/pwc-dec23.h
similarity index 100%
rename from drivers/media/video/pwc/pwc-dec23.h
rename to drivers/media/usb/pwc/pwc-dec23.h
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/usb/pwc/pwc-if.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-if.c
rename to drivers/media/usb/pwc/pwc-if.c
diff --git a/drivers/media/video/pwc/pwc-kiara.c b/drivers/media/usb/pwc/pwc-kiara.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-kiara.c
rename to drivers/media/usb/pwc/pwc-kiara.c
diff --git a/drivers/media/video/pwc/pwc-kiara.h b/drivers/media/usb/pwc/pwc-kiara.h
similarity index 100%
rename from drivers/media/video/pwc/pwc-kiara.h
rename to drivers/media/usb/pwc/pwc-kiara.h
diff --git a/drivers/media/video/pwc/pwc-misc.c b/drivers/media/usb/pwc/pwc-misc.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-misc.c
rename to drivers/media/usb/pwc/pwc-misc.c
diff --git a/drivers/media/video/pwc/pwc-nala.h b/drivers/media/usb/pwc/pwc-nala.h
similarity index 100%
rename from drivers/media/video/pwc/pwc-nala.h
rename to drivers/media/usb/pwc/pwc-nala.h
diff --git a/drivers/media/video/pwc/pwc-timon.c b/drivers/media/usb/pwc/pwc-timon.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-timon.c
rename to drivers/media/usb/pwc/pwc-timon.c
diff --git a/drivers/media/video/pwc/pwc-timon.h b/drivers/media/usb/pwc/pwc-timon.h
similarity index 100%
rename from drivers/media/video/pwc/pwc-timon.h
rename to drivers/media/usb/pwc/pwc-timon.h
diff --git a/drivers/media/video/pwc/pwc-uncompress.c b/drivers/media/usb/pwc/pwc-uncompress.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-uncompress.c
rename to drivers/media/usb/pwc/pwc-uncompress.c
diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
similarity index 100%
rename from drivers/media/video/pwc/pwc-v4l.c
rename to drivers/media/usb/pwc/pwc-v4l.c
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/usb/pwc/pwc.h
similarity index 100%
rename from drivers/media/video/pwc/pwc.h
rename to drivers/media/usb/pwc/pwc.h
diff --git a/drivers/media/video/sn9c102/Kconfig b/drivers/media/usb/sn9c102/Kconfig
similarity index 100%
rename from drivers/media/video/sn9c102/Kconfig
rename to drivers/media/usb/sn9c102/Kconfig
diff --git a/drivers/media/video/sn9c102/Makefile b/drivers/media/usb/sn9c102/Makefile
similarity index 100%
rename from drivers/media/video/sn9c102/Makefile
rename to drivers/media/usb/sn9c102/Makefile
diff --git a/drivers/media/video/sn9c102/sn9c102.h b/drivers/media/usb/sn9c102/sn9c102.h
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102.h
rename to drivers/media/usb/sn9c102/sn9c102.h
diff --git a/drivers/media/video/sn9c102/sn9c102_config.h b/drivers/media/usb/sn9c102/sn9c102_config.h
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_config.h
rename to drivers/media/usb/sn9c102/sn9c102_config.h
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/usb/sn9c102/sn9c102_core.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_core.c
rename to drivers/media/usb/sn9c102/sn9c102_core.c
diff --git a/drivers/media/video/sn9c102/sn9c102_devtable.h b/drivers/media/usb/sn9c102/sn9c102_devtable.h
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_devtable.h
rename to drivers/media/usb/sn9c102/sn9c102_devtable.h
diff --git a/drivers/media/video/sn9c102/sn9c102_hv7131d.c b/drivers/media/usb/sn9c102/sn9c102_hv7131d.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_hv7131d.c
rename to drivers/media/usb/sn9c102/sn9c102_hv7131d.c
diff --git a/drivers/media/video/sn9c102/sn9c102_hv7131r.c b/drivers/media/usb/sn9c102/sn9c102_hv7131r.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_hv7131r.c
rename to drivers/media/usb/sn9c102/sn9c102_hv7131r.c
diff --git a/drivers/media/video/sn9c102/sn9c102_mi0343.c b/drivers/media/usb/sn9c102/sn9c102_mi0343.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_mi0343.c
rename to drivers/media/usb/sn9c102/sn9c102_mi0343.c
diff --git a/drivers/media/video/sn9c102/sn9c102_mi0360.c b/drivers/media/usb/sn9c102/sn9c102_mi0360.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_mi0360.c
rename to drivers/media/usb/sn9c102/sn9c102_mi0360.c
diff --git a/drivers/media/video/sn9c102/sn9c102_mt9v111.c b/drivers/media/usb/sn9c102/sn9c102_mt9v111.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_mt9v111.c
rename to drivers/media/usb/sn9c102/sn9c102_mt9v111.c
diff --git a/drivers/media/video/sn9c102/sn9c102_ov7630.c b/drivers/media/usb/sn9c102/sn9c102_ov7630.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_ov7630.c
rename to drivers/media/usb/sn9c102/sn9c102_ov7630.c
diff --git a/drivers/media/video/sn9c102/sn9c102_ov7660.c b/drivers/media/usb/sn9c102/sn9c102_ov7660.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_ov7660.c
rename to drivers/media/usb/sn9c102/sn9c102_ov7660.c
diff --git a/drivers/media/video/sn9c102/sn9c102_pas106b.c b/drivers/media/usb/sn9c102/sn9c102_pas106b.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_pas106b.c
rename to drivers/media/usb/sn9c102/sn9c102_pas106b.c
diff --git a/drivers/media/video/sn9c102/sn9c102_pas202bcb.c b/drivers/media/usb/sn9c102/sn9c102_pas202bcb.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_pas202bcb.c
rename to drivers/media/usb/sn9c102/sn9c102_pas202bcb.c
diff --git a/drivers/media/video/sn9c102/sn9c102_sensor.h b/drivers/media/usb/sn9c102/sn9c102_sensor.h
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_sensor.h
rename to drivers/media/usb/sn9c102/sn9c102_sensor.h
diff --git a/drivers/media/video/sn9c102/sn9c102_tas5110c1b.c b/drivers/media/usb/sn9c102/sn9c102_tas5110c1b.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_tas5110c1b.c
rename to drivers/media/usb/sn9c102/sn9c102_tas5110c1b.c
diff --git a/drivers/media/video/sn9c102/sn9c102_tas5110d.c b/drivers/media/usb/sn9c102/sn9c102_tas5110d.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_tas5110d.c
rename to drivers/media/usb/sn9c102/sn9c102_tas5110d.c
diff --git a/drivers/media/video/sn9c102/sn9c102_tas5130d1b.c b/drivers/media/usb/sn9c102/sn9c102_tas5130d1b.c
similarity index 100%
rename from drivers/media/video/sn9c102/sn9c102_tas5130d1b.c
rename to drivers/media/usb/sn9c102/sn9c102_tas5130d1b.c
diff --git a/drivers/media/video/stk1160/Kconfig b/drivers/media/usb/stk1160/Kconfig
similarity index 100%
rename from drivers/media/video/stk1160/Kconfig
rename to drivers/media/usb/stk1160/Kconfig
diff --git a/drivers/media/video/stk1160/Makefile b/drivers/media/usb/stk1160/Makefile
similarity index 100%
rename from drivers/media/video/stk1160/Makefile
rename to drivers/media/usb/stk1160/Makefile
diff --git a/drivers/media/video/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
similarity index 100%
rename from drivers/media/video/stk1160/stk1160-ac97.c
rename to drivers/media/usb/stk1160/stk1160-ac97.c
diff --git a/drivers/media/video/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
similarity index 100%
rename from drivers/media/video/stk1160/stk1160-core.c
rename to drivers/media/usb/stk1160/stk1160-core.c
diff --git a/drivers/media/video/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
similarity index 100%
rename from drivers/media/video/stk1160/stk1160-i2c.c
rename to drivers/media/usb/stk1160/stk1160-i2c.c
diff --git a/drivers/media/video/stk1160/stk1160-reg.h b/drivers/media/usb/stk1160/stk1160-reg.h
similarity index 100%
rename from drivers/media/video/stk1160/stk1160-reg.h
rename to drivers/media/usb/stk1160/stk1160-reg.h
diff --git a/drivers/media/video/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
similarity index 100%
rename from drivers/media/video/stk1160/stk1160-v4l.c
rename to drivers/media/usb/stk1160/stk1160-v4l.c
diff --git a/drivers/media/video/stk1160/stk1160-video.c b/drivers/media/usb/stk1160/stk1160-video.c
similarity index 100%
rename from drivers/media/video/stk1160/stk1160-video.c
rename to drivers/media/usb/stk1160/stk1160-video.c
diff --git a/drivers/media/video/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
similarity index 100%
rename from drivers/media/video/stk1160/stk1160.h
rename to drivers/media/usb/stk1160/stk1160.h
diff --git a/drivers/media/video/tlg2300/Kconfig b/drivers/media/usb/tlg2300/Kconfig
similarity index 100%
rename from drivers/media/video/tlg2300/Kconfig
rename to drivers/media/usb/tlg2300/Kconfig
diff --git a/drivers/media/video/tlg2300/Makefile b/drivers/media/usb/tlg2300/Makefile
similarity index 100%
rename from drivers/media/video/tlg2300/Makefile
rename to drivers/media/usb/tlg2300/Makefile
diff --git a/drivers/media/video/tlg2300/pd-alsa.c b/drivers/media/usb/tlg2300/pd-alsa.c
similarity index 100%
rename from drivers/media/video/tlg2300/pd-alsa.c
rename to drivers/media/usb/tlg2300/pd-alsa.c
diff --git a/drivers/media/video/tlg2300/pd-common.h b/drivers/media/usb/tlg2300/pd-common.h
similarity index 100%
rename from drivers/media/video/tlg2300/pd-common.h
rename to drivers/media/usb/tlg2300/pd-common.h
diff --git a/drivers/media/video/tlg2300/pd-dvb.c b/drivers/media/usb/tlg2300/pd-dvb.c
similarity index 100%
rename from drivers/media/video/tlg2300/pd-dvb.c
rename to drivers/media/usb/tlg2300/pd-dvb.c
diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/usb/tlg2300/pd-main.c
similarity index 100%
rename from drivers/media/video/tlg2300/pd-main.c
rename to drivers/media/usb/tlg2300/pd-main.c
diff --git a/drivers/media/video/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
similarity index 100%
rename from drivers/media/video/tlg2300/pd-radio.c
rename to drivers/media/usb/tlg2300/pd-radio.c
diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/usb/tlg2300/pd-video.c
similarity index 100%
rename from drivers/media/video/tlg2300/pd-video.c
rename to drivers/media/usb/tlg2300/pd-video.c
diff --git a/drivers/media/video/tlg2300/vendorcmds.h b/drivers/media/usb/tlg2300/vendorcmds.h
similarity index 100%
rename from drivers/media/video/tlg2300/vendorcmds.h
rename to drivers/media/usb/tlg2300/vendorcmds.h
diff --git a/drivers/media/video/tm6000/Kconfig b/drivers/media/usb/tm6000/Kconfig
similarity index 100%
rename from drivers/media/video/tm6000/Kconfig
rename to drivers/media/usb/tm6000/Kconfig
diff --git a/drivers/media/video/tm6000/Makefile b/drivers/media/usb/tm6000/Makefile
similarity index 100%
rename from drivers/media/video/tm6000/Makefile
rename to drivers/media/usb/tm6000/Makefile
diff --git a/drivers/media/video/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-alsa.c
rename to drivers/media/usb/tm6000/tm6000-alsa.c
diff --git a/drivers/media/video/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-cards.c
rename to drivers/media/usb/tm6000/tm6000-cards.c
diff --git a/drivers/media/video/tm6000/tm6000-core.c b/drivers/media/usb/tm6000/tm6000-core.c
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-core.c
rename to drivers/media/usb/tm6000/tm6000-core.c
diff --git a/drivers/media/video/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-dvb.c
rename to drivers/media/usb/tm6000/tm6000-dvb.c
diff --git a/drivers/media/video/tm6000/tm6000-i2c.c b/drivers/media/usb/tm6000/tm6000-i2c.c
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-i2c.c
rename to drivers/media/usb/tm6000/tm6000-i2c.c
diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/usb/tm6000/tm6000-input.c
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-input.c
rename to drivers/media/usb/tm6000/tm6000-input.c
diff --git a/drivers/media/video/tm6000/tm6000-regs.h b/drivers/media/usb/tm6000/tm6000-regs.h
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-regs.h
rename to drivers/media/usb/tm6000/tm6000-regs.h
diff --git a/drivers/media/video/tm6000/tm6000-stds.c b/drivers/media/usb/tm6000/tm6000-stds.c
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-stds.c
rename to drivers/media/usb/tm6000/tm6000-stds.c
diff --git a/drivers/media/video/tm6000/tm6000-usb-isoc.h b/drivers/media/usb/tm6000/tm6000-usb-isoc.h
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-usb-isoc.h
rename to drivers/media/usb/tm6000/tm6000-usb-isoc.h
diff --git a/drivers/media/video/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
similarity index 100%
rename from drivers/media/video/tm6000/tm6000-video.c
rename to drivers/media/usb/tm6000/tm6000-video.c
diff --git a/drivers/media/video/tm6000/tm6000.h b/drivers/media/usb/tm6000/tm6000.h
similarity index 100%
rename from drivers/media/video/tm6000/tm6000.h
rename to drivers/media/usb/tm6000/tm6000.h
diff --git a/drivers/media/video/usbvision/Kconfig b/drivers/media/usb/usbvision/Kconfig
similarity index 100%
rename from drivers/media/video/usbvision/Kconfig
rename to drivers/media/usb/usbvision/Kconfig
diff --git a/drivers/media/video/usbvision/Makefile b/drivers/media/usb/usbvision/Makefile
similarity index 100%
rename from drivers/media/video/usbvision/Makefile
rename to drivers/media/usb/usbvision/Makefile
diff --git a/drivers/media/video/usbvision/usbvision-cards.c b/drivers/media/usb/usbvision/usbvision-cards.c
similarity index 100%
rename from drivers/media/video/usbvision/usbvision-cards.c
rename to drivers/media/usb/usbvision/usbvision-cards.c
diff --git a/drivers/media/video/usbvision/usbvision-cards.h b/drivers/media/usb/usbvision/usbvision-cards.h
similarity index 100%
rename from drivers/media/video/usbvision/usbvision-cards.h
rename to drivers/media/usb/usbvision/usbvision-cards.h
diff --git a/drivers/media/video/usbvision/usbvision-core.c b/drivers/media/usb/usbvision/usbvision-core.c
similarity index 100%
rename from drivers/media/video/usbvision/usbvision-core.c
rename to drivers/media/usb/usbvision/usbvision-core.c
diff --git a/drivers/media/video/usbvision/usbvision-i2c.c b/drivers/media/usb/usbvision/usbvision-i2c.c
similarity index 100%
rename from drivers/media/video/usbvision/usbvision-i2c.c
rename to drivers/media/usb/usbvision/usbvision-i2c.c
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
similarity index 100%
rename from drivers/media/video/usbvision/usbvision-video.c
rename to drivers/media/usb/usbvision/usbvision-video.c
diff --git a/drivers/media/video/usbvision/usbvision.h b/drivers/media/usb/usbvision/usbvision.h
similarity index 100%
rename from drivers/media/video/usbvision/usbvision.h
rename to drivers/media/usb/usbvision/usbvision.h
diff --git a/drivers/media/video/uvc/Kconfig b/drivers/media/usb/uvc/Kconfig
similarity index 100%
rename from drivers/media/video/uvc/Kconfig
rename to drivers/media/usb/uvc/Kconfig
diff --git a/drivers/media/video/uvc/Makefile b/drivers/media/usb/uvc/Makefile
similarity index 100%
rename from drivers/media/video/uvc/Makefile
rename to drivers/media/usb/uvc/Makefile
diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_ctrl.c
rename to drivers/media/usb/uvc/uvc_ctrl.c
diff --git a/drivers/media/video/uvc/uvc_debugfs.c b/drivers/media/usb/uvc/uvc_debugfs.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_debugfs.c
rename to drivers/media/usb/uvc/uvc_debugfs.c
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_driver.c
rename to drivers/media/usb/uvc/uvc_driver.c
diff --git a/drivers/media/video/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_entity.c
rename to drivers/media/usb/uvc/uvc_entity.c
diff --git a/drivers/media/video/uvc/uvc_isight.c b/drivers/media/usb/uvc/uvc_isight.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_isight.c
rename to drivers/media/usb/uvc/uvc_isight.c
diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_queue.c
rename to drivers/media/usb/uvc/uvc_queue.c
diff --git a/drivers/media/video/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_status.c
rename to drivers/media/usb/uvc/uvc_status.c
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_v4l2.c
rename to drivers/media/usb/uvc/uvc_v4l2.c
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
similarity index 100%
rename from drivers/media/video/uvc/uvc_video.c
rename to drivers/media/usb/uvc/uvc_video.c
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
similarity index 100%
rename from drivers/media/video/uvc/uvcvideo.h
rename to drivers/media/usb/uvc/uvcvideo.h
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 068e8da..097b17ce 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -616,16 +616,6 @@ menuconfig V4L_USB_DRIVERS
 
 if V4L_USB_DRIVERS && MEDIA_CAMERA_SUPPORT
 
-	comment "Webcam devices"
-
-source "drivers/media/video/uvc/Kconfig"
-
-source "drivers/media/video/gspca/Kconfig"
-
-source "drivers/media/video/pwc/Kconfig"
-
-source "drivers/media/video/cpia2/Kconfig"
-
 config USB_ZR364XX
 	tristate "USB ZR364XX Camera support"
 	depends on VIDEO_V4L2
@@ -662,40 +652,9 @@ config USB_S2255
 	  Say Y here if you want support for the Sensoray 2255 USB device.
 	  This driver can be compiled as a module, called s2255drv.
 
-source "drivers/media/video/sn9c102/Kconfig"
 
 endif # V4L_USB_DRIVERS && MEDIA_CAMERA_SUPPORT
 
-if V4L_USB_DRIVERS
-
-	comment "Webcam and/or TV USB devices"
-
-source "drivers/media/video/em28xx/Kconfig"
-
-endif
-
-if V4L_USB_DRIVERS && MEDIA_ANALOG_TV_SUPPORT
-
-	comment "TV USB devices"
-
-source "drivers/media/video/au0828/Kconfig"
-
-source "drivers/media/video/pvrusb2/Kconfig"
-
-source "drivers/media/video/hdpvr/Kconfig"
-
-source "drivers/media/video/tlg2300/Kconfig"
-
-source "drivers/media/video/cx231xx/Kconfig"
-
-source "drivers/media/video/tm6000/Kconfig"
-
-source "drivers/media/video/usbvision/Kconfig"
-
-source "drivers/media/video/stk1160/Kconfig"
-
-endif # V4L_USB_DRIVERS
-
 #
 # PCI drivers configuration - No devices here are for webcams
 #
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 9dff3e2..a22a258 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -99,20 +99,12 @@ obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_MEYE) += meye.o
 obj-$(CONFIG_VIDEO_SAA7134) += saa7134/
 obj-$(CONFIG_VIDEO_CX88) += cx88/
-obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
-obj-$(CONFIG_VIDEO_TLG2300) += tlg2300/
-obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
 obj-$(CONFIG_VIDEO_CX25821) += cx25821/
-obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
-obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
-obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
-obj-$(CONFIG_VIDEO_TM6000) += tm6000/
 obj-$(CONFIG_VIDEO_MXB) += mxb.o
 obj-$(CONFIG_VIDEO_HEXIUM_ORION) += hexium_orion.o
 obj-$(CONFIG_VIDEO_HEXIUM_GEMINI) += hexium_gemini.o
 obj-$(CONFIG_STA2X11_VIP) += sta2x11_vip.o
 obj-$(CONFIG_VIDEO_TIMBERDALE)	+= timblogiw.o
-obj-$(CONFIG_VIDEO_STK1160) += stk1160/
 
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 
@@ -130,11 +122,6 @@ obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
 obj-$(CONFIG_USB_ZR364XX)       += zr364xx.o
 obj-$(CONFIG_USB_STKWEBCAM)     += stkwebcam.o
 
-obj-$(CONFIG_USB_SN9C102)       += sn9c102/
-obj-$(CONFIG_USB_PWC)           += pwc/
-obj-$(CONFIG_USB_GSPCA)         += gspca/
-
-obj-$(CONFIG_VIDEO_HDPVR)	+= hdpvr/
 
 obj-$(CONFIG_USB_S2255)		+= s2255drv.o
 
@@ -179,9 +166,6 @@ obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
-obj-$(CONFIG_VIDEO_AU0828) += au0828/
-
-obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 obj-$(CONFIG_VIDEO_SAA7164)     += saa7164/
 
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
-- 
1.7.11.2

