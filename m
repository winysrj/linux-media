Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:45561 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759910AbZJMPJH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2009 11:09:07 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9DF8RrO018363
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 13 Oct 2009 10:08:30 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [PATCH 2/6] Davinci VPFE Capture: Take i2c adapter id through platform data
Date: Tue, 13 Oct 2009 20:38:23 +0530
Message-Id: <1255446503-16727-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

The I2C adapter ID is actually depends on Board and may vary, Davinci
uses id=1, but in case of AM3517 id=3.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/davinci/vpfe_capture.c |    3 +--
 include/media/davinci/vpfe_capture.h       |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index dc32de0..c3c37e7 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -2228,8 +2228,7 @@ static __init int vpfe_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, vpfe_dev);
 	/* set driver private data */
 	video_set_drvdata(vpfe_dev->video_dev, vpfe_dev);
-	i2c_adap = i2c_get_adapter(1);
-	vpfe_cfg = pdev->dev.platform_data;
+	i2c_adap = i2c_get_adapter(vpfe_cfg->i2c_adapter_id);
 	num_subdevs = vpfe_cfg->num_subdevs;
 	vpfe_dev->sd = kmalloc(sizeof(struct v4l2_subdev *) * num_subdevs,
 				GFP_KERNEL);
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index e8272d1..f610104 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -94,6 +94,8 @@ struct vpfe_subdev_info {
 struct vpfe_config {
 	/* Number of sub devices connected to vpfe */
 	int num_subdevs;
+	/*I2c Bus adapter no*/
+	int i2c_adapter_id;
 	/* information about each subdev */
 	struct vpfe_subdev_info *sub_devs;
 	/* evm card info */
-- 
1.6.2.4

