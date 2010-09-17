Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39091 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172Ab0IQBPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 21:15:42 -0400
Subject: [GIT PATCHES FOR 2.6.36] Two small fixes for Conexant TV chip
 drivers
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, stable@kernel.org,
	security@kernel.org, linux-kernel@vger.kernel.org,
	"Igor M. Liplianin" <liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 21:14:54 -0400
Message-ID: <1284686094.2056.41.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

Please pull the following two small changes for 2.6.36 and later
kernels.  Thanks go to Igor M. Liplianin for reporting the cx25840 bug
and Dan Rosenberg for fixing the possible information leak in the ivtvfb
driver.

The following changes since commit 67ac062a5138ed446a821051fddd798a01478f85:

  V4L/DVB: Fix regression for BeholdTV Columbus (2010-08-24 10:39:32 -0300)

are available in the git repository at:
  ssh://linuxtv.org/git/awalls/media_tree.git cx-fixes-36

Andy Walls (1):
      cx25840: Fix typo in volume control initialization: 65335 vs. 65535

Dan Rosenberg (1):
      ivtvfb: prevent reading uninitialized stack memory

 drivers/media/video/cx25840/cx25840-core.c |    2 +-
 drivers/media/video/ivtv/ivtvfb.c          |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

Regards,
Andy

