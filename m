Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37701 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1KFUdT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Nov 2011 15:33:19 -0500
Received: by faao14 with SMTP id o14so4499124faa.19
        for <linux-media@vger.kernel.org>; Sun, 06 Nov 2011 12:33:18 -0800 (PST)
From: Sylwester Nawrocki <snjw23@gmail.com>
To: linux-media@vger.kernel.org
Cc: Piotr Chmura <chmooreck@poczta.onet.pl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Subject: [PATCH 06/13] staging: as102: Fix the dvb device registration error path
Date: Sun,  6 Nov 2011 21:31:43 +0100
Message-Id: <1320611510-3326-7-git-send-email-snjw23@gmail.com>
In-Reply-To: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
References: <1320611510-3326-1-git-send-email-snjw23@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Release already acquired resources when error happens during
devices registration steps.
Use dev_err()  where struct device is available, instead of driver
specific err().

Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Sylwester Nawrocki <snjw23@gmail.com>
---
 drivers/staging/media/as102/as102_drv.c |   48 ++++++++++++++++---------------
 1 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index 85f58b9..e775900 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -195,19 +195,16 @@ static int as102_dvb_dmx_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 int as102_dvb_register(struct as102_dev_t *as102_dev)
 {
-	int ret = 0;
-	ENTER();
+	struct device *dev = &as102_dev->bus_adap.usb_dev->dev;
+	int ret;
 
 	ret = dvb_register_adapter(&as102_dev->dvb_adap,
-				   as102_dev->name,
-				   THIS_MODULE,
-				   &as102_dev->bus_adap.usb_dev->dev,
-				   adapter_nr
-				   );
+			   as102_dev->name, THIS_MODULE,
+			   dev, adapter_nr);
 	if (ret < 0) {
-		err("%s: dvb_register_adapter() failed (errno = %d)",
-		    __func__, ret);
-		goto failed;
+		dev_err(dev, "%s: dvb_register_adapter() failed: %d\n",
+			__func__, ret);
+		return ret;
 	}
 
 	as102_dev->dvb_dmx.priv = as102_dev;
@@ -225,22 +222,22 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 
 	ret = dvb_dmx_init(&as102_dev->dvb_dmx);
 	if (ret < 0) {
-		err("%s: dvb_dmx_init() failed (errno = %d)", __func__, ret);
-		goto failed;
+		dev_err("%s: dvb_dmx_init() failed: %d\n", __func__, ret);
+		goto edmxinit;
 	}
 
 	ret = dvb_dmxdev_init(&as102_dev->dvb_dmxdev, &as102_dev->dvb_adap);
 	if (ret < 0) {
-		err("%s: dvb_dmxdev_init() failed (errno = %d)", __func__,
-		    ret);
-		goto failed;
+		dev_err(dev, "%s: dvb_dmxdev_init() failed: %d\n",
+			__func__, ret);
+		goto edmxdinit;
 	}
 
 	ret = as102_dvb_register_fe(as102_dev, &as102_dev->dvb_fe);
 	if (ret < 0) {
-		err("%s: as102_dvb_register_frontend() failed (errno = %d)",
+		dev_err(dev, "%s: as102_dvb_register_frontend() failed: %d",
 		    __func__, ret);
-		goto failed;
+		goto efereg;
 	}
 
 	/* init bus mutex for token locking */
@@ -256,16 +253,21 @@ int as102_dvb_register(struct as102_dev_t *as102_dev)
 	if (fw_upload)
 		try_then_request_module(as102_fw_upload(&as102_dev->bus_adap),
 				"firmware_class");
-failed:
-	LEAVE();
-	/* FIXME: free dvb_XXX */
+
+	pr_info("Registered device %s", as102_dev->name);
+	return 0;
+
+efereg:
+	dvb_dmxdev_release(&as102_dev->dvb_dmxdev);
+edmxdinit:
+	dvb_dmx_release(&as102_dev->dvb_dmx);
+edmxinit:
+	dvb_unregister_adapter(&as102_dev->dvb_adap);
 	return ret;
 }
 
 void as102_dvb_unregister(struct as102_dev_t *as102_dev)
 {
-	ENTER();
-
 	/* unregister as102 frontend */
 	as102_dvb_unregister_fe(&as102_dev->dvb_fe);
 
@@ -276,7 +278,7 @@ void as102_dvb_unregister(struct as102_dev_t *as102_dev)
 	/* unregister dvb adapter */
 	dvb_unregister_adapter(&as102_dev->dvb_adap);
 
-	LEAVE();
+	pr_info("Unregistered device %s", as102_dev->name);
 }
 
 static int __init as102_driver_init(void)
-- 
1.7.5.4

