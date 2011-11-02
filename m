Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab1KBLqR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 07:46:17 -0400
Date: Wed, 2 Nov 2011 09:45:09 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: devel@driverdev.osuosl.org, Greg KH <gregkh@suse.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 0/3] Move media staging drivers to staging/media
Message-ID: <20111102094509.4954fead@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg,

As agreed, this is the patches that move media drivers to their
own places. Basically, cx25821 now seems ready to be at the standard
place, while the other drivers should still be in staging for a while.

The cxd2099 is a special case. This is an optional driver for handling
encrypted DVB streams. It abuses of the DVB API and, while we don't
have a proper way for handling it, we should keep it at staging, as
its API will change after we add proper support for it. According with
KS Workshop discussions, the proper way seems to add Media Controller
capabilities for DVB, and allow changing the DVB pipelines to add
a decriptor if/when needed.

PS.: I'll likely merge patch 3 with patch 2 when submitting it
upstream.

Mauro Carvalho Chehab (3):
  [media] move cx25821 out of staging
  staging: Move media drivers to staging/media
  staging/Makefile: Don't compile a media driver there

 drivers/media/dvb/ddbridge/Makefile                |    2 +-
 drivers/media/dvb/ngene/Makefile                   |    2 +-
 drivers/media/video/Kconfig                        |    2 +
 drivers/media/video/Makefile                       |    1 +
 drivers/{staging => media/video}/cx25821/Kconfig   |    0
 drivers/{staging => media/video}/cx25821/Makefile  |    0
 .../video}/cx25821/cx25821-alsa.c                  |    0
 .../video}/cx25821/cx25821-audio-upstream.c        |    0
 .../video}/cx25821/cx25821-audio-upstream.h        |    0
 .../video}/cx25821/cx25821-audio.h                 |    0
 .../video}/cx25821/cx25821-biffuncs.h              |    0
 .../video}/cx25821/cx25821-cards.c                 |    0
 .../video}/cx25821/cx25821-core.c                  |    0
 .../video}/cx25821/cx25821-gpio.c                  |    0
 .../{staging => media/video}/cx25821/cx25821-i2c.c |    0
 .../video}/cx25821/cx25821-medusa-defines.h        |    0
 .../video}/cx25821/cx25821-medusa-reg.h            |    0
 .../video}/cx25821/cx25821-medusa-video.c          |    0
 .../video}/cx25821/cx25821-medusa-video.h          |    0
 .../{staging => media/video}/cx25821/cx25821-reg.h |    0
 .../video}/cx25821/cx25821-sram.h                  |    0
 .../video}/cx25821/cx25821-video-upstream-ch2.c    |    0
 .../video}/cx25821/cx25821-video-upstream-ch2.h    |    0
 .../video}/cx25821/cx25821-video-upstream.c        |    0
 .../video}/cx25821/cx25821-video-upstream.h        |    0
 .../video}/cx25821/cx25821-video.c                 |    0
 .../video}/cx25821/cx25821-video.h                 |    0
 drivers/{staging => media/video}/cx25821/cx25821.h |    0
 drivers/staging/Kconfig                            |   16 +--------
 drivers/staging/Makefile                           |    9 +----
 drivers/staging/cx25821/README                     |    6 ---
 drivers/staging/media/Kconfig                      |   37 ++++++++++++++++++++
 drivers/staging/media/Makefile                     |    7 ++++
 drivers/staging/{ => media}/cxd2099/Kconfig        |    0
 drivers/staging/{ => media}/cxd2099/Makefile       |    0
 drivers/staging/{ => media}/cxd2099/TODO           |    0
 drivers/staging/{ => media}/cxd2099/cxd2099.c      |    0
 drivers/staging/{ => media}/cxd2099/cxd2099.h      |    0
 drivers/staging/{ => media}/dt3155v4l/Kconfig      |    0
 drivers/staging/{ => media}/dt3155v4l/Makefile     |    0
 drivers/staging/{ => media}/dt3155v4l/dt3155v4l.c  |    0
 drivers/staging/{ => media}/dt3155v4l/dt3155v4l.h  |    0
 drivers/staging/{ => media}/easycap/Kconfig        |    0
 drivers/staging/{ => media}/easycap/Makefile       |    0
 drivers/staging/{ => media}/easycap/README         |    0
 drivers/staging/{ => media}/easycap/easycap.h      |    0
 .../staging/{ => media}/easycap/easycap_ioctl.c    |    0
 drivers/staging/{ => media}/easycap/easycap_low.c  |    0
 drivers/staging/{ => media}/easycap/easycap_main.c |    0
 .../staging/{ => media}/easycap/easycap_settings.c |    0
 .../staging/{ => media}/easycap/easycap_sound.c    |    0
 .../staging/{ => media}/easycap/easycap_testcard.c |    0
 drivers/staging/{ => media}/go7007/Kconfig         |    0
 drivers/staging/{ => media}/go7007/Makefile        |    0
 drivers/staging/{ => media}/go7007/README          |    0
 drivers/staging/{ => media}/go7007/go7007-driver.c |    0
 drivers/staging/{ => media}/go7007/go7007-fw.c     |    0
 drivers/staging/{ => media}/go7007/go7007-i2c.c    |    0
 drivers/staging/{ => media}/go7007/go7007-priv.h   |    0
 drivers/staging/{ => media}/go7007/go7007-usb.c    |    0
 drivers/staging/{ => media}/go7007/go7007-v4l2.c   |    0
 drivers/staging/{ => media}/go7007/go7007.h        |    0
 drivers/staging/{ => media}/go7007/go7007.txt      |    0
 drivers/staging/{ => media}/go7007/s2250-board.c   |    0
 drivers/staging/{ => media}/go7007/s2250-loader.c  |    0
 drivers/staging/{ => media}/go7007/s2250-loader.h  |    0
 .../staging/{ => media}/go7007/saa7134-go7007.c    |    0
 drivers/staging/{ => media}/go7007/snd-go7007.c    |    0
 drivers/staging/{ => media}/go7007/wis-i2c.h       |    0
 drivers/staging/{ => media}/go7007/wis-ov7640.c    |    0
 drivers/staging/{ => media}/go7007/wis-saa7113.c   |    0
 drivers/staging/{ => media}/go7007/wis-saa7115.c   |    0
 .../staging/{ => media}/go7007/wis-sony-tuner.c    |    0
 drivers/staging/{ => media}/go7007/wis-tw2804.c    |    0
 drivers/staging/{ => media}/go7007/wis-tw9903.c    |    0
 drivers/staging/{ => media}/go7007/wis-uda1342.c   |    0
 drivers/staging/{ => media}/lirc/Kconfig           |    0
 drivers/staging/{ => media}/lirc/Makefile          |    0
 drivers/staging/{ => media}/lirc/TODO              |    0
 drivers/staging/{ => media}/lirc/TODO.lirc_zilog   |    0
 drivers/staging/{ => media}/lirc/lirc_bt829.c      |    0
 drivers/staging/{ => media}/lirc/lirc_ene0100.h    |    0
 .../staging/{ => media}/lirc/lirc_igorplugusb.c    |    0
 drivers/staging/{ => media}/lirc/lirc_imon.c       |    0
 drivers/staging/{ => media}/lirc/lirc_parallel.c   |    0
 drivers/staging/{ => media}/lirc/lirc_parallel.h   |    0
 drivers/staging/{ => media}/lirc/lirc_sasem.c      |    0
 drivers/staging/{ => media}/lirc/lirc_serial.c     |    0
 drivers/staging/{ => media}/lirc/lirc_sir.c        |    0
 drivers/staging/{ => media}/lirc/lirc_ttusbir.c    |    0
 drivers/staging/{ => media}/lirc/lirc_zilog.c      |    0
 drivers/staging/{ => media}/solo6x10/Kconfig       |    0
 drivers/staging/{ => media}/solo6x10/Makefile      |    0
 drivers/staging/{ => media}/solo6x10/TODO          |    0
 drivers/staging/{ => media}/solo6x10/core.c        |    0
 drivers/staging/{ => media}/solo6x10/disp.c        |    0
 drivers/staging/{ => media}/solo6x10/enc.c         |    0
 drivers/staging/{ => media}/solo6x10/g723.c        |    0
 drivers/staging/{ => media}/solo6x10/gpio.c        |    0
 drivers/staging/{ => media}/solo6x10/i2c.c         |    0
 drivers/staging/{ => media}/solo6x10/jpeg.h        |    0
 drivers/staging/{ => media}/solo6x10/offsets.h     |    0
 drivers/staging/{ => media}/solo6x10/osd-font.h    |    0
 drivers/staging/{ => media}/solo6x10/p2m.c         |    0
 drivers/staging/{ => media}/solo6x10/registers.h   |    0
 drivers/staging/{ => media}/solo6x10/solo6x10.h    |    0
 drivers/staging/{ => media}/solo6x10/tw28.c        |    0
 drivers/staging/{ => media}/solo6x10/tw28.h        |    0
 drivers/staging/{ => media}/solo6x10/v4l2-enc.c    |    0
 drivers/staging/{ => media}/solo6x10/v4l2.c        |    0
 110 files changed, 51 insertions(+), 31 deletions(-)
 rename drivers/{staging => media/video}/cx25821/Kconfig (100%)
 rename drivers/{staging => media/video}/cx25821/Makefile (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-alsa.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio-upstream.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio-upstream.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-audio.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-biffuncs.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-cards.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-core.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-gpio.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-i2c.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-defines.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-reg.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-video.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-medusa-video.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-reg.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-sram.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream-ch2.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream-ch2.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video-upstream.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video.c (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821-video.h (100%)
 rename drivers/{staging => media/video}/cx25821/cx25821.h (100%)
 delete mode 100644 drivers/staging/cx25821/README
 create mode 100644 drivers/staging/media/Kconfig
 create mode 100644 drivers/staging/media/Makefile
 rename drivers/staging/{ => media}/cxd2099/Kconfig (100%)
 rename drivers/staging/{ => media}/cxd2099/Makefile (100%)
 rename drivers/staging/{ => media}/cxd2099/TODO (100%)
 rename drivers/staging/{ => media}/cxd2099/cxd2099.c (100%)
 rename drivers/staging/{ => media}/cxd2099/cxd2099.h (100%)
 rename drivers/staging/{ => media}/dt3155v4l/Kconfig (100%)
 rename drivers/staging/{ => media}/dt3155v4l/Makefile (100%)
 rename drivers/staging/{ => media}/dt3155v4l/dt3155v4l.c (100%)
 rename drivers/staging/{ => media}/dt3155v4l/dt3155v4l.h (100%)
 rename drivers/staging/{ => media}/easycap/Kconfig (100%)
 rename drivers/staging/{ => media}/easycap/Makefile (100%)
 rename drivers/staging/{ => media}/easycap/README (100%)
 rename drivers/staging/{ => media}/easycap/easycap.h (100%)
 rename drivers/staging/{ => media}/easycap/easycap_ioctl.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_low.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_main.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_settings.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_sound.c (100%)
 rename drivers/staging/{ => media}/easycap/easycap_testcard.c (100%)
 rename drivers/staging/{ => media}/go7007/Kconfig (100%)
 rename drivers/staging/{ => media}/go7007/Makefile (100%)
 rename drivers/staging/{ => media}/go7007/README (100%)
 rename drivers/staging/{ => media}/go7007/go7007-driver.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-fw.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-i2c.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-priv.h (100%)
 rename drivers/staging/{ => media}/go7007/go7007-usb.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007-v4l2.c (100%)
 rename drivers/staging/{ => media}/go7007/go7007.h (100%)
 rename drivers/staging/{ => media}/go7007/go7007.txt (100%)
 rename drivers/staging/{ => media}/go7007/s2250-board.c (100%)
 rename drivers/staging/{ => media}/go7007/s2250-loader.c (100%)
 rename drivers/staging/{ => media}/go7007/s2250-loader.h (100%)
 rename drivers/staging/{ => media}/go7007/saa7134-go7007.c (100%)
 rename drivers/staging/{ => media}/go7007/snd-go7007.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-i2c.h (100%)
 rename drivers/staging/{ => media}/go7007/wis-ov7640.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-saa7113.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-saa7115.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-sony-tuner.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-tw2804.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-tw9903.c (100%)
 rename drivers/staging/{ => media}/go7007/wis-uda1342.c (100%)
 rename drivers/staging/{ => media}/lirc/Kconfig (100%)
 rename drivers/staging/{ => media}/lirc/Makefile (100%)
 rename drivers/staging/{ => media}/lirc/TODO (100%)
 rename drivers/staging/{ => media}/lirc/TODO.lirc_zilog (100%)
 rename drivers/staging/{ => media}/lirc/lirc_bt829.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_ene0100.h (100%)
 rename drivers/staging/{ => media}/lirc/lirc_igorplugusb.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_imon.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_parallel.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_parallel.h (100%)
 rename drivers/staging/{ => media}/lirc/lirc_sasem.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_serial.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_sir.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_ttusbir.c (100%)
 rename drivers/staging/{ => media}/lirc/lirc_zilog.c (100%)
 rename drivers/staging/{ => media}/solo6x10/Kconfig (100%)
 rename drivers/staging/{ => media}/solo6x10/Makefile (100%)
 rename drivers/staging/{ => media}/solo6x10/TODO (100%)
 rename drivers/staging/{ => media}/solo6x10/core.c (100%)
 rename drivers/staging/{ => media}/solo6x10/disp.c (100%)
 rename drivers/staging/{ => media}/solo6x10/enc.c (100%)
 rename drivers/staging/{ => media}/solo6x10/g723.c (100%)
 rename drivers/staging/{ => media}/solo6x10/gpio.c (100%)
 rename drivers/staging/{ => media}/solo6x10/i2c.c (100%)
 rename drivers/staging/{ => media}/solo6x10/jpeg.h (100%)
 rename drivers/staging/{ => media}/solo6x10/offsets.h (100%)
 rename drivers/staging/{ => media}/solo6x10/osd-font.h (100%)
 rename drivers/staging/{ => media}/solo6x10/p2m.c (100%)
 rename drivers/staging/{ => media}/solo6x10/registers.h (100%)
 rename drivers/staging/{ => media}/solo6x10/solo6x10.h (100%)
 rename drivers/staging/{ => media}/solo6x10/tw28.c (100%)
 rename drivers/staging/{ => media}/solo6x10/tw28.h (100%)
 rename drivers/staging/{ => media}/solo6x10/v4l2-enc.c (100%)
 rename drivers/staging/{ => media}/solo6x10/v4l2.c (100%)

-- 
1.7.6.4

