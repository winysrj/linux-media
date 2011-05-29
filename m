Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60591 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1E2HG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 03:06:28 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-media@vger.kernel.org>
Cc: <laurent.pinchart@ideasonboard.com>, <linux-omap@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] media: omap3isp: fix format string warning
Date: Sun, 29 May 2011 10:04:51 +0300
Message-Id: <1306652691-21102-1-git-send-email-ohad@wizery.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Trivially fix this:

drivers/media/video/omap3isp/isp.c: In function 'isp_isr_dbg':
drivers/media/video/omap3isp/isp.c:394: warning: zero-length gnu_printf format string

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/media/video/omap3isp/isp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/isp.c b/drivers/media/video/omap3isp/isp.c
index 472a693..a0d5e69 100644
--- a/drivers/media/video/omap3isp/isp.c
+++ b/drivers/media/video/omap3isp/isp.c
@@ -391,7 +391,7 @@ static inline void isp_isr_dbg(struct isp_device *isp, u32 irqstatus)
 	};
 	int i;
 
-	dev_dbg(isp->dev, "");
+	dev_dbg(isp->dev, "%s\n", __func__);
 
 	for (i = 0; i < ARRAY_SIZE(name); i++) {
 		if ((1 << i) & irqstatus)
-- 
1.7.1

