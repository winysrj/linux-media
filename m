Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:43822 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683AbaLKHh3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Dec 2014 02:37:29 -0500
From: Josh Wu <josh.wu@atmel.com>
To: <linux-media@vger.kernel.org>, <g.liakhovetski@gmx.de>
CC: <m.chehab@samsung.com>, <linux-arm-kernel@lists.infradead.org>,
	<laurent.pinchart@ideasonboard.com>, <s.nawrocki@samsung.com>,
	<festevam@gmail.com>, Josh Wu <josh.wu@atmel.com>
Subject: [v3][PATCH 1/5] media: soc-camera: use icd->control instead of icd->pdev for reset()
Date: Thu, 11 Dec 2014 15:35:35 +0800
Message-ID: <1418283339-16281-2-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1418283339-16281-1-git-send-email-josh.wu@atmel.com>
References: <1418283339-16281-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

icd->control is the sub device dev, i.e. i2c device.
icd->pdev is the soc camera device's device.

To be consitent with power() function, we will call reset() with
icd->control as well.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
v2->v3:
  1. check whether icd->control is NULL or not.

 drivers/media/platform/soc_camera/soc_camera.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index f4be2a1..7e6b914 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -688,7 +688,8 @@ static int soc_camera_open(struct file *file)
 
 		/* The camera could have been already on, try to reset */
 		if (sdesc->subdev_desc.reset)
-			sdesc->subdev_desc.reset(icd->pdev);
+			if (icd->control)
+				sdesc->subdev_desc.reset(icd->control);
 
 		ret = soc_camera_add_device(icd);
 		if (ret < 0) {
@@ -1175,7 +1176,8 @@ static void scan_add_host(struct soc_camera_host *ici)
 
 			/* The camera could have been already on, try to reset */
 			if (ssdd->reset)
-				ssdd->reset(icd->pdev);
+				if (icd->control)
+					ssdd->reset(icd->control);
 
 			icd->parent = ici->v4l2_dev.dev;
 
@@ -1461,7 +1463,7 @@ static int soc_camera_async_bound(struct v4l2_async_notifier *notifier,
 				memcpy(&sdesc->subdev_desc, ssdd,
 				       sizeof(sdesc->subdev_desc));
 				if (ssdd->reset)
-					ssdd->reset(icd->pdev);
+					ssdd->reset(&client->dev);
 			}
 
 			icd->control = &client->dev;
-- 
1.9.1

