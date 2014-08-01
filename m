Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59958 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaHANzx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:55:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: [PATCH 7/8] omap3isp: ccdc: Don't timeout on stream off when the CCDC is stopped
Date: Fri,  1 Aug 2014 15:46:33 +0200
Message-Id: <1406900794-9871-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When the CCDC is already stopped due to a buffer underrun, the stop
state machine won't advance in BT.656 mode as no interrupt are generated
by the stopped CCDC in that mode. Handle this case explicitly in the
ccdc_disable() function.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 4 ++++
 drivers/media/platform/omap3isp/ispccdc.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index ff2ea2b..ec0a0e8 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1320,6 +1320,8 @@ static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
 
 	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PCR,
 			ISPCCDC_PCR_EN, enable ? ISPCCDC_PCR_EN : 0);
+
+	ccdc->running = enable;
 }
 
 static int ccdc_disable(struct isp_ccdc_device *ccdc)
@@ -1330,6 +1332,8 @@ static int ccdc_disable(struct isp_ccdc_device *ccdc)
 	spin_lock_irqsave(&ccdc->lock, flags);
 	if (ccdc->state == ISP_PIPELINE_STREAM_CONTINUOUS)
 		ccdc->stopping = CCDC_STOP_REQUEST;
+	if (!ccdc->running)
+		ccdc->stopping = CCDC_STOP_FINISHED;
 	spin_unlock_irqrestore(&ccdc->lock, flags);
 
 	ret = wait_event_timeout(ccdc->wait,
diff --git a/drivers/media/platform/omap3isp/ispccdc.h b/drivers/media/platform/omap3isp/ispccdc.h
index 731ecc7..3440a70 100644
--- a/drivers/media/platform/omap3isp/ispccdc.h
+++ b/drivers/media/platform/omap3isp/ispccdc.h
@@ -124,6 +124,7 @@ struct ispccdc_lsc {
  * @lock: Serializes shadow_update with interrupt handler
  * @wait: Wait queue used to stop the module
  * @stopping: Stopping state
+ * @running: Is the CCDC hardware running
  * @ioctl_lock: Serializes ioctl calls and LSC requests freeing
  */
 struct isp_ccdc_device {
@@ -155,6 +156,7 @@ struct isp_ccdc_device {
 	spinlock_t lock;
 	wait_queue_head_t wait;
 	unsigned int stopping;
+	bool running;
 	struct mutex ioctl_lock;
 };
 
-- 
1.8.5.5

