Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:42816 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab2KRPNN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Nov 2012 10:13:13 -0500
From: Timo Kokkonen <timo.t.kokkonen@iki.fi>
To: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/7] ir-rx51: Various fixes
Date: Sun, 18 Nov 2012 17:13:02 +0200
Message-Id: <1353251589-26143-1-git-send-email-timo.t.kokkonen@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is a set of fixes that did not make in the last merge
window. Everything else except the last patch that fixes sparse
complaints have been posted before.

Especially the PM QoS conversion patch is important, without that one
the driver does not work at all unless there is some background load
keeping the CPU from sleeping.

The signal handling fixup patches did raise all sorts of discussion
last time, but my conclusion was that the patch itself should be fine
for now.

Please provide feedback and consider accepting them in. Thank you.


Timo Kokkonen (7):
  ir-rx51: Handle signals properly
  ir-rx51: Clean up timer initialization code
  ir-rx51: Move platform data checking into probe function
  ir-rx51: Replace module_{init,exit} macros with
    module_platform_driver
  ir-rx51: Convert latency constraints to PM QoS API
  ir-rx51: Remove useless variable from struct lirc_rx51
  ir-rx51: Fix sparse warnings

 arch/arm/mach-omap2/board-rx51-peripherals.c |   2 -
 drivers/media/rc/ir-rx51.c                   | 108 ++++++++++++++-------------
 include/media/ir-rx51.h                      |   2 -
 3 files changed, 56 insertions(+), 56 deletions(-)

-- 
1.8.0

