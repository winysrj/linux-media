Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47810 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0CSGEV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Mar 2010 02:04:21 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id o2J64IlI010392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 19 Mar 2010 01:04:20 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: m-karicheri2@ti.com, Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH-V2 4/7] Davinci VPFE Capture:Return 0 from suspend/resume
Date: Fri, 19 Mar 2010 11:34:10 +0530
Message-Id: <1268978653-32710-5-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Now Suspend/Resume functionality is being handled by respective CCDC
code, so return true (0) from bridge suspend/resume function.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 2219460..3946a70 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
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

