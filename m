Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36468 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbcCENxN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Mar 2016 08:53:13 -0500
Date: Sat, 5 Mar 2016 10:53:06 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.5] media fixes
Message-ID: <20160305105306.216edf92@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-4

For:
  - some last time changes before we stablize the new entity function
    integer numbers at uAPI;
  - probe: fix erroneous return value on i2c/adp1653 driver.
  - fix tx 5v detect regression on adv7604 driver.
  - fix missing unlock on error in vpfe_prepare_pipeline() on davinci_vpfe
    driver.

Thanks!
Mauro

The following changes since commit ac75fe5d8fe4a0bf063be18fb29684405279e79e:

  [media] saa7134-alsa: Only frees registered sound cards (2016-02-04 16:26:10 -0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.5-4

for you to fetch changes up to fbe093ac9f0201939279cdfe8b0fce20ce5ef7a9:

  [media] media: Sanitise the reserved fields of the G_TOPOLOGY IOCTL arguments (2016-03-03 18:10:53 -0300)

----------------------------------------------------------------
media fixes for v4.5-rc7

----------------------------------------------------------------
Anton Protopopov (1):
      [media] media: i2c/adp1653: probe: fix erroneous return value

Hans Verkuil (3):
      [media] [for,v4.5] media.h: increase the spacing between function ranges
      [media] adv7604: fix tx 5v detect regression
      [media] media.h: use hex values for range offsets,  move connectors base up.

Mauro Carvalho Chehab (2):
      [media] media.h: get rid of MEDIA_ENT_F_CONN_TEST
      [media] media.h: postpone connectors entities

Sakari Ailus (1):
      [media] media: Sanitise the reserved fields of the G_TOPOLOGY IOCTL arguments

Wei Yongjun (1):
      [media] media: davinci_vpfe: fix missing unlock on error in vpfe_prepare_pipeline()

 Documentation/DocBook/media/v4l/media-types.xml |  4 --
 drivers/media/i2c/adp1653.c                     |  2 +-
 drivers/media/i2c/adv7604.c                     |  3 +-
 drivers/media/usb/au0828/au0828-video.c         |  3 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c |  2 +-
 include/uapi/linux/media.h                      | 54 ++++++++++++++-----------
 6 files changed, 34 insertions(+), 34 deletions(-)

