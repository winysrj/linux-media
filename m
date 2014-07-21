Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:55221 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647AbaGURvN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 13:51:13 -0400
Date: Mon, 21 Jul 2014 14:51:05 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for 3.16-rc7] media fixes for master
Message-id: <20140721145105.416d098b.m.chehab@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

For a series of driver fixes:
	- Fix DVB-S tuning with tda1071;
	- Fix tuner probe on af9035 when the device has a bad eeprom;
	- Some fixes for the new si2168/2157 drivers;
	- one Kconfig build fix (for omap4iss);
	- Fixes at vpif error path;
	- Don't lock saa7134 ioctl at driver's base core level, as it now
	  uses V4L2 and VB2 locking schema;
	- Fix audio at hdpvr driver;
	- Fix the aspect ratio at the digital timings table;
	- One new USB ID (at gspca_pac7302): Genius i-Look 317 webcam

Regards,
Mauro

The following changes since commit a2668e10d7246e782f7708dc47c00f035da23a81:

  [media] au0828-dvb: restore its permission to 644 (2014-06-04 15:19:36 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media v4l_for_linus

for you to fetch changes up to 242841d3d71191348f98310e2d2001e1001d8630:

  [media] gspca_pac7302: Add new usb-id for Genius i-Look 317 (2014-07-14 21:06:35 -0300)

----------------------------------------------------------------
Antti Palosaari (8):
      [media] si2168: add one missing parenthesis
      [media] si2157: add one missing parenthesis
      [media] si2168: firmware download fix
      [media] af9035: override tuner id when bad value set into eeprom
      [media] tda10071: force modulation to QPSK on DVB-S
      [media] tda10071: add missing DVB-S2/PSK-8 FEC AUTO
      [media] tda10071: fix spec inversion reporting
      [media] tda10071: fix returned symbol rate calculation

Arnd Bergmann (1):
      [media] staging: tighten omap4iss dependencies

Dan Carpenter (1):
      [media] davinci: vpif: missing unlocks on error

Hans Verkuil (2):
      [media] saa7134: use unlocked_ioctl instead of ioctl
      [media] hdpvr: fix two audio bugs

Hans de Goede (1):
      [media] gspca_pac7302: Add new usb-id for Genius i-Look 317

Rickard Strandqvist (1):
      [media] media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong value used in aspect ratio

 drivers/media/dvb-frontends/si2168.c          | 16 +----------
 drivers/media/dvb-frontends/si2168_priv.h     |  2 +-
 drivers/media/dvb-frontends/tda10071.c        | 12 +++++---
 drivers/media/dvb-frontends/tda10071_priv.h   |  1 +
 drivers/media/pci/saa7134/saa7134-empress.c   |  2 +-
 drivers/media/platform/davinci/vpif_capture.c |  1 +
 drivers/media/platform/davinci/vpif_display.c |  1 +
 drivers/media/tuners/si2157.c                 |  2 +-
 drivers/media/usb/dvb-usb-v2/af9035.c         | 40 ++++++++++++++++++++++-----
 drivers/media/usb/gspca/pac7302.c             |  1 +
 drivers/media/usb/hdpvr/hdpvr-video.c         |  6 ++--
 drivers/media/v4l2-core/v4l2-dv-timings.c     |  4 +--
 drivers/staging/media/omap4iss/Kconfig        |  2 +-
 13 files changed, 55 insertions(+), 35 deletions(-)

