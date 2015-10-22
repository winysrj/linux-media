Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46833 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbbJVSDZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2015 14:03:25 -0400
Date: Thu, 22 Oct 2015 16:03:19 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.3] media fixes
Message-ID: <20151022160319.014f3601@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v4.3-4

For some regression fixes and potential security issues:
	- netup_unidvb: fix potential crash when spi is NULL
	- rtl28xxu: fix control message flaws
	- m88ds3103: fix a regression on Kernel 4.2;
	- c8sectpfe: fix some issues on this new driver;
	- v4l2-flash-led-class: fix a Kbuild dependency;
	- si2157 and si2158: check for array boundary when uploading
	  firmware files;
	- horus3a and lnbh25: fix some building troubles when some options
	  aren't selected;
	- ir-hix5hd2: drop the use of IRQF_NO_SUSPEND

Thanks!
Mauro

-

PS.: Those patches are at linux next, but I had do do a rebase, as
there were other patches there on my fixes branch that were meant
to go only for 4.4. Normally, I would re-push and wait for it to be
merged on -next, but Steven won't be releasing a -next version until
Nov, 2.

The following changes since commit 6ff33f3902c3b1c5d0db6b1e2c70b6d76fba357f:

  Linux 4.3-rc1 (2015-09-12 16:35:56 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media media/v4.3-4

for you to fetch changes up to 56ea37da3b93dfe46cb5c3ee0ee4cc44229ece47:

  [media] m88ds3103: use own reg update_bits() implementation (2015-10-22 15:48:28 -0200)

----------------------------------------------------------------
media fixes for v4.3-rc7

----------------------------------------------------------------
Abylay Ospan (1):
      [media] netup_unidvb: fix potential crash when spi is NULL

Antti Palosaari (2):
      [media] rtl28xxu: fix control message flaws
      [media] m88ds3103: use own reg update_bits() implementation

Colin Ian King (1):
      [media] c8sectpfe: fix ininitialized error return on firmware load failure

Jacek Anaszewski (1):
      [media] v4l2-flash-led-class: Add missing VIDEO_V4L2 Kconfig dependency

Javier Martinez Canillas (2):
      [media] horus3a: Fix horus3a_attach() function parameters
      [media] lnbh25: Fix lnbh25_attach() function return type

Laura Abbott (2):
      [media] si2157: Bounds check firmware
      [media] si2168: Bounds check firmware

Sudeep Holla (1):
      [media] ir-hix5hd2: drop the use of IRQF_NO_SUSPEND

Sudip Mukherjee (1):
      [media] c8sectpfe: fix return of garbage

 drivers/media/dvb-frontends/horus3a.h                 |  4 +-
 drivers/media/dvb-frontends/lnbh25.h                  |  2 +-
 drivers/media/dvb-frontends/m88ds3103.c               | 73 +-
 drivers/media/dvb-frontends/si2168.c                  |  4 +
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c     | 12 +-
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c |  7 +-
 drivers/media/rc/ir-hix5hd2.c                         |  2 +-
 drivers/media/tuners/si2157.c                         |  4 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c               | 15 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.h               |  2 +-
 drivers/media/v4l2-core/Kconfig                       |  2 +-
 11 files changed, 81 insertions(+), 46 deletions(-)

