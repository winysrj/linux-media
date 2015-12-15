Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40580 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964903AbbLOLA7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 06:00:59 -0500
Date: Tue, 15 Dec 2015 14:00:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] media-device: copy_to/from_user() returns positive
Message-ID: <20151215110040.GA9594@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The copy_to/from_user() functions return the number of bytes *not*
copied.  They don't return error codes.

Fixes: 4f6b3f363475 ('media] media-device: add support for MEDIA_IOC_G_TOPOLOGY ioctl')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c12481c..96ed207 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -376,18 +376,17 @@ static long media_device_get_topology(struct media_device *mdev,
 	struct media_v2_topology ktopo;
 	int ret;
 
-	ret = copy_from_user(&ktopo, utopo, sizeof(ktopo));
-
-	if (ret < 0)
-		return ret;
+	if (copy_from_user(&ktopo, utopo, sizeof(ktopo)))
+		return -EFAULT;
 
 	ret = __media_device_get_topology(mdev, &ktopo);
 	if (ret < 0)
 		return ret;
 
-	ret = copy_to_user(utopo, &ktopo, sizeof(*utopo));
+	if (copy_to_user(utopo, &ktopo, sizeof(*utopo)))
+		return -EFAULT;
 
-	return ret;
+	return 0;
 }
 
 static long media_device_ioctl(struct file *filp, unsigned int cmd,
