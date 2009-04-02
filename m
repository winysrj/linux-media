Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44059 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752834AbZDBJ4X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 05:56:23 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1LpJeq-0001sL-IC
	for linux-media@vger.kernel.org; Thu, 02 Apr 2009 11:56:24 +0200
Date: Thu, 2 Apr 2009 11:56:24 +0200 (CEST)
From: Guennadi Liakhovetski <lg@denx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] mt9t031: use platform power hook
Message-ID: <Pine.LNX.4.64.0904021149580.5263@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use platform power hook to turn the camera on and off.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 23f9ce9..2b0927b 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -141,8 +141,19 @@ static int get_shutter(struct soc_camera_device *icd, u32 *data)
 
 static int mt9t031_init(struct soc_camera_device *icd)
 {
+	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
 	int ret;
 
+	if (icl->power) {
+		ret = icl->power(&mt9t031->client->dev, 1);
+		if (ret < 0) {
+			dev_err(icd->vdev->parent,
+				"Platform failed to power-on the camera.\n");
+			return ret;
+		}
+	}
+
 	/* Disable chip output, synchronous option update */
 	ret = reg_write(icd, MT9T031_RESET, 1);
 	if (ret >= 0)
@@ -150,13 +161,23 @@ static int mt9t031_init(struct soc_camera_device *icd)
 	if (ret >= 0)
 		ret = reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
 
+	if (ret < 0 && icl->power)
+		icl->power(&mt9t031->client->dev, 0);
+
 	return ret >= 0 ? 0 : -EIO;
 }
 
 static int mt9t031_release(struct soc_camera_device *icd)
 {
+	struct mt9t031 *mt9t031 = container_of(icd, struct mt9t031, icd);
+	struct soc_camera_link *icl = mt9t031->client->dev.platform_data;
+
 	/* Disable the chip */
 	reg_clear(icd, MT9T031_OUTPUT_CONTROL, 2);
+
+	if (icl->power)
+		icl->power(&mt9t031->client->dev, 0);
+
 	return 0;
 }
 
