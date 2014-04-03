Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52684 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaDCX2I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Apr 2014 19:28:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] omap4iss: Remove VIDEO_OMAP4_DEBUG Kconfig option
Date: Fri,  4 Apr 2014 01:30:07 +0200
Message-Id: <1396567807-32564-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The option was supposed to control the definition of the DEBUG macro in
the Makefile but has been left unused by mistake. Given that debugging
should be enabled using dynamic printk, remote the Kconfig option.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/Kconfig | 6 ------
 drivers/staging/media/omap4iss/iss.c   | 6 +++---
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/omap4iss/Kconfig b/drivers/staging/media/omap4iss/Kconfig
index b9fe753..78b0fba 100644
--- a/drivers/staging/media/omap4iss/Kconfig
+++ b/drivers/staging/media/omap4iss/Kconfig
@@ -4,9 +4,3 @@ config VIDEO_OMAP4
 	select VIDEOBUF2_DMA_CONTIG
 	---help---
 	  Driver for an OMAP 4 ISS controller.
-
-config VIDEO_OMAP4_DEBUG
-	bool "OMAP 4 Camera debug messages"
-	depends on VIDEO_OMAP4
-	---help---
-	  Enable debug messages on OMAP 4 ISS controller driver.
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index 61fbfcd..219519d 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -204,7 +204,7 @@ void omap4iss_configure_bridge(struct iss_device *iss,
 	iss_reg_write(iss, OMAP4_ISS_MEM_ISP_SYS1, ISP5_CTRL, isp5ctrl_val);
 }
 
-#if defined(DEBUG) && defined(ISS_ISR_DEBUG)
+#ifdef ISS_ISR_DEBUG
 static void iss_isr_dbg(struct iss_device *iss, u32 irqstatus)
 {
 	static const char * const name[] = {
@@ -347,14 +347,14 @@ static irqreturn_t iss_isr(int irq, void *_iss)
 			omap4iss_resizer_isr(&iss->resizer,
 					     isp_irqstatus & resizer_events);
 
-#if defined(DEBUG) && defined(ISS_ISR_DEBUG)
+#ifdef ISS_ISR_DEBUG
 		iss_isp_isr_dbg(iss, isp_irqstatus);
 #endif
 	}
 
 	omap4iss_flush(iss);
 
-#if defined(DEBUG) && defined(ISS_ISR_DEBUG)
+#ifdef ISS_ISR_DEBUG
 	iss_isr_dbg(iss, irqstatus);
 #endif
 
-- 
Regards,

Laurent Pinchart

