Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:57838 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbcEMLcc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 07:32:32 -0400
Date: Fri, 13 May 2016 08:32:24 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [GIT PULL for v4.6] media fix
Message-ID: <20160513083224.1c2935c6@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-6

For a revert patch fixing a breakage that caused an OOPS on all VB2-based
DVB drivers.

We have already a proper fix, but it sounds safer to keep it being tested
for a while and not hush, to avoid the risk of another regression,
specially since this is meant to be c/c to stable. So, for now, let's just
revert the broken patch.

Thanks,
Mauro

-


The following changes since commit b34ecd5aa34800aefa9e2990a805243ec9348437:

  [media] media-device: fix builds when USB or PCI is compiled as module (2016-05-05 08:01:34 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-6

for you to fetch changes up to 93f0750dcdaed083d6209b01e952e98ca730db66:

  Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing" (2016-05-11 17:38:47 -0300)

----------------------------------------------------------------
media fixes for v4.6-rc8

----------------------------------------------------------------
Mauro Carvalho Chehab (1):
      Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"

 drivers/media/v4l2-core/videobuf2-v4l2.c | 6 ------
 1 file changed, 6 deletions(-)

