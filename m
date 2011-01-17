Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:64829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab1AQT0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 14:26:32 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0HJQVpF026370
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 17 Jan 2011 14:26:31 -0500
Date: Mon, 17 Jan 2011 14:26:30 -0500
From: Jarod Wilson <jarod@redhat.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org
Subject: [GIT PULL REQUEST] IR fixes, round 2, for 2.6.38
Message-ID: <20110117192630.GB2412@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hey Mauro,

Please grab these additional IR fixes for 2.6.38. One was included in my
prior pull req, but doesn't seem to have made it into the tree, the other
three are new. The two hdpvr i2c patches heavily discussed this past week
are included here, as is a new patch that fixes some memory leaks in the
lirc drivers and fixes a regression w/tx support in lirc_serial.

The following changes since commit 5e3e7cceb14392123c7bb9638038d4a0574bb295:

  [media] v4l2-device: fix 'use-after-freed' oops (2011-01-17 13:30:48 -0200)

are available in the git repository at:
  git://linuxtv.org/jarod/linux-2.6-ir.git for-2.6.38

Jarod Wilson (4):
      rc/mceusb: timeout should be in ns, not us
      hdpvr: enable IR part
      hdpvr: reduce latency of i2c read/write w/recycled buffer
      staging/lirc: fix mem leaks and ptr err usage

 drivers/media/rc/mceusb.c               |    4 +-
 drivers/media/video/hdpvr/Makefile      |    4 +-
 drivers/media/video/hdpvr/hdpvr-core.c  |   10 +--
 drivers/media/video/hdpvr/hdpvr-i2c.c   |  144 +++++++++++++++----------------
 drivers/media/video/hdpvr/hdpvr-video.c |    7 +-
 drivers/media/video/hdpvr/hdpvr.h       |    5 +-
 drivers/staging/lirc/lirc_imon.c        |    1 +
 drivers/staging/lirc/lirc_it87.c        |    1 +
 drivers/staging/lirc/lirc_parallel.c    |   19 +++-
 drivers/staging/lirc/lirc_sasem.c       |    1 +
 drivers/staging/lirc/lirc_serial.c      |    3 +-
 drivers/staging/lirc/lirc_sir.c         |    1 +
 12 files changed, 101 insertions(+), 99 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

