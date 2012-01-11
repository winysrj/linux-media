Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:41465 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933981Ab2AKV1R (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 16:27:17 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH 12/23] omap3: add definition for CONTROL_CAMERA_PHY_CTRL
Date: Wed, 11 Jan 2012 23:26:49 +0200
Message-Id: <1326317220-15339-12-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F0DFE92.80102@iki.fi>
References: <4F0DFE92.80102@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This register is available only in OMAP3630.

The original patch was submitted by Vimarsh Zutshi.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 arch/arm/mach-omap2/control.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index d4ef75d..6a26a0d 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -183,6 +183,7 @@
 #define OMAP3630_CONTROL_FUSE_OPP120_VDD1       (OMAP2_CONTROL_GENERAL + 0x0120)
 #define OMAP3630_CONTROL_FUSE_OPP50_VDD2        (OMAP2_CONTROL_GENERAL + 0x0128)
 #define OMAP3630_CONTROL_FUSE_OPP100_VDD2       (OMAP2_CONTROL_GENERAL + 0x012C)
+#define OMAP3630_CONTROL_CAMERA_PHY_CTRL	(OMAP2_CONTROL_GENERAL + 0x02f0)
 
 /* OMAP44xx control efuse offsets */
 #define OMAP44XX_CONTROL_FUSE_IVA_OPP50		0x22C
-- 
1.7.2.5

