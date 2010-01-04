Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35444 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0ADODO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 09:03:14 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com,
	m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 5/9] DMx:Update board files for ti-media directory change
Date: Mon,  4 Jan 2010 19:32:58 +0530
Message-Id: <1262613782-20463-6-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>


Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 arch/arm/mach-davinci/include/mach/dm355.h  |    2 +-
 arch/arm/mach-davinci/include/mach/dm644x.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-davinci/include/mach/dm355.h b/arch/arm/mach-davinci/include/mach/dm355.h
index 85536d8..ffba662 100644
--- a/arch/arm/mach-davinci/include/mach/dm355.h
+++ b/arch/arm/mach-davinci/include/mach/dm355.h
@@ -13,7 +13,7 @@
 
 #include <mach/hardware.h>
 #include <mach/asp.h>
-#include <media/davinci/vpfe_capture.h>
+#include <media/ti-media/vpfe_capture.h>
 
 #define ASP1_TX_EVT_EN	1
 #define ASP1_RX_EVT_EN	2
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index 44e8f0f..95f1e65 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -25,7 +25,7 @@
 #include <mach/hardware.h>
 #include <mach/emac.h>
 #include <mach/asp.h>
-#include <media/davinci/vpfe_capture.h>
+#include <media/ti-media/vpfe_capture.h>
 
 #define DM644X_EMAC_BASE		(0x01C80000)
 #define DM644X_EMAC_CNTRL_OFFSET	(0x0000)
-- 
1.6.2.4

