Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35450 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423Ab0ADODQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jan 2010 09:03:16 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: linux-omap@vger.kernel.org, hverkuil@xs4all.nl,
	davinci-linux-open-source@linux.davincidsp.com,
	m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 6/9] Davinci VPFE Capture:Return 0 from suspend/resume
Date: Mon,  4 Jan 2010 19:32:59 +0530
Message-Id: <1262613782-20463-7-git-send-email-hvaibhav@ti.com>
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
index 3257d26..7187eaa 100644
--- a/drivers/media/video/ti-media/vpfe_capture.c
+++ b/drivers/media/video/ti-media/vpfe_capture.c
@@ -2007,18 +2007,14 @@ static int vpfe_remove(struct platform_device *pdev)
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

