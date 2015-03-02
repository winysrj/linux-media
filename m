Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38313 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbbCBObq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 09:31:46 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Antti Palosaari <crope@iki.fi>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH] [media] use a function for DVB media controller register
Date: Mon,  2 Mar 2015 11:31:40 -0300
Message-Id: <89a2c1d60aa2cfcf4c9f194b4c923d72182be431.1425306670.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is really a simple function, but using it avoids to have
if's inside the drivers.

Also, the kABI becomes a little more clearer.

This shouldn't generate any overhead, and the type check
will happen when compiling with MC DVB enabled.

So, let's do it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/common/siano/smsdvb-main.c b/drivers/media/common/siano/smsdvb-main.c
index c739725ca7ee..367b8e77feb8 100644
--- a/drivers/media/common/siano/smsdvb-main.c
+++ b/drivers/media/common/siano/smsdvb-main.c
@@ -1104,9 +1104,7 @@ static int smsdvb_hotplug(struct smscore_device_t *coredev,
 		pr_err("dvb_register_adapter() failed %d\n", rc);
 		goto adapter_error;
 	}
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	client->adapter.mdev = coredev->media_dev;
-#endif
+	dvb_register_media_controller(&client->adapter, coredev->media_dev);
 
 	/* init dvb demux */
 	client->demux.dmx.capabilities = DMX_TS_FILTERING;
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 556c9e9d1d4e..12629b8ecb0c 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -125,8 +125,15 @@ extern void dvb_unregister_device (struct dvb_device *dvbdev);
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
 void dvb_create_media_graph(struct dvb_adapter *adap);
+static inline void dvb_register_media_controller(struct dvb_adapter *adap,
+						 struct media_device *mdev)
+{
+	adap->mdev = mdev;
+}
+
 #else
 static inline void dvb_create_media_graph(struct dvb_adapter *adap) {}
+#define dvb_register_media_controller(a, b) {}
 #endif
 
 extern int dvb_generic_open (struct inode *inode, struct file *file);
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 8bf2baae387f..ff39bf22442d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -465,9 +465,7 @@ static int register_dvb(struct cx231xx_dvb *dvb,
 		       dev->name, result);
 		goto fail_adapter;
 	}
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	dvb->adapter.mdev = dev->media_dev;
-#endif
+	dvb_register_media_controller(&dvb->adapter, dev->media_dev);
 
 	/* Ensure all frontends negotiate bus access */
 	dvb->frontend->ops.ts_bus_ctrl = cx231xx_dvb_bus_ctrl;
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 8bd08ba4f869..f5df9eaba04f 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -429,7 +429,7 @@ static void dvb_usbv2_media_device_register(struct dvb_usb_adapter *adap)
 		return;
 	}
 
-	adap->dvb_adap.mdev = mdev;
+	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
 	dev_info(&d->udev->dev, "media controller created\n");
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index 980d976960d9..7b7b834777b7 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -122,7 +122,7 @@ static void dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
 		kfree(mdev);
 		return;
 	}
-	adap->dvb_adap.mdev = mdev;
+	dvb_register_media_controller(&adap->dvb_adap, mdev);
 
 	dev_info(&d->udev->dev, "media controller created\n");
 #endif
-- 
2.1.0

