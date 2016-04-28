Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48178 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbcD1ON5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Apr 2016 10:13:57 -0400
Date: Thu, 28 Apr 2016 11:13:51 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.6-rc6] media fixes
Message-ID: <20160428111351.4a48266c@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linux,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-4

For some regression fixes:
- videobuf2 core: avoid the risk of going past buffer on multi-planes
  and fix rw mode;
- fix support for 4K formats at V4L2 core;
- fix a trouble at davinci_fpe, caused by a bad patch;
- usbvision: revert a patch with a partial fixup. The fixup patch was
  merged already, and this one has some issues.

Thanks!
Mauro

- 

The following changes since commit 405ddbfa68177b6169d09bc2308a39196a8eb64a:

  [media] Revert "[media] media: au0828 change to use Managed Media Controller API" (2016-03-31 15:09:04 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-4

for you to fetch changes up to 89a095668304e8a02502ffd35edacffdbf49aa8c:

  [media] vb2-memops: Fix over allocation of frame vectors (2016-04-25 10:22:55 -0300)

----------------------------------------------------------------
media fixes for v4.6-rc6

----------------------------------------------------------------
Hans Verkuil (2):
      [media] davinci_vpfe: Revert "staging: media: davinci_vpfe: remove,unnecessary ret variable"
      [media] v4l2-dv-timings.h: fix polarity for 4k formats

Ricardo Ribalda Delgado (2):
      [media] media: vb2: Fix regression on poll() for RW mode
      [media] vb2-memops: Fix over allocation of frame vectors

Sakari Ailus (2):
      [media] videobuf2-core: Check user space planes array in dqbuf
      [media] videobuf2-v4l2: Verify planes array in buffer dequeueing

Vladis Dronov (1):
      [media] usbvision: revert commit 588afcc1

 drivers/media/usb/usbvision/usbvision-video.c   |  7 ----
 drivers/media/v4l2-core/videobuf2-core.c        | 20 ++++++---
 drivers/media/v4l2-core/videobuf2-memops.c      |  2 +-
 drivers/media/v4l2-core/videobuf2-v4l2.c        | 20 +++++----
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 54 ++++++++++++++++---------
 include/media/videobuf2-core.h                  |  8 ++++
 include/uapi/linux/v4l2-dv-timings.h            | 30 +++++++++-----
 7 files changed, 90 insertions(+), 51 deletions(-)

