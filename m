Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50439 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab3KEDVP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Nov 2013 22:21:15 -0500
Message-ID: <1383621668.10562.5.camel@younglee-desktop>
Subject: [PATCH] media: marvell-ccic: drop resource free in driver remove
From: lbyang <lbyang@marvell.com>
Reply-To: lbyang@marvell.com
To: <corbet@lwn.net>
CC: <linux-media@vger.kernel.org>
Date: Tue, 5 Nov 2013 11:21:08 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>
Date: Tue, 5 Nov 2013 10:18:15 +0800
Subject: [PATCH] marvell-ccic: drop resource free in driver remove

The mmp-driver is using devm_* to allocate the resource. The old
resource release methods are not appropriate here.

Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mmp-driver.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 3458fa0..70cb57f 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -478,18 +478,11 @@ out_deinit_clk:
 static int mmpcam_remove(struct mmp_camera *cam)
 {
 	struct mcam_camera *mcam = &cam->mcam;
-	struct mmp_camera_platform_data *pdata;
 
 	mmpcam_remove_device(cam);
 	mccic_shutdown(mcam);
 	mmpcam_power_down(mcam);
-	pdata = cam->pdev->dev.platform_data;
-	gpio_free(pdata->sensor_reset_gpio);
-	gpio_free(pdata->sensor_power_gpio);
 	mcam_deinit_clk(mcam);
-	iounmap(cam->power_regs);
-	iounmap(mcam->regs);
-	kfree(cam);
 	return 0;
 }
 
-- 
1.7.9.5





