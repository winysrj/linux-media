Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59134 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751341Ab1BZGFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 01:05:11 -0500
Subject: [UPDATED] [GIT FIXES for 2.6.38] Fix cx23885 and cx25840
 regressions, fix ivtv DMA error handling, and add new cx18 board profile.
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mark Zimmerman <markzimm@frii.com>,
	Sven Barth <pascaldragon@googlemail.com>, stoth@kernellabs.com,
	hverkuil@xs4all.nl, Michael <mike@rsy.com>,
	Pete <pete-ivtv@ziiz.us>
In-Reply-To: <1297647870.19186.69.camel@localhost>
References: <1297647870.19186.69.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Feb 2011 01:05:14 -0500
Message-ID: <1298700314.2709.38.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull the following fixes for 2.6.38.  This is a resend of my
original pull request with two additional patches.

Thanks go to Sven Barth for reporting the regression with the CX2583x
chips in cx25840 and providing a patch.

Thanks also go to Mark Zimmerman for climing the git learning curve and
devoting the time perform a git bisect to isolate the cx23885
regression.

Thanks go to Michael for perform some excellent reasoning and working up
a patch to correct a long standing problem with the way the ivtv driver
deals with certain DMA Errors.  Thanks also go to Pete for testing
Mike's patch.  (I have altered Michael's original patch slightly, to
clear status errors only when it should be safe to do so without hanging
the DMA engine.)

Thanks to Devin and Hauppauge for adding a new board profile for the
latest HVR-1600 designs having a different DTV tuner and demodulator.

I think that's everyone...

Regards,
Andy

The following changes since commit cf720fed25b8078ce0d6a10036dbf7a0baded679:

  [media] add support for Encore FM3 (2011-01-19 16:42:42 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git cx-fix-38

Andy Walls (2):
      cx23885: Revert "Check for slave nack on all transactions"
      cx23885: Remove unused 'err:' labels to quiet compiler warning

Devin Heitmueller (1):
      cx18: Add support for Hauppauge HVR-1600 models with s5h1411

Michael (1):
      ivtv: Fix corrective action taken upon DMA ERR interrupt to avoid hang

Sven Barth (1):
      cx25840: fix probing of cx2583x chips

 drivers/media/video/cx18/cx18-cards.c      |   50 +++++++++++++++++++++++-
 drivers/media/video/cx18/cx18-driver.c     |   25 +++++++++++-
 drivers/media/video/cx18/cx18-driver.h     |    3 +-
 drivers/media/video/cx18/cx18-dvb.c        |   38 ++++++++++++++++++
 drivers/media/video/cx23885/cx23885-i2c.c  |   10 -----
 drivers/media/video/cx25840/cx25840-core.c |    3 +-
 drivers/media/video/ivtv/ivtv-irq.c        |   58 ++++++++++++++++++++++++---
 7 files changed, 165 insertions(+), 22 deletions(-)



