Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37799 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0BWIel (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Feb 2010 03:34:41 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V1 07/10] Davinci VPFE Capture:Return 0 from suspend/resume
Date: Tue, 23 Feb 2010 14:04:30 +0530
Message-Id: <1266914073-30135-8-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Now Suspend/Resume functionality is being handled by respective CCDC
code, so return true (0) from bridge suspend/resume function.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/ti-media/vpfe_capture.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/ti-media/vpfe_capture.c b/drivers/media/video/ti-media/vpfe_capture.c
index 3ffd636..cece265 100644
--- a/drivers/media/video/ti-media/vpfe_capture.c
+++ b/drivers/media/video/ti-media/vpfe_capture.c
@@ -2022,18 +2022,14 @@ static int __devexit vpfe_remove(struct platform_device *pdev)
 	return 0;
 }

-static int
-vpfe_suspend(struct device *dev)
+static int vpfe_suspend(struct device *dev)
 {
-	/* add suspend code here later */
-	return -1;
+	return 0;
 }

-static int
-vpfe_resume(struct device *dev)
+static int vpfe_resume(struct device *dev)
 {
-	/* add resume code here later */
-	return -1;
+	return 0;
 }

 static const struct dev_pm_ops vpfe_dev_pm_ops = {
--
1.6.2.4

