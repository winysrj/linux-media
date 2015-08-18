Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58340 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbbHRUSi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 16:18:38 -0400
Date: Tue, 18 Aug 2015 17:18:33 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.2] media fixes
Message-ID: <20150818171833.1c989c17@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.2-2

For some fixes:
	- a regression fix at the videobuf2 core driver;
	- Fix error handling at mantis probing code;
	- Revert the IR encode patches, as the API is not mature enough.
	  So, better to postpone the changes to a latter Kernel;
	- Fix Kconfig breakages on some randconfig scenarios.

Thanks!
Mauro

-

The following changes since commit faebbd8f134f0c054f372982c8ddd1bbcc41b440:

  [media] lmedm04: fix the range for relative measurements (2015-06-24 08:38:30 -0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.2-2

for you to fetch changes up to ab3452a4da373944c3435ca33ec4604920a516f8:

  [media] mantis: Fix error handling in mantis_dma_init() (2015-08-11 10:28:10 -0300)

----------------------------------------------------------------
media fixes for v4.2-rc8

----------------------------------------------------------------
David Härdeman (7):
      [media] rc: nuvoton-cir: Add support for writing wakeup samples via sysfs filter callback"
      [media] rc: rc-loopback: Add loopback of filter scancodes"
      [media] rc: rc-core: Add support for encode_wakeup drivers"
      [media] rc: ir-rc6-decoder: Add encode capability"
      [media] rc: ir-rc5-decoder: Add encode capability"
      [media] rc: rc-ir-raw: Add Manchester encoder (phase encoder) helper"
      [media] rc: rc-ir-raw: Add scancode encoder callback"

Fabio Estevam (1):
      [media] mantis: Fix error handling in _dmantisma_init()

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

