Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:49735 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab2HVTun (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 15:50:43 -0400
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/8] ir-rx51: Fixes in response to review comments
Date: Wed, 22 Aug 2012 22:50:33 +0300
Message-Id: <1345665041-15211-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches fix most of the issues pointed out in the patch review
by Sean Young and Sakari Ailus. The most noticeable change after these
patch set is that the IR transmission no longer times out even if the
timers are not waking up the MPU as it should be. However, the
transmission itself is still as badly mangled as before, unless there
is some background load preventing the MPU from going into
sleep. Otherwise the patches are mostly clean ups and rather trivial
stuff.

All comments are welcome. Thanks!

Timo Kokkonen (8):
  ir-rx51: Adjust dependencies
  ir-rx51: Handle signals properly
  ir-rx51: Trivial fixes
  ir-rx51: Clean up timer initialization code
  ir-rx51: Move platform data checking into probe function
  ir-rx51: Replace module_{init,exit} macros with
    module_platform_driver
  ir-rx51: Remove MPU wakeup latency adjustments
  ir-rx51: Remove useless variable from struct lirc_rx51

 arch/arm/mach-omap2/board-rx51-peripherals.c |  2 -
 drivers/media/rc/Kconfig                     |  4 +-
 drivers/media/rc/ir-rx51.c                   | 92 +++++++++++++---------------
 include/media/ir-rx51.h                      |  2 -
 4 files changed, 43 insertions(+), 57 deletions(-)

-- 
1.7.12

