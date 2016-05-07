Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43294 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbcEGMXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 May 2016 08:23:23 -0400
Date: Sat, 7 May 2016 09:23:15 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.6] media fixes
Message-ID: <20160507092315.044558e4@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-5

For:
  - deadlock fixes on driver probe at exynos4-is and s43-camif drivers;
  - a build breakage if media controller is enabled and USB or PCI is
    built as module.

Thanks!
Mauro

---

PS.: the USB/PCI fix didn't reach linux-next yet, because I was able to
	merge it only on Friday. I'm confident that it does what it is
	meant to do, the reported of the bug is also happy, and we got
	no reports from kbuild robot with randconfigs, but feel free to
	postpone it to next week if you want to.

The following changes since commit 89a095668304e8a02502ffd35edacffdbf49aa8c:

  [media] vb2-memops: Fix over allocation of frame vectors (2016-04-25 10:22:55 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-5

for you to fetch changes up to b34ecd5aa34800aefa9e2990a805243ec9348437:

  [media] media-device: fix builds when USB or PCI is compiled as module (2016-05-05 08:01:34 -0300)

----------------------------------------------------------------
media fixes for v4.6-rc7

----------------------------------------------------------------
Marek Szyprowski (2):
      [media] media: exynos4-is: fix deadlock on driver probe
      [media] media: s3c-camif: fix deadlock on driver probe()

Mauro Carvalho Chehab (1):
      [media] media-device: fix builds when USB or PCI is compiled as module

 drivers/media/media-device.c                  |  8 ++++----
 drivers/media/platform/exynos4-is/media-dev.c | 13 ++-----------
 drivers/media/platform/s3c-camif/camif-core.c | 12 +++---------
 3 files changed, 9 insertions(+), 24 deletions(-)

