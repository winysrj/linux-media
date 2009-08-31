Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbZHaFdn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 01:33:43 -0400
Date: Mon, 31 Aug 2009 02:33:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.31] V4L/DVB fixes
Message-ID: <20090831023331.3dd6f6b9@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For the following fixes:

   - fixes detection of cameras with MT9M111 on em28xx;
   - fixes LNA and LED with Hauppauge devices on sms1xx;
   - fixes SDIO compilation on Siano;
   - zr364: fix wrong indexes;
   - em28xx: Don't call em28xx_ir_init when IR is disabled;
   - gspca - sn9c20x: Fix gscpa sn9c20x build errors;
   - usb_af9015: fix an Oops on hotplugging with 2.6.31-rc5-git3;
   - MAINTAINERS: Update gspca sn9c20x name style.

Cheers,
Mauro.

---

 MAINTAINERS                               |    3 +-
 drivers/media/dvb/dvb-usb/af9015.c        |    2 +-
 drivers/media/dvb/siano/Kconfig           |   40 +++++++++++++--------
 drivers/media/dvb/siano/Makefile          |    9 +++--
 drivers/media/dvb/siano/smsdvb.c          |   44 +++++++++++++++++++++++
 drivers/media/dvb/siano/smssdio.c         |   54 ++++++++++++++++-------------
 drivers/media/video/em28xx/em28xx-cards.c |   44 ++++++++++++++++++++++--
 drivers/media/video/em28xx/em28xx.h       |    1 +
 drivers/media/video/gspca/Kconfig         |    2 +-
 drivers/media/video/zr364xx.c             |    2 +-
 10 files changed, 149 insertions(+), 52 deletions(-)

Joe Perches (1):
      V4L/DVB (12564a): MAINTAINERS: Update gspca sn9c20x name style

Jose Alberto Reguero (1):
      V4L/DVB (12588): usb_af9015: Oops on hotplugging with 2.6.31-rc5-git3

Mauro Carvalho Chehab (1):
      V4L/DVB (12449): adds webcam for Micron device MT9M111 0x143A to em28xx

Michael Krufky (1):
      V4L/DVB (12446): sms1xxx: restore GPIO functionality for all Hauppauge devices

Randy Dunlap (1):
      V4L/DVB (12502): gspca - sn9c20x: Fix gscpa sn9c20x build errors.

Roel Kluin (1):
      V4L/DVB (12457): zr364: wrong indexes

Shine Liu (1):
      V4L/DVB (12495): em28xx: Don't call em28xx_ir_init when disable_ir is true

Udi Atar (2):
      V4L/DVB (12450): Siano: Fixed SDIO compilation bugs
      V4L/DVB (12451): Update KConfig File to enable SDIO and USB interfaces

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
