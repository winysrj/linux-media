Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55733 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3LDRMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 12:12:21 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, jiada_wang@mentor.com,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v7 0/5] clk: clock deregistration support
Date: Wed, 04 Dec 2013 18:12:02 +0100
Message-id: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series implements clock deregistration in the common clock
framework. Detailed changes are listed at each patch. There is
included an additional patch for the omap3isp driver, required to avoid
regressions.

These patches were rebased on top of 3.13-rc1 and re-retested, are
also available in git repository:

git://linuxtv.org/snawrocki/samsung.git clk/clk-unregister

Changes since v6:
 - further fixes of NULL clock handling, minor error log changes.

Changes since v5:
 - fixed NULL clock handling in __clk_get(), __clk_put (patch 5/5).

Changes since v4:
 - removed stray struct module forward declaration in patch 3/5.

Changes since v3:
 - replaced WARN_ON() with WARN_ON_ONCE() in clk_nodrv_disable_unprepare()
   callback.

Changes since v2:
 - reordered the patches so the race condition is fixed before it can
   actually cause any issues,
 - fixed handling of NULL clock pointers in __clk_get(), __clk_put(),
 - added patch adding actual asignment of clk->owner; more details are
   discussed in that specific patch.

Changes since v1:
 - moved of_clk_{lock, unlock}, __of_clk_get_from_provider() function
   declaractions to a local header,
 - renamed clk_dummy_* to clk_nodrv_*.


Sylwester Nawrocki (5):
  omap3isp: Modify clocks registration to avoid circular references
  clk: Provide not locked variant of of_clk_get_from_provider()
  clkdev: Fix race condition in clock lookup from device tree
  clk: Add common __clk_get(), __clk_put() implementations
  clk: Implement clk_unregister

 arch/arm/include/asm/clkdev.h         |    2 +
 arch/blackfin/include/asm/clkdev.h    |    2 +
 arch/mips/include/asm/clkdev.h        |    2 +
 arch/sh/include/asm/clkdev.h          |    2 +
 drivers/clk/clk.c                     |  185 +++++++++++++++++++++++++++++++--
 drivers/clk/clk.h                     |   16 +++
 drivers/clk/clkdev.c                  |   12 ++-
 drivers/media/platform/omap3isp/isp.c |   22 ++--
 drivers/media/platform/omap3isp/isp.h |    1 +
 include/linux/clk-private.h           |    5 +
 include/linux/clkdev.h                |    5 +
 11 files changed, 235 insertions(+), 19 deletions(-)
 create mode 100644 drivers/clk/clk.h

--
1.7.9.5

