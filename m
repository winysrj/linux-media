Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59210 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbZHLWFd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2009 18:05:33 -0400
Date: Wed, 12 Aug 2009 19:05:23 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Message-ID: <20090812190523.75495888@caramujo.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For several fixes, including:

   - pxa_camera: Fix Oops in pxa_camera_probe;
   - ivtv, cx18: Read buffer overflow;
   - mtv9v011 (new driver): Some improvements to better control the webcam sensor;
   - zl10353 and qt1010: fix stack corruption bug;
   - cx23885-417: fix manipulation of tvnorms;
   - af9015: Fix for crash in dvb-usb-af9015;
   - sn9c20x: add subdriver entry to MAINTAINERS file;
   - sms1xxx: fix broken Hauppauge devices;
   - uvcvideo: Don't apply the FIX_BANDWIDTH quirk to all ViMicro devices;
   - uvcvideo: Avoid flooding the kernel log with "unknown event type" messages;
   - sms1xxx: fix build warning: unused variable 'board';
   - saa7134: Use correct product name for Hauppauge WinTV-HVR1150 ATSC/QAM-Hybrid;
   - saa7134: Use correct product name for Hauppauge WinTV-HVR1120 DVB-T/Hybrid;
   - cx88: HVR1300 ensure switching from Encoder to DVB-T and back is reliable;
   - cx88: fix regression in tuning for Geniatech X8000 MT;
   - cx88: Disable xc3028 power management for Geniatech x8000;
   - em28xx: fix support for Plextor ConvertX PX-TV100U;
   - em28xx: Several fixes at webcam support;
   - em28xx: fix regression in Empire DualTV digital tuning;
   - zr364xx: fix build errors;
   - soc-camera: fix recursive locking in .buf_queue();
   - hdpvr: add missing initialization of current_norm;
   - v4l2-ioctl: fix G_STD and G_PARM default handlers;
   - stk-webcam: read buffer overflow;
   - dvb: siano uses/depends on INPUT;
   - dvb: Use kzalloc for frontend states to have struct dvb_frontend properly;
   - siano: read buffer overflow.

Cheers,
Mauro.

---

 Documentation/video4linux/CARDLIST.em28xx   |    2 +-
 Documentation/video4linux/CARDLIST.saa7134  |    4 +-
 MAINTAINERS                                 |    8 ++
 drivers/media/common/tuners/qt1010.c        |   12 +-
 drivers/media/common/tuners/tuner-xc2028.c  |    4 +-
 drivers/media/common/tuners/tuner-xc2028.h  |    1 +
 drivers/media/dvb/dvb-usb/af9015.c          |    2 +-
 drivers/media/dvb/frontends/cx22700.c       |    2 +-
 drivers/media/dvb/frontends/cx22702.c       |    2 +-
 drivers/media/dvb/frontends/cx24110.c       |    2 +-
 drivers/media/dvb/frontends/dvb_dummy_fe.c  |    6 +-
 drivers/media/dvb/frontends/l64781.c        |    2 +-
 drivers/media/dvb/frontends/lgs8gl5.c       |    2 +-
 drivers/media/dvb/frontends/mt312.c         |    2 +-
 drivers/media/dvb/frontends/nxt6000.c       |    2 +-
 drivers/media/dvb/frontends/or51132.c       |    2 +-
 drivers/media/dvb/frontends/or51211.c       |    2 +-
 drivers/media/dvb/frontends/s5h1409.c       |    2 +-
 drivers/media/dvb/frontends/s5h1411.c       |    2 +-
 drivers/media/dvb/frontends/si21xx.c        |    2 +-
 drivers/media/dvb/frontends/sp8870.c        |    2 +-
 drivers/media/dvb/frontends/sp887x.c        |    2 +-
 drivers/media/dvb/frontends/stv0288.c       |    2 +-
 drivers/media/dvb/frontends/stv0297.c       |    2 +-
 drivers/media/dvb/frontends/stv0299.c       |    2 +-
 drivers/media/dvb/frontends/tda10021.c      |    2 +-
 drivers/media/dvb/frontends/tda10048.c      |    2 +-
 drivers/media/dvb/frontends/tda1004x.c      |    4 +-
 drivers/media/dvb/frontends/tda10086.c      |    2 +-
 drivers/media/dvb/frontends/tda8083.c       |    2 +-
 drivers/media/dvb/frontends/ves1820.c       |    2 +-
 drivers/media/dvb/frontends/ves1x93.c       |    2 +-
 drivers/media/dvb/frontends/zl10353.c       |   12 +-
 drivers/media/dvb/siano/Kconfig             |    2 +-
 drivers/media/dvb/siano/sms-cards.c         |  102 ----------------
 drivers/media/dvb/siano/smscoreapi.c        |    2 +-
 drivers/media/video/Kconfig                 |    2 +
 drivers/media/video/bw-qcam.c               |    2 +-
 drivers/media/video/cx18/cx18-controls.c    |    3 +-
 drivers/media/video/cx23885/cx23885-417.c   |    2 +
 drivers/media/video/cx88/cx88-cards.c       |    8 ++
 drivers/media/video/cx88/cx88-dvb.c         |    1 +
 drivers/media/video/cx88/cx88-mpeg.c        |    4 +
 drivers/media/video/em28xx/em28xx-cards.c   |  175 +++++++++++++++------------
 drivers/media/video/em28xx/em28xx-core.c    |    8 +-
 drivers/media/video/em28xx/em28xx-dvb.c     |    2 +-
 drivers/media/video/em28xx/em28xx-reg.h     |    3 +-
 drivers/media/video/em28xx/em28xx-video.c   |   77 +++++++++++--
 drivers/media/video/em28xx/em28xx.h         |    3 +
 drivers/media/video/hdpvr/hdpvr-video.c     |    2 +
 drivers/media/video/ivtv/ivtv-controls.c    |    3 +-
 drivers/media/video/mt9v011.c               |  156 ++++++++++++++++++++++--
 drivers/media/video/mt9v011.h               |    3 +-
 drivers/media/video/mx1_camera.c            |    6 +-
 drivers/media/video/mx3_camera.c            |   19 ++--
 drivers/media/video/pxa_camera.c            |    8 +-
 drivers/media/video/saa7134/saa7134-cards.c |   30 +++---
 drivers/media/video/saa7134/saa7134-dvb.c   |    4 +-
 drivers/media/video/saa7134/saa7134.h       |    4 +-
 drivers/media/video/sh_mobile_ceu_camera.c  |    5 +-
 drivers/media/video/stk-webcam.c            |    4 +-
 drivers/media/video/uvc/uvc_driver.c        |   24 +++-
 drivers/media/video/uvc/uvc_status.c        |    4 +-
 drivers/media/video/v4l2-ioctl.c            |   15 ++-
 64 files changed, 478 insertions(+), 306 deletions(-)

