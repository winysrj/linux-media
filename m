Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59959 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaHANzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:55:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: [PATCH 3/8] omap3isp: ccdc: Rename __ccdc_handle_stopping to ccdc_handle_stopping
Date: Fri,  1 Aug 2014 15:46:29 +0200
Message-Id: <1406900794-9871-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need for a double underscore in the function name, remove it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 56c3129..cd62d29 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1413,14 +1413,14 @@ static int ccdc_sbl_wait_idle(struct isp_ccdc_device *ccdc,
 	return -EBUSY;
 }
 
-/* __ccdc_handle_stopping - Handle CCDC and/or LSC stopping sequence
+/* ccdc_handle_stopping - Handle CCDC and/or LSC stopping sequence
  * @ccdc: Pointer to ISP CCDC device.
  * @event: Pointing which event trigger handler
  *
  * Return 1 when the event and stopping request combination is satisfied,
  * zero otherwise.
  */
-static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event)
+static int ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event)
 {
 	int rval = 0;
 
@@ -1502,7 +1502,7 @@ static void ccdc_lsc_isr(struct isp_ccdc_device *ccdc, u32 events)
 	if (ccdc->lsc.state == LSC_STATE_STOPPING)
 		ccdc->lsc.state = LSC_STATE_STOPPED;
 
-	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_LSC_DONE))
+	if (ccdc_handle_stopping(ccdc, CCDC_EVENT_LSC_DONE))
 		goto done;
 
 	if (ccdc->lsc.state != LSC_STATE_RECONFIG)
@@ -1642,7 +1642,7 @@ static void ccdc_vd0_isr(struct isp_ccdc_device *ccdc)
 		restart = ccdc_isr_buffer(ccdc);
 
 	spin_lock_irqsave(&ccdc->lock, flags);
-	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD0)) {
+	if (ccdc_handle_stopping(ccdc, CCDC_EVENT_VD0)) {
 		spin_unlock_irqrestore(&ccdc->lock, flags);
 		return;
 	}
@@ -1702,7 +1702,7 @@ static void ccdc_vd1_isr(struct isp_ccdc_device *ccdc)
 		break;
 	}
 
-	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD1))
+	if (ccdc_handle_stopping(ccdc, CCDC_EVENT_VD1))
 		goto done;
 
 	if (ccdc->lsc.request == NULL)
-- 
1.8.5.5

