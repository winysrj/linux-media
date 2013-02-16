Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36158 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab3BPQeh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 11:34:37 -0500
Received: by mail-ee0-f52.google.com with SMTP id b15so2159731eek.11
        for <linux-media@vger.kernel.org>; Sat, 16 Feb 2013 08:34:36 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 8/9] s5p-fimc: fix s5pv210 build
Date: Sat, 16 Feb 2013 17:34:27 +0100
Message-Id: <1361032467-9705-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Arnd Bergmann <arnd@arndb.de>

56bc911 "[media] s5p-fimc: Redefine platform data structure for fimc-is"
changed the bus_type member of struct fimc_source_info treewide, but
got one instance wrong in mach-s5pv210, which was evidently not
even build tested.

This adds the missing change to get s5pv210_defconfig to build again.
Applies on the Mauro's media tree.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
Resending to include this patch in the linuxtv.org patchwork.

 arch/arm/mach-s5pv210/mach-goni.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 423f6b6..868751d 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -846,7 +846,7 @@ static struct fimc_source_info goni_camera_sensors[] = {
 		.mux_id		= 0,
 		.flags		= V4L2_MBUS_PCLK_SAMPLE_FALLING |
 				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
-		.bus_type	= FIMC_BUS_TYPE_ITU_601,
+		.fimc_bus_type	= FIMC_BUS_TYPE_ITU_601,
 		.board_info	= &noon010pc30_board_info,
 		.i2c_bus_num	= 0,
 		.clk_frequency	= 16000000UL,
--
1.7.4.1

