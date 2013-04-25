Return-path: <linux-media-owner@vger.kernel.org>
Received: from p3plsmtpa09-03.prod.phx3.secureserver.net ([173.201.193.232]:36761
	"EHLO p3plsmtpa09-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756801Ab3DYKAM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Apr 2013 06:00:12 -0400
From: Leonid Kegulskiy <leo@lumanate.com>
To: hverkuil@xs4all.nl
Cc: Leonid Kegulskiy <leo@lumanate.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 1/4] [media] hdpvr: Removed unnecessary get_video_info() call from hdpvr_device_init()
Date: Thu, 25 Apr 2013 02:59:54 -0700
Message-Id: <1366883997-18909-2-git-send-email-leo@lumanate.com>
In-Reply-To: <1366883997-18909-1-git-send-email-leo@lumanate.com>
References: <1366883997-18909-1-git-send-email-leo@lumanate.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Leonid Kegulskiy <leo@lumanate.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 8247c19..cb69405 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -220,7 +220,6 @@ static int hdpvr_device_init(struct hdpvr_device *dev)
 {
 	int ret;
 	u8 *buf;
-	struct hdpvr_video_info *vidinf;
 
 	if (device_authorization(dev))
 		return -EACCES;
@@ -242,13 +241,6 @@ static int hdpvr_device_init(struct hdpvr_device *dev)
 		 "control request returned %d\n", ret);
 	mutex_unlock(&dev->usbc_mutex);
 
-	vidinf = get_video_info(dev);
-	if (!vidinf)
-		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
-			"no valid video signal or device init failed\n");
-	else
-		kfree(vidinf);
-
 	/* enable fan and bling leds */
 	mutex_lock(&dev->usbc_mutex);
 	buf[0] = 0x1;
-- 
1.7.10.4

