Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:54094 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1ERQHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 12:07:08 -0400
From: Sanjeev Premi <premi@ti.com>
To: <linux-media@vger.kernel.org>
CC: Sanjeev Premi <premi@ti.com>, <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] omap3: isp: fix compiler warning
Date: Wed, 18 May 2011 21:36:51 +0530
Message-ID: <1305734811-2354-1-git-send-email-premi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch fixes this compiler warning:
  drivers/media/video/omap3isp/isp.c: In function 'isp_isr_dbg':
  drivers/media/video/omap3isp/isp.c:392:2: warning: zero-length
   gnu_printf format string

Since printk() is used in next few statements, same was used
here as well.

Signed-off-by: Sanjeev Premi <premi@ti.com>
Cc: laurent.pinchart@ideasonboard.com
---

 Actually full block can be converted to dev_dbg()
 as well; but i am not sure about original intent
 of the mix.

 Based on comments, i can resubmit with all prints
 converted to dev_dbg.



 drivers/media/video/omap3isp/isp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 503bd79..1d38d96 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -387,7 +387,7 @@ static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
 	};
 	int i;
 
-	dev_dbg(isp->dev, "");
+	printk(KERN_DEBUG "%s:\n", dev_driver_string(isp->dev));
 
 	for (i = 0; i < ARRAY_SIZE(name); i++) {
 		if ((1 << i) & irqstatus)
-- 
1.7.2.2