Andy Walls (1):
      V4L/DVB (12338): cx18: Read buffer overflow

Antonio Ospite (1):
      V4L/DVB (12330): pxa_camera: Fix Oops in pxa_camera_probe

Brian Johnson (1):
      V4L/DVB (12373a): Add gspca sn9c20x subdriver entry to MAINTAINERS file

Devin Heitmueller (3):
      V4L/DVB (12393): cx88: fix regression in tuning for Geniatech X8000 MT
      V4L/DVB (12394): cx88: Disable xc3028 power management for Geniatech x8000
      V4L/DVB (12432): em28xx: fix regression in Empire DualTV digital tuning

Guennadi Liakhovetski (1):
      V4L/DVB (12424): soc-camera: fix recursive locking in .buf_queue()

Hans Verkuil (2):
      V4L/DVB (12428): hdpvr: add missing initialization of current_norm
      V4L/DVB (12429): v4l2-ioctl: fix G_STD and G_PARM default handlers

Jan Nikitenko (1):
      V4L/DVB (12341): zl10353 and qt1010: fix stack corruption bug

Laurent Pinchart (2):
      V4L/DVB (12328): uvcvideo: Don't apply the FIX_BANDWIDTH quirk to all ViMicro devices
      V4L/DVB (12380): uvcvideo: Avoid flooding the kernel log with "unknown event type" messages

Matthias Schwarzott (1):
      V4L/DVB (12440): Use kzalloc for frontend states to have struct dvb_frontend properly

Mauro Carvalho Chehab (12):
      V4L/DVB (12340): mtv9v011: Add a missing chip version to the driver
      V4L/DVB (12344): em28xx: fix support for Plextor ConvertX PX-TV100U
      V4L/DVB (12399): mt9v011: Add support for controlling frame rates
      V4L/DVB (12400): em28xx: Allow changing fps on webcams
      V4L/DVB (12401): m9v011: add vflip/hflip controls to control mirror/upside down
      V4L/DVB (12402): em28xx: fix: some em2710 chips use a different vendor ID
      V4L/DVB (12403): em28xx: properly reports some em2710 chips
      V4L/DVB (12406): em28xx: fix: don't do image interlacing on webcams
      V4L/DVB (12407): em28xx: Adjust Silvercrest xtal frequency
      V4L/DVB (12410): em28xx: Move the non-board dependent part to be outside em28xx_pre_card_setup()
      V4L/DVB (12411): em28xx: Fix artifacts with Silvercrest webcam
      V4L/DVB (12405): em28xx-cards: move register 0x13 setting to the proper place

Michael Krufky (5):
      V4L/DVB (12362): cx23885-417: fix manipulation of tvnorms
      V4L/DVB (12374): sms1xxx: fix broken Hauppauge devices
      V4L/DVB (12386): sms1xxx: fix build warning: unused variable 'board'
      V4L/DVB (12390): saa7134: Use correct product name for Hauppauge WinTV-HVR1150 ATSC/QAM-Hybrid
      V4L/DVB (12391): saa7134: Use correct product name for Hauppauge WinTV-HVR1120 DVB-T/Hybrid

Nils Kassube (1):
      V4L/DVB (12371): af9015: Fix for crash in dvb-usb-af9015

Randy Dunlap (2):
      V4L/DVB (12422): media/zr364xx: fix build errors
      V4L/DVB (12437): dvb: siano uses/depends on INPUT

Roel Kluin (4):
      V4L/DVB (12337): ivtv: Read buffer overflow
      V4L/DVB (12436): stk-webcam: read buffer overflow
      V4L/DVB (12438): Read buffer overflow
      V4L/DVB (12441): siano: read buffer overflow

Sohail Syyed (1):
      V4L/DVB (12349): cx88: HVR1300 ensure switching from Encoder to DVB-T and back is reliable

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
