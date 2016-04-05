Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33334 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbcDEC02 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Apr 2016 22:26:28 -0400
Date: Mon, 4 Apr 2016 19:25:32 -0700
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [GIT PULL for v4.6-rc3] media fixes
Message-ID: <20160404192532.488f1d05@vela.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-3

For some bug fixes on au0828 and snd-usb-audio:
  - The au0828+snd-usb-audio MC patch broke several things and produced some
    race conditions. Better to revert the patches, and re-work on them for
    a next version;
  - Fix a regression at tuner disable links logic;
  - properly handle dev_state as a bitmask.

Thanks,
Mauro

The following changes since commit f55532a0c0b8bb6148f4e07853b876ef73bc69ca:

  Linux 4.6-rc1 (2016-03-26 16:03:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.6-3

for you to fetch changes up to 405ddbfa68177b6169d09bc2308a39196a8eb64a:

  [media] Revert "[media] media: au0828 change to use Managed Media Controller API" (2016-03-31 15:09:04 -0300)

----------------------------------------------------------------
media fixes for v4.6-rc2

----------------------------------------------------------------
Mauro Carvalho Chehab (5):
      [media] au0828: disable tuner links and cache tuner/decoder
      [media] v4l2-mc: cleanup a warning
      [media] au0828: Fix dev_state handling
      [media] Revert "[media] sound/usb: Use Media Controller API to share media resources"
      [media] Revert "[media] media: au0828 change to use Managed Media Controller API"

Shuah Khan (2):
      [media] media: au0828 fix to clear enable/disable/change source handlers
      [media] au0828: fix au0828_v4l2_close() dev_state race condition

 drivers/media/usb/au0828/au0828-cards.c |   4 -
 drivers/media/usb/au0828/au0828-core.c  |  52 ++++--
 drivers/media/usb/au0828/au0828-input.c |   4 +-
 drivers/media/usb/au0828/au0828-video.c |  63 ++++---
 drivers/media/usb/au0828/au0828.h       |   9 +-
 drivers/media/v4l2-core/v4l2-mc.c       |   2 +-
 sound/usb/Kconfig                       |   4 -
 sound/usb/Makefile                      |   2 -
 sound/usb/card.c                        |  14 --
 sound/usb/card.h                        |   3 -
 sound/usb/media.c                       | 318 --------------------------------
 sound/usb/media.h                       |  72 --------
 sound/usb/mixer.h                       |   3 -
 sound/usb/pcm.c                         |  28 +--
 sound/usb/quirks-table.h                |   1 -
 sound/usb/stream.c                      |   2 -
 sound/usb/usbaudio.h                    |   6 -
 17 files changed, 79 insertions(+), 508 deletions(-)
 delete mode 100644 sound/usb/media.c
 delete mode 100644 sound/usb/media.h

