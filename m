Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52684 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3LXMcX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Dec 2013 07:32:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 3/3] omap3isp: ccdc: Don't hang when the SBL fails to become idle
Date: Tue, 24 Dec 2013 13:32:44 +0100
Message-Id: <1387888364-21631-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1387888364-21631-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Under abnormal conditions (such as glitches on the HSYNC/VSYNC signals)
the CCDC output SBL can fail to become idle. The driver currently logs
this condition to the kernel log and doesn't restart the CCDC. This
results in CCDC video capture hanging without any notification to
userspace.

Cancel the pipeline and mark the CCDC as crashed instead of hanging.
Userspace will be notified of the problem and will then be able to close
and reopen the device to trigger a reset of the ISP.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 561c991..5db2c88 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1516,6 +1516,8 @@ static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
 
 	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
 		dev_info(isp->dev, "CCDC won't become idle!\n");
+		isp->crashed |= 1U << ccdc->subdev.entity.id;
+		omap3isp_pipeline_cancel_stream(pipe);
 		goto done;
 	}
 
-- 
1.8.3.2

