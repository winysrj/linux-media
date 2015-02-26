Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbbBZLSx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 06:18:53 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	=?UTF-8?q?Rafael=20Louren=C3=A7o=20de=20Lima=20Chehab?=
	<chehabrafael@gmail.com>
Subject: [PATCH 1/2] [media] dvb-usb: create one media_dev per adapter
Date: Thu, 26 Feb 2015 08:18:36 -0300
Message-Id: <b905ed9a7a9cb26282abd19a9865d8ed02ec3a9d.1424949510.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of assuming just one adapter, change the code to store
one media controller per adapter.

This works fine for dvb-usb, as, on all drivers here, it is not
possible to write a media graph that would mix resources between
the two different adapters.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
index d0b0f3071422..e9fcb000b305 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-dvb.c
@@ -94,11 +94,11 @@ static int dvb_usb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	return dvb_usb_ctrl_feed(dvbdmxfeed,0);
 }
 
-static void dvb_usb_media_device_register(struct dvb_usb_device *d)
+static void dvb_usb_media_device_register(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-
 	struct media_device *mdev;
+	struct dvb_usb_device *d = adap->dev;
 	struct usb_device *udev = d->udev;
 	int ret;
 
@@ -122,24 +122,20 @@ static void dvb_usb_media_device_register(struct dvb_usb_device *d)
 		kfree(mdev);
 		return;
 	}
-
-	d->media_dev = mdev;
+	adap->dvb_adap.mdev = mdev;
 
 	dev_info(&d->udev->dev, "media controller created\n");
-
 #endif
 }
 
-static void dvb_usb_media_device_unregister(struct dvb_usb_device *d)
+static void dvb_usb_media_device_unregister(struct dvb_usb_adapter *adap)
 {
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	if (!d->media_dev)
 		return;
 
-	media_device_unregister(d->media_dev);
-	kfree(d->media_dev);
-	d->media_dev = NULL;
-
+	media_device_unregister(adap->dvb_adap.mdev);
+	kfree(adap->dvb_adap.mdev);
+	adap->dvb_adap.mdev = NULL;
 #endif
 }
 
@@ -157,8 +153,7 @@ int dvb_usb_adapter_dvb_init(struct dvb_usb_adapter *adap, short *adapter_nums)
 	adap->dvb_adap.priv = adap;
 
 #ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	dvb_usb_media_device_register(adap->dev);
-	adap->dvb_adap.mdev = adap->dev->media_dev;
+	dvb_usb_media_device_register(adap);
 #endif
 
 	if (adap->dev->props.read_mac_address) {
@@ -208,7 +203,7 @@ err_net_init:
 err_dmx_dev:
 	dvb_dmx_release(&adap->demux);
 err_dmx:
-	dvb_usb_media_device_unregister(adap->dev);
+	dvb_usb_media_device_unregister(adap);
 	dvb_unregister_adapter(&adap->dvb_adap);
 err:
 	return ret;
@@ -222,7 +217,7 @@ int dvb_usb_adapter_dvb_exit(struct dvb_usb_adapter *adap)
 		adap->demux.dmx.close(&adap->demux.dmx);
 		dvb_dmxdev_release(&adap->dmxdev);
 		dvb_dmx_release(&adap->demux);
-		dvb_usb_media_device_unregister(adap->dev);
+		dvb_usb_media_device_unregister(adap);
 		dvb_unregister_adapter(&adap->dvb_adap);
 		adap->state &= ~DVB_USB_ADAP_STATE_DVB;
 	}
@@ -324,7 +319,7 @@ int dvb_usb_adapter_frontend_init(struct dvb_usb_adapter *adap)
 		adap->num_frontends_initialized++;
 	}
 
-	dvb_create_media_graph(adap->dev->media_dev);
+	dvb_create_media_graph(adap->dvb_adap.mdev);
 
 	return 0;
 }
diff --git a/drivers/media/usb/dvb-usb/dvb-usb.h b/drivers/media/usb/dvb-usb/dvb-usb.h
index 8d37f1e5ff23..ce4c4e3b58bb 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb.h
+++ b/drivers/media/usb/dvb-usb/dvb-usb.h
@@ -453,10 +453,6 @@ struct dvb_usb_device {
 	struct module *owner;
 
 	void *priv;
-
-#ifdef CONFIG_MEDIA_CONTROLLER_DVB
-	struct media_device *media_dev;
-#endif
 };
 
 extern int dvb_usb_device_init(struct usb_interface *,
-- 
2.1.0

