Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51400 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754257AbcJRUqQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Oct 2016 16:46:16 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH v2 00/58] don't break long lines on strings
Date: Tue, 18 Oct 2016 18:45:12 -0200
Message-Id: <cover.1476822924.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


There are lots of drivers on media that breaks long line strings in order to
fit into 80 columns. This was an usual practice to make checkpatch happy.
However, it makes harder to detect where the strings are with grep.

As we're right now fixing other drivers due to KERN_CONT, we need to be
able to identify what printk strings don't end with a "\n". It is a way easier
to detect those if we don't break long lines.

So, this patch series re-group those strings, violating the 80 columns limit
by purpose.

Later patches will rely on this series to identify the strings that require
KERN_CONT (or that should be converted to hexadecimal dumps).

Originally, I coded this as a single patch, but I opted to split it per
directory, as it makes easy for people to review.

---

Version 2:

Thanks all for the review on version 1! I addressed all the issues pointed
by the public revices I received, and added the acks.

Someone asked me in priv about removing v4l2-ioctl.c from this series,
as it has long debug messages. I slept on this question. At the end,
I opted to keep it. The rationale is that it is a core file, and people
sometimes use the core as a coding style example.


Mauro Carvalho Chehab (58):
  b2c2: don't break long lines
  cx25840: don't break long lines
  smiapp: don't break long lines
  soc_camera: don't break long lines
  b2c2: don't break long lines
  bt8xx: don't break long lines
  cx18: don't break long lines
  cx23885: don't break long lines
  cx88: don't break long lines
  ddbridge: don't break long lines
  dm1105: don't break long lines
  ivtv: don't break long lines
  meye: don't break long lines
  pt1: don't break long lines
  saa7134: don't break long lines
  saa7164: don't break long lines
  solo6x10: don't break long lines
  ttpci: don't break long lines
  tw68: don't break long lines
  davinci: don't break long lines
  exynos4-is: don't break long lines
  marvell-ccic: don't break long lines
  omap: don't break long lines
  omap3isp: don't break long lines
  s5p-mfc: don't break long lines
  c8sectpfe: don't break long lines
  ti-vpe: don't break long lines
  si470x: don't break long lines
  si4713: don't break long lines
  wl128x: don't break long lines
  au0828: don't break long lines
  b2c2: don't break long lines
  cpia2: don't break long lines
  cx231xx: don't break long lines
  dvb-usb: don't break long lines
  dvb-usb-v2: don't break long lines
  em28xx: don't break long lines
  gspca: don't break long lines
  hdpvr: don't break long lines
  pvrusb2: don't break long lines
  pwc: don't break long lines
  siano: don't break long lines
  stkwebcam: don't break long lines
  tm6000: don't break long lines
  ttusb-budget: don't break long lines
  ttusb-dec: don't break long lines
  usbvision: don't break long lines
  uvc: don't break long lines
  zr364xx: don't break long lines
  v4l2-core: don't break long lines
  dvb-frontends: don't break long lines
  common: don't break long lines
  firewire: don't break long lines
  i2c: don't break long lines
  platform: don't break long lines
  radio: don't break long lines
  rc: don't break long lines
  tuners: don't break long lines

 drivers/media/common/b2c2/flexcop-eeprom.c         |   3 +-
 drivers/media/common/b2c2/flexcop-i2c.c            |   4 +-
 drivers/media/common/b2c2/flexcop-misc.c           |   9 +-
 drivers/media/common/b2c2/flexcop.c                |   3 +-
 drivers/media/common/tveeprom.c                    |   3 +-
 drivers/media/dvb-frontends/au8522_common.c        |   4 +-
 drivers/media/dvb-frontends/cx24110.c              |   4 +-
 drivers/media/dvb-frontends/cx24113.c              |   4 +-
 drivers/media/dvb-frontends/cx24116.c              |   8 +-
 drivers/media/dvb-frontends/cx24117.c              |   4 +-
 drivers/media/dvb-frontends/cx24123.c              |   4 +-
 drivers/media/dvb-frontends/ds3000.c               |  15 +-
 drivers/media/dvb-frontends/lgdt330x.c             |   3 +-
 drivers/media/dvb-frontends/m88rs2000.c            |   7 +-
 drivers/media/dvb-frontends/mt312.c                |   7 +-
 drivers/media/dvb-frontends/nxt200x.c              |  11 +-
 drivers/media/dvb-frontends/or51132.c              |   6 +-
 drivers/media/dvb-frontends/or51211.c              |   3 +-
 drivers/media/dvb-frontends/s5h1409.c              |   4 +-
 drivers/media/dvb-frontends/s5h1411.c              |   4 +-
 drivers/media/dvb-frontends/s5h1432.c              |   4 +-
 drivers/media/dvb-frontends/s921.c                 |   4 +-
 drivers/media/dvb-frontends/si21xx.c               |   8 +-
 drivers/media/dvb-frontends/sp887x.c               |   3 +-
 drivers/media/dvb-frontends/stv0288.c              |   7 +-
 drivers/media/dvb-frontends/stv0297.c              |   4 +-
 drivers/media/dvb-frontends/stv0299.c              |   7 +-
 drivers/media/dvb-frontends/stv0900_sw.c           |   3 +-
 drivers/media/dvb-frontends/tda10021.c             |   3 +-
 drivers/media/dvb-frontends/tda10023.c             |   6 +-
 drivers/media/dvb-frontends/tda10048.c             |  12 +-
 drivers/media/dvb-frontends/ves1820.c              |   8 +-
 drivers/media/dvb-frontends/zl10036.c              |   4 +-
 drivers/media/dvb-frontends/zl10039.c              |   3 +-
 drivers/media/firewire/firedtv-rc.c                |   4 +-
 drivers/media/i2c/as3645a.c                        |  13 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |  11 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |   7 +-
 drivers/media/i2c/msp3400-kthreads.c               |   4 +-
 drivers/media/i2c/mt9m032.c                        |   5 +-
 drivers/media/i2c/mt9p031.c                        |   5 +-
 drivers/media/i2c/saa7115.c                        |  18 +-
 drivers/media/i2c/saa717x.c                        |   4 +-
 drivers/media/i2c/smiapp/smiapp-regs.c             |   4 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   3 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   3 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   3 +-
 drivers/media/i2c/tvp5150.c                        |  14 +-
 drivers/media/i2c/tvp7002.c                        |   6 +-
 drivers/media/i2c/upd64083.c                       |   4 +-
 drivers/media/pci/b2c2/flexcop-dma.c               |   6 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   7 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |   9 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   6 +-
 drivers/media/pci/bt8xx/bttv-i2c.c                 |   6 +-
 drivers/media/pci/bt8xx/bttv-input.c               |   4 +-
 drivers/media/pci/cx18/cx18-alsa-main.c            |   8 +-
 drivers/media/pci/cx18/cx18-av-core.c              |  17 +-
 drivers/media/pci/cx18/cx18-av-firmware.c          |   3 +-
 drivers/media/pci/cx18/cx18-controls.c             |   9 +-
 drivers/media/pci/cx18/cx18-driver.c               |  35 ++-
 drivers/media/pci/cx18/cx18-dvb.c                  |   6 +-
 drivers/media/pci/cx18/cx18-fileops.c              |   6 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |   6 +-
 drivers/media/pci/cx18/cx18-irq.c                  |   4 +-
 drivers/media/pci/cx18/cx18-mailbox.c              |  39 ++-
 drivers/media/pci/cx18/cx18-queue.c                |   8 +-
 drivers/media/pci/cx18/cx18-streams.c              |   7 +-
 drivers/media/pci/cx23885/cimax2.c                 |   5 +-
 drivers/media/pci/cx23885/cx23885-417.c            |  17 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |  15 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |   8 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  15 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   3 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   3 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |   7 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |  15 +-
 drivers/media/pci/cx88/cx88-cards.c                |  14 +-
 drivers/media/pci/cx88/cx88-dsp.c                  |  12 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   6 +-
 drivers/media/pci/cx88/cx88-i2c.c                  |   3 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |  15 +-
 drivers/media/pci/cx88/cx88-tvaudio.c              |   6 +-
 drivers/media/pci/cx88/cx88-video.c                |   4 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   6 +-
 drivers/media/pci/dm1105/dm1105.c                  |   3 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |  12 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |  37 +--
 drivers/media/pci/ivtv/ivtv-firmware.c             |   4 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   8 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |   3 +-
 drivers/media/pci/meye/meye.c                      |  12 +-
 drivers/media/pci/pt1/pt1.c                        |   7 +-
 drivers/media/pci/saa7134/saa7134-alsa.c           |   3 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |   8 +-
 drivers/media/pci/saa7134/saa7134-core.c           |  39 ++-
 drivers/media/pci/saa7134/saa7134-dvb.c            |  32 +--
 drivers/media/pci/saa7134/saa7134-input.c          |  13 +-
 drivers/media/pci/saa7164/saa7164-buffer.c         |   3 +-
 drivers/media/pci/saa7164/saa7164-bus.c            |   4 +-
 drivers/media/pci/saa7164/saa7164-cards.c          |   4 +-
 drivers/media/pci/saa7164/saa7164-cmd.c            |  12 +-
 drivers/media/pci/saa7164/saa7164-core.c           |  66 +++--
 drivers/media/pci/saa7164/saa7164-dvb.c            |  34 ++-
 drivers/media/pci/saa7164/saa7164-encoder.c        |  18 +-
 drivers/media/pci/saa7164/saa7164-fw.c             |  10 +-
 drivers/media/pci/saa7164/saa7164-vbi.c            |  14 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   4 +-
 drivers/media/pci/ttpci/av7110.c                   |  29 +--
 drivers/media/pci/ttpci/av7110_hw.c                |  12 +-
 drivers/media/pci/ttpci/budget-av.c                |   3 +-
 drivers/media/pci/ttpci/budget-ci.c                |   4 +-
 drivers/media/pci/ttpci/budget-patch.c             |   3 +-
 drivers/media/pci/ttpci/budget.c                   |   3 +-
 drivers/media/pci/ttpci/ttpci-eeprom.c             |   3 +-
 drivers/media/pci/tw68/tw68-video.c                |  16 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |   4 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |   4 +-
 drivers/media/platform/davinci/vpbe.c              |  15 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   6 +-
 drivers/media/platform/davinci/vpif_capture.c      |   9 +-
 drivers/media/platform/davinci/vpif_display.c      |   9 +-
 drivers/media/platform/davinci/vpss.c              |   7 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |  26 +-
 drivers/media/platform/mx2_emmaprp.c               |  10 +-
 drivers/media/platform/omap/omap_vout.c            |  24 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |   5 +-
 drivers/media/platform/omap3isp/isp.c              |   4 +-
 drivers/media/platform/omap3isp/ispccdc.c          |   9 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |  13 +-
 drivers/media/platform/omap3isp/ispcsiphy.c        |   4 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |   8 +-
 drivers/media/platform/omap3isp/isph3a_af.c        |   8 +-
 drivers/media/platform/omap3isp/ispstat.c          |  58 +++--
 drivers/media/platform/pxa_camera.c                |   6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  13 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   7 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |  16 +-
 drivers/media/platform/ti-vpe/vpdma.c              |  22 +-
 drivers/media/platform/ti-vpe/vpe.c                |   3 +-
 drivers/media/platform/via-camera.c                |   7 +-
 drivers/media/radio/radio-gemtek.c                 |   8 +-
 drivers/media/radio/radio-wl1273.c                 |   3 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   7 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |  15 +-
 drivers/media/radio/si4713/si4713.c                |  13 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |  30 +--
 drivers/media/radio/wl128x/fmdrv_rx.c              |   8 +-
 drivers/media/rc/ati_remote.c                      |   3 +-
 drivers/media/rc/ene_ir.c                          |   3 +-
 drivers/media/rc/imon.c                            |  48 ++--
 drivers/media/rc/ite-cir.c                         |   9 +-
 drivers/media/rc/mceusb.c                          |   4 +-
 drivers/media/rc/rc-main.c                         |   3 +-
 drivers/media/rc/redrat3.c                         |  18 +-
 drivers/media/rc/streamzap.c                       |  11 +-
 drivers/media/rc/winbond-cir.c                     |   9 +-
 drivers/media/tuners/fc0011.c                      |   7 +-
 drivers/media/tuners/mc44s803.c                    |   4 +-
 drivers/media/tuners/tda18271-common.c             |   4 +-
 drivers/media/tuners/tda18271-fe.c                 |   3 +-
 drivers/media/tuners/tda18271-maps.c               |   6 +-
 drivers/media/tuners/tda8290.c                     |   4 +-
 drivers/media/tuners/tea5761.c                     |   6 +-
 drivers/media/tuners/tuner-simple.c                |  45 ++--
 drivers/media/tuners/xc4000.c                      |  25 +-
 drivers/media/usb/au0828/au0828-video.c            |   3 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |  11 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |   4 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |  10 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   4 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c        |  12 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |  10 +-
 drivers/media/usb/dvb-usb/cinergyT2-core.c         |   6 +-
 drivers/media/usb/dvb-usb/cinergyT2-fe.c           |   4 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   5 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   3 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |   3 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c       |   6 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  10 +-
 drivers/media/usb/dvb-usb/friio.c                  |   4 +-
 drivers/media/usb/dvb-usb/gp8psk.c                 |   3 +-
 drivers/media/usb/dvb-usb/opera1.c                 |   3 +-
 drivers/media/usb/dvb-usb/pctv452e.c               |   3 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |   3 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   3 +-
 drivers/media/usb/gspca/gspca.c                    |   3 +-
 drivers/media/usb/gspca/m5602/m5602_core.c         |  11 +-
 drivers/media/usb/gspca/mr97310a.c                 |   3 +-
 drivers/media/usb/gspca/ov519.c                    |   3 +-
 drivers/media/usb/gspca/pac207.c                   |   4 +-
 drivers/media/usb/gspca/pac7302.c                  |   3 +-
 drivers/media/usb/gspca/sn9c20x.c                  |   6 +-
 drivers/media/usb/gspca/sq905.c                    |   3 +-
 drivers/media/usb/gspca/sq905c.c                   |   4 +-
 drivers/media/usb/gspca/stv06xx/stv06xx.c          |   9 +-
 drivers/media/usb/gspca/sunplus.c                  |   3 +-
 drivers/media/usb/gspca/topro.c                    |   3 +-
 drivers/media/usb/gspca/zc3xx.c                    |   3 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |   9 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   7 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-audio.c          |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c       |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c    |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c       |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c         |   7 +-
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c        |  29 +--
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            | 181 +++++---------
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |  33 +--
 drivers/media/usb/pvrusb2/pvrusb2-io.c             |  35 +--
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c         |  36 +--
 drivers/media/usb/pvrusb2/pvrusb2-std.c            |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |  10 +-
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c      |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c         |   3 +-
 drivers/media/usb/pwc/pwc-if.c                     |   4 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |   6 +-
 drivers/media/usb/siano/smsusb.c                   |   4 +-
 drivers/media/usb/stkwebcam/stk-sensor.c           |   4 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   3 +-
 drivers/media/usb/tm6000/tm6000-alsa.c             |   4 +-
 drivers/media/usb/tm6000/tm6000-core.c             |  14 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |  16 +-
 drivers/media/usb/tm6000/tm6000-i2c.c              |   3 +-
 drivers/media/usb/tm6000/tm6000-stds.c             |   3 +-
 drivers/media/usb/tm6000/tm6000-video.c            |  18 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |   3 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |  20 +-
 drivers/media/usb/usbvision/usbvision-core.c       |  20 +-
 drivers/media/usb/usbvision/usbvision-video.c      |   4 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  36 +--
 drivers/media/usb/uvc/uvc_debugfs.c                |   5 +-
 drivers/media/usb/uvc/uvc_driver.c                 | 278 +++++++++++----------
 drivers/media/usb/uvc/uvc_entity.c                 |  10 +-
 drivers/media/usb/uvc/uvc_isight.c                 |  12 +-
 drivers/media/usb/uvc/uvc_status.c                 |  23 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  11 +-
 drivers/media/usb/uvc/uvc_video.c                  | 103 ++++----
 drivers/media/usb/zr364xx/zr364xx.c                |   6 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  91 ++-----
 drivers/media/v4l2-core/videobuf-core.c            |   3 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  25 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  10 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |   3 +-
 246 files changed, 1232 insertions(+), 1708 deletions(-)

-- 
2.7.4


