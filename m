Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:32826 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220AbaH0Mgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 08:36:36 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAY000AKTTU7Y10@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 27 Aug 2014 13:39:30 +0100 (BST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH] media: s5p-mfc: rename special clock to sclk_mfc
Date: Wed, 27 Aug 2014 14:36:28 +0200
Message-id: <1409142988-9315-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit d19f405a5a8d2ed942b40f8cf7929a5a50d0cc59 ("[media] s5p-mfc: Fix
selective sclk_mfc init") added support for special clock handling
(named "sclk-mfc"). However this clock is not defined yet on any
platform, so before adding it to all Exynos platform, better rename it
to "sclk_mfc" to match the scheme used for all other special clocks on
Exynos platform.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index b6a8be97a96c..826c48945bf5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -21,7 +21,7 @@
 #include "s5p_mfc_pm.h"
 
 #define MFC_GATE_CLK_NAME	"mfc"
-#define MFC_SCLK_NAME		"sclk-mfc"
+#define MFC_SCLK_NAME		"sclk_mfc"
 #define MFC_SCLK_RATE		(200 * 1000000)
 
 #define CLK_DEBUG
-- 
1.9.2

