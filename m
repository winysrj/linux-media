Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZD2WUH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 18:20:07 -0400
Date: Wed, 29 Apr 2009 19:17:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.30] V4L/DVB fixes
Message-ID: <20090429191710.0855c64d@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For two Kbuild fixes:
   - kBuild: move media after i2c to be sure that i2c will initialize 
     before v4l, when both i2c and v4l are compiled with 'Y';
   - cx231xx: Kconfig fixes;

And few driver fixes:
   - au0828: fix kernel oops regression on USB disconnect;
   - cx18: Send correct input routing value to external audio multiplexers;
   - cx18: Fix the handling of i2c bus registration error;
   - cx23885: Two fixes for DViCO FusionHDTV DVB-T Dual Express;
   - saa5249.c: fix use-after-free and leak;
   - saa5246a.c: fix use-after-free;
   - s2255drv: fix race condition on set mode;
   - mx3_camera: Fix compilation with CONFIG_PM.

Cheers,
Mauro.

---

 drivers/Makefile                            |    4 +-
 drivers/media/video/au0828/au0828-core.c    |    6 ++-
 drivers/media/video/cx18/cx18-audio.c       |    2 +-
 drivers/media/video/cx18/cx18-i2c.c         |   16 ++++++++--
 drivers/media/video/cx231xx/Kconfig         |   44 +++++++++++++-------------
 drivers/media/video/cx23885/cx23885-cards.c |    4 +-
 drivers/media/video/cx23885/cx23885-dvb.c   |    1 +
 drivers/media/video/mx3_camera.c            |    4 --
 drivers/media/video/s2255drv.c              |    2 +-
 drivers/media/video/saa5246a.c              |    3 +-
 drivers/media/video/saa5249.c               |    4 +-
 11 files changed, 49 insertions(+), 41 deletions(-)

Andy Walls (1):
      V4L/DVB (11494): cx18: Send correct input routing value to external audio multiplexers

Christopher Pascoe (1):
      V4L/DVB (11626): cx23885: Two fixes for DViCO FusionHDTV DVB-T Dual Express

Dan Carpenter (2):
      V4L/DVB (11515): drivers/media/video/saa5249.c: fix use-after-free and leak
      V4L/DVB (11516): drivers/media/video/saa5246a.c: fix use-after-free

Dean Anderson (1):
      V4L/DVB (11570): patch: s2255drv: fix race condition on set mode

Devin Heitmueller (1):
      V4L/DVB (11652): au0828: fix kernel oops regression on USB disconnect.

Guennadi Liakhovetski (1):
      V4L/DVB (11561a): move media after i2c

Jean Delvare (1):
      V4L/DVB (11568): cx18: Fix the handling of i2c bus registration error

Mauro Carvalho Chehab (1):
      V4L/DVB (11494a): cx231xx Kconfig fixes

Sascha Hauer (1):
      V4L/DVB (11612): mx3_camera: Fix compilation with CONFIG_PM

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
