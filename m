Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:30317 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab2BTB7S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Feb 2012 20:59:18 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: [PATCH v3 21/33] omap3: add definition for CONTROL_CAMERA_PHY_CTRL
Date: Mon, 20 Feb 2012 03:57:00 +0200
Message-Id: <1329703032-31314-21-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20120220015605.GI7784@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This register is available only in OMAP3630.

The original patch was submitted by Vimarsh Zutshi.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 arch/arm/mach-omap2/control.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index 0ba68d3..f3acf09 100644
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

