Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55083 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986AbZJPK1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 06:27:44 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n9GAR5Md028538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 16 Oct 2009 05:27:07 -0500
From: hvaibhav@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: [Resubmition PATCH] Davinci VPFE Capture: Take i2c adapter id through platform data
Date: Fri, 16 Oct 2009 15:57:01 +0530
Message-Id: <1255688821-6655-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <hvaibhav@ti.com>
References: <hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vaibhav Hiremath <hvaibhav@ti.com>

The I2C adapter ID is actually depends on Board and may vary, Davinci
uses id=1, but in case of AM3517 id=3.

Changes:
	- Fixed review comments (Typo) from Sergei

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
index e8272d1..fc83d98 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -94,6 +94,8 @@ struct vpfe_subdev_info {
 struct vpfe_config {
 	/* Number of sub devices connected to vpfe */
 	int num_subdevs;
+	/* I2C Bus adapter no */
+	int i2c_adapter_id;
 	/* information about each subdev */
 	struct vpfe_subdev_info *sub_devs;
 	/* evm card info */
--
1.6.2.4

