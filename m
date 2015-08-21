Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59120 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbbHUQyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 12:54:25 -0400
Date: Fri, 21 Aug 2015 13:54:18 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.2] media fixes
Message-ID: <20150821135418.30abd183@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.2-3

For some fixes:
	- a regression fix at the videobuf2 core driver;
	- Fix error handling at mantis probing code;
	- Revert the IR encode patches, as the API is not mature enough.
	  So, better to postpone the changes to a latter Kernel;
	- Fix Kconfig breakages on some randconfig scenarios.

Thanks!
Mauro

PS.: Sorry for the mess on my previous pull request. Yeah, the script
I was using to get patches from patchwork was broken and were mangling
the subject when importing e-mails with git Revert subjects.

-

The following changes since commit faebbd8f134f0c054f372982c8ddd1bbcc41b440:

  [media] lmedm04: fix the range for relative measurements (2015-06-24 08:38:30 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.2-3

for you to fetch changes up to 02387b5f25bdba668c7fe2618697bae24f973667:

  [media] mantis: Fix error handling in mantis_dma_init() (2015-08-19 07:04:55 -0300)

----------------------------------------------------------------
media fixes for v4.2-rc8

----------------------------------------------------------------
David Härdeman (7):
      Revert "[media] rc: nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback"
      Revert "[media] rc: rc-loopback: Add loopback of filter scancodes"
      Revert "[media] rc: rc-core: Add support for encode_wakeup drivers"
      Revert "[media] rc: ir-rc6-decoder: Add encode capability"
      Revert "[media] rc: ir-rc5-decoder: Add encode capability"
      Revert "[media] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper"
      Revert "[media] rc: rc-ir-raw: Add scancode encoder callback"

Fabio Estevam (1):
      [media] mantis: Fix error handling in mantis_dma_init()

Laurent Pinchart (1):
      [media] vb2: Fix compilation breakage when !CONFIG_BUG

Randy Dunlap (2):
      [media] media/dvb: fix ts2020.c Kconfig and build
      [media] media/pci/cobalt: fix Kconfig and build when SND is not enabled

Sakari Ailus (1):
      [media] vb2: Only requeue buffers immediately once streaming is started

 drivers/media/dvb-frontends/Kconfig      |   2 +-
 drivers/media/pci/cobalt/Kconfig         |   1 +
 drivers/media/pci/cobalt/cobalt-irq.c    |   2 +-
 drivers/media/pci/mantis/mantis_dma.c    |   5 +-
 drivers/media/rc/ir-rc5-decoder.c        | 116 -
 drivers/media/rc/ir-rc6-decoder.c        | 122 -
 drivers/media/rc/nuvoton-cir.c           | 127 -
 drivers/media/rc/nuvoton-cir.h           |   1 -
 drivers/media/rc/rc-core-priv.h          |  36 -
 drivers/media/rc/rc-ir-raw.c             | 139 --
 drivers/media/rc/rc-loopback.c           |  36 -
 drivers/media/rc/rc-main.c               |   7 +-
 drivers/media/v4l2-core/videobuf2-core.c |  40 +-
 include/media/rc-core.h                  |   7 -
 include/media/videobuf2-core.h           |   2 +
 15 files changed, 34 insertions(+), 609 deletions(-)

