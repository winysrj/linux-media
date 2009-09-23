Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbZIWBDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 21:03:45 -0400
Date: Tue, 22 Sep 2009 22:03:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [GIT PATCHES for 2.6.32] V4L/DVB fixes
Message-ID: <20090922220310.233e1854@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Linus,

Please pull from:
        ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git for_linus

For 4 build fix patches:

   - saa7134: fix build;
   - dvbdev: Remove an annoying/uneeded warning that happens when 
     DVB_CORE is disabled but some V4L drivers are enabled;
   - dib0700: not building CONFIG_DVB_TUNER_DIB0070 breaks compilation;
   - staging/go7007: Revert compatibility code added at the wrong place 
     preventing compilation.

Cheers,
Mauro.

---

 drivers/media/dvb/dvb-core/dvbdev.h        |    5 ++---
 drivers/media/dvb/dvb-usb/Kconfig          |    2 +-
 drivers/media/video/saa7164/saa7164-api.c  |    8 ++++----
 drivers/media/video/saa7164/saa7164-cmd.c  |    2 +-
 drivers/media/video/saa7164/saa7164-core.c |    6 +++---
 drivers/media/video/saa7164/saa7164.h      |    4 ++--
 drivers/staging/go7007/Makefile            |    5 -----
 7 files changed, 13 insertions(+), 19 deletions(-)

Ingo Molnar (1):
      media: video: Fix build in saa7164

Mauro Carvalho Chehab (3):
      V4L/DVB (13037): go7007: Revert compatibility code added at the wrong place
      V4L/DVB (13038): dvbdev: Remove an anoying/uneeded warning
      V4L/DVB (13039): dib0700: not building CONFIG_DVB_TUNER_DIB0070 breaks compilation

---------------------------------------------------
V4L/DVB development is hosted at http://linuxtv.org
