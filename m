Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:44673 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0CIUIU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Mar 2010 15:08:20 -0500
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id o29K8Jgp006298
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 9 Mar 2010 14:08:19 -0600
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH - FIX] V4L: vpfe_capture - free ccdc_lock when memory allocation fails
Date: Tue,  9 Mar 2010 15:08:18 -0500
Message-Id: <1268165298-31094-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Murali Karicheri <m-karicheri2@ti.com>

This patch fixes a bug in vpfe_probe() that doesn't call mutex_unlock() if memory
allocation for ccdc_cfg fails. See also the smatch warning report from Dan
Carpenter that shows this as an issue.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 885cd54..91f665b 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1829,7 +1829,7 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	if (NULL == ccdc_cfg) {
 		v4l2_err(pdev->dev.driver,
 			 "Memory allocation failed for ccdc_cfg\n");
-		goto probe_free_dev_mem;
+		goto probe_free_lock;
 	}
 
 	strncpy(ccdc_cfg->name, vpfe_cfg->ccdc, 32);
@@ -1981,8 +1981,9 @@ probe_out_video_release:
 probe_out_release_irq:
 	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
 probe_free_ccdc_cfg_mem:
-	mutex_unlock(&ccdc_lock);
 	kfree(ccdc_cfg);
+probe_free_lock:
+	mutex_unlock(&ccdc_lock);
 probe_free_dev_mem:
 	kfree(vpfe_dev);
 	return ret;
-- 
1.6.0.4

