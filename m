Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319AbaDCJcM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 05:32:12 -0400
Date: Thu, 3 Apr 2014 11:32:06 +0200
From: Jean Delvare <jdelvare@suse.de>
To: dmaengine@vger.kernel.org, linux-media@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] [media] platform: Fix timberdale dependencies
Message-ID: <20140403113206.0aab763f@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDEO_TIMBERDALE selects TIMB_DMA which itself depends on
MFD_TIMBERDALE, so VIDEO_TIMBERDALE should either select or depend on
MFD_TIMBERDALE as well. I chose to make it depend on it because I
think it makes more sense and it is consistent with what other options
are doing.

Adding a "|| HAS_IOMEM" to the TIMB_DMA dependencies silenced the
kconfig warning about unmet direct dependencies but it was wrong:
without MFD_TIMBERDALE, TIMB_DMA is useless as the driver has no
device to bind to.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/dma/Kconfig            |    2 +-
 drivers/media/platform/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-3.14.orig/drivers/dma/Kconfig	2014-04-03 09:21:03.566405827 +0200
+++ linux-3.14/drivers/dma/Kconfig	2014-04-03 09:28:32.618779030 +0200
@@ -197,7 +197,7 @@ config AMCC_PPC440SPE_ADMA
 
 config TIMB_DMA
 	tristate "Timberdale FPGA DMA support"
-	depends on MFD_TIMBERDALE || HAS_IOMEM
+	depends on MFD_TIMBERDALE
 	select DMA_ENGINE
 	help
 	  Enable support for the Timberdale FPGA DMA engine.
--- linux-3.14.orig/drivers/media/platform/Kconfig	2014-04-03 09:21:03.566405827 +0200
+++ linux-3.14/drivers/media/platform/Kconfig	2014-04-03 09:28:32.618779030 +0200
@@ -56,7 +56,7 @@ config VIDEO_VIU
 
 config VIDEO_TIMBERDALE
 	tristate "Support for timberdale Video In/LogiWIN"
-	depends on VIDEO_V4L2 && I2C && DMADEVICES
+	depends on MFD_TIMBERDALE && VIDEO_V4L2 && I2C && DMADEVICES
 	select DMA_ENGINE
 	select TIMB_DMA
 	select VIDEO_ADV7180


-- 
Jean Delvare
SUSE L3 Support
