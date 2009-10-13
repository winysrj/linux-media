Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45965 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760183AbZJMPKD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 11:10:03 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9DF9OkF019702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 10:09:26 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 4/6] Davinci VPFE Capture:Replaced IRQ_VDINT1 with vpfe_dev->ccdc_irq1
Date: Tue, 13 Oct 2009 20:39:22 +0530
Message-Id: <1255446562-16809-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index c3c37e7..abe21e4 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -752,7 +752,7 @@ static void vpfe_detach_irq(struct vpfe_device *vpfe_dev)
 
 	frame_format = ccdc_dev->hw_ops.get_frame_format();
 	if (frame_format == CCDC_FRMFMT_PROGRESSIVE)
-		free_irq(IRQ_VDINT1, vpfe_dev);
+		free_irq(vpfe_dev->ccdc_irq1, vpfe_dev);
 }
 
 static int vpfe_attach_irq(struct vpfe_device *vpfe_dev)
-- 
1.6.2.4

