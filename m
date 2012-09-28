Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:46670 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757622Ab2I1NuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 09:50:24 -0400
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH 1/4] [media] mmp: add register definition for marvell ccic
Date: Fri, 28 Sep 2012 21:47:11 +0800
Message-Id: <1348840031-21357-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch adds the definition of CCIC1/2 Clock Reset register address

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 arch/arm/mach-mmp/include/mach/regs-apmu.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-mmp/include/mach/regs-apmu.h b/arch/arm/mach-mmp/include/mach/regs-apmu.h
index 7af8deb..f2cf231 100755
--- a/arch/arm/mach-mmp/include/mach/regs-apmu.h
+++ b/arch/arm/mach-mmp/include/mach/regs-apmu.h
@@ -16,7 +16,8 @@
 /* Clock Reset Control */
 #define APMU_IRE	APMU_REG(0x048)
 #define APMU_LCD	APMU_REG(0x04c)
-#define APMU_CCIC	APMU_REG(0x050)
+#define APMU_CCIC_RST	APMU_REG(0x050)
+#define APMU_CCIC2_RST	APMU_REG(0x0f4)
 #define APMU_SDH0	APMU_REG(0x054)
 #define APMU_SDH1	APMU_REG(0x058)
 #define APMU_USB	APMU_REG(0x05c)
-- 
1.7.0.4

