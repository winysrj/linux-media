Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61527 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751684AbeCZVK4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:10:56 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Georgiana Chelu <georgiana.chelu93@gmail.com>,
        Geliang Tang <geliangtang@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH 09/18] media: staging: atomisp: get rid of an unused function
Date: Mon, 26 Mar 2018 17:10:42 -0400
Message-Id: <bdeb1cc21d2cb06cf98383c73fdc2e8946d503de.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The function __need_realloc_mipi_buffer() is not used anywhere.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../atomisp/pci/atomisp2/atomisp_compat_css20.c     | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index bbed1ed02074..b0e584b3cfc7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -1159,27 +1159,6 @@ void atomisp_css_mmu_invalidate_tlb(void)
 	ia_css_mmu_invalidate_cache();
 }
 
-/*
- * Check whether currently running MIPI buffer size fulfill
- * the requirement of the stream to be run
- */
-bool __need_realloc_mipi_buffer(struct atomisp_device *isp)
-{
-	unsigned int i;
-
-	for (i = 0; i < isp->num_of_streams; i++) {
-		struct atomisp_sub_device *asd = &isp->asd[i];
-
-		if (asd->streaming !=
-				ATOMISP_DEVICE_STREAMING_ENABLED)
-			continue;
-		if (asd->mipi_frame_size < isp->mipi_frame_size)
-			return true;
-	}
-
-	return false;
-}
-
 int atomisp_css_start(struct atomisp_sub_device *asd,
 			enum atomisp_css_pipe_id pipe_id, bool in_reset)
 {
-- 
2.14.3
