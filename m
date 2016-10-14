Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59047 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753255AbcJNUWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Oct 2016 16:22:43 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 00/57] don't break long lines on strings
Date: Fri, 14 Oct 2016 17:19:48 -0300
Message-Id: <cover.1476475770.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
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

I used the following perl script to merge the strings into a single
line (I ran it 10 times for each file):

#!/usr/bin/perl

while (<>) {
	if ($next ne "") {
		$c=$_;
		if ($c =~ /^\s+\"(.*)/) {
			$c2=$1;
			$next =~ s/\"\n$//;
			print "$next$c2\n";
			$next="";
			next;
		} else {
			print $next;
		}
		$next="";
	} else {
		if (m/\"$/) {
			if (!m/\\n\"$/) {
				$next=$_;
				next;
			}
		}
	}
	print $_;
}

I did a few manual adjustments afterwards.

Mauro Carvalho Chehab (57):
  [media] b2c2: don't break long lines
  [media] dvb-frontends: don't break long lines
  [media] firewire: don't break long lines
  [media] cx25840: don't break long lines
  [media] smiapp: don't break long lines
  [media] soc_camera: don't break long lines
  [media] b2c2: don't break long lines
  [media] bt8xx: don't break long lines
  [media] cx18: don't break long lines
  [media] cx23885: don't break long lines
  [media] cx88: don't break long lines
  [media] ddbridge: don't break long lines
  [media] dm1105: don't break long lines
  [media] ivtv: don't break long lines
  [media] meye: don't break long lines
  [media] pt1: don't break long lines
  [media] saa7134: don't break long lines
  [media] saa7164: don't break long lines
  [media] solo6x10: don't break long lines
  [media] ttpci: don't break long lines
  [media] tw68: don't break long lines
  [media] davinci: don't break long lines
  [media] exynos4-is: don't break long lines
  [media] marvell-ccic: don't break long lines
  [media] omap: don't break long lines
  [media] omap3isp: don't break long lines
  [media] s5p-mfc: don't break long lines
  [media] c8sectpfe: don't break long lines
  [media] ti-vpe: don't break long lines
  [media] si470x: don't break long lines
  [media] si4713: don't break long lines
  [media] wl128x: don't break long lines
  [media] au0828: don't break long lines
  [media] b2c2: don't break long lines
  [media] cpia2: don't break long lines
  [media] cx231xx: don't break long lines
  [media] dvb-usb: don't break long lines
  [media] dvb-usb-v2: don't break long lines
  [media] em28xx: don't break long lines
  [media] hdpvr: don't break long lines
  [media] pvrusb2: don't break long lines
  [media] pwc: don't break long lines
  [media] siano: don't break long lines
  [media] stkwebcam: don't break long lines
  [media] tm6000: don't break long lines
  [media] ttusb-budget: don't break long lines
  [media] ttusb-dec: don't break long lines
  [media] usbvision: don't break long lines
  [media] uvc: don't break long lines
  [media] zr364xx: don't break long lines
  [media] v4l2-core: don't break long lines
  [media] common: don't break long lines
  [media] i2c: don't break long lines
  [media] platform: don't break long lines
  [media] radio: don't break long lines
  [media] rc: don't break long lines
  [media] tuners: don't break long lines

 drivers/media/common/b2c2/flexcop-eeprom.c         |   3 +-
 drivers/media/common/b2c2/flexcop-i2c.c            |   3 +-
 drivers/media/common/b2c2/flexcop-misc.c           |   9 +-
 drivers/media/common/b2c2/flexcop.c                |   3 +-
 drivers/media/common/tveeprom.c                    |   3 +-
 drivers/media/dvb-frontends/au8522_common.c        |   4 +-
 drivers/media/dvb-frontends/cx24110.c              |   4 +-
 drivers/media/dvb-frontends/cx24113.c              |   4 +-
 drivers/media/dvb-frontends/cx24116.c              |  10 +-
 drivers/media/dvb-frontends/cx24117.c              |   4 +-
 drivers/media/dvb-frontends/cx24123.c              |   4 +-
 drivers/media/dvb-frontends/ds3000.c               |  15 +-
 drivers/media/dvb-frontends/lgdt330x.c             |   3 +-
 drivers/media/dvb-frontends/m88rs2000.c            |  11 +-
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
 drivers/media/dvb-frontends/stv0288.c              |  11 +-
 drivers/media/dvb-frontends/stv0297.c              |   4 +-
 drivers/media/dvb-frontends/stv0299.c              |   7 +-
 drivers/media/dvb-frontends/stv0900_sw.c           |   3 +-
 drivers/media/dvb-frontends/tda10021.c             |   3 +-
 drivers/media/dvb-frontends/tda10023.c             |   6 +-
 drivers/media/dvb-frontends/tda10048.c             |  12 +-
 drivers/media/dvb-frontends/ves1820.c              |   8 +-
 drivers/media/dvb-frontends/zl10036.c              |   4 +-
 drivers/media/dvb-frontends/zl10039.c              |   3 +-
 drivers/media/firewire/firedtv-avc.c               |   5 +-
 drivers/media/firewire/firedtv-rc.c                |   5 +-
 drivers/media/i2c/as3645a.c                        |   9 +-
 drivers/media/i2c/cx25840/cx25840-core.c           |  11 +-
 drivers/media/i2c/cx25840/cx25840-ir.c             |   6 +-
 drivers/media/i2c/msp3400-kthreads.c               |   3 +-
 drivers/media/i2c/mt9m032.c                        |   3 +-
 drivers/media/i2c/mt9p031.c                        |   3 +-
 drivers/media/i2c/saa7115.c                        |   3 +-
 drivers/media/i2c/saa717x.c                        |   3 +-
 drivers/media/i2c/smiapp/smiapp-regs.c             |   3 +-
 drivers/media/i2c/soc_camera/ov772x.c              |   3 +-
 drivers/media/i2c/soc_camera/ov9740.c              |   3 +-
 drivers/media/i2c/soc_camera/tw9910.c              |   3 +-
 drivers/media/i2c/ths8200.c                        |   4 +-
 drivers/media/i2c/tvp5150.c                        |   3 +-
 drivers/media/i2c/tvp7002.c                        |   3 +-
 drivers/media/i2c/upd64083.c                       |   3 +-
 drivers/media/pci/b2c2/flexcop-dma.c               |   6 +-
 drivers/media/pci/b2c2/flexcop-pci.c               |   6 +-
 drivers/media/pci/bt8xx/bttv-cards.c               |   9 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   6 +-
 drivers/media/pci/bt8xx/bttv-i2c.c                 |   6 +-
 drivers/media/pci/bt8xx/bttv-input.c               |   3 +-
 drivers/media/pci/cx18/cx18-alsa-main.c            |   6 +-
 drivers/media/pci/cx18/cx18-av-core.c              |  14 +-
 drivers/media/pci/cx18/cx18-av-firmware.c          |   3 +-
 drivers/media/pci/cx18/cx18-controls.c             |   9 +-
 drivers/media/pci/cx18/cx18-driver.c               |  30 ++--
 drivers/media/pci/cx18/cx18-dvb.c                  |   6 +-
 drivers/media/pci/cx18/cx18-fileops.c              |   6 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |   6 +-
 drivers/media/pci/cx18/cx18-irq.c                  |   3 +-
 drivers/media/pci/cx18/cx18-mailbox.c              |  35 ++---
 drivers/media/pci/cx18/cx18-queue.c                |   7 +-
 drivers/media/pci/cx18/cx18-streams.c              |   6 +-
 drivers/media/pci/cx23885/cimax2.c                 |   4 +-
 drivers/media/pci/cx23885/cx23885-417.c            |  15 +-
 drivers/media/pci/cx23885/cx23885-alsa.c           |  12 +-
 drivers/media/pci/cx23885/cx23885-cards.c          |   7 +-
 drivers/media/pci/cx23885/cx23885-core.c           |  12 +-
 drivers/media/pci/cx23885/cx23885-dvb.c            |   3 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   3 +-
 drivers/media/pci/cx23885/cx23888-ir.c             |   6 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |  13 +-
 drivers/media/pci/cx88/cx88-cards.c                |  12 +-
 drivers/media/pci/cx88/cx88-dsp.c                  |   9 +-
 drivers/media/pci/cx88/cx88-dvb.c                  |   6 +-
 drivers/media/pci/cx88/cx88-i2c.c                  |   3 +-
 drivers/media/pci/cx88/cx88-mpeg.c                 |  12 +-
 drivers/media/pci/cx88/cx88-tvaudio.c              |   6 +-
 drivers/media/pci/cx88/cx88-video.c                |   3 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |   6 +-
 drivers/media/pci/dm1105/dm1105.c                  |   3 +-
 drivers/media/pci/ivtv/ivtv-alsa-main.c            |   9 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |  36 ++---
 drivers/media/pci/ivtv/ivtv-firmware.c             |   3 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                  |   6 +-
 drivers/media/pci/ivtv/ivtvfb.c                    |   3 +-
 drivers/media/pci/meye/meye.c                      |  12 +-
 drivers/media/pci/pt1/pt1.c                        |   6 +-
 drivers/media/pci/saa7134/saa7134-alsa.c           |   3 +-
 drivers/media/pci/saa7134/saa7134-cards.c          |   6 +-
 drivers/media/pci/saa7134/saa7134-core.c           |  29 ++--
 drivers/media/pci/saa7134/saa7134-dvb.c            |  24 +--
 drivers/media/pci/saa7134/saa7134-input.c          |  12 +-
 drivers/media/pci/saa7164/saa7164-buffer.c         |   3 +-
 drivers/media/pci/saa7164/saa7164-bus.c            |   3 +-
 drivers/media/pci/saa7164/saa7164-cards.c          |   3 +-
 drivers/media/pci/saa7164/saa7164-cmd.c            |  10 +-
 drivers/media/pci/saa7164/saa7164-core.c           |  56 +++----
 drivers/media/pci/saa7164/saa7164-dvb.c            |  27 ++--
 drivers/media/pci/saa7164/saa7164-encoder.c        |  15 +-
 drivers/media/pci/saa7164/saa7164-fw.c             |   9 +-
 drivers/media/pci/saa7164/saa7164-vbi.c            |  12 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   3 +-
 drivers/media/pci/ttpci/av7110.c                   |  27 ++--
 drivers/media/pci/ttpci/av7110_hw.c                |  12 +-
 drivers/media/pci/ttpci/budget-av.c                |   3 +-
 drivers/media/pci/ttpci/budget-ci.c                |   4 +-
 drivers/media/pci/ttpci/budget-patch.c             |   3 +-
 drivers/media/pci/ttpci/budget.c                   |   3 +-
 drivers/media/pci/ttpci/ttpci-eeprom.c             |   3 +-
 drivers/media/pci/tw68/tw68-video.c                |  12 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |   3 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |   3 +-
 drivers/media/platform/davinci/vpbe.c              |  15 +-
 drivers/media/platform/davinci/vpfe_capture.c      |   6 +-
 drivers/media/platform/davinci/vpif_capture.c      |   9 +-
 drivers/media/platform/davinci/vpif_display.c      |   9 +-
 drivers/media/platform/davinci/vpss.c              |   6 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   3 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |  26 +--
 drivers/media/platform/mx2_emmaprp.c               |   3 +-
 drivers/media/platform/omap/omap_vout.c            |  12 +-
 drivers/media/platform/omap/omap_vout_vrfb.c       |   3 +-
 drivers/media/platform/omap3isp/isp.c              |   3 +-
 drivers/media/platform/omap3isp/ispccdc.c          |   6 +-
 drivers/media/platform/omap3isp/ispcsi2.c          |  11 +-
 drivers/media/platform/omap3isp/ispcsiphy.c        |   3 +-
 drivers/media/platform/omap3isp/isph3a_aewb.c      |   6 +-
 drivers/media/platform/omap3isp/isph3a_af.c        |   6 +-
 drivers/media/platform/omap3isp/ispstat.c          |  36 ++---
 drivers/media/platform/pxa_camera.c                |   6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   6 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c    |   7 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |  15 +-
 drivers/media/platform/ti-vpe/vpdma.c              |  12 +-
 drivers/media/platform/ti-vpe/vpe.c                |   3 +-
 drivers/media/platform/via-camera.c                |   7 +-
 drivers/media/radio/radio-gemtek.c                 |   8 +-
 drivers/media/radio/radio-wl1273.c                 |   3 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   6 +-
 drivers/media/radio/si470x/radio-si470x-usb.c      |  12 +-
 drivers/media/radio/si4713/si4713.c                |   7 +-
 drivers/media/radio/wl128x/fmdrv_common.c          |  21 +--
 drivers/media/radio/wl128x/fmdrv_rx.c              |   6 +-
 drivers/media/rc/ati_remote.c                      |   3 +-
 drivers/media/rc/ene_ir.c                          |   3 +-
 drivers/media/rc/imon.c                            |  43 ++---
 drivers/media/rc/ite-cir.c                         |   9 +-
 drivers/media/rc/mceusb.c                          |   4 +-
 drivers/media/rc/rc-main.c                         |   3 +-
 drivers/media/rc/redrat3.c                         |  18 +--
 drivers/media/rc/streamzap.c                       |   9 +-
 drivers/media/rc/winbond-cir.c                     |   9 +-
 drivers/media/tuners/fc0011.c                      |   7 +-
 drivers/media/tuners/mc44s803.c                    |   3 +-
 drivers/media/tuners/tda18271-common.c             |   3 +-
 drivers/media/tuners/tda18271-fe.c                 |   3 +-
 drivers/media/tuners/tda18271-maps.c               |   6 +-
 drivers/media/tuners/tda8290.c                     |   3 +-
 drivers/media/tuners/tea5761.c                     |   6 +-
 drivers/media/tuners/tuner-simple.c                |  39 ++---
 drivers/media/tuners/xc4000.c                      |  25 +--
 drivers/media/usb/au0828/au0828-video.c            |   3 +-
 drivers/media/usb/b2c2/flexcop-usb.c               |   9 +-
 drivers/media/usb/cpia2/cpia2_usb.c                |   4 +-
 drivers/media/usb/cx231xx/cx231xx-core.c           |   9 +-
 drivers/media/usb/cx231xx/cx231xx-dvb.c            |   3 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c        |  10 +-
 drivers/media/usb/dvb-usb-v2/mxl111sf.c            |   9 +-
 drivers/media/usb/dvb-usb/cinergyT2-core.c         |   6 +-
 drivers/media/usb/dvb-usb/dib0700_core.c           |   5 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c        |   3 +-
 drivers/media/usb/dvb-usb/dvb-usb-dvb.c            |   3 +-
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c       |   6 +-
 drivers/media/usb/dvb-usb/dw2102.c                 |  10 +-
 drivers/media/usb/dvb-usb/friio.c                  |   3 +-
 drivers/media/usb/dvb-usb/gp8psk.c                 |   3 +-
 drivers/media/usb/dvb-usb/opera1.c                 |   3 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c         |   3 +-
 drivers/media/usb/em28xx/em28xx-cards.c            |   3 +-
 drivers/media/usb/hdpvr/hdpvr-core.c               |   9 +-
 drivers/media/usb/hdpvr/hdpvr-i2c.c                |   6 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-audio.c          |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-cs53l32a.c       |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-cx2584x-v4l.c    |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-debugifc.c       |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c         |   6 +-
 drivers/media/usb/pvrusb2/pvrusb2-encoder.c        |  28 +---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            | 175 +++++++--------------
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c       |  33 ++--
 drivers/media/usb/pvrusb2/pvrusb2-io.c             |  33 ++--
 drivers/media/usb/pvrusb2/pvrusb2-ioread.c         |  33 ++--
 drivers/media/usb/pvrusb2/pvrusb2-std.c            |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           |   9 +-
 drivers/media/usb/pvrusb2/pvrusb2-video-v4l.c      |   4 +-
 drivers/media/usb/pvrusb2/pvrusb2-wm8775.c         |   3 +-
 drivers/media/usb/pwc/pwc-if.c                     |   3 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |   6 +-
 drivers/media/usb/siano/smsusb.c                   |   3 +-
 drivers/media/usb/stkwebcam/stk-sensor.c           |   3 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   3 +-
 drivers/media/usb/tm6000/tm6000-alsa.c             |   4 +-
 drivers/media/usb/tm6000/tm6000-core.c             |  11 +-
 drivers/media/usb/tm6000/tm6000-dvb.c              |  16 +-
 drivers/media/usb/tm6000/tm6000-i2c.c              |   3 +-
 drivers/media/usb/tm6000/tm6000-stds.c             |   3 +-
 drivers/media/usb/tm6000/tm6000-video.c            |  15 +-
 drivers/media/usb/ttusb-budget/dvb-ttusb-budget.c  |   3 +-
 drivers/media/usb/ttusb-dec/ttusb_dec.c            |  18 +--
 drivers/media/usb/usbvision/usbvision-core.c       |  15 +-
 drivers/media/usb/usbvision/usbvision-video.c      |   3 +-
 drivers/media/usb/uvc/uvc_ctrl.c                   |  24 +--
 drivers/media/usb/uvc/uvc_debugfs.c                |   3 +-
 drivers/media/usb/uvc/uvc_driver.c                 | 148 ++++++-----------
 drivers/media/usb/uvc/uvc_entity.c                 |   6 +-
 drivers/media/usb/uvc/uvc_isight.c                 |   9 +-
 drivers/media/usb/uvc/uvc_status.c                 |  15 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   6 +-
 drivers/media/usb/uvc/uvc_video.c                  |  69 +++-----
 drivers/media/usb/zr364xx/zr364xx.c                |   6 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  90 +++--------
 drivers/media/v4l2-core/videobuf-core.c            |   3 +-
 drivers/media/v4l2-core/videobuf2-core.c           |  21 +--
 drivers/media/v4l2-core/videobuf2-v4l2.c           |   9 +-
 drivers/media/v4l2-core/videobuf2-vmalloc.c        |   3 +-
 233 files changed, 781 insertions(+), 1611 deletions(-)

-- 
2.7.4


