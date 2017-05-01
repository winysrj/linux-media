Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41228 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758162AbdEAQDj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:03:39 -0400
Subject: [PATCH 00/16] lirc_dev spring cleaning
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:03:35 +0200
Message-ID: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc_dev has lots of functionality which is unused and the code isn't exactly
up-to-date with current kernel practices. This patchset removes the unused bits
and also simplifies the locking by moving lirc_dev over to only use
per-device mutexes rather than a big lirc lock in addition to per-device locks.

I think this is about as much as can be done right now before lirc_zilog is
either removed or ported to rc-core.

---

David Härdeman (16):
      lirc_dev: remove pointless functions
      lirc_dev: remove unused set_use_inc/set_use_dec
      lirc_dev: correct error handling
      lirc_dev: remove sampling kthread
      lirc_dev: clarify error handling
      lirc_dev: make fops mandatory
      lirc_dev: merge lirc_register_driver() and lirc_allocate_driver()
      lirc_zilog: remove module parameter minor
      lirc_dev: remove lirc_irctl_init() and lirc_cdev_add()
      lirc_dev: remove superfluous get/put_device() calls
      lirc_dev: remove unused module parameter
      lirc_dev: return POLLHUP and POLLERR when device is gone
      lirc_dev: use an ida instead of a hand-rolled array to keep track of minors
      lirc_dev: cleanup includes
      lirc_dev: remove name from struct lirc_driver
      lirc_dev: cleanup header


 drivers/media/rc/ir-lirc-codec.c        |   23 -
 drivers/media/rc/lirc_dev.c             |  516 ++++++++-----------------------
 drivers/staging/media/lirc/lirc_zilog.c |   33 --
 include/media/lirc_dev.h                |   53 ---
 4 files changed, 149 insertions(+), 476 deletions(-)

--
David Härdeman
