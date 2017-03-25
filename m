Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40045 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdCYVbt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 17:31:49 -0400
Date: Sat, 25 Mar 2017 21:31:46 +0000
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [GIT PULL for v4.12] Staging lirc cleanup
Message-ID: <20170325213146.GA28237@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

This pull promotes lirc_sir out of staging and removes lirc_sasem; this 
only leaves lirc_zilog in staging. I'm attempting to write a new driver for this, 
maybe we should keep lirc_zilog until that work completes.

Thanks
Sean


The following changes since commit c3d4fb0fb41f4b5eafeee51173c14e50be12f839:

  [media] rc: sunxi-cir: simplify optional reset handling (2017-03-24 08:30:03 -0300)

are available in the git repository at:

  git://linuxtv.org/syoung/media_tree.git for-v4.12c

for you to fetch changes up to d682dd284ab3d005f110742d1d4f288b87cc7d53:

  [media] staging: lirc_sasem: remove (2017-03-25 14:33:02 +0000)

----------------------------------------------------------------
Sean Young (8):
      [media] staging: sir: fill in missing fields and fix probe
      [media] staging: sir: remove unselectable Tekram and Actisys
      [media] staging: sir: fix checkpatch strict warnings
      [media] staging: sir: use usleep_range() rather than busy looping
      [media] staging: sir: remove unnecessary messages
      [media] staging: sir: make sure we are ready to receive interrupts
      [media] rc: promote lirc_sir out of staging
      [media] staging: lirc_sasem: remove

 drivers/media/rc/Kconfig                |   9 +
 drivers/media/rc/Makefile               |   1 +
 drivers/media/rc/sir_ir.c               | 438 ++++++++++++++++
 drivers/staging/media/lirc/Kconfig      |  12 -
 drivers/staging/media/lirc/Makefile     |   2 -
 drivers/staging/media/lirc/lirc_sasem.c | 899 --------------------------------
 drivers/staging/media/lirc/lirc_sir.c   | 839 -----------------------------
 7 files changed, 448 insertions(+), 1752 deletions(-)
 create mode 100644 drivers/media/rc/sir_ir.c
 delete mode 100644 drivers/staging/media/lirc/lirc_sasem.c
 delete mode 100644 drivers/staging/media/lirc/lirc_sir.c
