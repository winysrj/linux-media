Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760571Ab0HLSOZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 14:14:25 -0400
Message-ID: <4C643A08.3000605@redhat.com>
Date: Thu, 12 Aug 2010 15:14:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
Subject: [GIT PULL for 2.6.36] V4L/DVB fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Linus,

Please pull from:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

For 3 build fixes.

Cheers,
Mauro.

The following changes since commit ad41a1e0cab07c5125456e8d38e5b1ab148d04aa:

  Merge branch 'io_remap_pfn_range' of git://www.jni.nu/cris (2010-08-12 10:17:19 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

Mauro Carvalho Chehab (2):
      V4L/DVB: Fix IR_CORE dependencies
      V4L/DVB: fix Kconfig to depends on VIDEO_IR

Randy Dunlap (1):
      V4L/DVB: v4l2-ctrls.c: needs to include slab.h

 drivers/media/IR/Kconfig            |    9 ++++++++-
 drivers/media/dvb/dm1105/Kconfig    |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig   |    2 +-
 drivers/media/dvb/siano/Kconfig     |    2 +-
 drivers/media/dvb/ttpci/Kconfig     |    2 +-
 drivers/media/video/bt8xx/Kconfig   |    2 +-
 drivers/media/video/cx18/Kconfig    |    2 +-
 drivers/media/video/cx231xx/Kconfig |    2 +-
 drivers/media/video/cx23885/Kconfig |    2 +-
 drivers/media/video/cx88/Kconfig    |    2 +-
 drivers/media/video/em28xx/Kconfig  |    2 +-
 drivers/media/video/ivtv/Kconfig    |    2 +-
 drivers/media/video/saa7134/Kconfig |    2 +-
 drivers/media/video/tlg2300/Kconfig |    2 +-
 drivers/media/video/v4l2-ctrls.c    |    1 +
 15 files changed, 22 insertions(+), 14 deletions(-)

