Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46149 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdCYMC2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 08:02:28 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/8] Lirc staging cleanup
Date: Sat, 25 Mar 2017 12:02:18 +0000
Message-Id: <cover.1490443026.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series promotes lirc_sir out of staging and removes
lirc_sasem; this only leaves lirc_zilog in staging. I'm attempting to
write a new driver for this, maybe we should keep that until that
work completes.

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
 drivers/media/rc/sir_ir.c               | 451 ++++++++++++++++
 drivers/staging/media/lirc/Kconfig      |  12 -
 drivers/staging/media/lirc/Makefile     |   2 -
 drivers/staging/media/lirc/lirc_sasem.c | 899 --------------------------------
 drivers/staging/media/lirc/lirc_sir.c   | 839 -----------------------------
 7 files changed, 461 insertions(+), 1752 deletions(-)
 create mode 100644 drivers/media/rc/sir_ir.c
 delete mode 100644 drivers/staging/media/lirc/lirc_sasem.c
 delete mode 100644 drivers/staging/media/lirc/lirc_sir.c

-- 
2.9.3
