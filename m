Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:21775 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325Ab1BNBoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Feb 2011 20:44:32 -0500
Subject: [GIT FIXES for 2.6.38] Fix cx23885 and cx25840 regressions
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mark Zimmerman <markzimm@frii.com>,
	Sven Barth <pascaldragon@googlemail.com>, stoth@kernellabs.com,
	hverkuil@xs4all.nl
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Feb 2011 20:44:30 -0500
Message-ID: <1297647870.19186.69.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull the following regression fixes (and related compiler squawk
fix) for 2.6.38.

Thanks go to Sven Barth for reporting the regression with the CX2583x
chips in cx25840 and providing a patch.

Thanks also go to Mark Zimmerman for climinb the git learning curve and
devoting the time perform a git bisect to isolate the cx23885
regression.

Regards,
Andy


The following changes since commit cf720fed25b8078ce0d6a10036dbf7a0baded679:

  [media] add support for Encore FM3 (2011-01-19 16:42:42 -0200)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git cx-fix-38

Andy Walls (2):
      cx23885: Revert "Check for slave nack on all transactions"
      cx23885: Remove unused 'err:' labels to quiet compiler warning

Sven Barth (1):
      cx25840: fix probing of cx2583x chips

 drivers/media/video/cx23885/cx23885-i2c.c  |   10 ----------
 drivers/media/video/cx25840/cx25840-core.c |    3 ++-
 2 files changed, 2 insertions(+), 11 deletions(-)


