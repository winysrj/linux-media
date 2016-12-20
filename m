Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:48611 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752104AbcLTRub (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Dec 2016 12:50:31 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Lirc staging drivers
Date: Tue, 20 Dec 2016 17:50:23 +0000
Message-Id: <cover.1482255894.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series tries to make some headway with dealing with the
lirc staging drivers. Over the last couple of years, I have ported
lirc_serial, lirc_ttusbir and lirc_igorplugusb. I have not been able
to track down the hardware for the remaining drivers.

Note that the remaining lirc staging drivers were merged in 2010, and
other than trival patches, they have not made any progress towards
mainline.

ir-rx51 is not a staging driver, but it should not rely on the lirc
in-kernel API like the staging drivers do.


Sean Young (5):
  [media] ir-rx51: port to rc-core
  [media] staging: lirc_sir: port to rc-core
  [media] staging: lirc_parallel: remove
  [media] staging: lirc_bt829: remove
  [media] staging: lirc_imon: port remaining usb ids to imon and remove

 arch/arm/mach-omap2/pdata-quirks.c          |   8 +-
 drivers/media/rc/Kconfig                    |   2 +-
 drivers/media/rc/imon.c                     | 133 +++-
 drivers/media/rc/ir-rx51.c                  | 332 ++++------
 drivers/staging/media/lirc/Kconfig          |  22 +-
 drivers/staging/media/lirc/Makefile         |   3 -
 drivers/staging/media/lirc/lirc_bt829.c     | 401 ------------
 drivers/staging/media/lirc/lirc_imon.c      | 979 ----------------------------
 drivers/staging/media/lirc/lirc_parallel.c  | 741 ---------------------
 drivers/staging/media/lirc/lirc_parallel.h  |  26 -
 drivers/staging/media/lirc/lirc_sir.c       | 296 ++-------
 include/linux/platform_data/media/ir-rx51.h |   6 +-
 12 files changed, 322 insertions(+), 2627 deletions(-)
 delete mode 100644 drivers/staging/media/lirc/lirc_bt829.c
 delete mode 100644 drivers/staging/media/lirc/lirc_imon.c
 delete mode 100644 drivers/staging/media/lirc/lirc_parallel.c
 delete mode 100644 drivers/staging/media/lirc/lirc_parallel.h

-- 
2.9.3

