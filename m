Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:47169 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab2H3Rye (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 13:54:34 -0400
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCHv3 0/9] Fixes in response to review comments
Date: Thu, 30 Aug 2012 20:54:22 +0300
Message-Id: <1346349271-28073-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches fix most of the issues pointed out in the patch review
by Sean Young and Sakari Ailus.

The most noticeable change after these patch set is that the IR
transmission no longer times out even if the timers are not waking up
the MPU as it should be. Now that Jean Pihet kindly instructed me how
to use the PM QoS API for setting the latency constraints, the driver
will now work without any background load. Someone might consider such
restriction a blocker bug, that is fixed on this patch set.

Changes since v2:

- The 10us PM QoS latency requrement is documented in the code

- A missing quote mark is added into the Kconfig text

Changes since v1:

- Replace wake_up_interruptible with wake_up, as the driver is having
  non-interruptible sleeps

- Instead of just removing the set_max_mpu_wakeup_lat calls, replace
  them with QoS API calls

Timo Kokkonen (9):
  ir-rx51: Adjust dependencies
  ir-rx51: Handle signals properly
  ir-rx51: Trivial fixes
  ir-rx51: Clean up timer initialization code
  ir-rx51: Move platform data checking into probe function
  ir-rx51: Replace module_{init,exit} macros with
    module_platform_driver
  ir-rx51: Convert latency constraints to PM QoS API
  ir-rx51: Remove useless variable from struct lirc_rx51
  ir-rx51: Add missing quote mark in Kconfig text

 arch/arm/mach-omap2/board-rx51-peripherals.c |   2 -
 drivers/media/rc/Kconfig                     |   6 +-
 drivers/media/rc/ir-rx51.c                   | 102 ++++++++++++++-------------
 include/media/ir-rx51.h                      |   2 -
 4 files changed, 57 insertions(+), 55 deletions(-)

-- 
1.7.12

