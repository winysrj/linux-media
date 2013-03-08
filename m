Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59302 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3CHOnM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:43:12 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 12/12] mipi-csis: Enable all interrupts for fimc-is usage
Date: Fri, 08 Mar 2013 09:59:25 -0500
Message-id: <1362754765-2651-13-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FIMC-IS firmware needs all the MIPI-CSIS interrupts to be enabled.
This patch enables all those MIPI interrupts.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-fimc/mipi-csis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index debda7c..11eef67 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -64,7 +64,7 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 
 /* Interrupt mask */
 #define S5PCSIS_INTMSK			0x10
-#define S5PCSIS_INTMSK_EN_ALL		0xf000103f
+#define S5PCSIS_INTMSK_EN_ALL		0xfc00103f
 #define S5PCSIS_INTMSK_EVEN_BEFORE	(1 << 31)
 #define S5PCSIS_INTMSK_EVEN_AFTER	(1 << 30)
 #define S5PCSIS_INTMSK_ODD_BEFORE	(1 << 29)
-- 
1.7.9.5

