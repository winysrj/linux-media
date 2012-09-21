Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62325 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2IUFOY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 01:14:24 -0400
Received: by qcro28 with SMTP id o28so2325432qcr.19
        for <linux-media@vger.kernel.org>; Thu, 20 Sep 2012 22:14:24 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Tony Lindgren <tony@atomide.com>,
	Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Cc: Ido Yariv <ido@wizery.com>
Subject: [PATCH 1/3] [media] omap3isp: Fix compilation error in ispreg.h
Date: Fri, 21 Sep 2012 01:14:06 -0400
Message-Id: <1348204448-30855-1-git-send-email-ido@wizery.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit c49f34bc ("ARM: OMAP2+ Move SoC specific headers to be local to
mach-omap2") moved omap34xx.h to mach-omap2. This broke omap3isp, as it
includes omap34xx.h.

Instead of moving omap34xx to platform_data, simply add the two
definitions the driver needs and remove the include altogether.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/media/platform/omap3isp/ispreg.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
index 084ea77..e2c57f3 100644
--- a/drivers/media/platform/omap3isp/ispreg.h
+++ b/drivers/media/platform/omap3isp/ispreg.h
@@ -27,13 +27,13 @@
 #ifndef OMAP3_ISP_REG_H
 #define OMAP3_ISP_REG_H
 
-#include <plat/omap34xx.h>
-
-
 #define CM_CAM_MCLK_HZ			172800000	/* Hz */
 
 /* ISP Submodules offset */
 
+#define L4_34XX_BASE			0x48000000
+#define OMAP3430_ISP_BASE		(L4_34XX_BASE + 0xBC000)
+
 #define OMAP3ISP_REG_BASE		OMAP3430_ISP_BASE
 #define OMAP3ISP_REG(offset)		(OMAP3ISP_REG_BASE + (offset))
 
-- 
1.7.11.4

